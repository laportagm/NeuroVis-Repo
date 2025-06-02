# Core Development Mode for NeuroVis

## Overview

Core Development Mode is a special configuration that simplifies the NeuroVis project for focused architectural work. It disables complex UI systems and advanced features while keeping essential educational functionality intact.

## Benefits

- **Simplified Architecture**: Focus on core systems without UI complexity
- **Faster Iteration**: Reduced autoload dependencies speed up development
- **Clear Debugging**: Minimal systems make issues easier to trace
- **Stable Foundation**: Work on architecture without breaking production features

## What Gets Disabled

### Complex UI Systems
- ❌ UI_MODULAR_COMPONENTS - Component-based UI framework
- ❌ UI_COMPONENT_POOLING - Memory optimization for UI
- ❌ UI_STATE_PERSISTENCE - State management system
- ❌ UI_STYLE_ENGINE - Advanced theming engine
- ❌ UI_ADVANCED_INTERACTIONS - Drag & drop, gestures

### Advanced Features
- ❌ UI_GESTURE_RECOGNITION - Touch gesture support
- ❌ UI_CONTEXT_MENUS - Right-click menus
- ❌ AI_ASSISTANT_V2 - Next-gen AI features
- ❌ LAZY_LOADING - Deferred loading system

## What Stays Enabled

### Essential Features
- ✅ UI_LEGACY_PANELS - Basic UI functionality
- ✅ ADVANCED_ANIMATIONS - Smooth transitions
- ✅ ACCESSIBILITY_ENHANCED - Accessibility features
- ✅ MEMORY_OPTIMIZATION - Core memory management

### Development Tools
- ✅ DEBUG_COMPONENT_INSPECTOR - Component debugging
- ✅ DEBUG_PERFORMANCE_OVERLAY - Performance monitoring
- ✅ PERFORMANCE_MONITORING - Metrics tracking

### Core Autoloads
- ✅ KB - Knowledge base (legacy)
- ✅ KnowledgeService - Educational content
- ✅ AIAssistant - Basic AI features
- ✅ UIThemeManager - Theme management
- ✅ ModelSwitcherGlobal - 3D model control
- ✅ DebugCmd - Debug commands
- ✅ FeatureFlags - Feature management

## Quick Start

### Enable Core Development Mode

```bash
# Option 1: Use the shell script
./enable_core_dev.sh

# Option 2: Use Godot directly
godot --headless --script enable_core_development_mode.gd
```

### Validate Configuration

```bash
# Check if core development mode is properly configured
godot --headless --script validate_core_dev_mode.gd
```

### Disable Core Development Mode

```bash
# Option 1: Use the shell script
./disable_core_dev.sh

# Option 2: Use Godot directly
godot --headless --script disable_core_development_mode.gd
```

## Testing in Core Development Mode

When running tests in core development mode:

```bash
# Run simplified test suite
./run_tests.sh safe

# The tests will automatically detect core development mode
# and adjust expectations accordingly
```

## How It Works

### 1. Feature Flags System

**Note**: FeatureFlags is implemented as an autoload singleton without a `class_name` declaration to avoid naming conflicts in Godot.

Core Development Mode uses the FeatureFlags system to control which features are active:

```gdscript
# Check if in core development mode
if FeatureFlags.is_core_development_mode():
    print("Running in simplified mode")
```

### 2. Configuration Storage

Settings are stored in `user://feature_flags.cfg`:

```ini
[system]
core_development_mode=true

[features]
UI_MODULAR_COMPONENTS=false
UI_LEGACY_PANELS=true
# ... other feature flags
```

### 3. Autoload Management

The `project.godot` file is configured to enable FeatureFlags as an autoload while complex systems remain commented out.

### 4. Component Adaptation

Components check for core development mode and adapt their behavior:

```gdscript
func _ready() -> void:
    if Engine.has_singleton("FeatureFlags"):
        var flags = Engine.get_singleton("FeatureFlags")
        if flags.call("is_core_development_mode"):
            # Use simplified initialization
```

## Development Workflow

1. **Enable Core Development Mode**
   ```bash
   ./enable_core_dev.sh
   ```

2. **Work on Core Architecture**
   - Focus on core systems in `core/` directory
   - Develop without UI complexity
   - Test with simplified systems

3. **Validate Changes**
   ```bash
   ./run_tests.sh safe
   ```

4. **Disable When Done**
   ```bash
   ./disable_core_dev.sh
   ```

## Troubleshooting

### FeatureFlags Not Found

If you get "FeatureFlags autoload not found":
1. Check that FeatureFlags is enabled in project.godot
2. Ensure the path is correct: `res://core/features/FeatureFlags.gd`

### Tests Failing in Core Dev Mode

Some tests expect full functionality. In core development mode:
- UI component tests may be simplified
- Complex feature tests are skipped
- Focus on core system tests

### Configuration Not Persisting

Check the configuration file location:
- macOS: `~/Library/Application Support/Godot/app_userdata/A1-NeuroVis/feature_flags.cfg`
- Linux: `~/.local/share/godot/app_userdata/A1-NeuroVis/feature_flags.cfg`
- Windows: `%APPDATA%\Godot\app_userdata\A1-NeuroVis\feature_flags.cfg`

## Best Practices

1. **Always Validate**: Run validation after enabling/disabling
2. **Test Early**: Run tests frequently in core dev mode
3. **Document Changes**: Note which features your code depends on
4. **Clean Commits**: Disable core dev mode before committing

## Environment Variables

You can also control core development mode via environment variable:

```bash
# Enable
export NEUROVIS_CORE_DEV=1

# Disable
unset NEUROVIS_CORE_DEV
```

## Related Documentation

- [Development Standards](docs/dev/DEVELOPMENT_STANDARDS_MASTER.md)
- [Testing Guide](docs/dev/TESTING_STANDARDS.md)
- [Architecture Overview](docs/dev/scene_architecture.md)