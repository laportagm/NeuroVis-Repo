## StartupValidator.gd
## Comprehensive startup validation for NeuroVis educational platform
## Educational purpose: Ensures all critical educational components are ready for medical student use
## Clinical relevance: Validates anatomical data integrity and educational feature availability
##
## This system validates all critical components during startup,
## ensuring the educational platform provides accurate medical information.
##
## @tutorial: Startup validation patterns for educational software
## @version: 2.0

class_name StartupValidator
extends Node

# === CONSTANTS ===

signal validation_started

## Emitted during validation with progress updates
## @param category ValidationCategory - Current category being validated
## @param progress float - Progress percentage (0.0 to 1.0)
signal validation_progress(category: ValidationCategory, progress: float)

## Emitted when all validation checks complete
## @param results Dictionary - Complete validation results by category
signal validation_completed(results: Dictionary)

## Emitted when critical error prevents platform operation
## @param category ValidationCategory - Category where error occurred
## @param message String - Detailed error message for debugging
signal critical_error(category: ValidationCategory, message: String)

# === PRIVATE VARIABLES ===

enum ValidationCategory {
AUTOLOADS, RESOURCES, UI_COMPONENTS, EDUCATIONAL_CONTENT, PERFORMANCE, ACCESSIBILITY
}

enum ValidationResult { PASS, WARNING, FAIL }

# === SIGNALS ===
## Emitted when validation process starts

const MAX_VALIDATION_TIME: float = 10.0
const AUTOLOAD_CHECK_DELAY: float = 0.1
const PERFORMANCE_THRESHOLD_FPS: float = 60.0
const MEMORY_WARNING_THRESHOLD_MB: int = 500

# === ENUMS ===

var total_time: float = (Time.get_ticks_msec() / 1000.0) - _validation_start_time

# Compile final results
var final_results: Dictionary = _compile_results(total_time)

_is_validating = false
validation_completed.emit(final_results)

# Print summary
_print_validation_summary(final_results)

var required_autoloads: Array[String] = [
	"KnowledgeService",
	"AIAssistant",
	"UIThemeManager",
	"ModelSwitcherGlobal",
	"DebugCmd",
	"StructureAnalysisManager"
	]

var passed: int = 0
var total: int = required_autoloads.size()

var autoload_name: String = required_autoloads[i]
var node: Node = get_node_or_null("/root/" + autoload_name)

var result: ValidationResult = (
	ValidationResult.PASS if passed == total else ValidationResult.FAIL
	)
	_validation_results[ValidationCategory.AUTOLOADS] = {
	"result": result,
	"passed": passed,
	"total": total,
	"errors": _get_category_errors(ValidationCategory.AUTOLOADS)
	}


var critical_resources: Array[Dictionary] = [
	{"path": "res://assets/data/anatomical_data.json", "type": "educational_data"},
	{"path": "res://assets/models/Half_Brain.glb", "type": "3d_model"},
	{"path": "res://assets/models/Internal_Structures.glb", "type": "3d_model"}
	]

var passed: int = 0
var total: int = critical_resources.size()

var resource_info: Dictionary = critical_resources[i]
var exists: bool = ResourceLoader.exists(resource_info["path"])

var error_msg: String = (
	"Missing %s: %s" % [resource_info["type"], resource_info["path"]]
	)
	_critical_errors.append(error_msg)
	critical_error.emit(ValidationCategory.RESOURCES, error_msg)

	validation_progress.emit(ValidationCategory.RESOURCES, float(i + 1) / float(total))
	await get_tree().process_frame

var result: ValidationResult = (
	ValidationResult.PASS if passed == total else ValidationResult.FAIL
	)
	_validation_results[ValidationCategory.RESOURCES] = {
	"result": result,
	"passed": passed,
	"total": total,
	"errors": _get_category_errors(ValidationCategory.RESOURCES)
	}


var InfoPanelFactory: GDScript = preprepreload("res://ui/panels/InfoPanelFactory.gd") as GDScript
var test_panel: Control = InfoPanelFactory.create_info_panel()
var knowledge_service: Node = get_node_or_null("/root/KnowledgeService")
var test_structure: Dictionary = knowledge_service.get_structure("hippocampus")
var fps: float = Engine.get_frames_per_second()
var memory_mb: float = OS.get_static_memory_usage() / 1048576.0

	validation_progress.emit(ValidationCategory.PERFORMANCE, 0.5)

var has_issues: bool = false
var perf_warnings: Array[String] = []

var theme_manager: Node = get_node_or_null("/root/UIThemeManager")

	validation_progress.emit(ValidationCategory.ACCESSIBILITY, 0.5)

var category_errors: Array[String] = []
var passed_count: int = 0
var warning_count: int = 0
var failed_count: int = 0

