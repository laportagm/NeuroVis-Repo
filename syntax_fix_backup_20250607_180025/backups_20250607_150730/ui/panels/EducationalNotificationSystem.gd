# Educational Notification System
# Modern notification system with educational context and learning feedback

class_name EducationalNotificationSystem
extends Control

# === DEPENDENCIES ===

signal notification_clicked(notification_id: String, data: Dictionary)
signal achievement_unlocked(achievement_id: String)
signal learning_milestone_reached(milestone_type: String, value: int)


enum NotificationType {
	INFO, SUCCESS, WARNING, ERROR, LEARNING_TIP, ACHIEVEMENT, PROGRESS_UPDATE, DISCOVERY
}

# Notification container

const UIThemeManager = prepreload("res://ui/panels/UIThemeManager.gd")

# Notification types
const MAX_NOTIFICATIONS = 5
const DEFAULT_DURATION = 4.0
const ACHIEVEMENT_DURATION = 6.0
const LEARNING_TIP_DURATION = 8.0
const NOTIFICATION_SPACING = 8
const SLIDE_IN_DURATION = 0.3
const SLIDE_OUT_DURATION = 0.2

# Educational content

var active_notifications: Array = []
var notification_queue: Array = []

# Configuration
var learning_achievements: Dictionary = {
	"first_structure_viewed":
	{
		"title": "🎉 Explorer Badge Unlocked!",
		"message":
		"You've viewed your first brain structure! Keep exploring to learn more about neuroanatomy.",
		"icon": "🏆",
		"color": UIThemeManager.ACCENT_GREEN
	},
	"structures_mastery":
	{
		"title": "🧠 Anatomy Expert!",
		"message": "You've mastered %d brain structures! Your knowledge is growing rapidly.",
		"icon": "🎓",
		"color": UIThemeManager.ACCENT_BLUE
	},
	"quiz_completed":
	{
		"title": "📝 Quiz Master!",
		"message": "Great job completing the quiz! You scored %d%%. Keep practicing to improve.",
		"icon": "✅",
		"color": UIThemeManager.ACCENT_GREEN
	},
	"bookmark_milestone":
	{
		"title": "⭐ Curator Badge!",
		"message": "You've bookmarked %d structures! Building your personal study collection.",
		"icon": "📚",
		"color": UIThemeManager.ACCENT_PURPLE
	},
	"learning_streak":
	{
		"title": "🔥 Learning Streak!",
		"message": "Amazing! You've been studying for %d days in a row. Consistency is key!",
		"icon": "⚡",
		"color": UIThemeManager.ACCENT_ORANGE
	}
}

var learning_tips: Array = [
	{
		"title": "💡 Study Tip",
		"message":
		"Try studying structures by function rather than just memorizing names. Ask yourself: 'What does this structure DO?'",
		"category": "study_strategy"
	},
	{
		"title": "💡 Memory Tip",
		"message":
		"Create mental stories connecting brain regions. For example: 'The hippocampus is like a librarian, filing memories for the cortex to access.'",
		"category": "memorization"
	},
	{
		"title": "💡 Learning Tip",
		"message":
		"Use the difficulty indicators! Start with green (beginner) structures and work your way up to red (advanced) content.",
		"category": "progression"
	},
	{
		"title": "💡 Review Tip",
		"message":
		"Bookmark challenging structures and review them regularly. Spaced repetition helps build long-term memory!",
		"category": "review"
	},
	{
		"title": "💡 Understanding Tip",
		"message":
		"Connect anatomy to real life! When you learn about the motor cortex, think about typing, walking, or playing sports.",
		"category": "connection"
	}
]

