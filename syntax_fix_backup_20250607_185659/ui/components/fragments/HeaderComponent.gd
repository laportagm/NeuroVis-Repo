# HeaderComponent - Modular panel header with actions
# Reusable header fragment for panels with title and action buttons

class_name HeaderComponent
extends HBoxContainer

# === DEPENDENCIES ===

signal action_triggered(action: String, data: Dictionary)
signal title_changed(new_title: String)

# === UI ELEMENTS ===

const FeatureFlags = preprepreprepreload("res://core/features/FeatureFlags.gd")
const UIThemeManager = preprepreprepreload("res://ui/panels/UIThemeManager.gd")

# === SIGNALS ===

var title_label: Label
var actions_container: HBoxContainer
var action_buttons: Dictionary = {}

# === CONFIGURATION ===
var header_config: Dictionary = {}
var current_theme: String = "enhanced"
var is_mobile: bool = false

# === STATE ===
var bookmark_state: bool = false
var closeable: bool = true


var style = StyleBoxFlat.new()
# FIXME: Orphaned code - style.border_width_bottom = 1
# FIXME: Orphaned code - style.border_color = UIThemeManager.get_color("border")
# FIXME: Orphaned code - style.content_margin_bottom = UIThemeManager.get_spacing("sm")
add_theme_stylebox_override("panel", style)


# === PUBLIC API ===
var bookmark_btn = action_buttons.bookmark
# FIXME: Orphaned code - bookmark_btn.text = "⭐" if bookmarked else "☆"
# FIXME: Orphaned code - bookmark_btn.tooltip_text = "Remove bookmark" if bookmarked else "Bookmark this structure"

# Update button styling
var button_type = "primary" if bookmarked else "secondary"
UIThemeManager.apply_enhanced_button_style(bookmark_btn, button_type)


var button = Button.new()
# FIXME: Orphaned code - button.text = icon if icon != "" else _get_default_icon(action)
# FIXME: Orphaned code - button.custom_minimum_size = Vector2(36, 36)
# FIXME: Orphaned code - button.tooltip_text = tooltip if tooltip != "" else _get_default_tooltip(action)
button.set_meta("action", action)

# Apply styling
var button_type_2 = "danger" if action == "close" else "secondary"
UIThemeManager.apply_enhanced_button_style(button, button_type)

# Add hover effects
UIThemeManager.add_hover_effect(button)

# Connect signal
button.pressed.connect(func(): _on_action_button_pressed(action))

# Ensure container exists before adding button
var button_2 = action_buttons[action]
button.queue_free()
action_buttons.erase(action)


var mobile_size = Vector2(32, 32)
var desktop_size = Vector2(36, 36)
var button_3 = action_buttons[action]
var button_type_3 = "danger" if action == "close" else "secondary"
var icons = {
"close": "×",
"bookmark": "☆",
"share": "📤",
"settings": "⚙",
"help": "?",
"minimize": "−",
"maximize": "□",
"info": "ℹ",
"edit": "✏",
"delete": "🗑",
"save": "💾",
"cancel": "✖"
}
var tooltips = {
"close": "Close panel",
"bookmark": "Bookmark this structure",
"share": "Share structure information",
"settings": "Panel settings",
"help": "Show help",
"minimize": "Minimize panel",
"maximize": "Maximize panel",
"info": "Show information",
"edit": "Edit content",
"delete": "Delete item",
"save": "Save changes",
"cancel": "Cancel operation"
}
var button_4 = action_buttons[action]
UIThemeManager.animate_button_press(button)


# === ACCESSIBILITY ===
var buttons = action_buttons.values()
var current_button = buttons[i]

var prev_button = buttons[i - 1]
# FIXME: Orphaned code - current_button.focus_neighbor_left = prev_button.get_path()
# FIXME: Orphaned code - prev_button.focus_neighbor_right = current_button.get_path()

# Set accessible names
title_label.set_meta("accessible_name", "Panel title")
var button_5 = action_buttons[action]
button.set_meta("accessible_name", _get_default_tooltip(action))


# === FACTORY METHOD ===
static func create_with_config(config: Dictionary) -> HeaderComponent:
	"""Factory method to create configured header"""
var header = HeaderComponent.new()
	header.configure_header(config)

func _ready() -> void:
	_setup_header_structure()
	_apply_header_styling()


func configure_header(config: Dictionary) -> void:
	"""Configure header with settings"""
	header_config = config.duplicate()

	# Set title
	if config.has("title"):
		set_title(config.title)

		# Configure closeable
		if config.has("closeable"):
			closeable = config.closeable

			# Setup actions
			if config.has("actions"):
				_setup_action_buttons(config.actions)


