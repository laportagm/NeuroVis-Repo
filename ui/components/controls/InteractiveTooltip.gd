# Interactive Tooltip System for NeuroVis
# Rich, interactive tooltips with multimedia content support

class_name InteractiveTooltip
extends ResponsiveComponent

# === TOOLTIP SIGNALS ===

	# ORPHANED REF: signal tooltip_shown(target: Control, content: Dictionary)
signal tooltip_hidden(target: Control)
	# ORPHANED REF: signal tooltip_action_triggered(action: String, data: Dictionary)
signal tooltip_link_clicked(url: String)

# === TOOLTIP TYPES ===

enum TooltipType { SIMPLE, RICH, INTERACTIVE, EDUCATIONAL, DIAGNOSTIC }

# === CONFIGURATION ===

@export var tooltip_type: TooltipType = TooltipType.SIMPLE
@export var auto_position: bool = true
@export var show_delay: float = 0.5
@export var hide_delay: float = 0.1
@export var max_width: float = 300
@export var interactive_mode: bool = false

# === DISPLAY STATE ===

var target_control: Control
var is_visible: bool = false
var show_timer: Timer
var hide_timer: Timer
var content_data: Dictionary = {}

# === UI COMPONENTS ===
var main_container: VBoxContainer
var title_label: Label
var content_area: Control
var action_buttons: HBoxContainer
var arrow_indicator: Control

# === STATIC TOOLTIP MANAGER ===
static var active_tooltip: InteractiveTooltip
static var tooltip_instances: Array[InteractiveTooltip] = []


var tooltip = _get_or_create_tooltip(tooltip_type)
	# ORPHANED REF: tooltip._show_for_target(target, content)

active_tooltip = tooltip
var structure_data = {}

# Safe access to KnowledgeService in static context
# Since this is a static function, we need to get a scene tree node reference
var knowledge_service = target.get_node("/root/KnowledgeService")
# FIXED: Orphaned code - var content = {
"type": "educational",
	# ORPHANED REF: "title": structure_data.get("displayName", "Unknown Structure"),
	# ORPHANED REF: "description": structure_data.get("shortDescription", "No description available."),
	# ORPHANED REF: "functions": structure_data.get("functions", []),
	# ORPHANED REF: "actions":
[
	# ORPHANED REF: {"text": "Learn More", "action": "learn_more", "data": {"structure_id": structure_id}},
	# ORPHANED REF: {"text": "Highlight", "action": "highlight", "data": {"structure_id": structure_id}}
]
}

# FIXED: Orphaned code - var content_2 = {
"type": "diagnostic",
	# ORPHANED REF: "title": "Diagnostic Information",
	# ORPHANED REF: "data": diagnostic_data,
	# ORPHANED REF: "timestamp": Time.get_datetime_string_from_system()
}

# FIXED: Orphaned code - var tween = create_tween()
	# ORPHANED REF: tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.15)
	# ORPHANED REF: tween.tween_callback(func(): visible = false)
visible = false

_disconnect_target_events()

# FIXED: Orphaned code - var tooltip_type_string = content_data.get("type", "simple")

"simple":
_create_simple_content()
"rich":
_create_rich_content()
"interactive":
_create_interactive_content()
"educational":
_create_educational_content()
"diagnostic":
_create_diagnostic_content()
_:
_create_simple_content()


# FIXED: Orphaned code - var text = content_data.get("text", "")
# FIXED: Orphaned code - var label = UIComponentFactory.create_label(text, "body")
	# ORPHANED REF: label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	# ORPHANED REF: label.custom_minimum_size.x = min(max_width, 200)
	# ORPHANED REF: content_area.add_child(label)


# FIXED: Orphaned code - var title = content_data.get("title", "")
# FIXED: Orphaned code - var description = content_data.get("description", "")

