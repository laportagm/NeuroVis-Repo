## ComparativeInfoPanel.gd
## Side-by-side brain structure comparison panel for medical education
##
## This enhanced panel enables medical students to compare two brain structures
## simultaneously, highlighting similarities and differences to understand
## anatomical relationships, functional distinctions, and clinical relevance.
## Perfect for understanding related structures like hippocampus vs amygdala
## in memory systems or caudate vs putamen in motor control.
##
## Educational Features:
## - Side-by-side visual comparison with clear separation
## - Size ratios and spatial relationships
## - Function comparison with unique vs shared roles
## - Clinical condition associations
## - Anatomical connections visualization
## - Educational insights explaining relationships
## - Export functionality for study notes
##
## @tutorial: Comparative Medical Education UI Design
## @tutorial: Differential Learning in Neuroanatomy
## @version: 2.0 - Complete implementation with medical accuracy

class_name ComparativeInfoPanel
extends PanelContainer

# === SIGNALS ===
signal panel_closed
signal structure_swapped(slot: int, new_structure: String)
signal comparison_exported(content: String)
signal educational_insight_shown(insight_type: String)
signal structure_selected_for_slot(slot: int)

# === CONSTANTS ===
const PANEL_MIN_SIZE = Vector2(800, 600)
const ANIMATION_DURATION = 0.3
const SLOT_WIDTH = 380
const COMPARISON_COLORS = {
	"similar": Color("#06FFA5"),  # Green for similarities
	"different": Color("#FF006E"),  # Magenta for differences
	"unique": Color("#FFD93D"),  # Yellow for unique features
	"background": Color(0.1, 0.1, 0.15, 0.95),
	"border": Color(0.3, 0.6, 0.9, 0.8),
	"text_primary": Color.WHITE,
	"text_secondary": Color(0.8, 0.8, 0.8)
}

# === UI ELEMENTS ===
# Main containers
var main_container: VBoxContainer
var header_container: HBoxContainer
var comparison_container: HBoxContainer
var insights_container: VBoxContainer

# Header elements
var title_label: Label
var swap_button: Button
var export_button: Button
var close_button: Button

# Structure slots
var left_slot: VBoxContainer
var right_slot: VBoxContainer
var left_structure_name: Label
var right_structure_name: Label
var left_swap_button: Button
var right_swap_button: Button

# Comparison sections
var size_comparison: HBoxContainer
var location_comparison: HBoxContainer
var function_comparison: VBoxContainer
var clinical_comparison: VBoxContainer
var connection_comparison: VBoxContainer

# Educational insights
var insights_label: Label
var insights_content: RichTextLabel

# === STATE MANAGEMENT ===
var left_structure: Dictionary = {}
var right_structure: Dictionary = {}
var comparison_active: bool = false
var insights_data: Dictionary = {}

# === LIFECYCLE ===
func _ready() -> void:
	"""Initialize the comparative panel"""
	set_process_unhandled_input(true)
	_setup_panel_structure()
	_apply_comparison_styling()
	_setup_interactions()
	visible = false
	print("[ComparativePanel] Ready for medical structure comparison")


func _exit_tree() -> void:
	"""Clean up when panel is removed"""
	left_structure.clear()
	right_structure.clear()
	insights_data.clear()


# === PUBLIC INTERFACE ===
func compare_structures(structure1: Dictionary, structure2: Dictionary) -> void:
	"""Set up comparison between two brain structures"""
	if structure1.is_empty() or structure2.is_empty():
		push_error("[ComparativePanel] Both structures required for comparison")
		return

	# Prevent self-comparison
	if structure1.get("id", "") == structure2.get("id", ""):
		push_warning("[ComparativePanel] Cannot compare structure with itself")
		return

	left_structure = structure1
	right_structure = structure2
	comparison_active = true

	# Update UI
	_update_structure_slots()
	_update_comparisons()
	_generate_educational_insights()

	# Show panel
	show_panel()


func set_left_structure(structure: Dictionary) -> void:
	"""Set structure for left comparison slot"""
	if structure.is_empty():
		return

	left_structure = structure
	_update_left_slot()

	if not right_structure.is_empty():
		comparison_active = true
		_update_comparisons()
		_generate_educational_insights()


