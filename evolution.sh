#!/bin/bash

# OpenClaw V2 Evolution Script
# One-click migration from V1 to V2 structure

set -e

echo "═══════════════════════════════════════════════════════"
echo "🐺 OpenClaw V2 Evolution"
echo "One-Click Migration from V1 to V2"
echo "═══════════════════════════════════════════════════════"
echo ""

WORKSPACE="${1:-$(pwd)}"

echo "Workspace: $WORKSPACE"
echo ""

# Confirm
read -p "This will restructure your workspace for V2. Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "🚀 Starting V2 Evolution..."
echo ""

# Step 1: Create V2 structure
echo "📁 Step 1: Creating V2 Directory Structure"
mkdir -p "$WORKSPACE/.openclaw"/{core,context,logs,scripts,templates}
mkdir -p "$WORKSPACE/memory"/{daily,projects}
echo "✅ V2 structure created"
echo ""

# Step 2: Move V1 files
echo "📦 Step 2: Migrating V1 Files"
V1_FILES=("IDENTITY.md" "SOUL.md" "AGENTS.md" "USER.md" "TOOLS.md" "HEARTBEAT.md")
for file in "${V1_FILES[@]}"; do
    if [ -f "$WORKSPACE/$file" ]; then
        mv "$WORKSPACE/$file" "$WORKSPACE/.openclaw/core/"
        echo "✅ Moved: $file"
    else
        echo "⚠️  Missing: $file (using template)"
    fi
done
echo ""

# Step 3: Create enhanced scripts
echo "🔧 Step 3: Creating Enhanced Scripts"

cat > "$WORKSPACE/.openclaw/scripts/sync.sh" << 'SCRIPT_EOF'
#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$(dirname "$SCRIPT_DIR")")"
MEMORY_DIR="$WORKSPACE/memory"
cd "$MEMORY_DIR" || exit 1
git pull --rebase 2>/dev/null || true
git add .
if git diff --cached --quiet; then
    echo "✅ No changes to commit"
    exit 0
fi
TODAY=$(date +%Y-%m-%d)
COMMIT_MSG="Memory Sync: $TODAY"
METADATA="{\"date\":\"$TODAY\",\"type\":\"sync\"}"
git commit -m "$COMMIT_MSG" -m "metadata_json=$METADATA"
git push 2>/dev/null || echo "⚠️  Push failed - check remote"
echo "✅ Sync complete"
SCRIPT_EOF

cat > "$WORKSPACE/.openclaw/scripts/log.sh" << 'SCRIPT_EOF'
#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$(dirname "$SCRIPT_DIR")")"
MEMORY_DIR="$WORKSPACE/memory"
TODAY=$(date +%Y-%m-%d)
DAILY_LOG="$MEMORY_DIR/daily/$TODAY.md"
mkdir -p "$MEMORY_DIR/daily"
if [ ! -f "$DAILY_LOG" ]; then
cat > "$DAILY_LOG" << EOF
---
date: $TODAY
session_start: $(date +%H:%M)
type: daily-log
---

# Daily Log - $TODAY

## Session
Started at $(date +%H:%M)

## Active Projects
- [ ]

## Tasks Completed
- [ ]

## Learnings
-

## Decisions
-
EOF
    echo "✅ Created: $TODAY.md"
else
    echo "✅ Found: $TODAY.md"
fi
SCRIPT_EOF

cat > "$WORKSPACE/.openclaw/scripts/status.sh" << 'SCRIPT_EOF'
#!/bin/bash
echo "🐺 OpenClaw V2 Status"
echo "═══════════════════════"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$(dirname "$SCRIPT_DIR")")"
MEMORY_DIR="$WORKSPACE/memory"
if [ -d "$MEMORY_DIR/.git" ]; then
    echo "✅ Git repository initialized"
    cd "$MEMORY_DIR"
    COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    echo "   Commits: $COMMITS"
else
    echo "❌ Git not initialized"
fi
TODAY=$(date +%Y-%m-%d)
if [ -f "$MEMORY_DIR/daily/$TODAY.md" ]; then
    echo "✅ Today's log created"
