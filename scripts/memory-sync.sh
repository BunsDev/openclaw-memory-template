#!/bin/bash
#
# Memory Sync Script
# Handles git operations for memory system
#

set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$WORKSPACE_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if in git repo
if [ ! -d ".git" ]; then
    log_error "Not a git repository. Run setup.sh first."
    exit 1
fi

# Check for changes
if [ -z "$(git status --porcelain)" ]; then
    log_info "No changes to sync"
    exit 0
fi

# Auto mode (for cron)
if [ "$1" == "--auto" ]; then
    git add memory/ MEMORY.md HEARTBEAT.md
    git commit -m "Auto-sync: $(date +%Y-%m-%d %H:%M:%S)" || true
    git push origin main || true
    exit 0
fi

# Interactive mode
echo "🔄 Memory Sync"
echo "=============="
echo ""

# Show status
echo "📊 Changes detected:"
git status --short
echo ""

# Add changes
read -p "Add all changes? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add memory/ MEMORY.md HEARTBEAT.md AGENTS.md
    log_info "Changes staged"
else
    log_warn "Cancelled"
    exit 0
fi

# Commit
read -p "Enter commit message (or press Enter for default): " msg
if [ -z "$msg" ]; then
    msg="Session update: $(date +%Y-%m-%d %H:%M)"
fi

git commit -m "$msg"
log_info "Committed: $msg"

# Push
read -p "Push to remote? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push origin main
    log_info "Pushed to remote"
else
    log_warn "Not pushed (run 'git push' manually)"
fi

echo ""
echo "✅ Sync complete!"
