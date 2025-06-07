# Responsive UI Component for NeuroVis
# Automatically adapts layout and styling based on screen size and orientation

class_name ResponsiveComponent
extends Control

# === RESPONSIVE SYSTEM ===

signal breakpoint_changed(old_breakpoint: String, new_breakpoint: String)
signal orientation_changed(is_portrait: bool)
signal layout_adapted(layout_name: String)

# === BREAKPOINT SYSTEM ===

enum Breakpoint { MOBILE, TABLET_PORTRAIT, TABLET_LANDSCAPE, DESKTOP, WIDE_DESKTOP }

const BREAKPOINT_WIDTHS = {
	Breakpoint.MOBILE: 480,
	Breakpoint.TABLET_PORTRAIT: 768,
	Breakpoint.TABLET_LANDSCAPE: 1024,
	Breakpoint.DESKTOP: 1440,
	Breakpoint.WIDE_DESKTOP: 1920
}

const BREAKPOINT_NAMES = {
	Breakpoint.MOBILE: "mobile",
	Breakpoint.TABLET_PORTRAIT: "tablet_portrait", 
	Breakpoint.TABLET_LANDSCAPE: "tablet_landscape",
	Breakpoint.DESKTOP: "desktop",
	Breakpoint.WIDE_DESKTOP: "wide_desktop"
}

# === RESPONSIVE CONFIGURATION ===

@export var responsive_enabled: bool = true
@export var maintain_aspect_ratio: bool = false
@export var min_width: float = 320
@export var max_width: float = 1920
@export var adaptive_typography: bool = true
@export var touch_friendly_mode: bool = false
@export var component_id: String = ""
@export var enable_logging: bool = true

# === STATE ===

var current_breakpoint: Breakpoint = Breakpoint.DESKTOP
var current_viewport_size: Vector2
var is_portrait_orientation: bool = false
var layout_configs: Dictionary = {}

	var viewport = get_viewport()
	if not viewport:
		return
	
	current_viewport_size = viewport.get_visible_rect().size
	var new_breakpoint = _calculate_breakpoint(current_viewport_size.x)
	var new_orientation = current_viewport_size.y > current_viewport_size.x
	
	# Check for breakpoint change
	if new_breakpoint != current_breakpoint:
		var old_breakpoint_name = BREAKPOINT_NAMES[current_breakpoint]
		current_breakpoint = new_breakpoint
		var new_breakpoint_name = BREAKPOINT_NAMES[current_breakpoint]
		_log("Breakpoint changed: " + old_breakpoint_name + " -> " + new_breakpoint_name)
		breakpoint_changed.emit(old_breakpoint_name, new_breakpoint_name)
	
	# Check for orientation change
	if new_orientation != is_portrait_orientation:
		is_portrait_orientation = new_orientation
		_log("Orientation changed: " + ("portrait" if is_portrait_orientation else "landscape"))
		orientation_changed.emit(is_portrait_orientation)
	
	# Apply responsive layout
	_apply_responsive_layout()

	var breakpoint_name = BREAKPOINT_NAMES[current_breakpoint]
	var layout_config = layout_configs.get(breakpoint_name, {})
	
	if layout_config.is_empty():
		return
	
	_log("Applying responsive layout: " + breakpoint_name)
	
	# Apply padding and margin
	_apply_spacing(layout_config)
	
	# Apply typography scaling
	if adaptive_typography and layout_config.has("font_scale"):
		_apply_typography_scaling(layout_config.font_scale)
	
	# Apply touch-friendly mode
	if layout_config.has("button_height"):
		_apply_touch_friendly_sizing(layout_config.button_height)
	
	# Apply positioning
	_apply_responsive_positioning(layout_config)
	
	# Apply layout structure
	_apply_layout_structure(layout_config)
	
	layout_adapted.emit(breakpoint_name)

		var padding = layout_config.padding
		if self is MarginContainer:
			add_theme_constant_override("margin_top", padding.get("top", 16))
			add_theme_constant_override("margin_bottom", padding.get("bottom", 16))
			add_theme_constant_override("margin_left", padding.get("left", 16))
			add_theme_constant_override("margin_right", padding.get("right", 16))
		elif self is PanelContainer:
			# Apply padding via custom style
			var style = StyleBoxFlat.new()
			style.bg_color = Color(0.1, 0.1, 0.15, 0.9)
			style.content_margin_top = padding.get("top", 16)
			style.content_margin_bottom = padding.get("bottom", 16)
			style.content_margin_left = padding.get("left", 16)
			style.content_margin_right = padding.get("right", 16)
			add_theme_stylebox_override("panel", style)
	
	# Spacing for container children
	if layout_config.has("spacing"):
		var spacing = layout_config.spacing
		_apply_container_spacing(spacing)

		var current_size = node.get_theme_font_size("font_size")
		if current_size <= 0:
			current_size = 14  # Default size
		node.add_theme_font_size_override("font_size", int(current_size * scale))
	elif node is Button:
		var current_size = node.get_theme_font_size("font_size")
		if current_size <= 0:
			current_size = 14
		node.add_theme_font_size_override("font_size", int(current_size * scale))
	elif node is RichTextLabel:
		var current_size = node.get_theme_font_size("normal_font_size")
		if current_size <= 0:
			current_size = 14
		node.add_theme_font_size_override("normal_font_size", int(current_size * scale))
	
	# Recursively apply to children
	for child in node.get_children():
		_apply_typography_to_children(child, scale)

	var position = layout_config.position
	var width_percent = layout_config.panel_width_percent
	
	match position:
		"right":
			anchor_left = 1.0
			anchor_right = 1.0
			anchor_top = 0.0
			anchor_bottom = 1.0
			var width = current_viewport_size.x * width_percent
			offset_left = -width - 16
			offset_right = -16
			offset_top = 16
			offset_bottom = -16
		"bottom":
			anchor_left = 0.0
			anchor_right = 1.0
			anchor_top = 1.0
			anchor_bottom = 1.0
			var height = current_viewport_size.y * 0.5
			offset_left = 16
			offset_right = -16
			offset_top = -height - 16
			offset_bottom = -16

	var should_stack_vertical = layout_config.stack_vertical
	_apply_stacking_to_children(self, should_stack_vertical)

	var parent = container.get_parent()
	if not parent:
		return
	
	var children = container.get_children()
	var container_index = container.get_index()
	
	# Create new container
	var new_container = VBoxContainer.new() if to_vertical else HBoxContainer.new()
	new_container.name = container.name
	new_container.size_flags_horizontal = container.size_flags_horizontal
	new_container.size_flags_vertical = container.size_flags_vertical
	
	# Move children
	for child in children:
		container.remove_child(child)
		new_container.add_child(child)
	
	# Replace container
	parent.remove_child(container)
	parent.add_child(new_container)
	parent.move_child(new_container, container_index)
	container.queue_free()

