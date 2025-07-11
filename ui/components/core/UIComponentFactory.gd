# UI Component Factory for NeuroVis
# Centralized creation and configuration of UI components

class_name UIComponentFactory
extends RefCounted

# === DEPENDENCIES ===

enum ComponentType {
PANEL,
BUTTON,
LABEL,
TEXT_INPUT,
DROPDOWN,
SLIDER,
CHECKBOX,
RADIO_GROUP,
PROGRESS_BAR,
TAB_CONTAINER,
SCROLL_CONTAINER,
INFO_PANEL,
CONTROL_PANEL,
TOOLTIP,
MODAL_DIALOG,
NOTIFICATION
}


# === COMPONENT CONFIGURATIONS ===
static func get_component_configs() -> Dictionary:

	const SafeAutoloadAccess = preload("res://ui/components/core/SafeAutoloadAccess.gd")

# === COMPONENT TYPES ===
	const STYLE_PRESETS = {
"buttons":
	{
"primary": {"color": "button_primary", "variant": "filled"},
"secondary": {"color": "button_secondary", "variant": "filled"},
"danger": {"color": "button_danger", "variant": "filled"},
"ghost": {"color": "transparent", "variant": "outlined"},
"icon": {"color": "transparent", "variant": "flat", "size": "small"}
	},
"labels":
	{
"heading": {"size": 24, "weight": "bold", "color": "text_heading"},
"subheading": {"size": 18, "weight": "semibold", "color": "text_subheading"},
"body": {"size": 14, "weight": "normal", "color": "text_body"},
"caption": {"size": 12, "weight": "normal", "color": "text_muted"},
"accent": {"size": 14, "weight": "bold", "color": "text_accent"}
	},
"panels":
	{
"default": {"style": "enhanced", "opacity": 0.9, "blur": true},
"minimal": {"style": "minimal", "opacity": 0.95, "blur": true},
"solid": {"style": "solid", "opacity": 1.0, "blur": false},
"overlay": {"style": "overlay", "opacity": 0.8, "blur": true}
	}
	}


			# === FACTORY METHODS ===
static func create_component(type: ComponentType, config: Dictionary = {}) -> Control:
	# ORPHANED REF: """Create a UI component with configuration"""

	var component_data = get_component_configs().get(type)
	# FIXED: Orphaned code - var component_class = component_data.get("class")
	# FIXED: Orphaned code - var default_config = component_data.get("default_config", {})

# Merge default config with provided config
	# ORPHANED REF: var final_config = default_config.duplicate()
	# FIXED: Orphaned code - var component = component_class.new()

# Apply configuration
	# ORPHANED REF: _apply_component_config(component, final_config, type)

	# FIXED: Orphaned code - var panel_config = {"theme_variant": style}
	# ORPHANED REF: panel_config.merge(config)

	# FIXED: Orphaned code - var panel = create_component(ComponentType.PANEL, panel_config) as PanelContainer
	var button_config = {"text": text, "style": style}
	button_config.merge(config)

	# FIXED: Orphaned code - var button = create_component(ComponentType.BUTTON, button_config) as Button
	var label_config = {"text": text, "style": style}
	label_config.merge(config)

	# FIXED: Orphaned code - var label = create_component(ComponentType.LABEL, label_config) as Label
	var input_config = {"placeholder": placeholder}
	input_config.merge(config)

	# FIXED: Orphaned code - var input = create_component(ComponentType.TEXT_INPUT, input_config) as LineEdit
	var dropdown_config = {"options": options}
	dropdown_config.merge(config)

	# FIXED: Orphaned code - var dropdown = create_component(ComponentType.DROPDOWN, dropdown_config) as OptionButton
	var slider_config = {"min_value": min_val, "max_value": max_val, "value": initial_val}
	slider_config.merge(config)

	# FIXED: Orphaned code - var slider = create_component(ComponentType.SLIDER, slider_config) as HSlider
	var checkbox_config = {"text": text, "checked": checked}
	checkbox_config.merge(config)

	# FIXED: Orphaned code - var checkbox = create_component(ComponentType.CHECKBOX, checkbox_config) as CheckBox
	var progress_config = {"max_value": max_val}
	progress_config.merge(config)

	# FIXED: Orphaned code - var progress = create_component(ComponentType.PROGRESS_BAR, progress_config) as ProgressBar
	var panel_2 = create_panel("default", {"padding": 20})

