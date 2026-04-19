# Cursor Install

`Spec Prosecutor` can be installed in Cursor as a mode/rule document.

For hard-gated auto mode, prefer the GitHub/plugin installation path once this repository is published, because that path can include bundled hooks.

## Modes

- `off`: disabled rule file
- `on`: rule file marked to activate only when the prompt contains `启动sp`

## Expected Local Layout

```text
.cursor/
  rules/
    spec-prosecutor.mdc
```

## Recommended macOS CLI Flow

```bash
bash install.sh
spec-prosecutor init --cursor --mode off --cursor-workspace /path/to/project
spec-prosecutor init --cursor --mode on --cursor-workspace /path/to/project
spec-prosecutor uninstall --cursor --cursor-workspace /path/to/project
```

## Manual Installation Steps

1. Export the Cursor rule:

```bash
bash scripts/export-cursor-rule.sh off
bash scripts/export-cursor-rule.sh on
```

2. If `.cursor/rules/` does not exist yet in the target workspace, create it.

3. Copy one exported variant to `.cursor/rules/spec-prosecutor.mdc` in the target workspace:

- `dist/cursor/off/spec-prosecutor.mdc`
- `dist/cursor/on/spec-prosecutor.mdc`

4. Reload Cursor rules if needed.

## Trigger Phrase For On Mode

`启动sp`

## Repo Assets

- Cursor rule source: [docs/platform-guides/cursor.mdc](../platform-guides/cursor.mdc)
