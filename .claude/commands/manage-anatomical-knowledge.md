# Command: Manage Anatomical Knowledge

**Purpose**: Comprehensive management of NeuroVis anatomical knowledge base through SQLite database operations, memory graph relationships, and external medical validation for maintaining educational accuracy and currency.

**MCPs Used**: `sqlite` (primary), `memory`, `fetch`, `filesystem`, `sequential-thinking`

## Overview
This command provides complete anatomical knowledge management for NeuroVis educational platform, ensuring medical accuracy, educational effectiveness, and seamless integration with the KnowledgeService autoload system.

## Anatomical Knowledge Management Pipeline

### Phase 1: Knowledge Base Architecture & Analysis
**Use MCP `sequential-thinking`** to analyze knowledge management requirements:
- Map current anatomical data structure and relationships
- Identify gaps in educational content coverage
- Establish data quality standards for medical accuracy
- Plan knowledge base expansion and maintenance strategies

**Use MCP `sqlite`** to:
- Create comprehensive anatomical database schema
- Establish relationships between anatomical structures
- Index content for efficient educational queries
- Implement data integrity constraints for medical accuracy

**Knowledge Base Schema Design**:
```sql
-- Create comprehensive anatomical knowledge schema
CREATE TABLE IF NOT EXISTS anatomical_structures (
    id TEXT PRIMARY KEY,
    display_name TEXT NOT NULL,
    short_description TEXT,
    detailed_description TEXT,
    anatomical_system TEXT,
    educational_level TEXT CHECK (educational_level IN ('beginner', 'intermediate', 'advanced')),
    clinical_significance INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    medical_accuracy_score REAL DEFAULT 0.0,
    last_validated TIMESTAMP
);

CREATE TABLE IF NOT EXISTS anatomical_functions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    structure_id TEXT,
    function_description TEXT NOT NULL,
    clinical_relevance TEXT,
    pathology_implications TEXT,
    FOREIGN KEY (structure_id) REFERENCES anatomical_structures(id)
);

CREATE TABLE IF NOT EXISTS clinical_pathologies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    structure_id TEXT,
    pathology_name TEXT NOT NULL,
    description TEXT,
    symptoms TEXT,
    diagnostic_criteria TEXT,
    treatment_approaches TEXT,
    educational_significance INTEGER DEFAULT 1,
    FOREIGN KEY (structure_id) REFERENCES anatomical_structures(id)
);

CREATE TABLE IF NOT EXISTS learning_objectives (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    structure_id TEXT,
    objective_text TEXT NOT NULL,
    educational_level TEXT,
    assessment_method TEXT,
    learning_outcome_type TEXT,
    FOREIGN KEY (structure_id) REFERENCES anatomical_structures(id)
);

CREATE TABLE IF NOT EXISTS anatomical_relationships (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_structure TEXT,
    target_structure TEXT,
    relationship_type TEXT NOT NULL,
    relationship_description TEXT,
    clinical_importance INTEGER DEFAULT 1,
    FOREIGN KEY (source_structure) REFERENCES anatomical_structures(id),
    FOREIGN KEY (target_structure) REFERENCES anatomical_structures(id)
);

-- Educational progress tracking
CREATE TABLE IF NOT EXISTS knowledge_validation_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    structure_id TEXT,
    validation_type TEXT,
    validation_source TEXT,
    accuracy_score REAL,
    validator_id TEXT,
    validation_notes TEXT,
    validation_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (structure_id) REFERENCES anatomical_structures(id)
);
```

### Phase 2: Content Migration & Integration
**Use MCP `filesystem`** to:
- Read existing `anatomical_data.json` content
- Parse educational structure data and metadata
- Validate content format and completeness
- Backup existing content before migration

**Use MCP `sqlite`** to:
- Migrate JSON content to relational database structure
- Establish proper relationships between anatomical concepts
- Create indexes for educational query optimization
- Implement data validation and integrity checks

