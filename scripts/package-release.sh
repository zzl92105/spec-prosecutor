#!/usr/bin/env bash

set -euo pipefail

export LC_ALL=C
export LANG=C

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(python3 - <<'PY' "$ROOT_DIR/.codex-plugin/plugin.json"
import json
import sys
from pathlib import Path
print(json.loads(Path(sys.argv[1]).read_text())["version"])
PY
)"

STAGE_DIR="$ROOT_DIR/dist/release/stage/spec-prosecutor"
RELEASE_DIR="$ROOT_DIR/dist/release"
ARCHIVE_BASENAME="spec-prosecutor-v${VERSION}-macos"
ARCHIVE_PATH="$RELEASE_DIR/${ARCHIVE_BASENAME}.tar.gz"
CHECKSUM_PATH="$ARCHIVE_PATH.sha256"

rm -rf "$STAGE_DIR"
mkdir -p "$STAGE_DIR" "$RELEASE_DIR/homebrew"

cp -R \
  "$ROOT_DIR/.codex-plugin" \
  "$ROOT_DIR/.claude-plugin" \
  "$ROOT_DIR/.cursor-plugin" \
  "$ROOT_DIR/Formula" \
  "$ROOT_DIR/bin" \
  "$ROOT_DIR/docs" \
  "$ROOT_DIR/hooks" \
  "$ROOT_DIR/install.sh" \
  "$ROOT_DIR/scripts" \
  "$ROOT_DIR/skills" \
  "$ROOT_DIR/tests" \
  "$ROOT_DIR/README.md" \
  "$ROOT_DIR/.gitignore" \
  "$STAGE_DIR/"

chmod +x "$STAGE_DIR/install.sh" "$STAGE_DIR/bin/spec-prosecutor" "$STAGE_DIR/scripts/"*.sh "$STAGE_DIR/hooks/user-prompt-gate"

rm -f "$ARCHIVE_PATH" "$CHECKSUM_PATH"
tar -C "$ROOT_DIR/dist/release/stage" -czf "$ARCHIVE_PATH" spec-prosecutor
shasum -a 256 "$ARCHIVE_PATH" | awk '{print $1}' > "$CHECKSUM_PATH"

cat <<EOF
Packaged release assets:
  $ARCHIVE_PATH
  $CHECKSUM_PATH
EOF
