#!/usr/bin/env python3
"""Exercise real host CLIs using fresh HOME/config directories, without model calls."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
scratch = Path(tempfile.mkdtemp(prefix="spec-prosecutor-native-"))
repo = scratch / "marketplace with spaces"
shutil.copytree(ROOT, repo, ignore=shutil.ignore_patterns(".git", "dist", "__pycache__", ".venv"))
for name in ("home", "codex", "claude"):
    (scratch / name).mkdir()
env = dict(os.environ, HOME=str(scratch / "home"), CODEX_HOME=str(scratch / "codex"),
           CLAUDE_CONFIG_DIR=str(scratch / "claude"), XDG_CONFIG_HOME=str(scratch / "home/.config"))
plugin_id = "spec-prosecutor@spec-prosecutor-marketplace"


def run(*args):
    result = subprocess.run(args, cwd=scratch, env=env, text=True, capture_output=True, timeout=60)
    assert result.returncode == 0, f"{args}\n{result.stdout}\n{result.stderr}"
    return result.stdout


def same_skill(installed):
    original = repo / "plugins/spec-prosecutor/skills/spec-prosecutor"
    for path in original.rglob("*"):
        if path.is_file():
            assert (installed / "skills/spec-prosecutor" / path.relative_to(original)).read_bytes() == path.read_bytes()


for executable in ("codex", "claude"):
    assert shutil.which(executable), f"Install {executable} CLI before running native integration checks"
run("codex", "plugin", "marketplace", "add", str(repo), "--json")
first = json.loads(run("codex", "plugin", "add", plugin_id, "--json"))
same_skill(Path(first["installedPath"]))
run("claude", "plugin", "validate", str(repo), "--strict")
run("claude", "plugin", "validate", str(repo / "plugins/spec-prosecutor"), "--strict")
run("claude", "plugin", "marketplace", "add", str(repo))
run("claude", "plugin", "install", plugin_id)
details = run("claude", "plugin", "details", "spec-prosecutor")
assert "spec-prosecutor" in details
run("claude", "plugin", "disable", plugin_id)
run("claude", "plugin", "enable", plugin_id)
# Upgrade the isolated source, then ensure native management sees the new version.
manifest = repo / "plugins/spec-prosecutor/plugin.json"
data = json.loads(manifest.read_text(encoding="utf-8"))
data["version"] = "0.2.1"
manifest.write_text(json.dumps(data))
run(sys.executable, str(repo / "scripts/sync-metadata.py"))
# Local marketplaces are reread on add; marketplace upgrade is for Git sources.
updated = json.loads(run("codex", "plugin", "add", plugin_id, "--json"))
assert updated["version"] == "0.2.1"
same_skill(Path(updated["installedPath"]))
run("claude", "plugin", "marketplace", "update", "spec-prosecutor-marketplace")
run("claude", "plugin", "update", plugin_id)
installed = json.loads((scratch / "claude/plugins/installed_plugins.json").read_text(encoding="utf-8"))
assert installed["plugins"][plugin_id][0]["version"] == "0.2.1"
same_skill(Path(installed["plugins"][plugin_id][0]["installPath"]))
print(f"Native install, component discovery and update passed. Isolated artifacts: {scratch}")
