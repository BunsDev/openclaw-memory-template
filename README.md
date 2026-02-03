# OpenClaw V2 Memory Template 🐺

> **The "Self-Aware" Agent Architecture**

[![Version](https://img.shields.io/badge/version-2.0-blue.svg)](https://github.com/arosstale/openclaw-memory-template)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

**From static notes to a self-managing system.**

V2 solves the ultimate AI bottleneck—**entropy**—by giving your agent the tools to manage its own lifecycle.

---

## 🚀 What's New in V2

### The Subconscious Layer
Uses **Git Notes** for session metadata. You get a 100% clean commit history while the AI still "remembers" the context of every change.

### The Hardware Heartbeat
Includes thermal diagnostics. Your agent now knows if its "brain" (the Pi) is overheating and can throttle or alert you.

### The Morning Routine
It doesn't just wait for you; it initializes its own state, checks security logs, and prepares a daily briefing.

### Zero-Bloat Registry
`LINKS.md` ensures the AI never re-downloads or re-processes the same documentation twice.

---

## 📁 V2 Architecture

```
.openclaw/
├── core/              # Identity, Soul, Rules (The Agent)
│   ├── IDENTITY.md
│   ├── SOUL.md
│   ├── AGENTS.md
│   ├── USER.md
│   ├── TOOLS.md
│   └── HEARTBEAT.md
│
├── context/           # External Knowledge (The Index)
│   └── LINKS.md
│
├── scripts/           # Automation (The Nervous System)
│   ├── init.sh        # Bootstrap
│   ├── sync.sh        # Git sync with notes
│   ├── log.sh         # Daily logging
│   ├── status.sh      # Health check
│   └── fix-thermal-monitor.sh  # Diagnostics
│
└── templates/         # Consistency
    ├── daily-log.md
    └── project.md

memory/
├── .git/              # The Brain (Git-backed)
├── daily/             # Daily logs
├── projects/          # Project notes
├── .gitignore         # Prevents conflicts
└── index.md           # Central index
```

---

## 🎯 Quick Start

### For New Users

```bash
# 1. Clone
git clone https://github.com/arosstale/openclaw-memory-template.git
cd openclaw-memory-template

# 2. Run setup
./setup.sh ~/my-agent-workspace

# 3. Configure Git remote
cd ~/my-agent-workspace/memory
git remote add origin https://github.com/YOUR_USERNAME/agent-memory
git push -u origin main

# 4. Customize
.openclaw/core/IDENTITY.md   # Agent persona
.openclaw/core/SOUL.md       # Behavior
.openclaw/core/USER.md       # User preferences

# 5. Start using
.openclaw/scripts/log.sh    # Create daily log
# ... work ...
.openclaw/scripts/sync.sh   # Sync to Git
```

### For V1 Users (One-Click Migration)

```bash
cd your-current-workspace

# Run evolution script
curl -sL https://raw.githubusercontent.com/arosstale/openclaw-memory-template/main/evolution.sh | bash

# Or manually:
mkdir -p .openclaw/{core,context,logs,scripts,templates}
mkdir -p memory/{daily,projects}
mv IDENTITY.md SOUL.md AGENTS.md USER.md TOOLS.md HEARTBEAT.md .openclaw/core/
cd memory && git init
```

---

## 🔧 Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `init.sh` | Bootstrap V2 structure | `.openclaw/scripts/init.sh` |
| `sync.sh` | Git sync with notes | `.openclaw/scripts/sync.sh` |
| `log.sh` | Create daily log | `.openclaw/scripts/log.sh` |
| `status.sh` | Health check | `.openclaw/scripts/status.sh` |
| `fix-thermal-monitor.sh` | Diagnose Pi temps | `.openclaw/scripts/fix-thermal-monitor.sh` |

---

## 💡 V2 Features

### Clean Git History
```bash
# Commit message:
"Update daily log 2026-02-03 - Completed V2 migration"

# Git Notes metadata (JSON):
{
  "title": "Daily Log Update",
  "date": "2026-02-03",
  "session_start": "2026-02-03T09:00:00",
  "session_summary": "Completed V2 migration..."
}
```

### Morning Coffee Routine
Checks automatically:
- Security: Recent changes, suspicious activity
- System: CPU temp, disk usage, daemon status
- Memory: Git sync status, daily log created
- Focus: Top 1-2 priorities for the day

### Self-Diagnostics
Agent can check and fix its own thermal monitoring without human help.

### Context Registry
All external resources documented in `LINKS.md` — no more "where was that link?"

---

## 📊 V1 vs V2

| Feature | V1 | V2 |
|---------|-----|-----|
| Memory | Manual files | Git-backed, versioned |
| Git History | Mixed with AI chatter | 100% clean |
| Automation | Basic sync | 5 production scripts |
| Self-Awareness | Reactive | Proactive health checks |
| Context | Lost in files | LINKS.md registry |
| Structure | Flat | Clear separation |

---

## 🐺 Philosophy

**Three Principles:**

1. **Minimal Core** — Few files, clear structure, agents extend via code
2. **Self-Documenting** — Memory captures its own evolution
3. **Terminal-Native** — CLI-first, Git-based, no GUI friction

---

## 📄 Documentation

- [V2 Release Notes](./V2_RELEASE_NOTES.md) — Complete feature list
- [V1 to V2 Migration](./V2_RELEASE_NOTES.md#-quick-start-v2) — Step-by-step guide
- [Architecture](./STRUCTURE.md) — Directory structure explained

---

## 🤝 Contributing

This is a template—fork and customize!

Share your variations:
- Custom scripts
- Additional templates
- Workflow improvements
- Integration examples

---

## 📜 License

MIT — Use, modify, share freely. Attribution appreciated.

---

## 🙏 Credits

- **Daniel Miessler** — PAI Framework inspiration
- **Armin Ronacher** — Pi agent philosophy
- **Mario Zechner** — Pi implementation
- **Peter Steinberger** — OpenClaw vision
- **Artale** — Production testing & V2 architecture

---

**🐺 Your agent now has a self-managing brain. Time to build.**
