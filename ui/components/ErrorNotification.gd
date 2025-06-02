## ErrorNotification.gd
## Educational error notification component for NeuroVis
##
## Displays educational-context-aware error messages with appropriate styling
## and accessibility features for the educational neuroscience platform.
##
## @educational_context: Error handling in educational environment
## @version: 2.1

# Preload UIThemeManager for direct access instead of autoload dependency
# Use load() for more flexibility in testing environments
var UIThemeManagerScript = null

func _init():
    # Safely load UIThemeManager
    if ResourceLoader.exists("res://ui/panels/UIThemeManager.gd"):
        UIThemeManagerScript = load("res://ui/panels/UIThemeManager.gd")

class_name ErrorNotification
extends Control

# === CONSTANTS ===
const DISPLAY_DURATION: float = 5.0
const FADE_DURATION: float = 0.3
const ERROR_ICON: String = "⚠️"
const WARNING_ICON: String = "⚡"
const INFO_ICON: String = "ℹ️"

# === EXPORTS ===
@export var auto_dismiss: bool = true
@export var dismiss_duration: float = DISPLAY_DURATION
@export var notification_type: NotificationType = NotificationType.ERROR

# === ENUMS ===
enum NotificationType { ERROR, WARNING, INFO, SUCCESS }

# === SIGNALS ===
## Emitted when the notification is dismissed
signal notification_dismissed()

## Emitted when the notification is clicked
signal notification_clicked()

# === PRIVATE VARIABLES ===
var _label: Label
var _close_button: Button
var _icon_label: Label
var _background_panel: Panel
var _dismiss_timer: Timer

# === LIFECYCLE METHODS ===
func _ready() -> void:
	"""Initialize the error notification component"""
	# Check if we're in core development mode
	if Engine.has_singleton("FeatureFlags"):
		var FeatureFlagsRef = Engine.get_singleton("FeatureFlags")
		if FeatureFlagsRef.call("is_core_development_mode"):
			print("[ErrorNotification] Core development mode - using minimal UI")
	
	_setup_ui_structure()
	_apply_educational_theme()
	_setup_interactions()
	
	# Start auto-dismiss timer if enabled
	if auto_dismiss:
		_start_dismiss_timer()

# === PUBLIC METHODS ===
## Display an educational error message
## @param message: The error message to display
## @param type: The type of notification (error, warning, info, success)
func show_notification(message: String, type: NotificationType = NotificationType.ERROR) -> void:
	"""Display an educational error notification"""
	notification_type = type
	
	if _label:
		_label.text = message
	
	if _icon_label:
		_icon_label.text = _get_icon_for_type(type)
	
	_apply_type_styling(type)
	
	# Animate entrance
	# Access UIThemeManager safely through script or autoload
	if Engine.has_singleton("UIThemeManager"):
		UIThemeManager.animate_enhanced_entrance(self)
	elif UIThemeManagerScript != null:
		# Use direct script reference if autoload is not available
		UIThemeManagerScript.animate_enhanced_entrance(self)
	else:
		# Fallback animation if no UIThemeManager is available
		_animate_entrance_fallback()
	
	# Reset dismiss timer
	if auto_dismiss and _dismiss_timer:
		_dismiss_timer.start(dismiss_duration)

# Simple fallback animation when UIThemeManager is not available
func _animate_entrance_fallback() -> void:
	"""Fallback animation for testing environments"""
	modulate = Color.TRANSPARENT
	scale = Vector2(0.9, 0.9)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate", Color.WHITE, 0.4)
	tween.tween_property(self, "scale", Vector2.ONE, 0.4)

## Dismiss the notification
func dismiss_notification() -> void:
	"""Dismiss the notification with animation"""
	if _dismiss_timer:
		_dismiss_timer.stop()
	
	# Animate exit
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, FADE_DURATION)
	tween.tween_callback(_on_notification_dismissed)

## Set the notification message
## @param message: The message text to display
func set_message(message: String) -> void:
	"""Set the notification message"""
	if _label:
		_label.text = message

