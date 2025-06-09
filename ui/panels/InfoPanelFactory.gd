## InfoPanelFactory.gd
## Robust theme-aware factory for creating educational information panels
##
## This enhanced factory manages the creation of educational information panels that display
## anatomical brain structure data. It supports multiple panel types and theme modes,
## providing appropriate UI components for different learning contexts while maintaining
## medical accuracy. The factory includes resource preloading, content validation,
## and graceful error handling to ensure reliable educational experiences.
##
## Panel Types Supported:
## - STANDARD: Basic anatomical information display
## - COMPARATIVE: Side-by-side structure comparison
## - CLINICAL: Professional medical data presentation
## - EDUCATIONAL: Interactive learning-focused panels
## - ANALYSIS: Advanced structure analysis tools
##
## Theme Modes:
## - ENHANCED: Engaging glassmorphism design for medical students
## - MINIMAL: Clean clinical interface for professionals
##
## Medical Accuracy: All anatomical terminology and clinical data are preserved
## regardless of theme or panel type selection.
##
## @tutorial: Medical Education UI Factory Pattern
## @tutorial: Theme-Aware Component Architecture
## @version: 3.0 - Complete implementation with robust error handling

class_name InfoPanelFactory
extends RefCounted

# === ENUMERATIONS ===
enum ThemeMode { ENHANCED, MINIMAL }  # Engaging glassmorphism style for medical students  # Professional clinical style for healthcare settings

enum PanelType { STANDARD, COMPARATIVE, CLINICAL, EDUCATIONAL, ANALYSIS }  # Basic anatomical information display  # Side-by-side structure comparison  # Professional medical data presentation  # Interactive learning with quizzes  # Advanced structure analysis tools

# === CONFIGURATION ===
const PANEL_CONFIGS: Dictionary = {
	PanelType.STANDARD:
	{
		"enhanced_path": "res://ui/panels/EnhancedInformationPanel.gd",
		"minimal_path": "res://ui/panels/InformationPanelController.gd",
		"fallback_path": "res://ui/panels/InformationPanelController.gd",
		"min_size": Vector2(320, 400),
		"position_preset": Control.PRESET_CENTER_RIGHT
	},
	PanelType.COMPARATIVE:
	{
		"enhanced_path": "res://ui/panels/ComparativeInfoPanel.gd",
		"minimal_path": "res://ui/panels/ComparativeInfoPanel.gd",
		"fallback_path": null,
		"min_size": Vector2(600, 500),
		"position_preset": Control.PRESET_CENTER
	},
	PanelType.CLINICAL:
	{
		"enhanced_path": "res://ui/panels/ClinicalDataPanel.gd",
		"minimal_path": "res://ui/panels/ClinicalDataPanel.gd",
		"fallback_path": "res://ui/panels/InformationPanelController.gd",
		"min_size": Vector2(400, 600),
		"position_preset": Control.PRESET_CENTER_LEFT
	},
	PanelType.EDUCATIONAL:
	{
		"enhanced_path": "res://ui/panels/EducationalInteractivePanel.gd",
		"minimal_path": "res://ui/panels/EducationalInteractivePanel.gd",
		"fallback_path": "res://ui/panels/EnhancedInformationPanel.gd",
		"min_size": Vector2(480, 600),
		"position_preset": Control.PRESET_CENTER
	},
	PanelType.ANALYSIS:
	{
		"enhanced_path": "res://ui/panels/BrainAnalysisPanel.gd",
		"minimal_path": "res://ui/panels/BrainAnalysisPanel.gd",
		"fallback_path": null,
		"min_size": Vector2(500, 550),
		"position_preset": Control.PRESET_TOP_RIGHT
	}
}

# === STATE MANAGEMENT ===
static var current_theme: ThemeMode = ThemeMode.ENHANCED
static var _panel_cache: Dictionary = {}  # Cache for preloaded panels
static var _resource_cache: Dictionary = {}  # Cache for preloaded scripts
static var _is_initialized: bool = false

# === PROPERTY ALIASES FOR COMPATIBILITY ===
static var minimal_mode: bool:
	get:
		return current_theme == ThemeMode.MINIMAL
	set(value):
		set_theme(ThemeMode.MINIMAL if value else ThemeMode.ENHANCED)