# FIXED: Orphaned code - var rich_text = RichTextLabel.new()
	# ORPHANED REF: rich_text.bbcode_enabled = true
	# ORPHANED REF: rich_text.fit_content = true
	# ORPHANED REF: rich_text.scroll_active = false
	# ORPHANED REF: rich_text.custom_minimum_size = Vector2(max_width, 0)
	# ORPHANED REF: rich_text.text = description

	# ORPHANED REF: UIThemeManager.apply_rich_text_styling(rich_text, UIThemeManager.FONT_SIZE_MEDIUM)
	# ORPHANED REF: content_area.add_child(rich_text)


# FIXED: Orphaned code - var actions = content_data.get("actions", [])
# FIXED: Orphaned code - var title_2 = content_data.get("title", "")
# FIXED: Orphaned code - var description_2 = content_data.get("description", "")
# FIXED: Orphaned code - var functions = content_data.get("functions", [])

# Title
	# ORPHANED REF: var desc_label = UIComponentFactory.create_label(description, "body")
desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
desc_label.custom_minimum_size.x = max_width
content_area.add_child(desc_label)

	# Functions (limited to first 3 for tooltip)
# FIXED: Orphaned code - var func_label = UIComponentFactory.create_label("Key Functions:", "caption")
	# ORPHANED REF: content_area.add_child(func_label)

# FIXED: Orphaned code - var function_list = VBoxContainer.new()
# FIXED: Orphaned code - var func_item = HBoxContainer.new()
# FIXED: Orphaned code - var bullet = UIComponentFactory.create_label("•", "body")
	# ORPHANED REF: bullet.custom_minimum_size.x = 15
	# ORPHANED REF: var func_text = UIComponentFactory.create_label(str(functions[i]), "body")
func_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	# ORPHANED REF: func_item.add_child(bullet)
	# ORPHANED REF: func_item.add_child(func_text)
	# ORPHANED REF: function_list.add_child(func_item)

	# ORPHANED REF: content_area.add_child(function_list)

# FIXED: Orphaned code - var more_label = UIComponentFactory.create_label(
	# ORPHANED REF: "... and " + str(functions.size() - 3) + " more", "caption"
)
	# ORPHANED REF: content_area.add_child(more_label)

	# Action buttons
	# ORPHANED REF: var actions_2 = content_data.get("actions", [])
# FIXED: Orphaned code - var title_3 = content_data.get("title", "Diagnostic Info")
# FIXED: Orphaned code - var data = content_data.get("data", {})
# FIXED: Orphaned code - var timestamp = content_data.get("timestamp", "")

	# ORPHANED REF: title_label.text = title
title_label.visible = true

	# Timestamp
	# ORPHANED REF: var time_label = UIComponentFactory.create_label("Time: " + timestamp, "caption")
content_area.add_child(time_label)
content_area.add_child(HSeparator.new())

	# Data entries
var entry_container = HBoxContainer.new()
# FIXED: Orphaned code - var key_label = UIComponentFactory.create_label(str(key).capitalize() + ":", "caption")
	# ORPHANED REF: key_label.custom_minimum_size.x = 100
	# ORPHANED REF: var value_label = UIComponentFactory.create_label(str(data[key]), "body")

	# ORPHANED REF: entry_container.add_child(key_label)
entry_container.add_child(value_label)
content_area.add_child(entry_container)


# FIXED: Orphaned code - var button = UIComponentFactory.create_button(
	# ORPHANED REF: action_data.get("text", "Action"), action_data.get("style", "secondary")
)
	# ORPHANED REF: button.pressed.connect(_on_action_button_pressed.bind(action_data))
	# ORPHANED REF: action_buttons.add_child(button)

action_buttons.visible = true
interactive_mode = true


	# === POSITIONING ===
var viewport = get_viewport()
# FIXED: Orphaned code - var target_rect = target_control.get_global_rect()
# FIXED: Orphaned code - var viewport_size = viewport.get_visible_rect().size

