#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

search_fixed() {
  local pattern="$1"
  local path="$2"
  if command -v rg >/dev/null 2>&1; then
    rg -F -q "$pattern" "$path"
  else
    grep -F -q -- "$pattern" "$path"
  fi
}

required_report_headings=(
  "## Indictment Summary"
  "## Blockers"
  "## High Risk Items"
  "## Notices"
  "## Category Summary"
  "## Questions To Confirm Immediately"
)

required_field_labels=(
  "Source excerpt:"
  "Severity:"
  "Assessment:"
  "Problem:"
  "Implementation risk:"
)

required_categories=(
  "Ambiguity"
  "Vagueness"
  "Inaccurate Definition"
  "Missing Scenarios"
  "Unverifiable Requirement"
  "Missing Implementation Dependency"
)

assert_file() {
  local path="$1"
  [[ -f "$path" ]] || {
    echo "Missing expected file: ${path#$ROOT_DIR/}" >&2
    exit 1
  }
}

assert_contains() {
  local pattern="$1"
  local path="$2"
  if ! search_fixed "$pattern" "$path"; then
    echo "Expected pattern not found in ${path#$ROOT_DIR/}: $pattern" >&2
    exit 1
  fi
}

for case_dir in "$ROOT_DIR"/tests/cases/*; do
  [[ -d "$case_dir" ]] || continue

  prd_path="$case_dir/prd.md"
  report_path="$case_dir/expected-report.md"
  assert_file "$prd_path"
  assert_file "$report_path"

  for heading in "${required_report_headings[@]}"; do
    assert_contains "$heading" "$report_path"
  done

  for label in "${required_field_labels[@]}"; do
    assert_contains "$label" "$report_path"
  done

  for category in "${required_categories[@]}"; do
    assert_contains "$category" "$report_path"
  done
done

bash "$ROOT_DIR/scripts/export-all.sh" >/dev/null

assert_file "$ROOT_DIR/dist/codex/off/spec-prosecutor/README.md"
assert_file "$ROOT_DIR/dist/codex/on/spec-prosecutor/README.md"
assert_file "$ROOT_DIR/dist/codex-skill/off/spec-prosecutor/SKILL.md"
assert_file "$ROOT_DIR/dist/codex-skill/on/spec-prosecutor/SKILL.md"
assert_file "$ROOT_DIR/dist/claude-code/off/spec-prosecutor/SKILL.md"
assert_file "$ROOT_DIR/dist/claude-code/on/spec-prosecutor/SKILL.md"
assert_file "$ROOT_DIR/dist/cursor/off/spec-prosecutor.mdc"
assert_file "$ROOT_DIR/dist/cursor/on/spec-prosecutor.mdc"

assert_contains "Off mode is disabled and should not review PRDs." "$ROOT_DIR/dist/codex/off/spec-prosecutor/README.md"
assert_contains "Trigger phrase for auto mode: 启动sp" "$ROOT_DIR/dist/codex/on/spec-prosecutor/README.md"
assert_contains 'Spec Prosecutor is disabled in `off` mode.' "$ROOT_DIR/dist/codex-skill/off/spec-prosecutor/SKILL.md"
assert_contains "Use when the user includes the exact phrase \"启动sp\"" "$ROOT_DIR/dist/codex-skill/on/spec-prosecutor/SKILL.md"
assert_contains 'Spec Prosecutor is disabled in `off` mode.' "$ROOT_DIR/dist/claude-code/off/spec-prosecutor/SKILL.md"
assert_contains "Use when the user includes the exact phrase \"启动sp\"" "$ROOT_DIR/dist/claude-code/on/spec-prosecutor/SKILL.md"
assert_contains 'Spec Prosecutor is installed in `off` mode.' "$ROOT_DIR/dist/cursor/off/spec-prosecutor.mdc"
assert_contains 'Only activate when the prompt contains the exact phrase `启动sp`.' "$ROOT_DIR/dist/cursor/on/spec-prosecutor.mdc"
assert_contains 'CODEX_PLUGIN_ROOT' "$ROOT_DIR/dist/codex/on/spec-prosecutor/hooks/hooks.json"

assert_contains '"name": "len"' "$ROOT_DIR/.codex-plugin/plugin.json"
assert_contains '"developerName": "len"' "$ROOT_DIR/.codex-plugin/plugin.json"
assert_contains '"name": "len"' "$ROOT_DIR/.claude-plugin/plugin.json"
assert_contains '"name": "len"' "$ROOT_DIR/.cursor-plugin/plugin.json"

hook_with_trigger="$(printf '%s' '{"prompt":"启动sp，审查 /tmp/prd.md"}' | CODEX_PLUGIN_ROOT=/tmp/plugin bash "$ROOT_DIR/hooks/user-prompt-gate")"
if [[ "$hook_with_trigger" != *'$spec-prosecutor'* ]]; then
  echo "Expected trigger hook context to instruct Codex to invoke \$spec-prosecutor." >&2
  exit 1
fi

hook_without_trigger="$(printf '%s' '{"prompt":"spec-prosecutor 审查 /tmp/prd.md"}' | CODEX_PLUGIN_ROOT=/tmp/plugin bash "$ROOT_DIR/hooks/user-prompt-gate")"
if [[ "$hook_without_trigger" != *'"decision": "block"'* && "$hook_without_trigger" != *'"decision":"block"'* ]]; then
  echo "Expected non-trigger prompt mentioning spec-prosecutor to be blocked." >&2
  exit 1
fi

tmp_home="$(mktemp -d)"
HOME="$tmp_home" \
SP_SKIP_VALIDATE_REPO=1 \
bash "$ROOT_DIR/bin/spec-prosecutor" init --codex --mode on >/dev/null

assert_file "$tmp_home/.agents/skills/spec-prosecutor/SKILL.md"
if command -v rg >/dev/null 2>&1; then
  HOME="$tmp_home" codex debug prompt-input '启动sp' | rg -q 'spec-prosecutor:'
else
  HOME="$tmp_home" codex debug prompt-input '启动sp' | grep -q 'spec-prosecutor:'
fi

HOME="$tmp_home" \
PATH="$tmp_home/.local/bin:$PATH" \
bash "$ROOT_DIR/install.sh" --codex --mode on >/dev/null

if [[ ! -L "$tmp_home/.local/bin/spec-prosecutor" && ! -x "$tmp_home/.local/bin/spec-prosecutor" ]]; then
  echo "CLI binary was not installed by install.sh." >&2
  exit 1
fi

assert_file "$tmp_home/.agents/skills/spec-prosecutor/SKILL.md"

HOME="$tmp_home" \
SP_SKIP_VALIDATE_REPO=1 \
bash "$ROOT_DIR/bin/spec-prosecutor" uninstall --codex --cli >/dev/null

if [[ -e "$tmp_home/.agents/skills/spec-prosecutor" ]]; then
  echo "Codex skill directory was not removed during uninstall." >&2
  exit 1
fi

if [[ -e "$tmp_home/.local/bin/spec-prosecutor" || -e "$tmp_home/.local/share/spec-prosecutor/repo" ]]; then
  echo "CLI install was not removed during uninstall --cli." >&2
  exit 1
fi

echo "Regression checks passed."
