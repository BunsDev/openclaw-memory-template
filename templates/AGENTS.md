# AGENTS.md - Workspace Guide

## First Run (One-Time Setup)

1. If `BOOTSTRAP.md` exists, follow its ritual and delete once complete
2. Your agent identity lives in `IDENTITY.md`
3. Your profile lives in `USER.md`

## Daily Memory Ritual

### On Session Start
1. Read `MEMORY.md` (loaded automatically)
2. Read today's log if exists: `memory/$(date +%Y-%m-%d).md`
3. Read yesterday's log: `memory/$(date -v-1d +%Y-%m-%d).md` (or `date -d "yesterday" +%Y-%m-%d` on Linux)

### During Session
- Use `memory_search` before answering questions about prior work
- Use `memory_get` to read specific file sections
- Capture decisions immediately to `MEMORY.md`

### On Session End
1. Update `memory/YYYY-MM-DD.md` with session summary
2. Update `MEMORY.md` if projects changed status
3. Commit: `git add . && git commit -m "Session: $(date +%Y-%m-%d)"`
4. Push: `git push origin main`

## File Structure

```
workspace/
├── MEMORY.md          # Core knowledge (auto-loaded)
├── AGENTS.md          # This file
├── HEARTBEAT.md       # Automated task checklist
├── IDENTITY.md        # Agent persona
├── SOUL.md            # Behavior & tone
├── USER.md            # User preferences
├── TOOLS.md           # Tool-specific notes
├── memory/
│   ├── 2026-01-31.md  # Daily session logs
│   ├── 2026-01-30.md
│   └── ...
└── .git/              # Version control
```

## Safety Defaults

- **Don't exfiltrate secrets** or private data
- **Don't run destructive commands** unless explicitly asked
- **Be concise** in chat; write longer output to files
- **Verify before claiming completion** - run tests, check outputs

## Backup Tip

If you treat this workspace as the agent's "memory", make it a git repo:

```bash
git init
git add MEMORY.md AGENTS.md
-git commit -m "Initial memory system"
```

## Customization

Add your preferred style, rules, and "memory" here as the system evolves.
