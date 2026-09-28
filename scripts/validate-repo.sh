#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[[ $# -eq 0 || ( $# -eq 1 && "$1" == "--static" ) ]] || { echo "Usage: $0 [--static]" >&2; exit 1; }
python3 - "$ROOT_DIR" <<'PYTHON'
import json
import re
import sys
from pathlib import Path
root = Path(sys.argv[1])
skill = root / "skills/spec-prosecutor"
text = (skill / "SKILL.md").read_text(encoding="utf-8")
assert text.startswith("---\n")
header = text.split("---", 2)[1]
assert re.search(r"^name: spec-prosecutor$", header, re.M)
assert re.search(r"^description: .+", header, re.M)
for link in re.findall(r"\]\((references/[^)]+)\)", text):
    assert (skill / link).is_file(), link
for relative in ["agents/openai.yaml", "references/contract.md", "references/checklists.md", "references/report-template.md", "references/modes.md"]:
    assert (skill / relative).is_file(), relative
for name in [".codex-plugin", ".claude-plugin"]:
    manifest = json.loads((root / name / "plugin.json").read_text())
    assert manifest["name"] == "spec-prosecutor"
    assert "hooks" not in manifest
for case in (root / "tests/cases").iterdir():
    if case.is_dir():
        assert (case / "prd.md").is_file(), case
        assert (case / "expected-report.md").is_file(), case
print("Static skill checks passed.")
PYTHON
if [[ "${1:-}" != "--static" ]]; then
  bash "$ROOT_DIR/scripts/run-regression-checks.sh"
fi
