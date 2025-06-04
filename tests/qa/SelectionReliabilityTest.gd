## SelectionReliabilityTest.gd
## Comprehensive automated testing for structure selection reliability
##
## This QA testing suite systematically evaluates selection accuracy for all
## 25 anatomical structures across multiple camera angles and zoom levels.
##
## @tutorial: Educational QA Testing Standards
## @version: 1.0

class_name SelectionReliabilityTest
extends Node

# === CONSTANTS ===
const STRUCTURES_TO_TEST: Array[String] = [
    "Striatum", "Ventricles", "Thalamus", "Hippocampus", "Amygdala",
    "Midbrain", "Pons", "Medulla", "Corpus_Callosum", "Brainstem",
    "Cerebellum", "Frontal_Lobe", "Temporal_Lobe", "Parietal_Lobe",
    "Occipital_Lobe", "Insular_Cortex", "Cingulate_Cortex",
    "Caudate_Nucleus", "Putamen", "Globus_Pallidus", "Substantia_Nigra",
    "Subthalamic_Nucleus", "Pineal_Gland", "Pituitary_Gland", "Hypothalamus"
]

const REPETITIONS_PER_STRUCTURE: int = 10
const CAMERA_POSITIONS: Array[Dictionary] = [
    {"name": "front", "rotation": Vector3(0, 0, 0), "distance": 5.0},
    {"name": "right", "rotation": Vector3(0, PI/2, 0), "distance": 5.0},
    {"name": "left", "rotation": Vector3(0, -PI/2, 0), "distance": 5.0},
    {"name": "top", "rotation": Vector3(-PI/2, 0, 0), "distance": 5.0},
    {"name": "diagonal", "rotation": Vector3(-PI/4, PI/4, 0), "distance": 6.0}
]

const ZOOM_LEVELS: Array[float] = [3.0, 5.0, 8.0]  # Close, medium, far
const CLICK_DELAY: float = 0.1  # Delay between selection attempts
const CAMERA_TRANSITION_TIME: float = 0.5

# === SIGNALS ===
signal test_started
signal test_progress(current: int, total: int)
signal test_completed(results: Dictionary)
signal structure_test_completed(structure_name: String, results: Dictionary)

# === PRIVATE VARIABLES ===
var _main_scene: Node3D
var _selection_manager: Node
var _camera_controller: Node
var _camera: Camera3D
var _viewport: Viewport

var _test_results: Dictionary = {}
var _current_test_data: Dictionary = {}
var _is_testing: bool = false
var _test_start_time: int = 0

# Test state tracking
var _current_structure_index: int = 0
var _current_camera_index: int = 0
var _current_zoom_index: int = 0
var _current_repetition: int = 0
var _selection_success: bool = false
var _last_selected_structure: String = ""

# Configurable test parameters
var _test_mode: String = "full"
var _structures_to_test: Array = []
var _camera_positions: Array = []
var _zoom_levels: Array = []
var _repetitions: int = 0

# === PUBLIC METHODS ===
## Initialize the test system with required components
func initialize(main_scene: Node3D, selection_manager: Node, camera_controller: Node, camera: Camera3D) -> bool:
    """Initialize the selection reliability test system"""
    if not main_scene or not selection_manager or not camera_controller or not camera:
        push_error("[SelectionTest] Missing required components for initialization")
        return false
    
    _main_scene = main_scene
    _selection_manager = selection_manager
    _camera_controller = camera_controller
    _camera = camera
    _viewport = _camera.get_viewport()
    
    # Connect to selection signals
    if _selection_manager.has_signal("structure_selected"):
        _selection_manager.structure_selected.connect(_on_structure_selected)
    
    print("[SelectionTest] Initialized successfully")
    return true

