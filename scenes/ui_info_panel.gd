# Modern Structure Information Panel
# Direct implementation with glass morphism design
class_name StructureInfoPanel
extends PanelContainer

# UI node references
@onready var structure_name_label: Label
@onready var close_button: Button
@onready var description_text: RichTextLabel
@onready var functions_list: VBoxContainer

# Animation and state
var tween: Tween
var current_structure_id: String = ""
var is_animating: bool = false

# Styling colors
var title_color: Color = Color(0.3, 0.8, 1.0, 1.0)  # Cyan
var description_color: Color = Color(0.9, 0.9, 0.9, 1.0)  # Light gray
var function_color: Color = Color(0.8, 1.0, 0.8, 1.0)  # Light green

# Signals
signal panel_closed

func _ready() -> void:
    call_deferred("_initialize_panel")

func _initialize_panel() -> void:
    # Create UI structure if it doesn't exist
    if not _find_ui_nodes():
        _create_modern_ui()
    
    # Setup styling and connections
    _setup_modern_styling()
    _connect_signals()
    
    # Initialize state
    clear_data()
    print("[INFO_PANEL] Modern panel initialized")

func _find_ui_nodes() -> bool:
    """Try to find existing UI nodes"""
    structure_name_label = find_child("StructureName", true, false) as Label
    close_button = find_child("CloseButton", true, false) as Button
    description_text = find_child("DescriptionText", true, false) as RichTextLabel
    functions_list = find_child("FunctionsList", true, false) as VBoxContainer
    
    return structure_name_label != null and close_button != null and description_text != null and functions_list != null

func _create_modern_ui() -> void:
    """Create modern UI structure"""
    print("[INFO_PANEL] Creating modern UI structure")
    
    # Main margin container
    var margin = MarginContainer.new()
    margin.name = "MarginContainer"
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_top", 12)
    margin.add_theme_constant_override("margin_bottom", 12)
    margin.add_theme_constant_override("margin_left", 12)
    margin.add_theme_constant_override("margin_right", 12)
    add_child(margin)
    
    # Main VBox
    var main_vbox = VBoxContainer.new()
    main_vbox.name = "MainVBox"
    margin.add_child(main_vbox)
    
    # Title bar
    var title_bar = HBoxContainer.new()
    title_bar.name = "TitleBar"
    main_vbox.add_child(title_bar)
    
    # Structure name label
    structure_name_label = Label.new()
    structure_name_label.name = "StructureName"
    structure_name_label.text = "Structure Name"
    structure_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    structure_name_label.add_theme_font_size_override("font_size", 18)
    title_bar.add_child(structure_name_label)
    
    # Close button
    close_button = Button.new()
    close_button.name = "CloseButton"
    close_button.text = "✕"
    close_button.custom_minimum_size = Vector2(32, 32)
    close_button.flat = true
    title_bar.add_child(close_button)
    
    # Separator
    var separator = HSeparator.new()
    separator.add_theme_constant_override("separation", 8)
    main_vbox.add_child(separator)
    
    # Scroll container for content
    var scroll = ScrollContainer.new()
    scroll.name = "ScrollContainer"
    scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
    scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    main_vbox.add_child(scroll)
    
    # Content container
    var content_vbox = VBoxContainer.new()
    content_vbox.name = "ContentVBox"
    scroll.add_child(content_vbox)
    
    # Description section
    var desc_header = Label.new()
    desc_header.text = "Description"
    desc_header.add_theme_font_size_override("font_size", 14)
    desc_header.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8, 1.0))
    content_vbox.add_child(desc_header)
    
    description_text = RichTextLabel.new()
    description_text.name = "DescriptionText"
    description_text.custom_minimum_size = Vector2(0, 80)
    description_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    description_text.fit_content = true
    description_text.scroll_active = false
    description_text.bbcode_enabled = true
    content_vbox.add_child(description_text)
    
    # Functions section
    var func_header = Label.new()
    func_header.text = "Functions"
    func_header.add_theme_font_size_override("font_size", 14)
    func_header.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8, 1.0))
    content_vbox.add_child(func_header)
    
    functions_list = VBoxContainer.new()
    functions_list.name = "FunctionsList"
    content_vbox.add_child(functions_list)

func _setup_modern_styling() -> void:
    """Apply enhanced glass morphism styling using updated UIThemeManager"""
    # Apply enhanced glass panel styling
    UIThemeManager.apply_glass_panel(self, 0.95, "info")
    
    # Structure name styling with enhanced typography
    if structure_name_label:
        UIThemeManager.apply_modern_label(structure_name_label, UIThemeManager.FONT_SIZE_H2, title_color, "heading")
    
    # Close button styling with enhanced button system
    if close_button:
        UIThemeManager.apply_modern_button(close_button, UIThemeManager.ACCENT_RED, "icon")
    
    # Description text styling with enhanced rich text
    if description_text:
        UIThemeManager.apply_rich_text_styling(description_text, UIThemeManager.FONT_SIZE_MEDIUM, "description")
    
    print("[INFO_PANEL] Enhanced modern styling applied")

