## MedicalLighting.gd
## Specialized lighting system for medical visualization
##
## Implements professional three-point lighting optimized for anatomical visualization
## with presets for different educational and clinical contexts. Each lighting setup
## is carefully designed to enhance tissue differentiation, depth perception, and
## structure identification for medical education.
##
## Medical Context:
## - Three-point lighting (key, fill, rim) mimics professional medical photography
## - HDR tone mapping reveals subtle tissue variations critical for pathology
## - Ambient occlusion enhances sulci/gyri depth perception
## - Each preset simulates real-world medical visualization scenarios
##
## Educational Importance:
## - Students learn structure identification under various lighting conditions
## - Different presets prepare learners for clinical imaging interpretation
## - Accessibility features support diverse visual needs and photosensitivity
## - Lighting transitions help focus attention during guided learning
##
## Accessibility Considerations:
## - Adjustable intensity for photosensitive users
## - High contrast options for users with visual impairments
## - Neutral color temperatures to avoid eye strain
## - Bloom effects can be disabled for clarity
##
## @tutorial: docs/dev/medical-lighting.md
## @experimental: false

class_name MedicalLighting
extends Node3D

# === ENUMS ===
## Lighting presets for different educational and clinical contexts

signal preset_changed(preset: int)

## Emitted when a light property is changed
## @param light_type: String type of light (key, fill, rim)
## @param property: String property that changed
signal light_property_changed(light_type: String, property: String)

# === EXPORTS ===
## Currently active lighting preset

enum LightingPreset { EDUCATIONAL, CLINICAL, PRESENTATION, EXAMINATION, SURGICAL, CUSTOM }  # Warm, inviting lighting for extended study sessions  # Neutral white balance mimicking medical imaging suites  # High-contrast for projection and group learning  # Focused lighting simulating clinical examination  # Overhead lighting replicating operating room conditions  # User-defined for specific educational needs

# === SIGNALS ===
## Emitted when lighting preset changes
## @param preset: LightingPreset that was applied

@export var active_preset: LightingPreset = LightingPreset.EDUCATIONAL:
	set(value):
		active_preset = value
@export var use_hdr: bool = true:
	set(value):
		use_hdr = value
@export var ambient_occlusion_enabled: bool = true:
	set(value):
		ambient_occlusion_enabled = value
@export var bloom_enabled: bool = true:
	set(value):
		bloom_enabled = value
@export var key_light_color: Color = Color(1.0, 0.96, 0.9, 1.0):
	set(value):
		key_light_color = value
@export_range(0.0, 5.0, 0.1) var key_light_energy: float = 1.5:
	set(value):
		key_light_energy = value
@export var key_light_position: Vector3 = Vector3(1.5, 2.0, 2.0):
	set(value):
		key_light_position = value
@export var fill_light_color: Color = Color(0.9, 0.95, 1.0, 1.0):
	set(value):
		fill_light_color = value
@export_range(0.0, 5.0, 0.1) var fill_light_energy: float = 0.8:
	set(value):
		fill_light_energy = value
@export var fill_light_position: Vector3 = Vector3(-2.0, 0.5, 1.0):
	set(value):
		fill_light_position = value
@export var rim_light_color: Color = Color(0.85, 0.9, 1.0, 1.0):
	set(value):
		rim_light_color = value
@export_range(0.0, 5.0, 0.1) var rim_light_energy: float = 1.2:
	set(value):
		rim_light_energy = value
@export var rim_light_position: Vector3 = Vector3(0.0, 1.0, -2.5):
	set(value):
		rim_light_position = value
@export var ambient_light_color: Color = Color(0.9, 0.9, 0.95, 1.0):
	set(value):
		ambient_light_color = value
@export_range(0.0, 1.0, 0.05) var ambient_light_energy: float = 0.3:
	set(value):
		ambient_light_energy = value

