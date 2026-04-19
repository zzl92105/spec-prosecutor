# Spec Prosecutor Report

## Indictment Summary

- Implementation readiness: `Low`
- Blockers: `3`
- High Risk Items: `5`
- Notices: `1`

## Blockers

### 1. `[Missing Implementation Dependency]` Access scope is required without a permission matrix
- Assessment: `Likely Risk`
- Source excerpt: `External collaborators can view necessary project materials.`
- Severity: `Blocker`
- Problem: The PRD introduces a new user type but does not define which resources and actions are allowed or forbidden.
- Implementation risk: Engineering cannot design safe authorization rules, and the first version may leak internal content or over-restrict partners.
- Suggested follow-up question: Which exact resource types and actions are allowed for external collaborators in v1, and which are explicitly forbidden?

### 2. `[Inaccurate Definition]` "sensitive information" is named without an operational definition
- Assessment: `Confirmed Issue`
- Source excerpt: `Sensitive information should be protected.`
- Severity: `Blocker`
- Problem: The document relies on a critical security boundary but does not define what counts as sensitive information.
- Implementation risk: Different teams may hide different content, producing either data leakage or unnecessary blocking.
- Suggested follow-up question: What exact content categories count as sensitive information for this feature?

### 3. `[Missing Implementation Dependency]` Traceability and activity review are required without event requirements
- Assessment: `Likely Risk`
- Source excerpt: `Important operations should be traceable.` and `Relevant teams should be able to review collaborator activity later.`
- Severity: `Blocker`
- Problem: The PRD requires governance behavior but does not define which events must be logged, who can query them, or retention expectations.
- Implementation risk: Audit and review capabilities may be incomplete at launch and fail security or compliance review later.
- Suggested follow-up question: Which collaborator operations and activity events must be logged, who can review them, and how long must they be retained?

## High Risk Items

### 1. `[Inaccurate Definition]` "project admins" is used as an actor without a source-of-truth rule
- Assessment: `Confirmed Issue`
- Source excerpt: `Project admins can invite external collaborators to a project by email.`
- Severity: `High Risk`
- Problem: The document assumes project admin is already a stable role, but it does not define where that role comes from or whether multiple admin types exist.
- Implementation risk: Invite authority may be granted inconsistently across projects or products.
- Suggested follow-up question: Which existing role or permission determines that a user is a project admin for invitation purposes?

### 2. `[Unverifiable Requirement]` "receive the invitation in time" has no delivery expectation
- Assessment: `Confirmed Issue`
- Source excerpt: `The invited collaborator should receive the invitation in time.`
- Severity: `High Risk`
- Problem: The requirement implies a delivery or availability SLA without defining a measurable threshold.
- Implementation risk: Engineering cannot set retry or fallback behavior confidently, and QA cannot verify success criteria.
- Suggested follow-up question: What delivery expectation defines success for invitation sending in v1?

### 3. `[Missing Scenarios]` Invitation lifecycle is incomplete around expiry and acceptance
- Assessment: `Likely Risk`
- Source excerpt: `If the invitation expires, the admin can resend it.` and `The collaboration should start smoothly after the invite is accepted.`
- Severity: `High Risk`
- Problem: The document mentions expiry and acceptance but does not define invite validity duration, duplicate invites, revoked invites, or what happens if the email already belongs to an existing user.
- Implementation risk: The invite flow may break on common edge cases and require user-support intervention.
- Suggested follow-up question: What are the lifecycle rules for invite expiry, duplicate pending invites, revocation, and invites sent to existing accounts?

### 4. `[Vagueness]` "manage collaborator access in a convenient way" is not actionable
- Assessment: `Confirmed Issue`
- Source excerpt: `Project admins should be able to manage collaborator access in a convenient way.`
- Severity: `High Risk`
- Problem: The requirement expresses usability intent without defining the actual management actions that must exist.
- Implementation risk: Engineering may ship an incomplete management surface and still fail stakeholder expectations.
- Suggested follow-up question: Which exact access-management actions must be supported in v1: edit expiry, revoke access, resend invite, change scope, or something else?

### 5. `[Missing Scenarios]` Access removal is required without revocation timing rules
- Assessment: `Confirmed Issue`
- Source excerpt: `When the collaboration ends, access should be removed properly.`
- Severity: `High Risk`
- Problem: The requirement does not state whether access removal is immediate, scheduled, manual, or triggered by another system.
- Implementation risk: Former collaborators may retain access longer than intended or lose access before work is complete.
- Suggested follow-up question: What event ends a collaboration, and how quickly must collaborator access be revoked after that event?

## Notices

### 1. `[Unverifiable Requirement]` "avoid affecting internal collaboration too much" has no measurable boundary
- Assessment: `Likely Risk`
- Source excerpt: `The system should avoid affecting internal collaboration too much.`
- Severity: `Notice`
- Problem: The PRD expresses a general product concern without naming any measurable limit, prohibited UX change, or operational threshold.
- Implementation risk: This concern cannot guide implementation decisions and will likely resurface as subjective feedback later.
- Suggested follow-up question: What specific impact on internal collaboration must be avoided in v1?

## Category Summary

- Ambiguity: `0`
- Vagueness: `1`
- Inaccurate Definition: `2`
- Missing Scenarios: `2`
- Unverifiable Requirement: `2`
- Missing Implementation Dependency: `2`

## Questions To Confirm Immediately

1. Which exact resource types and actions are allowed for external collaborators in v1?
2. What exact content categories count as sensitive information for this feature?
3. Which collaborator operations and activity events must be logged and retained?
4. What are the lifecycle rules for expiry, duplicate invites, revocation, and existing-account invites?
5. What event ends a collaboration, and how quickly must access be revoked afterward?
