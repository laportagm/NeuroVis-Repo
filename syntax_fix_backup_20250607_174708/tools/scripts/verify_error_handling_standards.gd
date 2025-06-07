#!/usr/bin/env -S godot --headless --script

extends SceneTree

## Error Handling Standards Verification Script
## Checks all GDScript files for compliance with established error handling patterns
##
## Usage: godot --headless --script tools/scripts/verify_error_handling_standards.gd

# Error handling patterns to check

const VALID_PREFIXES = [
"[UI]",
"[Selection]",
"[Camera]",
"[Model]",
"[Knowledge]",
"[AI]",
"[Debug]",
"[System]",
"[Resource]",
"[Scene]",
"[Test]",
"[Tool]",
"[Navigation]",
"[Panel]",
"[Component]",
"[Theme]",
"[Education]",
"[Analytics]",
"[Interaction]",
"[Visualization]",
"[Performance]",
"[Accessibility]",
"[State]",
"[Event]",
"[Feature]",
"[Service]"
]

# Patterns that indicate non-standard error handling
const NON_STANDARD_PATTERNS = [
# Old patterns without component prefix
r"push_error\s*\(\s*[\"'](?!\[)",
r"push_warning\s*\(\s*[\"'](?!\[)",
r"print\s*\(\s*[\"']Error:",
r"print\s*\(\s*[\"']Warning:",
r"printerr\s*\(",  # Should use push_error instead
# Non-standard concatenation
r"push_error\s*\([^\"'\)]+\+",  # String concatenation in error
r"push_warning\s*\([^\"'\)]+\+",  # String concatenation in warning
]

# Standard patterns that should be used
const STANDARD_PATTERNS = {
"error": r"push_error\s*\(\s*[\"']\[[A-Za-z]+\]",
"warning": r"push_warning\s*\(\s*[\"']\[[A-Za-z]+\]",
"info": r"print\s*\(\s*[\"']\[[A-Za-z]+\]"
}

var total_files_checked: int = 0
var compliant_files: int = 0
var non_compliant_files: Array = []
var issues_by_type: Dictionary = {
"missing_prefix": 0, "non_standard_concat": 0, "using_printerr": 0, "invalid_prefix": 0
}


var start_time = Time.get_ticks_msec()
verify_project()
var duration = (Time.get_ticks_msec() - start_time) / 1000.0

print_summary(duration)
quit()


var dirs_to_check = [
"res://core", "res://ui", "res://scenes", "res://scripts", "res://tests", "res://tools"
]

var dir = DirAccess.open(path)
var file_name = dir.get_next()

var full_path = path + "/" + file_name

var file = FileAccess.open(file_path, FileAccess.READ)
var content = file.get_as_text()
	file.close()

var issues = []
var line_number = 0

var trimmed_line = line.strip_edges()
var regex = RegEx.new()
	regex.compile(pattern)
var issue_type = get_issue_type(pattern)
	issues.append(
	{"line": line_number, "type": issue_type, "content": line.strip_edges()}
	)
	issues_by_type[issue_type] += 1

	# Check for valid but incorrect prefixes
var regex = RegEx.new()
	regex.compile(r"\[[A-Za-z]+\]")
var prefix_line = ""

func _init() -> void:
	print("\n=== Error Handling Standards Verification ===\n")

func verify_project() -> void:
func scan_directory(path: String) -> void:
func check_file(file_path: String) -> void:
func get_issue_type(pattern: String) -> String:
	if pattern.contains("(?!\\[)"):
		return "missing_prefix"
		elif pattern.contains("\\+"):
			return "non_standard_concat"
			elif pattern.contains("printerr"):
				return "using_printerr"
				else:
					return "unknown"


func has_prefix(line: String) -> bool:
func has_valid_prefix(line: String) -> bool:
	for prefix in VALID_PREFIXES:
		if line.contains(prefix):
			return true
			return false