var custom_preset = {
	"key_light_color": key_color,
	"key_light_energy": key_energy,
	"fill_light_color": fill_color,
	"fill_light_energy": fill_energy,
	"rim_light_color": rim_color,
	"rim_light_energy": rim_energy,
	"ambient_light_color": ambient_color,
	"ambient_light_energy": ambient_energy
	}

	_preset_data[LightingPreset.CUSTOM] = custom_preset

	# Apply the custom preset
	active_preset = LightingPreset.CUSTOM

var new_key_position = position + Vector3(1.5, 2.0, 2.0)
var new_fill_position = position + Vector3(-2.0, 0.5, 1.0)
var new_rim_position = position + Vector3(0.0, 1.0, -2.5)

var base_preset = _preset_data[active_preset]

	key_light_energy = base_preset.key_light_energy * intensity_multiplier
	fill_light_energy = base_preset.fill_light_energy * intensity_multiplier
	rim_light_energy = base_preset.rim_light_energy * intensity_multiplier
	ambient_light_energy = base_preset.ambient_light_energy * intensity_multiplier

var preset_settings = _preset_data[lighting_preset]

# Apply to lights
	key_light_color = preset_settings.key_light_color
	key_light_energy = preset_settings.key_light_energy
	key_light_position = preset_settings.key_light_position

	fill_light_color = preset_settings.fill_light_color
	fill_light_energy = preset_settings.fill_light_energy
	fill_light_position = preset_settings.fill_light_position

	rim_light_color = preset_settings.rim_light_color
	rim_light_energy = preset_settings.rim_light_energy
	rim_light_position = preset_settings.rim_light_position

	ambient_light_color = preset_settings.ambient_light_color
	ambient_light_energy = preset_settings.ambient_light_energy

	# Make sure the key light is looking at the center
var tween = create_tween()
	tween.tween_property(target_object, property_name, end_value, duration)
	tween.play()


var _key_light: DirectionalLight3D
var _fill_light: OmniLight3D
var _rim_light: OmniLight3D
var _environment: Environment
var _world_environment: WorldEnvironment
var _initialized: bool = false
var _preset_data: Dictionary = {}


# === LIFECYCLE METHODS ===

func _ready() -> void:
	"""Initialize the medical lighting system"""
	_create_lighting_components()
	_create_environment()
	_initialize_presets()
	_apply_preset(active_preset)
	_initialized = true
	print("[MedicalLighting] Initialized with preset: " + _get_preset_name(active_preset))


	# === PUBLIC METHODS ===
	## Apply a lighting preset optimized for medical visualization
	## @param lighting_preset: LightingPreset to apply for specific educational context
	## @returns: bool - True if preset was successfully applied
