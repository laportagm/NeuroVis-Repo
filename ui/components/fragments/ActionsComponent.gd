# ActionsComponent - Modular action buttons for panels
# Reusable actions fragment with customizable button layouts

class_name ActionsComponent
extends HBoxContainer

# === DEPENDENCIES ===

signal action_triggered(action: String, data: Dictionary)
signal button_added(action: String, button: Button)
signal button_removed(action: String)

# === UI ELEMENTS ===

const FeatureFlags = preload("res://core/features/FeatureFlags.gd")
const UIThemeManager = preload("res://ui/panels/UIThemeManager.gd")

# === SIGNALS ===

var action_buttons: Dictionary = {}
# FIXED: Orphaned code - var button_groups: Dictionary = {}
# FIXED: Orphaned code - var separator_count: int = 0

# === CONFIGURATION ===
var actions_config: Dictionary = {}
# FIXED: Orphaned code - var current_theme: String = "enhanced"
var is_mobile: bool = false
var actions_layout_mode: String = "horizontal"  # horizontal, vertical, grid

# === STYLING ===
var button_size: Vector2 = Vector2(120, 36)
# FIXED: Orphaned code - var icon_size: Vector2 = Vector2(36, 36)


# FIXED: Orphaned code - var style = StyleBoxFlat.new()
	# ORPHANED REF: style.border_width_top = 1
	# ORPHANED REF: style.border_color = UIThemeManager.get_color("border")
	# ORPHANED REF: style.content_margin_top = UIThemeManager.get_spacing("sm")
	# ORPHANED REF: add_theme_stylebox_override("panel", style)


# === PUBLIC API ===
	# ORPHANED REF: var action = action_config.get("action", action_config.get("text", "action"))
# FIXED: Orphaned code - var text = action_config.get("text", action.capitalize())
# FIXED: Orphaned code - var icon = action_config.get("icon", "")
# FIXED: Orphaned code - var tooltip = action_config.get("tooltip", "")
# FIXED: Orphaned code - var button_type = action_config.get("type", "secondary")
# FIXED: Orphaned code - var group = action_config.get("group", "")

# Create button
var button = Button.new()
	# ORPHANED REF: button.text = text
	# ORPHANED REF: button.tooltip_text = tooltip if tooltip != "" else _get_default_tooltip(action)
button.set_meta("action", action)
	# ORPHANED REF: button.set_meta("group", group)

# Add icon if provided
var button_2 = action_buttons[action]
	# ORPHANED REF: var group_2 = button.get_meta("group", "")

# FIXED: Orphaned code - var separator = VSeparator.new()
	# ORPHANED REF: separator.custom_minimum_size = Vector2(2, button_size.y)
	# ORPHANED REF: separator.name = "Separator_" + str(separator_count)
	# ORPHANED REF: separator_count += 1
	# ORPHANED REF: add_child(separator)


# FIXED: Orphaned code - var button_3 = action_buttons[action]
var button_type_2 = button.get_meta("type", "secondary")
	# ORPHANED REF: UIThemeManager.apply_enhanced_button_style(button, button_type)


# === PRIVATE METHODS ===
var button_4 = action_buttons[action]
	# ORPHANED REF: var is_icon_only = button.text.length() <= 2  # Assuming icon buttons are short

var group_container = HBoxContainer.new()
group_container.name = "Group_" + group_name
group_container.add_theme_constant_override("separation", UIThemeManager.get_spacing("xs"))
add_child(group_container)
	# ORPHANED REF: button_groups[group_name] = group_container

	# ORPHANED REF: button_groups[group_name].add_child(button)


# FIXED: Orphaned code - var group_container_2 = button_groups[group_name]
var tooltips = {
"notes": "Add study notes for this structure",
"related": "Show related structures",
"quiz": "Start quiz on this structure",
"bookmark": "Bookmark this structure",
"share": "Share structure information",
"export": "Export structure data",
"print": "Print structure information",
"compare": "Compare with other structures",
"history": "View interaction history",
"help": "Get help with this structure"
}
# FIXED: Orphaned code - var button_5 = action_buttons[action]
UIThemeManager.animate_button_press(button)

# Emit action signal with configuration data
var action_data = config.duplicate()
action_data["timestamp"] = Time.get_unix_time_from_system()

action_triggered.emit(action, action_data)


# === PRESET CONFIGURATIONS ===
var actions = ActionsComponent.new()
actions.configure_actions(config)
# FIXED: Orphaned code - var actions_2 = ActionsComponent.new()
actions.apply_preset(preset_name)

