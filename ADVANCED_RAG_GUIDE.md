# OpenClaw Memory Template v3.0 - RAG Edition
## Advanced Memory System with Local Embeddings & Git Notes

**Status:** ⚡ ADVANCED  
**Features:** Git notes + Local embeddings + Multi-database + RAG  
**Backends:** SQLite (default) | PostgreSQL | LanceDB

---

## 🎯 What's New in v3.0

### Core Upgrades
- ✅ **Git-notes storage** - Memories sync with git push/pull
- ✅ **Local embeddings** - Sentence-transformers, no API calls
- ✅ **Semantic search** - Vector similarity via sqlite-vec/LanceDB
- ✅ **Multi-database** - SQLite (local) | Postgres (team) | LanceDB (scale)
- ✅ **RAG pipeline** - Retrieve → Augment → Generate
- ✅ **10 namespaces** - inception, decisions, learnings, patterns, etc.
- ✅ **Secrets filtering** - Auto-redact PII/API keys
- ✅ **Progressive hydration** - Load summaries → full → files

### Architecture
```
┌─────────────────────────────────────────────┐
│  OpenClaw Agent                             │
│  ├── MEMORY.md (static context)             │
│  └── memory_search (dynamic RAG)            │
└──────────────┬──────────────────────────────┘
               │
    ┌──────────┴──────────┐
    │   RAG Pipeline      │
    │  ┌───────────────┐  │
    │  │ 1. Embed Query│  │
    │  └───────┬───────┘  │
    │          ▼          │
    │  ┌───────────────┐  │
    │  │ 2. Vector DB  │  │ ← SQLite-vec / Postgres / LanceDB
    │  │    Search     │  │
    │  └───────┬───────┘  │
    │          ▼          │
    │  ┌───────────────┐  │
    │  │ 3. Retrieve   │  │ ← Top-k memories
    │  │    Memories   │  │
    │  └───────┬───────┘  │
    │          ▼          │
    │  ┌───────────────┐  │
    │  │ 4. Augment    │  │ ← Inject into context
    │  │    Context    │  │
    │  └───────────────┘  │
    └─────────────────────┘
               │
    ┌──────────┴──────────┐
    │   Storage Layer     │
    │  ┌───────────────┐  │
    │  │ Git Notes     │  │ ← refs/notes/memories
    │  │ (Source of    │  │
    │  │  Truth)       │  │
    │  └───────┬───────┘  │
    │          ▼          │
    │  ┌───────────────┐  │
    │  │ Vector Index  │  │ ← sqlite-vec / pgvector
    │  │ (Searchable)  │  │
    │  └───────────────┘  │
    └─────────────────────┘
```

---

## 🚀 Quick Start (Advanced)

### Option 1: SQLite + Git Notes (Default)
```bash
# Setup
git clone https://github.com/arosstale/openclaw-memory-template.git
cd openclaw-memory-template
./setup.sh --advanced ~/my-agent-workspace

# Install dependencies
cd ~/my-agent-workspace
pip install git-notes-memory sentence-transformers sqlite-vec

# Initialize RAG memory
./scripts/init-rag.sh --backend sqlite

# Capture a memory
./scripts/memory-capture.sh \
  --namespace decisions \
  --summary "Chose PostgreSQL for persistence" \
  --content "Evaluated SQLite vs PostgreSQL. PG wins for concurrency and team sync."

# Search memories
./scripts/memory-search.sh "database choice"
```

### Option 2: PostgreSQL (Team Setup)
```bash
# Setup Postgres with pgvector
docker run -d \
  --name agent-memory \
  -e POSTGRES_PASSWORD=secret \
  -p 5432:5432 \
  ankane/pgvector:latest

# Initialize with Postgres
./scripts/init-rag.sh --backend postgres \
  --connection "postgresql://postgres:secret@localhost:5432/memory"
```

### Option 3: LanceDB (High Performance)
```bash
pip install lancedb

./scripts/init-rag.sh --backend lancedb \
  --path ~/.local/share/agent-memory/lancedb
```

---

## 📁 File Structure (v3.0)

