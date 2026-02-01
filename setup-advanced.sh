#!/bin/bash
#
# Setup Advanced RAG Memory System
# Configures git-notes + local embeddings + vector database
#

set -e

WORKSPACE_DIR="${1:-$(pwd)}"
BACKEND="${2:-sqlite}"

echo "🚀 OpenClaw Memory System - Advanced RAG Setup"
echo "==============================================="
echo ""
echo "Workspace: $WORKSPACE_DIR"
echo "Backend: $BACKEND"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${BLUE}[STEP]${NC} $1"; }

# Check dependencies
log_step "Checking dependencies..."

if ! command -v python3 &> /dev/null; then
    log_error "Python 3 not found. Please install Python 3.11+"
    exit 1
fi

if ! command -v git &> /dev/null; then
    log_error "Git not found. Please install Git 2.25+"
    exit 1
fi

log_info "Dependencies OK"

# Create directory structure
log_step "Creating directory structure..."

mkdir -p "$WORKSPACE_DIR/.memory"/{embeddings,vector_store,git_notebook,namespaces,audit}
mkdir -p "$WORKSPACE_DIR/.memory/namespaces"/{inception,elicitation,research,decisions,progress,blockers,reviews,learnings,retrospective,patterns}

log_info "Directories created"

# Create config
log_step "Creating configuration..."

cat > "$WORKSPACE_DIR/.memory/config.yaml" << EOF
# OpenClaw Memory System - Configuration
# Generated: $(date -Iseconds)

# Storage backend: sqlite | postgres | lancedb
backend: $BACKEND

# SQLite configuration (default)
sqlite:
  path: $WORKSPACE_DIR/.memory/vector_store/memory.db

# PostgreSQL configuration (optional)
postgres:
  host: \${POSTGRES_HOST:-localhost}
  port: \${POSTGRES_PORT:-5432}
  database: \${POSTGRES_DB:-memory}
  user: \${POSTGRES_USER:-memory}
  password: \${POSTGRES_PASSWORD}

# LanceDB configuration (optional)
lancedb:
  path: $WORKSPACE_DIR/.memory/vector_store/lancedb

# Embeddings configuration
embeddings:
  model: all-MiniLM-L6-v2
  dimensions: 384
  device: cpu
  batch_size: 32
  cache_dir: $WORKSPACE_DIR/.memory/embeddings

# Git notes configuration
git:
  namespace: refs/notes/memories
  auto_sync: true
  sync_on_capture: true

# Search configuration
search:
  default_k: 5
  min_similarity: 0.5
  max_tokens: 2000
  include_distances: true

# Secrets filtering
secrets:
  enabled: true
  pii: true
  credentials: true
  entropy: false
  audit_log: $WORKSPACE_DIR/.memory/audit/secrets.log

# Namespaces (10 memory types)
namespaces:
  - inception      # Project origins
  - elicitation    # Requirements discovered
  - research       # Research findings
  - decisions      # Key decisions
  - progress       # Milestones achieved
  - blockers       # Issues encountered
  - reviews        # Code reviews
  - learnings      # Lessons learned
  - retrospective  # Post-project analysis
  - patterns       # Reusable patterns

# Logging
logging:
  level: INFO
  file: $WORKSPACE_DIR/.memory/memory.log
  format: "%(asctime)s | %(levelname)s | %(message)s"
EOF

log_info "Config created at $WORKSPACE_DIR/.memory/config.yaml"

# Setup git notes
log_step "Setting up git notes..."

cd "$WORKSPACE_DIR"

if [ ! -d ".git" ]; then
    git init
    log_info "Git repository initialized"
fi

# Create git notes ref
git notes --ref=memories list > /dev/null 2>&1 || true

log_info "Git notes configured (refs/notes/memories)"

# Create Python environment
log_step "Setting up Python environment..."

python3 -m venv "$WORKSPACE_DIR/.memory/venv" 2>/dev/null || true
source "$WORKSPACE_DIR/.memory/venv/bin/activate"

pip install --quiet --upgrade pip

# Install base packages
pip install --quiet \
    pyyaml \
    numpy \
    sentence-transformers \
    sqlite-vec \
    gitpython \
    python-dotenv

# Install optional backends
if [ "$BACKEND" = "postgres" ]; then
    pip install --quiet psycopg2-binary pgvector
    log_info "PostgreSQL support installed"
elif [ "$BACKEND" = "lancedb" ]; then
    pip install --quiet lancedb
    log_info "LanceDB support installed"
fi

log_info "Python packages installed"

# Create initialization script
log_step "Creating initialization script..."

cat > "$WORKSPACE_DIR/.memory/init_db.py" << 'PYTHON_EOF'
#!/usr/bin/env python3
"""Initialize memory database"""

import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

import yaml
import sqlite3
import sqlite_vec
from sentence_transformers import SentenceTransformer

