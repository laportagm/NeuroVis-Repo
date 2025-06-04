class_name ModernInfoDisplay
extends Control

signal closed()

func display_structure_data(data: Dictionary) -> void:
    # Clear previous content
    for child in get_children():
        child.queue_free()
    
    var card = _create_modern_card(data)
    add_child(card)
    _animate_entrance(card)

func _create_modern_card(data: Dictionary) -> Control:
    var card = PanelContainer.new()
    card.custom_minimum_size = Vector2(320, 0)
    
    # Glass morphism style
    var style = StyleBoxFlat.new()
    style.bg_color = Color(0.1, 0.1, 0.15, 0.95)
    style.corner_radius_top_left = 16
    style.corner_radius_top_right = 16
    style.corner_radius_bottom_left = 16
    style.corner_radius_bottom_right = 16
    style.border_width_left = 1
    style.border_width_right = 1
    style.border_width_top = 1
    style.border_width_bottom = 1
    style.border_color = Color(1, 1, 1, 0.1)
    style.shadow_size = 24
    style.shadow_color = Color(0, 0, 0, 0.4)
    card.add_theme_stylebox_override("panel", style)
    
    var content = VBoxContainer.new()
    content.add_theme_constant_override("separation", 16)
    card.add_child(content)
    
    # Header with close button
    var header = _create_header(data.get("displayName", "Unknown"))
    content.add_child(header)
    
    # Add separator
    var separator = HSeparator.new()
    content.add_child(separator)
    
    # Description with visual hierarchy
    if data.has("shortDescription"):
        var desc_panel = _create_description_panel(data.shortDescription)
        content.add_child(desc_panel)
    
    # Functions with modern bullet points
    if data.has("functions") and data.functions.size() > 0:
        var functions_section = _create_functions_section(data.functions)
        content.add_child(functions_section)
    
    # Action buttons
    var actions = _create_action_buttons()
    content.add_child(actions)
    
    return card

func _create_header(title: String) -> HBoxContainer:
    var header = HBoxContainer.new()
    
    var title_label = Label.new()
    title_label.text = title
    title_label.add_theme_font_size_override("font_size", 24)
    title_label.add_theme_color_override("font_color", Color("#00D9FF"))  # Primary cyan
    title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    header.add_child(title_label)
    
    var close_btn = Button.new()
    close_btn.text = "✕"
    close_btn.flat = true
    close_btn.add_theme_font_size_override("font_size", 20)
    close_btn.pressed.connect(_on_close)
    header.add_child(close_btn)
    
    return header

func _create_description_panel(text: String) -> PanelContainer:
    var panel = PanelContainer.new()
    var style = StyleBoxFlat.new()
    style.bg_color = Color("#16213E").darkened(0.2)  # Surface light darkened
    style.corner_radius_top_left = 8
    style.corner_radius_top_right = 8
    style.corner_radius_bottom_left = 8
    style.corner_radius_bottom_right = 8
    style.content_margin_left = 12
    style.content_margin_right = 12
    style.content_margin_top = 12
    style.content_margin_bottom = 12
    panel.add_theme_stylebox_override("panel", style)
    
    var label = RichTextLabel.new()
    label.text = text
    label.fit_content = true
    label.add_theme_color_override("default_color", Color("#B8BCC8"))  # Text secondary
    panel.add_child(label)
    
    return panel

func _create_functions_section(functions: Array) -> VBoxContainer:
    var section = VBoxContainer.new()
    
    var header = Label.new()
    header.text = "Key Functions"
    header.add_theme_font_size_override("font_size", 16)
    header.add_theme_color_override("font_color", Color("#FFB700"))  # Warning amber
    section.add_child(header)
    
    for func_text in functions:
        var item = HBoxContainer.new()
        
        var bullet = Label.new()
        bullet.text = "▸"
        bullet.add_theme_color_override("font_color", Color("#00D9FF"))  # Primary cyan
        item.add_child(bullet)
        
        var text_label = Label.new()
        text_label.text = func_text
        text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
        text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        item.add_child(text_label)
        
        section.add_child(item)
    
    return section

func _create_action_buttons() -> HBoxContainer:
    var container = HBoxContainer.new()
    container.add_theme_constant_override("separation", 8)
    
    var learn_btn = _create_styled_button("Learn More", Color("#00D9FF"))  # Primary cyan
    var focus_btn = _create_styled_button("Focus", Color("#FF006E"))      # Secondary magenta
    
    container.add_child(learn_btn)
    container.add_child(focus_btn)
    
    return container

func _create_styled_button(text: String, color: Color) -> Button:
    var btn = Button.new()
    btn.text = text
    btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    
    var style = StyleBoxFlat.new()
    style.bg_color = color
    style.corner_radius_top_left = 8
    style.corner_radius_top_right = 8
    style.corner_radius_bottom_left = 8
    style.corner_radius_bottom_right = 8
    style.content_margin_left = 16
    style.content_margin_right = 16
    style.content_margin_top = 8
    style.content_margin_bottom = 8
    
    btn.add_theme_stylebox_override("normal", style)
    btn.add_theme_color_override("font_color", Color("#1A1A2E"))  # Surface color
    
    return btn

func _on_close() -> void:
    _animate_exit(self)
    closed.emit()

# Animation helper functions
func _animate_entrance(control: Control, delay: float = 0.0) -> void:
    """Smooth entrance animation for any control"""
    control.modulate.a = 0
    control.scale = Vector2(0.9, 0.9)
    
    var tween = control.create_tween()
    if delay > 0:
        tween.tween_interval(delay)
    
    tween.set_parallel(true)
    tween.tween_property(control, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_OUT)
    tween.tween_property(control, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _animate_exit(control: Control, duration: float = 0.2) -> void:
    """Smooth exit animation"""
    var tween = control.create_tween()
    tween.set_parallel(true)
    tween.tween_property(control, "modulate:a", 0.0, duration)
    tween.tween_property(control, "scale", Vector2(0.9, 0.9), duration)
    tween.tween_callback(control.queue_free)