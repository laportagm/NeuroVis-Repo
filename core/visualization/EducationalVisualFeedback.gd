## EducationalVisualFeedback.gd
## Comprehensive visual feedback system for educational 3D structure interaction
##
## This system provides clear, accessible visual feedback for hoverable and
## selected structures while maintaining educational appropriateness and
## supporting colorblind users.
##
## @tutorial: Visual Feedback Design for Educational Applications
## @version: 1.0

class_name EducationalVisualFeedback
extends Node

# === CONSTANTS ===
# Colorblind-friendly color schemes (Deuteranope/Protanope/Tritanope safe)
const COLOR_SCHEMES: Dictionary = {
    "default": {
        "hover": Color("#00D9FF"),      # Cyan (high contrast)
        "selected": Color("#FFD700"),    # Gold (distinct from hover)
        "related": Color("#FF6B6B"),     # Coral (for connected structures)
        "outline": Color("#FFFFFF"),     # White outline for clarity
        "error": Color("#FF4757")        # Red for errors
    },
    "deuteranope": {  # Red-green colorblind (most common)
        "hover": Color("#0099FF"),       # Blue
        "selected": Color("#FFD700"),    # Gold  
        "related": Color("#FF6B6B"),     # Orange-red
        "outline": Color("#FFFFFF"),
        "error": Color("#FF4757")
    },
    "protanope": {    # Red-green colorblind
        "hover": Color("#0099FF"),       # Blue
        "selected": Color("#FFD700"),    # Gold
        "related": Color("#FF9500"),     # Orange
        "outline": Color("#FFFFFF"),
        "error": Color("#D63031")
    },
    "tritanope": {    # Blue-yellow colorblind (rare)
        "hover": Color("#00CEC9"),       # Teal
        "selected": Color("#FF6B6B"),    # Coral
        "related": Color("#A29BFE"),     # Purple
        "outline": Color("#FFFFFF"),
        "error": Color("#FF4757")
    },
    "monochrome": {   # High contrast for low vision
        "hover": Color("#FFFFFF"),       # White
        "selected": Color("#FFD700"),    # Gold
        "related": Color("#C0C0C0"),     # Silver
        "outline": Color("#000000"),     # Black
        "error": Color("#FF0000")
    }
}

# Animation timing constants
const HOVER_FADE_TIME: float = 0.2
const SELECTION_PULSE_TIME: float = 0.3
const OUTLINE_THICKNESS: float = 0.015
const HOVER_INTENSITY_MIN: float = 0.3
const HOVER_INTENSITY_MAX: float = 0.7

# === CONFIGURATION ===
@export_group("Visual Feedback Settings")
@export var color_scheme: String = "default"
@export_range(0.0, 1.0) var feedback_intensity: float = 0.7
@export var enable_animations: bool = true
@export var enable_outline: bool = true
@export var enable_depth_fade: bool = true
@export_range(0.5, 2.0) var animation_speed: float = 1.0

@export_group("Accessibility")
@export var high_contrast_mode: bool = false
@export var reduce_motion: bool = false
@export var enhanced_outlines: bool = false

# === PRIVATE VARIABLES ===
var _current_colors: Dictionary = {}
var _material_cache: Dictionary = {}  # Cache materials for performance
var _shader_cache: Dictionary = {}    # Cache compiled shaders
var _active_tweens: Dictionary = {}   # Track active animations

# === SIGNALS ===
signal visual_feedback_applied(mesh: MeshInstance3D, state: String)
signal color_scheme_changed(new_scheme: String)

# === INITIALIZATION ===
func _ready() -> void:
    """Initialize visual feedback system"""
    _load_color_scheme(color_scheme)
    _precompile_shaders()
    
    # Connect to accessibility settings if available
    if has_node("/root/AccessibilityManager"):
        var accessibility = get_node("/root/AccessibilityManager")
        accessibility.colorblind_mode_changed.connect(_on_colorblind_mode_changed)
        accessibility.reduce_motion_changed.connect(_on_reduce_motion_changed)

# === PUBLIC METHODS ===
## Apply hover visual feedback with accessibility considerations
func apply_hover_feedback(mesh: MeshInstance3D, original_material: Material = null) -> void:
    """Apply educational hover effect with smooth transitions"""
    if not mesh or not mesh.mesh:
        return
    
    # Get or create hover material
    var hover_mat = _get_or_create_hover_material(mesh, original_material)
    
    # Apply material with smooth transition
    if enable_animations and not reduce_motion:
        _animate_material_transition(mesh, hover_mat, HOVER_FADE_TIME)
    else:
        _apply_material_instant(mesh, hover_mat)
    
    # Add outline for better visibility
    if enable_outline:
        _add_outline_effect(mesh, _current_colors["outline"])
    
    # Add subtle animation
    if enable_animations and not reduce_motion:
        _add_hover_animation(mesh)
    
    visual_feedback_applied.emit(mesh, "hover")

