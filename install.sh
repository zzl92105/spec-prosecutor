#!/usr/bin/env bash

set -euo pipefail

[[ "$(uname -s)" == "Darwin" ]] || {
  echo "Spec Prosecutor installer currently supports macOS only." >&2
  exit 1
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_ROOT="${HOME}/.local/share/spec-prosecutor"
BIN_DIR="${HOME}/.local/bin"
TARGET_ROOT="${INSTALL_ROOT}/repo"
BIN_TARGET="${BIN_DIR}/spec-prosecutor"
INIT_ARGS=("$@")

mkdir -p "$INSTALL_ROOT" "$BIN_DIR"
rm -rf "$TARGET_ROOT"
mkdir -p "$TARGET_ROOT"

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
  "$TARGET_ROOT/"

chmod +x "$TARGET_ROOT/bin/spec-prosecutor"
ln -sf "$TARGET_ROOT/bin/spec-prosecutor" "$BIN_TARGET"

cat <<EOF
Spec Prosecutor installed for macOS.

CLI:
  $BIN_TARGET

If ~/.local/bin is not on your PATH, add this to ~/.zshrc:
  export PATH="\$HOME/.local/bin:\$PATH"

Next steps:
  spec-prosecutor doctor
  spec-prosecutor add -g
  spec-prosecutor add -g --codex
  spec-prosecutor add --agent cursor --cursor-workspace /path/to/project
  spec-prosecutor add -g --mode on
  bash install.sh --codex --mode on
EOF

if [[ ${#INIT_ARGS[@]} -gt 0 ]]; then
  SP_SKIP_VALIDATE_REPO=1 "$BIN_TARGET" init "${INIT_ARGS[@]}"
fi
