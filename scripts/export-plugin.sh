#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:-on}"
[[ "$MODE" == "on" || "$MODE" == "off" ]] || { echo "Usage: $0 [on|off]" >&2; exit 1; }
DIST_DIR="$ROOT_DIR/dist/codex/$MODE/spec-prosecutor"
mkdir -p "$DIST_DIR"
for directory in .codex-plugin .claude-plugin .cursor-plugin hooks; do
  mkdir -p "$DIST_DIR/$directory"
  cp -R "$ROOT_DIR/$directory/." "$DIST_DIR/$directory/"
done
mkdir -p "$DIST_DIR/docs/platform-guides"
cp -R "$ROOT_DIR/docs/platform-guides/." "$DIST_DIR/docs/platform-guides/"
cp "$ROOT_DIR/docs/install/marketplace.entry.json" "$DIST_DIR/docs/marketplace.entry.json"
python3 "$ROOT_DIR/scripts/export-skill.py" "$DIST_DIR/skills/spec-prosecutor" "$MODE"
cat > "$DIST_DIR/README.md" <<EOF
# Spec Prosecutor plugin export

Mode: $MODE. The shared skill is in skills/spec-prosecutor/.
Codex and Claude Code use native skill invocation; no phrase gate or hook is required.
See docs/platform-guides/ for host-specific usage.
EOF
echo "Exported plugin ($MODE) to $DIST_DIR"
