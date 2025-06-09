## Generate LOD Models Script
## Creates simplified versions of brain models for better performance
## @version: 1.0

extends SceneTree

# === CONSTANTS ===
const MODEL_PATHS = {
	"Half_Brain": "res://assets/models/Half_Brain.glb",
	"Internal_Structures": "res://assets/models/Internal_Structures.glb",
	"Brainstem": "res://assets/models/Brainstem(Solid).glb"
}

const LOD_LEVELS = [
	{"suffix": "_lod0", "reduction": 1.0},  # Original
	{"suffix": "_lod1", "reduction": 0.5},  # 50% vertices
	{"suffix": "_lod2", "reduction": 0.25},  # 25% vertices
	{"suffix": "_lod3", "reduction": 0.1}  # 10% vertices
]

var models_processed: int = 0


func _initialize() -> void:
	print("\n=== NeuroVis LOD Model Generator ===")
	print("Creating optimized LOD versions of brain models...\n")

	# Process each model
	for model_name in MODEL_PATHS:
		_process_model(model_name, MODEL_PATHS[model_name])

	print("\n✅ LOD generation complete!")
	print("Processed %d models with %d LOD levels each" % [models_processed, LOD_LEVELS.size()])

	quit()


func _process_model(model_name: String, model_path: String) -> void:
	print("Processing: %s" % model_name)

	# Load the model
	var resource = load(model_path)
	if not resource:
		push_error("Failed to load model: " + model_path)
		return

	# Create LOD directory
	var lod_dir = "res://assets/models/lod/"
	DirAccess.make_dir_recursive_absolute(lod_dir)

	# For now, we'll save configuration for runtime LOD
	# In production, you'd use external tools like Blender to create actual LOD meshes
	_save_lod_config(model_name, lod_dir)

	models_processed += 1
	print("  ✓ Generated LOD configuration for %s" % model_name)


func _save_lod_config(model_name: String, lod_dir: String) -> void:
	"""Save LOD configuration for runtime use"""
	var config = ConfigFile.new()

	# Save LOD settings
	config.set_value("lod", "model_name", model_name)
	config.set_value("lod", "levels", LOD_LEVELS.size())

	for i in range(LOD_LEVELS.size()):
		var level = LOD_LEVELS[i]
		config.set_value("level_%d" % i, "suffix", level.suffix)
		config.set_value("level_%d" % i, "reduction", level.reduction)
		config.set_value("level_%d" % i, "distance", 10.0 * i)  # Distance thresholds

	# Save aggressive LOD settings for performance
	config.set_value("performance", "aggressive_lod", true)
	config.set_value("performance", "auto_adjust", true)
	config.set_value("performance", "target_fps", 60)

	config.save(lod_dir + model_name + "_lod.cfg")