**Content Migration Implementation**:
```python
# Anatomical Knowledge Migration Tool
import json
import sqlite3
from typing import Dict, List, Any

class AnatomicalKnowledgeMigrator:
    def __init__(self, db_path: str, json_path: str):
        self.db_path = db_path
        self.json_path = json_path
        self.conn = sqlite3.connect(db_path)

    def migrate_anatomical_data(self) -> Dict[str, Any]:
        """Migrate anatomical data from JSON to SQLite with educational enhancements"""
        try:
            # Load existing JSON data
            with open(self.json_path, 'r') as f:
                anatomical_data = json.load(f)

            migration_results = {
                "structures_migrated": 0,
                "functions_migrated": 0,
                "pathologies_migrated": 0,
                "learning_objectives_created": 0,
                "relationships_established": 0,
                "validation_errors": []
            }

            # Migrate anatomical structures
            for structure in anatomical_data.get("structures", []):
                self._migrate_structure(structure, migration_results)

            # Establish anatomical relationships
            self._establish_anatomical_relationships(anatomical_data, migration_results)

            # Generate learning objectives
            self._generate_learning_objectives(migration_results)

            self.conn.commit()
            return migration_results

        except Exception as e:
            self.conn.rollback()
            return {"error": str(e), "migration_successful": False}

    def _migrate_structure(self, structure: Dict, results: Dict) -> None:
        """Migrate individual anatomical structure with educational enhancements"""
        try:
            # Insert main structure
            self.conn.execute("""
                INSERT OR REPLACE INTO anatomical_structures
                (id, display_name, short_description, anatomical_system, educational_level, clinical_significance)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (
                structure.get("id"),
                structure.get("displayName"),
                structure.get("shortDescription"),
                structure.get("anatomicalSystem", "nervous_system"),
                structure.get("educationalLevel", "intermediate"),
                structure.get("clinicalSignificance", 1)
            ))
            results["structures_migrated"] += 1

            # Migrate functions
            for function in structure.get("functions", []):
                self._migrate_function(structure["id"], function, results)

            # Migrate clinical relevance as pathologies
            clinical_relevance = structure.get("clinicalRelevance")
            if clinical_relevance:
                self._migrate_clinical_relevance(structure["id"], clinical_relevance, results)

        except Exception as e:
            results["validation_errors"].append({
                "structure_id": structure.get("id", "unknown"),
                "error": str(e)
            })

    def _migrate_function(self, structure_id: str, function: str, results: Dict) -> None:
        """Migrate anatomical function with clinical context"""
        self.conn.execute("""
            INSERT INTO anatomical_functions
            (structure_id, function_description, clinical_relevance)
            VALUES (?, ?, ?)
        """, (structure_id, function, f"Clinical implications of {function}"))
        results["functions_migrated"] += 1
```

### Phase 3: Knowledge Graph Construction
**Use MCP `memory`** to:
- Create anatomical concept entities in knowledge graph
- Establish relationships between anatomical structures
- Store educational metadata and learning pathways
- Maintain clinical significance weighting

**Knowledge Graph Implementation**:
```bash
# Create anatomical knowledge entities
memory.create_entities([
  {
    "name": "Hippocampus",
    "entityType": "anatomical_structure",
    "observations": [
      "Essential for memory formation and consolidation",
      "Located in medial temporal lobe",
      "Critical in Alzheimer's disease pathology",
      "Target for educational memory system learning"
    ]
  },
  {
    "name": "Cerebral_Cortex",
    "entityType": "anatomical_structure",
    "observations": [
      "Outer layer of cerebral hemispheres",
      "Contains majority of neuronal cell bodies",
      "Organized into functional areas",
      "Essential for higher cognitive functions"
    ]
  },
  {
    "name": "Memory_Formation",
    "entityType": "physiological_process",
    "observations": [
      "Involves hippocampus and associated structures",
      "Critical for educational learning objectives",
      "Impaired in various neurological conditions",
      "Key concept for medical student understanding"
    ]
  }
])

# Establish anatomical relationships
memory.create_relations([
  {
    "from": "Hippocampus",
    "to": "Memory_Formation",
    "relationType": "essential_for"
  },
  {
    "from": "Hippocampus",
    "to": "Temporal_Lobe",
    "relationType": "anatomically_located_in"
  },
  {
    "from": "Memory_Formation",
    "to": "Learning_Process",
    "relationType": "supports_educational"
  }
])
```

