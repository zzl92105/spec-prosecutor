# Install Notes

Installation assets in this directory are intended for local Codex, Claude Code, and Cursor setup.

## Recommended macOS Flow

If you are on macOS, use the local installer first:

```bash
bash install.sh
spec-prosecutor doctor
```

You can also install the CLI and selected hosts in one step:

```bash
bash install.sh --codex --mode on
bash install.sh --claude-code --mode on
bash install.sh --codex --claude-code --mode on
```

Then initialize the targets you want:

```bash
spec-prosecutor add -g --mode off
spec-prosecutor add -g --mode on
spec-prosecutor add -g --codex --mode off
spec-prosecutor add -g --codex --mode on
spec-prosecutor add --agent cursor --mode off --cursor-workspace /path/to/project
spec-prosecutor add --agent cursor --mode on --cursor-workspace /path/to/project
```

Natural mode switching is also supported:

```bash
spec-prosecutor on -g
spec-prosecutor on --codex
spec-prosecutor 开启 --agent cursor --cursor-workspace /path/to/project

spec-prosecutor off -g
spec-prosecutor off --codex
spec-prosecutor 关闭 --agent cursor --cursor-workspace /path/to/project
```

To remove them again:

```bash
spec-prosecutor remove -g
spec-prosecutor remove --codex
spec-prosecutor remove --codex --claude-code --cli
spec-prosecutor remove --all --cli
spec-prosecutor remove --agent cursor --cursor-workspace /path/to/project
```

## Modes

- `off`: disabled mode; do not review and do not activate
- `on`: armed auto mode, but only activates when the prompt contains `启动sp`

## Included

- [claude-code.md](claude-code.md)
- [codex-local.md](codex-local.md)
- [cursor.md](cursor.md)
- [github-direct.md](github-direct.md)
- [homebrew.md](homebrew.md)
- [publish-checklist.md](publish-checklist.md)
- [marketplace.entry.json](marketplace.entry.json)
