# Simple Theme Toggle Button
# Add this to your main UI to switch between Enhanced and Minimal themes

class_name ThemeToggle
extends CheckButton

# Preload the InfoPanelFactory

const InfoPanelFactory = preload("res://ui/panels/InfoPanelFactory.gd")


# FIXED: Orphaned code - var new_theme = (
InfoPanelFactory.ThemeMode.MINIMAL if pressed else InfoPanelFactory.ThemeMode.ENHANCED
)
InfoPanelFactory.set_theme(new_theme)

# Visual feedback
var tween = create_tween()
tween.tween_property(self, "modulate", Color.WHITE, 0.3)

# Immediately update panel if one is currently visible
var main_scene = get_tree().get_root().get_node_or_null("NeuroVisMainScene")

func _ready() -> void:
	# Set initial state based on current theme
	button_pressed = (InfoPanelFactory.get_theme() == InfoPanelFactory.ThemeMode.MINIMAL)

	# Style the toggle
	text = "Minimal UI"
	add_theme_font_size_override("font_size", 14)

	# Position in top-left corner
	position = Vector2(10, 10)

	# Connect signal
	toggled.connect(_on_theme_toggled)

	# Add tooltip
	tooltip_text = "Toggle between Enhanced and Minimal UI themes"


if pressed:
	text = "Minimal UI ✓"
	modulate = Color(0.8, 1.0, 0.8)  # Slight green tint
	else:
		text = "Enhanced UI ✓"
		modulate = Color(0.8, 0.8, 1.0)  # Slight blue tint

		# Animate the change
if main_scene and main_scene.has_method("refresh_info_panel"):
	main_scene.refresh_info_panel()

	print("Theme switched to: ", "Minimal" if pressed else "Enhanced")

func _on_theme_toggled(pressed: bool) -> void:
	# Update factory mode
