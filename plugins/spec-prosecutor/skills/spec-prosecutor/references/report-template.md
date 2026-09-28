# PRD Review Report

Use the user's language. The Chinese labels below illustrate the default plain-language style; translate them for other languages. Keep the order, omit empty category rows, and say “未发现” in empty severity groups. Never fill placeholders with invented issues. Explain detailed findings in short paragraphs rather than squeezing them into a wide table.

## 审查结论

- This review's target and effective version/scope.
- State what is clear enough to implement and what still needs a decision, in everyday language. Readiness remains Low / Medium / High / Not assessed internally; show those labels only when needed by the user or consuming format.
- Counts of unique findings: 需要先解决 / 容易造成错误或返工 / 建议补充. These map to Blocker / High Risk / Notice; use the contract's severity definitions, not the wording alone.

## 这次看了哪些材料

- Files/sections actually read and which documents govern when they disagree.
- Historical versions, unapproved drafts, duplicate exports and prototype limitations excluded from current-rule comparisons.
- Unread/unsupported material and unavailable dependencies. Explain how these limit the conclusion; label partial reviews explicitly.

## 需要先解决的问题

## 容易造成错误或返工的问题

## 建议补充的地方

Within the appropriate severity group, use this shape. Replace instructions with actual explanations; scale detail to the issue rather than following a word quota.

### SP-001 — A short title describing the problem in everyday language

**问题类型与判断**: Plain-language category, severity, and 已确认的问题 / 还需确认的风险. Keep severity and confidence separate; retain stable English enums only if required.

**需求现在怎么写的**: Give verified file lines/headings (or pages/cells), short excerpts and the relevant context. Cite both sides of a conflict. For a missing rule, say which relevant sources were checked and where the affected behavior is required.

**哪里说不清，或者对不上**: Explain the contradiction, incorrect result or missing decision. For ambiguity, explain the materially different interpretations. Do not merely repeat a category label.

**什么情况下会遇到**: Walk through one plausible triggering situation when useful. Identify the actor, action and point where behavior becomes uncertain. Explicitly label illustrative assumptions; do not invent source facts.

**会带来什么影响**: Explain the different observable outcomes and who is affected. Keep consequences proportional to the evidence. Combine with the preceding paragraph for simple issues to avoid repetition.

**需要确认什么**: Ask a focused question that resolves the decision. If options help, explain their different outcomes and leave the choice to the user. For performance concerns, distinguish requirement clarification from code or load-test validation.

## 问题分类统计

Count each finding once under its primary category. Totals must match the summary; use understandable translated category labels.

## 文档里已经登记的待确认事项

Reference existing decision IDs, explain which work must wait for them, and do not count them again as newly found defects. Identify an additional consequence only if supported by evidence.

## 建议优先确认的问题

Prioritize by concrete impact and reference finding/decision IDs instead of repeating the full explanation. No minimum count. If none remain within the reviewed scope, say so.
