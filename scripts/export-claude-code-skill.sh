#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:-off}"
DIST_DIR="$ROOT_DIR/dist/claude-code/$MODE/spec-prosecutor"

if [[ "$MODE" != "off" && "$MODE" != "on" ]]; then
  echo "Usage: $0 [off|on]" >&2
  exit 1
fi

rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

cp "$ROOT_DIR/skills/spec-prosecutor/SKILL.md" "$DIST_DIR/SKILL.md"
cp -R "$ROOT_DIR/skills/spec-prosecutor/references" "$DIST_DIR/references"

python3 - <<'PY' "$DIST_DIR" "$MODE"
import sys
from pathlib import Path

dist_dir = Path(sys.argv[1])
mode = sys.argv[2]
skill_path = dist_dir / "SKILL.md"
skill = skill_path.read_text()
trigger = "启动sp"

if mode == "on":
    skill = skill.replace(
        "description: Review one explicitly provided Markdown PRD before implementation starts. Finds ambiguity, vagueness, inaccurate definitions, missing scenarios, unverifiable requirements, and missing implementation dependencies, then outputs a structured prosecutor-style report for engineers.",
        f'description: Use when the user includes the exact phrase "{trigger}" and wants one explicitly provided Markdown PRD reviewed before implementation starts.'
    )
else:
    skill = """---\nname: spec-prosecutor\ndescription: Use when Spec Prosecutor is installed in disabled off mode and should refuse review until switched to on mode.\n---\n\n# Spec Prosecutor\n\nSpec Prosecutor is disabled in `off` mode.\n\nIf invoked, reply:\n\n`Spec Prosecutor 当前处于 off 模式，不执行审查。请切换到 on 模式后再使用。`\n"""

skill_path.write_text(skill)
PY

cat > "$DIST_DIR/README.md" <<'EOF'
# Spec Prosecutor For Claude Code

Install this folder at:

`~/.claude/skills/spec-prosecutor/`

Contents:

- `SKILL.md`
- `references/`
EOF

if [[ "$MODE" == "on" ]]; then
  echo "" >> "$DIST_DIR/README.md"
  echo "Trigger phrase for auto mode: \`启动sp\`" >> "$DIST_DIR/README.md"
else
  echo "" >> "$DIST_DIR/README.md"
  echo "Off mode is disabled and should not review PRDs." >> "$DIST_DIR/README.md"
fi

echo "Exported Claude Code skill ($MODE) to $DIST_DIR"
