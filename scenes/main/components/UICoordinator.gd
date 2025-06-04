## UICoordinator.gd
## Manages UI component initialization and panel visibility
##
## This component handles the initialization of UI components,
## manages panel visibility states, and coordinates UI updates.

class_name UICoordinator
extends Node

# === SIGNALS ===
signal ui_initialized()
signal panel_visibility_changed(panel_name: String, visible: bool)
signal theme_changed(theme_mode: String)

# === DEPENDENCIES ===
var info_panel: Control
var comparative_panel: Control
var object_name_label: Label

# === AUTOLOAD REFERENCES ===
var FeatureFlags = null
var UIThemeManager = null
var ComponentRegistryScript = null
var AccessibilityManager = null

# === STATE ===
var panels_initialized: bool = false
var current_theme_mode: String = "enhanced"

# === INITIALIZATION ===
func _ready() -> void:
    """Initialize UI coordinator and get autoload references"""
    _get_autoload_references()

func _get_autoload_references() -> void:
    """Get references to autoload singletons"""
    FeatureFlags = get_node_or_null("/root/FeatureFlags")
    UIThemeManager = get_node_or_null("/root/UIThemeManager")
    ComponentRegistryScript = get_node_or_null("/root/ComponentRegistry")
    AccessibilityManager = get_node_or_null("/root/AccessibilityManager")

func setup(dependencies: Dictionary) -> void:
    """Setup UI coordinator with required dependencies"""
    info_panel = dependencies.get("info_panel")
    comparative_panel = dependencies.get("comparative_panel")
    object_name_label = dependencies.get("object_name_label")
    
    _initialize_ui_components()
    _initialize_ui_panels()
    _apply_theme()

func _initialize_ui_components() -> void:
    """Initialize UI components safely"""
    print("[UICoordinator] Info: Initializing UI components...")

    # Check if we should use new component system
    if FeatureFlags and FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS):
        print("[UICoordinator] Info: ✓ Using new modular component system")
    else:
        print("[UICoordinator] Info: - Using legacy component system")

    # Initialize AccessibilityManager safely (temporarily disabled)
    # if AccessibilityManager and AccessibilityManager.has_method("initialize"):
    #     AccessibilityManager.initialize()
    #     print("[UICoordinator] Info: ✓ AccessibilityManager initialized")
    # else:
    print("[UICoordinator] Info: - AccessibilityManager temporarily disabled for progressive enablement")

func _initialize_ui_panels() -> void:
    """Initialize UI panels"""
    print("[UICoordinator] Info: Initializing UI panels...")

    # Initialize info panel if available
    if info_panel and info_panel.has_method("initialize"):
        info_panel.initialize()
        info_panel.hide() # Hide initially until structure selected
        panels_initialized = true

    # Initialize comparative panel if available
    if comparative_panel and comparative_panel.has_method("initialize"):
        comparative_panel.initialize()
        comparative_panel.hide() # Hide initially

    print("[UICoordinator] Info: ✓ UI panels initialized")
    ui_initialized.emit()

func _apply_theme() -> void:
    """Apply UI theme based on settings"""
    if not UIThemeManager:
        push_warning("[UICoordinator] Warning: UIThemeManager not available, using default theme")
        return
    
    # Apply theme to panels
    if UIThemeManager.has_method("apply_theme_to_control"):
        if info_panel:
            UIThemeManager.apply_theme_to_control(info_panel)
        if comparative_panel:
            UIThemeManager.apply_theme_to_control(comparative_panel)
        
        print("[UICoordinator] Info: ✓ Theme applied to UI panels")

# === PANEL MANAGEMENT ===
func show_info_panel(structure_info: Dictionary = {}) -> void:
    """Show the information panel with optional structure data"""
    if not info_panel:
        push_warning("[UICoordinator] Info panel not available")
        return
    
    # Hide comparative panel if showing info panel
    hide_comparative_panel()
    
    # Update panel content if structure info provided
    if not structure_info.is_empty() and info_panel.has_method("display_structure_info"):
        info_panel.display_structure_info(structure_info.get("name", ""))
    
    info_panel.show()
    panel_visibility_changed.emit("info_panel", true)

