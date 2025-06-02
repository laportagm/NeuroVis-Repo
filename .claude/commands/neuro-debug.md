# /neuro-debug
**Purpose**: Comprehensive debugging workflow for NeuroVis

**Usage**: `/neuro-debug "error_location" "description"`

**Integration**: sequential-thinking + godot + filesystem + memory

**Prompt**:
```
Role: Senior GDScript Developer
Context: NeuroVis debugging session
Project: /Users/gagelaporta/11A-NeuroVis copy3

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