## Apply selection visual feedback
func apply_selection_feedback(mesh: MeshInstance3D, original_material: Material = null) -> void:
    """Apply educational selection effect with clear indication"""
    if not mesh or not mesh.mesh:
        return
    
    # Get or create selection material
    var select_mat = _get_or_create_selection_material(mesh, original_material)
    
    # Apply with animation
    if enable_animations and not reduce_motion:
        _animate_material_transition(mesh, select_mat, SELECTION_PULSE_TIME)
        _add_selection_pulse(mesh)
    else:
        _apply_material_instant(mesh, select_mat)
    
    # Enhanced outline for selection
    if enable_outline:
        var outline_color = _current_colors["outline"]
        if enhanced_outlines:
            _add_outline_effect(mesh, outline_color, OUTLINE_THICKNESS * 1.5)
        else:
            _add_outline_effect(mesh, outline_color)
    
    visual_feedback_applied.emit(mesh, "selected")

## Apply related structure feedback (for connected anatomy)
func apply_related_feedback(mesh: MeshInstance3D, original_material: Material = null) -> void:
    """Apply subtle feedback for related structures"""
    if not mesh or not mesh.mesh:
        return
    
    var related_mat = _get_or_create_related_material(mesh, original_material)
    
    if enable_animations and not reduce_motion:
        _animate_material_transition(mesh, related_mat, HOVER_FADE_TIME * 1.5)
    else:
        _apply_material_instant(mesh, related_mat)
    
    visual_feedback_applied.emit(mesh, "related")

## Clear all visual feedback
func clear_feedback(mesh: MeshInstance3D, original_material: Material) -> void:
    """Clear all visual feedback with smooth transition"""
    if not mesh:
        return
    
    # Stop any active animations
    _stop_mesh_animations(mesh)
    
    # Remove outline
    _remove_outline_effect(mesh)
    
    # Restore original material
    if enable_animations and not reduce_motion:
        _animate_material_transition(mesh, original_material, HOVER_FADE_TIME)
    else:
        _apply_material_instant(mesh, original_material)

## Change color scheme (for accessibility)
func set_color_scheme(scheme_name: String) -> void:
    """Change the active color scheme"""
    if COLOR_SCHEMES.has(scheme_name):
        color_scheme = scheme_name
        _load_color_scheme(scheme_name)
        _invalidate_material_cache()
        color_scheme_changed.emit(scheme_name)

## Adjust feedback intensity
func set_feedback_intensity(intensity: float) -> void:
    """Adjust the intensity of visual feedback (0.0 - 1.0)"""
    feedback_intensity = clamp(intensity, 0.0, 1.0)
    _invalidate_material_cache()

## Get current accessibility settings
func get_accessibility_info() -> Dictionary:
    """Return current accessibility configuration"""
    return {
        "color_scheme": color_scheme,
        "feedback_intensity": feedback_intensity,
        "high_contrast": high_contrast_mode,
        "reduce_motion": reduce_motion,
        "enhanced_outlines": enhanced_outlines,
        "colors": _current_colors
    }

# === PRIVATE METHODS ===
func _load_color_scheme(scheme_name: String) -> void:
    """Load a color scheme from presets"""
    if COLOR_SCHEMES.has(scheme_name):
        _current_colors = COLOR_SCHEMES[scheme_name].duplicate()
        
        # Apply high contrast modifications if enabled
        if high_contrast_mode:
            for key in _current_colors:
                var color = _current_colors[key]
                # Increase saturation and value for better contrast
                color.s = min(color.s * 1.3, 1.0)
                color.v = min(color.v * 1.2, 1.0)
                _current_colors[key] = color

func _get_or_create_hover_material(mesh: MeshInstance3D, _base_material: Material) -> Material:
    """Create or retrieve cached hover material"""
    var cache_key = "hover_%s_%s" % [mesh.get_instance_id(), feedback_intensity]
    
    if _material_cache.has(cache_key):
        return _material_cache[cache_key]
    
    # Create new hover material
    var hover_mat = StandardMaterial3D.new()
    
    # Base color with transparency
    var base_color = _current_colors["hover"]
    hover_mat.albedo_color = Color(base_color.r, base_color.g, base_color.b, 0.8)
    
    # Emission for visibility
    hover_mat.emission_enabled = true
    hover_mat.emission = base_color
    hover_mat.emission_energy_multiplier = feedback_intensity * 0.5
    
    # Rim lighting for edge visibility
    hover_mat.rim_enabled = true
    hover_mat.rim = 0.8
    hover_mat.rim_tint = 0.5
    
    # Transparency for educational clarity
    hover_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    hover_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
    
    # Depth fade for overlapping structures
    if enable_depth_fade:
        hover_mat.distance_fade_mode = BaseMaterial3D.DISTANCE_FADE_PIXEL_DITHER
        hover_mat.distance_fade_min_distance = 0.1
        hover_mat.distance_fade_max_distance = 10.0
    
    _material_cache[cache_key] = hover_mat
    return hover_mat