func _initialize_presets() -> void:
	"""Initialize the lighting presets with medical visualization best practices"""
	# Educational preset - Warm lighting for comfortable extended study sessions
	# Medical rationale: Reduces eye strain during long anatomy learning sessions
	# while maintaining sufficient contrast for structure identification
	_preset_data[LightingPreset.EDUCATIONAL] = {
	"key_light_color": Color(1.0, 0.96, 0.9),
	"key_light_energy": 1.5,
	"key_light_position": Vector3(1.5, 2.0, 2.0),
	"fill_light_color": Color(0.9, 0.95, 1.0),
	"fill_light_energy": 0.8,
	"fill_light_position": Vector3(-2.0, 0.5, 1.0),
	"rim_light_color": Color(0.85, 0.9, 1.0),
	"rim_light_energy": 1.2,
	"rim_light_position": Vector3(0.0, 1.0, -2.5),
	"ambient_light_color": Color(0.9, 0.9, 0.95),
	"ambient_light_energy": 0.3
	}

	# Clinical preset - Neutral white balance mimicking medical imaging environments
	# Medical rationale: Simulates radiology suite lighting for accurate tissue
	# color representation, crucial for pathology identification training
	_preset_data[LightingPreset.CLINICAL] = {
	"key_light_color": Color(0.98, 0.98, 1.0),
	"key_light_energy": 1.2,
	"key_light_position": Vector3(0.0, 3.0, 1.5),
	"fill_light_color": Color(0.98, 0.98, 1.0),
	"fill_light_energy": 0.7,
	"fill_light_position": Vector3(-1.5, 0.0, 1.5),
	"rim_light_color": Color(0.95, 0.95, 1.0),
	"rim_light_energy": 0.8,
	"rim_light_position": Vector3(0.0, 0.5, -2.0),
	"ambient_light_color": Color(0.95, 0.95, 1.0),
	"ambient_light_energy": 0.2
	}

	# Presentation preset - High contrast for projection and group learning
	# Medical rationale: Enhanced shadows and highlights make anatomical
	# landmarks more visible in lecture halls and during group discussions
	_preset_data[LightingPreset.PRESENTATION] = {
	"key_light_color": Color(1.0, 0.98, 0.95),
	"key_light_energy": 2.0,
	"key_light_position": Vector3(2.0, 2.5, 1.5),
	"fill_light_color": Color(0.8, 0.85, 0.95),
	"fill_light_energy": 0.5,
	"fill_light_position": Vector3(-2.5, 0.0, 1.0),
	"rim_light_color": Color(0.95, 0.98, 1.0),
	"rim_light_energy": 1.8,
	"rim_light_position": Vector3(0.5, 0.5, -3.0),
	"ambient_light_color": Color(0.8, 0.8, 0.9),
	"ambient_light_energy": 0.15
	}

	# Examination preset - Focused lighting for detailed structure analysis
	# Medical rationale: Simulates examination light positioning used in
	# clinical settings, helping students prepare for real-world scenarios
	_preset_data[LightingPreset.EXAMINATION] = {
	"key_light_color": Color(1.0, 0.98, 0.96),
	"key_light_energy": 1.8,
	"key_light_position": Vector3(1.0, 1.5, 1.5),
	"fill_light_color": Color(0.96, 0.98, 1.0),
	"fill_light_energy": 0.6,
	"fill_light_position": Vector3(-1.5, 0.8, 1.0),
	"rim_light_color": Color(0.9, 0.95, 1.0),
	"rim_light_energy": 1.0,
	"rim_light_position": Vector3(0.0, 0.8, -2.0),
	"ambient_light_color": Color(0.9, 0.9, 0.95),
	"ambient_light_energy": 0.25
	}

	# Surgical preset - Overhead lighting mimicking operating room conditions
	# Medical rationale: Bright, shadow-free illumination from above replicates
	# surgical field lighting, essential for surgical anatomy education
	_preset_data[LightingPreset.SURGICAL] = {
	"key_light_color": Color(1.0, 1.0, 1.0),
	"key_light_energy": 2.0,
	"key_light_position": Vector3(0.0, 3.0, 0.0),
	"fill_light_color": Color(0.98, 0.98, 1.0),
	"fill_light_energy": 0.8,
	"fill_light_position": Vector3(-1.0, 2.5, 1.0),
	"rim_light_color": Color(0.96, 0.98, 1.0),
	"rim_light_energy": 0.8,
	"rim_light_position": Vector3(1.0, 2.5, -1.0),
	"ambient_light_color": Color(0.95, 0.95, 0.98),
	"ambient_light_energy": 0.15
	}

	# Custom preset (initially same as Educational)
	_preset_data[LightingPreset.CUSTOM] = _preset_data[LightingPreset.EDUCATIONAL].duplicate()


func apply_preset(lighting_preset: int) -> bool:
	"""Apply a predefined lighting preset for medical education"""
	if lighting_preset < 0 or lighting_preset > LightingPreset.CUSTOM:
		push_warning("[MedicalLighting] Invalid preset: " + str(lighting_preset))
		return false

		active_preset = lighting_preset
		# No need to call _apply_preset here as the setter does that

		return true


		## Create a custom lighting preset
		## @param key_color: Color for key light
		## @param key_energy: float energy for key light
		## @param fill_color: Color for fill light
		## @param fill_energy: float energy for fill light
		## @param rim_color: Color for rim light
		## @param rim_energy: float energy for rim light
		## @param ambient_color: Color for ambient light
		## @param ambient_energy: float energy for ambient light
		## @returns: bool indicating success
