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

plugin_path = root / ".codex-plugin/plugin.json"
plugin = json.loads(plugin_path.read_text())
plugin["repository"] = repo_url
plugin["homepage"] = repo_url
plugin.setdefault("author", {})["url"] = repo_url
plugin["interface"]["websiteURL"] = repo_url
plugin_path.write_text(json.dumps(plugin, indent=2, ensure_ascii=False) + "\n")

files = [
    root / "README.md",
    root / "docs/install/github-direct.md",
    root / "docs/install/homebrew.md",
]

for path in files:
    text = path.read_text()
    text = text.replace("<owner>/<repo>", slug)
    path.write_text(text)
PY

if [[ -f "$ROOT_DIR/dist/release/spec-prosecutor-v$(python3 - <<'PY' "$ROOT_DIR/.codex-plugin/plugin.json"
import json
import sys
from pathlib import Path
print(json.loads(Path(sys.argv[1]).read_text())["version"])
PY
)-macos.tar.gz" ]]; then
  bash "$ROOT_DIR/scripts/render-homebrew-formula.sh" "$OWNER" "$REPO" >/dev/null
fi

echo "Updated repository metadata for $SLUG"
