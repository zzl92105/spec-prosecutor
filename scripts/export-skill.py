#!/usr/bin/env python3
"""Export the same portable skill for both hosts and the plugin bundle."""
import argparse
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def export_skill(destination, mode):
    source = ROOT / "skills/spec-prosecutor"
    destination = Path(destination).resolve()
    if destination == source.resolve() or source.resolve() in destination.parents:
        raise ValueError("Export destination must not overwrite skill sources")
    shutil.copytree(source, destination, dirs_exist_ok=True)
    legacy_readme = destination / "README.md"
    if legacy_readme.exists():
        legacy_readme.write_text(
            f"# Spec Prosecutor\n\nExport mode: {mode}. "
            "See SKILL.md and references/modes.md for current usage.\n",
            encoding="utf-8",
        )
    if mode == "off":
        (destination / "SKILL.md").write_text(
            "---\nname: spec-prosecutor\n"
            "description: Spec Prosecutor is disabled; explain how to enable it when explicitly invoked.\n"
            "---\n\n# Spec Prosecutor\n\n"
            "Spec Prosecutor is disabled in `off` mode. Do not review requirements. "
            "Explain that the user can reinstall the on export or run "
            "`spec-prosecutor on` with the same host and project options.\n",
            encoding="utf-8",
        )
        metadata = destination / "agents/openai.yaml"
        metadata.write_text(metadata.read_text(encoding="utf-8").replace(
            "allow_implicit_invocation: true", "allow_implicit_invocation: false"
        ), encoding="utf-8")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("destination", type=Path)
    parser.add_argument("mode", choices=("on", "off"))
    args = parser.parse_args()
    export_skill(args.destination, args.mode)
