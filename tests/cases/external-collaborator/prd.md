# External Collaborator Access

## Background

Some projects need short-term collaboration with vendors and agency partners. Today teams often share screenshots or temporary accounts, which creates security risk and low collaboration efficiency. The platform should support inviting external collaborators into a project in a controlled way.

The first version is for web. Mobile can be supported later.

## Goal

- Allow controlled collaboration with external partners
- Reduce unsafe account sharing
- Keep internal project information protected

## Requirements

### Invite Flow

- Project admins can invite external collaborators to a project by email.
- The invited collaborator should receive the invitation in time.
- If the invitation expires, the admin can resend it.
- The collaboration should start smoothly after the invite is accepted.

### Access Scope

- External collaborators can view necessary project materials.
- Sensitive information should be protected.
- Project admins should be able to manage collaborator access in a convenient way.
- When the collaboration ends, access should be removed properly.

### Governance

- Important operations should be traceable.
- The system should avoid affecting internal collaboration too much.
- Relevant teams should be able to review collaborator activity later.

## Notes

- Reuse the existing account system if possible.
- PM will define detailed UI copy later.
