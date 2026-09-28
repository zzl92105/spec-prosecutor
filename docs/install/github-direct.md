# Source Installation

The portable skill source is `skills/spec-prosecutor/` in [zzl92105/spec-prosecutor](https://github.com/zzl92105/spec-prosecutor). Use the local working copy for unreleased changes.

Copy this entire folder into your project's `.agents/skills/` (Codex) or `.claude/skills/` (Claude Code). See [installation](README.md) for CLI and user-level options.

The repository also retains plugin manifests for distribution. The skill does not require hooks or a phrase gate. The shared `SKILL.md` uses standard `name` and `description` frontmatter and relative references; `agents/openai.yaml` supplies Codex metadata.