func _ready() -> void:
	_setup_actions_structure()
	_apply_actions_styling()


func configure_actions(config: Dictionary) -> void:
	"""Configure actions with settings"""
	actions_config = config.duplicate()

	# Set layout mode
	if config.has("layout"):
	actions_layout_mode = config.layout
	_update_layout_mode()

		# Setup buttons
	if config.has("buttons"):
	_setup_action_buttons(config.buttons)

			# Apply button sizing
	if config.has("button_size"):
	button_size = config.button_size
	_update_button_sizes()

	# ORPHANED REF: if config.has("icon_size"):
	# ORPHANED REF: icon_size = config.icon_size
	_update_button_sizes()


func add_action_button(action_config: Dictionary) -> Button:
	"""Add an action button with configuration"""
func remove_action_button(action: String) -> void:
	"""Remove an action button"""
	if action_buttons.has(action):
func get_action_button(action: String) -> Button:
	"""Get action button by action name"""
	return action_buttons.get(action)


func enable_action(action: String, enabled: bool = true) -> void:
	"""Enable or disable an action button"""
	if action_buttons.has(action):
	action_buttons[action].disabled = not enabled


func set_action_visible(action: String, visible: bool = true) -> void:
	"""Show or hide an action button"""
	if action_buttons.has(action):
	action_buttons[action].visible = visible


func add_separator() -> void:
	# ORPHANED REF: """Add a visual separator between button groups"""
func update_responsive_config(config: Dictionary) -> void:
	"""Update actions for responsive layout"""
	is_mobile = config.get("is_mobile", false)

	if is_mobile:
		# Smaller buttons and different layout on mobile
	button_size = Vector2(100, 32)
	# ORPHANED REF: icon_size = Vector2(32, 32)

		# Switch to vertical layout if too many buttons
	if action_buttons.size() > 3:
	actions_layout_mode = "vertical"
	_update_layout_mode()
else:
				# Desktop sizing
	button_size = Vector2(120, 36)
	# ORPHANED REF: icon_size = Vector2(36, 36)
	actions_layout_mode = "horizontal"
	_update_layout_mode()

	_update_button_sizes()


func apply_theme(theme: String) -> void:
	"""Apply theme to actions"""
	# ORPHANED REF: current_theme = theme

	# Update all buttons with theme
	for action in action_buttons:
func apply_preset(preset_name: String) -> void:
	"""Apply a preset button configuration"""
	match preset_name:
	"educational":
		configure_actions(
		{
	"buttons":
		[
	# ORPHANED REF: {"action": "notes", "text": "Study Notes", "icon": "📝", "type": "primary"},
	# ORPHANED REF: {"action": "quiz", "text": "Quiz", "icon": "🧠", "type": "secondary"},
	# ORPHANED REF: {"action": "related", "text": "Related", "icon": "🔗", "type": "secondary"}
		]
		}
		)

	"research":
		configure_actions(
		{
	"buttons":
		[
		{
	"action": "bookmark",
	# ORPHANED REF: "text": "Bookmark",
	# ORPHANED REF: "icon": "⭐",
	"type": "secondary"
		},
	# ORPHANED REF: {"action": "export", "text": "Export", "icon": "📋", "type": "secondary"},
	# ORPHANED REF: {"action": "compare", "text": "Compare", "icon": "⚖", "type": "secondary"},
	# ORPHANED REF: {"action": "history", "text": "History", "icon": "📈", "type": "secondary"}
		]
		}
		)

	"clinical":
		configure_actions(
		{
	"buttons":
		[
		{
	"action": "pathology",
	# ORPHANED REF: "text": "Pathology",
	# ORPHANED REF: "icon": "🔬",
	"type": "primary"
		},
		{
	"action": "symptoms",
	# ORPHANED REF: "text": "Symptoms",
	# ORPHANED REF: "icon": "📋",
	"type": "secondary"
		},
		{
	"action": "treatment",
	# ORPHANED REF: "text": "Treatment",
	# ORPHANED REF: "icon": "💊",
	"type": "secondary"
		}
		]
		}
		)

	"minimal":
		configure_actions(
		{
	"buttons":
		[
	# ORPHANED REF: {"action": "bookmark", "text": "", "icon": "⭐", "type": "secondary"},
	# ORPHANED REF: {"action": "share", "text": "", "icon": "📤", "type": "secondary"}
		]
		}
		)


										# === FACTORY METHOD ===
