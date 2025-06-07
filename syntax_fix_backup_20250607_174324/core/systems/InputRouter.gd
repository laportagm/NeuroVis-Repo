## InputRouter.gd
## Centralized input routing system for educational interactions
##
## This system efficiently routes input events to appropriate handlers based on
## context, mode, and UI state for optimized educational interaction handling.
##
## @tutorial: Educational input handling patterns
## @version: 1.0

class_name InputRouter
extends Node

# === SIGNALS ===
## Emitted when an educational interaction occurs

signal educational_interaction(interaction_type: String, data: Dictionary)

## Emitted when an input conflict is detected
signal input_conflict_detected(handlers: Array)

# === CONSTANTS ===
## Input modes for different educational contexts

enum InputMode {
NORMAL,          # Standard interaction mode
SELECTION,       # Structure selection focus
MEASUREMENT,     # Educational measurement mode
ANNOTATION,      # Adding educational annotations
COMPARISON       # Multi-structure comparison mode
}

## Interaction areas for routing
enum InteractionArea {
WORLD_3D,        # 3D space interactions
UI,              # UI element interactions
OVERLAY          # Modal/overlay interactions (highest priority)
}

# === EXPORTED VARIABLES ===
## Default input mode at startup

@export var default_mode: InputMode = InputMode.NORMAL

## Automatically detect UI interactions
@export var auto_detect_ui: bool = true

# === PRIVATE VARIABLES ===
# Current input handling state

var handler_entry = {
"node": handler,
"event_types": event_types,
"priority": priority,
"area": area
}

# Add to handlers list
_input_handlers.append(handler_entry)

# Sort by priority (descending)
_input_handlers.sort_custom(func(a, b): return a.priority > b.priority)

var removed = false
var old_mode = _current_mode
	_current_mode = mode
	_exclusive_mode_owner = exclusive_owner

var applicable_handlers = []
var event_type = event.get_class()

var handles_type = false
var priority_conflicts = {}
var top_priority = applicable_handlers[0].priority
var control = get_control_at_position(mouse_position)
	_ui_has_focus = control != null

	# If mouse position changed, invalidate cache for next time
var control = _ui_elements[i]
var ui_root = root.get_node_or_null("SceneManager/UIController/UI")

var _current_mode: InputMode = InputMode.NORMAL
var _current_area: InteractionArea = InteractionArea.WORLD_3D
var _ui_has_focus: bool = false

# Input handlers by priority (highest first)
var _input_handlers: Array[Dictionary] = []

# Input mode exclusivity control
var _exclusive_mode_owner: Node = null

# UI elements for collision detection
var _ui_elements: Array[Control] = []

# Cached raycasts for optimization
var _last_mouse_position: Vector2 = Vector2.ZERO
var _cached_ui_element_under_mouse: Control = null
var _cache_valid: bool = false

# === LIFECYCLE METHODS ===

func _ready() -> void:
	print("[InputRouter] Initializing educational input router")
	# Initialize with default mode
	set_input_mode(default_mode)

	# Connect to node tree updates for UI tracking
	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_removed)

func _unhandled_input(event: InputEvent) -> void:
	# Don't process if we don't have focus
	if not get_viewport().gui_is_dragging() and get_viewport().gui_has_modal_screen():
		return

		# Update UI focus status if needed
		if auto_detect_ui and event is InputEventMouse:
			_update_ui_focus(event.position)

			# Handle input based on current area and mode
			if _ui_has_focus:
				_current_area = InteractionArea.UI
				else:
					_current_area = InteractionArea.WORLD_3D

					# Pass to appropriate handlers
					_route_input(event)

					# === PUBLIC METHODS ===
					## Initialize the input router
					## @param root_node: The root node for finding UI elements

func initialize(root_node: Node = null) -> void:
	"""Initialize the input router with UI root node"""
	print("[InputRouter] Initializing with root node")

	if root_node:
		# Scan for UI elements
		_scan_for_ui_elements(root_node)
		else:
			# Use scene tree root as default
			_scan_for_ui_elements(get_tree().root)

			## Register an input handler
			## @param handler: Node that will handle input
			## @param event_types: Array of event types to handle
			## @param priority: Handler priority (higher = processed first)
			## @param area: InteractionArea this handler works in
			## @returns: Whether registration was successful