def init_sqlite(config):
    """Initialize SQLite database with sqlite-vec"""
    db_path = config['sqlite']['path']
    os.makedirs(os.path.dirname(db_path), exist_ok=True)
    
    conn = sqlite3.connect(db_path)
    conn.enable_load_extension(True)
    sqlite_vec.load(conn)
    conn.enable_load_extension(False)
    
    # Create memories table
    conn.execute("""
        CREATE TABLE IF NOT EXISTS memories (
            id TEXT PRIMARY KEY,
            namespace TEXT NOT NULL,
            summary TEXT NOT NULL,
            content TEXT,
            tags TEXT,
            file_path TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    
    # Create virtual table for vector search
    dimensions = config['embeddings']['dimensions']
    conn.execute(f"""
        CREATE VIRTUAL TABLE IF NOT EXISTS memory_vectors USING vec0(
            memory_id TEXT PRIMARY KEY,
            embedding FLOAT[{dimensions}] distance_metric=cosine
        )
    """)
    
    # Create indexes
    conn.execute("CREATE INDEX IF NOT EXISTS idx_namespace ON memories(namespace)")
    conn.execute("CREATE INDEX IF NOT EXISTS idx_created ON memories(created_at)")
    
    conn.commit()
    conn.close()
    
    print(f"✅ SQLite database initialized: {db_path}")

def download_model(config):
    """Download embedding model"""
    model_name = config['embeddings']['model']
    cache_dir = config['embeddings']['cache_dir']
    
    print(f"📥 Downloading embedding model: {model_name}")
    
    model = SentenceTransformer(
        model_name,
        cache_folder=cache_dir
    )
    
    print(f"✅ Model downloaded to {cache_dir}")
    print(f"   Dimensions: {model.get_sentence_embedding_dimension()}")

def main():
    config_path = os.path.join(os.path.dirname(__file__), 'config.yaml')
    
    with open(config_path) as f:
        config = yaml.safe_load(f)
    
    backend = config['backend']
    
    if backend == 'sqlite':
        init_sqlite(config)
    elif backend == 'postgres':
        print("⚠️  PostgreSQL: Please run migrations manually")
        print("   See docs/postgres-setup.md")
    elif backend == 'lancedb':
        os.makedirs(config['lancedb']['path'], exist_ok=True)
        print(f"✅ LanceDB directory created: {config['lancedb']['path']}")
    
    download_model(config)
    
    print("\n🎉 Memory system initialized!")

if __name__ == "__main__":
    main()
PYTHON_EOF

chmod +x "$WORKSPACE_DIR/.memory/init_db.py"

# Run initialization
log_step "Initializing database..."

source "$WORKSPACE_DIR/.memory/venv/bin/activate"
python3 "$WORKSPACE_DIR/.memory/init_db.py"

# Create capture script
cat > "$WORKSPACE_DIR/scripts/memory-capture.sh" << 'BASH_EOF'
#!/bin/bash
# Capture a memory to the RAG system

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
source "$WORKSPACE/.memory/venv/bin/activate"

python3 << PYTHON
import sys
sys.path.insert(0, "$WORKSPACE/.memory")

from memory_rag import MemorySystem
import argparse
import datetime

parser = argparse.ArgumentParser()
parser.add_argument('--namespace', '-n', required=True)
parser.add_argument('--summary', '-s', required=True)
parser.add_argument('--content', '-c', default='')
parser.add_argument('--tags', '-t', default='')
parser.add_argument('--file', '-f', default='')
args = parser.parse_args()

memory = MemorySystem()

memory_id = memory.capture(
    namespace=args.namespace,
    summary=args.summary,
    content=args.content,
    tags=args.tags.split(',') if args.tags else [],
    file_path=args.file
)

print(f"✅ Memory captured: {memory_id}")
PYTHON
BASH_EOF

chmod +x "$WORKSPACE_DIR/scripts/memory-capture.sh"

# Create search script
cat > "$WORKSPACE_DIR/scripts/memory-search.sh" << 'BASH_EOF'
#!/bin/bash
# Search memories using semantic search

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
source "$WORKSPACE/.memory/venv/bin/activate"

python3 << PYTHON
import sys
sys.path.insert(0, "$WORKSPACE/.memory")

from memory_rag import MemorySystem
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('query', help='Search query')
parser.add_argument('--namespace', '-n', default=None)
parser.add_argument('--k', '-k', type=int, default=5)
parser.add_argument('--min-similarity', '-m', type=float, default=0.5)
args = parser.parse_args()

memory = MemorySystem()

results = memory.search(
    query=args.query,
    namespace=args.namespace,
    k=args.k,
    min_similarity=args.min_similarity
)

print(f"\n🔍 Search: '{args.query}'")
print(f"   Found: {len(results)} results\n")

for i, result in enumerate(results, 1):
    sim_pct = result.similarity * 100
    print(f"{i}. [{result.namespace}] {result.summary}")
    print(f"   Similarity: {sim_pct:.1f}%")
    if result.content:
        preview = result.content[:150] + "..." if len(result.content) > 150 else result.content
        print(f"   {preview}")
    print()
PYTHON
BASH_EOF

chmod +x "$WORKSPACE_DIR/scripts/memory-search.sh"

# Summary
echo ""
echo "==============================================="
echo "✅ ADVANCED RAG MEMORY SYSTEM READY"
echo "==============================================="
echo ""
echo "Configuration: $WORKSPACE_DIR/.memory/config.yaml"
echo "Database: $WORKSPACE_DIR/.memory/vector_store/"
echo "Embeddings: $WORKSPACE_DIR/.memory/embeddings/"
echo ""
echo "Usage:"
echo "  ./scripts/memory-capture.sh --namespace decisions --summary \"Your summary\" --content \"Your content\""
echo "  ./scripts/memory-search.sh \"your query\""
echo ""
echo "Or use Python API:"
echo "  from memory_rag import MemorySystem"
echo "  memory = MemorySystem()"
echo "  memory.capture(...)"
echo "  memory.search(...)"
echo ""