# Calculate preferred position (below target)
# FIXED: Orphaned code - var preferred_pos = Vector2(
	# ORPHANED REF: target_rect.position.x + target_rect.size.x * 0.5,
	# ORPHANED REF: target_rect.position.y + target_rect.size.y + 8
)

	# Adjust if tooltip would go off-screen
var tooltip_size = Vector2(max_width, 100)  # Estimated size

# Horizontal adjustment
var mouse_event = event as InputEventMouseButton
var action = action_data.get("action", "")
# FIXED: Orphaned code - var data_2 = action_data.get("data", {})

	# ORPHANED REF: tooltip_action_triggered.emit(action, data)

	# Hide tooltip after action unless it's a persistent action
var tooltip_2 = InteractiveTooltip.new()
tooltip.tooltip_type = tooltip_type
var content_3 = control.get_meta("tooltip_content", {})

return tooltip


static func show_structure_tooltip(target: Control, structure_id: String) -> InteractiveTooltip:
	"""Show tooltip with brain structure information"""
	if target and target.is_inside_tree() and target.has_node("/root/KnowledgeService"):
	if knowledge_service and knowledge_service.has_method("get_structure"):
	structure_data = knowledge_service.get_structure(structure_id)
else:
	push_warning(
	"[InteractiveTooltip] Warning: KnowledgeService.get_structure method not available"
	)
else:
	push_warning(
	"[InteractiveTooltip] Warning: KnowledgeService not available or target not in tree"
	)

	# ORPHANED REF: return show_for_control(target, content, TooltipType.EDUCATIONAL)


	static func show_diagnostic_tooltip(
target: Control, diagnostic_data: Dictionary
	) -> InteractiveTooltip:
	"""Show diagnostic tooltip with system information"""
	# ORPHANED REF: return show_for_control(target, content, TooltipType.DIAGNOSTIC)


static func hide_all_tooltips() -> void:
	"""Hide all active tooltips"""
	if active_tooltip:
	active_tooltip._hide_tooltip()
	active_tooltip = null


		# === TOOLTIP DISPLAY ===
	if target_control:
	tooltip_hidden.emit(target_control)

	target_control = null


	# === CONTENT MANAGEMENT ===
	# ORPHANED REF: if text == "":
	return

	# ORPHANED REF: if title != "":
	# ORPHANED REF: title_label.text = title
	title_label.visible = true

	# ORPHANED REF: if description != "":
	# ORPHANED REF: if not actions.is_empty():
	# ORPHANED REF: _create_action_buttons(actions)


	# ORPHANED REF: if title != "":
	# ORPHANED REF: title_label.text = title
	title_label.visible = true

	# Description
	# ORPHANED REF: if description != "":
	# ORPHANED REF: if not functions.is_empty():
	# ORPHANED REF: for i in range(min(3, functions.size())):
	# ORPHANED REF: if functions.size() > 3:
	# ORPHANED REF: if not actions.is_empty():
	# ORPHANED REF: _create_action_buttons(actions)


	# ORPHANED REF: if timestamp != "":
	# ORPHANED REF: for key in data:
	if not viewport:
	return

	# ORPHANED REF: if preferred_pos.x + tooltip_size.x > viewport_size.x:
	# ORPHANED REF: preferred_pos.x = viewport_size.x - tooltip_size.x - 16
	# ORPHANED REF: if preferred_pos.x < 16:
	# ORPHANED REF: preferred_pos.x = 16

		# Vertical adjustment (show above if no room below)
	# ORPHANED REF: if preferred_pos.y + tooltip_size.y > viewport_size.y:
	# ORPHANED REF: preferred_pos.y = target_rect.position.y - tooltip_size.y - 8

			# Set position
	# ORPHANED REF: position = preferred_pos


			# === EVENT HANDLING ===
	if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
	if not interactive_mode:
	_hide_tooltip()


	if not action_data.get("persistent", false):
	_hide_tooltip()


	# === STATIC HELPER METHODS ===