func create_custom_preset(
	key_color: Color,
	key_energy: float,
	fill_color: Color,
	fill_energy: float,
	rim_color: Color,
	rim_energy: float,
	ambient_color: Color,
	ambient_energy: float
	) -> bool:
		"""Create a custom lighting preset"""
		# Store custom preset settings
func focus_on_position(position: Vector3, transition_time: float = 0.0) -> bool:
	"""Adjust lighting to focus on a specific position"""
	if not _initialized:
		return false

		# Calculate light positions based on focus point
func adjust_intensity(intensity_multiplier: float) -> bool:
	"""Adjust the intensity of all lights by a multiplier"""
	if not _initialized:
		return false

		intensity_multiplier = max(0.1, intensity_multiplier)

func save_current_as_custom() -> bool:
	"""Save the current lighting setup as a custom preset"""
	return create_custom_preset(
	key_light_color,
	key_light_energy,
	fill_light_color,
	fill_light_energy,
	rim_light_color,
	rim_light_energy,
	ambient_light_color,
	ambient_light_energy
	)


	## Reset lighting to default for current preset
	## @returns: bool indicating success
func reset_to_preset_default() -> bool:
	"""Reset lighting to the default values for the current preset"""
	if not _preset_data.has(active_preset):
		return false

		_apply_preset(active_preset)
		return true


		# === PRIVATE METHODS ===

func _fix_orphaned_code():
	if _initialized:
		_apply_preset(active_preset)
		preset_changed.emit(active_preset)

		## Whether to use HDR lighting
func _fix_orphaned_code():
	if _initialized:
		_update_environment()

		## Enable ambient occlusion for enhanced depth perception
func _fix_orphaned_code():
	if _initialized:
		_update_environment()

		## Enable subtle bloom effect
func _fix_orphaned_code():
	if _initialized:
		_update_environment()

		# === KEY LIGHT PROPERTIES ===
		## Key light color
func _fix_orphaned_code():
	if _key_light:
		_key_light.light_color = key_light_color
		light_property_changed.emit("key", "color")

		## Key light energy
func _fix_orphaned_code():
	if _key_light:
		_key_light.light_energy = key_light_energy
		light_property_changed.emit("key", "energy")

		## Key light position
func _fix_orphaned_code():
	if _key_light:
		_key_light.position = key_light_position
		light_property_changed.emit("key", "position")

		# === FILL LIGHT PROPERTIES ===
		## Fill light color
func _fix_orphaned_code():
	if _fill_light:
		_fill_light.light_color = fill_light_color
		light_property_changed.emit("fill", "color")

		## Fill light energy
func _fix_orphaned_code():
	if _fill_light:
		_fill_light.light_energy = fill_light_energy
		light_property_changed.emit("fill", "energy")

		## Fill light position
func _fix_orphaned_code():
	if _fill_light:
		_fill_light.position = fill_light_position
		light_property_changed.emit("fill", "position")

		# === RIM LIGHT PROPERTIES ===
		## Rim light color
func _fix_orphaned_code():
	if _rim_light:
		_rim_light.light_color = rim_light_color
		light_property_changed.emit("rim", "color")

		## Rim light energy
func _fix_orphaned_code():
	if _rim_light:
		_rim_light.light_energy = rim_light_energy
		light_property_changed.emit("rim", "energy")

		## Rim light position
func _fix_orphaned_code():
	if _rim_light:
		_rim_light.position = rim_light_position
		light_property_changed.emit("rim", "position")

		# === AMBIENT LIGHT PROPERTIES ===
		## Ambient light color
