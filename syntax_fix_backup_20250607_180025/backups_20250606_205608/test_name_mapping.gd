extends RefCounted
class_name NameMappingTest


# Test the name normalization function
static func test_normalization():

	var test_cases = [
		"Brain model (separated cerebellum 1) 6a",
		"Thalami (good)",
		"Hipp and Others (good)",
		"Striatum (good)",
		"Ventricles (good)",
		"Corpus Callosum (good)"
	]

	print("=== NAME MAPPING TEST ===")
	for test_name in test_cases:
		var normalized = _normalize_structure_name(test_name)
		print("'%s' -> '%s'" % [test_name, normalized])
	print("========================")


static func _normalize_structure_name(structure_name: String) -> String:
	var normalized = structure_name.to_lower()

	# Special mapping for common 3D model naming patterns
	var name_mappings = {
		"brain model": "cerebellum",
		"thalami": "thalamus",
		"hipp and others": "hippocampus",
		"corpus callosum": "corpus_callosum",
		"cerebellum": "cerebellum",
		"striatum": "striatum",
		"ventricles": "ventricles"
	}

	# Check for exact mapping first
	for pattern in name_mappings:
		if normalized.contains(pattern):
			return name_mappings[pattern]

	# Remove parenthetical suffixes
	var regex = RegEx.new()
	regex.compile("\\s*\\([^)]*\\)\\s*$")
	normalized = regex.sub(normalized, "", true)

	# Remove common prefixes and suffixes
	var prefixes_to_remove = ["brain ", "model "]
	var suffixes_to_remove = [" model", " structure", " region", " area", " cortex", " nucleus"]

	for prefix in prefixes_to_remove:
		if normalized.begins_with(prefix):
			normalized = normalized.substr(prefix.length())

	for suffix in suffixes_to_remove:
		if normalized.ends_with(suffix):
			normalized = normalized.substr(0, normalized.length() - suffix.length())

	normalized = normalized.strip_edges().replace(" ", "_")
	return normalized
