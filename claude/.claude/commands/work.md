---
description: Bootstrap and manage a work session. Routes to ticket or thought flow automatically. Use for any work context: "/work SG2-1234" for a Jira ticket, "/work ben discussion about auth" for ticket-less work, returning to in-progress work, or marking work done.
allowed-tools: Bash(test:*), Bash(mkdir:*), Bash(jira:*), Bash(git:*), Bash(mv:*), Bash(ls:*), Bash(fzf:*), Bash(gh:*), Bash(find:*), Bash(/Applications/Obsidian.app/Contents/MacOS/obsidian:*), Write(~/Documents/Lavakrew/**), Read(~/Documents/Lavakrew/**)
arguments:
  - name: input
    description: A Jira ticket ID (e.g. SG2-1234) or a free-text description (e.g. "ben discussion about auth")
    required: true
---

# Work Router

Inspect `$ARGUMENTS.input` and route:

- If it matches a Jira ticket ID pattern — one or more uppercase letters, a hyphen, and digits (e.g. `SG2-1234`, `PROJ-42`) — follow the **Ticket Flow** below.
- Otherwise — follow the **Thought Flow** below.

---

## Ticket Flow

Bootstrap or resume a Jira ticket session. Full instructions in `/ticket`.

Follow the ticket workflow exactly as defined in the `/ticket` command, passing `$ARGUMENTS.input` as the ticket ID.

---

## Thought Flow

Capture ticket-less work — a discussion, investigation, or idea. Full instructions in `/thought`.

Follow the thought workflow exactly as defined in the `/thought` command, passing `$ARGUMENTS.input` as the description.
