# MEMORY.md — Pi-Agent Knowledge Base

> **⚠️ CRITICAL:** This file is read automatically at session start.
> Keep it concise, factual, and up-to-date.

---

## Identity
- **Agent**: Pi-Agent 🐺📿
- **User**: Artale
- **Vibe**: Super villain expert professional/artist/mc
- **Philosophy**: Simons + Machiavelli + Samurai = Skillful Action

---

## System
- **Hardware**: AMD Ryzen 9 7950X3D (16c/32t), 124GB RAM, 1.8TB disk
- **OS**: Ubuntu 22.04 LTS
- **Primary Model**: kimi-code/kimi-for-coding
- **Fallback Models**: anthropic/claude-opus-4-5, zai/glm-4.7, zai/glm-4.5-air

---

## Active Projects

### HL Trading Agent V2
- **Location**: `/home/majinbu/pi-mono-workspace/hl-trading-agent`
- **Status**: 🟢 Active (paper trading)
- **Started**: 2026-01-24
- **Key Details**: 
  - 5 strategies: DivergenceVolatilityEnhanced, SelectiveMomentumSwing, TrendCapturePro, SupertrendNovaCloud, VolatilityBreakoutSystem
  - Consensus: 2/5 agreement, 65% confidence threshold
  - Tracker: SQLite @ `paper_trades.db`
  - Stop-loss: 8%, Take-profit: 16%
  - Max risk: 2% per trade, 3 trades/day, -3% daily halt
- **Next Milestone**: Reach 55%+ win rate on 50+ paper trades before live deploy

### Research Engine
- **Location**: `/home/majinbu/pi-mono-workspace/research-engine`
- **Status**: 🟢 Active (24/7/365)
- **Started**: 2026-01-20
- **Key Details**:
  - Domains: quant, ML, crypto, biomimicry, robotics, architecture, arts, physics
  - Papers: 78 in database
  - Authors: 201 tracked
  - Cron: Every 6 hours (`0 */6 * * *`)
- **Next Milestone**: Expand to 100 papers, add cross-domain synthesis

### Alpha Orchestrator
- **Location**: `/home/majinbu/pi-mono-workspace/alpha-orchestrator`
- **Status**: 🟢 Active (just deployed)
- **Started**: 2026-01-31
- **Key Details**:
  - Multi-venue: Hyperliquid + Polymarket + Kalshi
  - Self-improving code loops
  - Dashboard: http://localhost:8080
- **Next Milestone**: First arbitrage opportunity detection

---

## Key Preferences

### Communication
- Prefer "Artale" as address
- Concise replies in chat, detailed in files
- Ask before destructive operations
- Never send streaming replies to Discord

### Work Style
- Aggressive skill creation encouraged
- Verify before claiming completion
- Run tests after code changes
- Document decisions in MEMORY.md

### Technical
- Python 3.11+ for new code
- Async/await for I/O operations
- SQLite for local data
- Git commit after significant changes

---

## Important Context

### User Goals
- **Primary**: Profitable trading to support family
- **Secondary**: Build autonomous alpha systems
- **Tertiary**: Contribute to AI agent community

### Constraints
- **Financial**: Stressed about bills, careful with live trading
- **Time**: Needs results, not perfection
- **Risk**: Conservative position sizing (2% max)

### External Factors
- **Trading**: No live until 60%+ win rate on paper
- **Monitoring**: 24/7 thermal monitoring (PID: 1380056)
- **Backup**: Git sync to GitHub every 6 hours

---

## Knowledge Base

### Domain Expertise
- **Quantitative trading**: Technical analysis, risk management
- **Machine learning**: Strategy optimization, pattern recognition
- **Systems design**: Async architecture, monitoring, automation
- **AI agents**: Self-improvement, multi-agent systems

### Common Patterns
```bash
# Check trading status
python3 v61_system_test.py

# Sync memory
cd ~/pi-mono-workspace && ./scripts/memory-sync.sh --auto

# Start alpha orchestrator
cd alpha-orchestrator && ./start.sh

# Check thermal
python3 monitoring/prometheus/cpu_thermal_monitor.py
```

### Gotchas
- MoonDev strategies have hardcoded paths - use adapter rewrite
- Thermal daemon sometimes stops - auto-restart via cron
- Paper trading needs 50+ trades for statistical validity

---

## Quick Reference

### Critical Paths
```bash
# Trading system
cd ~/pi-mono-workspace/hl-trading-agent
python3 launch_paper_trading_v6.py

# Research engine
cd ~/pi-mono-workspace/research-engine
python3 collector.py

# Alpha orchestrator
cd ~/pi-mono-workspace/alpha-orchestrator
./start.sh
```

### Important Files
- `~/pi-mono-workspace/hl-trading-agent/v61_system_test.py`
- `~/pi-mono-workspace/alpha-orchestrator/orchestrator.py`
- `~/pi-mono-workspace/HEARTBEAT.md`

### External Resources
- [OpenClaw Docs](https://docs.openclaw.ai)
- [Hyperliquid API](https://hyperliquid.xyz)
- [Polymarket CLOB](https://docs.polymarket.com)

---

## Dated Logs
- See `memory/2026-01-31.md` — Alpha orchestrator deployment
- See `memory/2026-01-29.md` — Trading system overhaul
- See `memory/2026-01-25.md` — Major build session (trading + research)

---

## Indie AI Scene (Key Builders)
Indy Dev Dan, Simon Willison, Daniel Miessler, Mario+Peter (pi-mono/Clawdbot), Geoffrey Huntley (Ralph), Moon Dev, Ryan Carson, Quinn Michaels, Kelsey Hightower

---

## Subscriptions
- Anthropic Max plan
- Copilot Pro
- GLM $6 plan

---

*Last Updated: 2026-02-01 by Pi-Agent 🐺📿*