static func create_with_config(config: Dictionary) -> ActionsComponent:
	"""Factory method to create configured actions"""

	# ORPHANED REF: if icon != "":
	# ORPHANED REF: button.text = icon + " " + text if text != "" else icon

	# Set button size
	# ORPHANED REF: if icon != "" and text == "":
	# ORPHANED REF: button.custom_minimum_size = icon_size
else:
	button.custom_minimum_size = button_size

			# Apply styling
	# ORPHANED REF: UIThemeManager.apply_enhanced_button_style(button, button_type)
	UIThemeManager.add_hover_effect(button)

			# Connect signal
	button.pressed.connect(func(): _on_action_button_pressed(action, action_config))

			# Add to appropriate group or main container
	# ORPHANED REF: if group != "":
	# ORPHANED REF: _add_to_group(button, group)
else:
	add_child(button)

					# Track button
	action_buttons[action] = button
	button_added.emit(action, button)

	return button


	# ORPHANED REF: if group != "":
	# ORPHANED REF: _remove_from_group(button, group)

	button.queue_free()
	action_buttons.erase(action)
	button_removed.emit(action)


	if is_icon_only:
	# ORPHANED REF: button.custom_minimum_size = icon_size
else:
	button.custom_minimum_size = button_size


	if button.get_parent() == group_container:
	group_container.remove_child(button)

	# Remove empty groups
	if group_container.get_child_count() == 0:
	group_container.queue_free()
	# ORPHANED REF: button_groups.erase(group_name)


	return tooltips.get(action, "Action: " + action.capitalize())


	return actions


static func create_with_preset(preset_name: String) -> ActionsComponent:
	"""Factory method to create actions with preset"""
	return actions

func _setup_actions_structure() -> void:
	"""Setup the actions layout"""

	# Configure container
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", UIThemeManager.get_spacing("enhanced_inline_gap"))

	# Add content margins
	add_theme_constant_override("margin_left", UIThemeManager.get_spacing("md"))
	add_theme_constant_override("margin_right", UIThemeManager.get_spacing("md"))
	add_theme_constant_override("margin_top", UIThemeManager.get_spacing("sm"))
	add_theme_constant_override("margin_bottom", UIThemeManager.get_spacing("md"))


func _apply_actions_styling() -> void:
	"""Apply styling to actions container"""

	# Add subtle top border
func _setup_action_buttons(buttons_config: Array) -> void:
	"""Setup action buttons from configuration"""

	# Clear existing buttons
	for child in get_children():
	child.queue_free()
	action_buttons.clear()
	# ORPHANED REF: button_groups.clear()
	# ORPHANED REF: separator_count = 0

		# Create new buttons
	for button_config in buttons_config:
	if typeof(button_config) == TYPE_DICTIONARY:
	add_action_button(button_config)
	elif typeof(button_config) == TYPE_STRING:
					# Simple string button
	# ORPHANED REF: add_action_button({"action": button_config, "text": button_config.capitalize()})


func _update_layout_mode() -> void:
	"""Update container layout based on mode"""
	match actions_layout_mode:
	"vertical":
			# For vertical layout, just change alignment
			# Note: ActionsComponent extends HBoxContainer, so we can't change to VBox
			# but we can adjust button arrangement
		alignment = BoxContainer.ALIGNMENT_CENTER
	"horizontal":
		alignment = BoxContainer.ALIGNMENT_CENTER
	"grid":
					# Could implement grid layout here
		alignment = BoxContainer.ALIGNMENT_CENTER


func _update_button_sizes() -> void:
	"""Update all button sizes"""
	for action in action_buttons:
func _add_to_group(button: Button, group_name: String) -> void:
	# ORPHANED REF: """Add button to a named group"""
	# ORPHANED REF: if not button_groups.has(group_name):
		# Create group container
func _remove_from_group(button: Button, group_name: String) -> void:
	# ORPHANED REF: """Remove button from group"""
	# ORPHANED REF: if button_groups.has(group_name):
func _get_default_tooltip(action: String) -> String:
	# ORPHANED REF: """Get default tooltip for action"""
func _on_action_button_pressed(action: String, config: Dictionary) -> void:
	"""Handle action button press"""

	# Add button press animation
	if action_buttons.has(action) and FeatureFlags.is_enabled(FeatureFlags.ADVANCED_ANIMATIONS):

	pass