### Phase 4: External Medical Validation
**Use MCP `fetch`** to validate anatomical knowledge against authoritative sources:
- Cross-reference with PubMed for research currency
- Validate terminology against medical ontologies
- Verify clinical information with medical databases
- Update content based on latest medical research

**External Validation Workflow**:
```bash
# Validate anatomical terminology
fetch("https://www.ncbi.nlm.nih.gov/mesh/", {
  "query": "anatomical terminology validation",
  "structure": "hippocampus",
  "validation_type": "medical_accuracy"
})

# Cross-reference clinical information
fetch("https://www.who.int/classifications/icd/browse/", {
  "query": "neurological pathology validation",
  "pathology": "alzheimer_disease",
  "validation_type": "clinical_accuracy"
})

# Verify research currency
fetch("https://pubmed.ncbi.nlm.nih.gov/", {
  "query": "hippocampus memory formation recent research",
  "years": "2020-2024",
  "validation_type": "research_currency"
})
```

**Use MCP `sqlite`** to store validation results:
```sql
-- Log external validation results
INSERT INTO knowledge_validation_log
(structure_id, validation_type, validation_source, accuracy_score, validation_notes)
VALUES
('hippocampus', 'medical_terminology', 'NCBI_MeSH', 9.5, 'Terminology confirmed accurate'),
('hippocampus', 'clinical_relevance', 'WHO_ICD', 9.0, 'Clinical associations validated'),
('hippocampus', 'research_currency', 'PubMed', 8.8, 'Recent research integrated');
```

### Phase 5: Educational Content Enhancement
**Use MCP `sequential-thinking`** to systematically enhance educational value:
- Analyze learning objective completeness and clarity
- Identify gaps in clinical case study coverage
- Evaluate content accessibility for diverse learners
- Plan content updates for educational effectiveness

**Use MCP `sqlite`** to implement educational enhancements:
```sql
-- Generate comprehensive learning objectives
INSERT INTO learning_objectives (structure_id, objective_text, educational_level, learning_outcome_type)
VALUES
('hippocampus', 'Identify hippocampus location in coronal brain sections', 'beginner', 'anatomical_identification'),
('hippocampus', 'Explain hippocampal role in memory consolidation', 'intermediate', 'functional_understanding'),
('hippocampus', 'Analyze hippocampal pathology in neurodegenerative diseases', 'advanced', 'clinical_application'),
('hippocampus', 'Correlate hippocampal dysfunction with clinical symptoms', 'advanced', 'diagnostic_reasoning');

-- Add clinical pathology information
INSERT INTO clinical_pathologies
(structure_id, pathology_name, description, symptoms, diagnostic_criteria, educational_significance)
VALUES
('hippocampus', 'Alzheimer Disease', 'Progressive neurodegenerative disease affecting memory',
 'Memory loss, cognitive decline, behavioral changes',
 'Clinical assessment, neuroimaging, biomarkers', 5),
('hippocampus', 'Temporal Lobe Epilepsy', 'Seizure disorder often involving hippocampal sclerosis',
 'Complex partial seizures, memory impairment',
 'EEG, MRI, clinical history', 4);
```

### Phase 6: Query Optimization & Performance
**Use MCP `sqlite`** to optimize knowledge base performance:
- Create indexes for educational query patterns
- Implement full-text search for anatomical content
- Optimize relationship queries for learning pathways
- Configure database performance for real-time educational use

