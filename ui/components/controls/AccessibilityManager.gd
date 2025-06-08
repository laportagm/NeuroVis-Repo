# Accessibility Manager for NeuroVis
# Provides comprehensive accessibility features for UI components

class_name AccessibilityManager
extends RefCounted

# === ACCESSIBILITY SIGNALS ===

signal accessibility_mode_changed(enabled: bool)
signal screen_reader_announcement(text: String, priority: String)
signal keyboard_navigation_changed(active: bool)
signal high_contrast_toggled(enabled: bool)

# === ACCESSIBILITY SETTINGS ===
static var accessibility_enabled: bool = true
static var screen_reader_enabled: bool = false
static var keyboard_navigation_enabled: bool = true
static var high_contrast_mode: bool = false
static var reduced_motion: bool = false
static var font_size_scale: float = 1.0
static var focus_indicators_enhanced: bool = true

# === KEYBOARD NAVIGATION ===
static var current_focus_group: Array = []
static var focus_index: int = 0
static var navigation_stack: Array = []

# === SCREEN READER ===

enum AnnouncementPriority { LOW, MEDIUM, HIGH, URGENT }
static var announcement_queue: Array = []
static var last_announcement_time: float = 0.0

# === ACCESSIBILITY FEATURES ===

const WCAG_CONTRAST_RATIOS = {
"AA_normal": 4.5, "AA_large": 3.0, "AAA_normal": 7.0, "AAA_large": 4.5
}

const TOUCH_TARGET_SIZES = {"minimum": 44, "recommended": 48, "comfortable": 56}  # pixels (WCAG 2.1 Level AA)  # pixels  # pixels


# === INITIALIZATION ===
static func initialize() -> void:
	"""Initialize accessibility system"""
	_load_accessibility_settings()
	_setup_global_shortcuts()

	# FIXED: Orphaned code - var role = _determine_component_role(component)
	# ORPHANED REF: component.set_meta("accessibility_role", role)

	# FIXED: Orphaned code - var label = component.name.replace("_", " ").capitalize()
	# ORPHANED REF: component.set_meta("accessibility_label", label)

	# Set accessible description from tooltip if available
	var next_component = current_focus_group[focus_index]

	var prev_component = current_focus_group[focus_index]

	var previous_context = navigation_stack.pop_back()
	current_focus_group = previous_context.focus_group
	focus_index = previous_context.focus_index


	# === SCREEN READER SUPPORT ===
	static func announce(
text: String, priority: AnnouncementPriority = AnnouncementPriority.MEDIUM
	) -> void:
	"""Announce text to screen reader"""
	var announcement = {
"text": text, "priority": priority, "timestamp": Time.get_time_string_from_system()
	}

	# Add to queue based on priority
	AnnouncementPriority.URGENT:
	announcement_queue.push_front(announcement)
	AnnouncementPriority.HIGH:
	announcement_queue.insert(0, announcement)
_:
	announcement_queue.append(announcement)

	_process_announcement_queue()


static func announce_focus_change(component: Control) -> void:
	"""Announce when focus changes to a component"""
	var role_2 = component.get_meta("accessibility_role", "element")
	# FIXED: Orphaned code - var label_2 = component.get_meta("accessibility_label", component.name)
	# FIXED: Orphaned code - var description = component.get_meta("accessibility_description", "")

	# FIXED: Orphaned code - var announcement_2 = label + ", " + role
	var current_time = Time.get_time_string_from_system()
	# FIXED: Orphaned code - var announcement_3 = announcement_queue.pop_front()
	last_announcement_time = current_time

	# In a real implementation, this would interface with platform screen readers
	var bg_color = Color.BLACK
	var text_color = Color.WHITE
	var accent_color = Color.YELLOW
	var border_color = Color.WHITE

	var style = StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	component.add_theme_stylebox_override("normal", style)
	component.add_theme_color_override("font_color", text_color)
	# FIXED: Orphaned code - var style_2 = StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	component.add_theme_stylebox_override("panel", style)


