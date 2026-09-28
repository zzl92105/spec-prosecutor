# Codex Installation

From this repository:

```bash
bash bin/spec-prosecutor add --codex --project /path/to/project
```

Or copy the complete `skills/spec-prosecutor/` folder into the project's `.agents/skills/`. For user-wide use, copy it into `~/.agents/skills/` instead.

The folder contains `SKILL.md`, `references/`, and optional UI/policy metadata at `agents/openai.yaml`. Keep the whole folder so relative references work. Restart the session if changes are not discovered.

Invoke `$spec-prosecutor` with a document or directory. `启动sp` is an optional alias. No plugin or hook is required.

Existing CLI users can run `spec-prosecutor on --codex` or `spec-prosecutor off --codex`; add `--project /path/to/project` for a project-scoped installation.

[Official Codex documentation](https://learn.chatgpt.com/docs/build-skills)
