# GitHub Direct Install

This repository is structured to be compatible with the open Agent Skills ecosystem.

The common installation flow is:

```bash
npx skills add <owner>/<repo> --skill spec-prosecutor -a claude-code -a codex -a cursor
```

You can also target one agent at a time:

```bash
npx skills add <owner>/<repo> --skill spec-prosecutor -a claude-code
npx skills add <owner>/<repo> --skill spec-prosecutor -a codex
npx skills add <owner>/<repo> --skill spec-prosecutor -a cursor
```

## Why This Works

The `skills` CLI discovers skills from repository locations such as:

- repository root if it contains `SKILL.md`
- `skills/`

`Spec Prosecutor` uses:

```text
skills/spec-prosecutor/
  SKILL.md
  agents/openai.yaml
  references/
```

That matches the standard Agent Skills repository pattern used by GitHub-installable skill repositories.

## Hook-Based Hard Gate

This repository now also includes:

- `.claude-plugin/plugin.json`
- `.cursor-plugin/plugin.json`
- `hooks/hooks.json`
- `hooks/hooks-cursor.json`
- `hooks/user-prompt-gate`

Those assets are intended to support a hard-gated auto mode on hosts that honor plugin hooks.
The gate phrase is:

`启动sp`

In hook-enabled installs:

- prompts containing the trigger phrase can arm Spec Prosecutor automatically
- prompts that explicitly ask for `spec-prosecutor` without the phrase can be blocked

## Current Limitation

Replace `<owner>/<repo>` with the real public GitHub repository only after this project is published there.
Before publication, use the local install flows documented in this directory.
