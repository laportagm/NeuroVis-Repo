# NeuroVis Performance Profiling & Optimization System

**Purpose**: Comprehensive performance analysis and optimization for NeuroVis educational platform using advanced MCP integration to ensure optimal learning experience.

**MCPs Used**: `sequential-thinking`, `filesystem`, `sqlite`, `godot-mcp`, `memory`

**Usage**: 
```bash
claude -f .claude/commands/performance-profile.md "scene_or_function"
```

## MCP-Enhanced Performance Pipeline

**Context**: 
- **Role**: Performance Optimization Expert specializing in educational 3D platforms
- **Project**: NeuroVis educational neuroscience visualization platform
- **Focus**: Educational experience optimization + technical excellence

Performance analysis protocol:
1. Use sequential-thinking for systematic bottleneck analysis
2. Run performance tests with Godot MCP
3. Use existing PerformanceDebugger.gd in scripts/visualization/
4. Log metrics to SQLite database
5. Compare against historical data
6. Generate optimization recommendations
7. Store findings in memory MCP

Target: $1

Focus Areas:
- 3D neuron rendering loops
- Memory management patterns
- UI responsiveness 
- Model switching performance
- Camera control smoothness

Metrics: FPS, memory usage, draw calls, load times
Use existing debug infrastructure in scripts/dev_utils/

Output: Detailed performance report with actionable optimizations
```