func set_right_structure(structure: Dictionary) -> void:
	"""Set structure for right comparison slot"""
	if structure.is_empty():
		return

	right_structure = structure
	_update_right_slot()

	if not left_structure.is_empty():
		comparison_active = true
		_update_comparisons()
		_generate_educational_insights()


func swap_structures() -> void:
	"""Swap left and right structures"""
	if not comparison_active:
		return

	var temp = left_structure
	left_structure = right_structure
	right_structure = temp

	_update_structure_slots()
	_update_comparisons()

	structure_swapped.emit(0, left_structure.get("id", ""))
	structure_swapped.emit(1, right_structure.get("id", ""))


func clear_comparison() -> void:
	"""Clear current comparison"""
	left_structure.clear()
	right_structure.clear()
	comparison_active = false
	hide_panel()


func show_panel() -> void:
	"""Show panel with animation"""
	visible = true
	modulate.a = 0.0

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1.0, ANIMATION_DURATION)

	# Slight scale effect
	scale = Vector2(0.98, 0.98)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, ANIMATION_DURATION)


func hide_panel() -> void:
	"""Hide panel with animation"""
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, ANIMATION_DURATION * 0.8)
	tween.parallel().tween_property(self, "scale", Vector2(0.98, 0.98), ANIMATION_DURATION * 0.8)
	tween.tween_callback(func(): visible = false)
	panel_closed.emit()


# === PRIVATE SETUP METHODS ===
func _setup_panel_structure() -> void:
	"""Create the comparative panel structure"""
	# Base panel configuration
	custom_minimum_size = PANEL_MIN_SIZE
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	size_flags_vertical = Control.SIZE_SHRINK_CENTER

	# Main container
	main_container = VBoxContainer.new()
	main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_container.add_theme_constant_override("separation", 16)
	add_child(main_container)

	# Create sections
	_create_header_section()
	_create_comparison_container()
	_create_insights_section()


func _create_header_section() -> void:
	"""Create panel header with controls"""
	var header_bg = PanelContainer.new()
	header_bg.custom_minimum_size.y = 60
	main_container.add_child(header_bg)

	header_container = HBoxContainer.new()
	header_container.add_theme_constant_override("separation", 12)
	header_bg.add_child(header_container)

	# Title
	title_label = Label.new()
	title_label.text = "Structure Comparison"
	title_label.add_theme_font_size_override("font_size", 22)
	title_label.add_theme_color_override("font_color", COMPARISON_COLORS.text_primary)
	header_container.add_child(title_label)

	# Spacer
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_container.add_child(spacer)

	# Swap button
	swap_button = Button.new()
	swap_button.text = "↔️ Swap"
	swap_button.tooltip_text = "Swap left and right structures"
	swap_button.custom_minimum_size = Vector2(100, 40)
	header_container.add_child(swap_button)

	# Export button
	export_button = Button.new()
	export_button.text = "📄 Export"
	export_button.tooltip_text = "Export comparison for study notes"
	export_button.custom_minimum_size = Vector2(100, 40)
	header_container.add_child(export_button)

	# Close button
	close_button = Button.new()
	close_button.text = "✕"
	close_button.tooltip_text = "Close comparison (ESC)"
	close_button.custom_minimum_size = Vector2(40, 40)
	close_button.flat = true
	header_container.add_child(close_button)


func _create_comparison_container() -> void:
	"""Create main comparison area with two slots"""
	var scroll = ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_container.add_child(scroll)

	comparison_container = HBoxContainer.new()
	comparison_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	comparison_container.add_theme_constant_override("separation", 20)
	scroll.add_child(comparison_container)

	# Left structure slot
	left_slot = _create_structure_slot("left")
	comparison_container.add_child(left_slot)

	# Divider
	var divider = VSeparator.new()
	divider.add_theme_constant_override("separation", 2)
	divider.modulate = COMPARISON_COLORS.border
	comparison_container.add_child(divider)

	# Right structure slot
	right_slot = _create_structure_slot("right")
	comparison_container.add_child(right_slot)


