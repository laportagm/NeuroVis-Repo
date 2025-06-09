class_name BrainVisualizationCore
extends Node3D

# The NeuralNet class handles all core 3D representation and
# functionality for neural network visualization

# Signal to notify about ready state

signal neural_net_ready

# Structure mapping (mesh name to standardized ID)

# FIXED: Orphaned code - var structure_map = {
# Common name variations in 3D models
"Thalamus": "Thalamus",
"thalamus": "Thalamus",
"Thalami (good)": "Thalamus",  # Model-specific name
"Thalami": "Thalamus",
"Hippocampus": "Hippocampus",
"hippocampus": "Hippocampus",
"Hippocampus (good)": "Hippocampus",  # Model-specific name
"Hipp and Others (good)": "Hippocampus",  # Composite mesh in model that contains hippocampus
"Amygdala": "Amygdala",
"amygdala": "Amygdala",
"Amygdala (good)": "Amygdala",  # Model-specific name
"Midbrain": "Midbrain",
"midbrain": "Midbrain",
"Mesencephalon": "Midbrain",
"Midbrain (good)": "Midbrain",  # Model-specific name
"Pons": "Pons",
"pons": "Pons",
"Pons (good)": "Pons",  # Model-specific name
"Medulla": "Medulla",
"medulla": "Medulla",
"Medulla_Oblongata": "Medulla",
"MedullaOblongata": "Medulla",
"Medulla (good)": "Medulla",  # Model-specific name
"Corpus_Callosum": "Corpus_Callosum",
"CorpusCallosum": "Corpus_Callosum",
"Corpus Callosum (good)": "Corpus_Callosum",  # Model-specific name
"Brainstem": "Brainstem",
"brainstem": "Brainstem",
"Brainstem (good)": "Brainstem",  # Model-specific name
"Brainstem (good) 1": "Brainstem",  # Specific model instance
"Cerebellum": "Cerebellum",
"cerebellum": "Cerebellum",
"Cerebellum (good)": "Cerebellum",  # Model-specific name
"Brain model (separated cerebellum 1) 6a": "Cerebellum",  # Specific model instance
"Frontal_Lobe": "Frontal_Lobe",
"FrontalLobe": "Frontal_Lobe",
"Frontal Lobe (good)": "Frontal_Lobe",  # Model-specific name
"Temporal_Lobe": "Temporal_Lobe",
"TemporalLobe": "Temporal_Lobe",
"Temporal Lobe (good)": "Temporal_Lobe",  # Model-specific name
"Parietal_Lobe": "Parietal_Lobe",
"ParietalLobe": "Parietal_Lobe",
"Parietal Lobe (good)": "Parietal_Lobe",  # Model-specific name
"Occipital_Lobe": "Occipital_Lobe",
"OccipitalLobe": "Occipital_Lobe",
"Occipital Lobe (good)": "Occipital_Lobe",  # Model-specific name
# Additional meshes from the model that need mapping
"Ventricles (good)": "Ventricles",
"Ventricles": "Ventricles",
# Striatum mapping
"Striatum": "Striatum",
"striatum": "Striatum",
"Striatum (good)": "Striatum"  # Model-specific name
}


# FIXED: Orphaned code - var name_str = String(mesh_name)

# Try direct lookup first
var lower_name = name_str.to_lower()

func _ready() -> void:
	# Print confirmation message to the console when the scene is ready
	print("NeuralNet scene is ready and initialized.")

	# Log all mapped structure names
	print("Available structure mappings:")
	print(structure_map.keys())

	# Emit signal to notify other nodes that we're ready
	neural_net_ready.emit()


	# Map mesh name to structure ID

func map_mesh_name_to_structure_id(mesh_name: String) -> String:
	# Convert to string in case we got something else
func add_structure_mapping(mesh_name: String, structure_id: String) -> void:
	structure_map[mesh_name] = structure_id
	print("Added structure mapping: " + mesh_name + " -> " + structure_id)

if structure_map.has(name_str):
	return structure_map[name_str]

	# Try lowercase
if structure_map.has(lower_name):
	return structure_map[lower_name]

	# Try partial matching (check if mesh name contains any of our known keys)
	for key in structure_map:
		if name_str.contains(key) or key.contains(name_str):
			return structure_map[key]

			# No match found, log a verbose message to aid in debugging
			print_verbose("NeuralNet: No structure ID mapping found for mesh_name: '" + name_str + "'")
			return ""


			# Add a structure mapping
