# InfoPanelComponent - New modular info panel using foundation architecture
# Modern, composable panel with state persistence and performance optimization

class_name InfoPanelComponent
extends Control

# === DEPENDENCIES ===

signal panel_closed
signal section_toggled(section_name: String, expanded: bool)
signal action_triggered(action: String, data: Dictionary)
signal state_changed(state_data: Dictionary)

# === COMPONENT STATE ===

enum PanelState { INITIALIZING, READY, DISPLAYING, ANIMATING, CLOSING }

const FeatureFlags = preprepreload("res://core/features/FeatureFlags.gd")
const ComponentRegistry = preprepreload("res://ui/core/ComponentRegistry.gd")
const ComponentStateManager = preprepreload("res://ui/state/ComponentStateManager.gd")
const UIThemeManager = preprepreload("res://ui/panels/UIThemeManager.gd")
const StyleEngine = preprepreload("res://ui/theme/StyleEngine.gd")
const AdvancedInteractionSystem = preprepreload("res://core/interaction/AdvancedInteractionSystem.gd")

# === SIGNALS ===

var current_state: PanelState = PanelState.INITIALIZING

# === CONFIGURATION ===
var component_config: Dictionary = {}
var structure_data: Dictionary = {}
var panel_theme: String = "enhanced"
var component_id: String = ""

# === UI FRAGMENTS ===
var header_fragment: Control
var content_fragment: Control
var actions_fragment: Control

# === LAYOUT CONTAINERS ===
var main_container: VBoxContainer
var scroll_container: ScrollContainer

# === USER STATE ===
var section_states: Dictionary = {
	"description": true, "functions": true, "connections": false, "clinical": false  # Always visible  # Default expanded  # Default collapsed  # Default collapsed
}
var scroll_position: float = 0.0
var user_notes: String = ""
var is_bookmarked: bool = false

# === RESPONSIVE DATA ===
var viewport_size: Vector2
var is_mobile_layout: bool = false


	var gesture_mappings = {
		"swipe_up": "expand_all_sections",
		"swipe_down": "collapse_all_sections",
		"swipe_left": "previous_structure",
		"swipe_right": "next_structure",
		"pinch_zoom": "zoom_content",
		"long_press": "show_context_menu"
	}

	set_meta("gesture_mappings", gesture_mappings)


