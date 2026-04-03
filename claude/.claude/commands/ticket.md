---
description: Bootstrap and manage a Jira ticket work session — create Obsidian context notes, set up git worktrees across repos, check PR status, and handle the full lifecycle (start, return, done, add-repo).
allowed-tools: Bash(test:*), Bash(mkdir:*), Bash(jira:*), Bash(git:*), Bash(mv:*), Bash(ls:*), Bash(fzf:*), Bash(gh:*), Bash(find:*), Bash(/Applications/Obsidian.app/Contents/MacOS/obsidian:*), Write(~/Documents/Lavakrew/**), Read(~/Documents/Lavakrew/**)
arguments:
  - name: ticket_id
    description: Jira ticket ID (e.g., PROJ-1234)
    required: true
---

# Ticket Workspace Manager

Bootstrap a work session for ticket **$ARGUMENTS.ticket_id**.

## Key Paths

- **Obsidian context**: `~/Documents/Lavakrew/02-Areas/Work/Figment/Tickets/{Active|Done}/$ARGUMENTS.ticket_id/`
- **Code worktrees**: `~/code/tickets/$ARGUMENTS.ticket_id/`
- **Source repos**: `~/code/work/`

## Workflow

### Step 1: Check if ticket exists

```bash
find ~/Documents/Lavakrew/02-Areas/Work/Figment/Tickets -maxdepth 2 -type d -name "$ARGUMENTS.ticket_id" | head -1
```

If the find returns a path, it's a RETURNING ticket — store that path as `TICKET_PATH`. Otherwise it's NEW.

### Step 2a: NEW TICKET setup

1. Fetch Jira info first — if this fails (auth expired, ticket not found), stop and report the error before creating any files:
   ```bash
   jira issue view $ARGUMENTS.ticket_id --plain
   ```

2. Create the Obsidian folder and `_context.md`:
   ```bash
   mkdir -p ~/Documents/Lavakrew/02-Areas/Work/Figment/Tickets/Active/$ARGUMENTS.ticket_id
   ```
   ```yaml
   ticket: $ARGUMENTS.ticket_id
   jira: <URL from jira output>
   status: in-progress
   repos: []
   branch_description: ""
   created: <YYYY-MM-DD>
   updated: <YYYY-MM-DD>
   ```

3. Select repos using fzf:
   ```bash
   ls ~/code/work/ | fzf --multi --prompt="Select repos (TAB to multi-select): "
   ```

4. Derive a branch description from the Jira ticket title: lowercase, hyphenated, max 4-5 words. Show the suggestion and let the user confirm or override. Store it in `_context.md` as `branch_description`.

5. For each selected repo, create the worktree:
   ```bash
   git -C ~/code/work/<repo> fetch origin
   git -C ~/code/work/<repo> worktree add -b mp/$ARGUMENTS.ticket_id/<description> ~/code/tickets/$ARGUMENTS.ticket_id/<repo> origin/main
   ```

6. Update `_context.md` repos list with each selected repo.

7. Open `_context.md` in Obsidian:
   ```bash
   /Applications/Obsidian.app/Contents/MacOS/obsidian open path=02-Areas/Work/Figment/Tickets/Active/$ARGUMENTS.ticket_id/_context.md vault=Lavakrew
   ```

### Step 2b: RETURNING to ticket

Before diving in, orient yourself:
- **PRs**: Do any open PRs have pending review feedback that should be addressed before new work?
- **Drift**: Is any worktree significantly behind origin? If so, offer to rebase first.
- **Scope**: Has the Jira ticket description or status changed since last session?

1. Verify worktrees exist for each repo in the `repos:` list. For any that are missing, offer to recreate them using the stored `branch_description`. If the worktree path already exists as a stale directory (from a previous partial setup), offer to remove it before retrying.

2. Check PR status:
   ```bash
   gh pr list --state all --json number,title,state,reviewDecision,url --search "head:mp/$ARGUMENTS.ticket_id"
   ```

3. Show git status for each repo: current branch, uncommitted changes, ahead/behind origin.

4. Open `_context.md` in Obsidian (derive the relative vault path by stripping `~/Documents/Lavakrew/` from `TICKET_PATH`):
   ```bash
   /Applications/Obsidian.app/Contents/MacOS/obsidian open path=<relative-path>/_context.md vault=Lavakrew
   ```

## Special Commands

### done / mark complete

1. Before moving anything, check each worktree for uncommitted changes — warn and confirm if any exist.
2. Update `_context.md` status to `done`, bump `updated` timestamp.
3. Move ticket folder to Done:
   ```bash
   mv ~/Documents/Lavakrew/02-Areas/Work/Figment/Tickets/Active/$ARGUMENTS.ticket_id \
      ~/Documents/Lavakrew/02-Areas/Work/Figment/Tickets/Done/$ARGUMENTS.ticket_id
   ```
4. Remove each worktree listed in `_context.md`:
   ```bash
   git -C ~/code/work/<repo> worktree remove ~/code/tickets/$ARGUMENTS.ticket_id/<repo>
   ```
5. Confirm each removal succeeded.

### add repo

1. Run fzf selection, filtered to exclude repos already in `_context.md`:
   ```bash
   comm -23 <(ls ~/code/work/ | sort) \
            <(grep -oP '(?<=- ).*' $TICKET_PATH/_context.md | sort) \
   | fzf --multi --prompt="Select repos to add: "
   ```
2. Reuse `branch_description` from `_context.md`, or ask for a new one if this repo needs a different description.
3. Fetch and create worktree (same as Step 2a.5).
4. Update `_context.md` repos list.

## NEVER

- **NEVER create a worktree without fetching first** — branching from stale state causes silent divergence that's painful to unwind
- **NEVER use `mp/<ticket>` as the full branch name without a description suffix** — PRs become unidentifiable in `gh pr list` and the branch convention breaks
- **NEVER skip updating `repos:` in `_context.md` after adding a worktree** — the "done" and "add repo" flows both read this list; a stale list causes silent worktree leaks on cleanup
- **NEVER run `git worktree remove` without checking for uncommitted changes first** — the command won't loudly protect you from data loss
- **NEVER create `_context.md` if `jira issue view` fails** — a context file without real ticket data is worse than none; surface the auth error immediately
- **NEVER proceed with "done" if any PR is still open and unmerged** — warn the user and confirm intent before archiving

## Rules

1. **Active/Done split** — new tickets go into `Active/`; marking complete moves them to `Done/`
2. **Branch convention**: `mp/<ticket-lowercase>/<description>`
3. **Always fetch** before creating worktrees
4. **Update timestamps** when modifying `_context.md`
