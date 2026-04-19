# Spec Prosecutor For Codex

This file is a compatibility guide.
The plugin-native source of truth lives in `skills/spec-prosecutor/`.

## Purpose

Review one explicitly referenced Markdown PRD before implementation starts.

## Operating Rules

- Read only the provided Markdown file by default.
- Judge implementation readiness, not business value.
- Report aggressively, but separate confirmed issues from probable risks.
- Use prosecutor framing in headings and professional language in explanations.

## Required Charge Categories

- Ambiguity
- Vagueness
- Inaccurate Definition
- Missing Scenarios
- Unverifiable Requirement
- Missing Implementation Dependency

## Required Severity Levels

- Blocker
- High Risk
- Notice

## Required Report Structure

- Indictment Summary
- Blockers
- High Risk Items
- Notices
- Category Summary
- Questions To Confirm Immediately

## Finding Format

For each finding include:

- source excerpt
- charge
- severity
- assessment
- problem
- implementation risk
- follow-up question

Assessment rules:

- `Confirmed Issue`: the source text directly creates the problem
- `Likely Risk`: the risk is inferred from an omission or wording gap

Output rules:

- keep report section order fixed
- include severity explicitly inside each finding
- prefer 3 to 7 immediate confirmation questions
- merge near-duplicate findings instead of counting them repeatedly
