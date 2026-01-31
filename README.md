# OpenClaw Memory System — Template & Guide

A production-ready memory system for OpenClaw/Clawdbot agents. This template provides persistent knowledge management across sessions.

---

## Quick Start

### 1. Initialize Your Workspace

```bash
cd ~/your-clawdbot-workspace

# Create memory directory
mkdir -p memory

# Initialize git (if not already)
git init
git add .
git commit -m "Initial memory system setup"
```

### 2. Copy Template Files

Copy these files into your workspace:
- `MEMORY.md` — Main knowledge base
- `memory/YYYY-MM-DD.md` — Daily session logs
- `AGENTS.md` — Agent configuration guide
- `HEARTBEAT.md` — Automated checklists

### 3. Configure Git Sync (Recommended)

```bash
# Create private GitHub repo for backup
git remote add origin https://github.com/YOUR_USERNAME/clawdbot-memory.git

# Push initial commit
git push -u origin main
```

---

## File Structure

```
workspace/
├── MEMORY.md              # Core knowledge base (read at session start)
├── AGENTS.md              # Agent setup instructions
├── HEARTBEAT.md           # Periodic task checklist
├── IDENTITY.md            # Agent persona
├── SOUL.md                # Behavior & tone guidelines
├── USER.md                # User preferences
├── TOOLS.md               # Tool-specific notes
├── memory/
│   ├── 2026-01-31.md     # Daily session log
│   ├── 2026-01-30.md     # Previous day
│   └── ...
└── .git/                 # Version control
```

---

## MEMORY.md Format

```markdown
# MEMORY.md — [Agent Name] Knowledge Base

## Identity
- **Agent**: [Name] [Emoji]
- **User**: [Your name]
- **Vibe**: [Personality description]

## System
- **Hardware**: [Your specs]
- **OS**: [Operating system]
- **Primary Model**: [Default LLM]

## Active Projects

### [Project Name]
- **Location**: `/path/to/project`
- **Status**: [Active/Paused/Complete]
- **Key Details**: [Important context]

## Key Preferences
- [Preference 1]
- [Preference 2]

## Important Context
- [Critical information to remember]

## Dated Logs
- See `memory/YYYY-MM-DD.md` for session history
```

---

## Daily Logs Format

Create `memory/YYYY-MM-DD.md` for each session:

```markdown
# 2026-01-31 — [Session Theme]

## Summary
[What happened today]

## Completed
- [x] Task 1
- [x] Task 2

## In Progress
- [ ] Task 3 (blocked on X)

## Decisions Made
- [Decision and rationale]

## Blockers/Issues
- [What's preventing progress]

## Next Steps
- [ ] Priority task for next session

## References
- [Links, files, resources]
```

---

## How It Works

### Session Start
1. OpenClaw reads `MEMORY.md` automatically
2. Reads `AGENTS.md` for workspace rules
3. Optionally reads today's + yesterday's logs

### During Session
- Use `memory_search` to recall prior work
- Use `memory_get` to read specific snippets
- Agent automatically captures decisions to MEMORY.md

### Session End
- Create/update dated log in `memory/`
- Commit changes: `git add . && git commit -m "Session log: 2026-01-31"`
- Push to remote for backup

---

## Best Practices

### 1. Keep MEMORY.md High-Level
- Store durable facts (preferences, active projects)
- Link to detailed logs in `memory/`
- Update when projects change status

### 2. Daily Logs Are Detailed
- Capture what you did
- Note blockers and decisions
- Include file paths and commands used

### 3. Use Git
```bash
# Daily commit ritual
git add memory/ MEMORY.md
git commit -m "$(date +%Y-%m-%d) session log"
git push
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

## Example MEMORY.md

See `examples/MEMORY.example.md` for a full working example.

---

## Automation Tips

### Cron for Daily Backup
```bash
# Add to crontab
0 2 * * * cd ~/clawdbot-workspace && git add . && git commit -m "Auto-backup $(date +\%Y-\%m-\%d)" && git push
```

### Heartbeat Integration
Add to `HEARTBEAT.md`:
```markdown
## Daily
- [ ] Check for uncommitted memory changes
- [ ] Review yesterday's log
- [ ] Update project statuses if changed
```

---

## Advanced: Multi-Agent Sync

For multiple Clawdbot instances:

```bash
# Primary instance (VPS)
git remote add github https://github.com/user/clawdbot-memory.git

# Secondary instance (local)
git clone https://github.com/user/clawdbot-memory.git ~/clawdbot-memory
# Symlink or copy to workspace
```

---

## Troubleshooting

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

---

## Resources

- [OpenClaw Docs](https://docs.openclaw.ai)
- [Daniel Miessler's PAI Framework](https://github.com/danielmiessler/Personal_AI_Infrastructure)
- [Git Notes Memory Skill](https://clawdhub.com)

---

## License

MIT — Use, modify, share freely. Attribution appreciated.

---

**Created by**: [Your Name]  
**Last Updated**: 2026-01-31  
**Version**: 1.0.0
