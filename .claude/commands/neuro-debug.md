# NeuroVis Advanced Debugging System

**Purpose**: Comprehensive educational debugging workflow for NeuroVis platform using advanced MCP integration for systematic error resolution.

**MCPs Used**: `sequential-thinking`, `godot-mcp`, `filesystem`, `memory`, `sqlite`

**Usage**: 
```bash
claude -f .claude/commands/neuro-debug.md "error_location" "description"
```

## MCP-Enhanced Debugging Pipeline

**Context**: 
- **Role**: Senior GDScript Developer specializing in educational platforms
- **Project**: NeuroVis educational neuroscience platform
- **Focus**: Educational integrity + technical excellence

Step-by-step debugging process:
1. Use sequential-thinking to analyze the error systematically
2. Read error location with filesystem MCP
3. Check similar issues in memory MCP
4. Create targeted fix using project patterns
5. Test with Godot MCP quick_test.sh
6. Log solution pattern to memory MCP

Error Location: $1
Description: $2

Output: Unified diff patch + explanation + test results
Focus: Fix only the specific issue, maintain existing architecture
```