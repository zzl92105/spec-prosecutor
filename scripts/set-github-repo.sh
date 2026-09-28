#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <owner> <repo>" >&2
  exit 1
fi

OWNER="$1"
REPO="$2"
SLUG="$OWNER/$REPO"
REPO_URL="https://github.com/$SLUG"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 - <<'PY' "$ROOT_DIR" "$SLUG" "$REPO_URL"
import json
import sys
from pathlib import Path

root = Path(sys.argv[1])
slug = sys.argv[2]
repo_url = sys.argv[3]

plugin_path = root / "plugins/spec-prosecutor/plugin.json"
plugin = json.loads(plugin_path.read_text(encoding="utf-8"))
plugin["repository"] = repo_url
plugin["homepage"] = repo_url
plugin.setdefault("author", {})["url"] = repo_url
plugin["extensions"]["com.openai"]["interface"]["websiteURL"] = repo_url
plugin_path.write_text(json.dumps(plugin, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

files = [
    root / "README.md",
    root / "docs/install/github-direct.md",
    root / "docs/install/homebrew.md",
]

for path in files:
    text = path.read_text(encoding="utf-8")
    text = text.replace("<owner>/<repo>", slug)
    path.write_text(text, encoding="utf-8")
PY

python3 "$ROOT_DIR/scripts/sync-metadata.py"
echo "Updated repository metadata for $SLUG"
