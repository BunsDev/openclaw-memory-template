#!/bin/bash

# OpenClaw V2 Bootstrap Script
# Initializes V2 structure from existing V1 files

set -e

echo "🐺 OpenClaw V2 Bootstrap"
echo "═══════════════════════════════════════════════════════"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo "Workspace: $WORKSPACE"
echo ""

# 1. Create V2 directory structure
echo "📁 Step 1: Creating V2 Directory Structure"
echo "─────────────────────────────────────────────────────"

mkdir -p "$WORKSPACE/.openclaw"/{core,context,logs,scripts,templates}
mkdir -p "$WORKSPACE/memory"/{daily,projects}

echo "✅ Created: .openclaw/{core,context,logs,scripts,templates}"
echo "✅ Created: memory/{daily,projects}"
echo ""

# 2. Move V1 files to V2 structure
echo "📦 Step 2: Migrating V1 Files to V2 Structure"
echo "─────────────────────────────────────────────────────"

V1_FILES=("IDENTITY.md" "SOUL.md" "AGENTS.md" "USER.md" "TOOLS.md" "HEARTBEAT.md")
CORE_DIR="$WORKSPACE/.openclaw/core"

for file in "${V1_FILES[@]}"; do
    if [ -f "$WORKSPACE/$file" ]; then
        mv "$WORKSPACE/$file" "$CORE_DIR/"
        echo "✅ Moved: $file → .openclaw/core/"
    else
        echo "⚠️  Missing: $file (will use template)"
    fi
done
echo ""

# 3. Initialize Git repository in memory/
echo "🔧 Step 3: Initializing Git Repository in memory/"
echo "─────────────────────────────────────────────────────"

MEMORY_DIR="$WORKSPACE/memory"
cd "$MEMORY_DIR" || exit 1

if [ ! -d ".git" ]; then
    git init
    echo "✅ Git repository initialized"
else
    echo "⚠️  Git repository already exists"
fi

# Create .gitignore for memory repo
if [ ! -f ".gitignore" ]; then
    cat > ".gitignore" << 'EOF'
# OpenClaw V2 Memory Repository .gitignore

# Ignore parent workspace files
*
!/memory/

# But keep memory directory
!.gitignore
!daily/
!projects/
!index.md

# Ignore logs and databases
*.log
*.db
*.sqlite
*.sqlite*

# Ignore Python cache
__pycache__/
*.pyc

# Ignore IDE files
.vscode/
.idea/

# Ignore environment files
.env
.env.*

# Ignore OS files
.DS_Store
Thumbs.db
EOF
    echo "✅ Created: memory/.gitignore"
fi
echo ""

# 4. Create templates
echo "📝 Step 4: Creating Templates"
echo "─────────────────────────────────────────────────────"

TEMPLATES_DIR="$WORKSPACE/.openclaw/templates"

# Daily log template
if [ ! -f "$TEMPLATES_DIR/daily-log.md" ]; then
    cat > "$TEMPLATES_DIR/daily-log.md" << 'EOF'
---
date: {{DATE}}
session_start: {{TIME}}
session_end: 
type: daily-log
status: active
---

# Daily Log - {{DATE}}

## Session
Session started at {{TIME}}

## Active Projects
- [ ] 

## Tasks Completed
- [ ]

## Learnings
- 

## Decisions
- 

## Next Steps
- 
EOF
    echo "✅ Created: templates/daily-log.md"
fi

# Project template
if [ ! -f "$TEMPLATES_DIR/project.md" ]; then
    cat > "$TEMPLATES_DIR/project.md" << 'EOF'
---
project: {{PROJECT_NAME}}
status: active
started: {{DATE}}
type: project-note
---

# {{PROJECT_NAME}}

## Overview
Brief description of the project.

## Status
🟢 Active / 🟡 Paused / 🔴 Archived

## Location
`/path/to/project`

## Key Details
- Important context
- Technical decisions
- Dependencies

## Next Milestone
What's coming next.

## Resources
- Links
- Documentation
- Related files
EOF
    echo "✅ Created: templates/project.md"
fi
echo ""

# 5. Create context registry
echo "🧠 Step 5: Creating Context Registry"
echo "─────────────────────────────────────────────────────"

CONTEXT_DIR="$WORKSPACE/.openclaw/context"
if [ ! -f "$CONTEXT_DIR/LINKS.md" ]; then
    cat > "$CONTEXT_DIR/LINKS.md" << 'EOF'
# Context Registry (LINKS.md)
# External tools, APIs, and resources

## Usage
Add resources here immediately after discovery with format:

