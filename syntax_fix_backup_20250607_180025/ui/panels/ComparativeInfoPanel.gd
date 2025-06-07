## ComparativeInfoPanel.gd
## Educational comparative information display for multi-structure selection
##
## This panel displays information for up to 3 selected anatomical structures
## in a comparative format, highlighting relationships and differences for
## effective neuroanatomy learning.
##
## @tutorial: Comparative UI design for educational applications
## @version: 1.0

extends PanelContainer

# === SIGNALS ===

signal structure_focused(structure_name: String)
signal comparison_cleared
# Kept for future analytics/tracking
signal relationship_explored(relationship: String)

# === CONSTANTS ===

const MAX_STRUCTURES: int = 3
const PANEL_ANIMATION_TIME: float = 0.3
const STRUCTURE_CARD_HEIGHT: int = 200

# === NODES ===

var structure_container: VBoxContainer = $VBox/ScrollContainer/ContentVBox/StructureContainer
@onready
var relationship_container: VBoxContainer = $VBox/ScrollContainer/ContentVBox/RelationshipContainer
var card = _create_structure_card(i)
structure_container.add_child(card)
_structure_cards.append(card)
card.hide()

# Setup relationship section
var relationship_label = Label.new()
relationship_label.text = "Anatomical Relationships:"
relationship_label.add_theme_font_size_override("font_size", 16)
relationship_container.add_child(relationship_label)


var card = PanelContainer.new()
card.custom_minimum_size = Vector2(0, STRUCTURE_CARD_HEIGHT)

var vbox = VBoxContainer.new()
card.add_child(vbox)

# Header with structure name and state
var header = HBoxContainer.new()
vbox.add_child(header)

var state_indicator = ColorRect.new()
state_indicator.custom_minimum_size = Vector2(8, 30)
state_indicator.name = "StateIndicator"
header.add_child(state_indicator)

var name_label = Label.new()
name_label.name = "NameLabel"
name_label.add_theme_font_size_override("font_size", 18)
header.add_child(name_label)

var spacer = Control.new()
spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
header.add_child(spacer)

var focus_button = Button.new()
focus_button.text = "Focus"
focus_button.name = "FocusButton"
focus_button.custom_minimum_size = Vector2(60, 0)
header.add_child(focus_button)

# Content sections
var hsep = HSeparator.new()
vbox.add_child(hsep)

# Quick facts
var facts_label = Label.new()
facts_label.name = "FactsLabel"
facts_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
vbox.add_child(facts_label)

# Functions
var functions_label = Label.new()
functions_label.name = "FunctionsLabel"
functions_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
vbox.add_child(functions_label)

# Clinical relevance (abbreviated for space)
var clinical_label = Label.new()
clinical_label.name = "ClinicalLabel"
clinical_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
clinical_label.add_theme_color_override("font_color", Color(1.0, 0.8, 0.8))
vbox.add_child(clinical_label)

var colors = _theme_manager.get_color_palette()

# Panel styling
var panel_style = StyleBoxFlat.new()
panel_style.bg_color = colors["surface"]
panel_style.border_color = colors["primary"]
panel_style.set_border_width_all(2)
panel_style.set_corner_radius_all(8)
panel_style.set_content_margin_all(12)

add_theme_stylebox_override("panel", panel_style)

# Card styling
var card_style = StyleBoxFlat.new()
card_style.bg_color = colors["surface_variant"]
card_style.set_corner_radius_all(6)
card_style.set_content_margin_all(8)
card.add_theme_stylebox_override("panel", card_style)


# === PUBLIC METHODS ===
## Update display with new structure selections
var card = _structure_cards[index]
var structure_name = selection_data["name"]
var structure_data = {}

var normalized_name = _normalize_structure_name(structure_name)
structure_data = _knowledge_service.get_structure(normalized_name)

