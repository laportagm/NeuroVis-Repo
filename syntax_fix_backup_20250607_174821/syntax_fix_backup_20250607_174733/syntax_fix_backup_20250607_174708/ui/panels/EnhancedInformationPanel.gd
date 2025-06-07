## EnhancedInformationPanel.gd
## Primary educational information display panel for brain structure learning
##
## This panel provides the main interface for displaying anatomical information
## about brain structures in an educational context. It follows modern UI design
## principles with glassmorphism effects and responsive layouts while maintaining
## educational accessibility standards for diverse learners.
##
## Educational Learning Objectives:
## - Present anatomical information in a clear, hierarchical manner
## - Support progressive disclosure of complex medical information
## - Enable interactive learning through collapsible sections
## - Maintain accessibility for students with diverse needs
## - Track learning engagement through interaction analytics
##
## @tutorial: Educational UI Patterns
## @tutorial: Accessibility in Medical Education
## @version: 2.0

class_name EnhancedInformationPanel
extends PanelContainer

# === DEPENDENCIES ===

signal panel_closed
signal section_toggled(section_name: String, expanded: bool)
signal bookmark_toggled(structure_id: String, bookmarked: bool)

# === CORE COMPONENTS ===

const UIThemeManager = preprepreprepreload("res://ui/panels/UIThemeManager.gd")

# === SIGNALS ===

var header_container: HBoxContainer
var content_container: VBoxContainer
var scroll_container: ScrollContainer

# Header elements
var structure_name_label: Label
var action_buttons_container: HBoxContainer
var bookmark_button: Button
var share_button: Button
var close_button: Button

# Content sections
var description_section: VBoxContainer
var functions_section: VBoxContainer
var connections_section: VBoxContainer
var clinical_notes_section: VBoxContainer

# Section headers (for collapsible functionality)
var description_header: Button
var functions_header: Button
var connections_header: Button
var clinical_header: Button

# Content areas
var description_text: RichTextLabel
var functions_list: VBoxContainer
var connections_list: VBoxContainer
var clinical_text: RichTextLabel

# === STATE MANAGEMENT ===
var current_structure: Dictionary = {}
var panel_is_visible: bool = false
var section_states: Dictionary = {
	"description": true, "functions": true, "connections": false, "clinical": false  # Always expanded  # Default expanded  # Default collapsed  # Default collapsed
	}

	# === RESPONSIVE DATA ===
var viewport_size: Vector2
var is_mobile_layout: bool = false


var desc_header_label = Label.new()
	desc_header_label.text = "DESCRIPTION"
	UIThemeManager.apply_enhanced_typography(desc_header_label, "subheading")
	description_section.add_child(desc_header_label)

	# Description text
	description_text = RichTextLabel.new()
	description_text.bbcode_enabled = true
	description_text.fit_content = true
	description_text.scroll_active = false
	description_text.custom_minimum_size = Vector2(0, 100)
	description_text.text = "Description text will appear here when a structure is selected."
	UIThemeManager.apply_enhanced_typography(description_text, "body")
	description_section.add_child(description_text)


var focused = get_viewport().gui_get_focus_owner()
var mobile_padding = UIThemeManager.get_spacing("md")
	scroll_container.add_theme_constant_override("margin_left", mobile_padding)
	scroll_container.add_theme_constant_override("margin_right", mobile_padding)
	scroll_container.add_theme_constant_override("margin_top", mobile_padding)
	scroll_container.add_theme_constant_override("margin_bottom", mobile_padding)

	# Smaller button sizes
var mobile_button_size = Vector2(32, 32)
	bookmark_button.custom_minimum_size = mobile_button_size
	share_button.custom_minimum_size = mobile_button_size
	close_button.custom_minimum_size = mobile_button_size


	# === PUBLIC INTERFACE ===
var structure_name = structure_data.get(
	"displayName", structure_data.get("name", "Unknown Structure")
	)
	structure_name_label.text = structure_name

	# Update description
var description = structure_data.get(
	"shortDescription", structure_data.get("description", "No description available.")
	)
	description_text.text = "[font_size=14]" + description + "[/font_size]"

	# Update functions
	_update_functions_list(structure_data.get("functions", []))

	# Update connections (if available)
	_update_connections_list(structure_data.get("connections", []))

	# Update clinical notes (if available)
