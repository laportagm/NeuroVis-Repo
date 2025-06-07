# Enhanced signal handlers for new Figma features

# ===== EXPORT VARIABLES =====

@export var info_panel: Control

# ===== SIGNAL HANDLERS =====


		var bookmark_text = " ⭐" if bookmarked else ""
		UIThemeManager.animate_fade_text_change(
			object_name_label, "Selected: " + structure_id + bookmark_text
		)


func _setup_enhanced_ui_connections() -> void:
	"""Setup enhanced UI connections for new Figma features"""

	# Existing connections...
	_setup_ui_connections()

	# NEW: Enhanced info panel signals
	if info_panel and info_panel.has_signal("structure_bookmarked"):
		info_panel.structure_bookmarked.connect(_on_structure_bookmarked)

	if info_panel and info_panel.has_signal("related_structure_selected"):
		info_panel.related_structure_selected.connect(_on_related_structure_selected)

	if info_panel and info_panel.has_signal("action_requested"):
		info_panel.action_requested.connect(_on_action_requested)

	if info_panel and info_panel.has_signal("learning_progress_updated"):
		info_panel.learning_progress_updated.connect(_on_learning_progress_updated)


# NEW: Enhanced signal handlers
func _on_structure_bookmarked(structure_id: String, bookmarked: bool) -> void:
	"""Handle structure bookmarking with visual feedback"""
	print("🔖 Structure %s %s" % [structure_id, "bookmarked" if bookmarked else "unbookmarked"])

	# TODO: Save to persistent bookmark system
	# For now, show feedback
	if object_name_label:
func _on_related_structure_selected(structure_id: String) -> void:
	"""Handle related structure navigation"""
	print("🔗 Navigating to related structure: " + structure_id)

	# Display the related structure (this triggers your existing selection system)
	_display_structure_info(structure_id)


func _on_action_requested(action_type: String, structure_id: String) -> void:
	"""Handle action button presses with visual feedback"""
	print("🎯 Action requested: %s for %s" % [action_type, structure_id])

	match action_type:
		"notes":
			print("📝 Opening notes for " + structure_id)
			# TODO: Integrate with notes system

		"quiz":
			print("🧪 Starting quiz for " + structure_id)
			# TODO: Launch quiz interface

		"study":
			print("📚 Starting study mode for " + structure_id)
			# TODO: Enter focused study mode

		"explore":
			print("🔍 Exploring connections for " + structure_id)
			# TODO: Show structure connections in 3D


func _on_learning_progress_updated(structure_id: String, progress: float) -> void:
	"""Handle learning progress updates"""
	print("📊 Learning progress for %s: %.1f%%" % [structure_id, progress])

	# TODO: Save progress to learning analytics system
	# For now, show achievement feedback when reaching milestones
	if progress >= 100.0:
		print("🎉 Structure mastery achieved: " + structure_id)
