extends SceneTree

# Resource validation script for NeuroVis project
# Checks for the existence of required font resources
# Run with: godot --headless --script tools/scripts/validate_resources.gd


var required_fonts = [
"res://assets/fonts/Inter-Regular.ttf",
"res://assets/fonts/Inter-Bold.ttf",
"res://assets/fonts/JetBrainsMono-Regular.ttf"
]

# Track missing resources
var missing_resources = []
var found_resources = []
var placeholder_resources = []

# Check each required font
var tres_path = font_path.replace(".ttf", ".tres")
# FIXED: Orphaned code - var dir = DirAccess.open("res://")
# FIXED: Orphaned code - var file_name = dir.get_next()
# FIXED: Orphaned code - var font_files = []

var size_info = ""
var file_path = "res://assets/fonts/" + font

func _init():
	print("[ResourceValidator] Starting resource validation...")
	print("[ResourceValidator] Checking font resources...")
	print("")

	# Define required font resources

for font_path in required_fonts:
	print("[ResourceValidator] Checking: " + font_path)

	# Check if the actual font file exists
	if ResourceLoader.exists(font_path):
		found_resources.append(font_path)
		print("  ✓ Found: " + font_path)
		else:
			# Check for .tres placeholder
if ResourceLoader.exists(tres_path):
	placeholder_resources.append(font_path)
	print("  ⚠ Missing (placeholder exists): " + font_path)
	print("    → Found placeholder: " + tres_path)
	else:
		missing_resources.append(font_path)
		print("  ✗ Missing: " + font_path)

		print("")
		print("[ResourceValidator] ========== VALIDATION SUMMARY ==========")
		print("")

		# Print summary
		if missing_resources.is_empty() and placeholder_resources.is_empty():
			print("✅ SUCCESS: All required font resources are present!")
			print("")
			print("Found resources:")
			for resource in found_resources:
				print("  • " + resource)
				else:
					if not found_resources.is_empty():
						print("✓ Found resources (" + str(found_resources.size()) + "):")
						for resource in found_resources:
							print("  • " + resource)
							print("")

							if not placeholder_resources.is_empty():
								print("⚠ Resources using placeholders (" + str(placeholder_resources.size()) + "):")
								for resource in placeholder_resources:
									print("  • " + resource)
									print("")
									print("Note: These fonts are using SystemFont placeholders.")
									print("      Replace with actual font files for production use.")
									print("")

									if not missing_resources.is_empty():
										print("✗ MISSING resources (" + str(missing_resources.size()) + "):")
										for resource in missing_resources:
											print("  • " + resource)
											print("")
											print("Action required: Add the missing font files or run:")
											print("  godot --headless --script tools/scripts/create_font_placeholders.gd")

											print("")
											print("[ResourceValidator] ========================================")

											# Additional checks
											_check_fonts_directory()

											print("")
											print("[ResourceValidator] Validation complete.")

											# Exit with appropriate code
											if not missing_resources.is_empty():
												quit(1)  # Exit with error code if resources are missing
												else:
													quit(0)  # Exit successfully


if not dir:
	print("  ✗ ERROR: Cannot access project directory")
	return

	if not dir.dir_exists("assets"):
		print("  ✗ Missing: assets/ directory")
		return

		if not dir.dir_exists("assets/fonts"):
			print("  ✗ Missing: assets/fonts/ directory")
			return

			print("  ✓ Found: assets/fonts/ directory")

			# List contents of fonts directory
			dir.change_dir("assets/fonts")
			dir.list_dir_begin()
while file_name != "":
	if (
	not dir.current_is_dir()
	and (file_name.ends_with(".ttf") or file_name.ends_with(".tres"))
	):
		font_files.append(file_name)
		file_name = dir.get_next()

		dir.list_dir_end()

		if font_files.is_empty():
			print("  ⚠ Warning: No font files found in assets/fonts/")
			else:
				print("  Found " + str(font_files.size()) + " font file(s):")
				font_files.sort()
				for font in font_files:
if font.ends_with(".tres"):
	print("    • " + font + " (placeholder)")
	else:
		print("    • " + font)

func _check_fonts_directory() -> void:
	"""Check if the fonts directory exists and list its contents"""
	print("")
	print("[ResourceValidator] Checking fonts directory structure...")