var result: Dictionary = _validation_results[category]
match result.get("result", ValidationResult.FAIL):
	ValidationResult.PASS:
		passed_count += 1
		ValidationResult.WARNING:
			warning_count += 1
			ValidationResult.FAIL:
				failed_count += 1

var _validation_results: Dictionary = {}
var _is_validating: bool = false
var _validation_start_time: float = 0.0
var _critical_errors: Array[String] = []
var _warnings: Array[String] = []

# === PUBLIC METHODS ===


## Run comprehensive startup validation for educational platform
## @return Dictionary - Validation results with pass/fail status by category

func validate_startup() -> Dictionary:
	if _is_validating:
		push_warning("[StartupValidator] Validation already in progress")
		return {}

		_is_validating = true
		_validation_start_time = Time.get_ticks_msec() / 1000.0
		validation_started.emit()

		print("[StartupValidator] Starting comprehensive validation...")

		# Clear previous results
		_validation_results.clear()
		_critical_errors.clear()
		_warnings.clear()

		# Run validation checks in sequence
		await _validate_autoloads()
		await _validate_resources()
		await _validate_ui_components()
		await _validate_educational_content()
		await _validate_performance()
		await _validate_accessibility()

		# Calculate total time
func is_validating() -> bool:
	return _is_validating


	## Get last validation results
	## @return Dictionary - Last validation results or empty if not run
func get_last_results() -> Dictionary:
	return _validation_results.duplicate()


	# === PRIVATE VALIDATION METHODS ===


func _fix_orphaned_code():
	return final_results


	## Get current validation status
	## @return bool - True if validation is in progress
func _fix_orphaned_code():
	for i in range(total):
func _fix_orphaned_code():
	if node:
		passed += 1
		else:
			_critical_errors.append("Missing autoload: " + autoload_name)
			critical_error.emit(
			ValidationCategory.AUTOLOADS, "Required autoload not found: " + autoload_name
			)

			validation_progress.emit(ValidationCategory.AUTOLOADS, float(i + 1) / float(total))
			await get_tree().process_frame

func _fix_orphaned_code():
	for i in range(total):
func _fix_orphaned_code():
	if exists:
		passed += 1
		else:
func _fix_orphaned_code():
	if not InfoPanelFactory:
		_critical_errors.append("InfoPanelFactory not found")
		critical_error.emit(ValidationCategory.UI_COMPONENTS, "Cannot load InfoPanelFactory")
		_validation_results[ValidationCategory.UI_COMPONENTS] = {
		"result": ValidationResult.FAIL, "errors": ["InfoPanelFactory not available"]
		}
		return

		# Try to create test panel
		validation_progress.emit(ValidationCategory.UI_COMPONENTS, 0.5)

func _fix_orphaned_code():
	if test_panel:
		test_panel.queue_free()
		_validation_results[ValidationCategory.UI_COMPONENTS] = {
		"result": ValidationResult.PASS, "message": "UI components functional"
		}
		else:
			_warnings.append("Info panel creation returned null")
			_validation_results[ValidationCategory.UI_COMPONENTS] = {
			"result": ValidationResult.WARNING, "warnings": ["Panel creation issues"]
			}

			validation_progress.emit(ValidationCategory.UI_COMPONENTS, 1.0)


func _fix_orphaned_code():
	if not knowledge_service:
		_critical_errors.append("KnowledgeService not available")
		_validation_results[ValidationCategory.EDUCATIONAL_CONTENT] = {
		"result": ValidationResult.FAIL, "errors": ["Knowledge service unavailable"]
		}
		return

		# Test content retrieval
		validation_progress.emit(ValidationCategory.EDUCATIONAL_CONTENT, 0.5)

		if knowledge_service.has_method("get_structure"):
func _fix_orphaned_code():
	if not test_structure.is_empty():
		_validation_results[ValidationCategory.EDUCATIONAL_CONTENT] = {
		"result": ValidationResult.PASS, "message": "Educational content accessible"
		}
		else:
			_warnings.append("Test structure retrieval returned empty")
			_validation_results[ValidationCategory.EDUCATIONAL_CONTENT] = {
			"result": ValidationResult.WARNING, "warnings": ["Content retrieval issues"]
			}
			else:
				_critical_errors.append("KnowledgeService missing get_structure method")
				_validation_results[ValidationCategory.EDUCATIONAL_CONTENT] = {
				"result": ValidationResult.FAIL, "errors": ["Invalid knowledge service interface"]
				}

				validation_progress.emit(ValidationCategory.EDUCATIONAL_CONTENT, 1.0)


