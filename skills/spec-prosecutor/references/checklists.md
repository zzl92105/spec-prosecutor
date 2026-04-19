# Review Checklist

## Charge Categories

### 1. Ambiguity

Look for text that supports multiple reasonable implementations.

Signals:

- unclear subjects or objects
- undefined pronouns like "it", "this", "that"
- overloaded terms
- timing/order words without sequence definition
- interaction modes not closed, such as search vs select, exact match vs fuzzy match, single-select vs multi-select

### 2. Vagueness

Look for language that sounds directional but is not actionable.

Signals:

- "support"
- "optimize"
- "reasonable"
- "timely"
- "properly"
- "as needed"
- "if necessary"
- "can search"
- "can filter"
- "support multiple conditions"
- "show relevant options"

### 3. Inaccurate Definition

Look for business terms, states, or entities that appear precise but lack operational definition.

Signals:

- "active user"
- "effective store"
- "valid coupon"
- "successful submission"
- "abnormal order"

Check whether the document defines:

- inclusion
- exclusion
- state transition
- source of truth
- input method
- matching rule
- option cardinality
- required vs optional constraint



### 4. Missing Scenarios

Look for omitted paths around the main flow.

Signals:

- empty state
- failure state
- retry path
- timeout
- partial success
- rollback
- duplicate submission
- permission denied
- offline or delayed data
- no-result search
- too-many-results option loading
- option list loading failure
- selected value no longer valid
- conflicting filter combinations
- default filter on first load
- reset after refresh or navigation back

### 5. Unverifiable Requirement

Look for requirements that cannot be tested objectively.

Signals:

- no expected output
- no acceptance threshold
- no visible user behavior
- adjectives without measurable criteria
- search or filter behavior named without observable matching rules
- input control named without deterministic interaction behavior

For list retrieval and filtering, check whether QA could verify:

- what input produces what result set
- whether matching is case-sensitive
- whether whitespace, aliases, or partial text should match
- when filter application takes effect: instant, on blur, or on submit
- what happens when a required filter is left empty

### 6. Missing Implementation Dependency

Look for external requirements the engineer would need but cannot infer safely.

Signals:

- missing API contract
- missing field mapping
- missing event source
- missing role/permission matrix
- missing config or feature flag rules
- missing ownership for upstream data
- missing option source for filters
- missing dictionary or enum definition for dropdown values
- missing query parameter contract for search and filtering
- missing pagination, sorting, or default ordering dependency

### 7. Unclosed Interaction Details

Look for unclosed interaction details in lists, searches, filters, and selection behaviors that prevent precise implementation.

#### A. Search and Filter Requirements

Look for filter and search requirements with undefined interaction behavior.

Signals:

- filter named but required or optional status not stated
- query method not defined: dropdown, search-select, tree-selector, free-input, or other control type
- input control not defined: Input, Select, DatePicker, Cascader, TreeSelect, AutoComplete
- match mode not defined: exact match, prefix match, fuzzy match, full-text match, or other matching strategy
- single-select or multi-select not defined
- filter combination rules not defined: `AND`, `OR`, mixed rules, or conditional logic
- default values, reset behavior, and empty selection behavior not defined
- filter application timing not defined: instant (on change), on blur, on submit button click, or other trigger
- filter dependency relationships not defined: whether one filter enables/disables or filters another

For each search or filter requirement, check whether QA could verify:

- what input produces what result set
- whether matching is case-sensitive
- whether whitespace, aliases, or partial text should match
- when filter application takes effect: instant, on blur, or on submit
- what happens when a required filter is left empty

#### B. List Display Requirements

Look for list requirements with undefined display and interaction behavior.

Signals:

- sort rules not defined: default sort order, sortable fields, sort direction (ascending/descending)
- pagination method not defined: cursor-based, page-number-based, infinite scroll, or load-more button
- page size not defined for paginated lists
- load-more trigger conditions not defined (scroll threshold, button click)
- empty state presentation not defined (what users see when list has zero items)
- loading state not defined (skeleton, spinner, or placeholder)
- loading failure state not defined (error message, retry button, or fallback)
- no-result state not defined when search/filter returns empty results
- list item click behavior not defined (navigate, expand, select, or open modal)
- row selection behavior not defined (click row, checkbox, or radio button)
- list refresh strategy not defined (auto-refresh interval, manual refresh, or real-time updates)

#### C. Selection and Operation Requirements

Look for selection and operation requirements with undefined interaction details.

Signals:

- selection state representation not defined: Radio (single), Checkbox (multi), Toggle, or custom state
- operation button position and timing not defined: inline, hover, action column, right-click context menu, or toolbar
- confirmation mechanism not defined: direct operation, secondary confirmation, modal confirmation, or undo option
- batch operation method not defined (select all, checkbox selection, or other selection mechanism)
- post-operation state refresh strategy not defined (auto-refresh, manual refresh, or stay in current state)
- operation feedback not defined (success message, progress indicator, or silent completion)
- operation cancellation not defined (allow cancellation, cancellation timeout, or irreversible operations)

### 8. Data Structure & Field Definition

Look for entity and field definitions that lack technical details needed for implementation.

Signals:

- entity mentioned without field list (e.g., "user", "order", "product")
- field mentioned without data type (string, int, float, boolean, date, datetime, json, array)
- field mentioned without length limit
- field mentioned without required/optional constraint
- field mentioned without default value
- field mentioned without validation rules (regex, enum, range)
- field mentioned without uniqueness constraint
- field mentioned without index requirement
- entity relationships not defined (one-to-one, one-to-many, many-to-many)

