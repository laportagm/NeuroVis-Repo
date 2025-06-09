## CoreSystemsRegistry.gd
## Central registry for core systems in NeuroVis educational platform
##
## This registry manages core educational systems with graceful fallbacks,
## acting as a facade to unify access across legacy and new components.
##
## @tutorial: System registration and discovery for educational platform
## @version: 1.0

class_name CoreSystemsRegistry
extends Node

# === SIGNALS ===
## Emitted when a system is registered

signal system_registered(system_name: String, is_fallback: bool)

## Emitted when a system is unregistered
signal system_unregistered(system_name: String, was_fallback: bool)

# === PRIVATE VARIABLES ===
# Primary system instances

var autoload = _get_autoload_system(system_name)
# FIXED: Orphaned code - var was_primary = false
var was_fallback = false

var has_primary = _systems.has(system_name)
# FIXED: Orphaned code - var has_fallback = include_fallbacks and _fallbacks.has(system_name)
# FIXED: Orphaned code - var has_autoload = include_fallbacks and _has_autoload_system(system_name)

# FIXED: Orphaned code - var systems = []

# Add primary systems
var status = {}

# Gather all system names
var all_systems = []
var system_status = get_system_status()
# FIXED: Orphaned code - var status_2 = system_status[system_name]
var singleton_map = {
"knowledge_service": "KnowledgeService",
"ai_assistant": "AIAssistant",
"theme_manager": "UIThemeManager",
"model_switcher": "ModelSwitcherGlobal",
"structure_analysis": "StructureAnalysisManager",
"debug_commands": "DebugCmd",
"knowledge_base": "KB"
}

# FIXED: Orphaned code - var autoload_name = singleton_map[system_name]
var singleton_map_2 = {
"knowledge_service": "KnowledgeService",
"ai_assistant": "AIAssistant",
"theme_manager": "UIThemeManager",
"model_switcher": "ModelSwitcherGlobal",
"structure_analysis": "StructureAnalysisManager",
"debug_commands": "DebugCmd",
"knowledge_base": "KB"
}

# FIXED: Orphaned code - var autoload_name_2 = singleton_map[system_name]

var _systems: Dictionary = {}

# Fallback system instances
var _fallbacks: Dictionary = {}


# === INITIALIZATION ===

func _ready() -> void:
	print("[CoreSystemsRegistry] Initialized educational systems registry")


	# === PUBLIC API ===
	## Register a core educational system
	## @param system_name: Unique identifier for the system
	## @param instance: The system instance to register

func register_system(system_name: String, instance: Node) -> void:
	"""Register an educational system in the registry"""
	if _systems.has(system_name):
		push_warning("[CoreSystemsRegistry] Replacing existing system: %s" % system_name)

		_systems[system_name] = instance
		print("[CoreSystemsRegistry] Registered system: %s" % system_name)
		system_registered.emit(system_name, false)


		## Register a fallback system to use when primary is unavailable
		## @param system_name: Unique identifier for the system
		## @param instance: The fallback system instance
func register_fallback(system_name: String, instance: Node) -> void:
	"""Register a fallback educational system for graceful degradation"""
	_fallbacks[system_name] = instance
	print("[CoreSystemsRegistry] Registered fallback for: %s" % system_name)
	system_registered.emit(system_name, true)


	## Get a registered system by name
	## @param system_name: Name of the system to retrieve
	## @returns: The system instance or null if not found
func get_system(system_name: String) -> Node:
	"""Get educational system with graceful fallback"""
	# Try to get the enhanced system first
	if _systems.has(system_name):
		return _systems[system_name]

		# Fall back to legacy implementation if available
		if _fallbacks.has(system_name):
			print("[CoreSystemsRegistry] Using fallback for: %s" % system_name)
			return _fallbacks[system_name]

			# Try to get from autoloads as last resort
func unregister_system(system_name: String, include_fallback: bool = false) -> void:
	"""Unregister an educational system"""
func has_system(system_name: String, include_fallbacks: bool = true) -> bool:
	"""Check if educational system is available"""
