#!/bin/bash

# OpenClaw Daily Log Script (V2)
# Creates/updates daily log with template-based structure

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$(dirname "$SCRIPT_DIR")")"
MEMORY_DIR="$WORKSPACE/memory"
TEMPLATES_DIR="$WORKSPACE/.openclaw/templates"
TODAY=$(date +%Y-%m-%d)
DAILY_LOG="$MEMORY_DIR/daily/$TODAY.md"

echo "📝 Daily Log: $TODAY"

# Create daily directory if not exists
mkdir -p "$MEMORY_DIR/daily"

# Check if today's log exists
if [ -f "$DAILY_LOG" ]; then
    echo "📄 Found existing log: $DAILY_LOG"
    echo "✅ Daily log ready"
else
    echo "🆕 Creating new daily log..."
    
    # Get template
    if [ -f "$TEMPLATES_DIR/daily-log.md" ]; then
        TEMPLATE="$TEMPLATES_DIR/daily-log.md"
    else
        # Create default template inline
        TEMPLATE="/dev/stdin"
    fi
    
    # Create log with template
    cat > "$DAILY_LOG" << 'EOF'
---
date: 2026-02-03
session_start: 09:00
session_end: 
type: daily-log
status: active
---

# Daily Log - 2026-02-03

## Session
Session started at 09:00

## Active Projects
- [ ] Project 1
- [ ] Project 2

## Tasks Completed
- [ ]

## Learnings
- 

## Decisions
- 

## Next Steps
- 

EOF

    # Replace placeholder dates with actual dates
    sed -i "s/2026-02-03/$(date +%Y-%m-%d)/g" "$DAILY_LOG"
    sed -i "s/09:00/$(date +%H:%M)/g" "$DAILY_LOG"
    
    echo "✅ Daily log created: $DAILY_LOG"
fi

echo ""
echo "💡 Tip: Edit with your preferred editor:"
echo "   nano $DAILY_LOG"
echo "   code $DAILY_LOG"
