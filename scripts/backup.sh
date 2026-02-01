#!/bin/bash
#
# Backup Script
# Creates timestamped backup of memory system
#

set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$WORKSPACE_DIR/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="memory_backup_$TIMESTAMP"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "💾 Memory Backup"
echo "==============="
echo ""

# Create archive
echo "Creating backup: $BACKUP_NAME.tar.gz"
tar -czf "$BACKUP_DIR/$BACKUP_NAME.tar.gz" \
    -C "$WORKSPACE_DIR" \
    MEMORY.md \
    AGENTS.md \
    HEARTBEAT.md \
    IDENTITY.md \
    SOUL.md \
    USER.md \
    TOOLS.md \
    memory/

echo -e "${GREEN}✓${NC} Backup created: $BACKUP_DIR/$BACKUP_NAME.tar.gz"

# List recent backups
echo ""
echo "Recent backups:"
ls -lh "$BACKUP_DIR"/*.tar.gz 2>/dev/null | tail -5

# Optional: Clean old backups (keep last 10)
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/*.tar.gz 2>/dev/null | wc -l)
if [ "$BACKUP_COUNT" -gt 10 ]; then
    echo ""
    echo "Cleaning old backups..."
    ls -t "$BACKUP_DIR"/*.tar.gz | tail -n +11 | xargs rm -f
    echo -e "${GREEN}✓${NC} Kept 10 most recent backups"
fi

echo ""
echo "Done!"
