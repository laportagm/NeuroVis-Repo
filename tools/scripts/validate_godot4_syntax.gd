## validate_godot4_syntax.gd
## Validation script to detect remaining Godot 3 syntax patterns
##
## This script scans the codebase for old Godot 3 syntax patterns that should
## be converted to Godot 4. It's designed to be run as part of the test suite
## to ensure all code follows modern Godot 4 conventions.
##
## @tutorial: Godot 3 to 4 migration guide
## @version: 1.0

extends SceneTree

# === CONSTANTS ===

const SCRIPT_EXTENSIONS: Array[String] = ["gd", "tres", "tscn"]
const IGNORE_DIRS: Array[String] = [
	".godot",
	".git",
	"node_modules",
	"exports",
	"temp_syntax_check",
	"backups_",
	"syntax_fix_backup_"
]

# === PRIVATE VARIABLES ===

var _issues_found: Array[Dictionary] = []
var _files_scanned: int = 0
var _total_issues: int = 0


func _initialize() -> void:
	"""Run validation when script starts"""
	print("🔍 Starting Godot 4 syntax validation...")
	var success = validate_project()

	# Exit with appropriate code
	if success:
		print("✅ Validation complete - no issues found!")
		quit(0)
	else:
		print("❌ Validation failed - issues found!")
		quit(1)


func validate_project() -> bool:
	var project_root = ProjectSettings.globalize_path("res://")

	# Scan directory recursively
	_scan_directory(project_root)

	# Print results
	_print_validation_report()

	return _total_issues == 0


## Validate a single file
## @param file_path: Path to the file to validate
## @return: Array of issues found
func validate_file(file_path: String) -> Array:
	var issues = []

	# Check if file should be validated
	var extension = file_path.get_extension()
	if not extension in SCRIPT_EXTENSIONS:
		return issues

	# Only validate GDScript files for now
	if extension != "gd":
		return issues

	# Read file content
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("[Godot4SyntaxValidator] Failed to open file: " + file_path)
		return issues

	var content = file.get_as_text()
	file.close()

	# Split into lines for line-by-line analysis
	var lines = content.split("\n")

	# Check for various Godot 3 patterns
	for i in range(lines.size()):
		var line = lines[i]
		var line_number = i + 1

		# Skip comments
		if line.strip_edges().begins_with("#"):
			continue

		# Check for old signal connection syntax
		var signal_pattern = RegEx.new()
		signal_pattern.compile(r"\.connect\s*\(\s*[\"']([^\"']+)[\"']")
		var signal_match = signal_pattern.search(line)
		if signal_match:
			issues.append(
				{
					"type": "signal_connection",
					"line": line_number,
					"description": "Old Godot 3 signal connection syntax",
					"pattern": signal_match.get_string(),
					"suggestion": "Use signal_name.connect(callback) instead"
				}
			)

		# Check for old yield syntax
		if line.contains("yield(") and not line.contains("# Godot 3"):
			issues.append(
				{
					"type": "yield",
					"line": line_number,
					"description": "Old Godot 3 yield syntax",
					"pattern": "yield",
					"suggestion": "Use await instead of yield"
				}
			)

		# Check for old export syntax
		var export_pattern = RegEx.new()
		export_pattern.compile(r"export\s*\(")
		if export_pattern.search(line):
			issues.append(
				{
					"type": "export",
					"line": line_number,
					"description": "Old Godot 3 export syntax",
					"pattern": "export(...)",
					"suggestion": "Use @export annotations"
				}
			)

		# Check for old onready syntax
		if line.contains("onready var") and not line.contains("# Godot 3"):
			issues.append(
				{
					"type": "onready",
					"line": line_number,
					"description": "Old Godot 3 onready syntax",
					"pattern": "onready var",
					"suggestion": "Use @onready annotation"
				}
			)

		# Check for old tool syntax
		if line.strip_edges() == "tool":
			issues.append(
				{
					"type": "tool",
					"line": line_number,
					"description": "Old Godot 3 tool syntax",
					"pattern": "tool",
					"suggestion": "Use @tool annotation"
				}
			)

		# Check for disconnect with string
		var disconnect_pattern = RegEx.new()
		disconnect_pattern.compile(r"\.disconnect\s*\(\s*[\"']([^\"']+)[\"']")
		var disconnect_match = disconnect_pattern.search(line)
		if disconnect_match:
			issues.append(
				{
					"type": "signal_disconnection",
					"line": line_number,
					"description": "Old Godot 3 signal disconnection syntax",
					"pattern": disconnect_match.get_string(),
					"suggestion": "Use signal_name.disconnect(callback) instead"
				}
			)

		# Check for is_connected with string
		var is_connected_pattern = RegEx.new()
		is_connected_pattern.compile(r"\.is_connected\s*\(\s*[\"']([^\"']+)[\"']")
		var is_connected_match = is_connected_pattern.search(line)
		if is_connected_match:
			issues.append(
				{
					"type": "signal_is_connected",
					"line": line_number,
					"description": "Old Godot 3 is_connected syntax",
					"pattern": is_connected_match.get_string(),
					"suggestion": "Use signal_name.is_connected(callback) instead"
				}
			)

		# Check for emit_signal with string
		var emit_pattern = RegEx.new()
		emit_pattern.compile(r"emit_signal\s*\(\s*[\"']([^\"']+)[\"']")
		var emit_match = emit_pattern.search(line)
		if emit_match:
			issues.append(
				{
					"type": "emit_signal",
					"line": line_number,
					"description": "Old Godot 3 emit_signal syntax",
					"pattern": emit_match.get_string(),
					"suggestion": "Use signal_name.emit() instead"
				}
			)

	return issues


# === PRIVATE METHODS ===
func _scan_directory(dir_path: String) -> void:
	var dir = DirAccess.open(dir_path)
	if dir == null:
		push_error("[Godot4SyntaxValidator] Failed to open directory: " + dir_path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		var full_path = dir_path + "/" + file_name

		# Skip ignored directories
		var should_skip = false
		for ignore_dir in IGNORE_DIRS:
			if file_name == ignore_dir or full_path.contains("/" + ignore_dir + "/"):
				should_skip = true
				break

		if should_skip:
			file_name = dir.get_next()
			continue

		if dir.current_is_dir():
			# Recursively scan subdirectory
			_scan_directory(full_path)
		else:
			# Validate file
			var file_issues = validate_file(full_path)
			if not file_issues.is_empty():
				_issues_found.append({"file": full_path, "issues": file_issues})
				_total_issues += file_issues.size()
			_files_scanned += 1

		file_name = dir.get_next()

	dir.list_dir_end()


func _print_validation_report() -> void:
	print("\n=== Godot 4 Syntax Validation Report ===")
	print("Files scanned: " + str(_files_scanned))
	print("Total issues found: " + str(_total_issues))

	if _issues_found.is_empty():
		print("\n✅ No Godot 3 syntax patterns found! All code follows Godot 4 conventions.")
	else:
		print("\n❌ Found Godot 3 syntax patterns in the following files:")

		for file_data in _issues_found:
			var file_path = file_data.file
			var file_issues = file_data.issues

			# Make path relative to project for readability
			var relative_path = file_path.replace(ProjectSettings.globalize_path("res://"), "")

			print("\n📄 " + relative_path + " (" + str(file_issues.size()) + " issues):")

			for issue in file_issues:
				print("  Line " + str(issue.line) + ": " + issue.description)
				print("    Pattern: " + issue.pattern)
				print("    Fix: " + issue.suggestion)

	print("\n" + "=".repeat(40) + "\n")