var clinical_notes = structure_data.get("clinicalNotes", structure_data.get("notes", ""))
var function_item = Label.new()
	function_item.text = "• " + str(function_text)
	function_item.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UIThemeManager.apply_enhanced_typography(function_item, "small")
	functions_list.add_child(function_item)
	else:
		functions_header.text = ("▼" if section_states.functions else "▶") + " FUNCTIONS (0)"

var no_functions_label = Label.new()
	no_functions_label.text = "No functions listed for this structure."
	UIThemeManager.apply_enhanced_typography(no_functions_label, "small")
	functions_list.add_child(no_functions_label)


var connection_item = Button.new()
	connection_item.text = "→ " + str(connection)
	connection_item.alignment = HORIZONTAL_ALIGNMENT_LEFT
	connection_item.flat = true
	UIThemeManager.apply_enhanced_typography(connection_item, "small")
	UIThemeManager.add_hover_effect(connection_item)
	connections_list.add_child(connection_item)
	else:
		connections_header.text = ("▼" if section_states.connections else "▶") + " CONNECTIONS (0)"


var was_expanded = section_states.get(section_name, false)
var new_state = not was_expanded
	section_states[section_name] = new_state

var content_node: Control
var header_button: Button

match section_name:
	"functions":
		content_node = functions_list
		header_button = functions_header
		"connections":
			content_node = connections_list
			header_button = connections_header
			"clinical":
				content_node = clinical_text
				header_button = clinical_header
				_:
					return

					# Update header text
var arrow = "▼" if new_state else "▶"
var base_text = header_button.text.split(" ", false, 1)
var tween = create_tween()
	tween.tween_property(
	content_node,
	"modulate",
	Color.WHITE,
	UIThemeManager.get_animation_duration("content_fade_duration")
	)
	else:
var tween = create_tween()
	tween.tween_property(
	content_node,
	"modulate",
	Color.TRANSPARENT,
	UIThemeManager.get_animation_duration("content_fade_duration")
	)
	tween.tween_callback(func(): content_node.visible = false)

	# Emit signal
	section_toggled.emit(section_name, new_state)


	# === EVENT HANDLERS ===
var structure_id = current_structure.get("id", "")
var structure_name = current_structure.get("displayName", "structure")

func _ready() -> void:
	_setup_panel_structure()
	_apply_enhanced_styling()
	_setup_interactions()
	_setup_responsive_behavior()
	visible = false


func display_structure_info(structure_data: Dictionary) -> void:
	"""Display information for a brain structure"""

	current_structure = structure_data

	# Update structure name
func show_panel() -> void:
	"""Show panel with enhanced animation"""

	if panel_is_visible:
		return

		panel_is_visible = true
		visible = true

		# Apply entrance animation
		UIThemeManager.animate_enhanced_entrance(self, 0.0)


func hide_panel() -> void:
	"""Hide panel with enhanced animation"""

	if not panel_is_visible:
		return

		panel_is_visible = false

		# Apply exit animation
		UIThemeManager.animate_exit(self, UIThemeManager.get_animation_duration("exit_duration"))


func focus_close_button() -> void:
	"""Focus the close button (for accessibility)"""
	close_button.grab_focus()


func get_current_structure_id() -> String:
	"""Get the current structure ID"""
	return current_structure.get("id", "")


func is_section_expanded(section_name: String) -> bool:
	"""Check if a section is currently expanded"""
	return section_states.get(section_name, false)

func _fix_orphaned_code():
	if focused == functions_header:
		_toggle_section("functions")
		get_viewport().set_input_as_handled()
		elif focused == connections_header:
			_toggle_section("connections")
			get_viewport().set_input_as_handled()
			elif focused == clinical_header:
				_toggle_section("clinical")
				get_viewport().set_input_as_handled()


func _fix_orphaned_code():
	if clinical_notes != "":
		clinical_text.text = "[font_size=14]" + clinical_notes + "[/font_size]"
		clinical_notes_section.visible = true
		else:
			clinical_notes_section.visible = false

			# Show panel with animation
			show_panel()


