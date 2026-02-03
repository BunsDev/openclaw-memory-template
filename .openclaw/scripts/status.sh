#!/bin/bash

# OpenClaw Memory Status Script (V2)
# Instant health check and memory overview

echo "═══════════════════════════════════════════════════════"
echo "🐺 OpenClaw V2 Memory Status"
echo "═══════════════════════════════════════════════════════"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$(dirname "$SCRIPT_DIR")")"
MEMORY_DIR="$WORKSPACE/memory"
TODAY=$(date +%Y-%m-%d)

# 1. Git Status
echo "📊 Git Repository"
echo "─────────────────────────────────────────────────────"
if [ -d "$MEMORY_DIR/.git" ]; then
    cd "$MEMORY_DIR" || exit 1
    COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    LAST_COMMIT=$(git log -1 --format="%cr" 2>/dev/null || echo "No commits yet")
    BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
    
    echo "  Status: ✅ Git repository initialized"
    echo "  Branch: $BRANCH"
    echo "  Commits: $COMMIT_COUNT"
    echo "  Last update: $LAST_COMMIT"
    
    # Check remote
    if git remote get-url origin &>/dev/null; then
        REMOTE=$(git remote get-url origin)
        echo "  Remote: ✅ Configured ($REMOTE)"
    else
        echo "  Remote: ⚠️  Not configured"
        echo "         Run: cd memory && git remote add origin <url>"
    fi
    
    # Check for uncommitted changes
    if git diff --cached --quiet 2>/dev/null; then
        echo "  Uncommitted: ✅ Clean"
    else
        echo "  Uncommitted: ⚠️  Changes pending"
        echo "         Run: .openclaw/scripts/sync.sh"
    fi
else
    echo "  Status: ❌ Git repository NOT initialized"
    echo "  Run: cd memory && git init"
fi
echo ""

# 2. Daily Logs
echo "📅 Daily Logs"
echo "─────────────────────────────────────────────────────"
if [ -d "$MEMORY_DIR/daily" ]; then
    LOG_COUNT=$(ls -1 "$MEMORY_DIR/daily"/*.md 2>/dev/null | wc -l)
    TODAY_LOG="$MEMORY_DIR/daily/$TODAY.md"
    
    echo "  Total logs: $LOG_COUNT"
    
    if [ -f "$TODAY_LOG" ]; then
        echo "  Today's log: ✅ Created"
        LINES=$(wc -l < "$TODAY_LOG")
        echo "  Lines today: $LINES"
    else
        echo "  Today's log: ⚠️  Not created yet"
        echo "         Run: .openclaw/scripts/log.sh"
    fi
else
    echo "  Status: ❌ Daily directory missing"
    echo "  Run: mkdir -p memory/daily"
fi
echo ""

# 3. File Structure
echo "📁 File Structure"
echo "─────────────────────────────────────────────────────"
CORE_FILES=("IDENTITY.md" "SOUL.md" "AGENTS.md" "USER.md" "TOOLS.md" "HEARTBEAT.md")
CORE_DIR="$WORKSPACE/.openclaw/core"

for file in "${CORE_FILES[@]}"; do
    if [ -f "$CORE_DIR/$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ⚠️  $file (missing)"
    fi
done
echo ""

# 4. Scripts
echo "🔧 Scripts"
echo "─────────────────────────────────────────────────────"
SCRIPT_DIR="$WORKSPACE/.openclaw/scripts"
SCRIPTS=("init.sh" "sync.sh" "log.sh" "status.sh" "fix-thermal-monitor.sh")

for script in "${SCRIPTS[@]}"; do
    if [ -f "$SCRIPT_DIR/$script" ]; then
        if [ -x "$SCRIPT_DIR/$script" ]; then
            echo "  ✅ $script (executable)"
        else
            echo "  ⚠️  $script (not executable - run: chmod +x)"
        fi
    else
        echo "  ❌ $script (missing)"
    fi
done
echo ""

# 5. Context Registry
echo "🧠 Context Registry"
echo "─────────────────────────────────────────────────────"
LINKS_FILE="$WORKSPACE/.openclaw/context/LINKS.md"
if [ -f "$LINKS_FILE" ]; then
    ENTRIES=$(grep -c "^### " "$LINKS_FILE" 2>/dev/null || echo "0")
    echo "  Status: ✅ LINKS.md exists"
    echo "  Entries: $ENTRIES resources documented"
else
    echo "  Status: ⚠️  LINKS.md not found"
    echo "         Create: .openclaw/context/LINKS.md"
fi
echo ""

# 6. System Health (optional)
echo "💻 System Health"
echo "─────────────────────────────────────────────────────"
if command -v vcgencmd &>/dev/null; then
    TEMP=$(vcgencmd measure_temp 2>/dev/null | cut -d'=' -f2 | cut -d"'" -f1 || echo "N/A")
    echo "  Pi CPU Temp: $TEMP"
else
    echo "  Pi CPU Temp: N/A (not a Raspberry Pi or vcgencmd not available)"
fi

echo ""
echo "═══════════════════════════════════════════════════════"
echo "✨ V2 Status Check Complete"
echo "═══════════════════════════════════════════════════════"
