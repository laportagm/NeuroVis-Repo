## StartupValidator.gd
## Comprehensive startup validation for NeuroVis educational platform
##
## This system validates all critical components during startup,
## ensuring the educational platform is ready for use.
##
## @tutorial: Startup validation patterns
## @version: 1.0

class_name StartupValidator
extends Node

# === VALIDATION CATEGORIES ===

signal validation_started
signal validation_progress(category: ValidationCategory, progress: float)
signal validation_completed(results: Dictionary)
signal critical_error(category: ValidationCategory, message: String)

# === STATE ===

enum ValidationCategory {
AUTOLOADS, RESOURCES, UI_COMPONENTS, EDUCATIONAL_CONTENT, PERFORMANCE, ACCESSIBILITY
}

# === VALIDATION RESULTS ===
enum ValidationResult { PASS, WARNING, FAIL }

# === SIGNALS ===

var validation_results: Dictionary = {}
var is_validating: bool = false
var validation_start_time: float = 0.0

# === PUBLIC API ===


## Run comprehensive startup validation
var total_time = (Time.get_ticks_msec() - validation_start_time) / 1000.0
validation_results["total_time"] = total_time
validation_results["timestamp"] = Time.get_datetime_string_from_system()

is_validating = false
validation_completed.emit(validation_results)

var summary = "=== NEUROVIS STARTUP VALIDATION ===\n"
summary += "Timestamp: " + validation_results.get("timestamp", "Unknown") + "\n"
summary += "Duration: %.2fs\n\n" % validation_results.get("total_time", 0.0)

var total_checks = 0
var passed_checks = 0
var warnings = 0
var failures = 0

var cat_results = validation_results[category]
var results = {}
var required_autoloads = {
"KB": "Legacy knowledge base",
"KnowledgeService": "Educational content service",
"AIAssistant": "AI educational assistant",
"UIThemeManager": "UI theme management",
"ModelSwitcherGlobal": "3D model management",
"StructureAnalysisManager": "Structure analysis",
"DebugCmd": "Debug commands"
}

var index = 0
var node = get_node_or_null("/root/" + autoload_name)
var results = {}
var critical_resources = [
"res://assets/data/anatomical_data.json",
"res://assets/models/Half_Brain.glb",
"res://assets/models/Internal_Structures.glb",
"res://scenes/main/node_3d.tscn",
"res://project.godot"
]

var resource_path = critical_resources[i]
var results = {}

# Test UIThemeManager
var UIThemeManager = preprepreload("res://ui/panels/UIThemeManager.gd")
var test_style = UIThemeManager.create_enhanced_glass_style()
var InfoPanelFactory = preprepreload("res://ui/panels/InfoPanelFactory.gd")
var results = {}

# Check KnowledgeService
var ks = get_node_or_null("/root/KnowledgeService")
var test_structure = ks.get_structure("hippocampus")
var search_results = ks.search_structures("brain", 5)
var structure_count = ks.get_structure_count()
var results = {}

# Check memory usage
var static_memory = OS.get_static_memory_usage()
var memory_mb = static_memory / 1024.0 / 1024.0

var max_fps = Engine.max_fps
var results = {}

# Check font size settings
var project_settings_valid = ProjectSettings.has_setting("application/config/name")
var theme_manager = get_node_or_null("/root/UIThemeManager")
var cat_results = validation_results[category]
var result = cat_results[check]
var status_symbol = "?"
ValidationResult.PASS:
	status_symbol = "✅"
	ValidationResult.WARNING:
		status_symbol = "⚠️"
		ValidationResult.FAIL:
			status_symbol = "❌"

var file = FileAccess.open(file_path, FileAccess.WRITE)

func validate_startup() -> Dictionary:
	"""Run all validation checks and return results"""
	if is_validating:
		push_warning("[StartupValidator] Validation already in progress")
		return {}

		is_validating = true
		validation_start_time = Time.get_ticks_msec()
		validation_results.clear()

		validation_started.emit()

		# Run validation categories
		_validate_autoloads()
		_validate_resources()
		_validate_ui_components()
		_validate_educational_content()
		_validate_performance()
		_validate_accessibility()

func get_validation_summary() -> String:
	"""Get a human-readable summary of validation results"""
