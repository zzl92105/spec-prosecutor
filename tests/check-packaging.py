#!/usr/bin/env python3
"""Runnable packaging/install checks; no model calls or real user installation."""
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tarfile
import tempfile
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASH = shutil.which("bash")
if os.name == "nt":
    # Windows subprocess search can prefer System32/bash.exe (WSL). Use Git Bash explicitly.
    git = shutil.which("git")
    candidates = [parent / "bin/bash.exe" for parent in Path(git).parents] if git else []
    candidate = next((path for path in candidates if path.is_file()), None)
    assert candidate, f"Windows checks require Git Bash; Git was found at {git}"
    BASH = str(candidate)
assert BASH, "Bash is required for compatibility installer tests"



def snapshot(path):
    return {
        str(p.relative_to(path)): hashlib.sha256(p.read_bytes()).hexdigest()
        for p in path.rglob("*") if p.is_file()
    }


def main():
    # Leave generated artifacts in the OS temp directory for inspection.
    scratch = Path(tempfile.mkdtemp(prefix="spec-prosecutor-check-"))
    repo = scratch / "source"
    shutil.copytree(ROOT, repo, ignore=shutil.ignore_patterns(".git", "dist", "__pycache__"))
    original = snapshot(repo / "plugins/spec-prosecutor/skills")

    def run(*args, ok=True):
        result = subprocess.run(args, cwd=repo, text=True, encoding="utf-8", capture_output=True)
        assert (result.returncode == 0) == ok, result.stdout + result.stderr
        return result

    for path in [repo / "bin/spec-prosecutor", *repo.glob("scripts/*.sh"), repo / "hooks/user-prompt-gate"]:
        run(BASH, "-n", path.as_posix())
    run(BASH, "scripts/export-all.sh")
    source = snapshot(repo / "plugins/spec-prosecutor/skills/spec-prosecutor")
    for host in ("codex-skill", "claude-code"):
        assert snapshot(repo / "dist" / host / "on/spec-prosecutor") == source
        disabled = repo / "dist" / host / "off/spec-prosecutor"
        assert "disabled in `off` mode" in (disabled / "SKILL.md").read_text(encoding="utf-8")
        assert "allow_implicit_invocation: false" in (disabled / "agents/openai.yaml").read_text(encoding="utf-8")
        assert (disabled / "references/checklists.md").is_file()
    assert snapshot(repo / "dist/codex/on/spec-prosecutor/skills/spec-prosecutor") == source
    legacy = repo / "dist/codex-skill/on/spec-prosecutor/README.md"
    legacy.write_text("Old mandatory phrase-gate instructions")
    run(BASH, "scripts/export-codex-skill.sh", "on")
    assert "Old mandatory" not in legacy.read_text(encoding="utf-8")
    plugin = json.loads((repo / "dist/codex/on/spec-prosecutor/.codex-plugin/plugin.json").read_text(encoding="utf-8"))
    assert "hooks" not in plugin
    assert json.loads((repo / "hooks/hooks.json").read_text(encoding="utf-8")) == {"hooks": {}}
    for prompt in ("启动sp 审查 docs/", "$spec-prosecutor docs/", "/spec-prosecutor docs/", "How do I install spec-prosecutor?"):
        result = subprocess.run([BASH, "hooks/user-prompt-gate"], cwd=repo,
                                input=json.dumps({"prompt": prompt}), text=True, encoding="utf-8", capture_output=True)
        assert result.returncode == 0 and result.stdout == ""

    project = scratch / "项目 with spaces"
    project.mkdir()
    targets = [project / prefix / "skills/spec-prosecutor" for prefix in (".agents", ".claude")]
    # Confirm explicit project installation cannot mutate global copies.
    globals_before = {prefix: snapshot(Path.home() / prefix / "skills/spec-prosecutor")
                      for prefix in (".agents", ".claude")}
    command = [BASH, "bin/spec-prosecutor"]
    options = ["--codex", "--claude-code", "--project", project.as_posix()]
    run(*command, "add", *options)
    for target in targets:
        installed = snapshot(target)
        installed.pop("README.md", None)
        assert installed == source
        (target / "personal-note.txt").write_text("keep me")
    run(*command, "off", *options)
    for target in targets:
        assert "disabled in `off` mode" in (target / "SKILL.md").read_text(encoding="utf-8")
    run(*command, "on", *options)
    for target in targets:
        installed = snapshot(target)
        installed.pop("personal-note.txt")
        installed.pop("README.md", None)
        assert installed == source
        assert (target / "personal-note.txt").read_text(encoding="utf-8") == "keep me"

    before = snapshot(project)
    for bad in (["--global"], ["--all"], ["--mode", "invalid"]):
        run(*command, "add", *options, *bad, ok=False)
    run(*command, "add", "--project", project.as_posix(), ok=False)
    run(*command, "add", "--codex", "--project", (scratch / "missing").as_posix(), ok=False)
    run(*command, "add", "--codex", "--project", ok=False)
    run(*command, "remove", *options, "--cli", ok=False)
    assert snapshot(project) == before
    run(BASH, "scripts/export-codex-skill.sh", "invalid", ok=False)
    run("python3", "scripts/export-skill.py", "plugins/spec-prosecutor/skills/spec-prosecutor", "on", ok=False)
    assert snapshot(repo / "plugins/spec-prosecutor/skills") == original
    for prefix, before in globals_before.items():
        assert snapshot(Path.home() / prefix / "skills/spec-prosecutor") == before

    # A plugin replacement must not retain removed files from a previous build.
    stale = repo / "dist/codex/on/spec-prosecutor/obsolete.txt"
    stale.write_text("stale")
    run(BASH, "scripts/export-plugin.sh", "on")
    assert not stale.exists()
    assert list(stale.parent.parent.glob(".stage-*-previous/obsolete.txt"))
    # Release contents are closed and reproducible; test the extracted source, too.
    run(BASH, "scripts/package-release.sh")
    release = repo / "dist/release"
    first = snapshot(release)
    run(BASH, "scripts/package-release.sh")
    assert snapshot(release) == first
    with zipfile.ZipFile(next(release.glob("*-plugin.zip"))) as archive:
        names = archive.namelist()
        assert "spec-prosecutor/plugin.json" in names
        assert "spec-prosecutor/skills/spec-prosecutor/agents/openai.yaml" in names
        assert not any("hooks/" in n or "tests/" in n or "__pycache__" in n for n in names)
        extracted = scratch / "plugin-only"
        archive.extractall(extracted)
        assert snapshot(extracted / "spec-prosecutor") == snapshot(repo / "plugins/spec-prosecutor")
    unpacked = scratch / "source-archive"
    with tarfile.open(next(release.glob("*-source.tar.gz"))) as archive:
        archive.extractall(unpacked, **({"filter": "data"} if sys.version_info >= (3, 12) else {}))
    run(sys.executable, str(unpacked / "spec-prosecutor/scripts/sync-metadata.py"), "--check")
    # Migration defaults to read-only, preserves other catalog entries and keeps full backups.
    isolated_home = scratch / "isolated-home"
    old_skill = isolated_home / ".agents/skills/spec-prosecutor"
    shutil.copytree(repo / "plugins/spec-prosecutor/skills/spec-prosecutor", old_skill)
    (old_skill / "personal-note.txt").write_text("preserve personal changes")
    old_catalog = isolated_home / ".agents/plugins/marketplace.json"
    old_catalog.parent.mkdir(parents=True)
    unrelated = {"name": "another-plugin", "source": "./plugins/another-plugin"}
    original_catalog = {"name": "personal", "plugins": [unrelated,
                         {"name": "spec-prosecutor", "source": {"source": "local", "path": "/missing"}}]}
    old_catalog.write_text(json.dumps(original_catalog))
    migration = [sys.executable, str(repo / "scripts/migrate-install.py")]
    env = dict(os.environ, HOME=str(isolated_home), USERPROFILE=str(isolated_home), PYTHONDONTWRITEBYTECODE="1")
    before = snapshot(isolated_home)
    subprocess.run(migration, env=env, check=True, capture_output=True)
    assert snapshot(isolated_home) == before
    subprocess.run([*migration, "--apply"], env=env, check=True, capture_output=True)
    assert not old_skill.exists()
    assert json.loads(old_catalog.read_text(encoding="utf-8"))["plugins"] == [unrelated]
    backup = next((isolated_home / ".local/share/spec-prosecutor/backups").glob("legacy-*"))
    assert json.loads((backup / "marketplace.json").read_text(encoding="utf-8")) == original_catalog
    assert (backup / ".agents/skills/spec-prosecutor/personal-note.txt").read_text(encoding="utf-8") == "preserve personal changes"
    after = snapshot(isolated_home)
    subprocess.run([*migration, "--apply"], env=env, check=True, capture_output=True)
    assert snapshot(isolated_home) == after
    # CLI-only removal must parse independently without choosing or touching any host.
    empty_home = scratch / "empty-home"
    empty_home.mkdir()
    result = subprocess.run([*command, "uninstall", "--cli"], cwd=repo,
                            env=dict(os.environ, HOME=str(empty_home), USERPROFILE=str(empty_home)),
                            text=True, encoding="utf-8", capture_output=True)
    assert result.returncode == 0, result.stdout + result.stderr
    if os.name != "nt":
        linked_project = scratch / "linked-project"
        linked_project.mkdir()
        (linked_project / ".agents").symlink_to(isolated_home / ".agents", target_is_directory=True)
        result = subprocess.run([*migration, "--project", str(linked_project), "--apply"],
                                env=env, text=True, encoding="utf-8", capture_output=True)
        assert result.returncode != 0 and "symbolic link" in result.stderr
        assert snapshot(isolated_home) == after
    print(f"Packaging/install checks passed. Artifacts: {scratch}")


if __name__ == "__main__":
    main()
