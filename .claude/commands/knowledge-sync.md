# /knowledge-sync
**Purpose**: Sync project knowledge and architectural decisions

**Usage**: `/knowledge-sync "topic_or_update"`

**Integration**: memory + filesystem + github

**Prompt**:
```
Role: NeuroVis Project Architect
Context: Project knowledge management and documentation
Project: /Users/gagelaporta/11A-NeuroVis copy3

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