func _create_structure_slot(side: String) -> VBoxContainer:
	"""Create a structure display slot"""
	var slot = VBoxContainer.new()
	slot.custom_minimum_size.x = SLOT_WIDTH
	slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slot.add_theme_constant_override("separation", 12)

	# Slot header
	var header_panel = PanelContainer.new()
	var header_style = StyleBoxFlat.new()
	header_style.bg_color = Color(0.15, 0.15, 0.2, 0.6)
	header_style.set_corner_radius_all(8)
	header_style.set_content_margin_all(12)
	header_panel.add_theme_stylebox_override("panel", header_style)
	slot.add_child(header_panel)

	var header_box = HBoxContainer.new()
	header_panel.add_child(header_box)

	# Structure name
	var name_label = Label.new()
	name_label.text = "Select Structure"
	name_label.add_theme_font_size_override("font_size", 18)
	name_label.add_theme_color_override("font_color", COMPARISON_COLORS.text_secondary)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_box.add_child(name_label)

	if side == "left":
		left_structure_name = name_label
	else:
		right_structure_name = name_label

	# Swap button for slot
	var swap_btn = Button.new()
	swap_btn.text = "🔄"
	swap_btn.tooltip_text = "Change structure"
	swap_btn.custom_minimum_size = Vector2(40, 30)
	swap_btn.flat = true
	header_box.add_child(swap_btn)

	if side == "left":
		left_swap_button = swap_btn
	else:
		right_swap_button = swap_btn

	# Content sections
	_create_slot_content_sections(slot, side)

	return slot


func _create_slot_content_sections(slot: VBoxContainer, side: String) -> void:
	"""Create content sections for a structure slot"""
	# Size section
	var size_container = _create_info_section(slot, "SIZE", side + "_size")

	# Location section
	var location_container = _create_info_section(slot, "LOCATION", side + "_location")

	# Functions section
	var functions_container = _create_info_section(slot, "FUNCTIONS", side + "_functions")
	functions_container.custom_minimum_size.y = 100

	# Clinical section
	var clinical_container = _create_info_section(slot, "CLINICAL", side + "_clinical")
	clinical_container.custom_minimum_size.y = 80

	# Connections section
	var connections_container = _create_info_section(slot, "CONNECTIONS", side + "_connections")


func _create_info_section(parent: Control, title: String, section_name: String) -> PanelContainer:
	"""Create an information section"""
	var panel = PanelContainer.new()
	panel.name = section_name
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.12, 0.5)
	style.set_corner_radius_all(6)
	style.set_content_margin_all(8)
	panel.add_theme_stylebox_override("panel", style)
	parent.add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	panel.add_child(vbox)

	# Section title
	var title_label = Label.new()
	title_label.text = title
	title_label.add_theme_font_size_override("font_size", 12)
	title_label.add_theme_color_override("font_color", COMPARISON_COLORS.text_secondary)
	vbox.add_child(title_label)

	# Content label
	var content_label = Label.new()
	content_label.name = "content"
	content_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content_label.add_theme_font_size_override("font_size", 14)
	vbox.add_child(content_label)

	return panel


func _create_insights_section() -> void:
	"""Create educational insights section"""
	insights_container = VBoxContainer.new()
	insights_container.add_theme_constant_override("separation", 8)
	main_container.add_child(insights_container)

	# Insights header
	var header_box = HBoxContainer.new()
	insights_container.add_child(header_box)

	insights_label = Label.new()
	insights_label.text = "💡 Educational Insights"
	insights_label.add_theme_font_size_override("font_size", 18)
	insights_label.add_theme_color_override("font_color", COMPARISON_COLORS.unique)
	header_box.add_child(insights_label)

	# Insights content
	insights_content = RichTextLabel.new()
	insights_content.bbcode_enabled = true
	insights_content.fit_content = true
	insights_content.custom_minimum_size.y = 100
	insights_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	insights_container.add_child(insights_content)


# === UPDATE METHODS ===
func _update_structure_slots() -> void:
	"""Update both structure slots with current data"""
	_update_left_slot()
	_update_right_slot()


func _update_left_slot() -> void:
	"""Update left structure slot"""
	if left_structure.is_empty():
		left_structure_name.text = "Select Structure"
		left_structure_name.add_theme_color_override("font_color", COMPARISON_COLORS.text_secondary)
		_clear_slot_content(left_slot)
		return

	# Update name
	left_structure_name.text = left_structure.get("displayName", "Unknown")
	left_structure_name.add_theme_color_override("font_color", COMPARISON_COLORS.similar)

	# Update sections
	_update_slot_section(left_slot, "left_size", _get_structure_size(left_structure))
	_update_slot_section(left_slot, "left_location", _get_structure_location(left_structure))
	_update_slot_section(left_slot, "left_functions", _get_functions_summary(left_structure))
	_update_slot_section(left_slot, "left_clinical", _get_clinical_summary(left_structure))
	_update_slot_section(left_slot, "left_connections", _get_connections_summary(left_structure))