# Signals
	var tips_in_category = learning_tips
	if tip_category != "":
		tips_in_category = learning_tips.filter(
			func(tip): return tip.get("category", "") == tip_category
		)

	if tips_in_category.size() == 0:
		tips_in_category = learning_tips

	var random_tip = tips_in_category[randi() % tips_in_category.size()]
	_queue_notification(
		NotificationType.LEARNING_TIP,
		random_tip["title"],
		random_tip["message"],
		LEARNING_TIP_DURATION
	)


	var achievement = learning_achievements[achievement_id]
	var title = achievement["title"]
	var message = achievement["message"]

	# Handle formatted messages
	if custom_data.has("count"):
		message = message % custom_data["count"]
	elif custom_data.has("score"):
		message = message % custom_data["score"]
	elif custom_data.has("days"):
		message = message % custom_data["days"]

	var notification_data = {
		"achievement_id": achievement_id,
		"icon": achievement.get("icon", "🏆"),
		"color": achievement.get("color", UIThemeManager.ACCENT_GREEN),
		"custom_data": custom_data
	}

	_queue_notification(
		NotificationType.ACHIEVEMENT, title, message, ACHIEVEMENT_DURATION, notification_data
	)
	achievement_unlocked.emit(achievement_id)


	var title = "📊 Progress Update"
	var message = ""

	match milestone_type:
		"structures_viewed":
			message = "You've explored %d brain structures! " % current_value
			if target_value > 0:
				message += "Only %d more to complete this level." % (target_value - current_value)
		"quizzes_completed":
			message = "You've completed %d quizzes! Great job staying engaged." % current_value
		"study_time":
			message = (
				"You've spent %d minutes learning today. Excellent dedication!" % current_value
			)
		"bookmarks_created":
			message = (
				"You've bookmarked %d structures for review. Building a great study collection!"
				% current_value
			)
		_:
			message = "You've made progress in %s: %d" % [milestone_type, current_value]

	_queue_notification(NotificationType.PROGRESS_UPDATE, title, message, DEFAULT_DURATION)
	learning_milestone_reached.emit(milestone_type, current_value)


	var title = "🔍 New Discovery!"
	var message = "You discovered: " + structure_name

	if interesting_fact != "":
		message += "\n💡 Did you know? " + interesting_fact

	_queue_notification(NotificationType.DISCOVERY, title, message, LEARNING_TIP_DURATION)


	var notification_data = {
		"type": type,
		"title": title,
		"message": message,
		"duration": duration,
		"timestamp": Time.get_unix_time_from_system(),
		"id": _generate_notification_id(),
		"extra_data": extra_data
	}

	notification_queue.append(notification_data)
	_process_notification_queue()


		var notification_data = notification_queue.pop_front()
		_create_notification(notification_data)


	var notification = _build_notification_ui(data)

	# Add to container and track
	notifications_container.add_child(notification)
	active_notifications.append(notification)

	# Animate entrance
	_animate_notification_entrance(notification)

	# Setup auto-hide timer
	var timer = Timer.new()
	timer.wait_time = data["duration"]
	timer.one_shot = true
	timer.timeout.connect(func(): _remove_notification(notification))
	notification.add_child(timer)
	timer.start()

	print("[NOTIFICATION_SYSTEM] Showing notification: " + data["title"])


	var notification = PanelContainer.new()
	notification.name = "Notification_" + data["id"]
	notification.custom_minimum_size = Vector2(320, 0)

	# Apply styling based on type
	var style_variant = _get_notification_style_variant(data["type"])
	UIThemeManager.apply_glass_panel(notification, 0.95, style_variant)

	# Add colored border for type identification
	var border_color = _get_notification_color(data["type"], data.get("extra_data", {}))
	var panel_style = notification.get_theme_stylebox("panel").duplicate()
	panel_style.border_color = border_color
	panel_style.border_width_left = 4
	notification.add_theme_stylebox_override("panel", panel_style)

	# Main content container
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_top", UIThemeManager.MARGIN_MEDIUM)
	margin.add_theme_constant_override("margin_bottom", UIThemeManager.MARGIN_MEDIUM)
	margin.add_theme_constant_override("margin_left", UIThemeManager.MARGIN_MEDIUM)
	margin.add_theme_constant_override("margin_right", UIThemeManager.MARGIN_MEDIUM)
	notification.add_child(margin)

	var main_container = HBoxContainer.new()
	main_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	margin.add_child(main_container)

	# Icon/Type indicator
	var icon_label = Label.new()
	icon_label.text = _get_notification_icon(data["type"], data.get("extra_data", {}))
	icon_label.custom_minimum_size = Vector2(32, 32)
	icon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	UIThemeManager.apply_modern_label(icon_label, UIThemeManager.FONT_SIZE_LARGE, border_color)
	main_container.add_child(icon_label)

	# Content section
	var content_container = VBoxContainer.new()
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_TINY)
	main_container.add_child(content_container)

	# Title
	var title_label = Label.new()
	title_label.text = data["title"]
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UIThemeManager.apply_modern_label(
		title_label, UIThemeManager.FONT_SIZE_MEDIUM, UIThemeManager.TEXT_PRIMARY, "heading"
	)
	content_container.add_child(title_label)

	# Message
	var message_label = Label.new()
	message_label.text = data["message"]
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message_label.custom_minimum_size = Vector2(250, 0)
	UIThemeManager.apply_modern_label(
		message_label, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_SECONDARY
	)
	content_container.add_child(message_label)

	# Close button
	var close_button = Button.new()
	close_button.text = "✕"
	close_button.custom_minimum_size = Vector2(24, 24)
	close_button.flat = true
	UIThemeManager.apply_modern_button(close_button, UIThemeManager.ACCENT_RED, "small")
	close_button.pressed.connect(func(): _remove_notification(notification))
	main_container.add_child(close_button)

	# Add click interaction for certain notification types
	if data["type"] in [NotificationType.ACHIEVEMENT, NotificationType.DISCOVERY]:
		notification.gui_input.connect(_on_notification_clicked.bind(data))
		notification.mouse_entered.connect(
			func(): UIThemeManager.animate_hover_glow(notification, border_color, 0.2)
		)
		notification.mouse_exited.connect(
			func(): UIThemeManager.animate_hover_glow_off(notification)
		)

	# Store notification data
	notification.set_meta("notification_data", data)

	return notification


	var tween = notification.create_tween()
	tween.set_parallel(true)
	(
		tween
		. tween_property(notification, "position:x", 0, SLIDE_IN_DURATION)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_BACK)
	)
	tween.tween_property(notification, "modulate:a", 1.0, SLIDE_IN_DURATION * 0.5).set_ease(
		Tween.EASE_OUT
	)


	var tween = notification.create_tween()
	tween.set_parallel(true)
	tween.tween_property(notification, "position:x", 400, SLIDE_OUT_DURATION).set_ease(
		Tween.EASE_IN
	)
	tween.tween_property(notification, "modulate:a", 0.0, SLIDE_OUT_DURATION).set_ease(
		Tween.EASE_IN
	)

	tween.tween_callback(
		func():
			if notification.get_parent():
				notification.get_parent().remove_child(notification)
			notification.queue_free()
	)


		var data = notification.get_meta("notification_data", {})
		if data.get("type", -1) == type:
			return true
	return false