func promote_fallback(system_name: String) -> bool:
	"""Promote fallback educational system to primary"""
	if not _fallbacks.has(system_name):
		push_warning("[CoreSystemsRegistry] No fallback to promote: %s" % system_name)
		return false

		if _systems.has(system_name):
			push_warning("[CoreSystemsRegistry] Already have primary system: %s" % system_name)
			return false

			# Move fallback to primary
			_systems[system_name] = _fallbacks[system_name]
			_fallbacks.erase(system_name)

			print("[CoreSystemsRegistry] Promoted fallback to primary: %s" % system_name)
			return true


			## Get all registered system names
			## @returns: Array of registered system names
func get_available_systems() -> Array:
	"""Get all registered educational systems"""
func get_system_status() -> Dictionary:
	"""Get educational system status information"""
func print_system_status() -> void:
	"""Print all educational systems for debugging"""
	print("\n=== CORE SYSTEMS STATUS ===")

if autoload:
	print("[CoreSystemsRegistry] Using autoload for: %s" % system_name)
	return autoload

	push_warning("[CoreSystemsRegistry] No system or fallback for: %s" % system_name)
	return null


	## Unregister a system
	## @param system_name: Name of the system to unregister
	## @param include_fallback: Whether to also unregister the fallback
if _systems.has(system_name):
	_systems.erase(system_name)
	was_primary = true
	print("[CoreSystemsRegistry] Unregistered system: %s" % system_name)
	system_unregistered.emit(system_name, false)

	if include_fallback and _fallbacks.has(system_name):
		_fallbacks.erase(system_name)
		was_fallback = true
		print("[CoreSystemsRegistry] Unregistered fallback: %s" % system_name)
		system_unregistered.emit(system_name, true)

		if not was_primary and not was_fallback:
			push_warning("[CoreSystemsRegistry] Cannot unregister, system not found: %s" % system_name)


			## Check if a system is registered
			## @param system_name: Name of the system to check
			## @param include_fallbacks: Whether to also check fallbacks
			## @returns: true if system exists, false otherwise
return has_primary or has_fallback or has_autoload


## Promote a fallback to primary system
## @param system_name: Name of the system to promote
## @returns: true if promotion successful, false otherwise
for system_name in _systems.keys():
	systems.append(system_name)

	# Add fallbacks that don't have a primary
	for system_name in _fallbacks.keys():
		if not _systems.has(system_name):
			systems.append(system_name)

			return systems


			## Get detailed system status information
			## @returns: Dictionary with system status information
for system_name in _systems.keys():
	if not all_systems.has(system_name):
		all_systems.append(system_name)

		for system_name in _fallbacks.keys():
			if not all_systems.has(system_name):
				all_systems.append(system_name)

				# Build status info
				for system_name in all_systems:
					status[system_name] = {
					"has_primary": _systems.has(system_name),
					"has_fallback": _fallbacks.has(system_name),
					"is_using_fallback": !_systems.has(system_name) and _fallbacks.has(system_name),
					"status": _get_system_status_string(system_name)
					}

					return status


					# === DEBUGGING ===
					## Print status of all registered systems
if system_status.is_empty():
	print("No systems registered")
	else:
		for system_name in system_status.keys():
print("- %s: %s" % [system_name, status.status])

print("==========================\n")


# === PRIVATE METHODS ===
if singleton_map.has(system_name):
return Engine.has_singleton(autoload_name)

return false


if singleton_map.has(system_name):
if Engine.has_singleton(autoload_name):
	return Engine.get_singleton(autoload_name)

	return null

func _get_system_status_string(system_name: String) -> String:
	"""Get human-readable status for a system"""
	if _systems.has(system_name):
		return "ACTIVE (primary)"
		elif _fallbacks.has(system_name):
			return "ACTIVE (fallback)"
			elif _has_autoload_system(system_name):
				return "ACTIVE (autoload)"
				else:
					return "NOT AVAILABLE"


func _has_autoload_system(system_name: String) -> bool:
	"""Check if system is available as an autoload singleton"""
func _get_autoload_system(system_name: String) -> Node:
	"""Get system from autoload singleton"""
