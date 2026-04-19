#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STALE_PATH_PATTERN="core/contract\\.md|core/checklists\\.md|core/report-template\\.md|templates/report\\.md|adapters/claude-code/skills/spec-prosecutor/SKILL\\.md|adapters/codex/spec-prosecutor\\.md|adapters/cursor/spec-prosecutor\\.mdc|docs/core/"

required_files=(
  "README.md"
  "install.sh"
  ".codex-plugin/plugin.json"
  ".claude-plugin/plugin.json"
  ".cursor-plugin/plugin.json"
  "Formula/spec-prosecutor.rb.template"
  "bin/spec-prosecutor"
  "hooks/hooks.json"
  "hooks/hooks-cursor.json"
  "hooks/run-hook.cmd"
  "hooks/user-prompt-gate"
  "skills/spec-prosecutor/SKILL.md"
  "skills/spec-prosecutor/agents/openai.yaml"
  "skills/spec-prosecutor/references/contract.md"
  "skills/spec-prosecutor/references/checklists.md"
  "skills/spec-prosecutor/references/modes.md"
  "skills/spec-prosecutor/references/report-template.md"
  "tests/README.md"
  "tests/cases/README.md"
  "docs/install/README.md"
  "docs/install/claude-code.md"
  "docs/install/codex-local.md"
  "docs/install/cursor.md"
  "docs/install/github-direct.md"
  "docs/install/homebrew.md"
  "docs/install/publish-checklist.md"
  "docs/install/marketplace.entry.json"
  "docs/platform-guides/claude-code.md"
  "docs/platform-guides/codex.md"
  "docs/platform-guides/cursor.mdc"
  "scripts/export-all.sh"
  "scripts/export-claude-code-skill.sh"
  "scripts/export-cursor-rule.sh"
  "scripts/export-plugin.sh"
  "scripts/package-release.sh"
  "scripts/print-install-instructions.sh"
  "scripts/run-regression-checks.sh"
  "scripts/render-homebrew-formula.sh"
  "scripts/set-github-repo.sh"
)

for path in "${required_files[@]}"; do
  if [[ ! -f "$ROOT_DIR/$path" ]]; then
    echo "Missing required file: $path" >&2
    exit 1
  fi
done

if command -v rg >/dev/null 2>&1; then
  stale_path_scan() {
    (cd "$ROOT_DIR" && rg -n "$STALE_PATH_PATTERN" . --glob '!dist/**' --glob '!scripts/validate-repo.sh')
  }
else
  stale_path_scan() {
    (cd "$ROOT_DIR" && grep -R -n -E "$STALE_PATH_PATTERN" . --exclude-dir=dist --exclude=scripts/validate-repo.sh)
  }
fi

if stale_path_scan >/dev/null 2>&1; then
  echo "Found stale path references that should have been migrated." >&2
  stale_path_scan || true
  exit 1
fi

for forbidden_dir in adapters core examples platforms templates docs/core; do
  if [[ -e "$ROOT_DIR/$forbidden_dir" ]]; then
    echo "Found non-normative residual path: $forbidden_dir" >&2
    exit 1
  fi
done

case_dirs=("$ROOT_DIR"/tests/cases/*)

if [[ ${#case_dirs[@]} -eq 0 ]]; then
  echo "No test cases found under tests/cases." >&2
  exit 1
fi

for case_dir in "${case_dirs[@]}"; do
  [[ -d "$case_dir" ]] || continue

  if [[ ! -f "$case_dir/prd.md" ]]; then
    echo "Missing PRD fixture: ${case_dir#$ROOT_DIR/}/prd.md" >&2
    exit 1
  fi

  if [[ ! -f "$case_dir/expected-report.md" ]]; then
    echo "Missing expected report: ${case_dir#$ROOT_DIR/}/expected-report.md" >&2
    exit 1
  fi
done

bash "$ROOT_DIR/scripts/run-regression-checks.sh" >/dev/null

echo "Repo validation passed."