func _fix_orphaned_code():
	if base_text.size() > 1:
		header_button.text = arrow + " " + base_text[1]

		# Animate content visibility
		if new_state:
			content_node.visible = true
			content_node.modulate = Color.TRANSPARENT
func _fix_orphaned_code():
	if structure_id != "":
		# Toggle bookmark state (implement bookmark logic)
		bookmark_toggled.emit(structure_id, true)
		print("[EnhancedInfoPanel] Bookmarked structure: ", structure_id)


func _fix_orphaned_code():
	print("[EnhancedInfoPanel] Share requested for: ", structure_name)
	# Implement share functionality


func _setup_panel_structure() -> void:
	"""Create the enhanced panel structure following Figma specs for educational UI"""

	# Apply enhanced panel styling
	UIThemeManager.apply_enhanced_panel_style(self, "default")

	# Main scroll container for content
	scroll_container = ScrollContainer.new()
	scroll_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll_container.add_theme_constant_override(
	"margin_left", UIThemeManager.get_spacing("enhanced_panel_padding")
	)
	scroll_container.add_theme_constant_override(
	"margin_right", UIThemeManager.get_spacing("enhanced_panel_padding")
	)
	scroll_container.add_theme_constant_override(
	"margin_top", UIThemeManager.get_spacing("enhanced_panel_padding")
	)
	scroll_container.add_theme_constant_override(
	"margin_bottom", UIThemeManager.get_spacing("enhanced_panel_padding")
	)
	add_child(scroll_container)

	# Main content container
	content_container = VBoxContainer.new()
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_container.add_theme_constant_override(
	"separation", UIThemeManager.get_spacing("enhanced_section_gap")
	)
	scroll_container.add_child(content_container)

	_create_header_section()
	_create_content_sections()


func _create_header_section() -> void:
	"""Create header with structure name and action buttons"""

	header_container = HBoxContainer.new()
	header_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_container.custom_minimum_size.y = 48  # From Figma spec
	content_container.add_child(header_container)

	# Structure name label
	structure_name_label = Label.new()
	structure_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	structure_name_label.text = "Structure Name"
	structure_name_label.clip_contents = true  # For text truncation
	UIThemeManager.apply_enhanced_typography(structure_name_label, "heading")
	header_container.add_child(structure_name_label)

	# Action buttons container
	action_buttons_container = HBoxContainer.new()
	action_buttons_container.add_theme_constant_override(
	"separation", UIThemeManager.get_spacing("enhanced_inline_gap")
	)
	header_container.add_child(action_buttons_container)

	# Bookmark button
	bookmark_button = Button.new()
	bookmark_button.text = "⭐"
	bookmark_button.custom_minimum_size = Vector2(36, 36)
	bookmark_button.tooltip_text = "Bookmark this structure"
	UIThemeManager.apply_enhanced_button_style(bookmark_button, "secondary")
	action_buttons_container.add_child(bookmark_button)

	# Share button
	share_button = Button.new()
	share_button.text = "📤"
	share_button.custom_minimum_size = Vector2(36, 36)
	share_button.tooltip_text = "Share structure information"
	UIThemeManager.apply_enhanced_button_style(share_button, "secondary")
	action_buttons_container.add_child(share_button)

	# Close button
	close_button = Button.new()
	close_button.text = "×"
	close_button.custom_minimum_size = Vector2(36, 36)
	close_button.tooltip_text = "Close panel"
	UIThemeManager.apply_enhanced_button_style(close_button, "danger")
	action_buttons_container.add_child(close_button)


func _create_content_sections() -> void:
	"""Create all content sections with proper hierarchy"""

	# Description section (always visible, non-collapsible)
	_create_description_section()

	# Functions section (collapsible, default expanded)
	_create_functions_section()

	# Connections section (collapsible, default collapsed)
	_create_connections_section()

	# Clinical notes section (collapsible, default collapsed)
	_create_clinical_notes_section()


func _create_description_section() -> void:
	"""Create description section"""

	description_section = VBoxContainer.new()
	description_section.add_theme_constant_override(
	"separation", UIThemeManager.get_spacing("enhanced_item_gap")
	)
	content_container.add_child(description_section)

	# Section header (non-interactive for description)