# === EVENT HANDLERS ===
	var prefix = "[ResponsiveComponent:" + component_id + "] "
	match level:
		"error":
			push_error(prefix + message)
		"warning":
			push_warning(prefix + message)
		_:
			print(prefix + message)

func _ready() -> void:
	"""Setup responsive system"""
	# Set component ID if not provided
	if component_id.is_empty():
		component_id = get_class() + "_" + str(get_instance_id())
	
	# Setup responsive layouts
	_setup_responsive_layouts()
	
	# Initial responsive adaptation
	call_deferred("_adapt_to_viewport")
	
	# Connect to viewport changes
	if get_viewport():
		get_viewport().size_changed.connect(_on_viewport_changed)

func set_responsive_enabled(enabled: bool) -> void:
	"""Enable/disable responsive behavior"""
	responsive_enabled = enabled
	if enabled:
		_adapt_to_viewport()

func get_current_breakpoint() -> String:
	"""Get current breakpoint name"""
	return BREAKPOINT_NAMES[current_breakpoint]

func get_current_breakpoint_enum() -> Breakpoint:
	"""Get current breakpoint enum"""
	return current_breakpoint

func is_mobile_size() -> bool:
	"""Check if current size is mobile"""
	return current_breakpoint == Breakpoint.MOBILE

func is_tablet_size() -> bool:
	"""Check if current size is tablet"""
	return current_breakpoint in [Breakpoint.TABLET_PORTRAIT, Breakpoint.TABLET_LANDSCAPE]

func is_desktop_size() -> bool:
	"""Check if current size is desktop"""
	return current_breakpoint in [Breakpoint.DESKTOP, Breakpoint.WIDE_DESKTOP]

func set_custom_layout_config(breakpoint: String, config: Dictionary) -> void:
	"""Set custom layout configuration for a breakpoint"""
	layout_configs[breakpoint] = config
	if get_current_breakpoint() == breakpoint:
		_apply_responsive_layout()

func get_layout_config(breakpoint: String = "") -> Dictionary:
	"""Get layout configuration for breakpoint"""
	if breakpoint.is_empty():
		breakpoint = get_current_breakpoint()
	return layout_configs.get(breakpoint, {})

func force_breakpoint(breakpoint: String) -> void:
	"""Force a specific breakpoint for testing"""
	if breakpoint in BREAKPOINT_NAMES.values():
		for bp in BREAKPOINT_NAMES:
			if BREAKPOINT_NAMES[bp] == breakpoint:
				current_breakpoint = bp
				_apply_responsive_layout()
				break

# === UTILITY METHODS ===

