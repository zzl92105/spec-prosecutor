# Activation Modes

The source Skill is enabled. Native plugin activation is controlled by the host plugin manager. The legacy standalone exports additionally support `on` and `off`; those CLI switches do not control a native plugin.

- Codex: `$spec-prosecutor <file-or-directory>`.
- Claude Code: `/spec-prosecutor:spec-prosecutor <file-or-directory>` for a native plugin; `/spec-prosecutor` for a standalone copy.
- Natural-language PRD review requests and the legacy alias `启动sp` are supported. The alias is not a mandatory gate. Merely discussing installation or mentioning the name is not a review request.
- `off` exports contain a disabled entrypoint. They do not review and explain how to enable the skill. Codex also receives `allow_implicit_invocation: false` in that export.

No hook is required to use the skill. Installed host settings still control discovery and permissions. Enabling a skill does not authorize modifying reviewed documents.