func _create_functions_section() -> void:
	"""Create collapsible functions section"""

	functions_section = VBoxContainer.new()
	functions_section.add_theme_constant_override(
	"separation", UIThemeManager.get_spacing("enhanced_item_gap")
	)
	content_container.add_child(functions_section)

	# Collapsible header
	functions_header = Button.new()
	functions_header.text = "▼ FUNCTIONS"
	functions_header.alignment = HORIZONTAL_ALIGNMENT_LEFT
	functions_header.flat = true
	UIThemeManager.apply_enhanced_typography(functions_header, "subheading")
	functions_section.add_child(functions_header)

	# Functions list container
	functions_list = VBoxContainer.new()
	functions_list.add_theme_constant_override(
	"separation", UIThemeManager.get_spacing("enhanced_inline_gap")
	)
	functions_section.add_child(functions_list)


func _create_connections_section() -> void:
	"""Create collapsible connections section"""

	connections_section = VBoxContainer.new()
	connections_section.add_theme_constant_override(
	"separation", UIThemeManager.get_spacing("enhanced_item_gap")
	)
	content_container.add_child(connections_section)

	# Collapsible header
	connections_header = Button.new()
	connections_header.text = "▶ CONNECTIONS"
	connections_header.alignment = HORIZONTAL_ALIGNMENT_LEFT
	connections_header.flat = true
	UIThemeManager.apply_enhanced_typography(connections_header, "subheading")
	connections_section.add_child(connections_header)

	# Connections list container
	connections_list = VBoxContainer.new()
	connections_list.add_theme_constant_override(
	"separation", UIThemeManager.get_spacing("enhanced_inline_gap")
	)
	connections_list.visible = false  # Default collapsed
	connections_section.add_child(connections_list)


func _create_clinical_notes_section() -> void:
	"""Create collapsible clinical notes section"""

	clinical_notes_section = VBoxContainer.new()
	clinical_notes_section.add_theme_constant_override(
	"separation", UIThemeManager.get_spacing("enhanced_item_gap")
	)
	content_container.add_child(clinical_notes_section)

	# Collapsible header
	clinical_header = Button.new()
	clinical_header.text = "▶ CLINICAL NOTES"
	clinical_header.alignment = HORIZONTAL_ALIGNMENT_LEFT
	clinical_header.flat = true
	UIThemeManager.apply_enhanced_typography(clinical_header, "subheading")
	clinical_notes_section.add_child(clinical_header)

	# Clinical notes text
	clinical_text = RichTextLabel.new()
	clinical_text.bbcode_enabled = true
	clinical_text.fit_content = true
	clinical_text.scroll_active = false
	clinical_text.custom_minimum_size = Vector2(0, 80)
	clinical_text.visible = false  # Default collapsed
	UIThemeManager.apply_enhanced_typography(clinical_text, "body")
	clinical_notes_section.add_child(clinical_text)


func _apply_enhanced_styling() -> void:
	"""Apply enhanced styling throughout the panel"""

	# Set minimum sizes based on Figma specs
	custom_minimum_size = Vector2(320, 400)  # Minimum from design spec

	# Apply hover effects to interactive elements
	UIThemeManager.add_hover_effect(bookmark_button)
	UIThemeManager.add_hover_effect(share_button)
	UIThemeManager.add_hover_effect(close_button)
	UIThemeManager.add_hover_effect(functions_header)
	UIThemeManager.add_hover_effect(connections_header)
	UIThemeManager.add_hover_effect(clinical_header)


func _setup_interactions() -> void:
	"""Setup all button interactions and signals"""

	# Header button connections
	close_button.pressed.connect(_on_close_button_pressed)
	bookmark_button.pressed.connect(_on_bookmark_button_pressed)
	share_button.pressed.connect(_on_share_button_pressed)

	# Section toggle connections
	functions_header.pressed.connect(func(): _toggle_section("functions"))
	connections_header.pressed.connect(func(): _toggle_section("connections"))
	clinical_header.pressed.connect(func(): _toggle_section("clinical"))

	# Setup accessibility features
	_setup_accessibility()


