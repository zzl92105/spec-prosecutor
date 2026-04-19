#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cat <<EOF
Recommended macOS flow:

1. Install the CLI:
   bash "$ROOT_DIR/install.sh"

2. Check the installer:
   spec-prosecutor doctor

3. Initialize all targets:
   spec-prosecutor init --all --mode off --cursor-workspace /path/to/project
   spec-prosecutor init --all --mode on --cursor-workspace /path/to/project

Codex local install:

1. Export the plugin payload:
   bash "$ROOT_DIR/scripts/export-plugin.sh" off
   bash "$ROOT_DIR/scripts/export-plugin.sh" on

2. Copy the exported plugin to your preferred local plugin directory,
   for example:
   ~/plugins/spec-prosecutor

   Choose one:
   - $ROOT_DIR/dist/codex/off/spec-prosecutor
   - $ROOT_DIR/dist/codex/on/spec-prosecutor

3. Merge this entry into ~/.agents/plugins/marketplace.json:
   $ROOT_DIR/docs/install/marketplace.entry.json

   Replace source.path with the actual absolute plugin directory you chose.

   If the marketplace file does not exist yet, create:
   {
     "name": "local-plugins",
     "interface": { "displayName": "Local Plugins" },
     "plugins": []
   }

4. Restart or reload Codex so the marketplace is refreshed.

   On mode trigger phrase:
   启动sp

Claude Code install:

1. Export the Claude Code skill:
   bash "$ROOT_DIR/scripts/export-claude-code-skill.sh" off
   bash "$ROOT_DIR/scripts/export-claude-code-skill.sh" on

2. Copy:
   either
   $ROOT_DIR/dist/claude-code/off/spec-prosecutor
   or
   $ROOT_DIR/dist/claude-code/on/spec-prosecutor
   to:
   ~/.claude/skills/spec-prosecutor

   Create ~/.claude/skills if it does not exist yet.

   On mode trigger phrase:
   启动sp

Cursor install:

1. Export the Cursor rule:
   bash "$ROOT_DIR/scripts/export-cursor-rule.sh" off
   bash "$ROOT_DIR/scripts/export-cursor-rule.sh" on

2. Copy:
   either
   $ROOT_DIR/dist/cursor/off/spec-prosecutor.mdc
   or
   $ROOT_DIR/dist/cursor/on/spec-prosecutor.mdc
   to:
   .cursor/rules/spec-prosecutor.mdc

   Create .cursor/rules if it does not exist yet.

   On mode trigger phrase:
   启动sp
EOF
