## {{CLASS_NAME}}.gd
## {{CLASS_DESCRIPTION}}
##
## {{DETAILED_DESCRIPTION}}
##
## @tutorial: {{TUTORIAL_URL}}
## @experimental: {{IS_EXPERIMENTAL}}

extends {{BASE_CLASS}}

# === CONSTANTS ===
const {{CONSTANT_NAME}}: {{TYPE}} = {{VALUE}}

# === SIGNALS ===
## {{SIGNAL_DESCRIPTION}}
## @param {{PARAM_NAME}}: {{PARAM_DESCRIPTION}}
signal {{SIGNAL_NAME}}({{PARAM_NAME}}: {{PARAM_TYPE}})

# === EXPORTS ===
## {{EXPORT_DESCRIPTION}}

@export var {{EXPORT_VAR}}: {{TYPE}} = {{DEFAULT_VALUE}}

# === PUBLIC VARIABLES ===
var {{PUBLIC_VAR}}: {{TYPE}}

# === PRIVATE VARIABLES ===
var _{{PRIVATE_VAR}}: {{TYPE}}

var _is_initialized: bool = false

# === LIFECYCLE METHODS ===

func _ready() -> void:
	"""Initialize the {{CLASS_NAME}} component"""
	_initialize()

func _process(delta: float) -> void:
	"""Called every frame"""
	if not _is_initialized:
		return

		# Process logic here
		pass

		# === PUBLIC METHODS ===
		## {{METHOD_DESCRIPTION}}
		## @param {{PARAM_NAME}}: {{PARAM_DESCRIPTION}}
		## @return: {{RETURN_DESCRIPTION}}
func {{METHOD_NAME}}({{PARAM_NAME}}: {{PARAM_TYPE}}) -> {{RETURN_TYPE}}:
	"""{{METHOD_DOCUMENTATION}}"""

	# Validation
	if {{VALIDATION_CONDITION}}:
		push_error("[{{CLASS_NAME}}] {{ERROR_MESSAGE}}")
		return {{ERROR_RETURN_VALUE}}

		# Implementation
		# TODO: Implement method logic

		return {{SUCCESS_RETURN_VALUE}}

		# === PRIVATE METHODS ===
func _initialize() -> void:
	"""Initialize the component with default settings"""

	# Setup validation
	if not _validate_setup():
		push_error("[{{CLASS_NAME}}] Failed to initialize - invalid setup")
		return

		# Initialize subsystems
		_setup_connections()
		_apply_initial_state()

		_is_initialized = true
		print("[{{CLASS_NAME}}] Initialized successfully")

func _exit_tree() -> void:
	"""Clean up when node is removed from tree"""
	_cleanup()

func _validate_setup() -> bool:
	"""Validate that all required dependencies are available"""

	# Add validation logic
	return true

func _setup_connections() -> void:
	"""Setup signal connections and dependencies"""

	# Connect signals here
	pass

func _apply_initial_state() -> void:
	"""Apply initial state and configuration"""

	# Set initial state here
	pass

func _cleanup() -> void:
	"""Clean up resources and connections"""

	# Cleanup logic here
	_is_initialized = false

	# === EVENT HANDLERS ===
func _on_{{EVENT_NAME}}({{PARAM_NAME}}: {{PARAM_TYPE}}) -> void:
	"""Handle {{EVENT_DESCRIPTION}}"""

	if not _is_initialized:
		return

		# Event handling logic
		pass

		# === UTILITY METHODS ===
func _log_debug(message: String) -> void:
	"""Log debug message with class context"""
	if OS.is_debug_build():
		print("[{{CLASS_NAME}}] " + message)

func _log_error(message: String) -> void:
	"""Log error message with class context"""
	push_error("[{{CLASS_NAME}}] " + message)

	# === CLEANUP ===
class_name {{CLASS_NAME}}
