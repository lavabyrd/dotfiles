---
description: Add content to Obsidian vault with proper PARA categorization and hub linking. Use for documenting codebases, saving commands, capturing concepts, or preserving useful knowledge from conversations.
allowed-tools: Read, Glob, Write(~/Documents/LavaBrain/**), Bash(git:*), Bash(ls:*)
arguments:
  - name: action
    description: "Action to perform: document <path>, add <content>, command <cmd>, procedure <title>. If omitted, asks what to add."
    required: false
---

# Obsidian Vault Skill

## Overview

Add content to the LavaBrain Obsidian vault with proper formatting, hub linking, and PARA-compliant organization. All content lands in `01-Inbox/` for later organization.

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

### Destination
All content goes to: `~/Documents/LavaBrain/01-Inbox/`

## Hub Auto-Detection

Read existing hubs from `~/Documents/LavaBrain/04-Resources/Hubs/` and match content to relevant ones.

**Hub matching rules:**
- Go/Golang code -> `Golang`
- Kubernetes/K8s/kubectl -> `Kubernetes`
- Ethereum/ETH/validators -> `Ethereum-Network` or `Ethereum`
- Git commands/workflows -> `Git`
- Fish/Bash/ZSH shell -> respective shell hub
- Cardano/ADA -> `Blockchain`
- Cosmos SDK chains -> `Cosmos-Ecosystem`
- Claude/AI workflows -> `Claude`
- Terminal tools (yazi, zoxide, atuin) -> respective hubs

Always include `Development` hub for technical content.

## Actions

### document <path>
Analyze a codebase and create an architecture overview.

**Process:**
1. Read README if present
2. List directory structure (`ls -la`, check key dirs)
3. Identify tech stack from package files (go.mod, package.json, Cargo.toml, etc.)
4. Check git history for context (`git log --oneline -10`)
5. Identify main components and entry points

**Output structure:**
```markdown
# <Repo Name> Architecture Overview

## Purpose
What the repo does (from README or inferred)

## Tech Stack
- Language and version
- Key frameworks
- Notable dependencies

## Architecture
How main components connect (text description or ASCII diagram)

## Key Components
- `dir/` - Purpose of this directory
- `file` - What this key file does

## Configuration
How the app is configured (env vars, config files, etc.)

## Entry Points
Where execution starts, main APIs or interfaces

## Related
Links to other repos, docs, or vault notes if relevant
```

### add "<content>"
Save a concept, insight, or general note.

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
3. Continue...

## Verification
How to confirm it worked

## Troubleshooting
Common issues and fixes (if relevant)
```

**Tags:** `[procedure, <domain-tags>]`

## Trigger Modes

### Explicit Invocation
User runs `/obsidian <action>` with arguments.

### Conversational
User says "add this to obsidian" or "save this to my vault" mid-session.

**Identify "this" from context:**
- Just explained a command? -> Save as command
- Just analyzed architecture? -> Save as document
- Just solved a problem? -> Save as procedure
- Just explained a concept? -> Save as concept

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

## Content Type Tags

| Type | Tag Pattern |
|------|-------------|
| Codebase docs | `[architecture, repo-name, tech-stack-tags]` |
| Commands | `[command, tool-name]` |
| Procedures | `[procedure, domain-tags]` |
| Concepts | `[concept, domain-tags]` |

## Example Invocations

```
/obsidian document ~/code/work/eth2-metrics
/obsidian add "KES rotation requires incrementing the op_cert_counter"
/obsidian command "kubectl debug pod/mypod -it --image=busybox --target=container"
/obsidian procedure "Rotating KES keys for Cardano pools"
```

## Confirmation

After writing a note, confirm with:
```
Added to vault: 01-Inbox/2026-02-04_<filename>.md
Hubs: [Hub1, Hub2]
Tags: [tag1, tag2]
```