## Start the comprehensive selection reliability test
func start_test() -> void:
    """Begin automated testing of all structures"""
    if _is_testing:
        push_warning("[SelectionTest] Test already in progress")
        return
    
    print("[SelectionTest] Starting comprehensive selection reliability test")
    _is_testing = true
    _test_start_time = Time.get_ticks_msec()
    
    # Initialize test data
    _test_results.clear()
    _current_test_data.clear()
    
    # Reset test state
    _current_structure_index = 0
    _current_camera_index = 0
    _current_zoom_index = 0
    _current_repetition = 0
    
    test_started.emit()
    
    # Start first test
    _test_next_configuration()

## Stop the current test
func stop_test() -> void:
    """Stop the current test run"""
    if not _is_testing:
        return
    
    _is_testing = false
    print("[SelectionTest] Test stopped by user")
    _generate_report()

## Configure test for different modes
func set_test_configuration(mode: String, structures: Array = []) -> void:
    """Configure test based on mode (quick, single, or full)"""
    _test_mode = mode
    
    match mode:
        "quick":
            # Override for quick test - use provided structures
            _structures_to_test = structures if not structures.is_empty() else ["Hippocampus", "Thalamus", "Cerebellum", "Frontal_Lobe", "Brainstem"]
            _camera_positions = [
                {"name": "front", "rotation": Vector3(0, 0, 0), "distance": 5.0},
                {"name": "right", "rotation": Vector3(0, PI/2, 0), "distance": 5.0},
                {"name": "top", "rotation": Vector3(-PI/2, 0, 0), "distance": 5.0}
            ]
            _zoom_levels = [5.0]  # Medium zoom only
            _repetitions = 3  # Fewer repetitions
        
        "single":
            # Test single structure from all angles
            _structures_to_test = structures
            _camera_positions = CAMERA_POSITIONS.duplicate()  # Use all angles
            _zoom_levels = ZOOM_LEVELS.duplicate()  # Use all zoom levels
            _repetitions = REPETITIONS_PER_STRUCTURE
        
        _:  # "full" or default
            # Use all constants as configured
            _structures_to_test = STRUCTURES_TO_TEST.duplicate()
            _camera_positions = CAMERA_POSITIONS.duplicate()
            _zoom_levels = ZOOM_LEVELS.duplicate()
            _repetitions = REPETITIONS_PER_STRUCTURE

## Get current test progress
func get_test_progress() -> Dictionary:
    """Get detailed progress information"""
    var structures = _structures_to_test if not _structures_to_test.is_empty() else STRUCTURES_TO_TEST
    var cameras = _camera_positions if not _camera_positions.is_empty() else CAMERA_POSITIONS
    var zooms = _zoom_levels if not _zoom_levels.is_empty() else ZOOM_LEVELS
    var reps = _repetitions if _repetitions > 0 else REPETITIONS_PER_STRUCTURE
    
    var total_tests = structures.size() * cameras.size() * zooms.size() * reps
    var completed_tests = _calculate_completed_tests()
    
    return {
        "current_structure": structures[_current_structure_index] if _current_structure_index < structures.size() else "",
        "current_camera": cameras[_current_camera_index]["name"] if _current_camera_index < cameras.size() else "",
        "current_zoom": zooms[_current_zoom_index] if _current_zoom_index < zooms.size() else 0.0,
        "current_repetition": _current_repetition,
        "completed": completed_tests,
        "total": total_tests,
        "percentage": (float(completed_tests) / float(total_tests)) * 100.0
    }

