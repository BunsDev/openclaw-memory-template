# MEMORY.md — Example Agent Knowledge Base

## Identity
- **Agent**: Nexus 🤖⚡
- **User**: Alex (they/them)
- **Vibe**: Professional, concise, solution-oriented
- **Philosophy**: Ship fast, learn faster

## System
- **Hardware**: MacBook Pro M3, 36GB RAM
- **OS**: macOS Sonoma 14.2
- **Primary Model**: anthropic/claude-opus-4-5
- **Fallback Models**: zai/glm-4.7, openai/gpt-4o
- **Workspace**: `/Users/alex/clawdbot-workspace`

## Active Projects

### SaaS Dashboard (Priority 1)
- **Location**: `/Users/alex/projects/saas-dashboard`
- **Status**: MVP in development
- **Stack**: Next.js 14, Tailwind, Supabase, Stripe
- **Deadline**: Feb 15, 2026
- **Notes**: Focus on auth flow and billing first

### Blog Migration
- **Location**: `/Users/alex/projects/blog`
- **Status**: Paused
- **Blocker**: Waiting on new domain DNS
- **Next Action**: Resume after SaaS MVP

### Research: AI Agents
- **Location**: `~/clawdbot-workspace/research/agents`
- **Status**: Ongoing learning
- **Key Papers**: ReAct, Reflexion, Voyager
- **Goal**: Build autonomous coding agent

## Key Preferences

### Communication Style
- Prefer bullet points over paragraphs
- Show code examples when explaining concepts
- Ask clarifying questions before coding

### Technical Preferences
- TypeScript > JavaScript
- Server components > Client components
- SQLite for local, Postgres for production
- Prefer native CSS > Tailwind for complex UIs

### Work Patterns
- Morning: Deep work, coding
- Afternoon: Meetings, reviews
- Evening: Learning, experiments

## Important Context

### API Keys (env vars, never commit)
- `OPENAI_API_KEY` — GPT-4, embeddings
- `ANTHROPIC_API_KEY` — Claude
- `STRIPE_SECRET_KEY` — Billing
- `SUPABASE_SERVICE_ROLE` — Database

### Active Subscriptions
- GitHub Pro
- Vercel Pro
- OpenAI API ($50/mo budget)
- Anthropic API ($30/mo budget)

### Key Contacts
- Designer: sarah@example.com
- Backend contractor: mike@example.com (available Tuesdays)

## Recurring Tasks

### Weekly
- [ ] Review analytics dashboard
- [ ] Check API usage vs budget
- [ ] Sync with designer on Friday

### Monthly
- [ ] Rotate API keys
- [ ] Review and clean up old branches
- [ ] Update dependencies

## Quick Reference

### Common Commands
```bash
# Start dev server
cd ~/projects/saas-dashboard && npm run dev

# Database
cd ~/projects/saas-dashboard && npx prisma studio

# Deploy
cd ~/projects/saas-dashboard && vercel --prod
```

### File Paths
- Design files: `~/Dropbox/Designs/`
- Invoices: `~/Documents/Invoices/`
- Scratch: `~/Desktop/scratch/`

## Dated Logs

See `memory/` directory for session-by-session logs:
- `memory/2026-01-31.md` — SaaS auth flow implementation
- `memory/2026-01-30.md` — Database schema design
- `memory/2026-01-29.md` — Project initialization

## Decisions Log

| Date | Decision | Context | Status |
|------|----------|---------|--------|
| 2026-01-30 | Use Supabase Auth | Built-in, row-level security | Active |
| 2026-01-29 | Next.js over Remix | Better Vercel integration | Active |
| 2026-01-28 | Tailwind over CSS | Faster prototyping | Active |

## Resources & Bookmarks

### Documentation
- [Next.js App Router](https://nextjs.org/docs/app)
- [Supabase Auth Helpers](https://supabase.com/docs/guides/auth/auth-helpers/nextjs)
- [Stripe Checkout](https://stripe.com/docs/payments/checkout)

### Inspiration
- [Linear.app](https://linear.app) — UI patterns
- [Vercel Dashboard](https://vercel.com/dashboard) — UX flows

---

**Last Updated**: 2026-01-31 by Nexus 🤖⚡