func _setup_responsive_layouts() -> void:
	"""Setup layout configurations for different breakpoints"""
	layout_configs = {
		"mobile": {
			"padding": {"top": 8, "bottom": 8, "left": 8, "right": 8},
			"margin": {"top": 4, "bottom": 4, "left": 4, "right": 4},
			"font_scale": 0.9,
			"spacing": 8,
			"button_height": 44,  # Touch-friendly
			"panel_width_percent": 0.95,
			"position": "bottom",
			"stack_vertical": true
		},
		"tablet_portrait": {
			"padding": {"top": 12, "bottom": 12, "left": 12, "right": 12},
			"margin": {"top": 8, "bottom": 8, "left": 8, "right": 8},
			"font_scale": 1.0,
			"spacing": 12,
			"button_height": 40,
			"panel_width_percent": 0.6,
			"position": "right",
			"stack_vertical": false
		},
		"tablet_landscape": {
			"padding": {"top": 16, "bottom": 16, "left": 16, "right": 16},
			"margin": {"top": 12, "bottom": 12, "left": 12, "right": 12},
			"font_scale": 1.1,
			"spacing": 16,
			"button_height": 36,
			"panel_width_percent": 0.4,
			"position": "right",
			"stack_vertical": false
		},
		"desktop": {
			"padding": {"top": 20, "bottom": 20, "left": 20, "right": 20},
			"margin": {"top": 16, "bottom": 16, "left": 16, "right": 16},
			"font_scale": 1.0,
			"spacing": 20,
			"button_height": 32,
			"panel_width_percent": 0.3,
			"position": "right",
			"stack_vertical": false
		},
		"wide_desktop": {
			"padding": {"top": 24, "bottom": 24, "left": 24, "right": 24},
			"margin": {"top": 20, "bottom": 20, "left": 20, "right": 20},
			"font_scale": 1.2,
			"spacing": 24,
			"button_height": 36,
			"panel_width_percent": 0.25,
			"position": "right",
			"stack_vertical": false
		}
	}

func _adapt_to_viewport() -> void:
	"""Adapt component to current viewport size"""
	if not responsive_enabled:
		return
	
func _calculate_breakpoint(width: float) -> Breakpoint:
	"""Calculate breakpoint based on width"""
	if width < BREAKPOINT_WIDTHS[Breakpoint.MOBILE]:
		return Breakpoint.MOBILE
	elif width < BREAKPOINT_WIDTHS[Breakpoint.TABLET_PORTRAIT]:
		return Breakpoint.MOBILE
	elif width < BREAKPOINT_WIDTHS[Breakpoint.TABLET_LANDSCAPE]:
		return Breakpoint.TABLET_PORTRAIT
	elif width < BREAKPOINT_WIDTHS[Breakpoint.DESKTOP]:
		return Breakpoint.TABLET_LANDSCAPE
	elif width < BREAKPOINT_WIDTHS[Breakpoint.WIDE_DESKTOP]:
		return Breakpoint.DESKTOP
	else:
		return Breakpoint.WIDE_DESKTOP

func _apply_responsive_layout() -> void:
	"""Apply layout for current breakpoint"""
func _apply_spacing(layout_config: Dictionary) -> void:
	"""Apply responsive spacing"""
	# Padding
	if layout_config.has("padding"):
func _apply_container_spacing(spacing: int) -> void:
	"""Apply spacing to container children"""
	for child in get_children():
		if child is VBoxContainer:
			child.add_theme_constant_override("separation", spacing)
		elif child is HBoxContainer:
			child.add_theme_constant_override("separation", spacing)
		elif child is GridContainer:
			child.add_theme_constant_override("h_separation", spacing)
			child.add_theme_constant_override("v_separation", spacing)

func _apply_typography_scaling(font_scale: float) -> void:
	"""Apply typography scaling"""
	_apply_typography_to_children(self, font_scale)

func _apply_typography_to_children(node: Node, scale: float) -> void:
	"""Recursively apply typography scaling"""
	if node is Label:
func _apply_touch_friendly_sizing(button_height: int) -> void:
	"""Apply touch-friendly sizing"""
	_apply_touch_sizing_to_children(self, button_height)

func _apply_touch_sizing_to_children(node: Node, button_height: int) -> void:
	"""Recursively apply touch-friendly sizing"""
	if node is Button:
		node.custom_minimum_size.y = button_height
	elif node is LineEdit:
		node.custom_minimum_size.y = button_height
	elif node is OptionButton:
		node.custom_minimum_size.y = button_height
	
	# Recursively apply to children
	for child in node.get_children():
		_apply_touch_sizing_to_children(child, button_height)

func _apply_responsive_positioning(layout_config: Dictionary) -> void:
	"""Apply responsive positioning"""
	if not layout_config.has("position") or not layout_config.has("panel_width_percent"):
		return
	
func _apply_layout_structure(layout_config: Dictionary) -> void:
	"""Apply layout structure changes"""
	if not layout_config.has("stack_vertical"):
		return
	
func _apply_stacking_to_children(node: Node, vertical: bool) -> void:
	"""Apply vertical/horizontal stacking"""
	for child in node.get_children():
		if child is HBoxContainer and vertical:
			# Convert HBox to VBox
			_convert_container_orientation(child, true)
		elif child is VBoxContainer and not vertical:
			# Convert VBox to HBox
			_convert_container_orientation(child, false)
		
		# Recursively apply to children
		_apply_stacking_to_children(child, vertical)

func _convert_container_orientation(container: Container, to_vertical: bool) -> void:
	"""Convert container orientation"""
func _on_viewport_changed() -> void:
	"""Handle viewport size change"""
	call_deferred("_adapt_to_viewport")

func _handle_resize() -> void:
	"""Handle component resize"""
	_adapt_to_viewport()

# === PUBLIC API ===
func _log(message: String, level: String = "info") -> void:
	"""Component logging"""
	if not enable_logging:
		return
	
