---
description: Bootstrap ticket workspace with Obsidian context and git worktrees
arguments:
  - name: ticket_id
    description: Jira ticket ID (e.g., SS2-1234)
    required: true
  - name: action
    description: Optional action (done, info, add-repo)
    required: false
---

# Ticket Workspace Manager

You are bootstrapping a work session for ticket **$ARGUMENTS.ticket_id**.

## Paths

- **Obsidian vault**: `/Users/markpreston/Documents/LavaBrain`
- **Ticket context folder**: `/Users/markpreston/Documents/LavaBrain/02-Projects/Work/Tickets/$ARGUMENTS.ticket_id/`
- **Context file**: `/Users/markpreston/Documents/LavaBrain/02-Projects/Work/Tickets/$ARGUMENTS.ticket_id/_context.md`
- **Code worktrees**: `~/code/tickets/$ARGUMENTS.ticket_id/`
- **Source repos**: `~/code/work/`

## Actions

### If action is "done"

1. Update `_context.md` status to `completed`
2. Update the `updated` date in frontmatter
3. List any remaining worktrees that can be cleaned with `ticket clean $ARGUMENTS.ticket_id`
4. Do NOT delete anything from Obsidian

### If action is "info"

1. Read and display the `_context.md` file
2. Check worktree status for each repo (branch, uncommitted changes)
3. Show summary of current state

### If action is "add-repo"

1. Ask which repo to add
2. Ask for branch description (or use existing from other repos)
3. Run the equivalent of `ticket add $ARGUMENTS.ticket_id <repo> -d <description>`
4. Update `_context.md` with new repo entry

### Default action (no action specified)

Check if the ticket context folder exists:

#### If folder DOES NOT exist (new ticket):

1. **Create Obsidian folder**:
   ```
   mkdir -p /Users/markpreston/Documents/LavaBrain/02-Projects/Work/Tickets/$ARGUMENTS.ticket_id/
   ```

2. **Fetch Jira ticket info** using the `jira` CLI:
   ```bash
   jira issue view $ARGUMENTS.ticket_id --plain
   ```

3. **Create `_context.md`** with this structure:
   ```markdown
   ---
   ticket: $ARGUMENTS.ticket_id
   jira: https://figment.atlassian.net/browse/$ARGUMENTS.ticket_id
   status: in-progress
   repos: []
   created: <today's date YYYY-MM-DD>
   updated: <today's date YYYY-MM-DD>
   ---

   # $ARGUMENTS.ticket_id: <title from Jira>

   ## Summary

   <description from Jira>

   ## Current State

   - [ ] Initial setup
   ```

4. **Ask which repos are needed**:
   - List available repos in `~/code/work/`
   - Ask user to select one or more
   - Ask for a short branch description (e.g., "add-team-sync")

5. **Create worktrees** for each selected repo:
   ```bash
   # For each repo:
   git -C ~/code/work/<repo> fetch origin
   git -C ~/code/work/<repo> worktree add -b mp/<ticket-lowercase>/<description> ~/code/tickets/$ARGUMENTS.ticket_id/<repo> origin/main
   ```

6. **Update `_context.md`** with repo entries:
   ```yaml
   repos:
     - name: <repo>
       source: ~/code/work/<repo>
       worktree: ~/code/tickets/$ARGUMENTS.ticket_id/<repo>
       branch: mp/<ticket-lowercase>/<description>
   ```

7. **Summarize** what was created and ask what to work on.

#### If folder DOES exist (returning to ticket):

1. **Read `_context.md`** to load context

2. **Verify worktrees exist**:
   - For each repo in the YAML, check if worktree path exists
   - If missing, offer to recreate it

3. **Check worktree status**:
   - Current branch
   - Uncommitted changes count
   - Behind/ahead of origin

4. **Display summary**:
   - Ticket title and status
   - Repos and their state
   - Any existing plan.md content

5. **Ask what to work on** or if user wants to add another repo

## Important Rules

1. **NEVER delete or move Obsidian files** - only update status in `_context.md`
2. **NEVER add Co-authored-by trailers** for Claude in any commits
3. **Always use the branch naming convention**: `mp/<ticket-lowercase>/<description>`
4. **Always fetch origin** before creating worktrees
5. **Update the `updated` date** in frontmatter whenever modifying `_context.md`

## After Setup

Once the workspace is ready, you have full context. Help the user with their ticket work:
- Read relevant files from the worktrees
- Make code changes as requested
- Create commits (without AI co-author)
- Update the "Current State" section in `_context.md` as tasks complete