**Performance Optimization**:
```sql
-- Create indexes for educational queries
CREATE INDEX idx_structures_educational_level ON anatomical_structures(educational_level);
CREATE INDEX idx_structures_clinical_significance ON anatomical_structures(clinical_significance);
CREATE INDEX idx_functions_structure ON anatomical_functions(structure_id);
CREATE INDEX idx_pathologies_structure ON clinical_pathologies(structure_id);
CREATE INDEX idx_relationships_source ON anatomical_relationships(source_structure);
CREATE INDEX idx_relationships_target ON anatomical_relationships(target_structure);

-- Enable full-text search for educational content
CREATE VIRTUAL TABLE anatomical_search USING fts5(
    id, display_name, short_description, content,
    content='anatomical_structures',
    content_rowid='rowid'
);

-- Populate search index
INSERT INTO anatomical_search(id, display_name, short_description, content)
SELECT id, display_name, short_description,
       display_name || ' ' || short_description || ' ' ||
       COALESCE(detailed_description, '') as content
FROM anatomical_structures;
```

### Phase 7: Integration with NeuroVis Services
**Use MCP `filesystem`** to update NeuroVis integration:
- Update KnowledgeService to use SQLite backend
- Maintain backward compatibility with existing educational workflows
- Implement caching strategies for performance
- Configure database connections for educational use

**KnowledgeService Integration**:
```gdscript
## SQLiteKnowledgeService.gd
## Enhanced KnowledgeService with SQLite backend for comprehensive anatomical data

class_name SQLiteKnowledgeService
extends Node

# === CONSTANTS ===
const DATABASE_PATH: String = "user://anatomical_knowledge.db"
const CACHE_SIZE: int = 100
const QUERY_TIMEOUT: float = 5.0

# === DATABASE CONNECTION ===
var _db: SQLite
var _connection_active: bool = false
var _query_cache: Dictionary = {}

func _ready() -> void:
    _initialize_database_connection()

## Initialize SQLite database connection for educational content
func _initialize_database_connection() -> bool:
    _db = SQLite.new()

    if not _db.open(DATABASE_PATH):
        push_error("[SQLiteKnowledgeService] Failed to open anatomical database")
        return false

    _connection_active = true
    print("[SQLiteKnowledgeService] Anatomical knowledge database connected")
    return true

## Get comprehensive anatomical structure data with educational enhancements
## @param structure_id String - Anatomical structure identifier
## @return Dictionary - Complete educational structure data
func get_enhanced_structure_data(structure_id: String) -> Dictionary:
    if not _connection_active:
        push_error("[SQLiteKnowledgeService] Database connection not available")
        return {}

    # Check cache first
    var cache_key = "structure:" + structure_id
    if _query_cache.has(cache_key):
        return _query_cache[cache_key]

    # Query comprehensive structure data
    var query = """
        SELECT s.*,
               GROUP_CONCAT(f.function_description) as functions,
               GROUP_CONCAT(p.pathology_name) as pathologies,
               GROUP_CONCAT(lo.objective_text) as learning_objectives
        FROM anatomical_structures s
        LEFT JOIN anatomical_functions f ON s.id = f.structure_id
        LEFT JOIN clinical_pathologies p ON s.id = p.structure_id
        LEFT JOIN learning_objectives lo ON s.id = lo.structure_id
        WHERE s.id = ?
        GROUP BY s.id
    """

    _db.query_with_bindings(query, [structure_id])
    var result = _db.query_result

    if result.is_empty():
        push_warning("[SQLiteKnowledgeService] No data found for structure: " + structure_id)
        return {}

    var structure_data = _format_educational_structure_data(result[0])
    _query_cache[cache_key] = structure_data

    return structure_data

## Search anatomical structures with educational context
## @param search_term String - Search query
## @param educational_level String - Target educational level
## @return Array - Matching structures with educational metadata
func search_educational_structures(search_term: String, educational_level: String = "") -> Array:
    if not _connection_active:
        return []

    var query = """
        SELECT s.*,
               snippet(anatomical_search, 2, '<mark>', '</mark>', '...', 32) as highlight
        FROM anatomical_search
        JOIN anatomical_structures s ON anatomical_search.id = s.id
        WHERE anatomical_search MATCH ?
    """

    var bindings = [search_term]

    if not educational_level.is_empty():
        query += " AND s.educational_level = ?"
        bindings.append(educational_level)

    query += " ORDER BY s.clinical_significance DESC, rank"

    _db.query_with_bindings(query, bindings)

    var results = []
    for row in _db.query_result:
        results.append(_format_educational_structure_data(row))

    return results

func _format_educational_structure_data(row: Dictionary) -> Dictionary:
    return {
        "id": row.get("id", ""),
        "displayName": row.get("display_name", ""),
        "shortDescription": row.get("short_description", ""),
        "detailedDescription": row.get("detailed_description", ""),
        "anatomicalSystem": row.get("anatomical_system", ""),
        "educationalLevel": row.get("educational_level", "intermediate"),
        "clinicalSignificance": row.get("clinical_significance", 1),
        "functions": _parse_concatenated_field(row.get("functions", "")),
        "pathologies": _parse_concatenated_field(row.get("pathologies", "")),
        "learningObjectives": _parse_concatenated_field(row.get("learning_objectives", "")),
        "medicalAccuracyScore": row.get("medical_accuracy_score", 0.0),
        "lastValidated": row.get("last_validated", "")
    }
```

