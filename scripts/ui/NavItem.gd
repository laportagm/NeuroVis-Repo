extends PanelContainer
class_name NavItem

# Custom navigation item component for NeuroVis sidebar
# Provides icon + text layout with hover and selection states

signal clicked()

@export var icon_texture: Texture2D
@export var item_text: String = "Navigation Item"
@export var is_selected: bool = false

@onready var icon: TextureRect = $HBoxContainer/Icon
@onready var label: Label = $HBoxContainer/Label

var default_style: StyleBoxFlat
var hover_style: StyleBoxFlat
var selected_style: StyleBoxFlat

# Theme colors
var text_primary = Color("#e5e5e5")
var text_secondary = Color("#a0a0a0") 
var accent_color = Color("#26d0ce")
var hover_bg = Color("#2a2a2a")
var selected_bg = Color("#1f3a3a")

func _ready():
    # Create styles
    _create_styles()
    
    # Set initial content
    if icon and icon_texture:
        icon.texture = icon_texture
    
    if label:
        label.text = item_text
    
    # Apply initial style
    _update_style()
    
    # Connect mouse events
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)
    gui_input.connect(_on_gui_input)

func _create_styles():
    # Default style (transparent background)
    default_style = StyleBoxFlat.new()
    default_style.bg_color = Color.TRANSPARENT
    default_style.corner_radius_top_left = 6
    default_style.corner_radius_top_right = 6
    default_style.corner_radius_bottom_left = 6
    default_style.corner_radius_bottom_right = 6
    default_style.content_margin_left = 12
    default_style.content_margin_right = 12
    default_style.content_margin_top = 8
    default_style.content_margin_bottom = 8
    
    # Hover style
    hover_style = default_style.duplicate()
    hover_style.bg_color = hover_bg
    
    # Selected style
    selected_style = default_style.duplicate()
    selected_style.bg_color = selected_bg
    selected_style.border_width_left = 3
    selected_style.border_color = accent_color
    selected_style.content_margin_left = 9  # Compensate for border

func set_selected(selected: bool):
    is_selected = selected
    _update_style()

func _update_style():
    if is_selected:
        add_theme_stylebox_override("panel", selected_style)
        if label:
            label.modulate = accent_color
        if icon:
            icon.modulate = accent_color
    else:
        add_theme_stylebox_override("panel", default_style)
        if label:
            label.modulate = text_primary
        if icon:
            icon.modulate = text_secondary

func _on_mouse_entered():
    if not is_selected:
        add_theme_stylebox_override("panel", hover_style)
        if label:
            label.modulate = text_primary
        if icon:
            icon.modulate = text_primary
    
    # Change cursor to pointing hand
    mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_mouse_exited():
    if not is_selected:
        _update_style()

func _on_gui_input(event: InputEvent):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            clicked.emit()
            get_viewport().set_input_as_handled()

# Function to create the scene structure for this component
static func create_scene() -> PackedScene:
    var scene = PackedScene.new()
    
    # Root node
    var root = PanelContainer.new()
    root.name = "NavItem"
    root.custom_minimum_size = Vector2(260, 40)
    root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    
    # HBoxContainer for layout
    var hbox = HBoxContainer.new()
    hbox.name = "HBoxContainer"
    hbox.add_theme_constant_override("separation", 12)
    root.add_child(hbox)
    
    # Icon
    var icon = TextureRect.new()
    icon.name = "Icon"
    icon.custom_minimum_size = Vector2(20, 20)
    icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    icon.modulate = Color("#a0a0a0")
    hbox.add_child(icon)
    
    # Label
    var label = Label.new()
    label.name = "Label"
    label.text = "Navigation Item"
    label.add_theme_font_size_override("font_size", 14)
    hbox.add_child(label)
    
    # Pack the scene
    scene.pack(root)
    return scene
