## verify_safe_autoload_access.gd
## Verification script to check for unsafe autoload access patterns
##
## This script scans all .gd files to identify unsafe direct autoload access
## and ensures compliance with SafeAutoloadAccess standards.

extends Node

# Dangerous autoload access patterns to detect

const UNSAFE_PATTERNS = [
"KnowledgeService\\.",
"ModelSwitcherGlobal\\.",
"FeatureFlags\\.",
"DebugCmd\\.",
"UIThemeManager\\.",
"AIAssistantService\\.",
"ComponentRegistry\\.",
"ComponentStateManager\\."
]

# Safe patterns that are acceptable
const SAFE_PATTERNS = [
'has_node\\("/root/',
'get_node\\("/root/',
"\\.has_method\\(",
"\\.has_signal\\(",
"is_instance_valid\\("
]

# Directories to scan
const SCAN_DIRECTORIES = ["core/", "ui/", "scenes/", "scripts/", "tests/", "tools/"]

var total_files_scanned: int = 0
var files_with_issues: Array = []
var total_issues: int = 0


var dir = DirAccess.open(directory_path)
var file_name = dir.get_next()

var full_path = directory_path + "/" + file_name

var file = FileAccess.open(file_path, FileAccess.READ)
var line_number = 0
var file_issues = []

var line = file.get_line().strip_edges()

# Skip comments and empty lines
var issues = _check_line_for_unsafe_patterns(line, line_number)
var issues = []

# Skip lines that already use safe patterns
var regex = RegEx.new()
	regex.compile(pattern)
var results = regex.search_all(line)

var service_name = pattern.replace("\\.", "").replace("\\", "")
	issues.append(
	{
	"line": line_number,
	"content": line,
	"pattern": service_name,
	"issue_type": "unsafe_direct_access"
	}
	)

var regex = RegEx.new()
	regex.compile(safe_pattern)
var issues_by_type = {}
var issue_type = issue.issue_type
var issue_list = issues_by_type[issue_type]

func _ready() -> void:
	print("\n=== NeuroVis SafeAutoloadAccess Verification ===\n")

	_scan_project_files()
	_generate_report()

	# Exit with appropriate code
	if files_with_issues.is_empty():
		print("✅ All files comply with SafeAutoloadAccess standards!")
		get_tree().quit(0)
		else:
			print("❌ Found unsafe autoload access patterns!")
			get_tree().quit(1)


func _exit_tree() -> void:
	queue_free()

func _fix_orphaned_code():
	if dir == null:
		push_warning("[SafeAutoloadVerifier] Warning: Cannot open directory: " + directory_path)
		return

		dir.list_dir_begin()
func _fix_orphaned_code():
	while file_name != "":
func _fix_orphaned_code():
	if dir.current_is_dir() and not file_name.begins_with("."):
		# Recursively scan subdirectories
		_scan_directory(full_path)
		elif file_name.ends_with(".gd"):
			# Scan GDScript files
			_scan_file(full_path)

			file_name = dir.get_next()


func _fix_orphaned_code():
	if file == null:
		push_warning("[SafeAutoloadVerifier] Warning: Cannot read file: " + file_path)
		return

		total_files_scanned += 1
func _fix_orphaned_code():
	while not file.eof_reached():
		line_number += 1
func _fix_orphaned_code():
	if line.is_empty() or line.begins_with("#"):
		continue

		# Check for unsafe patterns
func _fix_orphaned_code():
	if not issues.is_empty():
		file_issues.append_array(issues)

		file.close()

		if not file_issues.is_empty():
			files_with_issues.append({"file": file_path, "issues": file_issues})
			total_issues += file_issues.size()


func _fix_orphaned_code():
	if _is_safe_pattern(line):
		return issues

		# Check for unsafe patterns
		for pattern in UNSAFE_PATTERNS:
func _fix_orphaned_code():
	if not results.is_empty():
func _fix_orphaned_code():
	return issues


