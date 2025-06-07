extends SceneTree

# Script to create placeholder font resources for the NeuroVis project
# This generates SystemFont resources that use system fonts as placeholders
# until proper font files are added to the project


var dir = DirAccess.open("res://")
var err = dir.make_dir("assets")
var err = dir.make_dir("fonts")
var fonts_to_create = [
	{
	"filename": "Inter-Regular.tres",
	"original_name": "Inter-Regular.ttf",
	"font_names": ["Inter", "Arial", "Helvetica", "sans-serif"],
	"weight": 400,
	"italic": false
	},
	{
	"filename": "Inter-Bold.tres",
	"original_name": "Inter-Bold.ttf",
	"font_names": ["Inter", "Arial", "Helvetica", "sans-serif"],
	"weight": 700,
	"italic": false
	},
	{
	"filename": "Inter-Variable.tres",
	"original_name": "Inter-Variable.ttf",
	"font_names": ["Inter", "Arial", "Helvetica", "sans-serif"],
	"weight": 400,
	"italic": false
	},
	{
	"filename": "JetBrainsMono-Regular.tres",
	"original_name": "JetBrainsMono-Regular.ttf",
	"font_names": ["JetBrains Mono", "Consolas", "Monaco", "monospace"],
	"weight": 400,
	"italic": false
	}
	]

	# Create placeholder fonts
var created_count = 0
var failed_count = 0

var font_path = "res://assets/fonts/" + font_config.filename

# Check if font already exists
var system_font = SystemFont.new()
	system_font.font_names = font_config.font_names
	system_font.font_weight = font_config.weight
	system_font.font_italic = font_config.italic
	system_font.antialiasing = TextServer.FONT_ANTIALIASING_GRAY
	system_font.hinting = TextServer.HINTING_LIGHT
	system_font.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_DISABLED

	# Save the font resource
var err = ResourceSaver.save(system_font, font_path)
var original_path = "res://assets/fonts/" + font_config.original_name
# Create a duplicate resource pointing to the same system font
var err2 = ResourceSaver.save(system_font, original_path)

func _init():
	print("[FontPlaceholders] Starting font placeholder generation...")

	# Ensure the fonts directory exists

func _fix_orphaned_code():
	if not dir:
		print("[FontPlaceholders] ERROR: Cannot access project directory")
		quit()
		return

		# Create assets directory if it doesn't exist
		if not dir.dir_exists("assets"):
			print("[FontPlaceholders] Creating assets directory...")
func _fix_orphaned_code():
	if err != OK:
		print("[FontPlaceholders] ERROR: Failed to create assets directory")
		quit()
		return

		# Create fonts directory if it doesn't exist
		dir.change_dir("assets")
		if not dir.dir_exists("fonts"):
			print("[FontPlaceholders] Creating assets/fonts directory...")
func _fix_orphaned_code():
	if err != OK:
		print("[FontPlaceholders] ERROR: Failed to create fonts directory")
		quit()
		return

		# Define font configurations
func _fix_orphaned_code():
	for font_config in fonts_to_create:
func _fix_orphaned_code():
	if ResourceLoader.exists(font_path):
		print("[FontPlaceholders] Font already exists: " + font_config.filename)
		continue

		# Create SystemFont resource
func _fix_orphaned_code():
	if err == OK:
		print("[FontPlaceholders] Created placeholder: " + font_config.filename)
		created_count += 1

		# Also create a symlink or copy for the expected .ttf filename
		if font_config.has("original_name"):
func _fix_orphaned_code():
	if err2 == OK:
		print(
		"[FontPlaceholders] Created TTF placeholder: " + font_config.original_name
		)
		else:
			print(
			(
			"[FontPlaceholders] Note: Could not create TTF reference for "
			+ font_config.original_name
			)
			)
			else:
				print(
				(
				"[FontPlaceholders] ERROR: Failed to save "
				+ font_config.filename
				+ " (Error: "
				+ str(err)
				+ ")"
				)
				)
				failed_count += 1

				# Print summary
				print("\n[FontPlaceholders] Generation complete!")
				print("[FontPlaceholders] Created: " + str(created_count) + " placeholder(s)")
				print("[FontPlaceholders] Failed: " + str(failed_count))
				print("[FontPlaceholders] Note: These are temporary placeholders using system fonts.")
				print("[FontPlaceholders] Replace them with actual font files when available.")

				# Quit the script
				quit()

