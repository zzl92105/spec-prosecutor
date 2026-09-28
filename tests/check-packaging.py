#!/usr/bin/env python3
"""Runnable packaging/install checks; no model calls or real user installation."""
import hashlib
import json
import shutil
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


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
    original = snapshot(repo / "skills")

    def run(*args, ok=True):
        result = subprocess.run(args, cwd=repo, text=True, capture_output=True)
        assert (result.returncode == 0) == ok, result.stdout + result.stderr
        return result

    for path in [repo / "bin/spec-prosecutor", *repo.glob("scripts/*.sh"), repo / "hooks/user-prompt-gate"]:
        run("bash", "-n", str(path))
    run("bash", "scripts/export-all.sh")
    source = snapshot(repo / "skills/spec-prosecutor")
    for host in ("codex-skill", "claude-code"):
        assert snapshot(repo / "dist" / host / "on/spec-prosecutor") == source
        disabled = repo / "dist" / host / "off/spec-prosecutor"
        assert "disabled in `off` mode" in (disabled / "SKILL.md").read_text()
        assert "allow_implicit_invocation: false" in (disabled / "agents/openai.yaml").read_text()
        assert (disabled / "references/checklists.md").is_file()
    assert snapshot(repo / "dist/codex/on/spec-prosecutor/skills/spec-prosecutor") == source
    legacy = repo / "dist/codex-skill/on/spec-prosecutor/README.md"
    legacy.write_text("Old mandatory phrase-gate instructions")
    run("bash", "scripts/export-codex-skill.sh", "on")
    assert "Old mandatory" not in legacy.read_text()
    plugin = json.loads((repo / "dist/codex/on/spec-prosecutor/.codex-plugin/plugin.json").read_text())
    assert "hooks" not in plugin
    assert json.loads((repo / "hooks/hooks.json").read_text()) == {"hooks": {}}
    for prompt in ("启动sp 审查 docs/", "$spec-prosecutor docs/", "/spec-prosecutor docs/", "How do I install spec-prosecutor?"):
        result = subprocess.run(["bash", "hooks/user-prompt-gate"], cwd=repo,
                                input=json.dumps({"prompt": prompt}), text=True, capture_output=True)
        assert result.returncode == 0 and result.stdout == ""

    project = scratch / "项目 with spaces"
    project.mkdir()
    targets = [project / prefix / "skills/spec-prosecutor" for prefix in (".agents", ".claude")]
    # Confirm explicit project installation cannot mutate global copies.
    globals_before = {prefix: snapshot(Path.home() / prefix / "skills/spec-prosecutor")
                      for prefix in (".agents", ".claude")}
    command = ["bash", "bin/spec-prosecutor"]
    options = ["--codex", "--claude-code", "--project", str(project)]
    run(*command, "add", *options)
    for target in targets:
        installed = snapshot(target)
        installed.pop("README.md", None)
        assert installed == source
        (target / "personal-note.txt").write_text("keep me")
    run(*command, "off", *options)
    for target in targets:
        assert "disabled in `off` mode" in (target / "SKILL.md").read_text()
    run(*command, "on", *options)
    for target in targets:
        installed = snapshot(target)
        installed.pop("personal-note.txt")
        installed.pop("README.md", None)
        assert installed == source
        assert (target / "personal-note.txt").read_text() == "keep me"

    before = snapshot(project)
    for bad in (["--global"], ["--all"], ["--mode", "invalid"]):
        run(*command, "add", *options, *bad, ok=False)
    run(*command, "add", "--project", str(project), ok=False)
    run(*command, "add", "--codex", "--project", str(scratch / "missing"), ok=False)
    run(*command, "add", "--codex", "--project", ok=False)
    run(*command, "remove", *options, "--cli", ok=False)
    assert snapshot(project) == before
    run("bash", "scripts/export-codex-skill.sh", "invalid", ok=False)
    run("python3", "scripts/export-skill.py", "skills/spec-prosecutor", "on", ok=False)
    assert snapshot(repo / "skills") == original
    for prefix, before in globals_before.items():
        assert snapshot(Path.home() / prefix / "skills/spec-prosecutor") == before
    print(f"Packaging/install checks passed. Artifacts: {scratch}")


if __name__ == "__main__":
    main()
