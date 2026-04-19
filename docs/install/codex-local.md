# Codex Local Install

`Spec Prosecutor` is structured as a local plugin with one primary skill:

- [skills/spec-prosecutor/SKILL.md](../../skills/spec-prosecutor/SKILL.md)

## Modes

- `off`: disabled mode; the package is installed but should not review
- `on`: hook-armed mode; the trigger phrase must be present, and the bundled hook can gate activation

## Expected Local Layout

Codex local plugins are easiest to manage with this home-directory layout:

```text
~/plugins/spec-prosecutor/
  .codex-plugin/plugin.json
  skills/spec-prosecutor/
```

## Recommended macOS CLI Flow

```bash
bash install.sh
spec-prosecutor init --codex --mode off
spec-prosecutor init --codex --mode on
spec-prosecutor uninstall --codex
```

## Manual Installation Steps

1. Export the plugin payload:

```bash
bash scripts/export-plugin.sh off
bash scripts/export-plugin.sh on
```

2. Choose one exported directory and copy it to your preferred plugin directory, for example `~/plugins/spec-prosecutor/`:

- `dist/codex/off/spec-prosecutor/`
- `dist/codex/on/spec-prosecutor/`

3. Add or merge [marketplace.entry.json](marketplace.entry.json) into `~/.agents/plugins/marketplace.json`.
   Replace `source.path` with the actual absolute plugin directory you chose in step 2.

If `~/.agents/plugins/marketplace.json` does not exist yet, create it first with:

```json
{
  "name": "local-plugins",
  "interface": {
    "displayName": "Local Plugins"
  },
  "plugins": []
}
```

4. Restart or reload Codex. Existing sessions keep the old skill list snapshot.

## Trigger Phrase For On Mode

`启动sp`

## Repo Assets

- Plugin manifest: [/.codex-plugin/plugin.json](../../.codex-plugin/plugin.json)
- Skill UI metadata: [skills/spec-prosecutor/agents/openai.yaml](../../skills/spec-prosecutor/agents/openai.yaml)
- Marketplace entry example: [docs/install/marketplace.entry.json](marketplace.entry.json)