# Add title bar
	var title_bar = HBoxContainer.new()
	# FIXED: Orphaned code - var title = create_label(config.get("title", "Information"), "heading")
	# FIXED: Orphaned code - var close_btn = create_button("✕", "icon", {"custom_minimum_size": Vector2(32, 32)})

	# ORPHANED REF: title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# ORPHANED REF: title_bar.add_child(title)
	# ORPHANED REF: title_bar.add_child(close_btn)

	# Add content area
	var content_scroll = ScrollContainer.new()
	content_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED

	var content_container = VBoxContainer.new()
	content_scroll.add_child(content_container)

	# Add separator
	var separator = HSeparator.new()

# Assemble panel
	var main_container = VBoxContainer.new()
	main_container.add_child(title_bar)
	main_container.add_child(separator)
	main_container.add_child(content_scroll)
	# ORPHANED REF: panel.add_child(main_container)

	# Store references for easy access
	# ORPHANED REF: panel.set_meta("title_label", title)
	# ORPHANED REF: panel.set_meta("close_button", close_btn)
	# ORPHANED REF: panel.set_meta("content_container", content_container)

	# FIXED: Orphaned code - var panel_3 = create_panel("default")
	# FIXED: Orphaned code - var main_container_2 = VBoxContainer.new()

# Title
	# ORPHANED REF: var title_2 = create_label(config.title, "heading")
	# ORPHANED REF: main_container.add_child(title)
	main_container.add_child(HSeparator.new())

	# Sections
	var sections = config.get("sections", [])
	# FIXED: Orphaned code - var section = _create_control_section(section_config)
	# ORPHANED REF: main_container.add_child(section)

	# ORPHANED REF: panel.add_child(main_container)
	# FIXED: Orphaned code - var form_panel = create_panel("default")
	# FIXED: Orphaned code - var form_container = VBoxContainer.new()

# Title
	# ORPHANED REF: var title_3 = create_label(config.title, "heading")
	# ORPHANED REF: form_container.add_child(title)
	# ORPHANED REF: form_container.add_child(HSeparator.new())

	# Fields
	var field_row = _create_form_field(field_config)
	# ORPHANED REF: form_container.add_child(field_row)

	# Actions
	var actions_row = HBoxContainer.new()
	actions_row.alignment = BoxContainer.ALIGNMENT_END

	var button_2 = create_button(action.get("text", "Action"), action.get("style", "primary"))
	# ORPHANED REF: actions_row.add_child(button)

	# ORPHANED REF: form_container.add_child(actions_row)

	# ORPHANED REF: form_panel.add_child(form_container)
	# FIXED: Orphaned code - var themed = SafeAutoloadAccess.apply_theme_safely(button, "button")
	# FIXED: Orphaned code - var themed_2 = SafeAutoloadAccess.apply_theme_safely(label, "label")
	# FIXED: Orphaned code - var themed_3 = SafeAutoloadAccess.apply_theme_safely(panel, "panel")
	# FIXED: Orphaned code - var themed_4 = SafeAutoloadAccess.apply_theme_safely(input, "button")
	# FIXED: Orphaned code - var themed_5 = SafeAutoloadAccess.apply_theme_safely(progress, "button")
	# FIXED: Orphaned code - var section_2 = VBoxContainer.new()

# Section title
	# ORPHANED REF: var title_4 = create_label(section_config.title, "subheading")
	# ORPHANED REF: section.add_child(title)

	# Section content
	var content = section_config.get("content", [])
	# FIXED: Orphaned code - var item = _create_control_item(item_config)
	# ORPHANED REF: section.add_child(item)

	# FIXED: Orphaned code - var item_type = item_config.get("type", "button")
	# FIXED: Orphaned code - var item_data = item_config.get("config", {})

	# ORPHANED REF: "button":
	var container = HBoxContainer.new()
	# FIXED: Orphaned code - var label_2 = create_label(item_config.get("label", "Value:"))
	# FIXED: Orphaned code - var slider_2 = create_slider(
	# ORPHANED REF: item_data.get("min", 0), item_data.get("max", 1), item_data.get("value", 0.5)
	)
	# ORPHANED REF: container.add_child(label)
	# ORPHANED REF: container.add_child(slider)
	# FIXED: Orphaned code - var field_container = VBoxContainer.new()