static func _apply_high_contrast_to_all_components() -> void:
	"""Apply high contrast mode to all registered components"""
	var current_size = 14  # Default size

	var min_size = TOUCH_TARGET_SIZES.minimum
	var current_size_2 = component.custom_minimum_size

	var tween = component.create_tween()
	tween.tween_property(component, "modulate", Color(1.2, 1.2, 1.2), 0.2)

	# Add focus outline (if supported)
	# FIXED: Orphaned code - var focus_style = StyleBoxFlat.new()
	# ORPHANED REF: focus_style.bg_color = Color.TRANSPARENT
	# ORPHANED REF: focus_style.border_color = Color.CYAN
	# ORPHANED REF: focus_style.border_width_left = 2
	# ORPHANED REF: focus_style.border_width_right = 2
	# ORPHANED REF: focus_style.border_width_top = 2
	# ORPHANED REF: focus_style.border_width_bottom = 2
	# ORPHANED REF: component.add_theme_stylebox_override("focus", focus_style)


static func _on_component_focus_exited(component: Control) -> void:
	"""Handle component focus lost"""
	var tween_2 = component.create_tween()
	tween.tween_property(component, "modulate", Color.WHITE, 0.2)


static func _on_component_input(event: InputEvent, component: Control) -> void:
	"""Handle component input for keyboard navigation"""
	var key_event = event as InputEventKey
	var fg_luminance = _calculate_relative_luminance(foreground)
	# FIXED: Orphaned code - var bg_luminance = _calculate_relative_luminance(background)

	# FIXED: Orphaned code - var lighter = max(fg_luminance, bg_luminance)
	# FIXED: Orphaned code - var darker = min(fg_luminance, bg_luminance)

	# FIXED: Orphaned code - var r = _linearize_color_component(color.r)
	# FIXED: Orphaned code - var g = _linearize_color_component(color.g)
	# FIXED: Orphaned code - var b = _linearize_color_component(color.b)

	# FIXED: Orphaned code - var contrast_ratio = check_color_contrast(foreground, background)
	# FIXED: Orphaned code - var required_ratio: float

"AA":
	# ORPHANED REF: required_ratio = (
	WCAG_CONTRAST_RATIOS.AA_large if large_text else WCAG_CONTRAST_RATIOS.AA_normal
	)
"AAA":
	# ORPHANED REF: required_ratio = (
	WCAG_CONTRAST_RATIOS.AAA_large if large_text else WCAG_CONTRAST_RATIOS.AAA_normal
	)
_:
	# ORPHANED REF: required_ratio = WCAG_CONTRAST_RATIOS.AA_normal

	print("[AccessibilityManager] Accessibility system initialized")


static func _load_accessibility_settings() -> void:
	"""Load accessibility settings from user preferences"""
	# In a real implementation, load from user settings file
	accessibility_enabled = true
	keyboard_navigation_enabled = true
	high_contrast_mode = false
	reduced_motion = false
	font_size_scale = 1.0


static func _setup_global_shortcuts() -> void:
	"""Setup global accessibility shortcuts"""
		# These would be connected to the main scene's input handling
	pass


		# === COMPONENT REGISTRATION ===
static func register_component(component: Control) -> void:
	"""Register a component for accessibility features"""
	if not accessibility_enabled or not component:
	return

	_setup_component_accessibility(component)
	_add_to_navigation_group(component)


static func _setup_component_accessibility(component: Control) -> void:
	"""Setup accessibility features for a component"""
					# Set focus mode if not set
	if component.focus_mode == Control.FOCUS_NONE:
	if component is Button or component is LineEdit or component is OptionButton:
	component.focus_mode = Control.FOCUS_ALL
else:
	component.focus_mode = Control.FOCUS_CLICK

								# Setup ARIA-like properties
	_setup_aria_properties(component)

								# Add focus indicators
	if focus_indicators_enhanced:
	_add_focus_indicators(component)

									# Setup keyboard handlers
	if keyboard_navigation_enabled:
	_setup_keyboard_navigation(component)

										# Apply accessibility styling
	_apply_accessibility_styling(component)


static func _setup_aria_properties(component: Control) -> void:
	"""Setup ARIA-like properties for screen readers"""
	if not component.has_meta("accessibility_role"):
	if not component.has_meta("accessibility_label") and component.name != "":
	if component.tooltip_text != "" and not component.has_meta("accessibility_description"):
	component.set_meta("accessibility_description", component.tooltip_text)


static func _determine_component_role(component: Control) -> String:
	# ORPHANED REF: """Determine ARIA role for component"""
	if component is Button:
	return "button"
	elif component is Label:
	return "text"
	elif component is LineEdit:
	return "textbox"
	elif component is OptionButton:
	return "combobox"
	elif component is CheckBox:
	return "checkbox"
	elif component is Slider:
	return "slider"
	elif component is ProgressBar:
	return "progressbar"
	elif component is TabContainer:
	return "tablist"
	elif component is Panel or component is PanelContainer:
	return "region"