static func _get_or_create_tooltip(tooltip_type: TooltipType) -> InteractiveTooltip:
	"""Get existing or create new tooltip instance"""
		# Try to reuse existing tooltip of same type
	for tooltip in tooltip_instances:
	if (
	is_instance_valid(tooltip)
	and tooltip.tooltip_type == tooltip_type
	and not tooltip.is_visible
	):
	return tooltip

				# Create new tooltip
	return tooltip


	# ORPHANED REF: static func register_tooltip_for_control(control: Control, content: Dictionary) -> void:
	# ORPHANED REF: """Register tooltip content for a control"""
	if not control:
	return

	# ORPHANED REF: control.set_meta("tooltip_content", content)

		# Connect mouse events
	if control.has_signal("mouse_entered"):
	control.mouse_entered.connect(_on_control_mouse_entered.bind(control))
	if control.has_signal("mouse_exited"):
	control.mouse_exited.connect(_on_control_mouse_exited.bind(control))


static func _on_control_mouse_entered(control: Control) -> void:
	"""Handle registered control mouse enter"""
	# ORPHANED REF: if not content.is_empty():
	# ORPHANED REF: show_for_control(control, content)


static func _on_control_mouse_exited(control: Control) -> void:
	"""Handle registered control mouse exit"""
	if active_tooltip and active_tooltip.target_control == control:
	active_tooltip.hide_timer.start()


			# === CLEANUP ===

func _setup_component() -> void:
	"""Setup the interactive tooltip"""
	super._setup_component()

	# Register with global manager
	tooltip_instances.append(self)

	# Setup tooltip structure
	_create_tooltip_structure()
	_setup_timers()
	_setup_positioning()

	# Initially hidden
	visible = false
	modulate = Color.TRANSPARENT


func _create_tooltip_structure() -> void:
	"""Create the tooltip UI structure"""
	# Apply enhanced tooltip styling
	UIThemeManager.apply_enhanced_panel_style(self, "overlay")

	# Main container
	main_container = VBoxContainer.new()
	main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_container.add_theme_constant_override("separation", UIThemeManager.get_spacing("sm"))
	add_child(main_container)

	# Title area (optional)
	title_label = UIComponentFactory.create_label("", "subheading")
	title_label.visible = false
	main_container.add_child(title_label)

	# Content area
	content_area = VBoxContainer.new()
	content_area.name = "ContentArea"
	main_container.add_child(content_area)

	# Action buttons area (for interactive tooltips)
	action_buttons = HBoxContainer.new()
	action_buttons.name = "ActionButtons"
	action_buttons.alignment = BoxContainer.ALIGNMENT_END
	action_buttons.visible = false
	main_container.add_child(action_buttons)


func _setup_timers() -> void:
	"""Setup show/hide timers"""
	show_timer = Timer.new()
	show_timer.wait_time = show_delay
	show_timer.one_shot = true
	show_timer.timeout.connect(_show_tooltip)
	add_child(show_timer)

	hide_timer = Timer.new()
	hide_timer.wait_time = hide_delay
	hide_timer.one_shot = true
	hide_timer.timeout.connect(_hide_tooltip)
	add_child(hide_timer)


func _setup_positioning() -> void:
	"""Setup automatic positioning"""
	z_index = 1000  # Ensure tooltips appear above other UI
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	size_flags_vertical = Control.SIZE_SHRINK_CENTER


	# === PUBLIC API ===
	static func show_for_control(
	# ORPHANED REF: target: Control, content: Dictionary, tooltip_type: TooltipType = TooltipType.SIMPLE
	) -> InteractiveTooltip:
	"""Show tooltip for a specific control"""
	hide_all_tooltips()

	# ORPHANED REF: func _show_for_target(target: Control, content: Dictionary) -> void:
	"""Show tooltip for specific target"""
	if not target or not is_instance_valid(target):
	return

	target_control = target
	# ORPHANED REF: content_data = content

		# Connect to target events
	_connect_target_events()

		# Update content
	_update_tooltip_content()

		# Position tooltip
	if auto_position:
	_position_near_target()

			# Start show timer
	show_timer.start()