# Field label
	# ORPHANED REF: var label_3 = create_label(field_config.label, "body")
	# ORPHANED REF: field_container.add_child(label)

	# Field input
	var field_type = field_config.get("type", "text")
	# FIXED: Orphaned code - var field_input: Control

"text":
	# ORPHANED REF: field_input = create_text_input(field_config.get("placeholder", ""))
"password":
	# ORPHANED REF: field_input = create_text_input(field_config.get("placeholder", ""), {"secure": true})
	# ORPHANED REF: "dropdown":
	# ORPHANED REF: field_input = create_dropdown(field_config.get("options", []))
	# ORPHANED REF: "checkbox":
	# ORPHANED REF: field_input = create_checkbox(
	field_config.get("text", ""), field_config.get("checked", false)
	)
	# ORPHANED REF: "slider":
	# ORPHANED REF: field_input = create_slider(
	field_config.get("min", 0),
	field_config.get("max", 1),
	field_config.get("value", 0.5)
	)
_:
	# ORPHANED REF: field_input = create_label("Unknown field type: " + field_type)

	# ORPHANED REF: field_container.add_child(field_input)

						# Field help text
	var help = create_label(field_config.help, "caption")
	# ORPHANED REF: field_container.add_child(help)

	# FIXED: Orphaned code - var base_component = create_component(type, config)

	# FIXED: Orphaned code - var _style = config.get("style", "primary")

# Apply theming safely
	var _style_2 = config.get("style", "body")

# Apply theming safely
	var _style_variant = config.get("theme_variant", "default")

# Apply theming safely

	return {
	ComponentType.PANEL:
	{
"class": PanelContainer,
	# ORPHANED REF: "default_config": {"theme_variant": "default", "padding": 16, "background_opacity": 0.9}
	},
	ComponentType.BUTTON:
	{
"class": Button,
	# ORPHANED REF: "default_config": {"style": "primary", "min_height": 32, "text_size": 14}
	},
	ComponentType.LABEL:
	# ORPHANED REF: {"class": Label, "default_config": {"style": "body", "color": "text_primary", "size": 14}},
	ComponentType.TEXT_INPUT:
	{
"class": LineEdit,
	# ORPHANED REF: "default_config": {"placeholder": "", "max_length": 0, "secure": false}
	},
	ComponentType.DROPDOWN:
	# ORPHANED REF: {"class": OptionButton, "default_config": {"selected": -1, "options": []}},
	ComponentType.SLIDER:
	{
"class": HSlider,
	# ORPHANED REF: "default_config": {"min_value": 0.0, "max_value": 1.0, "step": 0.1, "value": 0.5}
	},
	ComponentType.CHECKBOX:
	# ORPHANED REF: {"class": CheckBox, "default_config": {"checked": false, "text": ""}},
	ComponentType.PROGRESS_BAR:
	{
"class": ProgressBar,
	# ORPHANED REF: "default_config":
	{"min_value": 0.0, "max_value": 100.0, "value": 0.0, "show_percentage": true}
	},
	ComponentType.SCROLL_CONTAINER:
	{
"class": ScrollContainer,
	# ORPHANED REF: "default_config": {"horizontal_scroll": false, "vertical_scroll": true}
	}
	}


										# === STYLE PRESETS ===

	if not component_data:
	# ORPHANED REF: push_error("Unknown component type: " + str(type))
	return null

	for key in config:
	final_config[key] = config[key]

	# Create component instance
	# ORPHANED REF: return component


static func create_panel(style: String = "default", config: Dictionary = {}) -> PanelContainer:
	# ORPHANED REF: """Create a styled panel"""
	# ORPHANED REF: return panel


	static func create_button(
text: String, style: String = "primary", config: Dictionary = {}
	) -> Button:
	# ORPHANED REF: """Create a styled button"""
	# ORPHANED REF: return button


static func create_label(text: String, style: String = "body", config: Dictionary = {}) -> Label:
	# ORPHANED REF: """Create a styled label"""
	# ORPHANED REF: return label


