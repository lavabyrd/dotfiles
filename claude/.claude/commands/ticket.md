---
description: Bootstrap session with Jira ticket context
arguments:
  - name: ticket_id
    description: Jira ticket ID (e.g., SG2-1234)
    required: true
---

Fetch and display context for Jira ticket $ARGUMENTS.ticket_id.

Use the Jira API to retrieve:
- Ticket title and description
- Status and priority
- Acceptance criteria (if present)
- Related tickets/epics

The Jira API key is available via: `op read "op://employee/keys/jira_api_key"`

After fetching, summarize the ticket and suggest which repos from ~/code/work/ might be relevant based on the ticket description.

If the ticket workspace already exists at ~/code/tickets/$ARGUMENTS.ticket_id/, list what repos are checked out there.
