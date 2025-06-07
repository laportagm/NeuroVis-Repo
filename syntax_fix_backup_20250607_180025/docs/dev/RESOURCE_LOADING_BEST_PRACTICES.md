# Resource Loading Best Practices for NeuroVis

## **Critical Godot 4.4 Fixes Applied**

### ✅ Fixed: Empty Resource Path Error
**Problem:** `ResourceLoader.load_threaded_request("")` caused "Resource file not found: res://" error
**Fix:** Removed invalid empty string parameter and added proper cleanup

### ✅ Fixed: Tween Animation Callback Error  
**Problem:** `tween_method` parameter order mismatch in Godot 4
**Fix:** Use lambda functions for cleaner callback handling:
```gdscript
# ❌ OLD (Godot 3 style)
tween.tween_method(_update_emission_energy.bind(material), start, end, duration)

# ✅ NEW (Godot 4 style)
tween.tween_method(func(energy): _set_material_emission(material, energy), start, end, duration)
```

### ✅ Fixed: Null Export Variables
**Problem:** Scene file had `highlight_color = null` and `emission_energy = null`
**Fix:** Set proper default values in scene files

## **Resource Loading Safety Guidelines**

### 1. **Always Validate Paths**
```gdscript
# ❌ DANGEROUS
var resource = load(path)

# ✅ SAFE
if path.is_empty():
    push_error("Empty resource path")
    return null

if not ResourceLoader.exists(path):
    push_error("Resource not found: " + path)
    return null

var resource = load(path)
```

### 2. **Use ResourceDebugger for Monitoring**
```gdscript
# Instead of direct ResourceLoader.load()
var resource = ResourceDebugger.safe_load("res://path/to/resource.tscn", "PackedScene")
```

### 3. **Common Resource Loading Pitfalls**

#### A. Empty String Concatenation
```gdscript
# ❌ DANGEROUS - if file_name is empty
var path = "res://" + file_name  # Results in "res://"

# ✅ SAFE
if file_name.is_empty():
    return null
var path = "res://" + file_name
```

#### B. Invalid Root Path
```gdscript
# ❌ NEVER DO THIS
ResourceLoader.load("res://")  # Invalid path

# ✅ ALWAYS VALIDATE
if path == "res://":
    push_error("Invalid root-only path")
    return null
```

#### C. Threaded Loading with Empty Paths
```gdscript
# ❌ CAUSES ERRORS
ResourceLoader.load_threaded_request("")

# ✅ PROPER CLEANUP
# Let Godot handle cleanup automatically during scene transitions
```

### 4. **Export Variable Safety**
```gdscript
# In scene files (.tscn), never leave exports as null:
# ❌ BAD
highlight_color = null
emission_energy = null

# ✅ GOOD  
highlight_color = Color(0, 1, 0, 1)
emission_energy = 0.5
```

### 5. **Tween Callback Best Practices**
```gdscript
# ❌ GODOT 3 STYLE (causes parameter order errors)
func _animate_material(mesh: MeshInstance3D):
    var material = mesh.get_surface_override_material(0)
    var tween = mesh.create_tween()
    tween.tween_method(_update_emission.bind(material), 0.0, 1.0, 1.0)

func _update_emission(material: Material, energy: float):  # Wrong parameter order!
    material.emission_energy_multiplier = energy

# ✅ GODOT 4 STYLE (clean and safe)
func _animate_material(mesh: MeshInstance3D):
    var material = mesh.get_surface_override_material(0)
    var tween = mesh.create_tween()
    tween.tween_method(func(energy): _safe_set_emission(material, energy), 0.0, 1.0, 1.0)

func _safe_set_emission(material: Material, energy: float):
    if material and material.has_property("emission_energy_multiplier"):
        material.emission_energy_multiplier = energy
```

## **Debugging Tools**

### ResourceDebugger Usage
```gdscript
# Initialize in _ready() for debug builds
if OS.is_debug_build():
    ResourceDebugger.initialize()

# Use safe loading
var scene = ResourceDebugger.safe_load("res://scenes/ui_panel.tscn", "PackedScene")

# Generate reports
ResourceDebugger.print_report()
ResourceDebugger.export_debug_data("user://debug_log.json")
```

### Debug Commands
```gdscript
# In debug builds, use console commands:
> resource_debug_report     # Print loading statistics
> resource_debug_export     # Export debug data to file
```

## **Project-Specific Locations to Monitor**

### High-Risk Files for Resource Loading Issues:
1. **`scripts/ci/TestRunnerCLI.gd`** - Dynamic test script loading
2. **`scripts/ModelCoordinator.gd`** - 3D model asset loading  
3. **`scenes/node_3d.gd`** - Main scene with multiple resource dependencies
4. **Any script with `@export` Resource variables**
5. **Autoload scripts during initialization**

### Prevention Checklist:
- [ ] All `load()` calls validate path before loading
- [ ] No empty string concatenations in resource paths
- [ ] Export variables have proper default values in scene files
- [ ] Tween callbacks use Godot 4 lambda syntax
- [ ] ResourceDebugger enabled in debug builds
- [ ] Regular monitoring of resource loading statistics

## **Error Recovery Patterns**

### Graceful Resource Loading Failure
```gdscript
func load_brain_model(model_path: String) -> Node3D:
    var resource = ResourceDebugger.safe_load(model_path, "PackedScene")
    if not resource:
        # Fallback to default model
        resource = ResourceDebugger.safe_load("res://assets/models/default_brain.tscn", "PackedScene")
        if not resource:
            push_error("Critical: Cannot load any brain model")
            return null
    
    var instance = resource.instantiate()
    if not instance:
        push_error("Failed to instantiate loaded resource: " + model_path)
        return null
    
    return instance
```

This document should be updated whenever new resource loading patterns are discovered or fixed.