# === PUBLIC API ===
		var theme_value = config.theme
		if theme_value is String:
			panel_theme = theme_value
		elif theme_value is int:
			# Handle enum values - convert to string
			match theme_value:
				0:
					panel_theme = "enhanced"
				1:
					panel_theme = "minimal"
				_:
					panel_theme = "enhanced"  # Default fallback
		else:
			panel_theme = str(theme_value)  # Convert to string as fallback
		_apply_theme()

	if config.has("position"):
		_apply_positioning(config.position)

	# Restore state if persistence enabled
	if FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE):
		_restore_component_state()


	var structure_name = structure_data.get(
		"displayName", structure_data.get("name", "Unknown Structure")
	)
	if header_fragment and header_fragment.has_method("set_title"):
		header_fragment.set_title(structure_name)

	# Update content with structure data
	if content_fragment and content_fragment.has_method("display_structure_data"):
		content_fragment.display_structure_data(structure_data)

	# Update bookmark state
	if header_fragment and header_fragment.has_method("set_bookmark_state"):
		header_fragment.set_bookmark_state(is_bookmarked)

	# Save state change
	if FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE):
		_save_component_state()

	# Animate entrance if supported
	if FeatureFlags.is_enabled(FeatureFlags.ADVANCED_ANIMATIONS):
		UIThemeManager.animate_enhanced_entrance(self, 0.1)

	# Show panel
	show_panel()

	if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
		print("[InfoPanelComponent] Displayed info for: %s" % structure_name)


	var responsive_config = {"is_mobile": is_mobile_layout, "viewport_size": viewport_size}

	if header_fragment and header_fragment.has_method("update_responsive_config"):
		header_fragment.update_responsive_config(responsive_config)

	if content_fragment and content_fragment.has_method("update_responsive_config"):
		content_fragment.update_responsive_config(responsive_config)

	if actions_fragment and actions_fragment.has_method("update_responsive_config"):
		actions_fragment.update_responsive_config(responsive_config)


	var style_config = {
		"type": "panel",
		"variant": "primary" if panel_theme == "enhanced" else "minimal",
		"educational": true,
		"responsive": true
	}

	StyleEngine.apply_component_style(self, style_config)

	# Apply responsive sizing
	var responsive_size = StyleEngine.get_responsive_size(Vector2(320, 400))
	custom_minimum_size = responsive_size

	# Apply educational color scheme
	var bg_color = StyleEngine.get_color("surface")
	var border_color = StyleEngine.get_color("primary")

	# Create stylized background if supported
	if has_method("add_theme_color_override"):
		add_theme_color_override("bg_color", bg_color)
		add_theme_color_override("border_color", border_color)


	var state = get_state()
	ComponentStateManager.save_component_state(component_id, state)
	state_changed.emit(state)


	var state = ComponentStateManager.restore_component_state(component_id)
	if not state.is_empty():
		restore_state(state)


		var hover_tween = StyleEngine.create_scale_animation(
			self, Vector2.ONE, Vector2.ONE * 1.02, StyleEngine.get_animation_duration("micro")
		)
		hover_tween.play()


		var exit_tween = StyleEngine.create_scale_animation(
			self, scale, Vector2.ONE, StyleEngine.get_animation_duration("micro")
		)
		exit_tween.play()


	var gesture_mappings = get_meta("gesture_mappings", {})
	var action = gesture_mappings.get(gesture_name, "")

	if action == "":
		return

	match action:
		"expand_all_sections":
			_expand_all_sections()
		"collapse_all_sections":
			_collapse_all_sections()
		"previous_structure":
			action_triggered.emit("navigate_previous", {})
		"next_structure":
			action_triggered.emit("navigate_next", {})
		"zoom_content":
			_toggle_zoom_mode()
		"show_context_menu":
			action_triggered.emit("show_context_menu", {"source": "gesture"})


		var expand_tween = StyleEngine.create_scale_animation(
			content_fragment if content_fragment else self,
			Vector2(1.0, 0.8),
			Vector2.ONE,
			StyleEngine.get_animation_duration("educational")
		)
		expand_tween.play()


	var is_zoomed = get_meta("is_zoomed", false)
	var target_scale = Vector2(1.2, 1.2) if not is_zoomed else Vector2.ONE

	set_meta("is_zoomed", not is_zoomed)

	var zoom_tween = StyleEngine.create_scale_animation(
		self, scale, target_scale, StyleEngine.get_animation_duration("medium")
	)
	zoom_tween.play()


# === COMPONENT LIFECYCLE ===
	var panel = InfoPanelComponent.new()
	panel.configure(config)
	return panel

func _ready() -> void:
	_initialize_component()


func _initialize_component() -> void:
	"""Initialize the modern info panel component"""
	current_state = PanelState.INITIALIZING

	# Set component metadata
	set_meta("component_type", "info_panel")
	set_meta("creation_time", Time.get_unix_time_from_system())

	# Create component structure
	_setup_layout()
	_create_ui_fragments()
	_setup_responsive_behavior()
	_setup_interactions()

	current_state = PanelState.READY

	if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
		print("[InfoPanelComponent] Initialized with ID: %s" % component_id)


func _unhandled_input(event: InputEvent) -> void:
	"""Handle keyboard shortcuts"""
	if not visible or current_state != PanelState.DISPLAYING:
		return

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ESCAPE:
				hide_panel()
				get_viewport().set_input_as_handled()
			KEY_B:
				if event.meta_pressed or event.ctrl_pressed:
					_on_header_action("bookmark")
					get_viewport().set_input_as_handled()


