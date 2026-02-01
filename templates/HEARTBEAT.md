# HEARTBEAT.md

## Automated Task Checklist

### Daily
- [ ] Check `MEMORY.md` for accuracy
- [ ] Review yesterday's log in `memory/`
- [ ] Commit uncommitted changes: `git add . && git commit -m "$(date +%Y-%m-%d) auto"`
- [ ] Push to remote: `git push origin main`
- [ ] Check for system updates (if applicable)

### Weekly
- [ ] Review all active projects in `MEMORY.md`
- [ ] Update project statuses (active/paused/complete)
- [ ] Clean up old logs (archive if >30 days)
- [ ] Run `memory_sync.sh` full backup
- [ ] Review and optimize `HEARTBEAT.md` itself

### Monthly
- [ ] Full system audit
- [ ] Archive completed projects
- [ ] Review and update `IDENTITY.md`
- [ ] Clean up unused skills/tools from `TOOLS.md`
- [ ] Performance review of memory system

## Project-Specific Checklists

### [Project Name]
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

## Automation

Set up cron for daily heartbeat:

```bash
# Edit crontab
crontab -e

# Add line:
0 2 * * * cd ~/your-workspace && ./scripts/memory-sync.sh --auto
```

## Notes

- Keep this file small and actionable
- Use it for recurring tasks only
- One-off tasks go in `memory/YYYY-MM-DD.md`
