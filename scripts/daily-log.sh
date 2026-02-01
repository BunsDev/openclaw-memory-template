#!/bin/bash
#
# Daily Log Creator
# Creates a new daily log file from template
#

set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TODAY=$(date +%Y-%m-%d)
LOG_FILE="$WORKSPACE_DIR/memory/$TODAY.md"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if log already exists
if [ -f "$LOG_FILE" ]; then
    echo -e "${YELLOW}[WARN]${NC} Log for today already exists: $LOG_FILE"
    read -p "Open existing log? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ${EDITOR:-nano} "$LOG_FILE"
    fi
    exit 0
fi

# Get template
TEMPLATE="$WORKSPACE_DIR/memory/YYYY-MM-DD.template.md"

if [ ! -f "$TEMPLATE" ]; then
    echo "Error: Template not found at $TEMPLATE"
    exit 1
fi

# Create log from template
AGENT_NAME=$(grep "^\- \*\*Agent\*\*:" "$WORKSPACE_DIR/IDENTITY.md" 2>/dev/null | sed 's/.*: //' | sed 's/\[//' | sed 's/\]//' | awk '{print $1}' || echo "Agent")
USER_NAME=$(grep "^\- \*\*Name\*\*:" "$WORKSPACE_DIR/USER.md" 2>/dev/null | sed 's/.*: //' || echo "User")

cp "$TEMPLATE" "$LOG_FILE"

# Replace placeholders
sed -i '' "s/YYYY-MM-DD/$TODAY/g" "$LOG_FILE" 2>/dev/null || sed -i "s/YYYY-MM-DD/$TODAY/g" "$LOG_FILE"
sed -i '' "s/\[Agent Name\]/$AGENT_NAME/g" "$LOG_FILE" 2>/dev/null || sed -i "s/\[Agent Name\]/$AGENT_NAME/g" "$LOG_FILE"
sed -i '' "s/\[User Name\]/$USER_NAME/g" "$LOG_FILE" 2>/dev/null || sed -i "s/\[User Name\]/$USER_NAME/g" "$LOG_FILE"

echo -e "${GREEN}[INFO]${NC} Created daily log: $LOG_FILE"

# Open in editor
read -p "Open in editor? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ${EDITOR:-nano} "$LOG_FILE"
fi