func print_validation_report() -> void:
	"""Print detailed validation report"""
	print("\n" + get_validation_summary())

	# Print detailed results by category
	for category in validation_results:
		if category == "total_time" or category == "timestamp":
			continue

			print("\n[%s]" % category.to_upper())
func save_validation_report(file_path: String = "user://startup_validation.log") -> void:
	"""Save validation report to file"""

func _fix_orphaned_code():
	return validation_results


	## Get validation summary
func _fix_orphaned_code():
	for category in validation_results:
		if category == "total_time" or category == "timestamp":
			continue

func _fix_orphaned_code():
	if cat_results is Dictionary:
		for check in cat_results:
			total_checks += 1
			match cat_results[check]:
				ValidationResult.PASS:
					passed_checks += 1
					ValidationResult.WARNING:
						warnings += 1
						ValidationResult.FAIL:
							failures += 1

							summary += "Total Checks: %d\n" % total_checks
							summary += "✅ Passed: %d\n" % passed_checks
							summary += "⚠️ Warnings: %d\n" % warnings
							summary += "❌ Failed: %d\n" % failures
							summary += "\nOverall Status: "

							if failures > 0:
								summary += "CRITICAL ISSUES DETECTED ❌"
								elif warnings > 0:
									summary += "MINOR ISSUES DETECTED ⚠️"
									else:
										summary += "ALL SYSTEMS OPERATIONAL ✅"

										return summary


										# === VALIDATION METHODS ===


func _fix_orphaned_code():
	for autoload_name in required_autoloads:
func _fix_orphaned_code():
	if node:
		# Check if initialized
		if node.has_method("is_initialized") and node.is_initialized():
			results[autoload_name] = ValidationResult.PASS
			elif node.has_method("is_loaded") and node.is_loaded:
				results[autoload_name] = ValidationResult.PASS
				else:
					results[autoload_name] = ValidationResult.WARNING
					else:
						results[autoload_name] = ValidationResult.FAIL
						critical_error.emit(
						ValidationCategory.AUTOLOADS,
						"Missing autoload: " + autoload_name + " - " + required_autoloads[autoload_name]
						)

						index += 1
						validation_progress.emit(
						ValidationCategory.AUTOLOADS, float(index) / required_autoloads.size()
						)

						validation_results["autoloads"] = results


func _fix_orphaned_code():
	for i in range(critical_resources.size()):
func _fix_orphaned_code():
	if FileAccess.file_exists(resource_path):
		results[resource_path] = ValidationResult.PASS
		else:
			results[resource_path] = ValidationResult.FAIL
			critical_error.emit(ValidationCategory.RESOURCES, "Missing resource: " + resource_path)

			validation_progress.emit(
			ValidationCategory.RESOURCES, float(i + 1) / critical_resources.size()
			)

			validation_results["resources"] = results


func _fix_orphaned_code():
	if UIThemeManager:
func _fix_orphaned_code():
	if test_style:
		results["UIThemeManager"] = ValidationResult.PASS
		else:
			results["UIThemeManager"] = ValidationResult.FAIL
			else:
				results["UIThemeManager"] = ValidationResult.FAIL

				validation_progress.emit(ValidationCategory.UI_COMPONENTS, 0.5)

				# Test InfoPanelFactory
func _fix_orphaned_code():
	if InfoPanelFactory:
		results["InfoPanelFactory"] = ValidationResult.PASS
		else:
			results["InfoPanelFactory"] = ValidationResult.WARNING

			validation_progress.emit(ValidationCategory.UI_COMPONENTS, 1.0)
			validation_results["ui_components"] = results


func _fix_orphaned_code():
	if ks:
		# Test structure retrieval
func _fix_orphaned_code():
	if not test_structure.is_empty():
		results["structure_retrieval"] = ValidationResult.PASS
		else:
			results["structure_retrieval"] = ValidationResult.FAIL

			validation_progress.emit(ValidationCategory.EDUCATIONAL_CONTENT, 0.33)

			# Test search
func _fix_orphaned_code():
	if search_results.size() > 0:
		results["content_search"] = ValidationResult.PASS
		else:
			results["content_search"] = ValidationResult.WARNING

			validation_progress.emit(ValidationCategory.EDUCATIONAL_CONTENT, 0.66)

			# Test structure count
