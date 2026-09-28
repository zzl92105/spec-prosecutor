#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[[ $# -eq 0 ]] || { echo "Usage: $0" >&2; exit 1; }
python3 "$ROOT_DIR/scripts/sync-metadata.py" --check >/dev/null
python3 -B "$ROOT_DIR/scripts/package.py" release
