# Review Contract

## Evidence before findings

A finding must change implementation, acceptance, scope or responsibility in a concrete way. Describe a triggering scenario and its consequence; omit stylistic preferences and generic best-practice checklists.

Classify assessment separately from severity:

- **Confirmed Issue**: evidence demonstrates incompatible effective rules, an incorrect calculation, an impossible transition, or materially different interpretations of an explicitly required behavior. Quote the relevant text and show the contradiction or alternatives.
- **Likely Risk**: a plausible gap depends on an assumption, missing external contract or uncertain scope. State that dependency. Not finding a rule in one paragraph does not prove it is absent from the requirements.

A fact that needs external verification stays unverified until an authoritative source is available. Do not make legal, payment-network or hardware claims from memory.

## Scope and authority

For a directory, record the entry documents, effective scope, reference hierarchy and excluded versions. Look for definitions in the authoritative owner document before reporting them missing from a summary or another client.

A draft differing from an effective rule is not itself a contradiction. A recorded open decision is a **known pending decision**, not a newly discovered error. Assess its impact and affected phase; report an additional issue only if its consequences or inconsistencies are not already captured. If two current sources disagree without a declared precedence, report the unresolved conflict.

A prototype can expose a requirement mismatch, but demo data, simplifications and incomplete UI do not prove the PRD is wrong. Do not report missing backend security in an explicitly local mockup as a PRD defect.

## Severity

- **Blocker**: the affected core flow or acceptance cannot be determined, or conflicting rules permit concrete loss, unauthorized access or an irreversible wrong action. State exactly which flow is blocked; do not mark the entire project blocked automatically.
- **High Risk**: the flow can proceed, but a specific edge, state or authority gap is likely to cause inconsistent behavior or substantial rework.
- **Notice**: a localized, lower-impact ambiguity or traceability issue with a demonstrated consequence.

A low-confidence concern does not become a Blocker merely because its domain involves money or permissions. An acknowledged open dependency can block its affected integration phase without invalidating unrelated work.

## Output

Each finding includes a stable ID, category, severity, assessment, source locations and short excerpts, problem, triggering scenario/implementation risk, and a concrete clarification question. Cite both sides of a conflict. Use actual file lines, headings, document pages or table cells; never invent locations. For pasted text, cite its heading/paragraph.

Use the user's language. English enum names may be retained alongside translated labels. Keep the existing summary → severity groups → category counts → questions structure, adding coverage and known pending decisions as in the template. Prosecutor flavor is optional and confined to headings.

Count unique findings, not excerpts. Use one primary category per finding so counts reconcile. Do not force every category to appear or require a minimum number of findings/questions. If no issue is substantiated, say so within the reviewed scope.

Implementation readiness is Low / Medium / High, or **Not assessed** for insufficient coverage. Explain the affected scope and outstanding gates. This is a review judgment, not an implementation certification.

Do not rewrite the PRD or decide unresolved business rules on the user's behalf. If a minimal wording suggestion is useful, label assumptions and alternatives explicitly.