# === ADVANCED INTERACTION HANDLERS ===
func _exit_tree() -> void:
	"""Clean up component resources"""
	# Save final state
	if FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE) and component_id != "":
		_save_component_state()

	# Disconnect viewport signals
	if get_viewport() and get_viewport().size_changed.is_connected(_on_viewport_size_changed):
		get_viewport().size_changed.disconnect(_on_viewport_size_changed)


# === STATIC FACTORY METHOD ===
static func create_with_config(config: Dictionary) -> InfoPanelComponent:
	"""Static factory method for creating configured panels"""

func configure(config: Dictionary) -> void:
	"""Configure the component with new settings"""
	component_config = config.duplicate()
	component_id = config.get("component_id", "info_panel_default")

	# Extract configuration
	if config.has("structure_data"):
		display_structure_info(config.structure_data)

	if config.has("theme"):
func display_structure_info(structure_info: Dictionary) -> void:
	"""Display information for a brain structure"""
	current_state = PanelState.DISPLAYING
	structure_data = structure_info.duplicate()

	# Update header with structure name
func show_panel() -> void:
	"""Show the panel with animation"""
	if current_state == PanelState.DISPLAYING:
		visible = true

		# Apply entrance animation
		if FeatureFlags.is_enabled(FeatureFlags.ADVANCED_ANIMATIONS):
			UIThemeManager.animate_enhanced_entrance(self)


func hide_panel() -> void:
	"""Hide the panel with animation"""
	current_state = PanelState.CLOSING

	# Save state before hiding
	if FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE):
		_save_component_state()

	# Apply exit animation
	if FeatureFlags.is_enabled(FeatureFlags.ADVANCED_ANIMATIONS):
		UIThemeManager.animate_exit(self, UIThemeManager.get_animation_duration("exit_duration"))
	else:
		visible = false
		panel_closed.emit()


func get_state() -> Dictionary:
	"""Get current component state for persistence"""
	return {
		"structure_data": structure_data,
		"section_states": section_states,
		"scroll_position": scroll_container.scroll_vertical if scroll_container else 0,
		"user_notes": user_notes,
		"is_bookmarked": is_bookmarked,
		"panel_theme": panel_theme,
		"viewport_size": viewport_size,
		"component_config": component_config
	}


func restore_state(state: Dictionary) -> void:
	"""Restore component state from persistence"""
	if state.has("section_states"):
		section_states = state.section_states

		# Update content fragment with restored states
		if content_fragment and content_fragment.has_method("restore_section_states"):
			content_fragment.restore_section_states(section_states)

	if state.has("scroll_position") and scroll_container:
		# Restore scroll position after a frame to ensure content is loaded
		call_deferred("_restore_scroll_position", state.scroll_position)

	if state.has("user_notes"):
		user_notes = state.user_notes

	if state.has("is_bookmarked"):
		is_bookmarked = state.is_bookmarked
		if header_fragment and header_fragment.has_method("set_bookmark_state"):
			header_fragment.set_bookmark_state(is_bookmarked)

	if state.has("panel_theme"):
		panel_theme = state.panel_theme
		_apply_theme()


# === PRIVATE METHODS ===

func _setup_layout() -> void:
	"""Setup the main layout structure"""

	# Apply base styling
	UIThemeManager.apply_enhanced_panel_style(self, "elevated")

	# Set minimum size and layout
	custom_minimum_size = Vector2(320, 400)

	# Main container
	main_container = VBoxContainer.new()
	main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_container.add_theme_constant_override(
		"separation", UIThemeManager.get_spacing("enhanced_section_gap")
	)
	add_child(main_container)

	# Scroll container for content
	scroll_container = ScrollContainer.new()
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_container.add_child(scroll_container)

	# Content will be added to scroll container


