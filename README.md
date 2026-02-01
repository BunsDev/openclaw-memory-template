# OpenClaw Memory Template 🧠

> **Production-ready memory system for OpenClaw/Clawdbot agents**

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/arosstale/openclaw-memory-template)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A comprehensive, production-ready memory system template for OpenClaw agents. Based on Daniel Miessler's PAI framework, Armin Ronacher's Pi philosophy, and real-world production usage.

---

## 🎯 What This Is

This template provides a **complete memory architecture** for AI agents that:

- ✅ Persists knowledge across sessions
- ✅ Maintains daily context and decision history
- ✅ Syncs via Git for backup and multi-device access
- ✅ Self-documents through structured templates
- ✅ Integrates seamlessly with OpenClaw's memory tools

---

## 🚀 Quick Start

### 1. Clone the Template

```bash
git clone https://github.com/arosstale/openclaw-memory-template.git
cd openclaw-memory-template
```

### 2. Run Setup

```bash
./setup.sh ~/my-clawdbot-workspace
```

Or run in current directory:

```bash
./setup.sh
```

### 3. Customize

Edit the template files with your agent's identity:

```bash
cd ~/my-clawdbot-workspace

# Required
code MEMORY.md      # Core knowledge base
code IDENTITY.md    # Agent persona
code USER.md        # Your preferences

# Optional but recommended
code SOUL.md        # Behavior guidelines
code TOOLS.md       # Tool-specific notes
code HEARTBEAT.md   # Automated tasks
```

### 4. Start Using

```bash
# Create today's log
./scripts/daily-log.sh

# Sync to git
./scripts/memory-sync.sh

# Create backup
./scripts/backup.sh
```

---

## 📁 File Structure

```
workspace/
├── MEMORY.md                    # 🧠 Core knowledge base (READ AT START)
├── AGENTS.md                    # 📖 Workspace guide for agents
├── HEARTBEAT.md                 # 📋 Automated task checklist
├── IDENTITY.md                  # 🎭 Agent persona & identity
├── SOUL.md                      # 💫 Behavior & tone guidelines
├── USER.md                      # 👤 User profile & preferences
├── TOOLS.md                     # 🛠️ Tool-specific notes
├── memory/
│   ├── 2026-01-31.md           # 📅 Daily session logs
│   ├── 2026-01-30.md
│   └── YYYY-MM-DD.template.md  # 📝 Template for new logs
├── scripts/
│   ├── memory-sync.sh          # 🔄 Git sync script
│   ├── daily-log.sh            # 📄 Create daily log
│   └── backup.sh               # 💾 Backup creator
├── docs/                        # 📚 Documentation
└── .git/                        # 🔀 Version control
```

---

## 🧠 Core Files Explained

### MEMORY.md
**The brain of your agent.** Loaded automatically at every session start.

Contains:
- Identity & persona
- System specs
- Active projects
- Key preferences
- Important context
- Quick reference

**Keep it:** Concise, factual, up-to-date

### AGENTS.md
**Workspace rules.** How the agent should operate.

Contains:
- First-run instructions
- Daily memory ritual
- File structure guide
- Safety defaults

### HEARTBEAT.md
**Automation checklist.** Periodic tasks that need attention.

Contains:
- Daily tasks
- Weekly reviews
- Monthly audits
- Cron setup instructions

### IDENTITY.md
**Who the agent is.** Name, avatar, vibe.

Contains:
- Name & creature
- Communication style
- Role & persona
- Signature phrase

### SOUL.md
**How the agent behaves.** Core principles and boundaries.

Contains:
- Communication guidelines
- Decision-making rules
- Do/don't lists
- Evolution notes

### USER.md
**Who you are.** Your preferences, goals, style.

Contains:
- Background & expertise
- Communication preferences
- Goals & priorities
- Technical preferences

### TOOLS.md
**External tools.** Custom integrations and patterns.

Contains:
- Custom tool documentation
- External API notes
- Common patterns
- Troubleshooting

---

## 📅 Daily Workflow

### Session Start (Automatic)

1. OpenClaw reads `MEMORY.md`
2. Agent reads today's log (if exists)
3. Agent reads yesterday's log

### During Session

```bash
# Search prior work
memory_search "trading strategy"

# Get specific file
memory_get "path/to/file.md" --from 1 --lines 50

# Agent auto-captures decisions to MEMORY.md
```

### Session End

```bash
# 1. Update daily log
./scripts/daily-log.sh

# 2. Review and edit the log
# (opens in your default editor)

# 3. Sync to git
./scripts/memory-sync.sh

# Or auto-sync:
./scripts/memory-sync.sh --auto
```

---

## 🔧 Automation

### Cron Setup

Add to crontab for automatic sync:

```bash
# Edit crontab
crontab -e

# Add daily auto-sync at 2 AM
0 2 * * * cd ~/your-workspace && ./scripts/memory-sync.sh --auto

# Add weekly backup on Sundays
0 3 * * 0 cd ~/your-workspace && ./scripts/backup.sh
```

### Git Auto-Sync

Enable auto-commit on file changes (optional):

```bash
# Install watchdog
pip install watchdog

# Create watcher script
# (see docs/auto-watch.md)
```

---

## 🔄 Multi-Agent Sync

