#!/usr/bin/env python3
"""Build self-contained plugin exports and reproducible release archives."""
import argparse
import gzip
import hashlib
import importlib.util
import io
import json
from pathlib import Path
import shutil
import tarfile
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[1]
PLUGIN = ROOT / "plugins/spec-prosecutor"


def files(root):
    for path in sorted(root.rglob("*")):
        if path.is_symlink():
            raise ValueError(f"Package must not depend on symlinks: {path}")
        if path.is_file():
            yield path


def export(mode):
    parent = ROOT / "dist/codex" / mode
    parent.mkdir(parents=True, exist_ok=True)
    stage = Path(tempfile.mkdtemp(prefix=".stage-", dir=parent))
    output = parent / "spec-prosecutor"
    shutil.copytree(PLUGIN, stage, dirs_exist_ok=True)
    spec = importlib.util.spec_from_file_location("export_skill", ROOT / "scripts/export-skill.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module.export_skill(stage / "skills/spec-prosecutor", mode)
    list(files(stage))
    if output.exists():
        # Keep the old export recoverable, while preventing stale files in the new package.
        output.rename(parent / (stage.name + "-previous"))
    stage.rename(output)
    return output


def release():
    version = json.loads((PLUGIN / "plugin.json").read_text(encoding="utf-8"))["version"]
    output = ROOT / "dist/release"
    output.mkdir(parents=True, exist_ok=True)
    archive = output / f"spec-prosecutor-v{version}-plugin.zip"
    with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED) as z:
        for path in files(PLUGIN):
            info = zipfile.ZipInfo("spec-prosecutor/" + path.relative_to(PLUGIN).as_posix())
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            z.writestr(info, path.read_bytes())
    # Explicit distribution surface: never package .git, caches, customer data or dist/.
    entries = [".agents", ".github", ".claude-plugin", ".cursor-plugin", "plugins", "bin", "scripts",
               "docs", "tests", "hooks", "Formula", "install.sh", "README.md", "CHANGELOG.md",
               "requirements-dev.txt", ".gitignore"]
    source = output / f"spec-prosecutor-v{version}-source.tar.gz"
    with source.open("wb") as raw, gzip.GzipFile(fileobj=raw, mode="wb", filename="", mtime=0) as gz:
        with tarfile.open(fileobj=gz, mode="w") as tar:
            for name in entries:
                item = ROOT / name
                for path in files(item) if item.is_dir() else [item]:
                    data = path.read_bytes()
                    info = tarfile.TarInfo("spec-prosecutor/" + path.relative_to(ROOT).as_posix())
                    info.size = len(data)
                    info.mode = 0o755 if path.stat().st_mode & 0o111 else 0o644
                    tar.addfile(info, io.BytesIO(data))
    for path in (archive, source):
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        path.with_name(path.name + ".sha256").write_text(f"{digest}  {path.name}\n")
        print(path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("plugin", "release"))
    parser.add_argument("--mode", choices=("on", "off"), default="on")
    args = parser.parse_args()
    if args.command == "plugin":
        print(export(args.mode))
    else:
        release()