func hide_info_panel() -> void:
    """Hide the information panel"""
    if info_panel:
        info_panel.hide()
        panel_visibility_changed.emit("info_panel", false)

func show_comparative_panel(selections: Array = []) -> void:
    """Show the comparative panel with optional selection data"""
    if not comparative_panel:
        push_warning("[UICoordinator] Comparative panel not available")
        return
    
    # Hide info panel if showing comparative panel
    hide_info_panel()
    
    # Update panel content if selections provided
    if not selections.is_empty() and comparative_panel.has_method("update_comparison"):
        comparative_panel.update_comparison(selections)
    
    comparative_panel.show()
    panel_visibility_changed.emit("comparative_panel", true)

func hide_comparative_panel() -> void:
    """Hide the comparative panel"""
    if comparative_panel:
        comparative_panel.hide()
        panel_visibility_changed.emit("comparative_panel", false)

func hide_all_panels() -> void:
    """Hide all UI panels"""
    hide_info_panel()
    hide_comparative_panel()

# === LABEL UPDATES ===
func update_selection_label(text: String) -> void:
    """Update the object name label text"""
    if object_name_label:
        object_name_label.text = text

func update_multi_selection_label(selections: Array) -> void:
    """Update label for multiple selections"""
    if not object_name_label:
        return
    
    if selections.is_empty():
        object_name_label.text = "Selected: None"
    elif selections.size() == 1:
        object_name_label.text = "Selected: " + selections[0].get("name", "Unknown")
    else:
        var names = []
        for sel in selections:
            names.append(sel.get("name", "Unknown"))
        object_name_label.text = "Comparing: " + ", ".join(names)

# === THEME MANAGEMENT ===
func set_theme_mode(mode: String) -> void:
    """Set the UI theme mode (enhanced/minimal)"""
    if not UIThemeManager:
        push_warning("[UICoordinator] UIThemeManager not available")
        return
    
    current_theme_mode = mode
    
    if UIThemeManager.has_method("set_theme_mode"):
        var theme_enum = UIThemeManager.ThemeMode.ENHANCED if mode == "enhanced" else UIThemeManager.ThemeMode.MINIMAL
        UIThemeManager.set_theme_mode(theme_enum)
        _apply_theme()
        theme_changed.emit(mode)
        print("[UICoordinator] Info: Theme mode changed to: %s" % mode)

func toggle_theme() -> void:
    """Toggle between enhanced and minimal theme modes"""
    var new_mode = "minimal" if current_theme_mode == "enhanced" else "enhanced"
    set_theme_mode(new_mode)

# === NOTIFICATION SYSTEM ===
func show_notification(text: String, duration: float = 3.0, color: Color = Color.WHITE) -> void:
    """Show a temporary notification message"""
    var notification = Label.new()
    notification.text = text
    notification.add_theme_color_override("font_color", color)
    notification.add_theme_font_size_override("font_size", 16)
    
    # Position at top center
    notification.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
    notification.position.y = 100
    notification.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    
    # Add to UI layer
    var ui_layer = get_node_or_null("/root/UI_Layer")
    if not ui_layer and get_parent():
        ui_layer = get_parent().get_node_or_null("UI_Layer")
    
    if ui_layer:
        ui_layer.add_child(notification)
        
        # Auto-remove after duration
        await get_tree().create_timer(duration).timeout
        if is_instance_valid(notification):
            notification.queue_free()

# === PUBLIC METHODS ===
func is_panel_visible(panel_name: String) -> bool:
    """Check if a specific panel is visible"""
    match panel_name:
        "info_panel":
            return info_panel and info_panel.visible
        "comparative_panel":
            return comparative_panel and comparative_panel.visible
        _:
            return false

func get_visible_panels() -> Array:
    """Get list of currently visible panels"""
    var visible = []
    if is_panel_visible("info_panel"):
        visible.append("info_panel")
    if is_panel_visible("comparative_panel"):
        visible.append("comparative_panel")
    return visible

func are_panels_initialized() -> bool:
    """Check if UI panels have been initialized"""
    return panels_initialized