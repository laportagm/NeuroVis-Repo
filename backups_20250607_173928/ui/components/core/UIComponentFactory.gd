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
	return {
		ComponentType.PANEL:
		{
			"class": PanelContainer,
			"default_config": {"theme_variant": "default", "padding": 16, "background_opacity": 0.9}
		},
		ComponentType.BUTTON:
		{
			"class": Button,
			"default_config": {"style": "primary", "min_height": 32, "text_size": 14}
		},
		ComponentType.LABEL:
		{"class": Label, "default_config": {"style": "body", "color": "text_primary", "size": 14}},
		ComponentType.TEXT_INPUT:
		{
			"class": LineEdit,
			"default_config": {"placeholder": "", "max_length": 0, "secure": false}
		},
		ComponentType.DROPDOWN:
		{"class": OptionButton, "default_config": {"selected": -1, "options": []}},
		ComponentType.SLIDER:
		{
			"class": HSlider,
			"default_config": {"min_value": 0.0, "max_value": 1.0, "step": 0.1, "value": 0.5}
		},
		ComponentType.CHECKBOX:
		{"class": CheckBox, "default_config": {"checked": false, "text": ""}},
		ComponentType.PROGRESS_BAR:
		{
			"class": ProgressBar,
			"default_config":
			{"min_value": 0.0, "max_value": 100.0, "value": 0.0, "show_percentage": true}
		},
		ComponentType.SCROLL_CONTAINER:
		{
			"class": ScrollContainer,
			"default_config": {"horizontal_scroll": false, "vertical_scroll": true}
		}
	}


# === STYLE PRESETS ===

const SafeAutoloadAccess = prepreprepreload("res://ui/components/core/SafeAutoloadAccess.gd")

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
	"""Create a UI component with configuration"""

	var component_data = get_component_configs().get(type)
	if not component_data:
		push_error("Unknown component type: " + str(type))
		return null

	var component_class = component_data.get("class")
	var default_config = component_data.get("default_config", {})

	# Merge default config with provided config
	var final_config = default_config.duplicate()
	for key in config:
		final_config[key] = config[key]

	# Create component instance
	var component = component_class.new()

	# Apply configuration
	_apply_component_config(component, final_config, type)

	return component


static func create_panel(style: String = "default", config: Dictionary = {}) -> PanelContainer:
	"""Create a styled panel"""
	var panel_config = {"theme_variant": style}
	panel_config.merge(config)

	var panel = create_component(ComponentType.PANEL, panel_config) as PanelContainer
	return panel


static func create_button(
	text: String, style: String = "primary", config: Dictionary = {}
) -> Button:
	"""Create a styled button"""
	var button_config = {"text": text, "style": style}
	button_config.merge(config)

	var button = create_component(ComponentType.BUTTON, button_config) as Button
	return button


static func create_label(text: String, style: String = "body", config: Dictionary = {}) -> Label:
	"""Create a styled label"""
	var label_config = {"text": text, "style": style}
	label_config.merge(config)

	var label = create_component(ComponentType.LABEL, label_config) as Label
	return label


static func create_text_input(placeholder: String = "", config: Dictionary = {}) -> LineEdit:
	"""Create a styled text input"""
	var input_config = {"placeholder": placeholder}
	input_config.merge(config)

	var input = create_component(ComponentType.TEXT_INPUT, input_config) as LineEdit
	return input


static func create_dropdown(options: Array, config: Dictionary = {}) -> OptionButton:
	"""Create a styled dropdown"""
	var dropdown_config = {"options": options}
	dropdown_config.merge(config)

	var dropdown = create_component(ComponentType.DROPDOWN, dropdown_config) as OptionButton
	return dropdown


static func create_slider(
	min_val: float, max_val: float, initial_val: float = 0.0, config: Dictionary = {}
) -> HSlider:
	"""Create a styled slider"""
	var slider_config = {"min_value": min_val, "max_value": max_val, "value": initial_val}
	slider_config.merge(config)

	var slider = create_component(ComponentType.SLIDER, slider_config) as HSlider
	return slider


static func create_checkbox(
	text: String, checked: bool = false, config: Dictionary = {}
) -> CheckBox:
	"""Create a styled checkbox"""
	var checkbox_config = {"text": text, "checked": checked}
	checkbox_config.merge(config)

	var checkbox = create_component(ComponentType.CHECKBOX, checkbox_config) as CheckBox
	return checkbox


static func create_progress_bar(max_val: float = 100.0, config: Dictionary = {}) -> ProgressBar:
	"""Create a styled progress bar"""
	var progress_config = {"max_value": max_val}
	progress_config.merge(config)

	var progress = create_component(ComponentType.PROGRESS_BAR, progress_config) as ProgressBar
	return progress