func _fix_orphaned_code():
	if fps < PERFORMANCE_THRESHOLD_FPS and fps > 0:
		perf_warnings.append("Low FPS: %.1f (target: %.1f)" % [fps, PERFORMANCE_THRESHOLD_FPS])
		has_issues = true

		if memory_mb > MEMORY_WARNING_THRESHOLD_MB:
			perf_warnings.append("High memory usage: %d MB" % memory_mb)
			has_issues = true

			validation_progress.emit(ValidationCategory.PERFORMANCE, 1.0)

			if has_issues:
				_warnings.append_array(perf_warnings)
				_validation_results[ValidationCategory.PERFORMANCE] = {
				"result": ValidationResult.WARNING,
				"warnings": perf_warnings,
				"metrics": {"fps": fps, "memory_mb": memory_mb}
				}
				else:
					_validation_results[ValidationCategory.PERFORMANCE] = {
					"result": ValidationResult.PASS, "metrics": {"fps": fps, "memory_mb": memory_mb}
					}


func _fix_orphaned_code():
	if theme_manager:
		_validation_results[ValidationCategory.ACCESSIBILITY] = {
		"result": ValidationResult.PASS, "message": "Accessibility features available"
		}
		else:
			_warnings.append("UIThemeManager not available for accessibility")
			_validation_results[ValidationCategory.ACCESSIBILITY] = {
			"result": ValidationResult.WARNING, "warnings": ["Limited accessibility support"]
			}

			validation_progress.emit(ValidationCategory.ACCESSIBILITY, 1.0)


			# === HELPER METHODS ===


func _fix_orphaned_code():
	for error in _critical_errors:
		if error.contains(_get_category_name(category)):
			category_errors.append(error)
			return category_errors


func _fix_orphaned_code():
	for category in _validation_results:
func _fix_orphaned_code():
	return {
	"validation_time": total_time,
	"categories": _validation_results,
	"summary":
		{
		"passed": passed_count,
		"warnings": warning_count,
		"failed": failed_count,
		"total": _validation_results.size()
		},
		"critical_errors": _critical_errors,
		"warnings": _warnings,
		"is_ready": failed_count == 0
		}


func _validate_autoloads() -> void:
	"""Validate all required autoloads for educational features"""
	validation_progress.emit(ValidationCategory.AUTOLOADS, 0.0)

func _validate_resources() -> void:
	"""Validate critical educational resources"""
	validation_progress.emit(ValidationCategory.RESOURCES, 0.0)

func _validate_ui_components() -> void:
	"""Validate UI component system for educational interface"""
	validation_progress.emit(ValidationCategory.UI_COMPONENTS, 0.0)

	# Test critical UI factories
func _validate_educational_content() -> void:
	"""Validate educational content availability and integrity"""
	validation_progress.emit(ValidationCategory.EDUCATIONAL_CONTENT, 0.0)

func _validate_performance() -> void:
	"""Validate performance meets educational platform requirements"""
	validation_progress.emit(ValidationCategory.PERFORMANCE, 0.0)

	# Check FPS
func _validate_accessibility() -> void:
	"""Validate accessibility features for diverse learners"""
	validation_progress.emit(ValidationCategory.ACCESSIBILITY, 0.0)

	# Check if UIThemeManager supports accessibility
func _get_category_errors(category: ValidationCategory) -> Array[String]:
	"""Get errors for specific category"""
func _get_category_name(category: ValidationCategory) -> String:
	"""Get human-readable category name"""
	match category:
		ValidationCategory.AUTOLOADS:
			return "Autoloads"
			ValidationCategory.RESOURCES:
				return "Resources"
				ValidationCategory.UI_COMPONENTS:
					return "UI Components"
					ValidationCategory.EDUCATIONAL_CONTENT:
						return "Educational Content"
						ValidationCategory.PERFORMANCE:
							return "Performance"
							ValidationCategory.ACCESSIBILITY:
								return "Accessibility"
								_:
									return "Unknown"


func _compile_results(total_time: float) -> Dictionary:
	"""Compile final validation results"""
func _print_validation_summary(results: Dictionary) -> void:
	"""Print validation summary to console"""
	print("\n" + "=".repeat(50))
	print("STARTUP VALIDATION COMPLETE")
	print("=".repeat(50))
	print("Time: %.2f seconds" % results["validation_time"])
	print("\nSummary:")
	print("  ✅ Passed: %d" % results["summary"]["passed"])
	print("  ⚠️  Warnings: %d" % results["summary"]["warnings"])
	print("  ❌ Failed: %d" % results["summary"]["failed"])

	if results["critical_errors"].size() > 0:
		print("\nCritical Errors:")
		for error in results["critical_errors"]:
			print("  - " + error)

			if results["warnings"].size() > 0:
				print("\nWarnings:")
				for warning in results["warnings"]:
					print("  - " + warning)

					if results["is_ready"]:
						print("\n✅ Educational platform is ready!")
						else:
							print("\n❌ Platform not ready - critical issues must be resolved")

							print("=".repeat(50) + "\n")