# Educational content management

@onready var notifications_container: VBoxContainer

func _ready() -> void:
	_setup_notification_system()
	_position_container()
	print("[NOTIFICATION_SYSTEM] Educational notification system initialized")


func _process_notification_queue() -> void:
	"""Process queued notifications"""
	while notification_queue.size() > 0 and active_notifications.size() < MAX_NOTIFICATIONS:
func _exit_tree() -> void:
	"""Cleanup on removal"""
	dispose()

func show_info(title: String, message: String, duration: float = DEFAULT_DURATION) -> void:
	"""Show informational notification"""
	_queue_notification(NotificationType.INFO, title, message, duration)


func show_success(title: String, message: String, duration: float = DEFAULT_DURATION) -> void:
	"""Show success notification"""
	_queue_notification(NotificationType.SUCCESS, title, message, duration)


func show_warning(title: String, message: String, duration: float = DEFAULT_DURATION) -> void:
	"""Show warning notification"""
	_queue_notification(NotificationType.WARNING, title, message, duration)


func show_error(title: String, message: String, duration: float = DEFAULT_DURATION) -> void:
	"""Show error notification"""
	_queue_notification(NotificationType.ERROR, title, message, duration)


func show_learning_tip(tip_category: String = "") -> void:
	"""Show educational learning tip"""
func show_achievement(achievement_id: String, custom_data: Dictionary = {}) -> void:
	"""Show achievement notification"""
	if not learning_achievements.has(achievement_id):
		print("[NOTIFICATION_SYSTEM] Unknown achievement: " + achievement_id)
		return

func show_progress_update(
	milestone_type: String, current_value: int, target_value: int = 0
) -> void:
	"""Show learning progress update"""
func show_discovery(structure_name: String, interesting_fact: String = "") -> void:
	"""Show discovery notification when user finds something new"""
func track_structure_viewed(structure_id: String) -> void:
	"""Track when user views a structure"""
	# This would integrate with a persistence system
	# For now, just show achievement for first view
	show_achievement("first_structure_viewed")


func track_quiz_completion(score: int) -> void:
	"""Track quiz completion"""
	show_achievement("quiz_completed", {"score": score})


func track_bookmark_created(total_bookmarks: int) -> void:
	"""Track bookmark milestones"""
	if total_bookmarks in [1, 5, 10, 25, 50]:
		show_achievement("bookmark_milestone", {"count": total_bookmarks})


func track_learning_streak(days: int) -> void:
	"""Track learning streak milestones"""
	if days in [3, 7, 14, 30, 60]:
		show_achievement("learning_streak", {"days": days})


# Learning tip helpers
func show_contextual_tip(context: String) -> void:
	"""Show tip based on user's current context"""
	match context:
		"first_visit":
			show_learning_tip("study_strategy")
		"struggling_with_names":
			show_learning_tip("memorization")
		"rapid_progression":
			show_learning_tip("progression")
		"returning_user":
			show_learning_tip("review")
		_:
			show_learning_tip()


# Public utility functions
func clear_all_notifications() -> void:
	"""Clear all active notifications"""
	for notification in active_notifications:
		_remove_notification(notification)

	notification_queue.clear()


func get_active_notification_count() -> int:
	"""Get number of active notifications"""
	return active_notifications.size()


func has_notification_type(type: NotificationType) -> bool:
	"""Check if notification of specific type is active"""
	for notification in active_notifications:
