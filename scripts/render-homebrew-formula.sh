#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <owner> <repo>" >&2
  exit 1
fi

OWNER="$1"
REPO="$2"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(python3 - <<'PY' "$ROOT_DIR/.codex-plugin/plugin.json"
import json
import sys
from pathlib import Path
print(json.loads(Path(sys.argv[1]).read_text())["version"])
PY
)"

FORMULA_TEMPLATE="$ROOT_DIR/Formula/spec-prosecutor.rb.template"
FORMULA_OUTPUT_DIR="$ROOT_DIR/dist/release/homebrew"
FORMULA_OUTPUT_PATH="$FORMULA_OUTPUT_DIR/spec-prosecutor.rb"
TAG="v${VERSION}"
REVISION="$(git rev-list -n 1 "$TAG")"
URL="https://github.com/${OWNER}/${REPO}.git"
HOMEPAGE="https://github.com/${OWNER}/${REPO}"
mkdir -p "$FORMULA_OUTPUT_DIR"

python3 - <<'PY' "$FORMULA_TEMPLATE" "$FORMULA_OUTPUT_PATH" "$HOMEPAGE" "$URL" "$VERSION" "$TAG" "$REVISION"
import sys
from pathlib import Path

template = Path(sys.argv[1]).read_text()
output = Path(sys.argv[2])
homepage = sys.argv[3]
url = sys.argv[4]
version = sys.argv[5]
tag = sys.argv[6]
revision = sys.argv[7]

text = (
    template
    .replace("__HOMEPAGE__", homepage)
    .replace("__URL__", url)
    .replace("__VERSION__", version)
    .replace("__TAG__", tag)
    .replace("__REVISION__", revision)
)
output.write_text(text)
PY

echo "Rendered Homebrew formula: $FORMULA_OUTPUT_PATH"