func print_summary(duration: float) -> void:
	print("\n=== Verification Results ===\n")
	print("Total files checked: %d" % total_files_checked)
	print(
	(
	"Compliant files: %d (%.1f%%)"
	% [compliant_files, (compliant_files * 100.0) / max(total_files_checked, 1)]
	)
	)
	print("Non-compliant files: %d" % non_compliant_files.size())

	print("\n=== Issues by Type ===\n")
	for issue_type in issues_by_type:
		if issues_by_type[issue_type] > 0:
			print(
			"%s: %d" % [issue_type.capitalize().replace("_", " "), issues_by_type[issue_type]]
			)

			if non_compliant_files.size() > 0:
				print("\n=== Non-Compliant Files ===\n")
				for file_info in non_compliant_files:
					print("\n%s:" % file_info.path)
					for issue in file_info.issues:
						print("  Line %d [%s]: %s" % [issue.line, issue.type, issue.content])

						print("\n=== Compliance Guidelines ===\n")
						print("All error handling should follow these patterns:")
						print('  • push_error("[ComponentName] Error message")')
						print('  • push_warning("[ComponentName] Warning message")')
						print('  • print("[ComponentName] Info message")')
						print("\nValid component prefixes:")

func _fix_orphaned_code():
	for dir in dirs_to_check:
		if DirAccess.dir_exists_absolute(dir):
			scan_directory(dir)


func _fix_orphaned_code():
	if not dir:
		return

		dir.list_dir_begin()
func _fix_orphaned_code():
	while file_name != "":
func _fix_orphaned_code():
	if dir.current_is_dir() and not file_name.begins_with("."):
		scan_directory(full_path)
		elif file_name.ends_with(".gd"):
			check_file(full_path)

			file_name = dir.get_next()


func _fix_orphaned_code():
	if not file:
		return

		total_files_checked += 1
func _fix_orphaned_code():
	for line in content.split("\n"):
		line_number += 1

		# Skip comments
func _fix_orphaned_code():
	if trimmed_line.begins_with("#") or trimmed_line.begins_with("//"):
		continue

		# Check for non-standard patterns
		for pattern in NON_STANDARD_PATTERNS:
func _fix_orphaned_code():
	if regex.search(line):
func _fix_orphaned_code():
	if (
	line.contains("push_error")
	or line.contains("push_warning")
	or (line.contains("print(") and (line.contains("Error") or line.contains("Warning")))
	):
		if has_prefix(line) and not has_valid_prefix(line):
			issues.append(
			{"line": line_number, "type": "invalid_prefix", "content": line.strip_edges()}
			)
			issues_by_type["invalid_prefix"] += 1

			if issues.size() > 0:
				non_compliant_files.append({"path": file_path, "issues": issues})
				else:
					compliant_files += 1


func _fix_orphaned_code():
	return regex.search(line) != null


func _fix_orphaned_code():
	for i in range(VALID_PREFIXES.size()):
		prefix_line += VALID_PREFIXES[i]
		if i < VALID_PREFIXES.size() - 1:
			prefix_line += ", "
			if prefix_line.length() > 70:
				print("  " + prefix_line)
				prefix_line = ""
				if prefix_line.length() > 0:
					print("  " + prefix_line)

					print("\n=== Recommendations ===\n")
					if issues_by_type["missing_prefix"] > 0:
						print(
						(
						"• Add component prefixes to %d error/warning messages"
						% issues_by_type["missing_prefix"]
						)
						)
						if issues_by_type["non_standard_concat"] > 0:
							print(
							(
							"• Replace string concatenation with proper formatting in %d messages"
							% issues_by_type["non_standard_concat"]
							)
							)
							if issues_by_type["using_printerr"] > 0:
								print(
								(
								"• Replace printerr() with push_error() in %d locations"
								% issues_by_type["using_printerr"]
								)
								)
								if issues_by_type["invalid_prefix"] > 0:
									print(
									(
									"• Update %d messages to use valid component prefixes"
									% issues_by_type["invalid_prefix"]
									)
									)

									print("\nVerification completed in %.2f seconds" % duration)

									# Exit with appropriate code
									if non_compliant_files.size() > 0:
										print("\n❌ Error handling standards verification FAILED")
										quit(1)
										else:
											print("\n✅ All files comply with error handling standards!")
											quit(0)
