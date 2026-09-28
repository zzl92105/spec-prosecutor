#!/usr/bin/env bash
set -euo pipefail
cat <<'EOF'
Project installation (run from this repository):
  bash bin/spec-prosecutor add --codex --claude-code --project /path/to/project

Manual installation: copy the complete skills/spec-prosecutor folder to:
  Codex:       <project>/.agents/skills/
  Claude Code: <project>/.claude/skills/

Native invocation:
  Codex:       $spec-prosecutor <file-or-directory>
  Claude Code: /spec-prosecutor <file-or-directory>

Optional legacy alias: 启动sp
See README.md for on/off, user-level installation and legacy Cursor support.
EOF
