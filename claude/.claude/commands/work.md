---
description: Bootstrap ticket workspace with Obsidian context and git worktrees
arguments:
  - name: ticket_id
    description: Jira ticket ID (e.g., PROJ-1234)
    required: true
---

# Ticket Workspace Manager

Bootstrap a work session for ticket **$ARGUMENTS.ticket_id**.

## Key Paths

- **Obsidian context**: `~/Documents/LavaBrain/02-Projects/Work/Tickets/$ARGUMENTS.ticket_id/`
- **Code worktrees**: `~/code/tickets/$ARGUMENTS.ticket_id/`
- **Source repos**: `~/code/work/`

## Workflow

### Step 1: Check if ticket exists

```bash
test -d ~/Documents/LavaBrain/02-Projects/Work/Tickets/$ARGUMENTS.ticket_id && echo "RETURNING" || echo "NEW"
```

### Step 2a: NEW TICKET setup

1. Create Obsidian folder:
   ```bash
   mkdir -p ~/Documents/LavaBrain/02-Projects/Work/Tickets/$ARGUMENTS.ticket_id
   ```

2. Fetch Jira info:
   ```bash
   jira issue view $ARGUMENTS.ticket_id --plain
   ```

3. Create `_context.md` with YAML frontmatter:
   ```yaml
   ticket: $ARGUMENTS.ticket_id
   jira: <URL from jira output>
   status: in-progress
   repos: []
   created: <YYYY-MM-DD>
   updated: <YYYY-MM-DD>
   ```

4. Ask user which repos are needed from `~/code/work/`

5. Ask for short branch description (e.g., "fix-auth-bug")

6. For each repo, create worktree:
   ```bash
   git -C ~/code/work/<repo> fetch origin
   git -C ~/code/work/<repo> worktree add -b mp/<ticket-lower>/<description> ~/code/tickets/$ARGUMENTS.ticket_id/<repo> origin/main
   ```

7. Update `_context.md` with repo entries

### Step 2b: RETURNING to ticket

1. Read `_context.md` to load context
2. Verify worktrees exist (offer to recreate if missing)
3. Show status: branch, uncommitted changes, ahead/behind
4. Ask what to work on

## Special Commands

If user says "done" or "mark complete":
- Update `_context.md` status to `completed`
- Remind about `ticket clean $ARGUMENTS.ticket_id` for worktree cleanup
- Move Obsidian folder to `05-Archive/Work/Tickets/$ARGUMENTS.ticket_id/`

If user says "add repo":
- Ask which repo
- Use same branch description as existing repos (or ask for new one)
- Create worktree and update `_context.md`

## Rules

1. **Archive, never delete** - completed tickets go to `05-Archive/Work/Tickets/`
2. **No AI co-author** - never add Co-authored-by trailers for Claude
3. **Branch convention**: `mp/<ticket-lowercase>/<description>`
4. **Always fetch** before creating worktrees
5. **Update timestamps** when modifying `_context.md`
