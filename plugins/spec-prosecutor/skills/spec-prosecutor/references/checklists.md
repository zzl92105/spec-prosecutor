# PRD Review Checklist

Use only applicable checks. A question below is a review aid, not a requirement that every PRD contain every detail. Judge business behavior and acceptance first; implementation choices belong in design unless explicitly constrained.

## Scope, definitions and consistency

- Identify users, goals, included/excluded phases and ownership. Are summaries and detailed rules consistent within the same effective scope?
- Do terms have operational inclusion/exclusion criteria? Are currencies, units, time zones, rounding, date endpoints and numeric boundaries defined where outcomes depend on them?
- Compare shared terms, identifiers, formulas, field meanings and allowed states across documents and clients. Trace links, renamed chapters and authoritative owner documents before alleging an omission.
- Recompute concrete examples. Look for overlapping or uncovered conditions, contradictory constraints and impossible completion criteria.
- Distinguish historical/superseded decisions, unapproved proposals and current commitments. A decision record can resolve an apparent contradiction.

## Actors and permissions

- Who can view, create, edit, approve, cancel, export or perform a sensitive action? On which objects and fields?
- Are tenant, organization, ownership and assigned-object boundaries consistent between list, detail, aggregation and export?
- What happens to active sessions, in-flight work and historical visibility when roles, ownership or status change?
- Ask about authentication/encryption mechanisms only if they are explicit requirements or external constraints. Do not demand an algorithm merely because a PRD mentions security.

## Flows and states

- Trace preconditions, entry events, transitions, result visibility, terminal states and responsible actors.
- Check empty/invalid input, duplicates, retries, concurrency, timeout, partial success, cancellation and recovery where they affect the stated flow.
- Distinguish a request being accepted from an external action succeeding. Who owns retries and how is an uncertain result resolved?
- For offline/device/third-party flows, consider delayed, duplicate and out-of-order events, stale data and reconnect behavior. Do not prescribe a transport or physical capability absent evidence.

## Data and calculations

- Define business-required fields, allowed values, units, defaults, validation and identity where users or integrations depend on them.
- Identify the source of truth and event timing for shared facts, derived totals and audit history.
- Where money or quantities occur, check zero/negative/maximum values, partial operations, rounding and reconciliation, and whether examples match formulas.
- Do not require a complete SQL schema, primary-key strategy, indexes, storage types or database migration scripts in a business PRD.

## Interaction and acceptance

- Can QA derive an observable result for each required behavior? Are success, error and no-result outcomes distinguishable?
- For search/filter/selection, check matching, combinations, required/default values and pagination/sorting only where differing choices affect the promised result.
- Do destructive or costly actions have defined authorization, confirmation/reversal and completion feedback appropriate to their business impact?
- A particular widget, spinner or button location is not mandatory unless the UX contract depends on it.

## Dependencies, capacity and lifecycle

- Are required external capabilities, inputs, owners and unresolved decisions identified? Is a missing dependency actually needed before the affected phase can start?
- For performance promises, are measurement conditions and acceptance thresholds meaningful? Check whether the stated work has an unclear size or frequency (for example, exporting all history, repeatedly refreshing all records, or simultaneous requests) when that affects the promise. Explain the concrete scenario and missing assumptions; hypothetical scale is not evidence of a confirmed bottleneck. Distinguish an untestable requirement from a risk needing code inspection, measurements or load testing. Do not demand QPS, caching or TTL for features with no demonstrated need.
- If existing data/rules/users are affected, is compatibility, effective date and failure/reversal behavior clear? An isolated new feature does not inherently need a migration plan.
- Do retention, deletion, privacy/consent or audit requirements apply to the described data lifecycle? Use supplied policy or verified sources; do not invent compliance obligations.

## Categories

Choose the most specific primary category; retain these labels for existing consumers:
Ambiguity; Vagueness; Inaccurate Definition; Missing Scenarios; Unverifiable Requirement; Missing Implementation Dependency; Unclosed Interaction Details; Data Structure & Field Definition; Performance & Capacity Requirements; Security & Permission Requirements; Compatibility & Migration Requirements.

Also use **Logical Error** for demonstrated calculations/logic errors and **Cross-document Conflict** for incompatible current sources.

## Final pass

Before reporting, try to disprove each finding using the reviewed sources. Check scope/versions, cite evidence, separate severity from certainty, merge the same underlying gap, and keep known pending decisions separate. Ask the smallest question that resolves the concrete implementation fork.