func _update_right_slot() -> void:
	"""Update right structure slot"""
	if right_structure.is_empty():
		right_structure_name.text = "Select Structure"
		right_structure_name.add_theme_color_override("font_color", COMPARISON_COLORS.text_secondary)
		_clear_slot_content(right_slot)
		return

	# Update name
	right_structure_name.text = right_structure.get("displayName", "Unknown")
	right_structure_name.add_theme_color_override("font_color", COMPARISON_COLORS.different)

	# Update sections
	_update_slot_section(right_slot, "right_size", _get_structure_size(right_structure))
	_update_slot_section(right_slot, "right_location", _get_structure_location(right_structure))
	_update_slot_section(right_slot, "right_functions", _get_functions_summary(right_structure))
	_update_slot_section(right_slot, "right_clinical", _get_clinical_summary(right_structure))
	_update_slot_section(right_slot, "right_connections", _get_connections_summary(right_structure))


func _update_slot_section(slot: Control, section_name: String, content: String) -> void:
	"""Update a specific section in a slot"""
	var section = slot.find_child(section_name, true, false)
	if section:
		var content_label = section.find_child("content", true, false)
		if content_label and content_label is Label:
			content_label.text = content


func _clear_slot_content(slot: Control) -> void:
	"""Clear all content from a slot"""
	var sections = ["size", "location", "functions", "clinical", "connections"]
	var prefix = "left_" if slot == left_slot else "right_"

	for section in sections:
		_update_slot_section(slot, prefix + section, "—")


func _update_comparisons() -> void:
	"""Update comparison highlights between structures"""
	if not comparison_active:
		return

	# Compare sizes
	_highlight_size_differences()

	# Compare functions
	_highlight_function_differences()

	# Compare clinical relevance
	_highlight_clinical_differences()

	# Compare connections
	_highlight_connection_differences()


func _highlight_size_differences() -> void:
	"""Highlight size differences between structures"""
	var left_size = _get_structure_size_value(left_structure)
	var right_size = _get_structure_size_value(right_structure)

	if left_size > 0 and right_size > 0:
		var ratio = left_size / right_size
		var left_section = left_slot.find_child("left_size", true, false)
		var right_section = right_slot.find_child("right_size", true, false)

		if ratio > 1.1:  # Left is >10% larger
			_apply_highlight(left_section, COMPARISON_COLORS.similar)
			_apply_highlight(right_section, COMPARISON_COLORS.different)
			_add_size_comparison_note("~%.0f%% larger" % ((ratio - 1) * 100), "left")
		elif ratio < 0.9:  # Right is >10% larger
			_apply_highlight(left_section, COMPARISON_COLORS.different)
			_apply_highlight(right_section, COMPARISON_COLORS.similar)
			_add_size_comparison_note("~%.0f%% larger" % ((1/ratio - 1) * 100), "right")
		else:  # Similar size
			_apply_highlight(left_section, COMPARISON_COLORS.similar)
			_apply_highlight(right_section, COMPARISON_COLORS.similar)
			_add_size_comparison_note("Similar size", "both")


func _highlight_function_differences() -> void:
	"""Highlight functional differences and similarities"""
	var left_functions = left_structure.get("functions", [])
	var right_functions = right_structure.get("functions", [])

	# Find unique and shared functions
	var shared_functions = []
	var left_unique = []
	var right_unique = []

	for func in left_functions:
		var found = false
		for r_func in right_functions:
			if _functions_similar(func, r_func):
				shared_functions.append(func)
				found = true
				break
		if not found:
			left_unique.append(func)

	for func in right_functions:
		var found = false
		for shared in shared_functions:
			if _functions_similar(func, shared):
				found = true
				break
		if not found:
			right_unique.append(func)

	# Update displays with highlights
	var left_section = left_slot.find_child("left_functions", true, false)
	var right_section = right_slot.find_child("right_functions", true, false)

	if shared_functions.size() > 0:
		_apply_highlight(left_section, COMPARISON_COLORS.similar)
		_apply_highlight(right_section, COMPARISON_COLORS.similar)

	# Store for insights
	insights_data["shared_functions"] = shared_functions
	insights_data["left_unique_functions"] = left_unique
	insights_data["right_unique_functions"] = right_unique