# === INITIALIZATION ===
static func _static_init() -> void:
	"""Initialize factory on first use for medical education session"""
	if not _is_initialized:
		load_preference()
		_preload_common_resources()
		_is_initialized = true
		print("[InfoPanelFactory] Initialized with theme: %s" % get_theme_name())


## Create educational info panel based on type and theme
## @param panel_type: PanelType - Type of panel to create (defaults to STANDARD)
## @param structure_data: Dictionary - Optional medical structure data for validation
## @returns: Control - The appropriate educational panel or null if creation fails
static func create_info_panel(
	panel_type: PanelType = PanelType.STANDARD, structure_data: Dictionary = {}
) -> Control:
	# Ensure factory is initialized
	if not _is_initialized:
		_static_init()

	# Validate medical content if provided
	if not structure_data.is_empty() and not _validate_medical_content(structure_data):
		push_error("[InfoPanelFactory] Invalid medical content provided")
		return null

	# Get configuration for panel type
	var config = PANEL_CONFIGS.get(panel_type, PANEL_CONFIGS[PanelType.STANDARD])

	# Log panel creation for educational analytics
	print(
		(
			"[InfoPanelFactory] Creating %s panel with %s theme"
			% [_get_panel_type_name(panel_type), get_theme_name()]
		)
	)

	# Try to create panel from cache first
	var cache_key = "%s_%s" % [panel_type, current_theme]
	if _panel_cache.has(cache_key):
		var cached_panel = _panel_cache[cache_key]
		if is_instance_valid(cached_panel) and not cached_panel.is_inside_tree():
			print("[InfoPanelFactory] Using cached panel instance")
			return _configure_panel(cached_panel, config, structure_data)

	# Create new panel instance
	var panel = _create_panel_instance(config, panel_type)

	if panel:
		# Configure panel with settings
		panel = _configure_panel(panel, config, structure_data)

		# Cache for future use if cacheable
		if _is_panel_cacheable(panel_type):
			_panel_cache[cache_key] = panel

		return panel
	else:
		# Create emergency fallback panel
		return _create_emergency_panel(panel_type, structure_data)


## Create panel with backwards compatibility (legacy support)
static func create_info_panel() -> Control:
	return create_info_panel(PanelType.STANDARD)


# === PRIVATE FACTORY METHODS ===
static func _preload_common_resources() -> void:
	"""Preload commonly used panel scripts for performance"""
	print("[InfoPanelFactory] Preloading common medical panel resources...")

	var common_paths = [
		"res://ui/panels/EnhancedInformationPanel.gd",
		"res://ui/panels/InformationPanelController.gd",
		"res://ui/panels/ComparativeInfoPanel.gd",
		"res://ui/panels/BrainAnalysisPanel.gd"
	]

	for path in common_paths:
		if ResourceLoader.exists(path):
			_resource_cache[path] = load(path)
			print("[InfoPanelFactory] Preloaded: %s" % path.get_file())


static func _create_panel_instance(config: Dictionary, panel_type: PanelType) -> Control:
	"""Create panel instance based on configuration and theme"""
	var script_path: String

	# Determine which path to use based on theme
	match current_theme:
		ThemeMode.MINIMAL:
			script_path = config.get("minimal_path", "")
		ThemeMode.ENHANCED:
			script_path = config.get("enhanced_path", "")

	# Try primary path
	var panel_script = _load_panel_script(script_path)
	if panel_script:
		return panel_script.new()

	# Try fallback path
	var fallback_path = config.get("fallback_path", "")
	if fallback_path and fallback_path != "":
		push_warning("[InfoPanelFactory] Primary panel not found, using fallback")
		panel_script = _load_panel_script(fallback_path)
		if panel_script:
			return panel_script.new()

	return null


static func _load_panel_script(path: String) -> Script:
	"""Load panel script with caching"""
	if path.is_empty():
		return null

	# Check cache first
	if _resource_cache.has(path):
		return _resource_cache[path]

	# Load and cache
	if ResourceLoader.exists(path):
		var script = load(path)
		_resource_cache[path] = script
		return script

	return null