else:
	return "generic"


static func _add_focus_indicators(component: Control) -> void:
	"""Add enhanced focus indicators"""
	if not component.has_signal("focus_entered"):
	return

	component.focus_entered.connect(_on_component_focus_entered.bind(component))
	component.focus_exited.connect(_on_component_focus_exited.bind(component))


static func _setup_keyboard_navigation(component: Control) -> void:
	"""Setup keyboard navigation for component"""
	if not component.has_signal("gui_input"):
	return

	component.gui_input.connect(_on_component_input.bind(component))


static func _apply_accessibility_styling(component: Control) -> void:
	"""Apply accessibility-specific styling"""
	if high_contrast_mode:
	_apply_high_contrast_styling(component)

	if font_size_scale != 1.0:
	_apply_font_scaling(component)

																			# Ensure minimum touch target sizes
	_ensure_touch_target_size(component)


																			# === KEYBOARD NAVIGATION ===
static func _add_to_navigation_group(component: Control) -> void:
	"""Add component to keyboard navigation group"""
	if not keyboard_navigation_enabled:
	return

	if component.focus_mode != Control.FOCUS_NONE:
	current_focus_group.append(component)


static func navigate_next() -> void:
	"""Navigate to next focusable element"""
	if current_focus_group.is_empty():
	return

	focus_index = (focus_index + 1) % current_focus_group.size()
	if next_component and is_instance_valid(next_component) and next_component.visible:
	next_component.grab_focus()
	announce_focus_change(next_component)
else:
		# Remove invalid component and try again
	current_focus_group.erase(next_component)
	navigate_next()


static func navigate_previous() -> void:
	"""Navigate to previous focusable element"""
	if current_focus_group.is_empty():
	return

	focus_index = (focus_index - 1) % current_focus_group.size()
	if focus_index < 0:
	focus_index = current_focus_group.size() - 1

	if prev_component and is_instance_valid(prev_component) and prev_component.visible:
	prev_component.grab_focus()
	announce_focus_change(prev_component)
else:
		# Remove invalid component and try again
	current_focus_group.erase(prev_component)
	navigate_previous()


static func push_navigation_context(components: Array) -> void:
	# ORPHANED REF: """Push new navigation context (e.g., for modal dialogs)"""
	navigation_stack.append(
	{"focus_group": current_focus_group.duplicate(), "focus_index": focus_index}
	)

	current_focus_group = components
	focus_index = 0


static func pop_navigation_context() -> void:
	"""Pop navigation context"""
	if navigation_stack.is_empty():
	return

	if not screen_reader_enabled or text.is_empty():
	return

	if not component:
	return

	# ORPHANED REF: if description != "":
	# ORPHANED REF: announcement += ", " + description

	# Add state information
	if component is Button and component.disabled:
	announcement += ", disabled"
	elif component is CheckBox:
	announcement += ", " + ("checked" if component.button_pressed else "unchecked")
	elif component is Slider:
	announcement += ", value " + str(component.value)

	announce(announcement, AnnouncementPriority.MEDIUM)


static func _process_announcement_queue() -> void:
	"""Process the announcement queue"""
	if announcement_queue.is_empty():
	return

	if current_time == last_announcement_time:
	return  # Prevent spam

	print("[ScreenReader] " + announcement.text)


# === HIGH CONTRAST MODE ===
static func toggle_high_contrast() -> void:
	"""Toggle high contrast mode"""
	high_contrast_mode = not high_contrast_mode
	_apply_high_contrast_to_all_components()
	print("[AccessibilityManager] High contrast mode: " + str(high_contrast_mode))


static func _apply_high_contrast_styling(component: Control) -> void:
	"""Apply high contrast styling to component"""
	if not high_contrast_mode:
	return

			# High contrast color scheme
	if component is Label:
	component.add_theme_color_override("font_color", text_color)
	elif component is Button:
	for component in current_focus_group:
	if is_instance_valid(component):
	_apply_accessibility_styling(component)


		# === FONT SCALING ===
static func set_font_scale(scale: float) -> void:
	"""Set global font scaling factor"""
	font_size_scale = clamp(scale, 0.5, 3.0)
	_apply_font_scaling_to_all_components()
	print("[AccessibilityManager] Font scale set to: " + str(font_size_scale))


