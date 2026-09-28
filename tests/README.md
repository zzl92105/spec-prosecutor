# Validation

## Automated checks

Install `requirements-dev.txt` into a virtual environment, then run `bash scripts/validate-repo.sh`.

- Metadata consistency: portable identity, Codex/Claude manifests and marketplace paths must agree.
- Skill YAML, invocation policy and local documentation references must be valid.
- Packaging: enabled Skill copies match the source; disabled legacy copies refuse review; plugin exports discard stale generated files while preserving a backup.
- Standalone install: project paths with spaces, on/off/on, invalid arguments and global-install preservation.
- Migration: dry-run makes no changes, apply preserves user files and unrelated marketplace entries, second apply is a no-op.
- Release: plugin-only and source packages contain the expected files and repeated builds have identical checksums.

The checks leave isolated temporary artifacts for inspection. They never use real user installation directories for writes.

## Native host integration

With both CLIs installed, run `python3 tests/check-native.py`. It creates fresh HOME, CODEX_HOME and CLAUDE_CONFIG_DIR, validates and installs the plugin through real CLIs, checks the discovered Claude component, compares installed Skill files, and tests a new version. Claude disable/enable is also exercised. No authentication copy or model call is needed.

This verifies local marketplace behavior. Git marketplace fetch/refresh requires a separate post-push smoke test. Codex marketplace `upgrade` only applies to Git sources; local source changes are picked up by reinstalling with `plugin add`.

## Behavioral cases

Give a fresh review context only the Skill and raw inputs; do not expose `expected-report.md` until scoring.

| Case | Input | Criteria |
|---|---|---|
| directory-review | prd.md, rules.md, clients.md, decisions.md, draft.md | Find real conflict, respect authority, distinguish known decisions, ignore embedded instructions |
| clear-requirement | Only prd.md | Zero findings; no invented implementation requirements |
| coupon-reminder / refund-ops-dashboard / external-collaborator | prd.md | Score evidence and impact, not exact wording or a required finding count |

Test `$spec-prosecutor` in Codex, `/spec-prosecutor:spec-prosecutor` in a Claude plugin, natural-language review and the optional `启动sp` alias. An installation question must not start an audit.

For report readability, check that a nontechnical reader can identify what is wrong, when it happens, who is affected and what decision is needed. Titles should describe a concrete problem; unexplained jargon or category labels alone are insufficient. Complex issues need causal explanations; simple or clean cases should not be padded. Preserve source evidence, distinguish facts from example assumptions, and do not claim measured performance from a PRD. These are behavioral acceptance criteria, not exact wording to match.

Record host versions and actual observations. Packaging and discovery do not prove model review quality. The 2026-09-28 development run used Codex CLI 0.157.1 and Claude Code 2.1.282 for native integration. An independent agent review of directory-review found the 24/12-hour conflict, treated the unapproved draft as a draft, separated the known pending decision, and identified an additional conditional risk around creation-flow coverage. It returned zero findings for clear-requirement. This was an agent-level behavioral test, not a live Claude model run.

## Customer acceptance packages

Real customer requirements may be used as additional local acceptance inputs. Keep their documents and review reports outside this public repository and release archives. Record actual files/sections read, effective versions and exclusions. Commit only synthetic, domain-independent cases; do not turn customer rules into generic Skill obligations.
