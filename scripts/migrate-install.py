#!/usr/bin/env python3
"""Back up legacy standalone Skills before switching to native plugins. Dry-run by default."""
import argparse
import json
from pathlib import Path
import re
import shutil
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apply", action="store_true", help="Move legacy copies to a recoverable backup")
    parser.add_argument("--project", type=Path, help="Inspect an existing project instead of the user home")
    args = parser.parse_args()
    root = (args.project or Path.home()).expanduser().resolve()
    if not root.is_dir():
        parser.error(f"Directory does not exist: {root}")

    def reject_symlink_components(path):
        candidate = root
        for part in path.relative_to(root).parts:
            candidate = candidate / part
            if candidate.is_symlink():
                parser.error(f"Review this symbolic link manually before migration: {candidate}")

    moves = []
    for prefix in (".agents", ".codex", ".claude"):
        path = root / prefix / "skills/spec-prosecutor"
        reject_symlink_components(path)
        if path.exists():
            entry = path / "SKILL.md"
            if not entry.is_file() or not re.search(r"(?m)^name: *spec-prosecutor *$", entry.read_text(encoding="utf-8")):
                parser.error(f"Unrecognized directory; will not move it: {path}")
            moves.append(path)
    marketplace = root / ".agents/plugins/marketplace.json"
    data = None
    if not args.project:
        reject_symlink_components(marketplace)
    if not args.project and marketplace.is_file():
        data = json.loads(marketplace.read_text(encoding="utf-8"))
        if not isinstance(data, dict) or not isinstance(data.get("plugins"), list):
            parser.error("Personal marketplace must contain a plugins array")
        for entry in data["plugins"]:
            if not isinstance(entry, dict):
                parser.error("Personal marketplace contains a non-object entry")
        if not any(e.get("name") == "spec-prosecutor" for e in data["plugins"]):
            data = None
    for path in moves:
        print(f"Back up standalone Skill: {path}")
    if data is not None:
        print(f"Back up and remove only the old spec-prosecutor catalog entry: {marketplace}")
    if not moves and data is None:
        print("No legacy installations to migrate.")
        return
    if not args.apply:
        print("Dry-run only. Install and verify the native plugin first, then rerun with --apply.")
        return
    backup_parent = root / (".spec-prosecutor-backups" if args.project else ".local/share/spec-prosecutor/backups")
    backup_parent.mkdir(parents=True, exist_ok=True)
    backup = Path(tempfile.mkdtemp(prefix="legacy-", dir=backup_parent))
    if data is not None:
        shutil.copy2(marketplace, backup / "marketplace.json")
    for path in moves:
        destination = backup / path.relative_to(root)
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(str(path), destination)
    if data is not None:
        data["plugins"] = [e for e in data["plugins"] if e.get("name") != "spec-prosecutor"]
        # Atomic config replacement; preserve unrelated entries and file permissions.
        with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=marketplace.parent,
                                         prefix=".migration-", delete=False) as stream:
            json.dump(data, stream, ensure_ascii=False, indent=2)
            stream.write("\n")
            staged = Path(stream.name)
        staged.chmod(marketplace.stat().st_mode & 0o777)
        staged.replace(marketplace)
    print(f"Recoverable backup: {backup}")
    print("Restart the host or start a new session to use the native plugin.")


if __name__ == "__main__":
    main()