# === PRIVATE METHODS ===
func _test_next_configuration() -> void:
    """Test the next configuration in the sequence"""
    if not _is_testing:
        return
    
    # Use configured arrays or defaults
    var structures = _structures_to_test if not _structures_to_test.is_empty() else STRUCTURES_TO_TEST
    var cameras = _camera_positions if not _camera_positions.is_empty() else CAMERA_POSITIONS
    var zooms = _zoom_levels if not _zoom_levels.is_empty() else ZOOM_LEVELS
    
    # Check if we've completed all tests
    if _current_structure_index >= structures.size():
        _complete_testing()
        return
    
    var structure_name = structures[_current_structure_index]
    var camera_config = cameras[_current_camera_index]
    var zoom_level = zooms[_current_zoom_index]
    
    # Initialize structure results if needed
    if not _test_results.has(structure_name):
        _test_results[structure_name] = {
            "total_attempts": 0,
            "successful_selections": 0,
            "camera_results": {},
            "zoom_results": {},
            "failure_coordinates": [],
            "success_coordinates": [],
            "average_selection_time": 0.0,
            "edge_case_failures": 0,
            "difficulty_score": 0.0
        }
    
    # Position camera
    _position_camera(camera_config, zoom_level)
    
    # Wait for camera to settle
    await get_tree().create_timer(CAMERA_TRANSITION_TIME).timeout
    
    # Find structure bounds for testing
    var structure_bounds = _find_structure_bounds(structure_name)
    if structure_bounds.is_empty():
        print("[SelectionTest] Warning: Could not find bounds for %s" % structure_name)
        _advance_to_next_test()
        return
    
    # Perform selection test
    _perform_selection_test(structure_name, structure_bounds, camera_config["name"], zoom_level)

func _position_camera(camera_config: Dictionary, zoom_level: float) -> void:
    """Position camera for testing"""
    if _camera_controller.has_method("set_rotation"):
        _camera_controller.set_rotation(camera_config["rotation"])
    
    if _camera_controller.has_method("set_distance"):
        _camera_controller.set_distance(zoom_level)
    
    # Alternative approach if methods don't exist
    if _camera_controller.has_method("reset_view"):
        _camera_controller.reset_view()
        # Apply manual transforms
        _camera.position = Vector3(0, 0, zoom_level)
        _camera.rotation = camera_config["rotation"]

func _find_structure_bounds(structure_name: String) -> Rect2:
    """Find screen bounds of a structure"""
    var brain_model_parent = _main_scene.get_node_or_null("BrainModel")
    if not brain_model_parent:
        return Rect2()
    
    var bounds = Rect2()
    var found_mesh = false
    
    # Search for the structure mesh
    for child in brain_model_parent.get_children():
        if child is Node3D:
            var meshes = _find_meshes_recursive(child, structure_name)
            for mesh in meshes:
                var screen_rect = _calculate_screen_bounds(mesh)
                if not found_mesh:
                    bounds = screen_rect
                    found_mesh = true
                else:
                    bounds = bounds.merge(screen_rect)
    
    return bounds

func _find_meshes_recursive(node: Node3D, structure_name: String) -> Array[MeshInstance3D]:
    """Recursively find all meshes matching structure name"""
    var meshes: Array[MeshInstance3D] = []
    
    if node is MeshInstance3D:
        var node_name = node.name.to_lower()
        var search_name = structure_name.to_lower().replace("_", " ")
        
        if node_name.contains(search_name) or search_name.contains(node_name):
            meshes.append(node)
    
    for child in node.get_children():
        if child is Node3D:
            meshes.append_array(_find_meshes_recursive(child, structure_name))
    
    return meshes