## Anatomical Knowledge Management Quality Checklist

### Data Quality Standards
- [ ] All anatomical terminology validated against medical standards
- [ ] Clinical information cross-referenced with authoritative sources
- [ ] Educational content aligned with medical curriculum standards
- [ ] Database schema optimized for educational query patterns
- [ ] Data integrity constraints prevent invalid anatomical relationships

### Educational Excellence
- [ ] Learning objectives defined for all educational levels
- [ ] Clinical relevance documented for all anatomical structures
- [ ] Pathology information accurate and educationally significant
- [ ] Content accessibility verified for diverse learning needs
- [ ] Assessment integration planned for knowledge validation

### Technical Performance
- [ ] Database queries optimized for real-time educational use
- [ ] Full-text search enables efficient content discovery
- [ ] Caching strategies minimize database load
- [ ] KnowledgeService integration maintains existing workflows
- [ ] Database backup and recovery procedures established

### Medical Accuracy Validation
- [ ] External medical database validation completed
- [ ] Expert medical review process implemented
- [ ] Regular content updates scheduled for research currency
- [ ] Validation audit trail maintained for compliance
- [ ] Accuracy scoring system tracks content quality

## MCP Integration Workflow

```bash
# 1. Initialize knowledge management
sequential_thinking.think("Analyze anatomical knowledge management requirements")
memory.create_entities([{
  "name": "AnatomicalKnowledgeManagement",
  "entityType": "knowledge_system",
  "observations": ["Database design", "Educational requirements", "Medical accuracy standards"]
}])

# 2. Database operations
sqlite.create_table("anatomical_structures_schema")
sqlite.write_query("INSERT INTO anatomical_structures ...")
sqlite.read_query("SELECT * FROM anatomical_structures WHERE ...")

# 3. External validation
fetch("https://www.ncbi.nlm.nih.gov/mesh/", "validate_anatomical_terminology")
fetch("https://pubmed.ncbi.nlm.nih.gov/", "verify_research_currency")

# 4. Knowledge graph integration
memory.add_observations([{
  "entityName": "AnatomicalStructures",
  "contents": ["Structure relationships", "Clinical significance", "Educational pathways"]
}])

# 5. Update NeuroVis integration
filesystem.edit_file("core/knowledge/KnowledgeService.gd", "sqlite_integration")
filesystem.write_file("assets/data/anatomical_knowledge_backup.json", "backup_data")
```

## Success Criteria

- Comprehensive SQLite database contains all anatomical knowledge with educational metadata
- External medical validation confirms accuracy of all anatomical and clinical content
- Knowledge graph relationships support educational learning pathways
- Database performance supports real-time educational queries (<100ms response time)
- KnowledgeService integration maintains backward compatibility with existing workflows
- Full-text search enables efficient educational content discovery
- Regular validation process ensures content remains current with medical knowledge
- Educational enhancements support diverse learning needs and accessibility requirements
