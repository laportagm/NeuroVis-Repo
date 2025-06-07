# Test script for Enhanced Information Panel

extends Control

var test_structure_data = {
	"id": "test_hippocampus",
	"displayName": "Hippocampus",
	"shortDescription":
	"The hippocampus is a critical brain region involved in learning, memory formation, and spatial navigation. It's part of the limbic system and plays a crucial role in converting short-term memories into long-term memories.",
	"functions":
	[
		"Memory consolidation",
		"Spatial navigation and mapping",
		"Learning and memory formation",
		"Emotional memory processing",
		"Pattern recognition"
	],
	"connections":
	["Entorhinal Cortex", "Amygdala", "Prefrontal Cortex", "Thalamus", "Mammillary Bodies"],
	"clinicalNotes":
	"Damage to the hippocampus can result in severe memory impairments, particularly affecting the ability to form new episodic memories (anterograde amnesia). This region is also one of the first areas affected in Alzheimer's disease."
}

@onready var enhanced_panel = $EnhancedInfoPanel
@onready var test_button = $TestButton


func _ready():
	# Set up test button
	test_button.pressed.connect(_on_test_button_pressed)

	# Connect panel signals
	enhanced_panel.panel_closed.connect(_on_panel_closed)
	enhanced_panel.section_toggled.connect(_on_section_toggled)
	enhanced_panel.bookmark_toggled.connect(_on_bookmark_toggled)

	print("[Test] Enhanced panel test scene ready")


func _on_test_button_pressed():
	print("[Test] Testing enhanced panel with sample data")
	enhanced_panel.display_structure_info(test_structure_data)


func _on_panel_closed():
	print("[Test] Panel closed by user")


func _on_section_toggled(section_name: String, expanded: bool):
	print("[Test] Section '%s' %s" % [section_name, "expanded" if expanded else "collapsed"])


func _on_bookmark_toggled(structure_id: String, bookmarked: bool):
	print(
		"[Test] Structure '%s' %s" % [structure_id, "bookmarked" if bookmarked else "unbookmarked"]
	)
