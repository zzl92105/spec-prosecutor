# Spec Prosecutor Design

## Goal

`Spec Prosecutor` is a PRD review skill/plugin for engineers before implementation starts.

It reviews a single Markdown requirements document explicitly provided by the user and answers one question:

`Is this document clear enough to safely start coding?`

It does not rewrite the PRD, judge business value, or scan the whole repository by default.

## Primary User

- Engineer reading a PRD before writing code

## Trigger Model

- User mentions a Markdown file in chat
- User manually triggers `Spec Prosecutor`
- Tool reads only that file unless the user explicitly expands scope

## Product Positioning

This is not a product-manager writing assistant.
This is an engineering preflight checker for requirement quality.

Its job is to surface places where vague language will become wrong code, missing edge cases, or rework.

## Review Style

Two-layer output style:

- Outer layer: prosecutor framing such as `Indictment Summary`, `Charges`, `Evidence`
- Inner layer: calm and professional engineering language suitable for forwarding to PMs or adding to review notes

## Review Strategy

Default mode is aggressive:

- Prefer over-reporting to under-reporting
- Include both confirmed issues and high-probability risks
- Clearly label uncertain findings as `needs confirmation`

## Charge Categories

Version 1 uses six fixed categories:

1. Ambiguity
2. Vagueness
3. Inaccurate Definition
4. Missing Scenarios
5. Unverifiable Requirement
6. Missing Implementation Dependency

## Severity Levels

Three severity levels:

1. Blocker
2. High Risk
3. Notice

### Blocker

Use when coding should not begin before clarification.

Examples:

- A core object, state, or business rule is undefined
- Two reasonable implementations can be inferred from the same text
- Acceptance criteria for the main behavior are missing
- A required external interface, permission, or data dependency is unspecified

### High Risk

Use when coding could begin, but rework or missing behavior is likely.

Examples:

- Boundary cases are missing
- Error or empty-state behavior is not described
- Terms look precise but would likely be interpreted differently across roles
- Requirements describe intent but not executable behavior

### Notice

Use when the issue may not block implementation but will likely create confusion later.

Examples:

- Weak wording
- Incomplete terminology consistency
- Minor verification gaps

## Report Structure

Recommended report format:

1. Indictment Summary
2. Blockers
3. High Risk Items
4. Notices
5. Category Summary
6. Questions To Confirm Immediately

Each finding should include:

- Source excerpt
- Charge category
- Severity
- Problem statement
- Why it affects implementation
- Suggested follow-up question

## Scope Boundaries

Version 1 should not:

- Rewrite the PRD
- Propose implementation architecture unless directly needed to explain risk
- Infer hidden business rules as facts
- Review unrelated repository files by default

Version 1 may:

- Infer probable risks from wording gaps
- Suggest clarification questions
- Group duplicated findings when repeated throughout the PRD

## Platform Targets

Shared contract, separate thin adapters:

- Claude Code skill
- Codex prompt/profile
- Cursor rules/command

## Proposed Repository Layout

```text
spec-prosecutor/
  .codex-plugin/plugin.json
  skills/spec-prosecutor/
  tests/cases/
  scripts/
  docs/design/
```

## Expansion Paths

Future modes can include:

- `strict`
- `api-prd`
- `frontend-flow`
- `data-feature`

## Success Criteria

The first usable version is successful if an engineer can:

1. Mention one Markdown PRD
2. Trigger the mode manually
3. Receive a structured report with useful pre-implementation questions
4. Forward parts of that report directly to a PM without heavy editing