static func _configure_panel(
	panel: Control, config: Dictionary, structure_data: Dictionary
) -> Control:
	"""Configure panel with theme-appropriate settings"""
	if not panel:
		return null

	# Set minimum size
	var min_size = config.get("min_size", Vector2(320, 400))
	panel.custom_minimum_size = min_size

	# Apply theme styling
	var theme_manager = (
		Engine.get_singleton("UIThemeManager") if Engine.has_singleton("UIThemeManager") else null
	)
	if theme_manager and panel.has_method("apply_theme"):
		panel.apply_theme(current_theme)

	# Set initial data if provided
	if not structure_data.is_empty():
		if panel.has_method("display_structure_info"):
			panel.display_structure_info(structure_data)
		elif panel.has_method("set_structure_data"):
			panel.set_structure_data(structure_data)

	# Configure positioning
	if panel.has_method("set_position_preset"):
		var preset = config.get("position_preset", Control.PRESET_CENTER_RIGHT)
		panel.set_position_preset(preset)

	return panel


static func _validate_medical_content(structure_data: Dictionary) -> bool:
	"""Validate medical content for accuracy and completeness"""
	# Check for required medical fields
	var required_fields = ["id", "displayName"]
	for field in required_fields:
		if not structure_data.has(field) or structure_data[field] == "":
			push_warning("[InfoPanelFactory] Missing required medical field: %s" % field)
			return false

	# Validate medical terminology (basic check)
	var name = structure_data.get("displayName", "")
	if name.length() < 3 or name.to_upper() == name:
		push_warning("[InfoPanelFactory] Invalid medical structure name: %s" % name)
		return false

	return true


static func _create_emergency_panel(panel_type: PanelType, structure_data: Dictionary) -> Control:
	"""Create emergency fallback panel for medical education continuity"""
	push_error("[InfoPanelFactory] Creating emergency medical panel")

	var panel = PanelContainer.new()
	panel.name = "EmergencyMedicalPanel"
	panel.custom_minimum_size = Vector2(350, 200)

	# Create content container
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)

	# Error header
	var header = Label.new()
	header.text = "Medical Panel Load Error"
	header.add_theme_font_size_override("font_size", 18)
	header.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
	vbox.add_child(header)

	# Error message
	var message = RichTextLabel.new()
	message.fit_content = true
	message.bbcode_enabled = true
	message.text = (
		"[color=white]Could not load %s panel.\n\n" % _get_panel_type_name(panel_type)
		+ "This may affect your medical education experience.\n"
		+ "Please check your NeuroVis installation.[/color]"
	)
	vbox.add_child(message)

	# Show structure data if available
	if not structure_data.is_empty():
		var separator = HSeparator.new()
		vbox.add_child(separator)

		var data_label = Label.new()
		data_label.text = "Structure: %s" % structure_data.get("displayName", "Unknown")
		data_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
		vbox.add_child(data_label)

	return panel


static func _is_panel_cacheable(panel_type: PanelType) -> bool:
	"""Determine if panel type should be cached"""
	# Don't cache comparative or analysis panels (they may have state)
	return panel_type in [PanelType.STANDARD, PanelType.EDUCATIONAL]


static func _get_panel_type_name(panel_type: PanelType) -> String:
	"""Get human-readable panel type name"""
	match panel_type:
		PanelType.STANDARD:
			return "Standard Information"
		PanelType.COMPARATIVE:
			return "Comparative Analysis"
		PanelType.CLINICAL:
			return "Clinical Data"
		PanelType.EDUCATIONAL:
			return "Educational Interactive"
		PanelType.ANALYSIS:
			return "Brain Analysis"
		_:
			return "Unknown"


## Switch theme mode while preserving medical content accuracy
## @param mode: ThemeMode - Enhanced (student) or Minimal (clinical)
static func set_theme(mode: ThemeMode) -> void:
	current_theme = mode
	print("[InfoPanelFactory] Medical theme set to: %s" % ["ENHANCED", "MINIMAL"][mode])
	# Preserve theme preference for educational session continuity
	_save_preference()


## Get current theme for medical education context
## @returns: ThemeMode - Current educational theme setting
static func get_theme() -> ThemeMode:
	return current_theme


## Get theme name for medical education display
static func get_theme_name() -> String:
	match current_theme:
		ThemeMode.MINIMAL:
			return "Minimal (Clinical/Professional)"
		ThemeMode.ENHANCED, _:
			return "Enhanced (Student Learning)"