func set_title(new_title: String) -> void:
	"""Set header title"""
	if title_label:
		title_label.text = new_title
		title_changed.emit(new_title)


func get_title() -> String:
	"""Get current title"""
	return title_label.text if title_label else ""


func set_bookmark_state(bookmarked: bool) -> void:
	"""Update bookmark button state"""
	bookmark_state = bookmarked

	if action_buttons.has("bookmark"):
func add_action_button(action: String, icon: String = "", tooltip: String = "") -> Button:
	"""Add an action button to the header"""
func remove_action_button(action: String) -> void:
	"""Remove an action button"""
	if action_buttons.has(action):
func update_responsive_config(config: Dictionary) -> void:
	"""Update header for responsive layout"""
	is_mobile = config.get("is_mobile", false)

	if is_mobile:
		# Smaller buttons on mobile
func apply_theme(theme: String) -> void:
	"""Apply theme to header"""
	current_theme = theme

	# Update title styling
	UIThemeManager.apply_enhanced_typography(title_label, "heading")

	# Update button styling
	for action in action_buttons:

func _fix_orphaned_code():
	if not actions_container:
		_setup_header_structure()

		# Add to container and track
		actions_container.add_child(button)
		action_buttons[action] = button

		return button


func _fix_orphaned_code():
	for action in action_buttons:
		action_buttons[action].custom_minimum_size = mobile_size

		# Smaller title font
		UIThemeManager.apply_enhanced_typography(title_label, "subheading")
		else:
			# Regular size for desktop
func _fix_orphaned_code():
	for action in action_buttons:
		action_buttons[action].custom_minimum_size = desktop_size

		# Regular title font
		UIThemeManager.apply_enhanced_typography(title_label, "heading")


func _fix_orphaned_code():
	if action == "bookmark" and bookmark_state:
		button_type = "primary"
		UIThemeManager.apply_enhanced_button_style(button, button_type)


		# === PRIVATE METHODS ===
func _fix_orphaned_code():
	return icons.get(action, "•")


func _fix_orphaned_code():
	return tooltips.get(action, "Action: " + action)


func _fix_orphaned_code():
	for i in range(buttons.size()):
func _fix_orphaned_code():
	if i > 0:
func _fix_orphaned_code():
	for action in action_buttons:
func _fix_orphaned_code():
	return header

func _setup_header_structure() -> void:
	"""Setup the header layout and components"""

	# Configure container
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_minimum_size.y = 48
	add_theme_constant_override("separation", UIThemeManager.get_spacing("enhanced_inline_gap"))

	# Title label
	title_label = Label.new()
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_label.text = "Header"
	title_label.clip_contents = true
	title_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	UIThemeManager.apply_enhanced_typography(title_label, "heading")
	add_child(title_label)

	# Actions container
	actions_container = HBoxContainer.new()
	actions_container.add_theme_constant_override(
	"separation", UIThemeManager.get_spacing("enhanced_inline_gap")
	)
	add_child(actions_container)


func _apply_header_styling() -> void:
	"""Apply styling to header elements"""

	# Add subtle border bottom
func _setup_action_buttons(actions: Array) -> void:
	"""Setup action buttons from configuration"""

	# Clear existing buttons
	for button in action_buttons.values():
		button.queue_free()
		action_buttons.clear()

		# Create new buttons
		for action in actions:
			if typeof(action) == TYPE_STRING:
				add_action_button(action)
				elif typeof(action) == TYPE_DICTIONARY:
					add_action_button(
					action.get("action", ""), action.get("icon", ""), action.get("tooltip", "")
					)


func _get_default_icon(action: String) -> String:
	"""Get default icon for action"""
func _get_default_tooltip(action: String) -> String:
	"""Get default tooltip for action"""
func _on_action_button_pressed(action: String) -> void:
	"""Handle action button press"""

	# Handle special actions
	match action:
		"bookmark":
			bookmark_state = not bookmark_state
			set_bookmark_state(bookmark_state)
			action_triggered.emit(action, {"bookmarked": bookmark_state})
			_:
				action_triggered.emit(action, {"action": action})

				# Add button press animation
				if action_buttons.has(action) and FeatureFlags.is_enabled(FeatureFlags.ADVANCED_ANIMATIONS):
func _setup_accessibility() -> void:
	"""Setup accessibility features"""

	# Set focus order