# Update state indicator
var state_indicator = card.find_child("StateIndicator")
var name_label = card.find_child("NameLabel")
var focus_button = card.find_child("FocusButton")
var facts_label = card.find_child("FactsLabel")
var functions_label = card.find_child("FunctionsLabel")
var functions = structure_data.get("functions", [])
var clinical_label = card.find_child("ClinicalLabel")
var clinical = structure_data.get("clinicalRelevance", "")
var abbreviated = []
var card = _structure_cards[index]
var tween = create_tween()
tween.tween_property(card, "modulate:a", 1.0, PANEL_ANIMATION_TIME)


var card = _structure_cards[index]
var tween = create_tween()
tween.tween_property(card, "modulate:a", 0.0, PANEL_ANIMATION_TIME)
tween.tween_callback(card.hide)


var relationships = _find_relationships()

var rel_label = Label.new()
rel_label.text = "• " + rel
rel_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
relationship_container.add_child(rel_label)
var no_rel_label = Label.new()
no_rel_label.text = "• No direct relationships found"
no_rel_label.modulate.a = 0.6
relationship_container.add_child(no_rel_label)


var relationships = []

# Example relationship detection (extend with actual data)
var structure_names = []
var systems = {
"limbic": ["hippocampus", "amygdala", "cingulate", "fornix"],
"basal_ganglia": ["caudate", "putamen", "globus_pallidus", "substantia_nigra"],
"diencephalon": ["thalamus", "hypothalamus", "epithalamus"],
"brainstem": ["midbrain", "pons", "medulla"]
}

var system_structures = systems[system_name]
var matches = 0

var _structure_cards: Array[Control] = []
var _current_structures: Array[Dictionary] = []
var _knowledge_service: Node
var _theme_manager: Node
var _comparison_mode: bool = false


# === INITIALIZATION ===

@onready var title_label: Label = $VBox/Header/TitleLabel
@onready
@onready var clear_button: Button = $VBox/Header/ClearButton

# === PRIVATE VARIABLES ===

func _ready() -> void:
	"""Initialize comparative panel"""
	# Get autoloaded services
	if has_node("/root/KnowledgeService"):
		_knowledge_service = get_node("/root/KnowledgeService")

		if has_node("/root/UIThemeManager"):
			_theme_manager = get_node("/root/UIThemeManager")

			# Setup UI
			_setup_ui()
			_apply_theme()

			# Initially hidden
			hide()


			# === PRIVATE METHODS ===

func update_selections(selections: Array[Dictionary]) -> void:
	"""Update panel with current multi-selection data"""
	_current_structures = selections
	_comparison_mode = selections.size() > 1

	# Update title
	if title_label:
		if _comparison_mode:
			title_label.text = "Comparing %d Structures" % selections.size()
			elif selections.size() == 1:
				title_label.text = "Structure Information"
				else:
					title_label.text = "No Selection"

					# Update structure cards
					for i in range(MAX_STRUCTURES):
						if i < selections.size():
							_update_structure_card(i, selections[i])
							_show_card(i)
							else:
								_hide_card(i)

								# Update relationships if in comparison mode
								if _comparison_mode:
									_update_relationships()
									else:
										_clear_relationships()

										# Show panel if we have selections
										if selections.size() > 0:
											show()
											else:
												hide()


												## Clear all selections
func clear_all() -> void:
	"""Clear all displayed information"""
	_current_structures.clear()
	_comparison_mode = false

	for i in range(MAX_STRUCTURES):
		_hide_card(i)

		_clear_relationships()
		hide()
		comparison_cleared.emit()


		# === PRIVATE UPDATE METHODS ===

func _fix_orphaned_code():
	return card


func _fix_orphaned_code():
	for card in _structure_cards:
func _fix_orphaned_code():
	if not card:
		return

		# Get structure data from knowledge service
func _fix_orphaned_code():
	if _knowledge_service:
		# Normalize name for lookup
func _fix_orphaned_code():
	if state_indicator:
		state_indicator.color = selection_data["color"]

		# Update name
func _fix_orphaned_code():
	if name_label:
		name_label.text = structure_data.get("displayName", structure_name)
		name_label.add_theme_color_override("font_color", selection_data["color"])

		# Update focus button