func _calculate_screen_bounds(mesh: MeshInstance3D) -> Rect2:
    """Calculate screen space bounds for a mesh"""
    if not mesh.mesh:
        return Rect2()
    
    var aabb = mesh.get_aabb()
    var transform = mesh.global_transform
    
    # Get corners of AABB
    var corners = [
        transform * aabb.position,
        transform * (aabb.position + Vector3(aabb.size.x, 0, 0)),
        transform * (aabb.position + Vector3(0, aabb.size.y, 0)),
        transform * (aabb.position + Vector3(0, 0, aabb.size.z)),
        transform * (aabb.position + Vector3(aabb.size.x, aabb.size.y, 0)),
        transform * (aabb.position + Vector3(aabb.size.x, 0, aabb.size.z)),
        transform * (aabb.position + Vector3(0, aabb.size.y, aabb.size.z)),
        transform * (aabb.position + aabb.size)
    ]
    
    # Project to screen space
    var screen_points: Array[Vector2] = []
    for corner in corners:
        if _camera.is_position_behind(corner):
            continue
        var screen_pos = _camera.unproject_position(corner)
        screen_points.append(screen_pos)
    
    if screen_points.is_empty():
        return Rect2()
    
    # Calculate bounding rectangle
    var min_pos = screen_points[0]
    var max_pos = screen_points[0]
    
    for point in screen_points:
        min_pos.x = min(min_pos.x, point.x)
        min_pos.y = min(min_pos.y, point.y)
        max_pos.x = max(max_pos.x, point.x)
        max_pos.y = max(max_pos.y, point.y)
    
    return Rect2(min_pos, max_pos - min_pos)

func _perform_selection_test(structure_name: String, bounds: Rect2, camera_name: String, zoom: float) -> void:
    """Perform a single selection test"""
    _current_test_data = {
        "structure": structure_name,
        "camera": camera_name,
        "zoom": zoom,
        "repetition": _current_repetition,
        "start_time": Time.get_ticks_msec()
    }
    
    # Reset selection state
    _selection_success = false
    _last_selected_structure = ""
    
    # Calculate test click position
    var click_position = _calculate_test_click_position(bounds, _current_repetition)
    
    # Store test attempt data
    _current_test_data["click_position"] = click_position
    _current_test_data["bounds"] = bounds
    
    # Perform selection
    if _selection_manager.has_method("handle_selection_at_position"):
        _selection_manager.handle_selection_at_position(click_position)
    
    # Wait for selection result
    await get_tree().create_timer(CLICK_DELAY).timeout
    
    # Process result
    _process_selection_result()

func _calculate_test_click_position(bounds: Rect2, repetition: int) -> Vector2:
    """Calculate click position for testing"""
    # Test different areas of the structure
    var positions = [
        bounds.get_center(),  # Center
        bounds.position + Vector2(bounds.size.x * 0.25, bounds.size.y * 0.25),  # Top-left quadrant
        bounds.position + Vector2(bounds.size.x * 0.75, bounds.size.y * 0.25),  # Top-right quadrant
        bounds.position + Vector2(bounds.size.x * 0.25, bounds.size.y * 0.75),  # Bottom-left quadrant
        bounds.position + Vector2(bounds.size.x * 0.75, bounds.size.y * 0.75),  # Bottom-right quadrant
        bounds.position + Vector2(bounds.size.x * 0.5, bounds.size.y * 0.1),   # Top edge
        bounds.position + Vector2(bounds.size.x * 0.5, bounds.size.y * 0.9),   # Bottom edge
        bounds.position + Vector2(bounds.size.x * 0.1, bounds.size.y * 0.5),   # Left edge
        bounds.position + Vector2(bounds.size.x * 0.9, bounds.size.y * 0.5),   # Right edge
        bounds.get_center() + Vector2(randf_range(-10, 10), randf_range(-10, 10))  # Random offset
    ]
    
    return positions[repetition % positions.size()]