For each entity and field requirement, check whether the document defines:

- complete field list with data types
- field length constraints (varchar(255), int(11), etc.)
- required vs optional status for each field
- default values for optional fields
- validation rules (email format, regex pattern, numeric range, enum options)
- unique constraints (which fields must be unique)
- index requirements (which fields should be indexed)
- primary key definition
- foreign key relationships and cascade rules

### 9. Performance & Capacity Requirements

Look for performance and capacity requirements that lack measurable metrics.

Signals:

- "high performance", "fast response", "low latency"
- "support high concurrency", "high throughput"
- "optimize performance", "improve experience"
- "instant load", "smooth experience", "fast"
- "scale", "handle large data"
- performance claims without specific numbers

For each performance requirement, check whether the document defines:

- response time thresholds (e.g., 95% requests < 500ms, P99 < 1s)
- concurrent user count (e.g., support 1000 concurrent users)
- QPS/TPS requirements (e.g., 5000 queries per second)
- data volume limits (e.g., support 1M records)
- load time targets (e.g., first paint < 1s, LCP < 2.5s)
- caching strategy (which data to cache, TTL, eviction policy)
- lazy loading or pagination strategy to avoid loading large datasets
- database query optimization requirements (index usage, query query complexity limits)

### 10. Security & Permission Requirements

Look for security and permission requirements that lack technical specifications.

Signals:

- "need login", "require permission"
- "sensitive information", "confidential"
- "prevent malicious operations", "security"
- "audit", "trace", "log"
- security claims without specific mechanisms

For each security requirement, check whether the document defines:

- authentication method (Token, Session, OAuth2, JWT, SAML)
- authorization granularity (page-level, feature-level, data-level, row-level)
- data encryption requirements (which fields to encrypt at rest, encryption algorithm)
- transport encryption requirements (HTTPS, TLS version, certificate pinning)
- permission matrix (which roles can access which resources)
- audit logging requirements (which operations to log, retention period, log format)
- sensitive information handling (data masking, redaction, anonymization)
- protection measures (SQL injection prevention, XSS prevention and CSRF protection, rate limiting)

### 11. Compatibility & Migration Requirements

Look for compatibility and migration requirements that lack specific strategies.

Signals:

- "upgrade", "migrate"
- "compatible", "smooth transition"
- "backward compatible"
- migration claims without specific procedures

For each compatibility or migration requirement, check whether the document defines:

- database schema migration strategy (add field with NULL, then populate, then make required)
- API version control (v1/v2 compatibility period, deprecation timeline)
- frontend compatibility (legacy browser support, polyfill requirements)
- business rule change impact scope (which existing behavior changes)
- rollback strategy (what to do if migration fails)
- feature flag or gradual rollout strategy (percentage-based, A/B testing)
- data migration scripts and validation
- downtime requirements or zero-downtime migration approach

## Severity Heuristics

### Blocker

- Main flow cannot be implemented safely
- Core object or rule undefined
- Acceptance basis missing
- Required dependency absent

### High Risk

- Main flow mostly inferable but side effects likely wrong
- Boundary behavior missing
- Terminology likely inconsistent across teams

### Notice

- Low impact clarity issue
- Weak wording likely to create later debate

## Assessment Heuristics

### Confirmed Issue

Use when the source text itself directly creates the issue.

Typical cases:

- a term is used but not defined
- a requirement is phrased too vaguely to implement
- a measurable acceptance rule is missing from an explicitly required behavior
- a branch condition is referenced but not enumerated
- a filter lacks match mode, control type, or single/multi-select definition
- a search field is named but required/optional status is not stated
- a list requirement lacks pagination, sort, or state transition definition
- an entity is mentioned but field list, data types, or constraints are not defined
- performance is claimed but no measurable metrics are provided
- security is mentioned but authentication, authorization, or encryption methods are not specified
- migration or compatibility is mentioned but specific strategies are not defined

### Likely Risk

Use when the source text implies a likely implementation problem, but the exact gap is inferred rather than directly stated.

Typical cases:

- a dependency is probably required but not named
- an omitted edge case will likely matter in implementation
- a governance or analytics need suggests missing event or storage design
- a vague optional phrase such as "if needed" hides unresolved scope
- a filter probably depends on upstream dictionaries, but no source is named
- a list workflow likely needs reset, default, and invalid-selection handling, but none are specified
- entity fields probably have validation rules or constraints, but none are specified
- performance optimization or caching is likely needed, but no strategy is specified
- data encryption or access control is likely required, but no details are provided
- database migration or API versioning is likely needed, but no plan is specified

## Final Pass

Before finalizing a report, check:

- Did any `Likely Risk` get presented as a settled fact?
- Did any `Confirmed Issue` actually depend on unstated assumptions?
- Did repeated wording gaps get merged instead of counted multiple times?
- Are the immediate follow-up questions concrete enough to force a decision?

## Question Writing Rules

Good follow-up questions should:

- be answerable
- force a specific decision
- avoid broad open-ended phrasing
- tie directly to one implementation risk

For unclosed list and filter requirements, prefer questions like:

- "When searching by store name, should matching be exact, prefix-based, or fuzzy?"
- "For plant selection, should the control be a free-text input, dropdown, or searchable selector?"
- "Is plant filter single-select or multi-select?"
- "Which filters are mandatory before query execution, and which are optional?"
- "When multiple filters are filled, should the backend combine them with `AND` or `OR`?"

Bad:

- "Can you clarify this?"

Good:

- "What exact conditions make a user count as active for this rule: login in last 30 days, any purchase, or both?"
