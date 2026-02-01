# Template Structure

```
openclaw-memory-template/
│
├── 📄 README.md                    # Main documentation (10KB)
├── 📄 LICENSE                      # MIT License
├── 📄 TEMPLATE_SUMMARY.md          # Quick overview
├── 📄 STRUCTURE.md                 # This file
│
├── 🔧 setup.sh                     # One-command setup
├── 🚀 push-template.sh             # Push to GitHub helper
│
├── 📁 templates/                   # Core template files
│   │
│   ├── 🧠 MEMORY.md               # Main knowledge base
│   ├── 📖 AGENTS.md               # Workspace guide
│   ├── 📋 HEARTBEAT.md            # Automation checklist
│   ├── 🎭 IDENTITY.md             # Agent persona
│   ├── 💫 SOUL.md                 # Behavior guidelines
│   ├── 👤 USER.md                 # User profile
│   ├── 🛠️ TOOLS.md                # Tool notes
│   ├── 🚫 .gitignore              # Security exclusions
│   │
│   └── 📁 memory/
│       └── YYYY-MM-DD.md          # Daily log template
│
├── 📁 scripts/                     # Automation scripts
│   ├── 🔄 memory-sync.sh          # Git sync
│   ├── 📄 daily-log.sh            # Create daily logs
│   └── 💾 backup.sh               # Backup creator
│
├── 📁 examples/                    # Example files
│   └── MEMORY.example.md          # Filled-out example
│
└── 📁 docs/                        # Additional docs (optional)
    └── (user can add)
```

## File Purposes

### Core Memory (7 files)
| File | Purpose | Auto-Read |
|------|---------|-----------|
| MEMORY.md | Main knowledge base | ✅ Yes |
| AGENTS.md | Workspace rules | ✅ Yes |
| HEARTBEAT.md | Task checklist | ⚡ On heartbeat |
| IDENTITY.md | Agent identity | 📖 Reference |
| SOUL.md | Behavior guide | 📖 Reference |
| USER.md | User profile | 📖 Reference |
| TOOLS.md | Tool notes | 📖 Reference |

### Scripts (4 files)
| Script | Purpose | Usage |
|--------|---------|-------|
| setup.sh | Initialize workspace | `./setup.sh ~/workspace` |
| memory-sync.sh | Git sync | `./scripts/memory-sync.sh` |
| daily-log.sh | Create log | `./scripts/daily-log.sh` |
| backup.sh | Backup | `./scripts/backup.sh` |

## Installation Flow

```
User runs ./setup.sh
    ↓
Creates directory structure
    ↓
Copies templates
    ↓
Initializes git
    ↓
Commits initial state
    ↓
Prompts to customize
    ↓
Ready to use!
```

## Daily Workflow

```
Session Start
    ↓
OpenClaw reads MEMORY.md (auto)
    ↓
Read today's log
    ↓
Read yesterday's log
    ↓
[WORK SESSION]
    ↓
Update MEMORY.md (as needed)
    ↓
Create daily log
    ↓
Sync to git
    ↓
Session End
```
