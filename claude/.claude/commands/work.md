---
description: Bootstrap ticket workspace with Obsidian context and git worktrees
allowed-tools: Bash(test:*), Bash(mkdir:*), Bash(jira:*), Bash(git:*), Bash(mv:*), Bash(ls:*), Bash(fzf:*), Bash(gh:*), Bash(/Applications/Obsidian.app/Contents/MacOS/obsidian:*), Write(~/Documents/Lavakrew/**), Read(~/Documents/Lavakrew/**)
arguments:
  - name: ticket_id
    description: Jira ticket ID (e.g., PROJ-1234)
    required: true
---

# Ticket Workspace Manager

Bootstrap a work session for ticket **$ARGUMENTS.ticket_id**.

## Key Paths

- **Obsidian context**: `~/Documents/Lavakrew/02-Areas/Work/Figment/Tickets/$ARGUMENTS.ticket_id/`
- **Code worktrees**: `~/code/tickets/$ARGUMENTS.ticket_id/`
- **Source repos**: `~/code/work/`

## Workflow

### Step 1: Check if ticket exists

```bash
test -d ~/Documents/Lavakrew/02-Areas/Work/Figment/Tickets/$ARGUMENTS.ticket_id && echo "RETURNING" || echo "NEW"
```

### Step 2a: NEW TICKET setup

1. Create Obsidian folder:
   ```bash
   mkdir -p ~/Documents/Lavakrew/02-Areas/Work/Figment/Tickets/$ARGUMENTS.ticket_id
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

4. Select repos using fzf:
   ```bash
   ls ~/code/work/ | fzf --multi --prompt="Select repos (TAB to multi-select): "
   ```

5. Derive a branch description from the Jira ticket title: lowercase, hyphenated, max 4-5 words. Show the suggestion and let the user confirm or override.

6. For each selected repo, create worktree:
   ```bash
   git -C ~/code/work/<repo> fetch origin
   git -C ~/code/work/<repo> worktree add -b mp/<ticket-lower>/<description> ~/code/tickets/$ARGUMENTS.ticket_id/<repo> origin/main
   ```

7. Update `_context.md` repos list with each selected repo.

8. Open `_context.md` in Obsidian:
   ```bash
   /Applications/Obsidian.app/Contents/MacOS/obsidian open path=02-Areas/Work/Figment/Tickets/$ARGUMENTS.ticket_id/_context.md vault=Lavakrew
   ```

9. Navigate to workspace:
   - Single repo selected: `cd ~/code/tickets/$ARGUMENTS.ticket_id/<repo>`
   - Multiple repos selected: `cd ~/code/tickets/$ARGUMENTS.ticket_id/`

### Step 2b: RETURNING to ticket

1. Read `_context.md` to load context.

2. Verify worktrees exist — offer to recreate any that are missing.

3. Check PR status for this ticket:
   ```bash
   gh pr list --state all --json number,title,state,reviewDecision,url --search "head:mp/$ARGUMENTS.ticket_id"
   ```
   Show each PR's title, state (open/merged/closed), and review decision (approved/changes requested/pending).

4. Show git status for each repo: current branch, uncommitted changes, ahead/behind origin.

5. Open `_context.md` in Obsidian:
   ```bash
   /Applications/Obsidian.app/Contents/MacOS/obsidian open path=02-Areas/Work/Figment/Tickets/$ARGUMENTS.ticket_id/_context.md vault=Lavakrew
   ```

6. Ask what to work on.

7. Navigate to workspace:
   - Single repo in `_context.md`: `cd ~/code/tickets/$ARGUMENTS.ticket_id/<repo>`
   - Multiple repos: `cd ~/code/tickets/$ARGUMENTS.ticket_id/`

## Special Commands

If user says "done" or "mark complete":
- Update `_context.md` status to `completed` and bump `updated` timestamp.
- For each repo listed in `_context.md`, remove the worktree:
  ```bash
  git -C ~/code/work/<repo> worktree remove ~/code/tickets/$ARGUMENTS.ticket_id/<repo>
  ```
- Confirm each removal succeeded.

If user says "add repo":
- Run fzf selection against `ls ~/code/work/` (pre-filtered to exclude already-added repos).
- Reuse the existing branch description from `_context.md`, or ask for a new one.
- Create worktree and update `_context.md`.

## Rules

1. **Never move or archive** - completed ticket folders stay in `02-Areas/Work/Figment/Tickets/` permanently
2. **No AI co-author** - never add Co-authored-by trailers for Claude
3. **Branch convention**: `mp/<ticket-lowercase>/<description>`
4. **Always fetch** before creating worktrees
5. **Update timestamps** when modifying `_context.md`