static func _apply_font_scaling(component: Control) -> void:
	"""Apply font scaling to component"""
	if font_size_scale == 1.0:
	return

	if component is Label:
	current_size = component.get_theme_font_size("font_size")
	if current_size <= 0:
	current_size = 14
	component.add_theme_font_size_override("font_size", int(current_size * font_size_scale))
	elif component is Button:
	current_size = component.get_theme_font_size("font_size")
	if current_size <= 0:
	current_size = 14
	component.add_theme_font_size_override("font_size", int(current_size * font_size_scale))


static func _apply_font_scaling_to_all_components() -> void:
	"""Apply font scaling to all registered components"""
	for component in current_focus_group:
	if is_instance_valid(component):
	_apply_font_scaling(component)


							# === TOUCH TARGET SIZING ===
static func _ensure_touch_target_size(component: Control) -> void:
	"""Ensure component meets minimum touch target size"""
	if not (component is Button or component is CheckBox or component is OptionButton):
	return

	if current_size.x < min_size:
	current_size.x = min_size
	if current_size.y < min_size:
	current_size.y = min_size

	component.custom_minimum_size = current_size


		# === EVENT HANDLERS ===
static func _on_component_focus_entered(component: Control) -> void:
	"""Handle component focus gained"""
	if not focus_indicators_enhanced:
	return

				# Add focus highlight
	if component.has_method("add_theme_stylebox_override"):
	if not focus_indicators_enhanced:
	return

	# Remove focus highlight
	if not keyboard_navigation_enabled or not event is InputEventKey:
	return

	if not key_event.pressed:
	return

	match key_event.keycode:
	KEY_TAB:
		if key_event.shift_pressed:
		navigate_previous()
	else:
		navigate_next()
		component.get_viewport().set_input_as_handled()
		KEY_ENTER, KEY_SPACE:
		if component is Button:
		component.pressed.emit()
		announce("Button activated", AnnouncementPriority.MEDIUM)
		component.get_viewport().set_input_as_handled()
	KEY_ESCAPE:
		if navigation_stack.size() > 0:
		pop_navigation_context()
		component.get_viewport().set_input_as_handled()


									# === UTILITY METHODS ===
static func check_color_contrast(foreground: Color, background: Color) -> float:
	"""Check color contrast ratio between foreground and background"""
	# ORPHANED REF: return (lighter + 0.05) / (darker + 0.05)


static func _calculate_relative_luminance(color: Color) -> float:
	"""Calculate relative luminance for contrast ratio"""
	# ORPHANED REF: return 0.2126 * r + 0.7152 * g + 0.0722 * b


static func _linearize_color_component(component: float) -> float:
	"""Linearize color component for luminance calculation"""
	if component <= 0.03928:
	return component / 12.92
else:
	return pow((component + 0.055) / 1.055, 2.4)


	static func is_contrast_sufficient(
foreground: Color, background: Color, level: String = "AA", large_text: bool = false
	) -> bool:
	"""Check if contrast meets WCAG guidelines"""
	# ORPHANED REF: return contrast_ratio >= required_ratio


# === PUBLIC API ===
static func set_accessibility_enabled(enabled: bool) -> void:
	"""Enable/disable accessibility features"""
	accessibility_enabled = enabled
	print("[AccessibilityManager] Accessibility " + ("enabled" if enabled else "disabled"))


static func set_screen_reader_enabled(enabled: bool) -> void:
	"""Enable/disable screen reader support"""
	screen_reader_enabled = enabled
	print("[AccessibilityManager] Screen reader " + ("enabled" if enabled else "disabled"))


static func set_keyboard_navigation_enabled(enabled: bool) -> void:
	"""Enable/disable keyboard navigation"""
	keyboard_navigation_enabled = enabled
	print("[AccessibilityManager] Keyboard navigation " + ("enabled" if enabled else "disabled"))


static func get_accessibility_info() -> Dictionary:
	"""Get current accessibility settings"""
	return {
"accessibility_enabled": accessibility_enabled,
"screen_reader_enabled": screen_reader_enabled,
"keyboard_navigation_enabled": keyboard_navigation_enabled,
"high_contrast_mode": high_contrast_mode,
"reduced_motion": reduced_motion,
"font_size_scale": font_size_scale,
"focus_indicators_enhanced": focus_indicators_enhanced,
"registered_components": current_focus_group.size()
	}
