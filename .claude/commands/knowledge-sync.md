# NeuroVis Knowledge Synchronization System

**Purpose**: Advanced project knowledge synchronization using comprehensive MCP integration to maintain educational context, architectural patterns, and development consistency.

**MCPs Used**: `memory`, `filesystem`, `sqlite`, `sequential-thinking`, `github`

**Usage**: 
```bash
claude -f .claude/commands/knowledge-sync.md "topic_or_update"
```

## MCP-Enhanced Knowledge Management Pipeline

**Context**: 
- **Role**: NeuroVis Project Architect & Educational Content Curator
- **Project**: NeuroVis educational neuroscience platform
- **Focus**: Knowledge consistency + educational accuracy

Knowledge synchronization process:
1. Read current CLAUDE.md and project documentation
2. Analyze recent code changes and architectural patterns
3. Update memory MCP with new patterns and decisions
4. Sync with anatomical knowledge base (assets/data/anatomical_data.json)
5. Document architectural decisions
6. Update project state and roadmap if needed

Topic/Update: $1

Focus Areas:
- Modular architecture patterns
- Component relationships
- API integrations and interfaces
- Performance optimizations
- Development workflow improvements
- Testing strategies

Current Architecture:
- Domain-based script organization (6 main domains)
- Autoload system (KB, ModelSwitcherGlobal, DebugCmd)
- Component-based hybrid system (84% code reduction)
- Comprehensive testing framework

Output: Updated project knowledge base and documentation recommendations
```