```
workspace/
│
├── 🧠 MEMORY.md                    # Static context (auto-loaded)
├── 📖 AGENTS.md                    # Agent guidelines
├── 📋 HEARTBEAT.md                 # Automation checklist
├── 🎭 IDENTITY.md                  # Agent persona
├── 💫 SOUL.md                      # Behavior
├── 👤 USER.md                      # User profile
│
├── 📁 .memory/                     # NEW: RAG system
│   │
│   ├── config.yaml                 # Backend configuration
│   │
│   ├── 📁 embeddings/              # Local embedding cache
│   │   └── models/
│   │       └── all-MiniLM-L6-v2/   # Sentence transformer
│   │
│   ├── 📁 vector_store/            # Vector database
│   │   ├── memory.db               # SQLite + sqlite-vec
│   │   └── index/                  # FAISS/HNSW indexes
│   │
│   ├── 📁 git_notes/               # Git notes sync
│   │   └── refs/notes/memories     # Git notes ref
│   │
│   └── 📁 namespaces/              # 10 memory namespaces
│       ├── inception/              # Project origins
│       ├── elicitation/            # Requirements discovered
│       ├── research/               # Research findings
│       ├── decisions/              # Key decisions
│       ├── progress/               # Milestones
│       ├── blockers/               # Issues encountered
│       ├── reviews/                # Code reviews
│       ├── learnings/              # Lessons learned
│       ├── retrospective/          # Post-project review
│       └── patterns/               # Reusable patterns
│
├── 📁 memory/                      # Daily logs (Markdown)
│   └── 2026-02-01.md
│
└── 📁 scripts/
    │
    ├── setup.sh                    # Base setup
    ├── setup-advanced.sh           # NEW: RAG setup
    │
    ├── memory-sync.sh              # Git sync
    ├── daily-log.sh                # Create daily log
    ├── backup.sh                   # Backup
    │
    ├── init-rag.sh                 # NEW: Initialize RAG
    ├── memory-capture.sh           # NEW: Capture memory
    ├── memory-search.sh            # NEW: Semantic search
    ├── memory-status.sh            # NEW: Index stats
    └── memory-sync-advanced.sh     # NEW: Git notes sync
```

---

## 🔧 Configuration

### config.yaml
```yaml
# ~/.memory/config.yaml

# Storage backend
backend: sqlite  # sqlite | postgres | lancedb

# SQLite configuration
sqlite:
  path: ~/.memory/vector_store/memory.db
  
# PostgreSQL configuration  
postgres:
  host: localhost
  port: 5432
  database: memory
  user: ${POSTGRES_USER}
  password: ${POSTGRES_PASSWORD}
  
# LanceDB configuration
lancedb:
  path: ~/.memory/vector_store/lancedb

# Embeddings
embeddings:
  model: all-MiniLM-L6-v2  # 384 dimensions
  # Alternative: sentence-transformers/all-mpnet-base-v2
  device: cpu  # cpu | cuda
  batch_size: 32

# Git notes
git:
  namespace: refs/notes/memories
  auto_sync: true
  
# Search
search:
  default_k: 5
  min_similarity: 0.5
  max_tokens: 2000
  
# Secrets filtering
secrets:
  enabled: true
  pii: true
  credentials: true
  entropy: false
```

---

## 📝 Usage Examples

### Capture a Memory
```bash
# Basic capture
./scripts/memory-capture.sh \
  --namespace decisions \
  --summary "Chose FastAPI over Flask" \
  --content "FastAPI provides async support and automatic OpenAPI docs. Better for our use case."

# With tags
./scripts/memory-capture.sh \
  --namespace learnings \
  --summary "pytest fixtures can be module-scoped" \
  --content "Use @pytest.fixture(scope='module') for expensive setup like database connections." \
  --tags pytest,testing,database

# With file attachment
./scripts/memory-capture.sh \
  --namespace patterns \
  --summary "Ralph loop implementation" \
  --content "Iterative agent pattern for code generation" \
  --file docs/RALPH_LOOP.md
```

### Semantic Search
```bash
# Basic search
./scripts/memory-search.sh "database configuration"

# With filters
./scripts/memory-search.sh "pytest fixtures" \
  --namespace learnings \
  --k 10 \
  --min-similarity 0.7

# Search specific namespace
./scripts/memory-search.sh "API design" \
  --namespace decisions
```

### Advanced Queries
```bash
# Multi-namespace search
./scripts/memory-search.sh "error handling" \
  --namespaces learnings,blockers,patterns

# Date range
./scripts/memory-search.sh "trading strategy" \
  --since 2026-01-01 \
  --until 2026-01-31

# Tag filter
./scripts/memory-search.sh "async" \
  --tags python,fastapi
```