For multiple Clawdbot instances:

### Primary Instance (VPS)

```bash
# Already set up with ./setup.sh
git remote add github https://github.com/YOUR_USERNAME/clawdbot-memory
git push -u origin main
```

### Secondary Instance (Local)

```bash
# Clone memory repo
git clone https://github.com/YOUR_USERNAME/clawdbot-memory.git ~/clawdbot-memory

# Either symlink or copy to workspace
ln -s ~/clawdbot-memory/memory ~/your-workspace/memory
cp ~/clawdbot-memory/MEMORY.md ~/your-workspace/

# Set up sync cron
*/5 * * * * cd ~/your-workspace && git pull && ./scripts/memory-sync.sh --auto
```

---

## 📊 Best Practices

### 1. Keep MEMORY.md High-Level
- Store durable facts (preferences, active projects)
- Link to detailed logs in `memory/`
- Update when projects change status

### 2. Daily Logs Are Detailed
- Capture what you did
- Note blockers and decisions
- Include file paths and commands

### 3. Use Git Religiously
```bash
# Daily commit ritual
./scripts/memory-sync.sh

# Or one-liner
git add memory/ MEMORY.md && git commit -m "$(date +%Y-%m-%d) session" && git push
```

### 4. Search Before Answering

Always run `memory_search` before answering questions about:
- Prior decisions
- Project status
- User preferences
- Past work

### 5. Structured Format

Use consistent headers for easy parsing:
- `## Identity` — Who/what
- `## System` — Technical specs
- `## Active Projects` — Current work
- `## Key Preferences` — User wants
- `## Dated Logs` — Historical reference

---

## 🎨 Customization

### Change Agent Identity

```bash
code IDENTITY.md
# Edit: Name, creature, emoji, vibe
code SOUL.md
# Edit: Communication style, boundaries
```

### Add New Project

In `MEMORY.md`:

```markdown
### New Project Name
- **Location**: `/path/to/project`
- **Status**: 🟢 Active
- **Started**: 2026-02-01
- **Key Details**: Important context
- **Next Milestone**: What's coming
```

### Customize Daily Log Template

```bash
code memory/YYYY-MM-DD.template.md
# Edit the template with your preferred sections
```

---

## 🔐 Security

### Never Store in Memory:
- API keys (use `.env`)
- Passwords (use password manager)
- Private keys (use secure storage)
- Personal identifiable information (PII)

### Safe to Store:
- Project context
- Technical decisions
- Preferences and style
- Workflow patterns
- Tool configurations

### Use `.gitignore`:

```bash
# Already included in template:
.env
*.key
*.pem
config/secrets*
```

---

## 🐛 Troubleshooting

### Memory Not Loading?
- Ensure files are in workspace root
- Check file permissions: `chmod 644 MEMORY.md`
- Verify markdown formatting

### Git Push Fails?
- Check remote: `git remote -v`
- Set upstream: `git push -u origin main`
- Check credentials/token

### Search Not Finding Content?
- Ensure `memory/*.md` files exist
- Run `memory_search` with specific queries
- Check file encoding (UTF-8)

### Daily Log Not Creating?
- Check template exists: `memory/YYYY-MM-DD.template.md`
- Verify write permissions: `ls -la memory/`

---

## 🚀 Advanced Features

### Custom Scripts

Add your own scripts to `scripts/`:

```bash
#!/bin/bash
# scripts/my-custom-script.sh

# Your automation here
echo "Custom automation running..."
```

### Integration with Other Tools

#### Notion
```bash
# Export daily log to Notion
# (requires Notion API integration)
```

#### Obsidian
```bash
# Sync memory to Obsidian vault
ln -s ~/your-workspace/memory ~/Obsidian/AgentMemory
```

#### Telegram
```bash
# Send daily summary to Telegram
# (requires bot setup)
```

---

## 📚 Philosophy

This template is built on three principles:

### 1. Minimal Core (from Pi)
- Few files, clear structure
- No unnecessary complexity
- Agents extend themselves via code

### 2. Self-Documenting (from PAI)
- Memory captures its own evolution
- Decisions are recorded
- Context persists across sessions

### 3. Terminal-Native (from OpenClaw)
- CLI-first workflow
- Git-based sync
- No GUI friction

---

## 🤝 Contributing

This is a template—fork and customize for your needs!

Share your variations:
- Custom scripts
- Additional templates
- Workflow improvements
- Integration examples

---

## 📄 License

MIT — Use, modify, share freely. Attribution appreciated.

---

## 🙏 Credits

- **Daniel Miessler** - PAI Framework inspiration
- **Armin Ronacher** - Pi agent philosophy
- **Mario Zechner** - Pi implementation
- **Peter Steinberger** - OpenClaw vision
- **Artale** - Production testing & feedback

---

## 🔗 Resources

- [OpenClaw Docs](https://docs.openclaw.ai)
- [Daniel Miessler's PAI Framework](https://github.com/danielmiessler/Personal_AI_Infrastructure)
- [Armin Ronacher's Pi Post](https://lucumr.pocoo.org/2026/1/31/pi/)
- [ClawdHub](https://clawdhub.com) - Community skills

---

**🐺 Your agent now has persistent memory. Time to build.**