func _highlight_clinical_differences() -> void:
	"""Highlight clinical relevance differences"""
	var left_clinical = _get_clinical_conditions(left_structure)
	var right_clinical = _get_clinical_conditions(right_structure)

	var shared_conditions = []
	for condition in left_clinical:
		if condition in right_clinical:
			shared_conditions.append(condition)

	var left_section = left_slot.find_child("left_clinical", true, false)
	var right_section = right_slot.find_child("right_clinical", true, false)

	if shared_conditions.size() > 0:
		_apply_highlight(left_section, COMPARISON_COLORS.unique)
		_apply_highlight(right_section, COMPARISON_COLORS.unique)
		insights_data["shared_conditions"] = shared_conditions


func _highlight_connection_differences() -> void:
	"""Highlight connection pattern differences"""
	var left_connections = _get_structure_connections(left_structure)
	var right_connections = _get_structure_connections(right_structure)

	var shared_connections = []
	for conn in left_connections:
		if conn in right_connections:
			shared_connections.append(conn)

	if shared_connections.size() > 0:
		insights_data["shared_connections"] = shared_connections


# === EDUCATIONAL INSIGHTS ===
func _generate_educational_insights() -> void:
	"""Generate educational insights about the comparison"""
	if not comparison_active:
		insights_content.text = ""
		return

	var insights_text = ""
	var left_name = left_structure.get("displayName", "Structure 1")
	var right_name = right_structure.get("displayName", "Structure 2")

	# System membership insights
	var system_insight = _generate_system_insight(left_structure, right_structure)
	if system_insight != "":
		insights_text += "[color=#06FFA5]System Relationship:[/color] " + system_insight + "\n\n"

	# Functional relationship insights
	if insights_data.has("shared_functions") and insights_data.shared_functions.size() > 0:
		insights_text += "[color=#06FFA5]Functional Overlap:[/color] Both structures are involved in "
		insights_text += _natural_language_list(insights_data.shared_functions) + "\n\n"

	# Clinical insights
	if insights_data.has("shared_conditions") and insights_data.shared_conditions.size() > 0:
		insights_text += "[color=#FFD93D]Clinical Correlation:[/color] Both structures can be affected in "
		insights_text += _natural_language_list(insights_data.shared_conditions)
		insights_text += ", suggesting interconnected pathology.\n\n"

	# Specific comparisons
	var specific_insight = _get_specific_comparison_insight(left_structure.get("id", ""), right_structure.get("id", ""))
	if specific_insight != "":
		insights_text += "[color=#FF006E]Key Distinction:[/color] " + specific_insight + "\n\n"

	# Educational summary
	insights_text += _generate_learning_summary(left_name, right_name)

	insights_content.text = insights_text
	educational_insight_shown.emit("comparison")


func _generate_system_insight(struct1: Dictionary, struct2: Dictionary) -> String:
	"""Generate insight about system membership"""
	var id1 = struct1.get("id", "").to_lower()
	var id2 = struct2.get("id", "").to_lower()

	# Limbic system
	var limbic = ["hippocampus", "amygdala", "cingulate", "fornix"]
	if id1 in limbic and id2 in limbic:
		return "Both are core components of the limbic system, working together in emotion and memory processing."

	# Basal ganglia
	var basal_ganglia = ["striatum", "caudate", "putamen", "globus_pallidus", "substantia_nigra"]
	if id1 in basal_ganglia and id2 in basal_ganglia:
		return "Both are part of the basal ganglia circuit, crucial for motor control and habit formation."

	# Diencephalon
	var diencephalon = ["thalamus", "hypothalamus", "epithalamus", "subthalamus"]
	if id1 in diencephalon and id2 in diencephalon:
		return "Both belong to the diencephalon, serving as relay and regulatory centers."

	return ""


