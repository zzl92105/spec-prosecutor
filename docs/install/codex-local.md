# Codex Local Install

`Spec Prosecutor` is installed into Codex CLI as a local skill with one primary skill:

- [skills/spec-prosecutor/SKILL.md](../../skills/spec-prosecutor/SKILL.md)

## Modes

- `off`: disabled mode; the skill is installed but should not review
- `on`: phrase-gated mode; the trigger phrase must be present

## Expected Local Layout

Codex local skills are installed with this home-directory layout:

```text
~/.agents/skills/spec-prosecutor/
  SKILL.md
  references/
```

## Recommended macOS CLI Flow

```bash
bash install.sh --codex --mode off
bash install.sh --codex --mode on
spec-prosecutor uninstall --codex --cli
```

## Manual Installation Steps

1. Export the Codex skill payload:

```bash
bash scripts/export-codex-skill.sh off
bash scripts/export-codex-skill.sh on
```

2. Choose one exported directory and copy it to `~/.agents/skills/spec-prosecutor/`:

- `dist/codex-skill/off/spec-prosecutor/`
- `dist/codex-skill/on/spec-prosecutor/`

3. Start a new Codex session. Existing sessions keep the old skill list snapshot.

## Trigger Phrase For On Mode

`启动sp`

## Repo Assets

- Skill source: [skills/spec-prosecutor/SKILL.md](../../skills/spec-prosecutor/SKILL.md)
- Skill UI metadata: [skills/spec-prosecutor/agents/openai.yaml](../../skills/spec-prosecutor/agents/openai.yaml)
- Export script: [scripts/export-codex-skill.sh](../../scripts/export-codex-skill.sh)
