# HEARTBEAT.md — Daily Checklist

## Morning Startup ☀️

### Daily Review
- [ ] Read yesterday's memory log
- [ ] Check for any blockers from previous session
- [ ] Review today's priorities from MEMORY.md

### System Check
- [ ] Verify dev servers are running
- [ ] Check error logs from overnight
- [ ] Review any scheduled cron jobs

## Throughout Day 🔄

### Every 4 Hours
- [ ] Commit memory changes to git
- [ ] Push to remote backup

### When Starting New Task
- [ ] Search memory for related prior work
- [ ] Update project status in MEMORY.md

## Evening Wrap-Up 🌙

### Session End
- [ ] Write today's log to `memory/YYYY-MM-DD.md`
- [ ] Update active project statuses
- [ ] Commit and push all changes
- [ ] Note any blockers for tomorrow

### Weekly (Fridays)
- [ ] Review week in memory logs
- [ ] Update decisions log
- [ ] Archive completed projects
- [ ] Plan next week's priorities

## Automation

If using cron for heartbeat, read this file and:
1. Check for uncommitted changes → auto-commit
2. Review yesterday's log → flag blockers
3. Verify git sync status
