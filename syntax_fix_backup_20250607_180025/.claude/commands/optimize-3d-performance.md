# Command: Optimize 3D Performance

**Purpose**: Optimize NeuroVis 3D brain visualization performance to maintain consistent 60fps while preserving educational value and visual fidelity for complex anatomical models.

**MCPs Used**: `godot-mcp` (primary), `sequential-thinking`, `playwright`, `filesystem`, `memory`

## Overview
This command provides comprehensive 3D performance optimization for NeuroVis educational platform, ensuring smooth interactive learning experiences with complex brain models while maintaining medical accuracy and educational effectiveness.

## 3D Performance Optimization Pipeline

### Phase 1: Performance Analysis & Profiling
**Use MCP `sequential-thinking`** to systematically analyze performance requirements:
- Identify performance bottlenecks in brain model rendering
- Analyze educational interaction patterns and usage scenarios
- Establish performance targets for different hardware configurations
- Prioritize optimization efforts based on educational impact

**Use MCP `godot-mcp`** to:
- Profile current 3D rendering performance with brain models
- Analyze draw calls, vertex counts, and texture usage
- Identify GPU bottlenecks and CPU limitations
- Test performance across different anatomical viewing scenarios

**Performance Profiling Implementation**:
```gdscript
## BrainVisualizationProfiler.gd
## Profiles 3D performance for NeuroVis brain models with educational context

class_name BrainVisualizationProfiler
extends Node

# === CONSTANTS ===
const TARGET_FPS: int = 60
const MAX_DRAW_CALLS: int = 100
const MAX_TEXTURE_MEMORY_MB: int = 500
const PERFORMANCE_SAMPLE_DURATION: float = 10.0

# === SIGNALS ===
## Emitted when performance metrics are collected
## @param metrics Dictionary - Performance data with educational context
signal performance_metrics_collected(metrics: Dictionary)

# === PERFORMANCE METRICS ===
var _performance_data: Dictionary = {}
var _sampling_active: bool = false
var _sample_start_time: float

## Start comprehensive performance profiling for educational 3D content
## @param profiling_config Dictionary - Configuration for profiling parameters
func start_educational_profiling(profiling_config: Dictionary) -> void:
    if _sampling_active:
        push_warning("[BrainProfiler] Profiling already active")
        return

    _reset_performance_metrics()
    _configure_profiling_parameters(profiling_config)
    _sampling_active = true
    _sample_start_time = Time.get_time_from_start()

    print("[BrainProfiler] Started educational 3D performance profiling")

## Collect real-time performance metrics for brain visualization
func _process(_delta: float) -> void:
    if not _sampling_active:
        return

    var current_time = Time.get_time_from_start()
    if current_time - _sample_start_time >= PERFORMANCE_SAMPLE_DURATION:
        _finalize_performance_sampling()
        return

    _collect_frame_metrics()
    _analyze_educational_interaction_performance()

func _collect_frame_metrics() -> void:
    var fps = Engine.get_frames_per_second()
    var draw_calls = RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TYPE_VISIBLE, RenderingServer.RENDERING_INFO_DRAW_CALLS_IN_FRAME)
    var texture_memory = RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TYPE_VIDEO, RenderingServer.RENDERING_INFO_VIDEO_MEM_USED)

    _performance_data.fps_samples.append(fps)
    _performance_data.draw_call_samples.append(draw_calls)
    _performance_data.memory_samples.append(texture_memory)

    # Track educational performance thresholds
    if fps < TARGET_FPS:
        _performance_data.fps_violations += 1

    if draw_calls > MAX_DRAW_CALLS:
        _performance_data.draw_call_violations += 1

func _analyze_educational_interaction_performance() -> void:
    # Analyze performance during educational interactions
    var brain_models = get_tree().get_nodes_in_group("brain_models")
    var ui_panels = get_tree().get_nodes_in_group("educational_panels")

    _performance_data.active_brain_models = brain_models.size()
    _performance_data.active_ui_panels = ui_panels.size()

    # Check selection system performance
    if has_node("/root/BrainStructureSelectionManager"):
        var selection_manager = get_node("/root/BrainStructureSelectionManager")
        _performance_data.selection_performance = selection_manager.get_selection_performance_metrics()
```

