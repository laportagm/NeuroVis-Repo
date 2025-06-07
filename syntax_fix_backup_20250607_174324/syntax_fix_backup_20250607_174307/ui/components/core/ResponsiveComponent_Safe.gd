## ResponsiveComponent_Safe.gd
## Safe version of ResponsiveComponent with no external dependencies

class_name ResponsiveComponentSafe
extends Control

# === RESPONSIVE SYSTEM ===

signal breakpoint_changed(old_breakpoint: String, new_breakpoint: String)
signal orientation_changed(is_portrait: bool)
signal layout_adapted(layout_name: String)

# === BREAKPOINT SYSTEM ===

enum Breakpoint { MOBILE, TABLET_PORTRAIT, TABLET_LANDSCAPE, DESKTOP, WIDE_DESKTOP }

const BREAKPOINT_WIDTHS = {
	Breakpoint.MOBILE: 480,
	Breakpoint.TABLET_PORTRAIT: 768,
	Breakpoint.TABLET_LANDSCAPE: 1024,
	Breakpoint.DESKTOP: 1440,
	Breakpoint.WIDE_DESKTOP: 1920
}

const BREAKPOINT_NAMES = {
	Breakpoint.MOBILE: "mobile",
	Breakpoint.TABLET_PORTRAIT: "tablet_portrait",
	Breakpoint.TABLET_LANDSCAPE: "tablet_landscape",
	Breakpoint.DESKTOP: "desktop",
	Breakpoint.WIDE_DESKTOP: "wide_desktop"
}

# === CONFIGURATION ===

@export var responsive_enabled: bool = true
@export var enable_logging: bool = false
@export var component_id: String = ""

# === STATE ===

var current_breakpoint: Breakpoint = Breakpoint.DESKTOP
var is_portrait_orientation: bool = false
var last_viewport_size: Vector2 = Vector2.ZERO


	var viewport = get_viewport()
	if viewport:
		viewport.size_changed.connect(_on_viewport_size_changed)


	var viewport = get_viewport()
	if not viewport:
		return

	var viewport_size = viewport.get_visible_rect().size
	if viewport_size == last_viewport_size:
		return

	last_viewport_size = viewport_size

	# Determine breakpoint
	var old_breakpoint = current_breakpoint
	_update_breakpoint(viewport_size)

	# Check orientation
	var was_portrait = is_portrait_orientation
	is_portrait_orientation = viewport_size.y > viewport_size.x

	# Emit signals if changes occurred
	if old_breakpoint != current_breakpoint:
		breakpoint_changed.emit(
			BREAKPOINT_NAMES[old_breakpoint], BREAKPOINT_NAMES[current_breakpoint]
		)
		_log(
			(
				"Breakpoint changed: "
				+ BREAKPOINT_NAMES[old_breakpoint]
				+ " -> "
				+ BREAKPOINT_NAMES[current_breakpoint]
			)
		)

	if was_portrait != is_portrait_orientation:
		orientation_changed.emit(is_portrait_orientation)
		_log("Orientation changed to: " + ("portrait" if is_portrait_orientation else "landscape"))

	# Apply responsive layout
	_apply_responsive_layout()


	var width = viewport_size.x

	if width < BREAKPOINT_WIDTHS[Breakpoint.MOBILE]:
		current_breakpoint = Breakpoint.MOBILE
	elif width < BREAKPOINT_WIDTHS[Breakpoint.TABLET_PORTRAIT]:
		current_breakpoint = Breakpoint.MOBILE
	elif width < BREAKPOINT_WIDTHS[Breakpoint.TABLET_LANDSCAPE]:
		current_breakpoint = Breakpoint.TABLET_PORTRAIT
	elif width < BREAKPOINT_WIDTHS[Breakpoint.DESKTOP]:
		current_breakpoint = Breakpoint.TABLET_LANDSCAPE
	elif width < BREAKPOINT_WIDTHS[Breakpoint.WIDE_DESKTOP]:
		current_breakpoint = Breakpoint.DESKTOP
	else:
		current_breakpoint = Breakpoint.WIDE_DESKTOP


	var prefix = "[ResponsiveComponentSafe:" + component_id + "] "
	match level:
		"error":
			push_error(prefix + message)
		"warning":
			push_warning(prefix + message)
		_:
			print(prefix + message)

func _ready() -> void:
	"""Initialize responsive component"""
	if component_id.is_empty():
		component_id = "responsive_" + str(get_instance_id())

	if responsive_enabled:
		_connect_viewport_signals()
		call_deferred("_adapt_to_viewport")


func get_current_breakpoint() -> String:
	"""Get current breakpoint name"""
	return BREAKPOINT_NAMES[current_breakpoint]


func get_current_breakpoint_enum() -> Breakpoint:
	"""Get current breakpoint enum"""
	return current_breakpoint


func is_mobile_size() -> bool:
	"""Check if current size is mobile"""
	return current_breakpoint == Breakpoint.MOBILE


func is_tablet_size() -> bool:
	"""Check if current size is tablet"""
	return current_breakpoint in [Breakpoint.TABLET_PORTRAIT, Breakpoint.TABLET_LANDSCAPE]


func is_desktop_size() -> bool:
	"""Check if current size is desktop"""
	return current_breakpoint in [Breakpoint.DESKTOP, Breakpoint.WIDE_DESKTOP]


func set_responsive_enabled(enabled: bool) -> void:
	"""Enable/disable responsive behavior"""
	responsive_enabled = enabled
	if enabled:
		_adapt_to_viewport()


# === UTILITY METHODS ===

func _connect_viewport_signals() -> void:
	"""Connect to viewport size changes"""
func _on_viewport_size_changed() -> void:
	"""Handle viewport size change"""
	if responsive_enabled:
		_adapt_to_viewport()


func _adapt_to_viewport() -> void:
	"""Adapt component to current viewport size"""
func _update_breakpoint(viewport_size: Vector2) -> void:
	"""Update current breakpoint based on viewport width"""
func _apply_responsive_layout() -> void:
	"""Apply responsive layout - override in derived classes"""
	layout_adapted.emit(BREAKPOINT_NAMES[current_breakpoint])


# === PUBLIC API ===
func _log(message: String, level: String = "info") -> void:
	"""Component logging"""
	if not enable_logging:
		return
