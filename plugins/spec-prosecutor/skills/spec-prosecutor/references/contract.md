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

Use the user's language and plain, neutral headings. Keep the summary → coverage → severity groups → category counts → known decisions → questions structure. Present severity as practical advice: Blocker = 需要先解决, High Risk = 容易造成错误或返工, Notice = 建议补充. Present confidence separately: Confirmed Issue = 已确认的问题, Likely Risk = 还需确认的风险. Translate these labels for other languages. Retain English enum names only when the user or a consuming format needs them. Do not default to courtroom language such as indictment or accusation.

## Explain findings in everyday language

Write for readers who know their business but may not know software terminology. Lead with a concrete consequence, such as “用户可能付了钱，却没有订单”, instead of an abstract label such as “交易链路一致性缺失”. When a technical term is necessary, explain it at first use; for example, “重复请求只处理一次（幂等）”.

For each finding, connect the evidence to the outcome: what the requirement currently says → the specific situation where it stops being clear or consistent → the different results people could implement → who would be affected and how → the decision needed. A label like “边界不清”“存在性能风险” or a clarification question alone is not an explanation.

Give enough context that the reader can understand the issue without opening every cited file, while retaining precise references and brief excerpts for verification. Explain one plausible scenario in ordinary language where useful. Mark invented scenarios as examples or assumptions; never present illustrative data volumes, timings, losses or user behavior as facts from the PRD.

Use short connected paragraphs and direct questions. Expand complicated findings enough to explain the causal steps; keep simple findings short and respect an explicit request for a brief report. Do not pad every issue to a fixed length, repeat the same explanation in multiple fields, exaggerate consequences, or invent findings to make the report look thorough.

When suggesting a clarification, offer alternatives only if they help the reader decide, and explain their different user-visible outcomes. Do not select a business rule on the user's behalf. Missing information should remain explicit, not be filled with a confident guess.

For performance findings, explain the requested workload or promise, the condition that makes it uncertain, and what evidence is missing. Distinguish a requirement that cannot be tested as written from an implementation that might be slow. Do not claim a confirmed bottleneck, slow SQL, memory leak or actual concurrency limit from PRD text alone; identify when code inspection, measurements or load testing would be needed.

Count unique findings, not excerpts. Use one primary category per finding so counts reconcile. Do not force every category to appear or require a minimum number of findings/questions. If no issue is substantiated, say so within the reviewed scope.

Implementation readiness is Low / Medium / High, or **Not assessed** for insufficient coverage. Explain the affected scope and outstanding gates. This is a review judgment, not an implementation certification.

Do not rewrite the PRD or decide unresolved business rules on the user's behalf. If a minimal wording suggestion is useful, label assumptions and alternatives explicitly.