### Phase 2: LOD (Level of Detail) Optimization
**Use MCP `godot-mcp`** to implement educational LOD system:
- Create multiple detail levels for brain models based on viewing distance
- Implement educational priority-based LOD (important structures maintain higher detail)
- Optimize mesh complexity while preserving anatomical accuracy
- Configure automatic LOD switching for smooth performance

**Educational LOD Implementation**:
```gdscript
## EducationalLODManager.gd
## Manages Level of Detail for brain models with educational priority weighting

class_name EducationalLODManager
extends Node

# === CONSTANTS ===
const DETAIL_LEVELS: int = 4
const EDUCATIONAL_PRIORITY_WEIGHT: float = 0.3
const DISTANCE_WEIGHT: float = 0.7

# === ENUMS ===
enum EducationalPriority {
    CRITICAL,      # Essential structures (e.g., hippocampus, cortex)
    HIGH,          # Important for curriculum (e.g., basal ganglia)
    MEDIUM,        # Supporting structures (e.g., white matter tracts)
    LOW            # Background structures (e.g., meninges)
}

## Optimize brain model LOD based on educational importance and viewing distance
## @param brain_model MeshInstance3D - Brain structure to optimize
## @param camera_distance float - Distance from educational viewing camera
## @param educational_priority EducationalPriority - Educational importance
func optimize_educational_lod(brain_model: MeshInstance3D, camera_distance: float, educational_priority: EducationalPriority) -> void:
    if not brain_model or not brain_model.mesh:
        push_warning("[EducationalLOD] Invalid brain model provided")
        return

    var lod_level = _calculate_educational_lod_level(camera_distance, educational_priority)
    var optimized_mesh = _generate_lod_mesh(brain_model.mesh, lod_level)

    brain_model.mesh = optimized_mesh

    # Maintain educational annotations for critical structures
    if educational_priority == EducationalPriority.CRITICAL:
        _preserve_educational_annotations(brain_model)

func _calculate_educational_lod_level(distance: float, priority: EducationalPriority) -> int:
    # Distance-based LOD calculation
    var distance_lod = clamp(int(distance / 10.0), 0, DETAIL_LEVELS - 1)

    # Educational priority adjustment
    var priority_adjustment = 0
    match priority:
        EducationalPriority.CRITICAL:
            priority_adjustment = -2  # Higher detail for critical structures
        EducationalPriority.HIGH:
            priority_adjustment = -1
        EducationalPriority.MEDIUM:
            priority_adjustment = 0
        EducationalPriority.LOW:
            priority_adjustment = 1   # Lower detail for less important structures

    return clamp(distance_lod + priority_adjustment, 0, DETAIL_LEVELS - 1)
```

### Phase 3: Texture and Material Optimization
**Use MCP `filesystem`** to:
- Analyze texture usage and compression settings
- Optimize brain material shaders for educational visualization
- Implement texture atlasing for brain regions
- Configure texture streaming for large anatomical datasets

**Use MCP `memory`** to:
- Store optimization patterns and best practices
- Track material performance characteristics
- Maintain texture optimization guidelines
- Record successful optimization strategies

**Material Optimization Implementation**:
```gdscript
## BrainMaterialOptimizer.gd
## Optimizes materials and textures for educational brain visualization

class_name BrainMaterialOptimizer
extends Node

# === MATERIAL OPTIMIZATION ===
## Optimize brain materials for educational performance
## @param brain_materials Array[Material] - Materials to optimize
## @param optimization_level int - Optimization intensity (0-3)
## @return Array[Material] - Optimized materials
func optimize_brain_materials(brain_materials: Array[Material], optimization_level: int) -> Array[Material]:
    var optimized_materials: Array[Material] = []

    for material in brain_materials:
        var optimized_material = _optimize_single_material(material, optimization_level)
        optimized_materials.append(optimized_material)

    return optimized_materials

func _optimize_single_material(material: Material, optimization_level: int) -> Material:
    if not material is StandardMaterial3D:
        return material

    var optimized = material.duplicate() as StandardMaterial3D

    match optimization_level:
        0: # Minimal optimization - preserve full quality
            _apply_minimal_optimization(optimized)
        1: # Moderate optimization - balance quality and performance
            _apply_moderate_optimization(optimized)
        2: # Aggressive optimization - prioritize performance
            _apply_aggressive_optimization(optimized)
        3: # Maximum optimization - educational functionality only
            _apply_maximum_optimization(optimized)

    return optimized

func _apply_educational_shader_optimization(material: StandardMaterial3D) -> void:
    # Optimize shaders for educational brain visualization
    material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
    material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED

    # Maintain selection highlighting capability
    material.flags_use_point_size = true
    material.flags_vertex_lighting = true
```

