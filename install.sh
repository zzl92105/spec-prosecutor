#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 - "$ROOT_DIR" <<'PYTHON'
import os
import shutil
import sys
import tempfile
from pathlib import Path
root = Path(sys.argv[1]).resolve()
parent = Path.home() / ".local/share/spec-prosecutor"
target = parent / "repo"
binary = Path.home() / ".local/bin/spec-prosecutor"
if binary.exists() or binary.is_symlink():
    if not binary.is_symlink() or binary.resolve() != target / "bin/spec-prosecutor":
        raise SystemExit(f"Refusing to replace unrelated command: {binary}")
if root == target.resolve():
    print("CLI is already running from its installation; source unchanged.")
else:
    parent.mkdir(parents=True, exist_ok=True)
    stage = Path(tempfile.mkdtemp(prefix="stage-", dir=parent))
    shutil.copytree(root, stage, dirs_exist_ok=True,
                    ignore=shutil.ignore_patterns(".git", "dist", "__pycache__", ".venv"))
    if target.exists() or target.is_symlink():
        backup = parent / (stage.name + "-previous")
        target.rename(backup)
        print(f"Previous CLI preserved at {backup}")
    stage.rename(target)
binary.parent.mkdir(parents=True, exist_ok=True)
if not binary.is_symlink():
    binary.symlink_to(target / "bin/spec-prosecutor")
print(f"Standalone compatibility CLI: {binary}")
print("Native plugins use codex/claude plugin commands; see README.md.")
PYTHON
if [[ $# -gt 0 ]]; then
  bash "$HOME/.local/share/spec-prosecutor/repo/bin/spec-prosecutor" init "$@"
fi
