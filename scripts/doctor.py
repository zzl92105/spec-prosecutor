#!/usr/bin/env python3
"""Read-only diagnosis of old standalone installs and broken personal entries."""
import json
import os
from pathlib import Path

home = Path.home()
for host in (".agents", ".claude"):
    path = home / host / "skills/spec-prosecutor"
    print(f"Standalone {host}: {path} ({'present' if path.exists() else 'absent'})")
market = home / ".agents/plugins/marketplace.json"
if market.is_file():
    try:
        data = json.loads(market.read_text(encoding="utf-8"))
        for entry in data.get("plugins", []):
            if entry.get("name") != "spec-prosecutor":
                continue
            source = entry.get("source", {})
            path = source if isinstance(source, str) else source.get("path")
            if path:
                target = home / path
                print(f"Personal marketplace entry: {target} ({'present' if target.exists() else 'BROKEN'})")
    except (ValueError, OSError, TypeError, AttributeError) as error:
        print(f"Cannot inspect personal marketplace: {error}")
print("Native plugin status: codex plugin list; claude plugin list")
print("Migration and duplicate-install guidance: docs/install/migration.md")