# === COMPLEX COMPONENT FACTORIES ===
static func create_info_panel(config: Dictionary = {}) -> Control:
	"""Create a complete information panel"""
	var panel = create_panel("default", {"padding": 20})

	# Add title bar
	var title_bar = HBoxContainer.new()
	var title = create_label(config.get("title", "Information"), "heading")
	var close_btn = create_button("✕", "icon", {"custom_minimum_size": Vector2(32, 32)})

	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_bar.add_child(title)
	title_bar.add_child(close_btn)

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
	panel.add_child(main_container)

	# Store references for easy access
	panel.set_meta("title_label", title)
	panel.set_meta("close_button", close_btn)
	panel.set_meta("content_container", content_container)

	return panel


static func create_control_panel(config: Dictionary = {}) -> Control:
	"""Create a control panel with sections"""
	var panel = create_panel("default")
	var main_container = VBoxContainer.new()

	# Title
	if config.has("title"):
		var title = create_label(config.title, "heading")
		main_container.add_child(title)
		main_container.add_child(HSeparator.new())

	# Sections
	var sections = config.get("sections", [])
	for section_config in sections:
		var section = _create_control_section(section_config)
		main_container.add_child(section)

	panel.add_child(main_container)
	return panel


static func create_form(fields: Array, config: Dictionary = {}) -> Control:
	"""Create a form with specified fields"""
	var form_panel = create_panel("default")
	var form_container = VBoxContainer.new()

	# Title
	if config.has("title"):
		var title = create_label(config.title, "heading")
		form_container.add_child(title)
		form_container.add_child(HSeparator.new())

	# Fields
	for field_config in fields:
		var field_row = _create_form_field(field_config)
		form_container.add_child(field_row)

	# Actions
	if config.has("actions"):
		var actions_row = HBoxContainer.new()
		actions_row.alignment = BoxContainer.ALIGNMENT_END

		for action in config.actions:
			var button = create_button(action.get("text", "Action"), action.get("style", "primary"))
			actions_row.add_child(button)

		form_container.add_child(actions_row)

	form_panel.add_child(form_container)
	return form_panel


# === HELPER METHODS ===
static func _apply_component_config(
	component: Control, config: Dictionary, type: ComponentType
) -> void:
	"""Apply configuration to component"""
	match type:
		ComponentType.BUTTON:
			_configure_button(component as Button, config)
		ComponentType.LABEL:
			_configure_label(component as Label, config)
		ComponentType.PANEL:
			_configure_panel(component as PanelContainer, config)
		ComponentType.TEXT_INPUT:
			_configure_text_input(component as LineEdit, config)
		ComponentType.DROPDOWN:
			_configure_dropdown(component as OptionButton, config)
		ComponentType.SLIDER:
			_configure_slider(component as HSlider, config)
		ComponentType.CHECKBOX:
			_configure_checkbox(component as CheckBox, config)
		ComponentType.PROGRESS_BAR:
			_configure_progress_bar(component as ProgressBar, config)


static func _configure_button(button: Button, config: Dictionary) -> void:
	"""Configure button component safely"""
	if not button:
		return

	if config.has("text"):
		button.text = config.text

	var themed = SafeAutoloadAccess.apply_theme_safely(button, "button")
	if not themed:
		_log_factory_warning("Button theming unavailable, using fallback for: " + button.text)

	if config.has("min_height"):
		button.custom_minimum_size.y = config.min_height


# === LOGGING HELPER ===
static func _log_factory_warning(message: String) -> void:
	"""Log factory warnings"""
	print("[UIComponentFactory] Warning: " + message)


static func _configure_label(label: Label, config: Dictionary) -> void:
	"""Configure label component safely"""
	if not label:
		return

	if config.has("text"):
		label.text = config.text

	var themed = SafeAutoloadAccess.apply_theme_safely(label, "label")
	if not themed:
		_log_factory_warning("Label theming unavailable, using fallback for: " + label.text)


static func _configure_panel(panel: PanelContainer, config: Dictionary) -> void:
	"""Configure panel component safely"""
	if not panel:
		return

	var themed = SafeAutoloadAccess.apply_theme_safely(panel, "panel")
	if not themed:
		_log_factory_warning("Panel theming unavailable, using fallback")


static func _configure_text_input(input: LineEdit, config: Dictionary) -> void:
	"""Configure text input component"""
	if config.has("placeholder"):
		input.placeholder_text = config.placeholder

	if config.has("max_length"):
		input.max_length = config.max_length

	if config.has("secure"):
		input.secret = config.secure

	# Apply safe theming (text input uses button theming)
	var themed = SafeAutoloadAccess.apply_theme_safely(input, "button")
	if not themed:
		_log_factory_warning("Text input theming unavailable, using fallback")


