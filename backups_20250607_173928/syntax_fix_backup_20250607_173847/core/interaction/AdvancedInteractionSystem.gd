## AdvancedInteractionSystem.gd
## Advanced interaction patterns for educational 3D brain visualization
##
## Provides sophisticated input handling including drag & drop, context menus,
## gesture recognition, and multi-modal interaction for educational workflows.
##
## @tutorial: Advanced interaction patterns
## @version: 3.0

class_name AdvancedInteractionSystem
extends Node

# === DEPENDENCIES ===

signal structure_selected(structure_name: String, interaction_type: String)
signal structure_focused(structure_name: String, focus_data: Dictionary)
signal context_menu_requested(position: Vector2, context: Dictionary)
signal drag_operation_started(source: Control, data: Dictionary)
signal drag_operation_completed(source: Control, target: Control, data: Dictionary)
signal gesture_recognized(gesture_name: String, gesture_data: Dictionary)
signal educational_action_triggered(action: String, context: Dictionary)

# === INTERACTION MODES ===

enum InteractionMode { LEARNING, EXPLORATION, ASSESSMENT, CLINICAL, ACCESSIBILITY }  # Student-focused, guided interactions  # Free exploration with assistance  # Testing and evaluation mode  # Professional clinical workflow  # Accessible interaction patterns

enum GestureType {
	NONE,
	SWIPE_LEFT,
	SWIPE_RIGHT,
	SWIPE_UP,
	SWIPE_DOWN,
	PINCH_ZOOM,
	ROTATE_CLOCKWISE,
	ROTATE_COUNTER_CLOCKWISE,
	CIRCLE_GESTURE,
	TAP,
	DOUBLE_TAP,
	LONG_PRESS
}

enum DragOperation {
	NONE, MOVE_PANEL, RESIZE_PANEL, REORDER_SECTIONS, COPY_CONTENT, EDUCATIONAL_SEQUENCE
}

# === STATE MANAGEMENT ===

const FeatureFlags = preprepreload("res://core/features/FeatureFlags.gd")
const StyleEngine = preprepreload("res://ui/theme/StyleEngine.gd")

# === INTERACTION CONSTANTS ===
const DRAG_THRESHOLD: float = 10.0  # Pixels before drag starts
const LONG_PRESS_DURATION: float = 0.8  # Seconds for long press
const DOUBLE_CLICK_TIME: float = 0.4  # Seconds for double click
const GESTURE_SAMPLE_RATE: int = 60  # Samples per second for gestures

# === SIGNALS ===
## Educational interaction signals

		var distance = _mouse_start_position.distance_to(_mouse_current_position)

		if distance > DRAG_THRESHOLD and not _drag_threshold_exceeded:
			_drag_threshold_exceeded = true
			_start_drag_operation(event.position)

		if _is_dragging:
			_update_drag_operation(event.position)


		var timer = get_tree().create_timer(LONG_PRESS_DURATION)
		timer.timeout.connect(_on_long_press_detected.bind(position))


	var current_time = Time.get_time_dict_from_system()["unix"]
	var time_diff = current_time - _last_click_time

	if time_diff < DOUBLE_CLICK_TIME:
		_click_count += 1
	else:
		_click_count = 1

	_last_click_time = current_time

	# Handle different click types
	if _click_count == 1:
		_handle_single_click(position)
	elif _click_count == 2:
		_handle_double_click(position)
		_click_count = 0


	var context = _get_interaction_context(position)
	_show_context_menu(position, context)


	var target = _get_control_at_position(position)
	if target:
		_select_target(target, "click")


	var target = _get_control_at_position(position)
	if target:
		_focus_target(target, "double_click")


	var context = _get_interaction_context(position)
	_show_context_menu(position, context)


