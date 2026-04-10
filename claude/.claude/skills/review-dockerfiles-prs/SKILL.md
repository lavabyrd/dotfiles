---
name: review-dockerfiles-prs
description: Review open pull requests in the dockerfiles repo — show what changed, validate Docker image SHA digests against the registry, then approve and merge via gh CLI. Use this skill whenever asked to review PRs, check open PRs, validate image SHAs, or process Renovate bumps in the dockerfiles repo. Also triggers on "what PRs are open", "review the bumps", "approve the PRs", or any mention of checking/merging dockerfiles PRs.
tools: Bash, Read
---

# review-dockerfiles-prs

Review open dockerfiles PRs, validate image SHA digests, and approve/merge interactively.

## Context

This repo contains single-line Dockerfiles of the form:
```
FROM image:tag@sha256:<digest>
```

Renovate opens PRs that bump image versions. Each PR typically changes:
- `Dockerfile` — new `image:tag@sha256:<digest>`
- `build.yaml` — updated version tag

SHA validation uses `crane digest image:tag` and compares the returned digest against what the PR puts in the Dockerfile. They must match exactly.

## Workflow

### Step 1: List open PRs

```bash
gh pr list --json number,title,headRefName,createdAt,author --limit 50
```

Print a numbered list so the user can see everything at a glance before diving in.

**Author check:** All PRs in this repo should be authored by `renovate` (or `renovate[bot]`). Any PR from a different author is a manual/human PR — list it separately under a "Manual PRs (skipped)" section and do not process it through the automated workflow. The user should review those manually.

### Step 2: For each PR, collect and validate

Only process PRs authored by renovate. For each one, run these in sequence:

**Get the diff:**
```bash
gh pr diff <number>
```

**Extract FROM lines** from the diff — look for lines starting with `+FROM` that contain `@sha256:`. Parse out:
- `image` (registry + name)
- `tag`
- `digest` (the sha256 from the Dockerfile)

**Validate the digest** using crane:
```bash
crane digest <image>:<tag>
```

Compare crane's output to the digest in the Dockerfile. They must be identical.

**Get the PR body for context:**
```bash
gh pr view <number> --json title,body,files
```

### Step 3: Present a summary for each PR

Show one block per PR:

```
PR #<number>: <title>
Branch: <headRefName>
Files: <list of changed files>

Changes:
  - <image>:<old-tag> → <tag>
  - OLD SHA: sha256:<old-digest>
  - NEW SHA: sha256:<new-digest>

SHA validation:
  crane digest <image>:<tag> → sha256:<crane-result>
  Dockerfile digest          → sha256:<dockerfile-digest>
  Result: ✓ VALID  |  ✗ MISMATCH
```

If crane fails (network error, image not found), mark as `⚠ UNVERIFIABLE` and note the error — do not block on it, but surface it clearly.

If the SHA is a mismatch, flag it prominently and do not offer to merge that PR.

### Step 4: Interactive approve/merge loop

After presenting all summaries, go through each valid PR one at a time and ask:

```
PR #<number>: <title>
SHA: ✓ VALID

Action? [a]pprove+merge  [s]kip  [c]lose  (or press enter to skip)
```

Wait for user input before proceeding to the next PR.

**On "a" (approve + merge):**
```bash
gh pr review <number> --approve
gh pr merge <number> --squash --delete-branch
```

**On "c" (close):**
```bash
gh pr close <number>
```

**On "s" or enter:** move to the next PR.

After each action, confirm the result with a single line (e.g., `✓ Merged #1255` or `✓ Closed #1254`).

### Step 5: Final summary

When all PRs are processed, print a compact summary:
```
Done.
  Merged:  #1255, #1258
  Skipped: #1254
  Invalid: (none)
```

## Notes

- Always validate SHAs before offering to merge. Never merge a PR with a mismatched digest.
- If `crane` is not installed, fall back to `docker manifest inspect image:tag` and parse the top-level digest from the JSON. Note the fallback in output.
- Multi-arch images: `crane digest` returns the manifest list digest, which is what goes in the Dockerfile. This is correct — no special handling needed.
- PRs that touch files other than `Dockerfile` and `build.yaml` should be flagged for manual review rather than auto-merged.
- Private registries (e.g., `public.ecr.aws`) may require AWS credentials. If crane fails with an auth error, note it and skip SHA validation for that image.