### Git Notes Sync
```bash
# Sync to git notes
./scripts/memory-sync-advanced.sh push

# Pull from remote
./scripts/memory-sync-advanced.sh pull

# Full reindex
./scripts/memory-sync-advanced.sh reindex

# Verify consistency
./scripts/memory-sync-advanced.sh verify
```

---

## 🐍 Python API

```python
from memory_rag import MemorySystem

# Initialize
memory = MemorySystem(backend="sqlite")

# Capture
memory.capture(
    namespace="decisions",
    summary="Chose PostgreSQL",
    content="PostgreSQL wins for concurrency",
    tags=["database", "architecture"]
)

# Search
results = memory.search(
    query="database choice",
    namespace="decisions",
    k=5,
    min_similarity=0.6
)

for result in results:
    print(f"{result.similarity:.2f}: {result.summary}")
    print(f"  {result.content[:100]}...")

# Get by ID
mem = memory.get("mem_abc123")

# Update
memory.update("mem_abc123", content="Updated content")

# Delete
memory.delete("mem_abc123")

# Namespace operations
all_decisions = memory.list_namespace("decisions")
stats = memory.stats()
```

---

## 🔗 Integration with OpenClaw

### In MEMORY.md
```markdown
## Memory System
- **Type:** RAG with local embeddings
- **Backend:** SQLite + sqlite-vec
- **Model:** all-MiniLM-L6-v2 (384d)
- **Location:** ~/.memory/

## Usage
```bash
# Search memories
memory_search "database decision"

# Capture decision
./scripts/memory-capture.sh --namespace decisions ...
```
```

### Automatic Hooks
The system integrates with OpenClaw hooks:

```yaml
# .claw/hooks.yaml
hooks:
  session_start:
    - inject_relevant_memories: true
    - max_memories: 5
    
  post_tool_use:
    - capture_file_context: true
    - auto_capture_threshold: 0.85
    
  pre_compact:
    - capture_high_confidence: true
    
  stop:
    - sync_index: true
    - prompt_uncaptured: true
```

---

## 📊 Performance

| Backend | Storage | Search | Best For |
|---------|---------|--------|----------|
| **SQLite** | 10MB-1GB | ~50ms | Single agent, local |
| **PostgreSQL** | Unlimited | ~20ms | Team, multi-agent |
| **LanceDB** | 10MB-100GB | ~10ms | Scale, high throughput |

### Embedding Models
| Model | Dimensions | Speed | Quality |
|-------|------------|-------|---------|
| all-MiniLM-L6-v2 | 384 | Fast | Good |
| all-mpnet-base-v2 | 768 | Medium | Better |
| all-MiniLM-L12-v2 | 384 | Medium | Best |

---

## 🔐 Security

### Secrets Filtering
Automatically redacts:
- PII: SSN, credit cards, phone numbers
- Credentials: API keys, tokens, passwords
- Cloud: AWS, GCP, Azure credentials
- Entropy: High-entropy strings

```bash
# Test filtering
./scripts/memory-test-secret.sh "API key: sk-abc123"

# Scan existing memories
./scripts/memory-scan-secrets.sh

# Audit log
cat ~/.memory/audit/secrets.log
```

### Never Store
- Private keys
- Passwords
- API keys (use .env)
- Personal data

### Safe to Store
- Architecture decisions
- Lessons learned
- Code patterns
- Project context

---

## 🚀 Deployment Options

### Local (Default)
```bash
./setup.sh --advanced ~/agent-workspace
```

### Cloudflare (Edge)
```bash
# Use cloudflare-saas-stack
git clone https://github.com/supermemoryai/cloudflare-saas-stack
cd cloudflare-saas-stack

# Deploy D1 database
wrangler d1 create agent-memory

# Deploy worker
wrangler deploy
```

### Self-Hosted
```bash
# Docker Compose
docker-compose up -d

# Includes:
# - PostgreSQL with pgvector
# - Redis for caching
# - Memory API server
```

---

## 📚 Resources

- [git-notes-memory](https://github.com/zircote/git-notes-memory) - Git-native semantic memory
- [sqlite-vec](https://github.com/asg017/sqlite-vec) - Vector search for SQLite
- [LanceDB](https://lancedb.github.io/lancedb/) - Serverless vector DB
- [sentence-transformers](https://www.sbert.net/) - Embeddings
- [Unsloth Embeddings](https://unsloth.ai/docs/new/embedding-finetuning) - Fine-tuning

---

**v3.0 RAG Edition - Production-ready memory with local embeddings.** 🐺📿