static func _configure_dropdown(dropdown: OptionButton, config: Dictionary) -> void:
	"""Configure dropdown component"""
	if config.has("options"):
		dropdown.clear()
		for option in config.options:
			if option is String:
				dropdown.add_item(option)
			elif option is Dictionary and option.has("text"):
				dropdown.add_item(option.text)

	if config.has("selected") and config.selected >= 0:
		dropdown.selected = config.selected


static func _configure_slider(slider: HSlider, config: Dictionary) -> void:
	"""Configure slider component"""
	slider.min_value = config.get("min_value", 0.0)
	slider.max_value = config.get("max_value", 1.0)
	slider.step = config.get("step", 0.1)
	slider.value = config.get("value", 0.5)


static func _configure_checkbox(checkbox: CheckBox, config: Dictionary) -> void:
	"""Configure checkbox component"""
	if config.has("text"):
		checkbox.text = config.text

	checkbox.button_pressed = config.get("checked", false)


static func _configure_progress_bar(progress: ProgressBar, config: Dictionary) -> void:
	"""Configure progress bar component safely"""
	if not progress:
		return

	progress.min_value = config.get("min_value", 0.0)
	progress.max_value = config.get("max_value", 100.0)
	progress.value = config.get("value", 0.0)

	# Apply safe theming
	var themed = SafeAutoloadAccess.apply_theme_safely(progress, "button")
	if not themed:
		_log_factory_warning("Progress bar theming unavailable, using fallback")


static func _create_control_section(section_config: Dictionary) -> Control:
	"""Create a control section"""
	var section = VBoxContainer.new()

	# Section title
	if section_config.has("title"):
		var title = create_label(section_config.title, "subheading")
		section.add_child(title)

	# Section content
	var content = section_config.get("content", [])
	for item_config in content:
		var item = _create_control_item(item_config)
		section.add_child(item)

	return section


static func _create_control_item(item_config: Dictionary) -> Control:
	"""Create a control item"""
	var item_type = item_config.get("type", "button")
	var item_data = item_config.get("config", {})

	match item_type:
		"button":
			return create_button(
				item_config.get("text", "Button"), item_config.get("style", "primary"), item_data
			)
		"slider":
			var container = HBoxContainer.new()
			var label = create_label(item_config.get("label", "Value:"))
			var slider = create_slider(
				item_data.get("min", 0), item_data.get("max", 1), item_data.get("value", 0.5)
			)
			container.add_child(label)
			container.add_child(slider)
			return container
		"checkbox":
			return create_checkbox(
				item_config.get("text", "Option"), item_config.get("checked", false)
			)
		_:
			return create_label("Unknown control type: " + item_type)


static func _create_form_field(field_config: Dictionary) -> Control:
	"""Create a form field"""
	var field_container = VBoxContainer.new()

	# Field label
	if field_config.has("label"):
		var label = create_label(field_config.label, "body")
		field_container.add_child(label)

	# Field input
	var field_type = field_config.get("type", "text")
	var field_input: Control

	match field_type:
		"text":
			field_input = create_text_input(field_config.get("placeholder", ""))
		"password":
			field_input = create_text_input(field_config.get("placeholder", ""), {"secure": true})
		"dropdown":
			field_input = create_dropdown(field_config.get("options", []))
		"checkbox":
			field_input = create_checkbox(
				field_config.get("text", ""), field_config.get("checked", false)
			)
		"slider":
			field_input = create_slider(
				field_config.get("min", 0),
				field_config.get("max", 1),
				field_config.get("value", 0.5)
			)
		_:
			field_input = create_label("Unknown field type: " + field_type)

	field_container.add_child(field_input)

	# Field help text
	if field_config.has("help"):
		var help = create_label(field_config.help, "caption")
		field_container.add_child(help)

	return field_container


# === UTILITY METHODS ===
static func get_component_types() -> Array:
	"""Get all available component types"""
	return ComponentType.values()


static func get_style_presets(component_type: String) -> Dictionary:
	"""Get style presets for component type"""
	return STYLE_PRESETS.get(component_type, {})


static func create_responsive_component(type: ComponentType, config: Dictionary = {}) -> Control:
	"""Create a responsive component - temporarily simplified"""
	# TODO: Re-enable ResponsiveComponent once parsing issues are resolved
	# For now, just return the base component
	var base_component = create_component(type, config)
	return base_component

	var _style = config.get("style", "primary")

	# Apply theming safely
	var _style = config.get("style", "body")

	# Apply theming safely
	var _style_variant = config.get("theme_variant", "default")

	# Apply theming safely
