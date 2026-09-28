# Activation Modes

The source skill and default exports are **on** (enabled).

- Codex: `$spec-prosecutor <file-or-directory>`.
- Claude Code: `/spec-prosecutor <file-or-directory>`; a plugin may use `/spec-prosecutor:spec-prosecutor`.
- Natural-language PRD review requests and the legacy alias `启动sp` are supported. The alias is not a mandatory gate. Merely discussing installation or mentioning the name is not a review request.
- `off` exports contain a disabled entrypoint. They do not review and explain how to enable the skill. Codex also receives `allow_implicit_invocation: false` in that export.

No hook is required to use the skill. Installed host settings still control discovery and permissions. Enabling a skill does not authorize modifying reviewed documents.