# === DRAG & DROP SYSTEM ===
	var source = _get_control_at_position(_mouse_start_position)
	if not source or not _is_draggable(source):
		return

	_is_dragging = true
	_drag_source = source
	_drag_data = _get_drag_data(source)

	# Create drag preview
	_create_drag_preview(source, position)

	# Highlight drop targets
	_highlight_drop_targets(true)

	drag_operation_started.emit(source, _drag_data)
	print("[AdvancedInteraction] Drag started: %s" % source.name)


	var drop_target = _get_drop_target_at_position(position)
	if drop_target != _current_drop_target:
		_update_drop_target_highlight(drop_target)


	var drop_target = _get_drop_target_at_position(position)

	if drop_target and _can_drop_on_target(drop_target, _drag_data):
		_perform_drop(drop_target)
		drag_operation_completed.emit(_drag_source, drop_target, _drag_data)

	# Cleanup
	_cleanup_drag_operation()


	var structure_name = context.get("structure_name", "")
	var menu_type = context.get("menu_type", "default")

	match menu_type:
		"structure":
			_add_structure_menu_items(structure_name)
		"panel":
			_add_panel_menu_items()
		"educational":
			_add_educational_menu_items()
		_:
			_add_default_menu_items()


	var action = _get_context_menu_action(id)
	_trigger_educational_action(action, _context_menu_data)


	var gesture = _recognize_gesture_pattern()
	if gesture != GestureType.NONE:
		_trigger_gesture(gesture)


	var start_point = _gesture_points[0]
	var end_point = _gesture_points[-1]
	var total_distance = start_point.distance_to(end_point)

	# Simple gesture recognition
	if total_distance < 50:
		return GestureType.TAP

	var direction = (end_point - start_point).normalized()

	# Swipe detection
	if abs(direction.x) > abs(direction.y):
		return GestureType.SWIPE_RIGHT if direction.x > 0 else GestureType.SWIPE_LEFT
	else:
		return GestureType.SWIPE_DOWN if direction.y > 0 else GestureType.SWIPE_UP


	var gesture_data = {
		"type": gesture_type,
		"points": _gesture_points.duplicate(),
		"duration": Time.get_time_dict_from_system()["unix"] - _gesture_start_time
	}

	gesture_recognized.emit(GestureType.keys()[gesture_type], gesture_data)
	_handle_gesture_action(gesture_type, gesture_data)

	# Clear gesture data
	_gesture_points.clear()


	var action_data = {
		"action": action,
		"context": context,
		"timestamp": Time.get_time_dict_from_system()["unix"],
		"mode": _current_mode
	}

	# Add to interaction history
	_interaction_history.append(action_data)

	# Limit history size
	if _interaction_history.size() > 100:
		_interaction_history = _interaction_history.slice(-50)

	educational_action_triggered.emit(action, action_data)
	print("[AdvancedInteraction] Educational action: %s" % action)


# === UTILITY METHODS ===
	var viewport = get_viewport()
	if not viewport:
		return null

	# Use Godot's built-in collision detection
	return viewport.gui_get_focus_owner()


	var target = _get_control_at_position(position)
	var context = {
		"position": position,
		"timestamp": Time.get_time_dict_from_system()["unix"],
		"mode": _current_mode
	}

	if target:
		context["target"] = target.name
		context["target_type"] = target.get_class()

		# Check if target is a brain structure
		if target.has_meta("structure_name"):
			context["structure_name"] = target.get_meta("structure_name")
			context["menu_type"] = "structure"
		elif target.has_meta("panel_type"):
			context["menu_type"] = "panel"
		else:
			context["menu_type"] = "default"

	return context


	var actions = {
		1: "primary_action",
		2: "secondary_action",
		3: "bookmark_action",
		4: "copy_action",
		5: "share_action"
	}
	return actions.get(id, "unknown_action")


# === PUBLIC API ===

var _current_mode: InteractionMode = InteractionMode.LEARNING
var _interaction_enabled: bool = true
var _gesture_recognition_enabled: bool = true
var _context_menus_enabled: bool = true

# === INPUT TRACKING ===
var _mouse_start_position: Vector2
var _mouse_current_position: Vector2
var _is_dragging: bool = false
var _drag_threshold_exceeded: bool = false
var _last_click_time: float = 0.0
var _click_count: int = 0
var _long_press_timer: float = 0.0
var _is_long_press_active: bool = false

