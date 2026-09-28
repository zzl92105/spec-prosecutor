#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[[ $# -eq 0 || ( $# -eq 1 && "$1" == "--static" ) ]] || { echo "Usage: $0 [--static]" >&2; exit 1; }
python3 "$ROOT_DIR/scripts/validate-repo.py"
if [[ "${1:-}" != "--static" ]]; then
  bash "$ROOT_DIR/scripts/run-regression-checks.sh"
fi