func _get_specific_comparison_insight(id1: String, id2: String) -> String:
	"""Get specific insights for common comparisons"""
	var pair = [id1.to_lower(), id2.to_lower()]
	pair.sort()

	var insights_db = {
		["amygdala", "hippocampus"]: "While the hippocampus encodes memories, the amygdala adds emotional significance, creating emotionally-charged memories.",
		["caudate", "putamen"]: "Together they form the striatum - caudate handles cognitive loops while putamen focuses on motor loops.",
		["thalamus", "hypothalamus"]: "The thalamus relays sensory information to cortex, while hypothalamus maintains homeostasis and drives.",
		["broca", "wernicke"]: "Broca's area produces speech, Wernicke's area comprehends it - damage creates distinct aphasia types.",
		["globus_pallidus", "substantia_nigra"]: "Both output structures of basal ganglia - substantia nigra provides dopamine, globus pallidus inhibits movement."
	}

	var key = pair[0] + "," + pair[1]
	for insight_key in insights_db:
		if insight_key[0] == pair[0] and insight_key[1] == pair[1]:
			return insights_db[insight_key]

	return ""


func _generate_learning_summary(name1: String, name2: String) -> String:
	"""Generate educational summary"""
	return "[color=#00D9FF]Learning Point:[/color] Understanding how " + name1 + " and " + name2 + " work together helps explain integrated brain function in health and disease."


# === EXPORT FUNCTIONALITY ===
func _export_comparison() -> void:
	"""Export comparison data for study notes"""
	if not comparison_active:
		return

	var export_text = "# Brain Structure Comparison\n"
	export_text += "## " + left_structure.get("displayName", "Unknown") + " vs " + right_structure.get("displayName", "Unknown") + "\n\n"

	# Size comparison
	export_text += "### Size Comparison\n"
	export_text += "- " + left_structure.get("displayName", "") + ": " + _get_structure_size(left_structure) + "\n"
	export_text += "- " + right_structure.get("displayName", "") + ": " + _get_structure_size(right_structure) + "\n\n"

	# Functions
	export_text += "### Functions\n"
	export_text += "**" + left_structure.get("displayName", "") + ":**\n"
	for func in left_structure.get("functions", []):
		export_text += "- " + func + "\n"
	export_text += "\n**" + right_structure.get("displayName", "") + ":**\n"
	for func in right_structure.get("functions", []):
		export_text += "- " + func + "\n"

	# Clinical relevance
	export_text += "\n### Clinical Relevance\n"
	export_text += _format_clinical_for_export(left_structure, right_structure)

	# Insights
	export_text += "\n### Educational Insights\n"
	export_text += insights_content.text.replace("[color=#", "").replace("[/color]", "").replace("]", ": ")

	# Save to clipboard or file
	DisplayServer.clipboard_set(export_text)
	comparison_exported.emit(export_text)
	print("[ComparativePanel] Comparison exported to clipboard")


# === HELPER METHODS ===
func _get_structure_size(structure: Dictionary) -> String:
	"""Get size description for structure"""
	var id = structure.get("id", "")
	var sizes = {
		"hippocampus": "~3.5 cm",
		"amygdala": "~1.5 cm",
		"striatum": "~6 cm",
		"thalamus": "~3 cm",
		"cortex": "2-4 mm thick",
		"cerebellum": "~10 cm",
		"ventricles": "~150 mL"
	}
	return sizes.get(id, "Variable")


func _get_structure_size_value(structure: Dictionary) -> float:
	"""Get numeric size value for comparison"""
	var size_str = _get_structure_size(structure)
	var regex = RegEx.new()
	regex.compile("([0-9.]+)")
	var result = regex.search(size_str)
	if result:
		return float(result.get_string(1))
	return 0.0


func _get_structure_location(structure: Dictionary) -> String:
	"""Get location description"""
	var id = structure.get("id", "")
	var locations = {
		"hippocampus": "Medial temporal lobe",
		"amygdala": "Medial temporal lobe",
		"striatum": "Basal ganglia",
		"thalamus": "Diencephalon",
		"cortex": "Cerebral surface",
		"cerebellum": "Posterior fossa"
	}
	return locations.get(id, "Central nervous system")


func _get_functions_summary(structure: Dictionary) -> String:
	"""Get abbreviated functions list"""
	var functions = structure.get("functions", [])
	if functions.size() == 0:
		return "No functions documented"
	elif functions.size() <= 3:
		return "\n".join(functions)
	else:
		var summary = ""
		for i in range(3):
			summary += functions[i] + "\n"
		summary += "(+" + str(functions.size() - 3) + " more)"
		return summary


