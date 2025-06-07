## ServiceLocator.gd
## Service locator pattern implementation for NeuroVis educational platform
##
## This system provides a central registry for educational services,
## enabling better testability and reducing direct dependencies.
##
## @tutorial: Dependency management for educational platform
## @version: 1.0

class_name ServiceLocator
extends Node

# === PRIVATE VARIABLES ===
# Map of service names to service instances

		var instance = _create_service_from_factory(service_name)
		if instance:
			return instance

	# Try fallback service
	if _fallback_services.has(service_name):
		print("[ServiceLocator] Using fallback for: %s" % service_name)
		return _fallback_services[service_name]

	# Service not found
	push_warning("[ServiceLocator] Service not found: %s" % service_name)
	return null


## Check if a service is registered
## @param service_name: Name of the service to check
## @returns: true if service exists (including fallbacks), false otherwise
	var services = []

	# Add primary services
	for service_name in _services.keys():
		services.append(service_name)

	# Add factories that don't have an instance yet
	for factory_name in _factories.keys():
		if not _services.has(factory_name):
			services.append(factory_name + " (factory)")

	# Add fallbacks that don't have a primary
	for fallback_name in _fallback_services.keys():
		if not _services.has(fallback_name) and not _factories.has(fallback_name):
			services.append(fallback_name + " (fallback)")

	return services


# === DEBUGGING ===
## Print the status of all registered services
		var status = "Available"
		if service_name.ends_with(" (factory)"):
			status = "Not initialized (factory available)"
		elif service_name.ends_with(" (fallback)"):
			status = "Using fallback"

		print("- %s: %s" % [service_name.split(" ")[0], status])

	print("=============================\n")


# === PRIVATE METHODS ===
	var factory = _factories[service_name]
	var instance = null

	if factory.is_valid():
		instance = factory.call()

		# Cache created instance
		if instance:
			_services[service_name] = instance
			print("[ServiceLocator] Service created successfully: %s" % service_name)
		else:
			push_error("[ServiceLocator] Factory returned null for: %s" % service_name)
	else:
		push_error("[ServiceLocator] Invalid factory for: %s" % service_name)

	return instance

var _services: Dictionary = {}

# Fallback services when primary is unavailable
var _fallback_services: Dictionary = {}

# Service factories for lazy initialization
var _factories: Dictionary = {}


# === INITIALIZATION ===

func _ready() -> void:
	print("[ServiceLocator] Initialized educational service registry")


# === PUBLIC API ===
## Register a service with the locator
## @param service_name: Unique identifier for the service
## @param service_instance: The service instance to register

func register_service(service_name: String, service_instance) -> void:
	"""Register an educational service in the registry"""
	if _services.has(service_name):
		push_warning("[ServiceLocator] Replacing existing service: %s" % service_name)

	_services[service_name] = service_instance
	print("[ServiceLocator] Registered service: %s" % service_name)


## Register a fallback service to use when primary is unavailable
## @param service_name: Unique identifier for the service
## @param fallback_instance: The fallback service instance
func register_fallback(service_name: String, fallback_instance) -> void:
	"""Register a fallback educational service for graceful degradation"""
	_fallback_services[service_name] = fallback_instance
	print("[ServiceLocator] Registered fallback for: %s" % service_name)


## Register a factory function to create service on demand
## @param service_name: Unique identifier for the service
## @param factory: Callable that creates and returns the service
func register_factory(service_name: String, factory: Callable) -> void:
	"""Register factory for lazy educational service initialization"""
	_factories[service_name] = factory
	print("[ServiceLocator] Registered factory for: %s" % service_name)


## Get a service by name
## @param service_name: Name of the service to retrieve
## @returns: The service instance or null if not found
func get_service(service_name: String):
	"""Get educational service from registry with fallback support"""
	# Check if we already have the service
	if _services.has(service_name):
		return _services[service_name]

	# Try to create using factory if available
	if _factories.has(service_name):
func has_service(service_name: String) -> bool:
	"""Check if educational service is available (including fallbacks)"""
	return (
		_services.has(service_name)
		or _fallback_services.has(service_name)
		or _factories.has(service_name)
	)


## Unregister a service
## @param service_name: Name of the service to remove
func unregister_service(service_name: String) -> void:
	"""Unregister an educational service"""
	if _services.has(service_name):
		_services.erase(service_name)
		print("[ServiceLocator] Unregistered service: %s" % service_name)
	else:
		push_warning("[ServiceLocator] Cannot unregister, service not found: %s" % service_name)


## Get all registered service names
## @returns: Array of registered service names
func get_available_services() -> Array:
	"""Get list of all available educational services"""
func print_service_status() -> void:
	"""Print all educational services for debugging"""
	print("\n=== SERVICE LOCATOR STATUS ===")
	print("Registered services: %d" % _services.size())

	for service_name in get_available_services():

func _create_service_from_factory(service_name: String):
	"""Create service instance from registered factory"""
	if not _factories.has(service_name):
		return null

	print("[ServiceLocator] Creating service from factory: %s" % service_name)

	# Create service instance