func register_handler(handler: Node, event_types: Array, priority: int = 0, area: InteractionArea = -1) -> bool:
	"""Register a node to handle specific input event types"""
	if not is_instance_valid(handler):
		push_error("[InputRouter] Cannot register invalid handler")
		return false

		if event_types.is_empty():
			push_error("[InputRouter] Cannot register handler without event types")
			return false

			# Create handler entry
func unregister_handler(handler: Node) -> void:
	"""Remove a node from input handling"""
	if not is_instance_valid(handler):
		return

		# Remove from handlers list
func set_input_mode(mode: InputMode, exclusive_owner: Node = null) -> void:
	"""Set the educational interaction input mode"""
	if mode == _current_mode:
		return

		# Handle exclusivity changes
		if exclusive_owner and _exclusive_mode_owner and _exclusive_mode_owner != exclusive_owner:
			push_warning("[InputRouter] Mode is exclusively owned by " + _exclusive_mode_owner.name +
			", but " + exclusive_owner.name + " attempted to change it")
			return

func release_exclusive_mode(owner: Node) -> void:
	"""Release exclusive hold on input mode"""
	if _exclusive_mode_owner == owner:
		_exclusive_mode_owner = null
		print("[InputRouter] Exclusive mode released by " + owner.name)
		else if _exclusive_mode_owner != null:
			push_warning("[InputRouter] Attempted to release exclusive mode owned by " +
			_exclusive_mode_owner.name + " from " + owner.name)

			## Get the current input mode
func get_input_mode() -> InputMode:
	"""Get current educational interaction mode"""
	return _current_mode

	## Check if a control is under the mouse position
	## @param position: Mouse position to check
	## @returns: Control under the mouse or null
func get_control_at_position(position: Vector2) -> Control:
	"""Get UI control at specified position"""
	# Use cached result if valid
	if _cache_valid and position == _last_mouse_position:
		return _cached_ui_element_under_mouse

		# Update cache
		_last_mouse_position = position
		_cached_ui_element_under_mouse = _find_ui_element_at_position(position)
		_cache_valid = true

		return _cached_ui_element_under_mouse

		# === PRIVATE METHODS ===
		## Route input to appropriate handlers

func _fix_orphaned_code():
	print("[InputRouter] Registered handler: " + handler.name + " with priority " + str(priority))

	# Add to UI elements list if it's a Control
	if handler is Control:
		_add_ui_element(handler)

		return true

		## Unregister an input handler
		## @param handler: Node to unregister
func _fix_orphaned_code():
	for i in range(_input_handlers.size() - 1, -1, -1):
		if _input_handlers[i].node == handler:
			_input_handlers.remove_at(i)
			removed = true

			if removed:
				print("[InputRouter] Unregistered handler: " + handler.name)

				# Remove from UI elements if it's a Control
				if handler is Control:
					_ui_elements.erase(handler)

					## Set the current input mode
					## @param mode: New input mode to set
					## @param exclusive_owner: Node that requested exclusivity
func _fix_orphaned_code():
	print("[InputRouter] Input mode changed from " + InputMode.keys()[old_mode] +
	" to " + InputMode.keys()[mode])

	# Notify of mode change
	educational_interaction.emit("mode_changed", {
	"old_mode": old_mode,
	"new_mode": mode,
	"exclusive": (exclusive_owner != null)
	})

	## Release exclusive input mode
	## @param owner: Node that currently owns exclusive mode
func _fix_orphaned_code():
	for handler in _input_handlers:
		# Check if handler works in current area or all areas (-1)
		if handler.area != -1 and handler.area != _current_area:
			continue

			# Check if handler accepts this event type
func _fix_orphaned_code():
	for type in handler.event_types:
		if event_type == type or event.is_class(type):
			handles_type = true
			break

			if handles_type and is_instance_valid(handler.node):
				applicable_handlers.append(handler)

				# Check for conflicts (multiple handlers with same priority)
				if applicable_handlers.size() > 1:
func _fix_orphaned_code():
	for handler in applicable_handlers:
		if not priority_conflicts.has(handler.priority):
			priority_conflicts[handler.priority] = []
			priority_conflicts[handler.priority].append(handler.node.name)

			# Emit conflict warning if multiple handlers have same top priority