func _fix_orphaned_code():
	if regex.search(line):
		return true

		return false


func _fix_orphaned_code():
	for file_data in files_with_issues:
		for issue in file_data.issues:
func _fix_orphaned_code():
	if not issues_by_type.has(issue_type):
		issues_by_type[issue_type] = []
		issues_by_type[issue_type].append(
		{
		"file": file_data.file,
		"line": issue.line,
		"content": issue.content,
		"pattern": issue.pattern
		}
		)

		# Report by issue type
		for issue_type in issues_by_type:
func _fix_orphaned_code():
	print("## %s (%d issues)" % [issue_type.replace("_", " ").capitalize(), issue_list.size()])

	for issue in issue_list:
		print("  📁 %s:%d" % [issue.file, issue.line])
		print("    🔍 Pattern: %s" % issue.pattern)
		print("    📝 Line: %s" % issue.content.strip_edges())
		print("")

		print("=== REMEDIATION GUIDE ===\n")
		print("To fix unsafe autoload access patterns:")
		print("")
		print("1. **Replace direct access** with safe patterns:")
		print("   ❌ KnowledgeService.get_structure(id)")
		print('   ✅ if has_node("/root/KnowledgeService"):')
		print('        var service = get_node("/root/KnowledgeService")')
		print('        if service.has_method("get_structure"):')
		print("          service.get_structure(id)")
		print("")
		print("2. **Add graceful fallbacks** for missing services:")
		print("   ✅ else:")
		print('        push_warning("[Component] Warning: Service not available")')
		print("        return safe_default_value")
		print("")
		print("3. **Follow the documentation**: docs/dev/SAFE_AUTOLOAD_ACCESS_STANDARDS.md")
		print("")
		print("4. **Test your changes** with missing autoloads to ensure no crashes")
		print("")

		print("=== FILES REQUIRING UPDATES ===\n")
		for file_data in files_with_issues:
			print("📁 %s (%d issues)" % [file_data.file, file_data.issues.size()])

			print("\n=== PRIORITY RECOMMENDATIONS ===\n")
			print("1. **High Priority**: Fix files in core/ and ui/ directories")
			print("2. **Medium Priority**: Fix files in scenes/ directory")
			print("3. **Low Priority**: Fix files in tests/ and tools/ directories")
			print("")
			print("Remember: The goal is to prevent AI-caused crashes by making")
			print("autoload access robust and predictable.")


			# Self-cleanup

func _scan_project_files() -> void:
	"""Scan all .gd files in the project for unsafe autoload patterns"""
	print("Scanning project files for unsafe autoload access patterns...\n")

	for directory in SCAN_DIRECTORIES:
		_scan_directory(directory)


func _scan_directory(directory_path: String) -> void:
	"""Recursively scan a directory for .gd files"""
func _scan_file(file_path: String) -> void:
	"""Scan a specific .gd file for unsafe autoload patterns"""
func _check_line_for_unsafe_patterns(line: String, line_number: int) -> Array:
	"""Check a line for unsafe autoload access patterns"""
func _is_safe_pattern(line: String) -> bool:
	"""Check if a line uses safe autoload access patterns"""
	for safe_pattern in SAFE_PATTERNS:
func _generate_report() -> void:
	"""Generate a comprehensive verification report"""
	print("=== VERIFICATION REPORT ===\n")

	print("Files scanned: %d" % total_files_scanned)
	print("Files with issues: %d" % files_with_issues.size())
	print("Total issues found: %d\n" % total_issues)

	if files_with_issues.is_empty():
		print("🎉 Excellent! No unsafe autoload access patterns found.\n")
		print("All files comply with SafeAutoloadAccess standards:")
		print("- ✅ Using has_node() checks before access")
		print("- ✅ Using get_node() for safe references")
		print("- ✅ Verifying method availability with has_method()")
		print("- ✅ Providing graceful fallbacks for missing services")
		return

		print("⚠️  Found unsafe autoload access patterns:\n")

		# Group issues by type