# === PRIVATE METHODS ===
func _setup_ui_structure() -> void:
	"""Setup the UI structure for the notification"""
	# Main background panel
	_background_panel = Panel.new()
	_background_panel.name = "BackgroundPanel"
	add_child(_background_panel)
	
	# Container for content
	var container = HBoxContainer.new()
	container.name = "ContentContainer"
	_background_panel.add_child(container)
	
	# Icon label
	_icon_label = Label.new()
	_icon_label.name = "IconLabel"
	_icon_label.text = ERROR_ICON
	container.add_child(_icon_label)
	
	# Message label
	_label = Label.new()
	_label.name = "MessageLabel"
	_label.text = "Error message"
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.add_child(_label)
	
	# Close button
	_close_button = Button.new()
	_close_button.name = "CloseButton"
	_close_button.text = "✕"
	_close_button.custom_minimum_size = Vector2(32, 32)
	container.add_child(_close_button)
	
	# Dismiss timer
	_dismiss_timer = Timer.new()
	_dismiss_timer.name = "DismissTimer"
	_dismiss_timer.wait_time = dismiss_duration
	_dismiss_timer.one_shot = true
	add_child(_dismiss_timer)

func _apply_educational_theme() -> void:
	"""Apply educational theme styling"""
	# Set size and position regardless of theme availability
	custom_minimum_size = Vector2(320, 80)
	anchor_left = 1.0
	anchor_right = 1.0
	anchor_top = 0.0
	anchor_bottom = 0.0
	offset_left = -340  # Position from right edge
	offset_right = -20
	offset_top = 20
	offset_bottom = 100
	
	# Check if UIThemeManager is available
	if UIThemeManagerScript == null:
		_apply_fallback_styling()
		return
	
	# Access UIThemeManager safely through script or autoload
	var theme_manager = UIThemeManagerScript
	
	# Apply panel styling
	theme_manager.apply_enhanced_panel_style(_background_panel, "elevated")
	
	# Apply typography
	theme_manager.apply_enhanced_typography(_icon_label, "heading")
	theme_manager.apply_enhanced_typography(_label, "body")
	theme_manager.apply_enhanced_typography(_close_button, "small")
	
	# Apply button styling
	theme_manager.apply_enhanced_button_style(_close_button, "secondary")

# Apply basic styling when UIThemeManager is not available (testing mode)
func _apply_fallback_styling() -> void:
	"""Apply minimal styling when UIThemeManager is unavailable"""
	if _background_panel:
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.15, 0.15, 0.15, 0.9)
		style.border_width_bottom = 1
		style.border_width_left = 1
		style.border_width_right = 1
		style.border_width_top = 1
		style.border_color = Color(1, 0, 0, 0.5)
		style.corner_radius_bottom_left = 8
		style.corner_radius_bottom_right = 8
		style.corner_radius_top_left = 8
		style.corner_radius_top_right = 8
		_background_panel.add_theme_stylebox_override("panel", style)
	
	if _label:
		_label.add_theme_font_size_override("font_size", 14)
		_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.9))
	
	if _icon_label:
		_icon_label.add_theme_font_size_override("font_size", 18)
		_icon_label.add_theme_color_override("font_color", Color(1, 0, 0, 0.9))
	
	if _close_button:
		_close_button.add_theme_font_size_override("font_size", 12)
		_close_button.add_theme_color_override("font_color", Color(1, 1, 1, 0.9))