func _process_selection_result() -> void:
    """Process the result of a selection attempt"""
    var structure_name = _current_test_data["structure"]
    var success = _selection_success and _last_selected_structure == structure_name
    
    # Update test data
    _current_test_data["success"] = success
    _current_test_data["selected_structure"] = _last_selected_structure
    _current_test_data["duration"] = Time.get_ticks_msec() - _current_test_data["start_time"]
    
    # Update results
    var results = _test_results[structure_name]
    results["total_attempts"] += 1
    
    if success:
        results["successful_selections"] += 1
        results["success_coordinates"].append(_current_test_data["click_position"])
    else:
        results["failure_coordinates"].append({
            "position": _current_test_data["click_position"],
            "camera": _current_test_data["camera"],
            "zoom": _current_test_data["zoom"],
            "selected_instead": _last_selected_structure
        })
        
        # Check if this was an edge case
        if _is_edge_click(_current_test_data["click_position"], _current_test_data["bounds"]):
            results["edge_case_failures"] += 1
    
    # Update camera-specific results
    var camera_key = _current_test_data["camera"]
    if not results["camera_results"].has(camera_key):
        results["camera_results"][camera_key] = {"attempts": 0, "successes": 0}
    results["camera_results"][camera_key]["attempts"] += 1
    if success:
        results["camera_results"][camera_key]["successes"] += 1
    
    # Update zoom-specific results
    var zoom_key = str(_current_test_data["zoom"])
    if not results["zoom_results"].has(zoom_key):
        results["zoom_results"][zoom_key] = {"attempts": 0, "successes": 0}
    results["zoom_results"][zoom_key]["attempts"] += 1
    if success:
        results["zoom_results"][zoom_key]["successes"] += 1
    
    # Update progress
    var progress = get_test_progress()
    test_progress.emit(progress["completed"], progress["total"])
    
    # Continue to next test
    _advance_to_next_test()

func _is_edge_click(position: Vector2, bounds: Rect2) -> bool:
    """Check if click position is near edge of bounds"""
    var edge_threshold = 5.0  # pixels
    
    var dist_to_left = abs(position.x - bounds.position.x)
    var dist_to_right = abs(position.x - (bounds.position.x + bounds.size.x))
    var dist_to_top = abs(position.y - bounds.position.y)
    var dist_to_bottom = abs(position.y - (bounds.position.y + bounds.size.y))
    
    return (dist_to_left < edge_threshold or dist_to_right < edge_threshold or
            dist_to_top < edge_threshold or dist_to_bottom < edge_threshold)

func _advance_to_next_test() -> void:
    """Advance to the next test configuration"""
    _current_repetition += 1
    
    var reps = _repetitions if _repetitions > 0 else REPETITIONS_PER_STRUCTURE
    var zooms = _zoom_levels if not _zoom_levels.is_empty() else ZOOM_LEVELS
    
    if _current_repetition >= reps:
        _current_repetition = 0
        _current_zoom_index += 1
        
        if _current_zoom_index >= zooms.size():
            _current_zoom_index = 0
            _current_camera_index += 1
            
            var cameras = _camera_positions if not _camera_positions.is_empty() else CAMERA_POSITIONS
            
            if _current_camera_index >= cameras.size():
                _current_camera_index = 0
                
                # Calculate structure results
                var structures = _structures_to_test if not _structures_to_test.is_empty() else STRUCTURES_TO_TEST
                _calculate_structure_metrics(structures[_current_structure_index])
                
                # Emit structure completion signal
                structure_test_completed.emit(
                    structures[_current_structure_index], 
                    _test_results[structures[_current_structure_index]])
                
                _current_structure_index += 1
    
    # Continue testing
    _test_next_configuration()

func _calculate_structure_metrics(structure_name: String) -> void:
    """Calculate final metrics for a structure"""
    var results = _test_results[structure_name]
    
    # Calculate success rate
    var success_rate = 0.0
    if results["total_attempts"] > 0:
        success_rate = float(results["successful_selections"]) / float(results["total_attempts"]) * 100.0
    
    results["success_rate"] = success_rate
    
    # Calculate difficulty score (0-100, higher = more difficult)
    var edge_failure_rate = 0.0
    if results["total_attempts"] > 0:
        edge_failure_rate = float(results["edge_case_failures"]) / float(results["total_attempts"])
    
    var difficulty_score = (100.0 - success_rate) * 0.7 + (edge_failure_rate * 100.0) * 0.3
    results["difficulty_score"] = difficulty_score
    
    # Categorize difficulty
    if difficulty_score >= 70:
        results["difficulty_category"] = "VERY_HARD"
    elif difficulty_score >= 50:
        results["difficulty_category"] = "HARD"
    elif difficulty_score >= 30:
        results["difficulty_category"] = "MEDIUM"
    elif difficulty_score >= 10:
        results["difficulty_category"] = "EASY"
    else:
        results["difficulty_category"] = "VERY_EASY"