func _fix_orphaned_code():
	if focus_button:
		focus_button.pressed.connect(func(): _on_focus_pressed(structure_name), CONNECT_ONE_SHOT)

		# Update content
func _fix_orphaned_code():
	if facts_label:
		facts_label.text = "📍 " + structure_data.get("shortDescription", "Loading...")

func _fix_orphaned_code():
	if functions_label:
func _fix_orphaned_code():
	if functions.size() > 0:
		functions_label.text = "🧠 " + _abbreviate_list(functions, 2)
		else:
			functions_label.text = ""

func _fix_orphaned_code():
	if clinical_label:
func _fix_orphaned_code():
	if clinical:
		clinical_label.text = "⚕️ " + _abbreviate_text(clinical, 80)
		else:
			clinical_label.text = ""


func _fix_orphaned_code():
	for i in range(max_items):
		abbreviated.append(items[i])

		return ", ".join(abbreviated) + " (+" + str(items.size() - max_items) + " more)"


func _fix_orphaned_code():
	if not card.visible:
		card.modulate.a = 0.0
		card.show()

func _fix_orphaned_code():
	if card.visible:
func _fix_orphaned_code():
	if relationships.size() > 0:
		for rel in relationships:
func _fix_orphaned_code():
	for struct in _current_structures:
		structure_names.append(_normalize_structure_name(struct["name"]).to_lower())

		# Check for system memberships
func _fix_orphaned_code():
	for system_name in systems:
func _fix_orphaned_code():
	for struct_name in structure_names:
		for system_struct in system_structures:
			if system_struct in struct_name:
				matches += 1
				break

				if matches >= 2:
					relationships.append("Both part of the " + system_name.replace("_", " "))

					return relationships


func _setup_ui() -> void:
	"""Setup UI structure"""
	# Configure header
	if title_label:
		title_label.text = "Structure Comparison"
		title_label.add_theme_font_size_override("font_size", 20)

		if clear_button:
			clear_button.text = "Clear All"
			clear_button.pressed.connect(_on_clear_pressed)
			clear_button.tooltip_text = "Clear all selections (Esc)"

			# Create structure card slots
			for i in range(MAX_STRUCTURES):
func _create_structure_card(_index: int) -> Control:
	"""Create a structure information card"""
func _apply_theme() -> void:
	"""Apply current theme settings"""
	if not _theme_manager:
		return

func _update_structure_card(index: int, selection_data: Dictionary) -> void:
	"""Update a specific structure card with data"""
func _normalize_structure_name(name: String) -> String:
	"""Normalize structure name for knowledge lookup"""
	return name.replace(" (good)", "").replace("(good)", "").strip_edges()


func _abbreviate_text(text: String, max_length: int) -> String:
	"""Abbreviate text to fit in limited space"""
	if text.length() <= max_length:
		return text
		return text.substr(0, max_length - 3) + "..."


func _abbreviate_list(items: Array, max_items: int) -> String:
	"""Convert array to abbreviated string"""
	if items.size() <= max_items:
		return ", ".join(items)

func _show_card(index: int) -> void:
	"""Show a structure card with animation"""
func _hide_card(index: int) -> void:
	"""Hide a structure card"""
func _update_relationships() -> void:
	"""Update relationship information between selected structures"""
	_clear_relationships()

	if _current_structures.size() < 2:
		return

		# Check for known relationships
func _find_relationships() -> Array[String]:
	"""Find anatomical relationships between selected structures"""
func _clear_relationships() -> void:
	"""Clear relationship display"""
	# Keep the title label
	for child in relationship_container.get_children():
		if child.text != "Anatomical Relationships:":
			child.queue_free()


			# === SIGNAL HANDLERS ===
func _on_clear_pressed() -> void:
	"""Handle clear button press"""
	clear_all()


func _on_focus_pressed(structure_name: String) -> void:
	"""Handle focus button press for a structure"""
	structure_focused.emit(structure_name)
	print("[ComparativePanel] Focus requested for: " + structure_name)