func _apply_type_styling(type: NotificationType) -> void:
	"""Apply styling based on notification type"""
	var color: Color
	
	# Handle case when UIThemeManager is not available
	if UIThemeManagerScript == null:
		# Use fallback colors
		match type:
			NotificationType.ERROR:
				color = Color(1.0, 0.0, 0.0, 1.0)  # Red
			NotificationType.WARNING:
				color = Color(1.0, 0.7, 0.0, 1.0)  # Orange
			NotificationType.INFO:
				color = Color(0.0, 0.7, 1.0, 1.0)  # Blue
			NotificationType.SUCCESS:
				color = Color(0.0, 1.0, 0.4, 1.0)  # Green
			_:
				color = Color(1.0, 0.0, 0.0, 1.0)  # Red
	else:
		# Use theme manager colors
		var theme_manager = UIThemeManagerScript
		match type:
			NotificationType.ERROR:
				color = theme_manager.ACCENT_RED
			NotificationType.WARNING:
				color = theme_manager.ACCENT_ORANGE
			NotificationType.INFO:
				color = theme_manager.ACCENT_BLUE
			NotificationType.SUCCESS:
				color = theme_manager.ACCENT_GREEN
			_:
				color = theme_manager.ACCENT_RED
	
	# Apply color to icon
	if _icon_label:
		_icon_label.add_theme_color_override("font_color", color)
	
	# Apply border color if available
	if _background_panel and _background_panel.has_theme_stylebox("panel"):
		var style = _background_panel.get_theme_stylebox("panel").duplicate()
		if style is StyleBoxFlat:
			style.border_color = color
			_background_panel.add_theme_stylebox_override("panel", style)

func _setup_interactions() -> void:
	"""Setup interaction handling"""
	# Close button
	if _close_button:
		_close_button.pressed.connect(_on_close_button_pressed)
	
	# Dismiss timer
	if _dismiss_timer:
		_dismiss_timer.timeout.connect(_on_dismiss_timer_timeout)
	
	# Click to dismiss
	gui_input.connect(_on_notification_input)

func _get_icon_for_type(type: NotificationType) -> String:
	"""Get icon character for notification type"""
	match type:
		NotificationType.ERROR:
			return ERROR_ICON
		NotificationType.WARNING:
			return WARNING_ICON
		NotificationType.INFO:
			return INFO_ICON
		NotificationType.SUCCESS:
			return "✅"
		_:
			return ERROR_ICON

func _start_dismiss_timer() -> void:
	"""Start the auto-dismiss timer"""
	if _dismiss_timer:
		_dismiss_timer.start(dismiss_duration)

# === EVENT HANDLERS ===
func _on_close_button_pressed() -> void:
	"""Handle close button press"""
	dismiss_notification()

func _on_dismiss_timer_timeout() -> void:
	"""Handle auto-dismiss timer timeout"""
	dismiss_notification()

func _on_notification_input(event: InputEvent) -> void:
	"""Handle notification click"""
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		notification_clicked.emit()
		# Don't auto-dismiss on click, let the user decide

func _on_notification_dismissed() -> void:
	"""Handle notification dismissal"""
	notification_dismissed.emit()
	queue_free()

# === STATIC FACTORY METHODS ===
## Create and show an error notification
## @param message: Error message to display
## @param parent: Parent node to add notification to
## @returns: ErrorNotification instance
static func show_error(message: String, parent: Node) -> ErrorNotification:
	"""Factory method to create and show an error notification"""
	var notification = ErrorNotification.new()
	parent.add_child(notification)
	notification.show_notification(message, NotificationType.ERROR)
	return notification

## Create and show a warning notification
## @param message: Warning message to display
## @param parent: Parent node to add notification to
## @returns: ErrorNotification instance
static func show_warning(message: String, parent: Node) -> ErrorNotification:
	"""Factory method to create and show a warning notification"""
	var notification = ErrorNotification.new()
	parent.add_child(notification)
	notification.show_notification(message, NotificationType.WARNING)
	return notification

## Create and show an info notification
## @param message: Info message to display
## @param parent: Parent node to add notification to
## @returns: ErrorNotification instance
static func show_info(message: String, parent: Node) -> ErrorNotification:
	"""Factory method to create and show an info notification"""
	var notification = ErrorNotification.new()
	parent.add_child(notification)
	notification.show_notification(message, NotificationType.INFO)
	return notification

## Create and show a success notification
## @param message: Success message to display
## @param parent: Parent node to add notification to
## @returns: ErrorNotification instance
static func show_success(message: String, parent: Node) -> ErrorNotification:
	"""Factory method to create and show a success notification"""
	var notification = ErrorNotification.new()
	parent.add_child(notification)
	notification.show_notification(message, NotificationType.SUCCESS)
	return notification