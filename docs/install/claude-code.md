# Claude Code Install

`Spec Prosecutor` can be installed in Claude Code as a folder-based skill.

For hard-gated auto mode like `caveman`, prefer the GitHub/plugin installation path once this repository is published, because that path can include bundled hooks.

## Modes

- `off`: disabled mode
- `on`: auto mode gated by the exact phrase `启动sp`

## Expected Local Layout

```text
~/.claude/skills/spec-prosecutor/
  SKILL.md
  references/
```

## Recommended macOS CLI Flow

```bash
bash install.sh
spec-prosecutor init --claude-code --mode off
spec-prosecutor init --claude-code --mode on
spec-prosecutor uninstall --claude-code
```

## Manual Installation Steps

1. Export the Claude Code package:

```bash
bash scripts/export-claude-code-skill.sh off
bash scripts/export-claude-code-skill.sh on
```

2. If `~/.claude/skills/` does not exist yet, create it.

3. Copy one exported variant to `~/.claude/skills/spec-prosecutor/`:

- `dist/claude-code/off/spec-prosecutor/`
- `dist/claude-code/on/spec-prosecutor/`

4. Restart or reload Claude Code so the new skill is discovered.

## Trigger Phrase For On Mode

`启动sp`

## Repo Assets

- Source skill: [skills/spec-prosecutor/SKILL.md](../../skills/spec-prosecutor/SKILL.md)
- Claude guide: [docs/platform-guides/claude-code.md](../platform-guides/claude-code.md)