static func create_text_input(placeholder: String = "", config: Dictionary = {}) -> LineEdit:
	# ORPHANED REF: """Create a styled text input"""
	# ORPHANED REF: return input


static func create_dropdown(options: Array, config: Dictionary = {}) -> OptionButton:
	# ORPHANED REF: """Create a styled dropdown"""
	# ORPHANED REF: return dropdown


	static func create_slider(
min_val: float, max_val: float, initial_val: float = 0.0, config: Dictionary = {}
	) -> HSlider:
	# ORPHANED REF: """Create a styled slider"""
	# ORPHANED REF: return slider


	static func create_checkbox(
text: String, checked: bool = false, config: Dictionary = {}
	) -> CheckBox:
	# ORPHANED REF: """Create a styled checkbox"""
	# ORPHANED REF: return checkbox


static func create_progress_bar(max_val: float = 100.0, config: Dictionary = {}) -> ProgressBar:
	# ORPHANED REF: """Create a styled progress bar"""
	# ORPHANED REF: return progress


# === COMPLEX COMPONENT FACTORIES ===
static func create_info_panel(config: Dictionary = {}) -> Control:
	# ORPHANED REF: """Create a complete information panel"""
	# ORPHANED REF: return panel


static func create_control_panel(config: Dictionary = {}) -> Control:
	# ORPHANED REF: """Create a control panel with sections"""
	# ORPHANED REF: if config.has("title"):
	for section_config in sections:
	# ORPHANED REF: return panel


static func create_form(fields: Array, config: Dictionary = {}) -> Control:
	"""Create a form with specified fields"""
	# ORPHANED REF: if config.has("title"):
	for field_config in fields:
	if config.has("actions"):
	for action in config.actions:
	# ORPHANED REF: return form_panel


# === HELPER METHODS ===
	static func _apply_component_config(
	# ORPHANED REF: component: Control, config: Dictionary, type: ComponentType
	) -> void:
	# ORPHANED REF: """Apply configuration to component"""
	match type:
		ComponentType.BUTTON:
	# ORPHANED REF: _configure_button(component as Button, config)
		ComponentType.LABEL:
	# ORPHANED REF: _configure_label(component as Label, config)
		ComponentType.PANEL:
	# ORPHANED REF: _configure_panel(component as PanelContainer, config)
		ComponentType.TEXT_INPUT:
	# ORPHANED REF: _configure_text_input(component as LineEdit, config)
		ComponentType.DROPDOWN:
	# ORPHANED REF: _configure_dropdown(component as OptionButton, config)
		ComponentType.SLIDER:
	# ORPHANED REF: _configure_slider(component as HSlider, config)
		ComponentType.CHECKBOX:
	# ORPHANED REF: _configure_checkbox(component as CheckBox, config)
		ComponentType.PROGRESS_BAR:
	# ORPHANED REF: _configure_progress_bar(component as ProgressBar, config)


	# ORPHANED REF: static func _configure_button(button: Button, config: Dictionary) -> void:
	# ORPHANED REF: """Configure button component safely"""
	# ORPHANED REF: if not button:
	return

	if config.has("text"):
	# ORPHANED REF: button.text = config.text

	# ORPHANED REF: if not themed:
	# ORPHANED REF: _log_factory_warning("Button theming unavailable, using fallback for: " + button.text)

	if config.has("min_height"):
	# ORPHANED REF: button.custom_minimum_size.y = config.min_height


		# === LOGGING HELPER ===
