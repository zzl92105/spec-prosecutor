# Spec Prosecutor Report

## Indictment Summary

- Implementation readiness: `Low`
- Blockers: `2`
- High Risk Items: `4`
- Notices: `2`

## Blockers

### 1. `[Inaccurate Definition]` "active users" has no operational definition
- Assessment: `Confirmed Issue`
- Source excerpt: `Active users should receive the reminder in a proper way.`
- Severity: `Blocker`
- Problem: The document uses a business term that appears important to targeting logic, but it does not define the criteria.
- Implementation risk: Engineering cannot determine targeting conditions safely. Different teams may implement different filters.
- Suggested follow-up question: What exact rules define an active user for this feature: recent login, recent order, coupon ownership, or a combination?

### 2. `[Missing Implementation Dependency]` Monitoring requirement has no metrics contract
- Assessment: `Likely Risk`
- Source excerpt: `Relevant teams should be able to monitor reminder effectiveness.`
- Severity: `Blocker`
- Problem: The document requests observability without defining events, metrics, dashboard ownership, or success measures.
- Implementation risk: Engineers cannot know which logs, counters, or event payloads are required before launch.
- Suggested follow-up question: Which metrics and event fields are required to measure reminder effectiveness, and which team owns the dashboard?

## High Risk Items

### 1. `[Vagueness]` "before order submission" lacks trigger timing
- Assessment: `Confirmed Issue`
- Source excerpt: `Support reminding users before order submission.`
- Severity: `High Risk`
- Problem: The phrase does not specify whether the trigger is at cart page, checkout page, submit click, or payment page.
- Implementation risk: Different trigger points can produce materially different UX and data events.
- Suggested follow-up question: At which exact page or user action should the coupon reminder appear?

### 2. `[Vagueness]` "in a proper way" is not implementable
- Assessment: `Confirmed Issue`
- Source excerpt: `Active users should receive the reminder in a proper way.`
- Severity: `High Risk`
- Problem: The expected reminder format is not described.
- Implementation risk: Engineering cannot choose between modal, banner, toast, inline copy, or other presentation safely.
- Suggested follow-up question: What reminder format should be used for each supported client surface?

### 3. `[Missing Scenarios]` "abnormal orders" is referenced but not enumerated
- Assessment: `Confirmed Issue`
- Source excerpt: `For abnormal orders, the reminder strategy should be adjusted accordingly.`
- Severity: `High Risk`
- Problem: The document references a branch condition without listing which abnormal cases are included.
- Implementation risk: Error-handling behavior will be incomplete or inconsistent.
- Suggested follow-up question: Which cases count as abnormal orders for this feature: payment failure, expired coupon, stock shortage, duplicate submission, or others?

### 4. `[Unverifiable Requirement]` "avoid disturbing users too much" has no measurable threshold
- Assessment: `Confirmed Issue`
- Source excerpt: `The system should avoid disturbing users too much.`
- Severity: `High Risk`
- Problem: The requirement expresses intent but does not define frequency caps or suppression rules.
- Implementation risk: QA cannot verify compliance, and engineering cannot implement rate limits confidently.
- Suggested follow-up question: What frequency cap or suppression logic defines acceptable reminder volume?

## Notices

### 1. `[Vagueness]` "more obvious reminder" lacks comparative standard
- Assessment: `Likely Risk`
- Source excerpt: `If the coupon is valid, the page should show a more obvious reminder.`
- Severity: `Notice`
- Problem: The document implies a stronger UI treatment without defining the baseline.
- Implementation risk: UI implementation may vary and trigger later product feedback.
- Suggested follow-up question: What specific visual difference is required when the coupon is valid?

### 2. `[Missing Scenarios]` Retry behavior is underspecified
- Assessment: `Likely Risk`
- Source excerpt: `If needed, the coupon reminder can be retried.`
- Severity: `Notice`
- Problem: The document does not define retry trigger, retry limit, or idempotency rules.
- Implementation risk: Later integration or analytics discrepancies are likely.
- Suggested follow-up question: Under what conditions should the reminder retry, and how many attempts are allowed?

## Category Summary

- Ambiguity: `0`
- Vagueness: `4`
- Inaccurate Definition: `1`
- Missing Scenarios: `2`
- Unverifiable Requirement: `1`
- Missing Implementation Dependency: `1`

## Questions To Confirm Immediately

1. What exact conditions define an active user for this feature?
2. At which page or user action should the reminder trigger?
3. Which abnormal-order cases must have custom handling?
4. What quantitative rule defines "not disturbing users too much"?
5. What metrics, events, and owners are required for monitoring reminder effectiveness?