func _fix_orphaned_code():
	if _environment:
		_environment.ambient_light_color = ambient_light_color
		light_property_changed.emit("ambient", "color")

		## Ambient light energy
func _fix_orphaned_code():
	if _environment:
		_environment.ambient_light_energy = ambient_light_energy
		light_property_changed.emit("ambient", "energy")

		# === PRIVATE VARIABLES ===

func _fix_orphaned_code():
	return true


	## Focus lighting on a specific position
	## @param position: Vector3 position to focus lighting on
	## @param transition_time: float time for transition in seconds (0 for instant)
	## @returns: bool indicating success
func _fix_orphaned_code():
	if transition_time <= 0.0:
		# Instant transition
		_key_light.position = new_key_position
		_fill_light.position = new_fill_position
		_rim_light.position = new_rim_position

		key_light_position = new_key_position
		fill_light_position = new_fill_position
		rim_light_position = new_rim_position
		else:
			# Animated transition
			_animate_property(
			_key_light, "position", _key_light.position, new_key_position, transition_time
			)
			_animate_property(
			_fill_light, "position", _fill_light.position, new_fill_position, transition_time
			)
			_animate_property(
			_rim_light, "position", _rim_light.position, new_rim_position, transition_time
			)

			# Wait for animation to complete
			await get_tree().create_timer(transition_time).timeout

			# Update exported properties
			key_light_position = new_key_position
			fill_light_position = new_fill_position
			rim_light_position = new_rim_position

			return true


			## Adjust light intensity for all lights
			## @param intensity_multiplier: float to multiply all light energies by
			## @returns: bool indicating success
func _fix_orphaned_code():
	return true


	## Save current lighting setup as a custom preset
	## @returns: bool indicating success
func _fix_orphaned_code():
	if _key_light:
		_key_light.look_at(Vector3.ZERO)

		print("[MedicalLighting] Applied preset: " + _get_preset_name(lighting_preset))


func _create_lighting_components() -> void:
	"""Create the three-point lighting components for professional medical visualization

	Three-point lighting is the standard in medical photography and visualization:
		- Key light: Primary illumination defining form and structure
		- Fill light: Reduces harsh shadows, reveals detail in crevices
		- Rim light: Separates subject from background, enhances 3D perception
		"""
		# Key Light - Primary directional illumination
		# Medical purpose: Defines anatomical form through controlled shadows,
		# essential for understanding 3D brain structure
		_key_light = DirectionalLight3D.new()
		_key_light.name = "KeyLight"
		_key_light.shadow_enabled = true
		_key_light.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
		_key_light.directional_shadow_blend_splits = true
		_key_light.directional_shadow_depth_range = DirectionalLight3D.SHADOW_DEPTH_RANGE_STABLE
		_key_light.light_bake_mode = Light3D.BAKE_DYNAMIC
		_key_light.light_color = key_light_color
		_key_light.light_energy = key_light_energy
		_key_light.position = key_light_position
		_key_light.look_at(Vector3.ZERO)
		add_child(_key_light)

		# Fill Light - Soft omnidirectional light to reduce harsh shadows
		# Medical purpose: Reveals anatomical detail in shadowed areas like
		# deep sulci and fissures, preventing loss of important structures
		_fill_light = OmniLight3D.new()
		_fill_light.name = "FillLight"
		_fill_light.shadow_enabled = true
		_fill_light.omni_shadow_mode = OmniLight3D.SHADOW_DUAL_PARABOLOID
		_fill_light.shadow_blur = 2.0
		_fill_light.light_color = fill_light_color
		_fill_light.light_energy = fill_light_energy
		_fill_light.omni_range = 10.0
		_fill_light.position = fill_light_position
		add_child(_fill_light)

		# Rim Light - Backlighting for edge definition and depth separation
		# Medical purpose: Creates subtle edge highlighting that helps distinguish
		# overlapping structures and enhances perception of anatomical layers
		_rim_light = OmniLight3D.new()
		_rim_light.name = "RimLight"
		_rim_light.shadow_enabled = false
		_rim_light.light_color = rim_light_color
		_rim_light.light_energy = rim_light_energy
		_rim_light.omni_range = 8.0
		_rim_light.position = rim_light_position
		add_child(_rim_light)