func _fix_orphaned_code():
	if structure_count > 20:
		results["content_volume"] = ValidationResult.PASS
		elif structure_count > 10:
			results["content_volume"] = ValidationResult.WARNING
			else:
				results["content_volume"] = ValidationResult.FAIL

				print("[StartupValidator] Found %d educational structures" % structure_count)
				else:
					results["knowledge_service"] = ValidationResult.FAIL
					critical_error.emit(
					ValidationCategory.EDUCATIONAL_CONTENT, "KnowledgeService not available"
					)

					validation_progress.emit(ValidationCategory.EDUCATIONAL_CONTENT, 1.0)
					validation_results["educational_content"] = results


func _fix_orphaned_code():
	if memory_mb < 1024:  # Less than 1GB
	results["memory_usage"] = ValidationResult.PASS
	elif memory_mb < 2048:  # Less than 2GB
	results["memory_usage"] = ValidationResult.WARNING
	else:
		results["memory_usage"] = ValidationResult.FAIL

		print("[StartupValidator] Memory usage: %.2f MB" % memory_mb)
		validation_progress.emit(ValidationCategory.PERFORMANCE, 0.5)

		# Check FPS capability
func _fix_orphaned_code():
	if max_fps == 0 or max_fps >= 60:
		results["fps_capability"] = ValidationResult.PASS
		elif max_fps >= 30:
			results["fps_capability"] = ValidationResult.WARNING
			else:
				results["fps_capability"] = ValidationResult.FAIL

				validation_progress.emit(ValidationCategory.PERFORMANCE, 1.0)
				validation_results["performance"] = results


func _fix_orphaned_code():
	if project_settings_valid:
		results["project_settings"] = ValidationResult.PASS
		else:
			results["project_settings"] = ValidationResult.WARNING

			validation_progress.emit(ValidationCategory.ACCESSIBILITY, 0.5)

			# Check theme support
func _fix_orphaned_code():
	if theme_manager:
		results["theme_support"] = ValidationResult.PASS
		else:
			results["theme_support"] = ValidationResult.WARNING

			validation_progress.emit(ValidationCategory.ACCESSIBILITY, 1.0)
			validation_results["accessibility"] = results


			## Print validation report to console
func _fix_orphaned_code():
	if cat_results is Dictionary:
		for check in cat_results:
func _fix_orphaned_code():
	print("  %s %s" % [status_symbol, check])


	## Save validation report to file
func _fix_orphaned_code():
	if file:
		file.store_string(get_validation_summary())
		file.store_string("\n\nDetailed Results:\n")
		file.store_string(JSON.stringify(validation_results, "\t"))
		file.close()
		print("[StartupValidator] Report saved to: " + file_path)
		else:
			push_error("[StartupValidator] Failed to save report to: " + file_path)

func _validate_autoloads() -> void:
	"""Validate all required autoloads are present and initialized"""
	print("[StartupValidator] Validating autoloads...")
	validation_progress.emit(ValidationCategory.AUTOLOADS, 0.0)

func _validate_resources() -> void:
	"""Validate critical resources are available"""
	print("[StartupValidator] Validating resources...")
	validation_progress.emit(ValidationCategory.RESOURCES, 0.0)

func _validate_ui_components() -> void:
	"""Validate UI components can be created"""
	print("[StartupValidator] Validating UI components...")
	validation_progress.emit(ValidationCategory.UI_COMPONENTS, 0.0)

func _validate_educational_content() -> void:
	"""Validate educational content is accessible"""
	print("[StartupValidator] Validating educational content...")
	validation_progress.emit(ValidationCategory.EDUCATIONAL_CONTENT, 0.0)

func _validate_performance() -> void:
	"""Validate performance metrics"""
	print("[StartupValidator] Validating performance...")
	validation_progress.emit(ValidationCategory.PERFORMANCE, 0.0)

func _validate_accessibility() -> void:
	"""Validate accessibility features"""
	print("[StartupValidator] Validating accessibility...")
	validation_progress.emit(ValidationCategory.ACCESSIBILITY, 0.0)