# === GESTURE RECOGNITION ===
var _gesture_points: Array[Vector2] = []
var _gesture_start_time: float = 0.0
var _current_gesture: GestureType = GestureType.NONE

# === DRAG & DROP ===
var _drag_source: Control = null
var _drag_data: Dictionary = {}
var _drag_preview: Control = null
var _drop_targets: Array[Control] = []
var _current_drop_target: Control = null

# === CONTEXT MENU ===
var _context_menu: PopupMenu = null
var _context_menu_source: Control = null
var _context_menu_data: Dictionary = {}

# === EDUCATIONAL STATE ===
var _selected_structure: String = ""
var _learning_context: Dictionary = {}
var _interaction_history: Array[Dictionary] = []


# === INITIALIZATION ===

func _ready() -> void:
	_setup_interaction_system()
	_setup_context_menu()
	_setup_gesture_recognition()
	print("[AdvancedInteraction] System initialized")


func _unhandled_input(event: InputEvent) -> void:
	if not _interaction_enabled:
		return

	# Handle different input types
	if event is InputEventMouseButton:
		_handle_mouse_button(event)
	elif event is InputEventMouseMotion:
		_handle_mouse_motion(event)
	elif event is InputEventKey:
		_handle_keyboard_input(event)
	elif event is InputEventScreenTouch:
		_handle_touch_input(event)
	elif event is InputEventScreenDrag:
		_handle_drag_input(event)


func set_interaction_mode(mode: InteractionMode) -> void:
	"""Set current interaction mode"""
	_current_mode = mode
	print("[AdvancedInteraction] Mode changed to: %s" % InteractionMode.keys()[mode])


func get_interaction_mode() -> InteractionMode:
	"""Get current interaction mode"""
	return _current_mode


func enable_gestures(enabled: bool) -> void:
	"""Enable/disable gesture recognition"""
	_gesture_recognition_enabled = enabled
	print("[AdvancedInteraction] Gestures: %s" % enabled)


func enable_context_menus(enabled: bool) -> void:
	"""Enable/disable context menus"""
	_context_menus_enabled = enabled
	print("[AdvancedInteraction] Context menus: %s" % enabled)


func get_interaction_history() -> Array[Dictionary]:
	"""Get interaction history"""
	return _interaction_history.duplicate()


func clear_interaction_history() -> void:
	"""Clear interaction history"""
	_interaction_history.clear()
	print("[AdvancedInteraction] History cleared")


# === PLACEHOLDER METHODS ===
# These would be implemented based on specific UI framework

func _setup_interaction_system() -> void:
	"""Setup the interaction system"""
	# Set process mode for consistent input handling
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Initialize interaction state
	_interaction_enabled = FeatureFlags.is_enabled(FeatureFlags.UI_ADVANCED_INTERACTIONS)
	_gesture_recognition_enabled = FeatureFlags.is_enabled(FeatureFlags.UI_GESTURE_RECOGNITION)
	_context_menus_enabled = FeatureFlags.is_enabled(FeatureFlags.UI_CONTEXT_MENUS)


func _setup_context_menu() -> void:
	"""Setup context menu system"""
	if not _context_menus_enabled:
		return

	_context_menu = PopupMenu.new()
	_context_menu.name = "AdvancedContextMenu"
	add_child(_context_menu)

	# Connect context menu signals
	_context_menu.id_pressed.connect(_on_context_menu_item_selected)
	_context_menu.popup_hide.connect(_on_context_menu_hidden)


func _setup_gesture_recognition() -> void:
	"""Setup gesture recognition system"""
	if not _gesture_recognition_enabled:
		return

	_gesture_points.clear()
	print("[AdvancedInteraction] Gesture recognition enabled")


# === INPUT HANDLING ===
func _handle_mouse_button(event: InputEventMouseButton) -> void:
	"""Handle mouse button events"""
	match event.button_index:
		MOUSE_BUTTON_LEFT:
			if event.pressed:
				_on_left_click_start(event.position)
			else:
				_on_left_click_end(event.position)

		MOUSE_BUTTON_RIGHT:
			if event.pressed:
				_on_right_click(event.position)

		MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				_on_middle_click(event.position)