func _create_environment() -> void:
	"""Create the environment settings optimized for medical visualization"""
	_environment = Environment.new()

	# Basic settings - Dark background reduces eye strain and enhances contrast
	_environment.background_mode = Environment.BG_COLOR
	_environment.background_color = Color(0.05, 0.05, 0.05)

	# Ambient light - Provides base illumination to prevent complete shadows
	# in deep brain structures like sulci
	_environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	_environment.ambient_light_color = ambient_light_color
	_environment.ambient_light_energy = ambient_light_energy

	# HDR Tone mapping - Critical for medical visualization
	# Medical importance: HDR reveals subtle tissue density variations that
	# help distinguish between gray matter, white matter, and pathological tissue
	if use_hdr:
		_environment.tonemap_mode = Environment.TONE_MAPPER_ACES
		_environment.tonemap_exposure = 1.0
		_environment.tonemap_white = 1.0
		else:
			_environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR

			# SSAO (Screen Space Ambient Occlusion) - Enhances anatomical depth perception
			# Medical importance: Makes gyri and sulci boundaries more distinct,
			# crucial for identifying cortical regions and understanding brain topology
			if ambient_occlusion_enabled:
				_environment.ssao_enabled = true
				_environment.ssao_radius = 1.0
				_environment.ssao_intensity = 1.0
				_environment.ssao_detail = 0.5
				_environment.ssao_horizon = 0.06
				_environment.ssao_sharpness = 0.98

				# Subtle bloom effect - Used judiciously for realism
				# Medical note: Minimal bloom prevents loss of fine anatomical detail
				# while adding subtle realism to highlighted structures
				if bloom_enabled:
					_environment.glow_enabled = true
					_environment.glow_normalized = true
					_environment.glow_intensity = 0.2
					_environment.glow_bloom = 0.1
					_environment.glow_blend_mode = Environment.GLOW_BLEND_ADDITIVE

					# Create WorldEnvironment
					_world_environment = WorldEnvironment.new()
					_world_environment.name = "MedicalEnvironment"
					_world_environment.environment = _environment
					add_child(_world_environment)


func _apply_preset(lighting_preset: int) -> void:
	"""Apply a preset to the lighting setup"""
	if not _preset_data.has(lighting_preset):
		push_warning("[MedicalLighting] Preset not found: " + str(lighting_preset))
		return

func _update_environment() -> void:
	"""Update environment settings based on current properties"""
	if not _environment:
		return

		# Update tone mapping
		if use_hdr:
			_environment.tonemap_mode = Environment.TONE_MAPPER_ACES
			else:
				_environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR

				# Update ambient occlusion
				_environment.ssao_enabled = ambient_occlusion_enabled

				# Update bloom
				_environment.glow_enabled = bloom_enabled

				# Update ambient light
				_environment.ambient_light_color = ambient_light_color
				_environment.ambient_light_energy = ambient_light_energy


func _animate_property(
	target_object: Object,
	property_name: String,
	start_value: Variant,
	end_value: Variant,
	duration: float
	) -> void:
		"""Animate a property over time for smooth lighting transitions"""
func _get_preset_name(lighting_preset: int) -> String:
	"""Get the name of a preset from its enum value for display purposes"""
	match lighting_preset:
		LightingPreset.EDUCATIONAL:
			return "Educational"
			LightingPreset.CLINICAL:
				return "Clinical"
				LightingPreset.PRESENTATION:
					return "Presentation"
					LightingPreset.EXAMINATION:
						return "Examination"
						LightingPreset.SURGICAL:
							return "Surgical"
							LightingPreset.CUSTOM:
								return "Custom"
								_:
									return "Unknown"
