## InfoPanelFactory.gd
## Factory for creating educational information panels with theme support
##
## This factory manages the creation of educational information panels that display
## anatomical brain structure data. It supports multiple theme modes to accommodate
## different learning environments and user preferences while maintaining a consistent
## educational interface. The factory pattern ensures backward compatibility while
## allowing flexible UI evolution for diverse educational contexts.
##
## Educational Learning Objectives:
## - Support multiple learning environments (gaming vs clinical)
## - Maintain consistent educational content presentation
## - Enable adaptive UI for different learner preferences
## - Preserve educational functionality across theme changes
##
## @tutorial: Educational Factory Pattern
## @tutorial: Adaptive UI for Medical Education
## @version: 2.0

class_name InfoPanelFactory
extends RefCounted

# === EDUCATIONAL THEME MODES ===

enum ThemeMode { ENHANCED, MINIMAL }  # Gaming-style for engaging student learning  # Professional style for clinical education

# === STATE MANAGEMENT ===
## Current educational theme preference (default to engaging style)
	static var current_theme: ThemeMode = ThemeMode.ENHANCED


	## Create educational info panel based on current theme preference
	## @returns: Control - The appropriate educational panel for current theme
	static func create_info_panel() -> Control:

var minimal_path = "res://ui/panels/minimal_info_panel.gd"
var MinimalPanelScript = load(minimal_path)
var panel = MinimalPanelScript.new()
var enhanced_path = "res://ui/panels/EnhancedInformationPanel.gd"
var EnhancedPanelScript = load(enhanced_path)
var panel = EnhancedPanelScript.new()
var unified_path = "res://scenes/ui_info_panel_unified.gd"
var UnifiedPanelScript = load(unified_path)
var panel = UnifiedPanelScript.new()
var basic_path = "res://scenes/ui_info_panel.gd"
var BasicPanelScript = load(basic_path)
var fallback = PanelContainer.new()
	fallback.name = "FallbackPanel"
var config = ConfigFile.new()
var config = ConfigFile.new()
	config.set_value("ui", "theme_mode", current_theme)
	config.save("user://ui_settings.cfg")

func _fix_orphaned_code():
	print("[InfoPanelFactory] Current theme: %s" % ["ENHANCED", "MINIMAL"][current_theme])

	match current_theme:
		ThemeMode.MINIMAL:
			# Try to load minimal panel

func _fix_orphaned_code():
	if ResourceLoader.exists(minimal_path):
func _fix_orphaned_code():
	print("[InfoPanelFactory] Creating MINIMAL panel")
func _fix_orphaned_code():
	print("[InfoPanelFactory] Panel created: %s" % panel.get_class())
	return panel
	else:
		push_warning("[InfoPanelFactory] Minimal panel not found at: %s" % minimal_path)

		ThemeMode.ENHANCED, _:
			# Use the new enhanced panel as primary option
func _fix_orphaned_code():
	if ResourceLoader.exists(enhanced_path):
func _fix_orphaned_code():
	print("[InfoPanelFactory] Creating ENHANCED panel (Figma-compliant)")
func _fix_orphaned_code():
	print("[InfoPanelFactory] Panel created: %s" % panel.get_class())
	return panel
	else:
		# Fallback to unified panel
func _fix_orphaned_code():
	if ResourceLoader.exists(unified_path):
func _fix_orphaned_code():
	print("[InfoPanelFactory] Creating ENHANCED/unified panel")
func _fix_orphaned_code():
	print("[InfoPanelFactory] Panel created: %s" % panel.get_class())
	return panel
	else:
		# Fallback to basic panel
func _fix_orphaned_code():
	if ResourceLoader.exists(basic_path):
func _fix_orphaned_code():
	print("[InfoPanelFactory] Creating basic panel")
	return BasicPanelScript.new()

	# Ultimate fallback - create empty panel
	push_error("[InfoPanelFactory] No panel scripts found, creating fallback")
func _fix_orphaned_code():
	return fallback


	# Switch theme mode
	static func set_theme(mode: ThemeMode) -> void:
		current_theme = mode
		print("[InfoPanelFactory] Theme set to: %s" % ["ENHANCED", "MINIMAL"][mode])
		_save_preference()


		# Get current theme
		static func get_theme() -> ThemeMode:
			return current_theme


			# Load theme preference from user settings
			static func load_preference() -> void:
func _fix_orphaned_code():
	if config.load("user://ui_settings.cfg") == OK:
		current_theme = config.get_value("ui", "theme_mode", ThemeMode.ENHANCED)
		print(
		(
		"[InfoPanelFactory] Loaded theme preference: %s"
		% ["ENHANCED", "MINIMAL"][current_theme]
		)
		)


		# Save theme preference
		static func _save_preference() -> void:
func _fix_orphaned_code():
	print("[InfoPanelFactory] Saved theme preference")


	# Get theme name for display
	static func get_theme_name() -> String:
		match current_theme:
			ThemeMode.MINIMAL:
				return "Minimal (Professional)"
				ThemeMode.ENHANCED, _:
					return "Enhanced (Gaming)"


					# Quick property aliases for compatibility
					static var minimal_mode: bool:
						get:
							return current_theme == ThemeMode.MINIMAL
							set(value):
								set_theme(ThemeMode.MINIMAL if value else ThemeMode.ENHANCED)


								static func save_preference() -> void:
									_save_preference()