func add_custom_achievement(achievement_id: String, achievement_data: Dictionary) -> void:
	"""Add custom achievement to the system"""
	learning_achievements[achievement_id] = achievement_data
	print("[NOTIFICATION_SYSTEM] Added custom achievement: " + achievement_id)


func add_custom_learning_tip(tip_data: Dictionary) -> void:
	"""Add custom learning tip"""
	learning_tips.append(tip_data)
	print("[NOTIFICATION_SYSTEM] Added custom learning tip")


# Cleanup
func dispose() -> void:
	"""Clean up notification system"""
	clear_all_notifications()
	learning_achievements.clear()
	learning_tips.clear()


func _setup_notification_system() -> void:
	"""Setup the notification display system"""
	# Create notifications container
	notifications_container = VBoxContainer.new()
	notifications_container.name = "NotificationsContainer"
	notifications_container.add_theme_constant_override("separation", NOTIFICATION_SPACING)
	notifications_container.size_flags_horizontal = Control.SIZE_SHRINK_END
	notifications_container.size_flags_vertical = Control.SIZE_SHRINK_END
	add_child(notifications_container)

	# Set high z-index to appear above other UI
	z_index = 2000


func _position_container() -> void:
	"""Position notification container in top-right corner"""
	set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	notifications_container.position = Vector2(-20, 20)


# Public interface for showing notifications
func _queue_notification(
	type: NotificationType,
	title: String,
	message: String,
	duration: float,
	extra_data: Dictionary = {}
) -> void:
	"""Queue notification for display"""
func _create_notification(data: Dictionary) -> void:
	"""Create and display a notification"""
func _build_notification_ui(data: Dictionary) -> Control:
	"""Build sophisticated notification UI"""
func _get_notification_style_variant(type: NotificationType) -> String:
	"""Get style variant based on notification type"""
	match type:
		NotificationType.ACHIEVEMENT, NotificationType.DISCOVERY:
			return "highlight"
		NotificationType.LEARNING_TIP:
			return "info"
		NotificationType.ERROR:
			return "warning"
		_:
			return "standard"


func _get_notification_color(type: NotificationType, extra_data: Dictionary = {}) -> Color:
	"""Get color based on notification type"""
	match type:
		NotificationType.INFO:
			return UIThemeManager.ACCENT_BLUE
		NotificationType.SUCCESS:
			return UIThemeManager.ACCENT_GREEN
		NotificationType.WARNING:
			return UIThemeManager.ACCENT_ORANGE
		NotificationType.ERROR:
			return UIThemeManager.ACCENT_RED
		NotificationType.LEARNING_TIP:
			return UIThemeManager.ACCENT_CYAN
		NotificationType.ACHIEVEMENT:
			return extra_data.get("color", UIThemeManager.ACCENT_GREEN)
		NotificationType.PROGRESS_UPDATE:
			return UIThemeManager.ACCENT_PURPLE
		NotificationType.DISCOVERY:
			return UIThemeManager.ACCENT_PINK
		_:
			return UIThemeManager.ACCENT_BLUE


func _get_notification_icon(type: NotificationType, extra_data: Dictionary = {}) -> String:
	"""Get icon based on notification type"""
	match type:
		NotificationType.INFO:
			return "ℹ️"
		NotificationType.SUCCESS:
			return "✅"
		NotificationType.WARNING:
			return "⚠️"
		NotificationType.ERROR:
			return "❌"
		NotificationType.LEARNING_TIP:
			return "💡"
		NotificationType.ACHIEVEMENT:
			return extra_data.get("icon", "🏆")
		NotificationType.PROGRESS_UPDATE:
			return "📊"
		NotificationType.DISCOVERY:
			return "🔍"
		_:
			return "📢"


func _animate_notification_entrance(notification: Control) -> void:
	"""Animate notification entrance"""
	# Start off-screen to the right
	notification.position.x = 400
	notification.modulate.a = 0.0

	# Animate slide-in
func _animate_notification_exit(notification: Control) -> void:
	"""Animate notification exit"""
func _remove_notification(notification: Control) -> void:
	"""Remove notification with animation"""
	if notification in active_notifications:
		active_notifications.erase(notification)

	_animate_notification_exit(notification)

	# Process queue for any waiting notifications
	get_tree().create_timer(SLIDE_OUT_DURATION).timeout.connect(_process_notification_queue)


func _generate_notification_id() -> String:
	"""Generate unique notification ID"""
	return "notif_" + str(Time.get_unix_time_from_system()) + "_" + str(randi())


func _on_notification_clicked(data: Dictionary, event: InputEvent) -> void:
	"""Handle notification click"""
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("[NOTIFICATION_SYSTEM] Notification clicked: " + data["id"])
		notification_clicked.emit(data["id"], data)


# Achievement tracking helpers
