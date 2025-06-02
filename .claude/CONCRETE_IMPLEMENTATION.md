# Concrete Implementation Example

## 🎯 Exact Changes to Your Current Files

### File 1: `scenes/ui_info_panel.gd` (Current)
**Changes needed**: Just add interface inheritance (1 line change)

```gdscript
# Line 3 - CHANGE FROM:
extends PanelContainer

# CHANGE TO:
extends IInfoPanel  # or PanelContainer if IInfoPanel extends it

# That's it! Everything else stays the same
```

### File 2: `scenes/main_scene.gd` (Current Integration)
**Find where info panel is created and modify**:

```gdscript
# CURRENT CODE (around line 50-70):
func _ready() -> void:
    # ... other setup ...
    info_panel = preload("res://scenes/ui_info_panel.gd").new()
    info_panel.panel_closed.connect(_on_info_panel_closed)
    ui_layer.add_child(info_panel)
    info_panel.visible = false

# NEW CODE (minimal change):
func _ready() -> void:
    # ... other setup ...
    # Load theme preference (one line)
    InfoPanelFactory.load_theme_preference()
    
    # Create panel using factory (one line change)
    info_panel = InfoPanelFactory.create_info_panel()
    
    # Everything else stays exactly the same!
    info_panel.panel_closed.connect(_on_info_panel_closed)
    ui_layer.add_child(info_panel)
    info_panel.visible = false
```

### File 3: New Factory (Complete file)
**Create**: `scripts/ui/InfoPanelFactory.gd`

```gdscript
class_name InfoPanelFactory
extends RefCounted

static var use_minimal_theme: bool = false

static func create_info_panel() -> PanelContainer:
    # Try minimal theme
    if use_minimal_theme:
        var minimal_scene = load("res://scripts/ui/minimal_info_panel.gd")
        if minimal_scene:
            return minimal_scene.new()
    
    # Default to existing panel (no breaking change)
    return load("res://scenes/ui_info_panel.gd").new()

static func load_theme_preference() -> void:
    # Optional - can skip this initially
    pass
```

## 🔄 Migration in 3 Safe Steps

### Step 1: Add Factory (5 minutes)
```bash
# 1. Create factory file
touch scripts/ui/InfoPanelFactory.gd
# 2. Copy the factory code above
# 3. Test that current UI still works
```

### Step 2: Use Factory (5 minutes)
```gdscript
# In main_scene.gd, change ONE line:
# OLD:
info_panel = preload("res://scenes/ui_info_panel.gd").new()

# NEW:
info_panel = InfoPanelFactory.create_info_panel()
```

### Step 3: Add Minimal Panel (10 minutes)
```bash
# Copy minimal panel
cp .claude/minimal_info_panel.gd scripts/ui/

# Enable in factory
InfoPanelFactory.use_minimal_theme = true

# Test it works!
```

## 🧪 Test at Each Step

### After Step 1 - Factory Added
```bash
# Run game - should work exactly as before
./quick_test.sh
# Expected: No change in behavior
```

### After Step 2 - Factory Used
```bash
# Run game - should still work exactly as before
./quick_test.sh
# Expected: No change, but now using factory
```

### After Step 3 - Minimal Theme
```bash
# Run game - should show minimal UI
./quick_test.sh
# Expected: Clean, minimal interface
```

## 💡 Actual Code Diff

### main_scene.gd changes:
```diff
 func _ready() -> void:
     # Setup UI
-    info_panel = preload("res://scenes/ui_info_panel.gd").new()
+    info_panel = InfoPanelFactory.create_info_panel()
     info_panel.panel_closed.connect(_on_info_panel_closed)
     ui_layer.add_child(info_panel)
```

### That's literally the only change to existing code!

## 🎮 Adding Theme Toggle (Optional)

### Quick Toggle Button
```gdscript
# Add to main_scene.gd _ready():
func _add_theme_toggle() -> void:
    # Create simple toggle in corner
    var btn = Button.new()
    btn.text = "Toggle Theme"
    btn.position = Vector2(10, 10)
    btn.pressed.connect(_toggle_theme)
    ui_layer.add_child(btn)

func _toggle_theme() -> void:
    # Switch theme
    InfoPanelFactory.use_minimal_theme = !InfoPanelFactory.use_minimal_theme
    
    # Recreate panel
    var was_visible = info_panel.visible
    var old_data = info_panel.current_structure_data  # if stored
    
    info_panel.queue_free()
    info_panel = InfoPanelFactory.create_info_panel()
    ui_layer.add_child(info_panel)
    info_panel.visible = was_visible
    
    # Reconnect
    info_panel.panel_closed.connect(_on_info_panel_closed)
```

## ✅ Complete Working Example

### 1. Terminal Commands:
```bash
# Create factory
echo 'class_name InfoPanelFactory
extends RefCounted

static var use_minimal_theme: bool = false

static func create_info_panel() -> PanelContainer:
    if use_minimal_theme:
        var minimal = load("res://scripts/ui/minimal_info_panel.gd")
        if minimal:
            return minimal.new()
    return load("res://scenes/ui_info_panel.gd").new()' > scripts/ui/InfoPanelFactory.gd

# Copy minimal panel
cp .claude/minimal_info_panel.gd scripts/ui/

# That's it!
```

### 2. In Godot:
1. Open `main_scene.gd`
2. Find where `info_panel` is created
3. Change that ONE line to use factory
4. Run game - works!

### 3. Test Theme:
```gdscript
# In Godot editor console:
InfoPanelFactory.use_minimal_theme = true
# Restart scene - see minimal theme!
```

## 🚨 If Anything Breaks

### Instant Rollback:
```gdscript
# In InfoPanelFactory.gd:
static func create_info_panel() -> PanelContainer:
    # EMERGENCY - just return original
    return load("res://scenes/ui_info_panel.gd").new()
```

### Or in main_scene.gd:
```gdscript
# Just revert the one line:
info_panel = preload("res://scenes/ui_info_panel.gd").new()
# Instead of factory
```

## 📊 Success Metrics

✓ **No breaking changes**: Existing functionality unchanged
✓ **Minimal code changes**: Literally 1 line in main file
✓ **Easy rollback**: Can revert in seconds
✓ **Theme switching**: Works with simple toggle
✓ **Both themes work**: Enhanced and minimal

This is the safest possible way to add the theme system!