func _show_tooltip() -> void:
	"""Actually show the tooltip"""
	if not target_control or not is_instance_valid(target_control):
	return

	is_visible = true
	visible = true

		# Animate entrance
	if animation_enabled:
	UIThemeManager.animate_enhanced_entrance(self, 0.0)
else:
	modulate = Color.WHITE

	tooltip_shown.emit(target_control, content_data)


func _hide_tooltip() -> void:
	"""Hide the tooltip"""
	if not is_visible:
	return

	is_visible = false

		# Animate exit
	if animation_enabled:
func _update_tooltip_content() -> void:
	# ORPHANED REF: """Update tooltip content based on type and data"""
	_clear_content()

func _clear_content() -> void:
	# ORPHANED REF: """Clear existing content"""
	for child in content_area.get_children():
	child.queue_free()

	for child in action_buttons.get_children():
	child.queue_free()

	title_label.visible = false
	action_buttons.visible = false


func _create_simple_content() -> void:
	# ORPHANED REF: """Create simple text tooltip"""
func _create_rich_content() -> void:
	# ORPHANED REF: """Create rich text tooltip with formatting"""
func _create_interactive_content() -> void:
	"""Create interactive tooltip with buttons"""
	_create_rich_content()

func _create_educational_content() -> void:
	"""Create educational tooltip for brain structures"""
func _create_diagnostic_content() -> void:
	"""Create diagnostic tooltip with system information"""
	# ORPHANED REF: func _create_action_buttons(actions: Array) -> void:
	"""Create action buttons for interactive tooltips"""
	# ORPHANED REF: for action_data in actions:
func _position_near_target() -> void:
	"""Position tooltip near target control"""
	if not target_control or not is_instance_valid(target_control):
	return

func _connect_target_events() -> void:
	"""Connect to target control events"""
	if not target_control:
	return

	if target_control.has_signal("mouse_exited"):
	if not target_control.mouse_exited.is_connected(_on_target_mouse_exited):
	target_control.mouse_exited.connect(_on_target_mouse_exited)

	if interactive_mode and target_control.has_signal("mouse_entered"):
	if not target_control.mouse_entered.is_connected(_on_target_mouse_entered):
	target_control.mouse_entered.connect(_on_target_mouse_entered)


func _disconnect_target_events() -> void:
	"""Disconnect from target control events"""
	if not target_control:
	return

	if target_control.has_signal("mouse_exited"):
	if target_control.mouse_exited.is_connected(_on_target_mouse_exited):
	target_control.mouse_exited.disconnect(_on_target_mouse_exited)

	if target_control.has_signal("mouse_entered"):
	if target_control.mouse_entered.is_connected(_on_target_mouse_entered):
	target_control.mouse_entered.disconnect(_on_target_mouse_entered)


func _on_target_mouse_exited() -> void:
	"""Handle target mouse exit"""
	if not interactive_mode:
	hide_timer.start()


func _on_target_mouse_entered() -> void:
	"""Handle target mouse enter"""
	hide_timer.stop()


func _gui_input(event: InputEvent) -> void:
	"""Handle tooltip input events"""
	super._gui_input(event)

	if event is InputEventMouseButton:
func _on_action_button_pressed(action_data: Dictionary) -> void:
	# ORPHANED REF: """Handle action button press"""
func _cleanup_resources() -> void:
	"""Clean up tooltip resources"""
	super._cleanup_resources()

	tooltip_instances.erase(self)
	_disconnect_target_events()

	if active_tooltip == self:
	active_tooltip = null

	pass
