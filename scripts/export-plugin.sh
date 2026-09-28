#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[[ $# -le 1 ]] || { echo "Usage: $0 [on|off]" >&2; exit 1; }
python3 "$ROOT_DIR/scripts/sync-metadata.py" --check >/dev/null
python3 -B "$ROOT_DIR/scripts/package.py" plugin --mode "${1:-on}"