func _calculate_completed_tests() -> int:
    """Calculate number of completed tests"""
    var structures_done = _current_structure_index
    var cameras_done = _current_camera_index
    var zooms_done = _current_zoom_index
    var reps_done = _current_repetition
    
    return (structures_done * CAMERA_POSITIONS.size() * ZOOM_LEVELS.size() * REPETITIONS_PER_STRUCTURE +
            cameras_done * ZOOM_LEVELS.size() * REPETITIONS_PER_STRUCTURE +
            zooms_done * REPETITIONS_PER_STRUCTURE +
            reps_done)

func _complete_testing() -> void:
    """Complete the testing process"""
    _is_testing = false
    var total_time = Time.get_ticks_msec() - _test_start_time
    
    print("[SelectionTest] Testing completed in %.1f seconds" % (total_time / 1000.0))
    
    _generate_report()
    test_completed.emit(_test_results)

func _generate_report() -> void:
    """Generate comprehensive testing report"""
    var report = """# NeuroVis Selection Reliability Test Report
Generated: %s
Test Duration: %.1f seconds

## Executive Summary

Total Structures Tested: %d
Total Selection Attempts: %d
Overall Success Rate: %.1f%%

## Detailed Results by Structure

""" % [Time.get_datetime_string_from_system(), 
       (Time.get_ticks_msec() - _test_start_time) / 1000.0,
       _test_results.size(),
       _calculate_total_attempts(),
       _calculate_overall_success_rate()]
    
    # Sort structures by difficulty score
    var sorted_structures = []
    for structure_name in _test_results:
        sorted_structures.append({
            "name": structure_name,
            "difficulty": _test_results[structure_name]["difficulty_score"]
        })
    
    sorted_structures.sort_custom(func(a, b): return a["difficulty"] > b["difficulty"])
    
    # Add structure results
    for struct_data in sorted_structures:
        var structure_name = struct_data["name"]
        var results = _test_results[structure_name]
        
        report += """### %s
- **Success Rate**: %.1f%% (%d/%d)
- **Difficulty Score**: %.1f/100 (%s)
- **Edge Case Failures**: %d
""" % [structure_name, 
       results["success_rate"],
       results["successful_selections"],
       results["total_attempts"],
       results["difficulty_score"],
       results["difficulty_category"],
       results["edge_case_failures"]]
        
        # Camera breakdown
        report += "- **Camera Angle Performance**:\n"
        for camera_name in results["camera_results"]:
            var cam_data = results["camera_results"][camera_name]
            var cam_success_rate = 0.0
            if cam_data["attempts"] > 0:
                cam_success_rate = float(cam_data["successes"]) / float(cam_data["attempts"]) * 100.0
            report += "  - %s: %.1f%% (%d/%d)\n" % [camera_name, cam_success_rate, cam_data["successes"], cam_data["attempts"]]
        
        # Zoom level breakdown
        report += "- **Zoom Level Performance**:\n"
        for zoom_level in results["zoom_results"]:
            var zoom_data = results["zoom_results"][zoom_level]
            var zoom_success_rate = 0.0
            if zoom_data["attempts"] > 0:
                zoom_success_rate = float(zoom_data["successes"]) / float(zoom_data["attempts"]) * 100.0
            report += "  - %s units: %.1f%% (%d/%d)\n" % [zoom_level, zoom_success_rate, zoom_data["successes"], zoom_data["attempts"]]
        
        # Failure analysis
        if results["failure_coordinates"].size() > 0:
            report += "- **Common Failure Patterns**:\n"
            var failure_patterns = _analyze_failure_patterns(results["failure_coordinates"])
            for pattern in failure_patterns:
                report += "  - %s\n" % pattern
        
        report += "\n"
    
    # Priority recommendations
    report += """## Priority Recommendations

### Critical Issues (Difficulty Score > 70):
"""
    
    var critical_count = 0
    for struct_data in sorted_structures:
        if _test_results[struct_data["name"]]["difficulty_score"] >= 70:
            critical_count += 1
            report += "1. **%s** - %.1f%% success rate\n" % [
                struct_data["name"],
                _test_results[struct_data["name"]]["success_rate"]
            ]
            var patterns = _analyze_failure_patterns(_test_results[struct_data["name"]]["failure_coordinates"])
            for pattern in patterns:
                report += "   - %s\n" % pattern
    
    if critical_count == 0:
        report += "*No critical issues found*\n"
    
    report += "\n### High Priority Issues (Difficulty Score 50-70):\n"
    
    var high_count = 0
    for struct_data in sorted_structures:
        var score = _test_results[struct_data["name"]]["difficulty_score"]
        if score >= 50 and score < 70:
            high_count += 1
            report += "1. **%s** - %.1f%% success rate\n" % [
                struct_data["name"],
                _test_results[struct_data["name"]]["success_rate"]
            ]
    
    if high_count == 0:
        report += "*No high priority issues found*\n"
    
    # Statistical summary
    report += "\n## Statistical Summary\n\n"
    report += _generate_statistical_summary()
    
    # Save report
    _save_report(report)

