extends EditorScript

# This script must be run from the Godot editor using the "Run Current Script" button
# It will add the AI architecture autoloads to the project.godot file

	var editor = get_editor_interface()

	# Add autoloads
	EditorInterface.get_editor_settings().set_setting(
		"autoload/AIConfig", "res://core/ai/config/AIConfigurationManager.gd"
	)
	EditorInterface.get_editor_settings().set_setting(
		"autoload/AIRegistry", "res://core/ai/AIProviderRegistry.gd"
	)
	EditorInterface.get_editor_settings().set_setting(
		"autoload/AIIntegration", "res://core/ai/AIIntegrationManager.gd"
	)

	print("Autoloads added successfully!")
	print("Remember to restart the editor for these changes to take effect.")
func _run() -> void:
	print("Adding AI architecture autoloads...")

	# Get the EditorInterface singleton
@tool
