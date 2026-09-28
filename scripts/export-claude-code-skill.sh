#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:-on}"
DIST_DIR="$ROOT_DIR/dist/claude-code/$MODE/spec-prosecutor"
python3 "$ROOT_DIR/scripts/export-skill.py" "$DIST_DIR" "$MODE"
echo "Exported Claude Code skill ($MODE) to $DIST_DIR"
