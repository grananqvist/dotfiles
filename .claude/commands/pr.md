---
allowed-tools: Bash(git checkout:*), Bash(git add:*), Bash(git status:*), Bash(git push:*), Bash(git commit:*), Bash(gh pr create:*), Bash(gh pr view:*), Bash(git diff:*), Bash(git branch:*), Bash(cat .github/pull_request_template.md:*), Read(*)
description: Commit, push, and open a PR
---

## Arguments

- `$ARGUMENTS`: Optional base branch to create PR against (e.g., "main", "develop"). Defaults to repo's default branch.

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Existing PR for this branch: !`gh pr view --json url,state 2>/dev/null || echo "No existing PR"`

## PR Template

!`cat .github/pull_request_template.md 2>/dev/null || echo "No PR template found"`
Guidelines when filling out the PR template, and when doing any tasks presented as checkboxes:
* Be concise, if there are any checkboxes, we should make sure to address them, unless its related to e2e testing.
* For CHANGELOG.md checkboxes, we only do them if there are user-facing changes or bug fixes.
* For documentation updates, make sure we include any updates to relevant .rst or .md files, particularly API reference.

## Your task

Based on the above changes:
1. Create a new branch if on main
2. Create a single commit with an appropriate 1 sentence message, do not include authorship information, and no emojis.
3. Push the branch to origin
4. If a PR already exists for this branch, just push (step 3) - do not create a new PR
5. If no PR exists, create a pull request using `gh pr create` with a body following the PR template above. If `$ARGUMENTS` is provided, use `--base $ARGUMENTS` to target that branch.
6. You have the capability to call multiple tools in a single response. You MUST do all of the above in a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.