func _get_or_create_selection_material(mesh: MeshInstance3D, _base_material: Material) -> Material:
    """Create or retrieve cached selection material"""
    var cache_key = "select_%s_%s" % [mesh.get_instance_id(), feedback_intensity]
    
    if _material_cache.has(cache_key):
        return _material_cache[cache_key]
    
    var select_mat = StandardMaterial3D.new()
    
    # Selection color
    var base_color = _current_colors["selected"]
    select_mat.albedo_color = base_color
    
    # Strong emission for clear selection
    select_mat.emission_enabled = true
    select_mat.emission = base_color
    select_mat.emission_energy_multiplier = feedback_intensity * 0.8
    
    # Rim for contrast
    select_mat.rim_enabled = true
    select_mat.rim = 1.0
    select_mat.rim_tint = 0.8
    
    # Slight transparency
    select_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    select_mat.albedo_color.a = 0.9
    
    _material_cache[cache_key] = select_mat
    return select_mat

func _get_or_create_related_material(mesh: MeshInstance3D, _base_material: Material) -> Material:
    """Create material for related structures"""
    var cache_key = "related_%s_%s" % [mesh.get_instance_id(), feedback_intensity]
    
    if _material_cache.has(cache_key):
        return _material_cache[cache_key]
    
    var related_mat = StandardMaterial3D.new()
    
    # Subtle indication
    var base_color = _current_colors["related"]
    related_mat.albedo_color = Color(base_color.r, base_color.g, base_color.b, 0.6)
    
    # Soft emission
    related_mat.emission_enabled = true
    related_mat.emission = base_color
    related_mat.emission_energy_multiplier = feedback_intensity * 0.3
    
    # Transparency
    related_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    
    _material_cache[cache_key] = related_mat
    return related_mat

func _add_outline_effect(_mesh: MeshInstance3D, _color: Color, _thickness: float = OUTLINE_THICKNESS) -> void:
    """Add outline effect using shader or duplicate mesh method"""
    # Implementation depends on Godot version and performance requirements
    # For now, using rim lighting as outline approximation
    pass

func _remove_outline_effect(_mesh: MeshInstance3D) -> void:
    """Remove outline effect from mesh"""
    pass

func _animate_material_transition(mesh: MeshInstance3D, target_material: Material, _duration: float) -> void:
    """Smoothly transition between materials"""
    # For now, apply instantly to avoid tween errors
    # TODO: Implement proper material transition animation
    _apply_material_instant(mesh, target_material)

func _apply_material_instant(mesh: MeshInstance3D, material: Material) -> void:
    """Apply material without animation"""
    var surface_count = mesh.mesh.get_surface_count()
    for i in range(surface_count):
        mesh.set_surface_override_material(i, material)

func _add_hover_animation(mesh: MeshInstance3D) -> void:
    """Add subtle hover animation"""
    if not enable_animations or reduce_motion:
        return
    
    var tween = mesh.create_tween()
    tween.set_loops()
    
    # Subtle scale pulse
    var original_scale = mesh.scale
    var hover_scale = original_scale * 1.02
    
    tween.tween_property(mesh, "scale", hover_scale, 0.8 / animation_speed)
    tween.tween_property(mesh, "scale", original_scale, 0.8 / animation_speed)
    
    _active_tweens["%s_hover" % mesh.get_instance_id()] = tween

func _add_selection_pulse(mesh: MeshInstance3D) -> void:
    """Add selection confirmation pulse"""
    if not enable_animations or reduce_motion:
        return
    
    var tween = mesh.create_tween()
    
    # Quick pulse
    var original_scale = mesh.scale
    tween.tween_property(mesh, "scale", original_scale * 1.1, 0.1 / animation_speed)
    tween.tween_property(mesh, "scale", original_scale, 0.2 / animation_speed)

func _stop_mesh_animations(mesh: MeshInstance3D) -> void:
    """Stop all animations for a mesh"""
    var mesh_id = mesh.get_instance_id()
    
    # Stop main tween
    if _active_tweens.has(mesh_id):
        _active_tweens[mesh_id].kill()
        _active_tweens.erase(mesh_id)
    
    # Stop hover animation
    var hover_key = "%s_hover" % mesh_id
    if _active_tweens.has(hover_key):
        _active_tweens[hover_key].kill()
        _active_tweens.erase(hover_key)
    
    # Reset scale
    mesh.scale = Vector3.ONE

func _precompile_shaders() -> void:
    """Precompile shaders for better performance"""
    # Shader compilation would happen here
    pass

func _invalidate_material_cache() -> void:
    """Clear material cache when settings change"""
    _material_cache.clear()

# === ACCESSIBILITY CALLBACKS ===
func _on_colorblind_mode_changed(mode: String) -> void:
    """Handle colorblind mode changes"""
    set_color_scheme(mode)

func _on_reduce_motion_changed(enabled: bool) -> void:
    """Handle reduce motion preference"""
    reduce_motion = enabled
    
    # Stop all active animations if motion is reduced
    if reduce_motion:
        for tween in _active_tweens.values():
            if tween and is_instance_valid(tween):
                tween.kill()
        _active_tweens.clear()

# === CLEANUP ===
func _exit_tree() -> void:
    """Clean up resources"""
    # Stop all animations
    for tween in _active_tweens.values():
        if tween and is_instance_valid(tween):
            tween.kill()
    
    _active_tweens.clear()
    _material_cache.clear()
    _shader_cache.clear()