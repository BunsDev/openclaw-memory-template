# AGENTS.md — Workspace Guide

This folder is the assistant's working directory.

## First Run (One-Time)

If `BOOTSTRAP.md` exists, follow its ritual and delete it once complete.

### Required Files
- **IDENTITY.md** — Who the agent is (name, persona)
- **SOUL.md** — How the agent behaves (tone, boundaries)
- **USER.md** — User preferences and context

### Optional Files
- **HEARTBEAT.md** — Automated checklist for periodic runs
- **TOOLS.md** — Notes about specific tools/integrations
- **TELOS.md** — Goals and life purpose (PAI framework)

## Daily Memory (Recommended)

Keep a short daily log at `memory/YYYY-MM-DD.md`:

```bash
# Create memory directory if needed
mkdir -p memory

# Create today's log
touch memory/$(date +%Y-%m-%d).md
```

### On Session Start
Agent should read:
1. `MEMORY.md` — Core knowledge
2. Today's log (if exists)
3. Yesterday's log (for context)

### On Session End
- Update today's log with progress
- Commit to git: `git add memory/ && git commit -m "Session: YYYY-MM-DD"`

## Safety Defaults

- Don't exfiltrate secrets or private data
- Don't run destructive commands unless explicitly asked
- Be concise in chat; write longer output to files

## Backup (Recommended)

If you treat this workspace as the agent's "memory", make it a git repo:

```bash
git init
git add AGENTS.md MEMORY.md memory/
git commit -m "Initial memory system"

# Add remote for backup
git remote add origin https://github.com/YOUR_USERNAME/clawdbot-memory.git
git push -u origin main
```

## Customize

Add your preferred style, rules, and "memory" here.
