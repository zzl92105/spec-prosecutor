#!/usr/bin/env bash
set -euo pipefail
cat <<'EOF'
Codex native plugin:
  codex plugin marketplace add https://github.com/zzl92105/spec-prosecutor.git --ref main
  codex plugin add spec-prosecutor@spec-prosecutor-marketplace
Claude Code native plugin:
  claude plugin marketplace add zzl92105/spec-prosecutor
  claude plugin install spec-prosecutor@spec-prosecutor-marketplace
Invocation:
  Codex:       $spec-prosecutor <file-or-directory>
  Claude Code: /spec-prosecutor:spec-prosecutor <file-or-directory>
Start a new session after installation. See docs/install/migration.md for old standalone copies.
EOF
