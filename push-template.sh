#!/bin/bash
#
# Push template to GitHub
# Run this after customizing
#

set -e

cd "$(dirname "$0")"

echo "🚀 Preparing template for GitHub..."
echo ""

# Check if git repo
if [ ! -d ".git" ]; then
    echo "Initializing git..."
    git init
fi

# Add all files
echo "📦 Adding files..."
git add .

# Commit
echo "💾 Committing..."
git commit -m "v2.0.0 - Production-ready memory template

Features:
- 10 core template files
- 3 automation scripts
- Example MEMORY.md
- Comprehensive README
- Multi-agent sync guide
- Security best practices

Based on:
- Daniel Miessler's PAI Framework
- Armin Ronacher's Pi philosophy
- Production testing by Artale

Ready for community replication." || true

echo ""
echo "✅ Template ready!"
echo ""
echo "Next steps:"
echo "1. Ensure you're in the right repo"
echo "2. Set remote: git remote add origin https://github.com/arosstale/openclaw-memory-template"
echo "3. Push: git push -u origin main"
echo ""
echo "Or manually:"
echo "  git remote -v"
echo "  git push origin main"
