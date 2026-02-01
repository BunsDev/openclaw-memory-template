#!/bin/bash
#
# OpenClaw Memory System - Setup Script
# Run this to initialize a production-ready agent memory system
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="${1:-$(pwd)}"

echo "🧠 OpenClaw Memory System Setup"
echo "==============================="
echo ""
echo "Target directory: $WORKSPACE_DIR"
echo ""

# Confirm
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p "$WORKSPACE_DIR/memory"
mkdir -p "$WORKSPACE_DIR/docs"
mkdir -p "$WORKSPACE_DIR/scripts"
mkdir -p "$WORKSPACE_DIR/.claude"

# Copy template files
echo "📝 Copying template files..."

# Core memory files
cp "$SCRIPT_DIR/templates/MEMORY.md" "$WORKSPACE_DIR/MEMORY.md"
cp "$SCRIPT_DIR/templates/AGENTS.md" "$WORKSPACE_DIR/AGENTS.md"
cp "$SCRIPT_DIR/templates/HEARTBEAT.md" "$WORKSPACE_DIR/HEARTBEAT.md"
cp "$SCRIPT_DIR/templates/IDENTITY.md" "$WORKSPACE_DIR/IDENTITY.md"
cp "$SCRIPT_DIR/templates/SOUL.md" "$WORKSPACE_DIR/SOUL.md"
cp "$SCRIPT_DIR/templates/USER.md" "$WORKSPACE_DIR/USER.md"
cp "$SCRIPT_DIR/templates/TOOLS.md" "$WORKSPACE_DIR/TOOLS.md"

# Daily log template
cp "$SCRIPT_DIR/templates/memory/YYYY-MM-DD.md" "$WORKSPACE_DIR/memory/YYYY-MM-DD.template.md"

# Scripts
cp "$SCRIPT_DIR/scripts/memory-sync.sh" "$WORKSPACE_DIR/scripts/"
cp "$SCRIPT_DIR/scripts/daily-log.sh" "$WORKSPACE_DIR/scripts/"
cp "$SCRIPT_DIR/scripts/backup.sh" "$WORKSPACE_DIR/scripts/"
chmod +x "$WORKSPACE_DIR/scripts/"*.sh

# Git setup
echo "🔧 Initializing git repository..."
cd "$WORKSPACE_DIR"

if [ ! -d ".git" ]; then
    git init
    git add .
    git commit -m "Initial memory system setup"
    echo "✅ Git repository initialized"
else
    echo "⚠️  Git repository already exists"
fi

# Create .gitignore if not exists
if [ ! -f ".gitignore" ]; then
    cat > ".gitignore" << 'EOF'
# Secrets
.env
*.key
*.pem
config/secrets*

# Logs
*.log
logs/

# Temporary files
.tmp/
tmp/
*.tmp

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Large files
*.db-journal
*.sqlite-journal
EOF
    git add .gitignore
    git commit -m "Add .gitignore"
fi

# Setup completion
echo ""
echo "==============================="
echo "✅ Setup Complete!"
echo "==============================="
echo ""
echo "Next steps:"
echo ""
echo "1. Customize your files:"
echo "   - MEMORY.md    → Edit with your agent's knowledge"
echo "   - IDENTITY.md  → Set agent name and persona"
echo "   - USER.md      → Add your preferences"
echo "   - SOUL.md      → Define behavior and tone"
echo ""
echo "2. Set up git sync (optional but recommended):"
echo "   git remote add origin https://github.com/YOUR_USERNAME/clawdbot-memory"
echo "   git push -u origin main"
echo ""
echo "3. Start using:"
echo "   - Create daily logs: ./scripts/daily-log.sh"
echo "   - Auto-sync: ./scripts/memory-sync.sh --auto"
echo "   - Manual backup: ./scripts/backup.sh"
echo ""
echo "4. Read the guide:"
echo "   cat README.md"
echo ""
echo "🐺 Your agent now has persistent memory!"
