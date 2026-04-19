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
ARCHIVE_BASENAME="${TAG}.tar.gz"
URL="https://github.com/${OWNER}/${REPO}/archive/refs/tags/${ARCHIVE_BASENAME}"
HOMEPAGE="https://github.com/${OWNER}/${REPO}"
TMP_DIR="$(mktemp -d)"
ARCHIVE_PATH="$TMP_DIR/$ARCHIVE_BASENAME"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

curl -fsSL "$URL" -o "$ARCHIVE_PATH"
SHA256="$(shasum -a 256 "$ARCHIVE_PATH" | awk '{print $1}')"
mkdir -p "$FORMULA_OUTPUT_DIR"

python3 - <<'PY' "$FORMULA_TEMPLATE" "$FORMULA_OUTPUT_PATH" "$HOMEPAGE" "$URL" "$SHA256" "$VERSION"
import sys
from pathlib import Path

template = Path(sys.argv[1]).read_text()
output = Path(sys.argv[2])
homepage = sys.argv[3]
url = sys.argv[4]
sha256 = sys.argv[5]
version = sys.argv[6]

text = (
    template
    .replace("__HOMEPAGE__", homepage)
    .replace("__URL__", url)
    .replace("__SHA256__", sha256)
    .replace("__VERSION__", version)
)
output.write_text(text)
PY

echo "Rendered Homebrew formula: $FORMULA_OUTPUT_PATH"