func _setup_responsive_behavior() -> void:
	"""Setup responsive behavior for different screen sizes"""

	# Get initial viewport size
	viewport_size = get_viewport().get_visible_rect().size
	_update_responsive_layout()

	# Connect to viewport size changes
	get_viewport().size_changed.connect(_on_viewport_size_changed)


func _setup_accessibility() -> void:
	"""Setup accessibility features for keyboard navigation and screen readers"""

	# Set focus order for keyboard navigation
	if close_button and share_button:
		close_button.focus_neighbor_left = share_button.get_path()
		if share_button and bookmark_button:
			share_button.focus_neighbor_left = bookmark_button.get_path()
			if bookmark_button and share_button:
				bookmark_button.focus_neighbor_right = share_button.get_path()
				if share_button and close_button:
					share_button.focus_neighbor_right = close_button.get_path()

					# Section headers in tab order (using Godot 4.x property names)
					if close_button and functions_header:
						close_button.focus_neighbor_bottom = functions_header.get_path()
						if functions_header and connections_header:
							functions_header.focus_neighbor_bottom = connections_header.get_path()
							if connections_header and clinical_header:
								connections_header.focus_neighbor_bottom = clinical_header.get_path()

								# Set up keyboard shortcuts
								set_process_unhandled_key_input(true)

								# Add accessibility labels
								close_button.add_theme_color_override(
								"font_focus_color", UIThemeManager.get_color("text_heading")
								)
								bookmark_button.add_theme_color_override(
								"font_focus_color", UIThemeManager.get_color("text_heading")
								)
								share_button.add_theme_color_override(
								"font_focus_color", UIThemeManager.get_color("text_heading")
								)

								# Set accessible names for screen readers
								if structure_name_label:
									structure_name_label.add_theme_color_override("font_outline_color", Color.BLACK)
									structure_name_label.add_theme_constant_override("outline_size", 1)


func _unhandled_key_input(event: InputEvent) -> void:
	"""Handle keyboard shortcuts for accessibility"""

	if not panel_is_visible:
		return

		if event is InputEventKey and event.pressed:
			match event.keycode:
				KEY_ESCAPE:
					# Close panel with Escape key
					hide_panel()
					get_viewport().set_input_as_handled()
					KEY_B:
						# Bookmark with B key (Cmd+B handled separately)
						if event.meta_pressed or event.ctrl_pressed:
							_on_bookmark_button_pressed()
							get_viewport().set_input_as_handled()
							KEY_SPACE:
								# Expand/collapse focused section with Space
func _update_responsive_layout() -> void:
	"""Update layout based on current viewport size"""

	viewport_size = get_viewport().get_visible_rect().size
	is_mobile_layout = viewport_size.x <= 768

	# Apply responsive panel sizing
	UIThemeManager.apply_responsive_panel_sizing(self, viewport_size)

	# Adjust content for mobile
	if is_mobile_layout:
		# Reduce padding on mobile
func _update_functions_list(functions: Array) -> void:
	"""Update the functions list display"""

	# Clear existing functions
	for child in functions_list.get_children():
		child.queue_free()

		# Add new functions
		if functions.size() > 0:
			# Update header with count
			functions_header.text = (
			("▼" if section_states.functions else "▶")
			+ " FUNCTIONS ("
			+ str(functions.size())
			+ ")"
			)

			for function_text in functions:
func _update_connections_list(connections: Array) -> void:
	"""Update the connections list display"""

	# Clear existing connections
	for child in connections_list.get_children():
		child.queue_free()

		# Add new connections
		if connections.size() > 0:
			connections_header.text = (
			("▼" if section_states.connections else "▶")
			+ " CONNECTIONS ("
			+ str(connections.size())
			+ ")"
			)

			for connection in connections:
func _toggle_section(section_name: String) -> void:
	"""Toggle visibility of a collapsible section"""

func _on_close_button_pressed() -> void:
	hide_panel()
	panel_closed.emit()


func _on_bookmark_button_pressed() -> void:
func _on_share_button_pressed() -> void:
func _on_viewport_size_changed() -> void:
	_update_responsive_layout()


	# === ACCESSIBILITY HELPERS ===