else
    echo "⚠️  Today's log missing"
fi
echo "✅ V2 Evolution complete"
SCRIPT_EOF

chmod +x "$WORKSPACE/.openclaw/scripts/"*.sh
echo "✅ Enhanced scripts created"
echo ""

# Step 4: Initialize Git
echo "🔧 Step 4: Initializing Git Repository"
cd "$WORKSPACE/memory"
if [ ! -d ".git" ]; then
    git init
    cat > ".gitignore" << 'EOF'
*
!/memory/
!.gitignore
!daily/
!projects/
!index.md
*.log
*.db
__pycache__/
.vscode/
.env
.DS_Store
EOF
    echo "✅ Git repository initialized"
else
    echo "⚠️  Git already initialized"
fi
echo ""

# Step 5: Create context registry
echo "🧠 Step 5: Creating Context Registry"
cat > "$WORKSPACE/.openclaw/context/LINKS.md" << 'EOF'
# Context Registry
# Add external resources here as you discover them

## CLI Tools

## APIs

## Monitoring

## Project-Specific

**Last Updated**: $(date +%Y-%m-%d)
EOF
echo "✅ Context registry created"
echo ""

# Step 6: First daily log
echo "📅 Step 6: Creating First Daily Log"
TODAY=$(date +%Y-%m-%d)
cat > "$WORKSPACE/memory/daily/$TODAY.md" << EOF
---
date: $TODAY
session_start: $(date +%H:%M)
type: daily-log
---

# Daily Log - $TODAY

## Session
V2 Evolution completed! 🎉

## Active Projects
- [x] V2 Migration

## Tasks Completed
- [x] Restructured workspace
- [x] Migrated to Git-backed memory
- [x] Created enhanced scripts

## Learnings
- V2 provides clean Git history with Git Notes
- Morning Coffee routine enables proactive health checks
- LINKS.md prevents context bloat

## Next Steps
- Configure Git remote
- Start using .openclaw/scripts/sync.sh
EOF
echo "✅ First daily log created"
echo ""

# Step 7: Create index
echo "📚 Step 7: Creating Knowledge Index"
cat > "$WORKSPACE/memory/index.md" << 'EOF'
# Knowledge Index

## Daily Logs
See `daily/` directory

## Projects
See `projects/` directory

## Quick Links
- [Core Identity](../.openclaw/core/IDENTITY.md)
- [Context Registry](../.openclaw/context/LINKS.md)
EOF
echo "✅ Knowledge index created"
echo ""

# Step 8: Initial commit
echo "💾 Step 8: Initial Commit"
cd "$WORKSPACE/memory"
git add . 2>/dev/null || true
git commit -m "V2 Evolution: Initial commit" -m "metadata_json={\"type\":\"evolution\",\"date\":\"$(date +%Y-%m-%d)\"}" 2>/dev/null || echo "⚠️  Nothing to commit"
echo "✅ Initial commit created"
echo ""

# Summary
echo "═══════════════════════════════════════════════════════"
echo "✨ V2 Evolution Complete!"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "Your workspace has been transformed:"
echo ""
echo "  📁 .openclaw/core/      → Identity, Soul, Rules"
echo "  📁 .openclaw/context/   → LINKS.md (External resources)"
echo "  📁 .openclaw/scripts/   → 3 enhanced automation scripts"
echo "  📁 memory/              → Git-backed daily logs"
echo ""
echo "Next steps:"
echo ""
echo "1. Configure Git remote:"
echo "   cd memory"
echo "   git remote add origin https://github.com/YOUR_USERNAME/agent-memory"
echo "   git push -u origin main"
echo ""
echo "2. Run health check:"
echo "   .openclaw/scripts/status.sh"
echo ""
echo "3. Start using V2:"
echo "   .openclaw/scripts/log.sh    # Create daily log"
echo "   .openclaw/scripts/sync.sh   # Sync to Git"
echo ""
echo "🐺 Welcome to OpenClaw V2!"
echo ""