static func _log_factory_warning(message: String) -> void:
	"""Log factory warnings"""
	print("[UIComponentFactory] Warning: " + message)


	# ORPHANED REF: static func _configure_label(label: Label, config: Dictionary) -> void:
	# ORPHANED REF: """Configure label component safely"""
	# ORPHANED REF: if not label:
	return

	if config.has("text"):
	# ORPHANED REF: label.text = config.text

	# ORPHANED REF: if not themed:
	# ORPHANED REF: _log_factory_warning("Label theming unavailable, using fallback for: " + label.text)


	# ORPHANED REF: static func _configure_panel(panel: PanelContainer, config: Dictionary) -> void:
	# ORPHANED REF: """Configure panel component safely"""
	# ORPHANED REF: if not panel:
	return

	# ORPHANED REF: if not themed:
	_log_factory_warning("Panel theming unavailable, using fallback")


	# ORPHANED REF: static func _configure_text_input(input: LineEdit, config: Dictionary) -> void:
	# ORPHANED REF: """Configure text input component"""
	if config.has("placeholder"):
	# ORPHANED REF: input.placeholder_text = config.placeholder

	if config.has("max_length"):
	# ORPHANED REF: input.max_length = config.max_length

	if config.has("secure"):
	# ORPHANED REF: input.secret = config.secure

					# Apply safe theming (text input uses button theming)
	# ORPHANED REF: if not themed:
	# ORPHANED REF: _log_factory_warning("Text input theming unavailable, using fallback")


	# ORPHANED REF: static func _configure_dropdown(dropdown: OptionButton, config: Dictionary) -> void:
	# ORPHANED REF: """Configure dropdown component"""
	if config.has("options"):
	# ORPHANED REF: dropdown.clear()
	for option in config.options:
	if option is String:
	# ORPHANED REF: dropdown.add_item(option)
	elif option is Dictionary and option.has("text"):
	# ORPHANED REF: dropdown.add_item(option.text)

	if config.has("selected") and config.selected >= 0:
	# ORPHANED REF: dropdown.selected = config.selected


	# ORPHANED REF: static func _configure_slider(slider: HSlider, config: Dictionary) -> void:
	# ORPHANED REF: """Configure slider component"""
	# ORPHANED REF: slider.min_value = config.get("min_value", 0.0)
	# ORPHANED REF: slider.max_value = config.get("max_value", 1.0)
	# ORPHANED REF: slider.step = config.get("step", 0.1)
	# ORPHANED REF: slider.value = config.get("value", 0.5)


	# ORPHANED REF: static func _configure_checkbox(checkbox: CheckBox, config: Dictionary) -> void:
	# ORPHANED REF: """Configure checkbox component"""
	if config.has("text"):
	# ORPHANED REF: checkbox.text = config.text

	# ORPHANED REF: checkbox.button_pressed = config.get("checked", false)


	# ORPHANED REF: static func _configure_progress_bar(progress: ProgressBar, config: Dictionary) -> void:
	# ORPHANED REF: """Configure progress bar component safely"""
	# ORPHANED REF: if not progress:
	return

	# ORPHANED REF: progress.min_value = config.get("min_value", 0.0)
	# ORPHANED REF: progress.max_value = config.get("max_value", 100.0)
	# ORPHANED REF: progress.value = config.get("value", 0.0)

												# Apply safe theming
	# ORPHANED REF: if not themed:
	_log_factory_warning("Progress bar theming unavailable, using fallback")


static func _create_control_section(section_config: Dictionary) -> Control:
	# ORPHANED REF: """Create a control section"""
	# ORPHANED REF: if section_config.has("title"):
	for item_config in content:
	# ORPHANED REF: return section


static func _create_control_item(item_config: Dictionary) -> Control:
	# ORPHANED REF: """Create a control item"""
	return create_button(
	# ORPHANED REF: item_config.get("text", "Button"), item_config.get("style", "primary"), item_data
	)
	# ORPHANED REF: "slider":
	return container
	# ORPHANED REF: "checkbox":
	return create_checkbox(
	item_config.get("text", "Option"), item_config.get("checked", false)
	)
_:
	# ORPHANED REF: return create_label("Unknown control type: " + item_type)


static func _create_form_field(field_config: Dictionary) -> Control:
	"""Create a form field"""
	# ORPHANED REF: if field_config.has("label"):
	if field_config.has("help"):
	# ORPHANED REF: return field_container


# === UTILITY METHODS ===
static func get_component_types() -> Array:
	# ORPHANED REF: """Get all available component types"""
	return ComponentType.values()


static func get_style_presets(component_type: String) -> Dictionary:
	# ORPHANED REF: """Get style presets for component type"""
	return STYLE_PRESETS.get(component_type, {})


static func create_responsive_component(type: ComponentType, config: Dictionary = {}) -> Control:
	# ORPHANED REF: """Create a responsive component - temporarily simplified"""
			# TODO: Re-enable ResponsiveComponent once parsing issues are resolved
			# For now, just return the base component
	# ORPHANED REF: return base_component
