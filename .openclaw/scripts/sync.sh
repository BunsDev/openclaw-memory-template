#!/bin/bash

# OpenClaw Memory Synchronization Script (V2)
# Uses Git Notes for session metadata - Clean Git History

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$(dirname "$SCRIPT_DIR")")"
MEMORY_DIR="$WORKSPACE/memory"

echo "🔄 Memory Sync: Starting..."

# Check if memory is a Git repo
if [ ! -d "$MEMORY_DIR/.git" ]; then
    echo "⚠️  Memory is not a Git repo. Initialize..."
    cd "$MEMORY_DIR" || exit 1
    git init
    echo "✓ Git repo initialized"
fi

# Pull latest changes
cd "$MEMORY_DIR" || exit 1
echo "📥 Pulling latest from remote..."

# Check if remote exists
if git remote get-url origin &>/dev/null; then
    git pull --rebase origin main 2>/dev/null || git pull --rebase origin master 2>/dev/null || echo "⚠️  No remote configured yet"
else
    echo "⚠️  No remote configured. Set up with:"
    echo "   cd memory && git remote add origin <your-repo-url>"
fi

# Stage all changes
echo "📝 Staging changes..."
git add .

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo "✓ No changes to commit"
    exit 0
fi

# Daily log path
TODAY=$(date +%Y-%m-%d)
DAILY_LOG="$MEMORY_DIR/daily/$TODAY.md"

# Extract session summary from daily log (first meaningful line)
SESSION_SUMMARY=""
if [ -f "$DAILY_LOG" ]; then
    SESSION_SUMMARY=$(cat "$DAILY_LOG" | grep -A 5 "## Session" | grep -v "^##" | grep -v "^$" | head -1 | tr -d '"')
fi

# Build commit message
if [ -n "$SESSION_SUMMARY" ]; then
    COMMIT_MSG="Update daily log $TODAY - $SESSION_SUMMARY"
else
    COMMIT_MSG="Update daily log $TODAY"
fi

# Get current session info
CURRENT_SESSION_START=$(date +%Y-%m-%dT%H:%M:%S)

# Prepare git-notes metadata (clean JSON)
METADATA=$(cat << EOF
{
  "title": "Daily Log Update",
  "date": "$TODAY",
  "session_start": "$CURRENT_SESSION_START",
  "type": "daily-log",
  "session_summary": "$SESSION_SUMMARY"
}
EOF
)

echo "📊 Session Info:"
echo "   Daily Log: $DAILY_LOG"
echo "   Session Start: $CURRENT_SESSION_START"

# Commit with git-notes metadata
echo "💾 Committing with git-notes metadata..."
git commit -m "$COMMIT_MSG" -m "metadata_json=$METADATA"

# Push changes
echo "📤 Pushing to remote..."
if git remote get-url origin &>/dev/null; then
    git push origin main 2>/dev/null || git push origin master 2>/dev/null || echo "⚠️  Push failed - check remote"
    echo "✅ Memory sync complete!"
else
    echo "⚠️  No remote configured"
    echo "   Set up with: cd memory && git remote add origin <your-repo-url>"
fi

echo ""
echo "💡 Tip: Use 'git log --notes' to see all stored metadata"