func _create_ui_fragments() -> void:
	"""Create UI fragments using component registry"""

	# Create header fragment
	header_fragment = ComponentRegistry.create_component(
		"header",
		{
			"title": "Structure Information",
			"actions": ["bookmark", "share", "close"],
			"closeable": true
		}
	)

	if header_fragment:
		main_container.add_child(header_fragment)
		main_container.move_child(header_fragment, 0)  # Header first

	# Create content fragment
	content_fragment = ComponentRegistry.create_component(
		"content",
		{
			"sections": ["description", "functions", "connections", "clinical"],
			"collapsible_sections": ["functions", "connections", "clinical"],
			"section_states": section_states
		}
	)

	if content_fragment:
		scroll_container.add_child(content_fragment)

	# Create actions fragment
	actions_fragment = ComponentRegistry.create_component(
		"actions",
		{
			"buttons":
			[
				{"text": "Study Notes", "action": "notes", "icon": "📝"},
				{"text": "Related", "action": "related", "icon": "🔗"},
				{"text": "Quiz", "action": "quiz", "icon": "🧠"}
			]
		}
	)

	if actions_fragment:
		main_container.add_child(actions_fragment)


func _setup_responsive_behavior() -> void:
	"""Setup responsive behavior for different screen sizes"""
	viewport_size = get_viewport().get_visible_rect().size
	_update_responsive_layout()

	# Connect to viewport changes
	get_viewport().size_changed.connect(_on_viewport_size_changed)


func _setup_interactions() -> void:
	"""Setup component interactions and signal connections"""

	# Connect header signals
	if header_fragment and header_fragment.has_signal("action_triggered"):
		header_fragment.action_triggered.connect(_on_header_action)

	# Connect content signals
	if content_fragment:
		if content_fragment.has_signal("section_toggled"):
			content_fragment.section_toggled.connect(_on_content_section_toggled)
		if content_fragment.has_signal("content_changed"):
			content_fragment.content_changed.connect(_on_content_changed)

	# Connect actions signals
	if actions_fragment and actions_fragment.has_signal("action_triggered"):
		actions_fragment.action_triggered.connect(_on_actions_triggered)

	# Setup advanced interactions if enabled
	if FeatureFlags.is_enabled(FeatureFlags.UI_ADVANCED_INTERACTIONS):
		_setup_advanced_interactions()

	# Setup keyboard shortcuts
	set_process_unhandled_input(true)


func _setup_advanced_interactions() -> void:
	"""Setup advanced interaction features"""
	# Enable drag and drop for panel repositioning
	set_meta("draggable", true)
	set_meta("drag_type", "panel")
	set_meta("drag_data", {"panel_id": component_id, "type": "info_panel"})

	# Enable context menu
	set_meta("context_menu_enabled", true)
	set_meta("panel_type", "info_panel")

	# Connect to mouse events for advanced interactions
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	# Setup gesture recognition for touch devices
	if StyleEngine.is_mobile_layout():
		_setup_touch_gestures()


func _setup_touch_gestures() -> void:
	"""Setup touch gesture support"""
	# Enable touch gesture recognition
	set_meta("gesture_enabled", true)

	# Define gesture mappings for educational actions
func _update_responsive_layout() -> void:
	"""Update layout based on viewport size"""
	viewport_size = get_viewport().get_visible_rect().size
	is_mobile_layout = viewport_size.x <= 768

	# Apply responsive sizing
	UIThemeManager.apply_responsive_panel_sizing(self, viewport_size)

	# Update fragments with responsive config
func _apply_theme() -> void:
	"""Apply current theme to component using StyleEngine"""
	# Use new StyleEngine for unified theming
	if FeatureFlags.is_enabled(FeatureFlags.UI_STYLE_ENGINE):
		_apply_style_engine_theme()
	else:
		# Fallback to legacy theming
		UIThemeManager.apply_enhanced_panel_style(self, "elevated")

	# Update fragments with theme
	if header_fragment and header_fragment.has_method("apply_theme"):
		header_fragment.apply_theme(panel_theme)

	if content_fragment and content_fragment.has_method("apply_theme"):
		content_fragment.apply_theme(panel_theme)

	if actions_fragment and actions_fragment.has_method("apply_theme"):
		actions_fragment.apply_theme(panel_theme)


func _apply_style_engine_theme() -> void:
	"""Apply theme using StyleEngine"""