func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	"""Handle mouse motion events"""
	_mouse_current_position = event.position

	# Check for drag threshold
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
func _handle_keyboard_input(event: InputEventKey) -> void:
	"""Handle keyboard input for educational shortcuts"""
	if not event.pressed:
		return

	# Educational keyboard shortcuts
	match event.keycode:
		KEY_SPACE:
			_trigger_educational_action("focus_structure")
		KEY_ENTER:
			_trigger_educational_action("confirm_selection")
		KEY_ESCAPE:
			_trigger_educational_action("cancel_operation")
		KEY_F:
			_trigger_educational_action("toggle_fullscreen")
		KEY_H:
			_trigger_educational_action("show_help")
		KEY_B:
			if event.ctrl_pressed:
				_trigger_educational_action("bookmark_structure")


func _handle_touch_input(event: InputEventScreenTouch) -> void:
	"""Handle touch input for mobile/tablet support"""
	if event.pressed:
		_on_touch_start(event.position)
	else:
		_on_touch_end(event.position)


func _handle_drag_input(event: InputEventScreenDrag) -> void:
	"""Handle touch drag input"""
	_update_gesture_recognition(event.position)


# === CLICK HANDLING ===
func _on_left_click_start(position: Vector2) -> void:
	"""Handle left click start"""
	_mouse_start_position = position
	_mouse_current_position = position
	_drag_threshold_exceeded = false
	_long_press_timer = 0.0
	_is_long_press_active = false

	# Start long press detection
	if _current_mode != InteractionMode.CLINICAL:
func _on_left_click_end(position: Vector2) -> void:
	"""Handle left click end"""
	if _is_dragging:
		_end_drag_operation(position)
		return

	# Handle click/tap
func _on_right_click(position: Vector2) -> void:
	"""Handle right click for context menu"""
	if not _context_menus_enabled:
		return

func _on_middle_click(position: Vector2) -> void:
	"""Handle middle click for special actions"""
	_trigger_educational_action("quick_info", {"position": position})


# === CLICK ACTIONS ===
func _handle_single_click(position: Vector2) -> void:
	"""Handle single click/tap"""
func _handle_double_click(position: Vector2) -> void:
	"""Handle double click/tap"""
func _on_long_press_detected(position: Vector2) -> void:
	"""Handle long press detection"""
	if _is_dragging or _is_long_press_active:
		return

	_is_long_press_active = true
func _start_drag_operation(position: Vector2) -> void:
	"""Start drag operation"""
func _update_drag_operation(position: Vector2) -> void:
	"""Update drag operation"""
	if not _is_dragging or not _drag_preview:
		return

	# Update preview position
	_drag_preview.position = position + Vector2(10, 10)

	# Check for drop targets
func _end_drag_operation(position: Vector2) -> void:
	"""End drag operation"""
	if not _is_dragging:
		return

func _cleanup_drag_operation() -> void:
	"""Clean up drag operation"""
	_is_dragging = false
	_drag_threshold_exceeded = false

	if _drag_preview:
		_drag_preview.queue_free()
		_drag_preview = null

	_highlight_drop_targets(false)
	_current_drop_target = null
	_drag_source = null
	_drag_data.clear()


# === CONTEXT MENU SYSTEM ===
func _show_context_menu(position: Vector2, context: Dictionary) -> void:
	"""Show context menu"""
	if not _context_menu:
		return

	_context_menu_data = context
	_populate_context_menu(context)

	# Position context menu
	_context_menu.popup()
	_context_menu.position = position

	context_menu_requested.emit(position, context)


func _populate_context_menu(context: Dictionary) -> void:
	"""Populate context menu with relevant options"""
	_context_menu.clear()

func _add_structure_menu_items(structure_name: String) -> void:
	"""Add structure-specific menu items"""
	_context_menu.add_item("📖 Learn About " + structure_name, 1)
	_context_menu.add_item("🔍 Focus View", 2)
	_context_menu.add_item("⭐ Bookmark", 3)
	_context_menu.add_separator()
	_context_menu.add_item("📋 Copy Info", 4)
	_context_menu.add_item("📤 Share", 5)


