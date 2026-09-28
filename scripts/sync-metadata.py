#!/usr/bin/env python3
"""Generate host manifests and catalogs from the portable plugin manifest."""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PLUGIN = ROOT / "plugins/spec-prosecutor"
MARKETPLACE = "spec-prosecutor-marketplace"


def generated_files():
    manifest = json.loads((PLUGIN / "plugin.json").read_text(encoding="utf-8"))
    identity = {k: v for k, v in manifest.items() if k not in ("$schema", "extensions")}
    codex = dict(identity, skills="./skills/", **manifest["extensions"]["com.openai"])
    entry = {
        "name": manifest["name"],
        "source": {"source": "local", "path": "./plugins/spec-prosecutor"},
        "policy": {"installation": "AVAILABLE", "authentication": "ON_INSTALL"},
        "category": "Productivity",
    }
    return {
        PLUGIN / ".codex-plugin/plugin.json": codex,
        PLUGIN / ".claude-plugin/plugin.json": identity,
        ROOT / ".agents/plugins/marketplace.json": {
            "name": MARKETPLACE,
            "interface": {"displayName": "Spec Prosecutor"},
            "plugins": [entry],
        },
        ROOT / ".claude-plugin/marketplace.json": {
            "name": MARKETPLACE,
            "owner": manifest["author"],
            "metadata": {"description": "General-purpose PRD review for Codex and Claude Code"},
            "plugins": [{"name": manifest["name"], "source": "./plugins/spec-prosecutor",
                         "version": manifest["version"], "description": manifest["description"]}],
        },
        ROOT / "docs/install/marketplace.entry.json": entry,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    stale = []
    for path, data in generated_files().items():
        expected = json.dumps(data, indent=2, ensure_ascii=False) + "\n"
        if args.check:
            if not path.is_file() or path.read_text(encoding="utf-8") != expected:
                stale.append(str(path.relative_to(ROOT)))
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(expected, encoding="utf-8")
    if stale:
        parser.exit(1, "Metadata drift; run python3 scripts/sync-metadata.py:\n" + "\n".join(stale) + "\n")
    print("Host manifests and marketplaces are synchronized.")


if __name__ == "__main__":
    main()
