#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:-off}"
DIST_DIR="$ROOT_DIR/dist/codex/$MODE/spec-prosecutor"

if [[ "$MODE" != "off" && "$MODE" != "on" ]]; then
  echo "Usage: $0 [off|on]" >&2
  exit 1
fi

rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

cp -R "$ROOT_DIR/.codex-plugin" "$DIST_DIR/.codex-plugin"
cp -R "$ROOT_DIR/.claude-plugin" "$DIST_DIR/.claude-plugin"
cp -R "$ROOT_DIR/.cursor-plugin" "$DIST_DIR/.cursor-plugin"
cp -R "$ROOT_DIR/hooks" "$DIST_DIR/hooks"
cp -R "$ROOT_DIR/skills" "$DIST_DIR/skills"
mkdir -p "$DIST_DIR/docs"
cp -R "$ROOT_DIR/docs/platform-guides" "$DIST_DIR/docs/platform-guides"
cp "$ROOT_DIR/docs/install/marketplace.entry.json" "$DIST_DIR/docs/marketplace.entry.json"

python3 - <<'PY' "$DIST_DIR" "$MODE"
import sys
from pathlib import Path

dist_dir = Path(sys.argv[1])
mode = sys.argv[2]

skill_path = dist_dir / "skills/spec-prosecutor/SKILL.md"
yaml_path = dist_dir / "skills/spec-prosecutor/agents/openai.yaml"

skill = skill_path.read_text()
yaml = yaml_path.read_text()

trigger = "启动sp"

if mode == "on":
    skill = skill.replace(
        "description: Review one explicitly provided Markdown PRD before implementation starts. Finds ambiguity, vagueness, inaccurate definitions, missing scenarios, unverifiable requirements, and missing implementation dependencies, then outputs a structured prosecutor-style report for engineers.",
        f'description: Use when the user includes the exact phrase "{trigger}" and wants one explicitly provided Markdown PRD reviewed before implementation starts.'
    )
else:
    skill = """---\nname: spec-prosecutor\ndescription: Use when Spec Prosecutor is installed in disabled off mode and should refuse review until switched to on mode.\n---\n\n# Spec Prosecutor\n\nSpec Prosecutor is disabled in `off` mode.\n\nIf invoked, reply:\n\n`Spec Prosecutor 当前处于 off 模式，不执行审查。请切换到 on 模式后再使用。`\n"""

skill_path.write_text(skill)
yaml_path.write_text(yaml)
PY

cat > "$DIST_DIR/README.md" <<'EOF'
# Spec Prosecutor

Packaged plugin export for local installation.

Contents:

- `.codex-plugin/plugin.json`
- `.claude-plugin/plugin.json`
- `.cursor-plugin/plugin.json`
- `hooks/`
- `skills/spec-prosecutor/`
- `docs/platform-guides/`
- `docs/marketplace.entry.json`

Install this folder under `~/plugins/spec-prosecutor` and merge `docs/marketplace.entry.json` into `~/.agents/plugins/marketplace.json`.
EOF

if [[ "$MODE" == "on" ]]; then
  echo "Trigger phrase for auto mode: 启动sp" >> "$DIST_DIR/README.md"
else
  echo "Off mode is disabled and should not review PRDs." >> "$DIST_DIR/README.md"
fi

echo "Exported Codex plugin ($MODE) to $DIST_DIR"
