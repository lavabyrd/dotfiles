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

- **Obsidian context**: `~/Documents/Lavakrew/02-Areas/Work/Figment/Notes/{Active|Done}/<slug>/`

## Setup

### Step 1: Derive slug and check if it exists

Slugify the description: lowercase, hyphenated, strip punctuation, max 5-6 words.

```bash
find ~/Documents/Lavakrew/02-Areas/Work/Figment/Notes -maxdepth 2 -type d | head -20
```

If a folder with a matching slug already exists, it's a RETURNING thought — load its `_context.md` and ask what to continue with. Otherwise it's NEW.

### Step 2: NEW thought setup

1. Extract people from the description — any word that looks like a proper name (capitalised, not a Jira ID, not a common word). Format each as `[[Name]]`. If none found, leave `people: []`.

2. Create the folder and `_context.md`:
   ```bash
   mkdir -p ~/Documents/Lavakrew/02-Areas/Work/Figment/Notes/Active/<slug>
   ```
   ```yaml
   title: "<description as written>"
   status: active
   created: <YYYY-MM-DD>
   updated: <YYYY-MM-DD>
   people: ["[[Name]]"]
   threads: []
   jira: ""
   ```

   Body below the frontmatter:
   ```markdown
   ## <description as written>

   <description as written, with people names replaced by their [[wikilink]] form>

   ## Notes

   ```

3. If this work involves code, surface a nudge: "This looks like it may need code changes — consider creating a Jira ticket first so you can use /work with a proper worktree."

4. Open `_context.md` in Obsidian:
   ```bash
   /Applications/Obsidian.app/Contents/MacOS/obsidian open path=02-Areas/Work/Figment/Notes/Active/<slug>/_context.md vault=Lavakrew
   ```

## Special Commands

### done / resolved

1. Update `_context.md` status to `done`, bump `updated` timestamp.
2. Move to Done:
   ```bash
   mv ~/Documents/Lavakrew/02-Areas/Work/Figment/Notes/Active/<slug> \
      ~/Documents/Lavakrew/02-Areas/Work/Figment/Notes/Done/<slug>
   ```

### done / graduated to ticket

If this thought became a Jira ticket:

1. Ask for the ticket ID.
2. Update `_context.md`: set `jira: <TICKET-ID>`, status to `done`, bump `updated`.
3. Move to Done:
   ```bash
   mv ~/Documents/Lavakrew/02-Areas/Work/Figment/Notes/Active/<slug> \
      ~/Documents/Lavakrew/02-Areas/Work/Figment/Notes/Done/<slug>
   ```
4. Add a comment on the Jira issue linking back to the vault note:
   ```bash
   jira issue comment add <TICKET-ID> "Context note: 02-Areas/Work/Figment/Notes/Done/<slug>/_context.md"
   ```

### add thread

Add a link (Slack URL, PR URL, email thread) to the `threads:` list in `_context.md` and bump `updated`.

## NEVER

- **NEVER create a thought note for work that already has a Jira ticket** — use `/work <TICKET-ID>` instead; thoughts are for pre-ticket or no-ticket work only
- **NEVER skip the Jira comment when graduating a thought to a ticket** — the link back is the only way to find the original context from the ticket side
- **NEVER use the inbox for this type of work** — that's what this command replaces; inbox notes don't have lifecycle and are hard to surface

## Rules

1. **Active/Done split** — new thoughts go into `Active/`; closing moves them to `Done/`
2. **Update timestamps** when modifying `_context.md`
3. **People are wikilinks** — always format as `[[Name]]`, never validate against existing vault notes