### Phase 4: UI Performance Optimization
**Use MCP `playwright`** to test UI performance:
- Validate educational panel rendering performance
- Test theme switching performance (Enhanced/Minimal)
- Analyze accessibility feature performance impact
- Validate responsive design performance across devices

**UI Performance Testing**:
```bash
# Test educational panel performance
playwright.browser_navigate("file://test_educational_panels.html")
playwright.browser_take_screenshot("ui_performance_baseline")

# Validate theme switching performance
playwright.browser_evaluate(`
  // Test Enhanced theme performance
  UIThemeManager.set_theme_mode(UIThemeManager.ThemeMode.ENHANCED);
  performance.mark('enhanced_theme_start');

  // Measure rendering time
  requestAnimationFrame(() => {
    performance.mark('enhanced_theme_end');
    performance.measure('enhanced_theme_switch', 'enhanced_theme_start', 'enhanced_theme_end');
  });
`)

# Test accessibility feature performance
playwright.browser_evaluate(`
  // Enable accessibility features and measure impact
  AccessibilityManager.enable_screen_reader_support();
  AccessibilityManager.enable_keyboard_navigation();

  // Measure performance impact
  performance.mark('accessibility_enabled');
`)
```

### Phase 5: Memory Management Optimization
**Use MCP `godot-mcp`** to optimize memory usage:
- Implement efficient brain model loading and unloading
- Optimize texture memory management for large datasets
- Configure garbage collection for educational content
- Implement smart caching for frequently accessed structures

**Memory Management Implementation**:
```gdscript
## BrainModelMemoryManager.gd
## Manages memory for educational brain models and textures

class_name BrainModelMemoryManager
extends Node

# === CONSTANTS ===
const MAX_LOADED_MODELS: int = 10
const TEXTURE_CACHE_SIZE_MB: int = 200
const MODEL_CACHE_SIZE_MB: int = 300

# === CACHING SYSTEM ===
var _model_cache: Dictionary = {}
var _texture_cache: Dictionary = {}
var _memory_usage: Dictionary = {"models": 0, "textures": 0}

## Load brain model with intelligent caching for educational performance
## @param model_path String - Path to brain model resource
## @param educational_priority EducationalPriority - Priority for caching
## @return MeshInstance3D - Loaded brain model
func load_educational_brain_model(model_path: String, educational_priority: EducationalPriority) -> MeshInstance3D:
    # Check cache first
    if _model_cache.has(model_path):
        _update_cache_access_time(model_path)
        return _model_cache[model_path].duplicate()

    # Load new model
    var brain_model = _load_brain_model_resource(model_path)
    if brain_model == null:
        push_error("[MemoryManager] Failed to load brain model: " + model_path)
        return null

    # Cache management based on educational priority
    _cache_brain_model(model_path, brain_model, educational_priority)

    return brain_model

func _cache_brain_model(model_path: String, brain_model: MeshInstance3D, priority: EducationalPriority) -> void:
    # Remove least important models if cache is full
    if _model_cache.size() >= MAX_LOADED_MODELS:
        _evict_lowest_priority_model()

    _model_cache[model_path] = {
        "model": brain_model,
        "priority": priority,
        "access_time": Time.get_time_from_start(),
        "access_count": 1
    }

    _update_memory_usage()

func _evict_lowest_priority_model() -> void:
    var lowest_priority_path: String = ""
    var lowest_priority_value = EducationalPriority.CRITICAL

    for path in _model_cache.keys():
        var cached_item = _model_cache[path]
        if cached_item.priority > lowest_priority_value:
            lowest_priority_value = cached_item.priority
            lowest_priority_path = path

    if not lowest_priority_path.is_empty():
        _model_cache.erase(lowest_priority_path)
        print("[MemoryManager] Evicted model: " + lowest_priority_path)
```

