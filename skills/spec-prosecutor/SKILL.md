---
name: spec-prosecutor
description: Review one explicitly provided Markdown PRD before implementation starts. Finds ambiguity, vagueness, inaccurate definitions, missing scenarios, unverifiable requirements, and missing implementation dependencies, then outputs a structured prosecutor-style report for engineers.
---

# Spec Prosecutor

Use this skill when the user wants to review a PRD or requirement document before coding.

## Inputs

- One Markdown requirement document explicitly provided by the user

## Workflow

1. Read the target Markdown file only.
2. Review it using `references/checklists.md`.
3. Follow the behavior contract in `references/contract.md`.
4. Apply activation behavior from `references/modes.md` when the installed package is configured for auto mode.
5. Produce a report using `references/report-template.md`.

## Activation Modes

- Off mode: disabled. Do not activate or review.
- On mode: activate only when the prompt contains the exact phrase `启动sp`.
- In either mode, review only one explicitly provided Markdown PRD unless the user expands scope.

Mode preamble:

- In `on` mode, start the response with: `Spec Prosecutor 已启动。接下来，这份 PRD 将失去被含糊其辞保护的权利。`

## Review Rules

- Focus on implementation readiness.
- Prefer aggressive coverage over conservative omission.
- For every finding include: `source_excerpt`, `charge`, `severity`, `assessment`, `problem`, `implementation_risk`, `follow_up_question`.
- Use `assessment = Confirmed Issue` when the source text directly supports the problem.
- Use `assessment = Likely Risk` when the problem is inferred from a wording or coverage gap.
- Keep prosecutor flavor in headings only; keep body text professional.

## Required Charge Categories

- Ambiguity
- Vagueness
- Inaccurate Definition
- Missing Scenarios
- Unverifiable Requirement
- Missing Implementation Dependency
- Unclosed Interaction Details
- Data Structure & Field Definition
- Performance & Capacity Requirements
- Security & Permission Requirements
- Compatibility & Migration Requirements

## Required Severity Levels

- Blocker
- High Risk
- Notice

## Required Output

Include:

- indictment summary
- blockers
- high risk items
- notices
- category summary
- questions to confirm immediately

Additional output rules:

- Keep the mode preamble as the first line before the report body.
- Keep section order fixed.
- Include `Severity` explicitly inside each finding, even when the finding already sits under a severity section.
- Prefer 3 to 7 items in `Questions To Confirm Immediately`.
- Merge duplicate findings that point to the same implementation gap.

## Do Not

- rewrite the whole PRD unless asked
- scan unrelated files unless the user expands scope
- invent missing rules and state them as settled facts
