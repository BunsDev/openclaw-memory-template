#!/usr/bin/env python3
"""
memory_rag.py - Core RAG memory system for OpenClaw
Git notes + Local embeddings + Vector database
"""

import os
import sys
import yaml
import json
import uuid
import sqlite3
import subprocess
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Optional, Tuple
from dataclasses import dataclass, asdict

import numpy as np
from sentence_transformers import SentenceTransformer

# Try to import optional backends
try:
    import sqlite_vec
    SQLITE_VEC_AVAILABLE = True
except ImportError:
    SQLITE_VEC_AVAILABLE = False

try:
    import lancedb
    LANCEDB_AVAILABLE = True
except ImportError:
    LANCEDB_AVAILABLE = False


@dataclass
class Memory:
    """Memory entity"""
    id: str
    namespace: str
    summary: str
    content: str
    tags: List[str]
    file_path: Optional[str]
    created_at: str
    updated_at: str
    git_note_ref: Optional[str] = None


@dataclass
class MemoryResult:
    """Memory with similarity score"""
    memory: Memory
    similarity: float


class SecretsFilter:
    """Filter secrets from memory content"""
    
    PATTERNS = {
        'api_key': r'(?:api[_-]?key|apikey)\s*[:=]\s*["\']?[a-zA-Z0-9_-]{16,}["\']?',
        'password': r'(?:password|passwd|pwd)\s*[:=]\s*["\']?[^"\'\s]+["\']?',
        'token': r'(?:token|secret)\s*[:=]\s*["\']?[a-zA-Z0-9_-]{16,}["\']?',
        'aws_key': r'AKIA[0-9A-Z]{16}',
        'github_token': r'gh[pousr]_[A-Za-z0-9_]{36}',
        'private_key': r'-----BEGIN (?:RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----',
    }
    
    def __init__(self, enabled: bool = True):
        self.enabled = enabled
        self.import re
    
    def filter(self, content: str) -> str:
        """Filter secrets from content"""
        if not self.enabled:
            return content
        
        filtered = content
        for name, pattern in self.PATTERNS.items():
            filtered = re.sub(pattern, f'[REDACTED:{name}]', filtered, flags=re.IGNORECASE)
        
        return filtered


class EmbeddingModel:
    """Local embedding model"""
    
    def __init__(self, model_name: str = "all-MiniLM-L6-v2", cache_dir: Optional[str] = None, device: str = "cpu"):
        self.model_name = model_name
        self.cache_dir = cache_dir
        self.device = device
        self._model = None
    
    @property
    def model(self):
        """Lazy load model"""
        if self._model is None:
            self._model = SentenceTransformer(
                self.model_name,
                cache_folder=self.cache_dir,
                device=self.device
            )
        return self._model
    
    def encode(self, texts: List[str]) -> np.ndarray:
        """Encode texts to embeddings"""
        return self.model.encode(texts, show_progress_bar=False)
    
    @property
    def dimension(self) -> int:
        """Get embedding dimension"""
        return self.model.get_sentence_embedding_dimension()


class GitNotesStorage:
    """Storage backend using git notes"""
    
    def __init__(self, repo_path: str, namespace: str = "refs/notes/memories"):
        self.repo_path = repo_path
        self.namespace = namespace
    
    def save(self, memory_id: str, data: Dict) -> bool:
        """Save memory to git notes"""
        try:
            content = json.dumps(data, indent=2)
            # Write to git notes
            cmd = [
                'git', 'notes', f'--ref={self.namespace}',
                'add', '-f', '-m', content,
                'HEAD'
            ]
            subprocess.run(cmd, cwd=self.repo_path, check=True, capture_output=True)
            return True
        except subprocess.CalledProcessError as e:
            print(f"Warning: Failed to save git note: {e}")
            return False
    
    def load_all(self) -> List[Dict]:
        """Load all memories from git notes"""
        try:
            cmd = ['git', 'notes', f'--ref={self.namespace}', 'list']
            result = subprocess.run(cmd, cwd=self.repo_path, capture_output=True, text=True)
            
            memories = []
            for line in result.stdout.strip().split('\n'):
                if not line:
                    continue
                parts = line.split()
                if len(parts) >= 2:
                    note_ref = parts[0]
                    # Get note content
                    show_cmd = ['git', 'notes', f'--ref={self.namespace}', 'show', note_ref]
                    show_result = subprocess.run(show_cmd, cwd=self.repo_path, capture_output=True, text=True)
                    try:
                        data = json.loads(show_result.stdout)
                        memories.append(data)
                    except json.JSONDecodeError:
                        pass
            
            return memories
        except subprocess.CalledProcessError:
            return []


