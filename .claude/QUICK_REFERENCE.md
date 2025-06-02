# NeuroVis Theme Implementation - Quick Reference

## 🎯 Minimal Changes Overview

```
Current System                         With Theme Support
─────────────                         ─────────────────
                                      
main_scene.gd                         main_scene.gd
     │                                     │
     ├─ Creates info_panel                 ├─ Creates info_panel
     │  directly                           │  via Factory
     │                                     │
     ▼                                     ▼
ui_info_panel.gd                      InfoPanelFactory
(Enhanced Style)                           │
                                          ├─ if (minimal)
                                          │    └─> minimal_info_panel.gd
                                          │
                                          └─ else
                                               └─> ui_info_panel.gd
```

## ⚡ Quick Implementation (15 minutes)

### 1️⃣ Create Factory (2 min)
```bash
# In terminal
cat > scripts/ui/InfoPanelFactory.gd << 'EOF'
class_name InfoPanelFactory
extends RefCounted

static var minimal_mode: bool = false

static func create_info_panel() -> Control:
    if minimal_mode:
        return load("res://scripts/ui/minimal_info_panel.gd").new()
    return load("res://scenes/ui_info_panel.gd").new()
EOF
```

### 2️⃣ Update Main Scene (1 min)
Find and replace ONE line:
```gdscript
# FIND:
info_panel = preload("res://scenes/ui_info_panel.gd").new()

# REPLACE WITH:
info_panel = InfoPanelFactory.create_info_panel()
```

### 3️⃣ Add Minimal Panel (2 min)
```bash
cp .claude/minimal_info_panel.gd scripts/ui/
```

### 4️⃣ Test (10 min)
```bash
# Test 1: Original still works
./quick_test.sh

# Test 2: Enable minimal
# In Godot console: InfoPanelFactory.minimal_mode = true
# Reload scene (F6)

# Test 3: Verify signals work
# Click on brain structures
```

## 🔍 Where to Find Things

### Your Files:
```
scenes/
├── main_scene.gd          ← Change 1 line here
├── ui_info_panel.gd       ← No changes needed!
└── ui_info_panel.tscn     ← No changes needed!

scripts/ui/
├── InfoPanelFactory.gd    ← New file (5 lines)
├── minimal_info_panel.gd  ← New file (from .claude/)
└── UIThemeManager.gd      ← No changes needed!
```

### What Each File Does:
- `InfoPanelFactory.gd` - Decides which panel to create
- `minimal_info_panel.gd` - Clean Apple-style panel
- `ui_info_panel.gd` - Your current gaming-style panel

## 🚦 Visual Verification

### Enhanced Theme (Current):
```
┌──────────────────────────┐
│ 🧠 Hippocampus    🔖📤✕  │ ← Colorful icons
│ ░░░░░░░░░░░░░░░░░░░░░░░ │ ← Glass blur effect
│ Description text here... │ ← Rich text formatting
│ • Function 1 ███████████ │ ← Colored bullets
│ • Function 2 ███████████ │ ← Hover animations
└──────────────────────────┘
```

### Minimal Theme (New):
```
┌──────────────────────────┐
│ Hippocampus         ☆ ×  │ ← Simple icons
│ Temporal Lobe Structure  │ ← Subtle category
│ ──────────────────────── │ ← Clean separator
│ A critical structure...  │ ← Plain text
│    Memory consolidation  │ ← No bullets
│    Spatial navigation    │ ← Minimal hover
└──────────────────────────┘
```

## 🛠️ Troubleshooting

### "info_panel is null"
```gdscript
# Add safety check:
if info_panel == null:
    push_error("Failed to create info panel")
    info_panel = load("res://scenes/ui_info_panel.gd").new()
```

### "Signal not found"
```gdscript
# Both panels have same signals, but check:
if info_panel.has_signal("panel_closed"):
    info_panel.panel_closed.connect(_on_panel_closed)
```

### "Minimal panel not loading"
```gdscript
# In Factory, add fallback:
static func create_info_panel() -> Control:
    if minimal_mode:
        var minimal_path = "res://scripts/ui/minimal_info_panel.gd"
        if ResourceLoader.exists(minimal_path):
            return load(minimal_path).new()
        else:
            push_warning("Minimal panel not found, using default")
    return load("res://scenes/ui_info_panel.gd").new()
```

## 🎮 Adding UI Toggle (Optional)

### Quick Version (Corner Button):
```gdscript
# Add to main_scene.gd _ready():
var toggle = CheckButton.new()
toggle.text = "Min"
toggle.position = Vector2(10, 50)
toggle.toggled.connect(func(on): 
    InfoPanelFactory.minimal_mode = on
    # Recreate panel
    if info_panel:
        info_panel.queue_free()
        _create_info_panel()  # Your existing function
)
ui_layer.add_child(toggle)
```

### Professional Version (Settings Menu):
```gdscript
# In settings menu:
var theme_option = OptionButton.new()
theme_option.add_item("Enhanced (Gaming)")
theme_option.add_item("Minimal (Professional)")
theme_option.selected = 0 if !InfoPanelFactory.minimal_mode else 1
theme_option.item_selected.connect(_on_theme_selected)
```

## ✅ Final Checklist

**Before Starting:**
- [ ] Backup your project
- [ ] Current UI works properly
- [ ] You can run quick_test.sh

**Implementation:**
- [ ] Created InfoPanelFactory.gd
- [ ] Changed 1 line in main_scene.gd
- [ ] Copied minimal_info_panel.gd
- [ ] Tested original theme still works
- [ ] Tested minimal theme works
- [ ] Signals connect properly
- [ ] Can switch between themes

**Success Indicators:**
- ✓ No errors in console
- ✓ Can select brain structures
- ✓ Panel shows/hides properly
- ✓ Both themes look correct
- ✓ Performance unchanged

## 💬 Ready-to-Use Commands

```bash
# Complete implementation
claude "Implement the theme system following QUICK_REFERENCE.md - just the 3 essential steps"

# If issues arise
claude "The info panel isn't showing after implementing the factory - help debug"

# Add theme toggle
claude "Add a simple theme toggle button to test switching between enhanced and minimal"
```

Remember: You're only changing ONE line in your existing code. Everything else is new files that don't affect current functionality!
