---
description: Capture a piece of ticket-less work — a discussion, investigation, or idea — as a structured note in the vault. Creates an active context note under 02-Areas/Work/Figment/Notes/ with lifecycle management (active → done, or graduate to a Jira ticket). Use when starting work that has no ticket yet.
allowed-tools: Bash(mkdir:*), Bash(jira:*), Bash(mv:*), Bash(find:*), Bash(/Applications/Obsidian.app/Contents/MacOS/obsidian:*), Write(~/Documents/Lavakrew/**), Read(~/Documents/Lavakrew/**)
arguments:
  - name: description
    description: Free-text description of the work (e.g. "ben discussion about auth refactor")
    required: true
---

# Thought Workspace

Capture ticket-less work for: **$ARGUMENTS.description**

## Key Paths

- **Obsidian context**: `~/Documents/Lavakrew/02-Areas/Work/Figment/Notes/{Active|Done}/`

## Naming Convention

Files use the vault standard: `YYYY-MM-DD — Type — Title.md`

Type is one of: `Investigation`, `Discussion`, `Note`, `Task` — pick the best fit for the description.

Title is the description in title case, max ~6 words.

Example: `2026-04-09 — Investigation — Twingate Cilium TCP Session Tracking.md`

## Setup

### Step 1: Derive filename and check if it exists

Build the filename from today's date + type + title-cased description (abbreviated if needed).

```bash
find ~/Documents/Lavakrew/02-Areas/Work/Figment/Notes -maxdepth 2 -type f -name "*.md" | head -20
```

If a file with a matching title already exists in `Active/`, it's a RETURNING thought — load it and ask what to continue with. Otherwise it's NEW.

### Step 2: NEW thought setup

1. Extract people from the description — any word that looks like a proper name (capitalised, not a Jira ID, not a common word). Format each as `[[Name]]`. If none found, leave `people: []`.

2. Create the flat file at `~/Documents/Lavakrew/02-Areas/Work/Figment/Notes/Active/<filename>`:
   ```yaml
   title: "<description as written>"
   type: <Investigation|Discussion|Note|Task>
   status: active
   created: <YYYY-MM-DD>
   updated: <YYYY-MM-DD>
   people: ["[[Name]]"]
   threads: []
   jira: ""
   tags: [work, figment, thought]
   ```

   Body below the frontmatter:
   ```markdown
   ## <description as written>

   <description as written, with people names replaced by their [[wikilink]] form>

   ## Notes

   ```

3. If this work involves code, surface a nudge: "This looks like it may need code changes — consider creating a Jira ticket first so you can use /work with a proper worktree."

4. Open the file in Obsidian:
   ```bash
   /Applications/Obsidian.app/Contents/MacOS/obsidian open path=02-Areas/Work/Figment/Notes/Active/<filename> vault=Lavakrew
   ```

## Special Commands

### done / resolved

1. Update the file: set `status: done`, bump `updated` timestamp.
2. Move to Done:
   ```bash
   mv ~/Documents/Lavakrew/02-Areas/Work/Figment/Notes/Active/<filename> \
      ~/Documents/Lavakrew/02-Areas/Work/Figment/Notes/Done/<filename>
   ```

### done / graduated to ticket

If this thought became a Jira ticket:

1. Ask for the ticket ID.
2. Update the file: set `jira: <TICKET-ID>`, status to `done`, bump `updated`.
3. Move to Done:
   ```bash
   mv ~/Documents/Lavakrew/02-Areas/Work/Figment/Notes/Active/<filename> \
      ~/Documents/Lavakrew/02-Areas/Work/Figment/Notes/Done/<filename>
   ```
4. Add a comment on the Jira issue linking back to the vault note:
   ```bash
   jira issue comment add <TICKET-ID> "Context note: 02-Areas/Work/Figment/Notes/Done/<filename>"
   ```

### add thread

Add a link (Slack URL, PR URL, email thread) to the `threads:` list in the file's frontmatter and bump `updated`.

## NEVER

- **NEVER create a thought note for work that already has a Jira ticket** — use `/work <TICKET-ID>` instead; thoughts are for pre-ticket or no-ticket work only
- **NEVER skip the Jira comment when graduating a thought to a ticket** — the link back is the only way to find the original context from the ticket side
- **NEVER use the inbox for this type of work** — that's what this command replaces; inbox notes don't have lifecycle and are hard to surface
- **NEVER create a folder per thought** — use a single flat file following the `YYYY-MM-DD — Type — Title.md` convention

## Rules

1. **Active/Done split** — new thoughts go into `Active/`; closing moves them to `Done/`
2. **Flat files only** — one `.md` file per thought, no subfolders, no `_context.md`
3. **Update timestamps** when modifying a thought file
4. **People are wikilinks** — always format as `[[Name]]`, never validate against existing vault notes