func _fix_orphaned_code():
	if priority_conflicts[top_priority].size() > 1:
		input_conflict_detected.emit(priority_conflicts[top_priority])

		# Process handlers in priority order until one handles the event
		for handler in applicable_handlers:
			if not is_instance_valid(handler.node):
				continue

				if handler.node.has_method("handle_input"):
					# Handler has dedicated input handler method
					if handler.node.handle_input(event, _current_mode):
						get_viewport().set_input_as_handled()
						return
						else:
							# Forward to _unhandled_input if present
							if handler.node.has_method("_unhandled_input"):
								# Can't detect if _unhandled_input handled the event
								# Just deliver and continue
								handler.node._unhandled_input(event)

								# If viewport reports input handled, stop processing
								if get_viewport().is_input_handled():
									return

									## Handle global keyboard shortcuts
func _fix_orphaned_code():
	if mouse_position != _last_mouse_position:
		_cache_valid = false

		## Find UI element at a position
func _fix_orphaned_code():
	if not is_instance_valid(control) or not control.visible:
		continue

		if control.get_global_rect().has_point(position) and control.mouse_filter != Control.MOUSE_FILTER_IGNORE:
			return control

			return null

			## Scan the tree for UI elements
func _fix_orphaned_code():
	if ui_root:
		_find_ui_controls_recursive(ui_root)
		else:
			# Fallback to scanning the whole tree
			_find_ui_controls_recursive(root)

			print("[InputRouter] Found " + str(_ui_elements.size()) + " UI elements for input handling")

			## Recursively find all UI controls

func _route_input(event: InputEvent) -> void:
	"""Route input event to appropriate handlers based on context"""
	# Skip if event already handled
	if event.is_class("InputEventMouse") and get_viewport().is_input_handled():
		return

		# Common keyboard shortcuts processing
		if event is InputEventKey and event.pressed:
			if _handle_global_shortcuts(event):
				get_viewport().set_input_as_handled()
				return

				# Filter handlers by area and event type
func _handle_global_shortcuts(event: InputEventKey) -> bool:
	"""Process global educational keyboard shortcuts"""
	if event.pressed:
		match event.keycode:
			# Mode switching shortcuts
			KEY_F1:
				# Toggle debug mode
				if enable_debug and Input.is_key_pressed(KEY_CTRL):
					# Toggle debug console would go here
					return true
					KEY_ESCAPE:
						# Cancel current operation or return to normal mode
						if _current_mode != InputMode.NORMAL:
							set_input_mode(InputMode.NORMAL)
							return true
							KEY_TAB:
								# Educational feature - cycle through structures in comparison mode
								if _current_mode == InputMode.COMPARISON:
									educational_interaction.emit("cycle_comparison", {})
									return true

									# No global shortcut handled
									return false

									## Update UI focus state based on mouse position
func _update_ui_focus(mouse_position: Vector2) -> void:
	"""Update whether UI has focus based on mouse position"""
func _find_ui_element_at_position(position: Vector2) -> Control:
	"""Find which UI element is under a position"""
	# Process in reverse order (top to bottom)
	for i in range(_ui_elements.size() - 1, -1, -1):
func _scan_for_ui_elements(root: Node) -> void:
	"""Find all UI elements in the scene for input handling"""
	# Clear current list
	_ui_elements.clear()

func _find_ui_controls_recursive(node: Node) -> void:
	"""Recursively gather all UI controls"""
	if node is Control and node.mouse_filter != Control.MOUSE_FILTER_IGNORE:
		_add_ui_element(node)

		for child in node.get_children():
			_find_ui_controls_recursive(child)

			## Add a UI element to the tracked list
func _add_ui_element(control: Control) -> void:
	"""Add a UI element to the tracked elements list"""
	if not control in _ui_elements:
		_ui_elements.append(control)

		## Handle node added to scene
func _on_node_added(node: Node) -> void:
	"""Track new UI elements added to scene"""
	if node is Control and node.mouse_filter != Control.MOUSE_FILTER_IGNORE:
		_add_ui_element(node)
		# Invalidate cache when UI changes
		_cache_valid = false

		## Handle node removed from scene
func _on_node_removed(node: Node) -> void:
	"""Handle UI elements removed from scene"""
	if node is Control and node in _ui_elements:
		_ui_elements.erase(node)
		# Invalidate cache when UI changes
		_cache_valid = false

		# Unregister as handler if registered
		for i in range(_input_handlers.size() - 1, -1, -1):
			if _input_handlers[i].node == node:
				_input_handlers.remove_at(i)