class SQLiteBackend:
    """SQLite + sqlite-vec backend"""
    
    def __init__(self, db_path: str, embedding_model: EmbeddingModel):
        self.db_path = db_path
        self.embedding_model = embedding_model
        self._init_db()
    
    def _init_db(self):
        """Initialize database"""
        conn = sqlite3.connect(self.db_path)
        
        if SQLITE_VEC_AVAILABLE:
            conn.enable_load_extension(True)
            sqlite_vec.load(conn)
            conn.enable_load_extension(False)
        
        # Create tables
        conn.execute("""
            CREATE TABLE IF NOT EXISTS memories (
                id TEXT PRIMARY KEY,
                namespace TEXT NOT NULL,
                summary TEXT NOT NULL,
                content TEXT,
                tags TEXT,
                file_path TEXT,
                created_at TEXT,
                updated_at TEXT
            )
        """)
        
        if SQLITE_VEC_AVAILABLE:
            dimensions = self.embedding_model.dimension
            conn.execute(f"""
                CREATE VIRTUAL TABLE IF NOT EXISTS memory_vectors USING vec0(
                    memory_id TEXT PRIMARY KEY,
                    embedding FLOAT[{dimensions}] distance_metric=cosine
                )
            """)
        
        conn.execute("CREATE INDEX IF NOT EXISTS idx_namespace ON memories(namespace)")
        conn.execute("CREATE INDEX IF NOT EXISTS idx_created ON memories(created_at)")
        
        conn.commit()
        conn.close()
    
    def insert(self, memory: Memory, embedding: np.ndarray):
        """Insert memory and embedding"""
        conn = sqlite3.connect(self.db_path)
        
        try:
            # Insert memory
            conn.execute("""
                INSERT INTO memories (id, namespace, summary, content, tags, file_path, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                memory.id, memory.namespace, memory.summary, memory.content,
                json.dumps(memory.tags), memory.file_path, memory.created_at, memory.updated_at
            ))
            
            # Insert embedding
            if SQLITE_VEC_AVAILABLE:
                embedding_bytes = np.array(embedding).astype(np.float32).tobytes()
                conn.execute("""
                    INSERT INTO memory_vectors (memory_id, embedding)
                    VALUES (?, ?)
                """, (memory.id, embedding_bytes))
            
            conn.commit()
        finally:
            conn.close()
    
    def search(self, query_embedding: np.ndarray, namespace: Optional[str] = None, 
               k: int = 5, min_similarity: float = 0.5) -> List[Tuple[str, float]]:
        """Search for similar memories"""
        if not SQLITE_VEC_AVAILABLE:
            return []
        
        conn = sqlite3.connect(self.db_path)
        conn.enable_load_extension(True)
        sqlite_vec.load(conn)
        conn.enable_load_extension(False)
        
        try:
            query_bytes = np.array(query_embedding).astype(np.float32).tobytes()
            
            if namespace:
                # Search with namespace filter
                results = conn.execute("""
                    SELECT v.memory_id, v.distance
                    FROM memory_vectors v
                    JOIN memories m ON v.memory_id = m.id
                    WHERE m.namespace = ?
                    AND v.embedding MATCH ?
                    ORDER BY v.distance
                    LIMIT ?
                """, (namespace, query_bytes, k)).fetchall()
            else:
                # Search all
                results = conn.execute("""
                    SELECT memory_id, distance
                    FROM memory_vectors
                    WHERE embedding MATCH ?
                    ORDER BY distance
                    LIMIT ?
                """, (query_bytes, k)).fetchall()
            
            # Convert distance to similarity (cosine distance -> similarity)
            return [(row[0], 1.0 - row[1]) for row in results if (1.0 - row[1]) >= min_similarity]
        finally:
            conn.close()
    
    def get(self, memory_id: str) -> Optional[Memory]:
        """Get memory by ID"""
        conn = sqlite3.connect(self.db_path)
        
        try:
            row = conn.execute(
                "SELECT * FROM memories WHERE id = ?",
                (memory_id,)
            ).fetchone()
            
            if row:
                return Memory(
                    id=row[0],
                    namespace=row[1],
                    summary=row[2],
                    content=row[3],
                    tags=json.loads(row[4]) if row[4] else [],
                    file_path=row[5],
                    created_at=row[6],
                    updated_at=row[7]
                )
            return None
        finally:
            conn.close()


class MemorySystem:
    """Main memory system interface"""
    
    def __init__(self, config_path: Optional[str] = None):
        # Find config
        if config_path is None:
            # Look for .memory/config.yaml in current or parent directories
            current = Path.cwd()
            for path in [current] + list(current.parents):
                config_file = path / ".memory" / "config.yaml"
                if config_file.exists():
                    config_path = str(config_file)
                    self.workspace_path = str(path)
                    break
        
        if config_path is None:
            raise RuntimeError("Could not find .memory/config.yaml")
        
        # Load config
        with open(config_path) as f:
            self.config = yaml.safe_load(f)
        
        # Initialize components
        self.embedding_model = EmbeddingModel(
            model_name=self.config['embeddings']['model'],
            cache_dir=self.config['embeddings']['cache_dir'],
            device=self.config['embeddings']['device']
        )
        
        self.secrets_filter = SecretsFilter(enabled=self.config['secrets']['enabled'])
        
        # Initialize backend
        backend = self.config['backend']
        if backend == 'sqlite':
            self.backend = SQLiteBackend(
                self.config['sqlite']['path'],
                self.embedding_model
            )
        else:
            raise NotImplementedError(f"Backend '{backend}' not yet implemented")
        
        # Initialize git notes
        self.git_storage = GitNotesStorage(
            self.workspace_path,
            self.config['git']['namespace']
        )
    
    def capture(self, namespace: str, summary: str, content: str = "", 
                tags: List[str] = None, file_path: str = None) -> str:
        """Capture a new memory"""
        
        # Validate namespace
        if namespace not in self.config['namespaces']:
            raise ValueError(f"Unknown namespace: {namespace}. Use: {self.config['namespaces']}")
        
        # Generate ID
        memory_id = f"mem_{uuid.uuid4().hex[:12]}"
        
        # Filter secrets
        content = self.secrets_filter.filter(content)
        summary = self.secrets_filter.filter(summary)
        
        # Create memory object
        now = datetime.now().isoformat()
        memory = Memory(
            id=memory_id,
            namespace=namespace,
            summary=summary,
            content=content,
            tags=tags or [],
            file_path=file_path,
            created_at=now,
            updated_at=now
        )
        
        # Generate embedding
        text_to_embed = f"{summary} {content}"
        embedding = self.embedding_model.encode([text_to_embed])[0]
        
        # Store in backend
        self.backend.insert(memory, embedding)
        
        # Store in git notes
        memory_dict = asdict(memory)
        memory_dict['embedding_model'] = self.config['embeddings']['model']
        self.git_storage.save(memory_id, memory_dict)
        
        return memory_id
    
    def search(self, query: str, namespace: str = None, k: int = 5, 
               min_similarity: float = 0.5) -> List[MemoryResult]:
        """Search memories semantically"""
        
        # Generate query embedding
        query_embedding = self.embedding_model.encode([query])[0]
        
        # Search backend
        results = self.backend.search(
            query_embedding,
            namespace=namespace,
            k=k,
            min_similarity=min_similarity
        )
        
        # Load full memories
        memory_results = []
        for memory_id, similarity in results:
            memory = self.backend.get(memory_id)
            if memory:
                memory_results.append(MemoryResult(memory=memory, similarity=similarity))
        
        return memory_results
    
    def get(self, memory_id: str) -> Optional[Memory]:
        """Get memory by ID"""
        return self.backend.get(memory_id)
    
    def sync_from_git(self):
        """Sync memories from git notes to local index"""
        memories = self.git_storage.load_all()
        
        for data in memories:
            memory = Memory(
                id=data['id'],
                namespace=data['namespace'],
                summary=data['summary'],
                content=data['content'],
                tags=data.get('tags', []),
                file_path=data.get('file_path'),
                created_at=data['created_at'],
                updated_at=data['updated_at'],
                git_note_ref=data.get('git_note_ref')
            )
            
            # Re-embed if needed
            text = f"{memory.summary} {memory.content}"
            embedding = self.embedding_model.encode([text])[0]
            
            try:
                self.backend.insert(memory, embedding)
            except sqlite3.IntegrityError:
                # Already exists
                pass
        
        return len(memories)


# Convenience functions for CLI usage
def get_memory_system() -> MemorySystem:
    """Get configured memory system"""
    return MemorySystem()


if __name__ == "__main__":
    # CLI usage
    import argparse
    
    parser = argparse.ArgumentParser(description="Memory RAG System")
    subparsers = parser.add_subparsers(dest='command')
    
    # Capture command
    capture_parser = subparsers.add_parser('capture')
    capture_parser.add_argument('--namespace', '-n', required=True)
    capture_parser.add_argument('--summary', '-s', required=True)
    capture_parser.add_argument('--content', '-c', default='')
    capture_parser.add_argument('--tags', '-t', default='')
    
    # Search command
    search_parser = subparsers.add_parser('search')
    search_parser.add_argument('query')
    search_parser.add_argument('--namespace', '-n', default=None)
    search_parser.add_argument('--k', type=int, default=5)
    
    # Sync command
    sync_parser = subparsers.add_parser('sync')
    
    args = parser.parse_args()
    
    memory = get_memory_system()
    
    if args.command == 'capture':
        memory_id = memory.capture(
            namespace=args.namespace,
            summary=args.summary,
            content=args.content,
            tags=args.tags.split(',') if args.tags else []
        )
        print(f"✅ Captured: {memory_id}")
    
    elif args.command == 'search':
        results = memory.search(args.query, namespace=args.namespace, k=args.k)
        print(f"\n🔍 Found {len(results)} results:\n")
        for i, result in enumerate(results, 1):
            print(f"{i}. [{result.memory.namespace}] {result.memory.summary}")
            print(f"   Similarity: {result.similarity:.2%}")
            print()
    
    elif args.command == 'sync':
        count = memory.sync_from_git()
        print(f"✅ Synced {count} memories from git notes")
    
    else:
        parser.print_help()