### Phase 6: Performance Monitoring Integration
**Use MCP `sequential-thinking`** to design monitoring system:
- Implement real-time performance metrics collection
- Create educational performance dashboards
- Establish performance alerts for educational quality thresholds
- Design automated optimization triggers

**Use MCP `memory`** to:
- Store performance optimization patterns
- Track optimization effectiveness over time
- Maintain performance benchmarks for different hardware
- Create relationships between optimization strategies and outcomes

### Phase 7: Automated Performance Testing
**Use MCP `playwright`** for comprehensive performance testing:
- Automated performance regression testing
- Cross-platform performance validation
- Educational workflow performance testing
- Accessibility feature performance impact analysis

**Performance Testing Suite**:
```bash
# Comprehensive 3D performance test suite
playwright.browser_navigate("neurovis://educational_performance_test")

# Test brain model loading performance
playwright.browser_evaluate(`
  async function testBrainModelPerformance() {
    const models = ['hippocampus', 'cortex', 'brainstem', 'cerebellum'];
    const results = {};

    for (const model of models) {
      performance.mark('model_load_start_' + model);
      await BrainModelManager.load_model(model);
      performance.mark('model_load_end_' + model);

      performance.measure('model_load_' + model,
        'model_load_start_' + model,
        'model_load_end_' + model);

      const measure = performance.getEntriesByName('model_load_' + model)[0];
      results[model] = measure.duration;
    }

    return results;
  }
`)

# Test educational interaction performance
playwright.browser_evaluate(`
  // Test structure selection performance
  performance.mark('selection_start');
  BrainStructureSelectionManager.select_structure('hippocampus');
  performance.mark('selection_end');
  performance.measure('structure_selection', 'selection_start', 'selection_end');
`)
```

## Performance Optimization Quality Checklist

### Performance Standards
- [ ] Maintains consistent 60fps during all educational interactions
- [ ] Loading time <3 seconds for initial brain model display
- [ ] Memory usage remains under 500MB for texture data
- [ ] Draw calls optimized to <100 per frame
- [ ] LOD system preserves educational accuracy at all detail levels

### Educational Quality Preservation
- [ ] Anatomical accuracy maintained at all optimization levels
- [ ] Educational annotations and labels remain visible
- [ ] Interactive features function smoothly during optimization
- [ ] Clinical relevance preserved in optimized models
- [ ] Accessibility features maintain performance standards

### Cross-Platform Performance
- [ ] Performance validated on minimum hardware specifications
- [ ] Optimization scales appropriately across device capabilities
- [ ] Educational functionality consistent across platforms
- [ ] Memory management adapts to available system resources
- [ ] Performance monitoring works across all target platforms

### Integration Standards
- [ ] NeuroVis autoload services maintain performance
- [ ] Theme switching (Enhanced/Minimal) remains smooth
- [ ] AI assistant integration doesn't impact 3D performance
- [ ] Debug commands for performance monitoring available
- [ ] Educational workflow performance meets targets

## MCP Integration Workflow

```bash
# 1. Initialize performance analysis
sequential_thinking.think("Analyze 3D performance bottlenecks for educational brain models")
memory.create_entities([{
  "name": "PerformanceOptimization",
  "entityType": "optimization_process",
  "observations": ["Bottleneck analysis", "Optimization strategies", "Performance targets"]
}])

# 2. Profile current performance
godot-mcp.run_project("profile brain model performance")
godot-mcp.get_debug_output()

# 3. Test UI performance
playwright.browser_navigate("neurovis://performance_test")
playwright.browser_evaluate("run_educational_performance_tests()")

# 4. Implement optimizations
filesystem.edit_file("core/models/LODManager.gd", "educational_lod_optimization")
godot-mcp.create_scene("test/performance/", "optimized_test_scene.tscn")

# 5. Validate optimization results
memory.add_observations([{
  "entityName": "OptimizationResults",
  "contents": ["Performance improvements", "Educational quality preservation", "Cross-platform validation"]
}])
```

## Success Criteria

- Consistent 60fps performance maintained during complex educational interactions
- Brain model loading time reduced to <3 seconds for all anatomical structures
- Memory usage optimized while preserving educational and medical accuracy
- LOD system maintains anatomical correctness at all detail levels
- Educational workflow performance meets established targets
- Cross-platform performance validated on minimum hardware specifications
- Automated performance monitoring prevents regression
- Optimization strategies documented and reproducible
