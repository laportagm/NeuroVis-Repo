@tool
extends EditorScript

# This script must be run from the Godot editor using the "Run Current Script" button
# It will add the AI architecture autoloads to the project.godot file


func _run() -> void:
	print("Adding AI architecture autoloads...")

	# Get the project settings
	var settings = ProjectSettings

	# Add autoloads
	settings.set_setting("autoload/AIConfig", "*res://core/ai/config/AIConfigurationManager.gd")
	settings.set_setting("autoload/AIRegistry", "*res://core/ai/AIProviderRegistry.gd")
	settings.set_setting("autoload/AIIntegration", "*res://core/ai/AIIntegrationManager.gd")

	# Save the project settings
	var error = settings.save()

	if error == OK:
		print("Autoloads added successfully!")
		print("Remember to restart the editor for these changes to take effect.")
	else:
		print("Failed to save project settings!")
