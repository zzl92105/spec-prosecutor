#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

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
  if ! rg -F -q "$pattern" "$path"; then
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
assert_file "$ROOT_DIR/dist/claude-code/off/spec-prosecutor/SKILL.md"
assert_file "$ROOT_DIR/dist/claude-code/on/spec-prosecutor/SKILL.md"
assert_file "$ROOT_DIR/dist/cursor/off/spec-prosecutor.mdc"
assert_file "$ROOT_DIR/dist/cursor/on/spec-prosecutor.mdc"

assert_contains "Off mode is disabled and should not review PRDs." "$ROOT_DIR/dist/codex/off/spec-prosecutor/README.md"
assert_contains "Trigger phrase for auto mode: 启动sp" "$ROOT_DIR/dist/codex/on/spec-prosecutor/README.md"
assert_contains 'Spec Prosecutor is disabled in `off` mode.' "$ROOT_DIR/dist/claude-code/off/spec-prosecutor/SKILL.md"
assert_contains "Use when the user includes the exact phrase \"启动sp\"" "$ROOT_DIR/dist/claude-code/on/spec-prosecutor/SKILL.md"
assert_contains 'Spec Prosecutor is installed in `off` mode.' "$ROOT_DIR/dist/cursor/off/spec-prosecutor.mdc"
assert_contains 'Only activate when the prompt contains the exact phrase `启动sp`.' "$ROOT_DIR/dist/cursor/on/spec-prosecutor.mdc"

assert_contains '"name": "len"' "$ROOT_DIR/.codex-plugin/plugin.json"
assert_contains '"developerName": "len"' "$ROOT_DIR/.codex-plugin/plugin.json"
assert_contains '"name": "len"' "$ROOT_DIR/.claude-plugin/plugin.json"
assert_contains '"name": "len"' "$ROOT_DIR/.cursor-plugin/plugin.json"

tmp_home="$(mktemp -d)"
custom_plugins_root="$(mktemp -d)"
custom_marketplace_dir="$(mktemp -d)"
custom_marketplace="$custom_marketplace_dir/marketplace.json"
custom_plugin_dir="$custom_plugins_root/spec-prosecutor"
custom_plugin_dir_resolved="$(python3 - <<'PY' "$custom_plugin_dir"
from pathlib import Path
import sys
print(Path(sys.argv[1]).expanduser().resolve())
PY
)"

HOME="$tmp_home" \
SP_SKIP_VALIDATE_REPO=1 \
CODEX_PLUGIN_DIR="$custom_plugin_dir" \
CODEX_MARKETPLACE_PATH="$custom_marketplace" \
bash "$ROOT_DIR/bin/spec-prosecutor" init --codex --mode on >/dev/null

assert_file "$custom_plugin_dir/.codex-plugin/plugin.json"
assert_file "$custom_plugin_dir/skills/spec-prosecutor/SKILL.md"
assert_file "$custom_marketplace"
assert_contains "\"path\": \"$custom_plugin_dir_resolved\"" "$custom_marketplace"

HOME="$tmp_home" \
SP_SKIP_VALIDATE_REPO=1 \
CODEX_PLUGIN_DIR="$custom_plugin_dir" \
CODEX_MARKETPLACE_PATH="$custom_marketplace" \
bash "$ROOT_DIR/bin/spec-prosecutor" uninstall --codex >/dev/null

if [[ -e "$custom_plugin_dir" ]]; then
  echo "Custom Codex plugin directory was not removed during uninstall." >&2
  exit 1
fi

echo "Regression checks passed."
