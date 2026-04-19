#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

rm -rf "$ROOT_DIR/dist/codex" \
       "$ROOT_DIR/dist/codex-skill" \
       "$ROOT_DIR/dist/claude-code" \
       "$ROOT_DIR/dist/cursor" \
       "$ROOT_DIR/dist/spec-prosecutor"

bash "$ROOT_DIR/scripts/export-plugin.sh" off
bash "$ROOT_DIR/scripts/export-plugin.sh" on
bash "$ROOT_DIR/scripts/export-codex-skill.sh" off
bash "$ROOT_DIR/scripts/export-codex-skill.sh" on
bash "$ROOT_DIR/scripts/export-claude-code-skill.sh" off
bash "$ROOT_DIR/scripts/export-claude-code-skill.sh" on
bash "$ROOT_DIR/scripts/export-cursor-rule.sh" off
bash "$ROOT_DIR/scripts/export-cursor-rule.sh" on

echo "Exported all installable artifacts under $ROOT_DIR/dist"