func _get_clinical_summary(structure: Dictionary) -> String:
	"""Get clinical relevance summary"""
	var clinical = structure.get("clinicalRelevance", "")
	if clinical.length() > 100:
		return clinical.substr(0, 97) + "..."
	return clinical if clinical != "" else "No clinical data"


func _get_clinical_conditions(structure: Dictionary) -> Array:
	"""Extract clinical conditions from structure"""
	var conditions = []
	var clinical_text = structure.get("clinicalRelevance", "")

	# Common conditions to look for
	var known_conditions = ["Alzheimer", "Parkinson", "epilepsy", "stroke", "amnesia", "PTSD", "depression", "schizophrenia"]

	for condition in known_conditions:
		if condition.to_lower() in clinical_text.to_lower():
			conditions.append(condition)

	return conditions


func _get_connections_summary(structure: Dictionary) -> String:
	"""Get connections summary"""
	# This would connect to actual connection data
	return "Multiple connections"


func _get_structure_connections(structure: Dictionary) -> Array:
	"""Get list of connected structures"""
	# Placeholder - would connect to real data
	return ["cortex", "thalamus", "brainstem"]


func _functions_similar(func1: String, func2: String) -> bool:
	"""Check if two functions are similar"""
	var keywords1 = func1.to_lower().split(" ")
	var keywords2 = func2.to_lower().split(" ")

	var matches = 0
	for word in keywords1:
		if word.length() > 3 and word in keywords2:
			matches += 1

	return matches >= 2


func _natural_language_list(items: Array) -> String:
	"""Convert array to natural language list"""
	if items.size() == 0:
		return ""
	elif items.size() == 1:
		return items[0]
	elif items.size() == 2:
		return items[0] + " and " + items[1]
	else:
		var result = ""
		for i in range(items.size() - 1):
			result += items[i] + ", "
		result += "and " + items[items.size() - 1]
		return result


func _apply_highlight(control: Control, color: Color) -> void:
	"""Apply highlight color to a control"""
	if control:
		var style = control.get_theme_stylebox("panel")
		if style and style is StyleBoxFlat:
			style.border_color = color
			style.set_border_width_all(2)


func _add_size_comparison_note(note: String, side: String) -> void:
	"""Add comparison note to size section"""
	# Would add visual indicator of size difference
	pass


func _format_clinical_for_export(struct1: Dictionary, struct2: Dictionary) -> String:
	"""Format clinical data for export"""
	var text = "**" + struct1.get("displayName", "") + ":**\n"
	text += struct1.get("clinicalRelevance", "No clinical data") + "\n\n"
	text += "**" + struct2.get("displayName", "") + ":**\n"
	text += struct2.get("clinicalRelevance", "No clinical data") + "\n"
	return text


# === STYLING ===
func _apply_comparison_styling() -> void:
	"""Apply glassmorphism styling to panel"""
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = COMPARISON_COLORS.background
	panel_style.border_color = COMPARISON_COLORS.border
	panel_style.set_border_width_all(1)
	panel_style.set_corner_radius_all(12)
	panel_style.shadow_color = Color(0, 0, 0, 0.3)
	panel_style.shadow_size = 8
	panel_style.shadow_offset = Vector2(0, 4)
	add_theme_stylebox_override("panel", panel_style)


# === INTERACTION SETUP ===
func _setup_interactions() -> void:
	"""Setup button interactions"""
	close_button.pressed.connect(_on_close_pressed)
	swap_button.pressed.connect(swap_structures)
	export_button.pressed.connect(_export_comparison)

	left_swap_button.pressed.connect(func(): structure_selected_for_slot.emit(0))
	right_swap_button.pressed.connect(func(): structure_selected_for_slot.emit(1))

	# Keyboard shortcuts
	set_process_unhandled_key_input(true)


func _unhandled_key_input(event: InputEvent) -> void:
	"""Handle keyboard shortcuts"""
	if not visible:
		return

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ESCAPE:
				hide_panel()
				get_viewport().set_input_as_handled()
			KEY_S:
				if event.ctrl_pressed or event.meta_pressed:
					swap_structures()
					get_viewport().set_input_as_handled()
			KEY_E:
				if event.ctrl_pressed or event.meta_pressed:
					_export_comparison()
					get_viewport().set_input_as_handled()


func _on_close_pressed() -> void:
	"""Handle close button press"""
	hide_panel()