func _add_panel_menu_items() -> void:
	"""Add panel-specific menu items"""
	_context_menu.add_item("📌 Pin Panel", 1)
	_context_menu.add_item("🔄 Refresh", 2)
	_context_menu.add_item("⚙️ Settings", 3)
	_context_menu.add_separator()
	_context_menu.add_item("❌ Close", 4)


func _add_educational_menu_items() -> void:
	"""Add educational menu items"""
	_context_menu.add_item("❓ Help", 1)
	_context_menu.add_item("💡 Hint", 2)
	_context_menu.add_item("📝 Take Quiz", 3)
	_context_menu.add_separator()
	_context_menu.add_item("📊 Progress", 4)


func _add_default_menu_items() -> void:
	"""Add default menu items"""
	_context_menu.add_item("⚙️ Settings", 1)
	_context_menu.add_item("❓ Help", 2)


func _on_context_menu_item_selected(id: int) -> void:
	"""Handle context menu item selection"""
func _on_context_menu_hidden() -> void:
	"""Handle context menu hiding"""
	_context_menu_data.clear()


# === GESTURE RECOGNITION ===
func _update_gesture_recognition(position: Vector2) -> void:
	"""Update gesture recognition"""
	if not _gesture_recognition_enabled:
		return

	_gesture_points.append(position)

	# Limit gesture points to prevent memory issues
	if _gesture_points.size() > 100:
		_gesture_points = _gesture_points.slice(-50)

	# Analyze gesture if we have enough points
	if _gesture_points.size() >= 10:
		_analyze_gesture()


func _analyze_gesture() -> void:
	"""Analyze current gesture pattern"""
	if _gesture_points.size() < 3:
		return

func _recognize_gesture_pattern() -> GestureType:
	"""Recognize gesture pattern from points"""
func _trigger_gesture(gesture_type: GestureType) -> void:
	"""Trigger gesture action"""
func _handle_gesture_action(gesture_type: GestureType, data: Dictionary) -> void:
	"""Handle gesture action"""
	match gesture_type:
		GestureType.SWIPE_LEFT:
			_trigger_educational_action("navigate_previous")
		GestureType.SWIPE_RIGHT:
			_trigger_educational_action("navigate_next")
		GestureType.SWIPE_UP:
			_trigger_educational_action("show_details")
		GestureType.SWIPE_DOWN:
			_trigger_educational_action("hide_details")


# === EDUCATIONAL ACTIONS ===
func _trigger_educational_action(action: String, context: Dictionary = {}) -> void:
	"""Trigger educational action"""
func _get_control_at_position(position: Vector2) -> Control:
	"""Get control at screen position"""
func _get_interaction_context(position: Vector2) -> Dictionary:
	"""Get interaction context for position"""
func _is_draggable(control: Control) -> bool:
	"""Check if control is draggable"""
	return control.has_meta("draggable") and control.get_meta("draggable", false)


func _get_drag_data(source: Control) -> Dictionary:
	"""Get drag data from source"""
	return {
		"source": source,
		"type": source.get_meta("drag_type", "generic"),
		"data": source.get_meta("drag_data", {})
	}


func _get_context_menu_action(id: int) -> String:
	"""Get action name for context menu ID"""
func _create_drag_preview(source: Control, position: Vector2) -> void:
	pass


func _highlight_drop_targets(highlight: bool) -> void:
	pass


func _get_drop_target_at_position(position: Vector2) -> Control:
	return null


func _update_drop_target_highlight(target: Control) -> void:
	pass


func _can_drop_on_target(target: Control, data: Dictionary) -> bool:
	return false


func _perform_drop(target: Control) -> void:
	pass


func _select_target(target: Control, interaction_type: String) -> void:
	pass


func _focus_target(target: Control, interaction_type: String) -> void:
	pass


func _on_touch_start(position: Vector2) -> void:
	_on_left_click_start(position)


func _on_touch_end(position: Vector2) -> void:
	_on_left_click_end(position)
