# Claude Code Installation

From this repository:

```bash
bash bin/spec-prosecutor add --claude-code --project /path/to/project
```

Or copy the complete `skills/spec-prosecutor/` folder into the project's `.claude/skills/`. For user-wide use, copy it into `~/.claude/skills/` instead.

Invoke `/spec-prosecutor` with a document or directory. Native plugin installs may use `/spec-prosecutor:spec-prosecutor`. Natural-language PRD review requests and `启动sp` are also supported; no hook or extra password is needed. `agents/openai.yaml` is Codex metadata, not a Claude dependency.

Existing CLI users can run `spec-prosecutor on --claude-code` or `spec-prosecutor off --claude-code`; add `--project /path/to/project` for a project-scoped installation.

[Official Claude Code documentation](https://code.claude.com/docs/en/skills)