## Get available panel types
static func get_available_panel_types() -> Array:
	return PanelType.values()


## Clear panel cache to free memory
static func clear_panel_cache() -> void:
	for key in _panel_cache:
		var panel = _panel_cache[key]
		if is_instance_valid(panel) and panel.has_method("queue_free"):
			panel.queue_free()
	_panel_cache.clear()
	print("[InfoPanelFactory] Panel cache cleared")


## Get cache statistics for debugging
static func get_cache_stats() -> Dictionary:
	return {
		"panel_cache_size": _panel_cache.size(),
		"resource_cache_size": _resource_cache.size(),
		"current_theme": get_theme_name(),
		"is_initialized": _is_initialized
	}


## Load theme preference from user settings for educational continuity
static func load_preference() -> void:
	# FIX: Proper config handling for medical education preferences
	var config = ConfigFile.new()
	if config.load("user://ui_settings.cfg") == OK:
		current_theme = config.get_value("ui", "theme_mode", ThemeMode.ENHANCED)
		print(
			(
				"[InfoPanelFactory] Loaded medical education preference: %s"
				% ["ENHANCED", "MINIMAL"][current_theme]
			)
		)
	else:
		# FIX: Default to enhanced for optimal student learning experience
		print("[InfoPanelFactory] No saved preference, defaulting to ENHANCED for students")
		current_theme = ThemeMode.ENHANCED


## Public save preference method for medical education settings
static func save_preference() -> void:
	_save_preference()


## Save theme preference for medical education session persistence
static func _save_preference() -> void:
	# FIX: Ensure medical education preferences persist across sessions
	var config = ConfigFile.new()
	config.set_value("ui", "theme_mode", current_theme)
	var save_result = config.save("user://ui_settings.cfg")
	if save_result == OK:
		print(
			(
				"[InfoPanelFactory] Saved medical education preference: %s"
				% ["ENHANCED", "MINIMAL"][current_theme]
			)
		)
	else:
		push_warning("[InfoPanelFactory] Failed to save medical education preference")


# === PANEL CREATION HELPERS ===
## Create standard information panel (convenience method)
static func create_standard_panel(structure_data: Dictionary = {}) -> Control:
	return create_info_panel(PanelType.STANDARD, structure_data)


## Create comparative analysis panel
static func create_comparative_panel(
	structure1: Dictionary = {}, structure2: Dictionary = {}
) -> Control:
	var panel = create_info_panel(PanelType.COMPARATIVE)
	if panel and panel.has_method("set_comparison_data"):
		panel.set_comparison_data(structure1, structure2)
	return panel


## Create clinical data panel
static func create_clinical_panel(structure_data: Dictionary = {}) -> Control:
	return create_info_panel(PanelType.CLINICAL, structure_data)


## Create educational interactive panel
static func create_educational_panel(structure_data: Dictionary = {}) -> Control:
	return create_info_panel(PanelType.EDUCATIONAL, structure_data)


## Create brain analysis panel
static func create_analysis_panel(structure_data: Dictionary = {}) -> Control:
	return create_info_panel(PanelType.ANALYSIS, structure_data)

# === TESTING & VALIDATION ===
## Comprehensive testing approach:
## 1. Test Standard Panel Creation:
##    - Launch NeuroVis and select hippocampus
##    - Verify Enhanced theme shows glassmorphism UI
##    - Verify Minimal theme shows clinical UI
##    - Confirm medical content identical in both
##
## 2. Test Panel Type Variations:
##    - Create each panel type programmatically
##    - Verify appropriate UI components load
##    - Test with valid and invalid structure data
##
## 3. Test Error Handling:
##    - Rename panel scripts to trigger fallbacks
##    - Verify emergency panels display correctly
##    - Confirm error messages are educational
##
## 4. Test Caching System:
##    - Create multiple panels of same type
##    - Verify cache improves performance
##    - Test cache clearing functionality
##
## 5. Test Theme Persistence:
##    - Switch themes and restart application
##    - Verify preference saves and loads
##    - Test with corrupted preference file
##
## 6. Test Medical Content Validation:
##    - Pass invalid structure data
##    - Verify validation catches errors
##    - Confirm no panels created with bad data