func _apply_positioning(position_hint: String) -> void:
	"""Apply positioning based on hint"""
	match position_hint:
		"right":
			anchor_left = 1.0
			anchor_right = 1.0
			offset_left = -custom_minimum_size.x - 16
			offset_right = -16
		"left":
			anchor_left = 0.0
			anchor_right = 0.0
			offset_left = 16
			offset_right = custom_minimum_size.x + 16
		"center":
			anchor_left = 0.5
			anchor_right = 0.5
			offset_left = -custom_minimum_size.x / 2.0
			offset_right = custom_minimum_size.x / 2.0


func _save_component_state() -> void:
	"""Save component state for persistence"""
	if component_id.is_empty():
		return

func _restore_component_state() -> void:
	"""Restore component state from persistence"""
	if component_id.is_empty():
		return

func _restore_scroll_position(scroll_pos: float) -> void:
	"""Restore scroll position after content is loaded"""
	if scroll_container:
		scroll_container.scroll_vertical = int(scroll_pos)


# === EVENT HANDLERS ===
func _on_header_action(action: String, data: Dictionary = {}) -> void:
	"""Handle header actions"""
	match action:
		"close":
			hide_panel()
		"bookmark":
			is_bookmarked = not is_bookmarked
			if header_fragment and header_fragment.has_method("set_bookmark_state"):
				header_fragment.set_bookmark_state(is_bookmarked)
			action_triggered.emit(
				"bookmark",
				{"structure_id": structure_data.get("id", ""), "bookmarked": is_bookmarked}
			)
		"share":
			action_triggered.emit("share", {"structure_data": structure_data})
		_:
			action_triggered.emit(action, data)


func _on_content_section_toggled(section_name: String, expanded: bool) -> void:
	"""Handle section toggle in content"""
	section_states[section_name] = expanded
	section_toggled.emit(section_name, expanded)

	# Save state change
	if FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE):
		_save_component_state()


func _on_content_changed(_change_data: Dictionary) -> void:
	"""Handle content changes"""
	# Save scroll position
	if scroll_container:
		scroll_position = scroll_container.scroll_vertical

	if FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE):
		_save_component_state()


func _on_actions_triggered(action: String, data: Dictionary = {}) -> void:
	"""Handle action button presses"""
	match action:
		"notes":
			action_triggered.emit("show_notes", {"structure_id": structure_data.get("id", "")})
		"related":
			action_triggered.emit("show_related", {"structure_data": structure_data})
		"quiz":
			action_triggered.emit("start_quiz", {"structure_id": structure_data.get("id", "")})
		_:
			action_triggered.emit(action, data)


func _on_viewport_size_changed() -> void:
	"""Handle viewport size changes"""
	_update_responsive_layout()


func _on_mouse_entered() -> void:
	"""Handle mouse entering the panel"""
	if FeatureFlags.is_enabled(FeatureFlags.UI_ADVANCED_INTERACTIONS):
		# Add hover effect using StyleEngine
func _on_mouse_exited() -> void:
	"""Handle mouse exiting the panel"""
	if FeatureFlags.is_enabled(FeatureFlags.UI_ADVANCED_INTERACTIONS):
		# Remove hover effect
func _handle_gesture_action(gesture_name: String) -> void:
	"""Handle gesture-based actions"""
func _expand_all_sections() -> void:
	"""Expand all collapsible sections"""
	for section_name in section_states.keys():
		section_states[section_name] = true

	# Update content fragment
	if content_fragment and content_fragment.has_method("expand_all_sections"):
		content_fragment.expand_all_sections()

	# Animate expansion
	if FeatureFlags.is_enabled(FeatureFlags.UI_SMOOTH_ANIMATIONS):
func _collapse_all_sections() -> void:
	"""Collapse all sections except description"""
	for section_name in section_states.keys():
		if section_name != "description":  # Keep description always visible
			section_states[section_name] = false

	# Update content fragment
	if content_fragment and content_fragment.has_method("collapse_all_sections"):
		content_fragment.collapse_all_sections()


func _toggle_zoom_mode() -> void:
	"""Toggle content zoom mode"""
