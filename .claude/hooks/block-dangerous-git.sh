#!/bin/bash
# Block dangerous git commands in Claude Code
# This hook receives tool input via stdin as JSON

# Read the command from stdin (JSON with "tool_input.command" field for Bash tool)
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
    exit 0  # Not a bash command or no command field
fi

# Patterns to block
BLOCKED_PATTERNS=(
    # Force push
    'git\s+push\s+.*-f'
    'git\s+push\s+.*--force'
    'git\s+push\s+--force'
    # Block pushing to remote named 'upstream' (but not --set-upstream flag)
    'git\s+push\s+upstream(\s|$)'
    # Hard reset
    'git\s+reset\s+--hard'
    'git\s+reset\s+.*HEAD~'
    'git\s+reset\s+.*HEAD\^'
    # Branch deletion
    'git\s+branch\s+-d'
    'git\s+branch\s+-D'
    'git\s+branch\s+--delete'
    # Remote deletion
    'git\s+remote\s+remove'
    'git\s+remote\s+rm'
    # Tag deletion
    'git\s+tag\s+-d'
    'git\s+tag\s+--delete'
    # Worktree removal
    'git\s+worktree\s+remove'
    # Destructive clean/checkout
    'git\s+clean\s+-fd'
    'git\s+clean\s+-f'
    'git\s+checkout\s+--\s+\.'
    # Stash destruction
    'git\s+stash\s+drop'
    'git\s+stash\s+clear'
    # Reflog manipulation
    'git\s+reflog\s+expire'
    'git\s+reflog\s+delete'
    # Rebase (can rewrite history)
    'git\s+rebase\s+-i'
    'git\s+rebase\s+--interactive'
    # Filter-branch (history rewriting)
    'git\s+filter-branch'
    # gc with aggressive options
    'git\s+gc\s+--prune'
    'git\s+gc\s+--aggressive'
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qEi "$pattern"; then
        echo "BLOCKED: Dangerous git command detected: $COMMAND" >&2
        echo "Pattern matched: $pattern" >&2
        exit 2  # Non-zero exit blocks the command
    fi
done

exit 0  # Allow the command
