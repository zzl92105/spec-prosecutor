#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:-off}"
DIST_DIR="$ROOT_DIR/dist/cursor/$MODE"

if [[ "$MODE" != "off" && "$MODE" != "on" ]]; then
  echo "Usage: $0 [off|on]" >&2
  exit 1
fi

rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

cp "$ROOT_DIR/docs/platform-guides/cursor.mdc" "$DIST_DIR/spec-prosecutor.mdc"

if [[ "$MODE" == "on" ]]; then
  python3 - <<'PY' "$DIST_DIR/spec-prosecutor.mdc"
import sys
from pathlib import Path
path = Path(sys.argv[1])
text = path.read_text()
prefix = "# Auto Mode Trigger\n\nOnly activate when the prompt contains the exact phrase `启动sp`.\n\n"
path.write_text(prefix + text)
PY
else
  cat > "$DIST_DIR/spec-prosecutor.mdc" <<'EOF'
# Spec Prosecutor Disabled

Spec Prosecutor is installed in `off` mode.

Do not review PRDs in this mode.
If the user tries to invoke it, respond that Spec Prosecutor must be switched to `on` mode first.
EOF
fi

cat > "$DIST_DIR/README.md" <<'EOF'
# Spec Prosecutor For Cursor

Install this rule at:

`.cursor/rules/spec-prosecutor.mdc`
EOF

if [[ "$MODE" == "on" ]]; then
  echo "" >> "$DIST_DIR/README.md"
  echo "Trigger phrase for auto mode: \`启动sp\`" >> "$DIST_DIR/README.md"
else
  echo "" >> "$DIST_DIR/README.md"
  echo "Off mode is disabled and should not review PRDs." >> "$DIST_DIR/README.md"
fi

echo "Exported Cursor rule ($MODE) to $DIST_DIR/spec-prosecutor.mdc"
