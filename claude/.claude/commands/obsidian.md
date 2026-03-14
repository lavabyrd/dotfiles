---
description: Add content to Obsidian vault with proper PARA categorization and hub linking. Use for documenting codebases, saving commands, capturing concepts, or preserving useful knowledge from conversations.
allowed-tools: Read, Glob, Write(~/Documents/LavaBrain/**), Edit(~/Documents/LavaBrain/**), Bash(git:*), Bash(ls:*), Bash(/Applications/Obsidian.app/Contents/MacOS/obsidian:*)
arguments:
  - name: action
    description: "Action to perform: document <path>, add <content>, command <cmd>, procedure <title>, update <note-name>, research <topic>. If omitted, asks what to add."
    required: false
---

# Obsidian Vault Skill

## CLI

All vault interactions use the Obsidian CLI:
```
/Applications/Obsidian.app/Contents/MacOS/obsidian <command> vault=LavaBrain
```

For file creation: write content with the Write tool first, then open with the CLI. This avoids content escaping issues for large notes.

## File Conventions

### Naming
```
YYYY-MM-DD_title_in_snake_case.md
```
- Date prefix in ISO format (YYYY-MM-DD)
- Title in lowercase with underscores
- No special characters

### Frontmatter
```yaml
---
date: DD-MM-YYYY
tags: [lowercase, tags]
hubs: [Matching-Hub-Names]
urls:
  - https://relevant-url.com
---
# Title With Proper Capitalization
```
- Date in European format (DD-MM-YYYY)
- Tags are lowercase
- Hubs match existing hub names exactly

### Codebase Documentation Frontmatter
For `document` action, include additional fields:
```yaml
scanned_at: <short-sha>
scanned_path: <repo-path>
```
This enables "what changed since last scan" queries by comparing git history.

### Destination
All new content goes to: `~/Documents/LavaBrain/01-Inbox/`

## Hub Auto-Detection

Read the live hub list before creating any note:
```bash
ls ~/Documents/LavaBrain/04-Resources/Hubs/
```
Match content to relevant hub names from what's actually there. Always include `Development` for technical content.

## Duplicate Check

Before creating any note, search for existing ones:
```bash
/Applications/Obsidian.app/Contents/MacOS/obsidian search query="<title keywords>" vault=LavaBrain
```
If a relevant note exists, offer to update it instead of creating a duplicate.

## Actions

### document <path>
Analyze a codebase and create an architecture overview.

**Process:**
1. Check repo state with `git status` — if there are local changes or the branch is not main, warn and stop. Do not modify the repo.
2. Read README if present
3. List directory structure, check key dirs
4. Identify tech stack from package files (go.mod, package.json, Cargo.toml, etc.)
5. Check git history: `git log --oneline -10`
6. Capture current SHA: `git rev-parse --short HEAD`

**Output structure:**
```markdown
# <Repo Name> Architecture Overview

## Purpose
What the repo does

## Tech Stack
- Language and version
- Key frameworks
- Notable dependencies

## Architecture
How main components connect

## Key Components
- `dir/` - Purpose
- `file` - What it does

## Configuration
Env vars, config files

## Entry Points
Where execution starts, main APIs or interfaces

## Related
Links to other repos, docs, or vault notes
```

Include `scanned_at` (short SHA) and `scanned_path` (repo path) in frontmatter.

### add "<content>"
Save a concept, insight, or general note.

**Format:**
```markdown
# <Title>

## Overview
What this concept is and why it matters

## Key Points
- Point one
- Point two

## Related
Links or cross-references
```

**Tags:** `[concept, <domain-tags>]`

### command "<cmd>"
Save a command snippet with context.

**Format:**
```markdown
# <Tool> Command: <Brief Description>

## Command
\`\`\`bash
<the command>
\`\`\`

## Purpose
What this command does and when to use it

## Options Explained
- `--flag` - What this flag does

## Example Usage
<practical example with context>

## Related
Links to relevant docs or hub
```

**Tags:** `[command, <tool-name>]`

### procedure "<title>"
Create a how-to guide from recent conversation.

**Format:**
```markdown
# <Title>

## Overview
Brief description of what this procedure accomplishes

## Prerequisites
- What's needed before starting

## Steps
1. First step
2. Second step

## Verification
How to confirm it worked

## Troubleshooting
Common issues and fixes (if relevant)
```

**Tags:** `[procedure, <domain-tags>]`

### update "<note-name>"
Append content to an existing note.

1. Search for the note:
   ```bash
   /Applications/Obsidian.app/Contents/MacOS/obsidian search query="<note-name>" vault=LavaBrain
   ```
2. Read the existing file to understand current content
3. Ask what to add
4. Append using the CLI:
   ```bash
   /Applications/Obsidian.app/Contents/MacOS/obsidian append path=<path> content="\n<new content>" vault=LavaBrain
   ```
5. Open the note:
   ```bash
   /Applications/Obsidian.app/Contents/MacOS/obsidian open path=<path> vault=LavaBrain
   ```

### research "<topic>"
Delegate to the `topic-researcher` agent to gather structured knowledge on a topic, then save the result.

1. Hand off to the `topic-researcher` agent with the topic
2. Take the returned markdown content
3. Save as a new note in `01-Inbox/` following the standard format
4. Open the note

**Tags:** `[concept, research, <domain-tags>]`

## Opening Notes

After writing any file with the Write tool, always open it:
```bash
/Applications/Obsidian.app/Contents/MacOS/obsidian open path=01-Inbox/<filename>.md vault=LavaBrain
```

## Trigger Modes

### Explicit Invocation
User runs `/obsidian <action>` with arguments.

### Conversational
User says "add this to obsidian" or "save this to my vault" mid-session.

**Identify "this" from context:**
- Just explained a command? → Save as command
- Just analyzed architecture? → Save as document
- Just solved a problem? → Save as procedure
- Just explained a concept? → Save as concept

### Proactive Suggestions
After doing something reusable, offer: "Want me to add this to your vault?"

**Suggest after:**
- Explaining a debugging approach
- Analyzing code architecture or patterns
- Demonstrating a useful command with explanation
- Walking through a multi-step procedure

**Do NOT suggest after:**
- Simple Q&A
- Routine code edits
- Basic git operations
- Trivial file changes

## Vault Organization

This command captures new content. For reorganizing existing notes, moving files between PARA folders, or fixing metadata across the vault, use the `obsidian-vault-organizer` agent instead.

## Content Type Tags

| Type | Tag Pattern |
|------|-------------|
| Codebase docs | `[architecture, repo-name, tech-stack-tags]` |
| Commands | `[command, tool-name]` |
| Procedures | `[procedure, domain-tags]` |
| Concepts | `[concept, domain-tags]` |
| Research | `[concept, research, domain-tags]` |

## Confirmation

After writing a note, confirm with:
```
Added to vault: 01-Inbox/<filename>.md
Hubs: [Hub1, Hub2]
Tags: [tag1, tag2]
```

## Rescanning Codebases

When user asks "what changed since last scan" for a previously documented repo:

1. Read the existing doc to get `scanned_at` SHA and `scanned_path`
2. Run `git log <scanned_at>..HEAD --oneline` to see commits since
3. Summarize significant changes
4. Offer to update the doc with new SHA and any architectural changes