```markdown
### Resource Name (YYYY-MM-DD)
**Purpose**: What it does
**Link**: https://example.com
**Use Case**: When to use it
**Discovery**: How you found it
```

---

## CLI Tools

*Add CLI tools here as you discover them*

## APIs

*Add API references here*

## Monitoring

*Add monitoring tools here*

## Project-Specific

*Add project resources here*

---

**Last Updated**: {{DATE}}
EOF
    # Replace placeholder
    sed -i "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$CONTEXT_DIR/LINKS.md"
    echo "✅ Created: context/LINKS.md"
fi
echo ""

# 6. Create first daily log
echo "📅 Step 6: Creating First Daily Log"
echo "─────────────────────────────────────────────────────"

TODAY=$(date +%Y-%m-%d)
DAILY_LOG="$WORKSPACE/memory/daily/$TODAY.md"

if [ ! -f "$DAILY_LOG" ]; then
    cat > "$DAILY_LOG" << EOF
---
date: $TODAY
session_start: $(date +%H:%M)
session_end: 
type: daily-log
status: active
---

# Daily Log - $TODAY

## Session
V2 Bootstrap completed. Memory system initialized.

## Active Projects
- [x] OpenClaw V2 Migration

## Tasks Completed
- [x] Created V2 directory structure
- [x] Migrated V1 files
- [x] Initialized Git repository
- [x] Created templates
- [x] Set up context registry

## Learnings
- V2 provides clean separation of concerns
- Git Notes enables metadata storage without clutter
- Morning Coffee routine enables proactive health checks

## Next Steps
- Configure Git remote
- Start using .openclaw/scripts/sync.sh
- Add resources to LINKS.md

## Decisions
- Migrated from V1 to V2 structure
- Using Git-backed memory for version control
EOF
    echo "✅ Created: memory/daily/$TODAY.md"
else
    echo "⚠️  Daily log already exists: $TODAY"
fi
echo ""

# 7. Create index.md
echo "📚 Step 7: Creating Knowledge Index"
echo "─────────────────────────────────────────────────────"

if [ ! -f "$MEMORY_DIR/index.md" ]; then
    cat > "$MEMORY_DIR/index.md" << 'EOF'
# Knowledge Index

Central index for quick reference across all memory.

## Daily Logs
See `daily/` directory for session-by-session logs.

## Projects
See `projects/` directory for project-specific knowledge.

## Quick Links
- [Today](daily/{{TODAY}}.md)
- [Core Identity](../.openclaw/core/IDENTITY.md)
- [Context Registry](../.openclaw/context/LINKS.md)

## Search
Use `memory_search` in OpenClaw to find specific content.
EOF
    # Replace placeholder
    sed -i "s/{{TODAY}}/$(date +%Y-%m-%d)/g" "$MEMORY_DIR/index.md"
    echo "✅ Created: memory/index.md"
fi
echo ""

# 8. Make scripts executable
echo "🔧 Step 8: Making Scripts Executable"
echo "─────────────────────────────────────────────────────"

chmod +x "$WORKSPACE/.openclaw/scripts/"*.sh
echo "✅ Scripts are now executable"
echo ""

# 9. Initial commit
echo "💾 Step 9: Initial Commit"
echo "─────────────────────────────────────────────────────"

cd "$MEMORY_DIR" || exit 1
if git diff --cached --quiet 2>/dev/null; then
    git add .
    git commit -m "V2 Migration: Initial bootstrap" -m "metadata_json={\"type\":\"bootstrap\",\"date\":\"$(date +%Y-%m-%d)\"}" || echo "⚠️  Nothing to commit"
    echo "✅ Initial commit created"
else
    echo "⚠️  Changes already staged"
fi
echo ""

# Summary
echo "═══════════════════════════════════════════════════════"
echo "✨ V2 Bootstrap Complete!"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo ""
echo "1. Configure Git remote:"
echo "   cd memory"
echo "   git remote add origin https://github.com/YOUR_USERNAME/agent-memory"
echo "   git push -u origin main"
echo ""
echo "2. Customize your files:"
echo "   .openclaw/core/IDENTITY.md"
echo "   .openclaw/core/SOUL.md"
echo "   .openclaw/core/USER.md"
echo ""
echo "3. Run health check:"
echo "   .openclaw/scripts/status.sh"
echo ""
echo "4. Start using V2:"
echo "   .openclaw/scripts/log.sh    # Create daily log"
echo "   # ... work ..."
echo "   .openclaw/scripts/sync.sh   # Sync to Git"
echo ""
echo "🐺 Welcome to OpenClaw V2!"