func _connect_signals() -> void:
    """Connect UI signals"""
    if close_button and not close_button.pressed.is_connected(_on_close_pressed):
        close_button.pressed.connect(_on_close_pressed)

# Public interface
func display_structure_data(structure_data: Dictionary) -> void:
    """Display structure information with smooth animation"""
    if structure_data.is_empty():
        print("[INFO_PANEL] Empty structure data received")
        clear_data()
        return
    
    current_structure_id = structure_data.get("id", "unknown")
    print("[INFO_PANEL] Displaying: " + current_structure_id)
    
    # Show panel with animation if hidden
    if not visible:
        _animate_entrance()
    
    # Update content
    _update_content(structure_data)

func clear_data() -> void:
    """Clear panel content"""
    current_structure_id = ""
    
    if structure_name_label:
        structure_name_label.text = "No Structure Selected"
    
    if description_text:
        description_text.text = "[color=#888888][i]Select a structure to view information[/i][/color]"
    
    _clear_functions()
    visible = false

func hide_panel() -> void:
    """Hide panel with animation"""
    _animate_exit()

func show_panel() -> void:
    """Show panel with animation"""
    _animate_entrance()

# Animation methods
func _animate_entrance() -> void:
    """Smooth entrance animation using UIThemeManager"""
    if is_animating:
        return
    
    is_animating = true
    UIThemeManager.animate_entrance(self, 0.25)
    
    # Set animation complete after delay
    get_tree().create_timer(0.25).timeout.connect(func(): is_animating = false)

func _animate_exit() -> void:
    """Smooth exit animation using UIThemeManager"""
    if is_animating:
        return
    
    is_animating = true
    UIThemeManager.animate_exit(self, 0.2)
    
    # Set animation complete and emit signal after delay
    get_tree().create_timer(0.2).timeout.connect(func(): 
        is_animating = false
        emit_signal("panel_closed")
    )

# Content update methods
func _update_content(structure_data: Dictionary) -> void:
    """Update panel content"""
    # Update structure name
    if structure_name_label:
        var display_name = structure_data.get("displayName", "Unknown Structure")
        structure_name_label.text = display_name
    
    # Update description
    if description_text:
        var description = structure_data.get("shortDescription", "No description available.")
        description_text.text = _format_rich_text(description)
    
    # Update functions
    var functions = structure_data.get("functions", [])
    _update_functions(functions)

func _format_rich_text(text: String) -> String:
    """Format text with rich text styling"""
    var formatted = "[color=#E8E8E8]%s[/color]" % text
    
    # Highlight anatomical terms
    var terms = ["brain", "cortex", "neuron", "cerebral", "temporal", "frontal", 
                 "parietal", "occipital", "hippocampus", "amygdala", "thalamus", 
                 "cerebellum", "brainstem"]
    
    for term in terms:
        var regex = RegEx.new()
        regex.compile("(?i)\\b" + term + "\\b")
        formatted = regex.sub(formatted, "[color=#FFD700][b]$0[/b][/color]", true)
    
    return formatted

func _update_functions(functions_array: Array) -> void:
    """Update functions list"""
    _clear_functions()
    
    if functions_array.is_empty():
        var placeholder = Label.new()
        placeholder.text = "No functions information available"
        placeholder.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6, 1.0))
        placeholder.add_theme_font_size_override("font_size", 11)
        functions_list.add_child(placeholder)
        return
    
    # Add function items
    for i in range(functions_array.size()):
        var function_text = str(functions_array[i])
        var item = _create_function_item(function_text, i)
        functions_list.add_child(item)

func _create_function_item(text: String, index: int) -> Control:
    """Create styled function list item"""
    var container = HBoxContainer.new()
    
    # Bullet point
    var bullet = Label.new()
    var color = Color.from_hsv(float(index) * 0.15, 0.6, 0.9)
    bullet.text = "•"
    bullet.add_theme_color_override("font_color", color)
    bullet.add_theme_font_size_override("font_size", 14)
    bullet.custom_minimum_size.x = 20
    
    # Function text
    var label = Label.new()
    label.text = text
    label.add_theme_color_override("font_color", function_color)
    label.add_theme_font_size_override("font_size", 11)
    label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    
    container.add_child(bullet)
    container.add_child(label)
    
    return container

func _clear_functions() -> void:
    """Clear functions list safely"""
    if not functions_list:
        return
    
    for child in functions_list.get_children():
        functions_list.remove_child(child)
        child.queue_free()

# Signal handlers
func _on_close_pressed() -> void:
    """Handle close button press"""
    print("[INFO_PANEL] Close button pressed")
    hide_panel()

# Cleanup
func dispose() -> void:
    """Clean up resources"""
    if tween:
        tween.kill()
    clear_data()

func _exit_tree() -> void:
    """Cleanup on removal"""
    dispose()