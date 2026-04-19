# Spec Prosecutor For Claude Code

This file is a compatibility guide.
The plugin-native source of truth lives in `skills/spec-prosecutor/`.

## Purpose

Review one explicitly referenced Markdown PRD before implementation starts.

## Install Shape

Claude Code skills are easiest to consume as a self-contained folder:

```text
~/.claude/skills/spec-prosecutor/
  SKILL.md
  references/
```

## Operating Rules

- Read only the explicitly provided Markdown file by default.
- Judge implementation readiness, not business value.
- Report aggressively, but keep inferred risks labeled.
- Use prosecutor framing in headings and professional language in explanations.

## Required Finding Fields

- source excerpt
- charge
- severity
- assessment
- problem
- implementation risk
- follow-up question

## Assessment Labels

- `Confirmed Issue`
- `Likely Risk`