func _analyze_failure_patterns(failures: Array) -> Array[String]:
    """Analyze failure coordinates to identify patterns"""
    var patterns: Array[String] = []
    
    if failures.is_empty():
        return patterns
    
    # Check for camera angle issues
    var camera_failures = {}
    var zoom_failures = {}
    var misselection_targets = {}
    
    for failure in failures:
        # Count camera angle failures
        var camera = failure.get("camera", "unknown")
        if not camera_failures.has(camera):
            camera_failures[camera] = 0
        camera_failures[camera] += 1
        
        # Count zoom level failures
        var zoom = str(failure.get("zoom", "unknown"))
        if not zoom_failures.has(zoom):
            zoom_failures[zoom] = 0
        zoom_failures[zoom] += 1
        
        # Track what was selected instead
        var selected_instead = failure.get("selected_instead", "nothing")
        if not misselection_targets.has(selected_instead):
            misselection_targets[selected_instead] = 0
        misselection_targets[selected_instead] += 1
    
    # Identify patterns
    for camera in camera_failures:
        if camera_failures[camera] >= 3:
            patterns.append("High failure rate from %s view (%d failures)" % [camera, camera_failures[camera]])
    
    for zoom in zoom_failures:
        if zoom_failures[zoom] >= 3:
            patterns.append("Difficult to select at %s unit distance (%d failures)" % [zoom, zoom_failures[zoom]])
    
    for target in misselection_targets:
        if target != "nothing" and misselection_targets[target] >= 2:
            patterns.append("Often misselects '%s' instead (%d times)" % [target, misselection_targets[target]])
    
    return patterns

func _calculate_total_attempts() -> int:
    """Calculate total number of selection attempts"""
    var total = 0
    for structure_name in _test_results:
        total += _test_results[structure_name]["total_attempts"]
    return total

func _calculate_overall_success_rate() -> float:
    """Calculate overall success rate across all structures"""
    var total_attempts = 0
    var total_successes = 0
    
    for structure_name in _test_results:
        total_attempts += _test_results[structure_name]["total_attempts"]
        total_successes += _test_results[structure_name]["successful_selections"]
    
    if total_attempts == 0:
        return 0.0
    
    return float(total_successes) / float(total_attempts) * 100.0

func _generate_statistical_summary() -> String:
    """Generate statistical summary of results"""
    var summary = ""
    
    # Calculate statistics
    var success_rates = []
    var difficulty_scores = []
    
    for structure_name in _test_results:
        success_rates.append(_test_results[structure_name]["success_rate"])
        difficulty_scores.append(_test_results[structure_name]["difficulty_score"])
    
    if success_rates.is_empty():
        return "No data available for statistical analysis\n"
    
    # Sort for median calculation
    success_rates.sort()
    difficulty_scores.sort()
    
    # Calculate mean
    var mean_success = 0.0
    var mean_difficulty = 0.0
    for i in range(success_rates.size()):
        mean_success += success_rates[i]
        mean_difficulty += difficulty_scores[i]
    mean_success /= success_rates.size()
    mean_difficulty /= difficulty_scores.size()
    
    # Calculate median
    var median_success = success_rates[int(success_rates.size() / 2.0)]
    var median_difficulty = difficulty_scores[int(difficulty_scores.size() / 2.0)]
    
    # Calculate standard deviation
    var variance_success = 0.0
    var variance_difficulty = 0.0
    for i in range(success_rates.size()):
        variance_success += pow(success_rates[i] - mean_success, 2)
        variance_difficulty += pow(difficulty_scores[i] - mean_difficulty, 2)
    variance_success /= success_rates.size()
    variance_difficulty /= difficulty_scores.size()
    
    var std_dev_success = sqrt(variance_success)
    var std_dev_difficulty = sqrt(variance_difficulty)
    
    summary += """- **Success Rate Statistics**:
  - Mean: %.1f%%
  - Median: %.1f%%
  - Std Dev: %.1f%%
  - Range: %.1f%% - %.1f%%

- **Difficulty Score Statistics**:
  - Mean: %.1f
  - Median: %.1f
  - Std Dev: %.1f
  - Range: %.1f - %.1f

- **Distribution**:
  - Very Easy (0-10): %d structures
  - Easy (10-30): %d structures
  - Medium (30-50): %d structures
  - Hard (50-70): %d structures
  - Very Hard (70-100): %d structures
""" % [mean_success, median_success, std_dev_success, success_rates[0], success_rates[-1],
       mean_difficulty, median_difficulty, std_dev_difficulty, difficulty_scores[0], difficulty_scores[-1],
       _count_difficulty_category("VERY_EASY"),
       _count_difficulty_category("EASY"),
       _count_difficulty_category("MEDIUM"),
       _count_difficulty_category("HARD"),
       _count_difficulty_category("VERY_HARD")]
    
    return summary

func _count_difficulty_category(category: String) -> int:
    """Count structures in a difficulty category"""
    var count = 0
    for structure_name in _test_results:
        if _test_results[structure_name].get("difficulty_category", "") == category:
            count += 1
    return count

func _save_report(report_content: String) -> void:
    """Save the report to file"""
    var timestamp = Time.get_datetime_string_from_system().replace(" ", "_").replace(":", "-")
    var file_path = "user://selection_reliability_report_%s.md" % timestamp
    
    var file = FileAccess.open(file_path, FileAccess.WRITE)
    if file:
        file.store_string(report_content)
        file.close()
        print("[SelectionTest] Report saved to: %s" % file_path)
        
        # Also save to project directory for easy access
        var project_file_path = "res://test_reports/selection_reliability_%s.md" % timestamp
        var project_file = FileAccess.open(project_file_path, FileAccess.WRITE)
        if project_file:
            project_file.store_string(report_content)
            project_file.close()
            print("[SelectionTest] Report also saved to: %s" % project_file_path)
    else:
        push_error("[SelectionTest] Failed to save report")

# === SIGNAL HANDLERS ===
func _on_structure_selected(structure_name: String, _mesh: MeshInstance3D) -> void:
    """Handle structure selection during testing"""
    _selection_success = true
    _last_selected_structure = structure_name