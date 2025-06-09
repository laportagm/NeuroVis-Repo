# Malformed Preload Statements Report

## Summary

Found **2 types of malformed preload statements** in the NeuroVis project:

1. **`prepreprepreload`** (4 pre's) - 161 instances
2. **`preprepreload`** (3 pre's) - 30 instances

Total: **191 malformed preload statements** across 53 unique files

## Files with `prepreprepreload` (4 pre's)

### Core Systems (10 files)
- `core/interaction/AdvancedInteractionSystem.gd` - Lines: 48, 49
- `core/systems/DebugController.gd` - Line: 18
- `core/systems/LoadingStateManager.gd` - Line: 22
- `enable_core_development_mode.gd` - Line: 8

### Main Scene Files (24 instances)
- `scenes/main/components/AICoordinator.gd` - Line: 22
- `scenes/main/components/DebugManager.gd` - Line: 56
- `scenes/main/node_3d_updated.gd` - Lines: 28-30, 34-36, 39-42, 45, 48, 51, 174
- `scenes/main/node_3d.gd` - Lines: 32-34, 85, 109, 397, 684

### Scripts (5 instances)
- `scripts/components/brain_visualizer.gd` - Lines: 33, 36-38

### Tests (94 instances)
- Test framework references in multiple test files
- Integration tests with many instances of malformed preloads
- Unit tests with validation scripts

### UI Components (28 instances)
- Multiple UI component files with malformed preloads
- Navigation components
- Panel components
- Fragment components

### Tools/Scripts (19 instances)
- Validation and testing scripts
- Component test scripts

## Files with `preprepreload` (3 pre's)

### Core Systems (10 instances)
- `core/ai/AIProviderRegistry.gd` - Line: 41
- `core/systems/ErrorHandler.gd` - Line: 337
- `core/systems/StartupValidator_CodeQuality.gd` - Line: 120
- `core/systems/StartupValidator.gd` - Lines: 82, 84
- `core/systems/DebugController.gd` - Line: 68
- `core/systems/SystemIntegrationManager.gd` - Lines: 254, 287
- `core/systems/CoreSystemsBootstrap.gd` - Line: 81
- `core/interaction/BrainStructureSelectionManager.gd` - Line: 307

### Test Files (20 instances)
- Various test and validation scripts

## Correct Syntax

The correct syntax should be:
```gdscript
# For constants:
const ClassName = preload("res://path/to/file.gd")

# For variables:
var instance = preload("res://path/to/file.gd")
```

## Recommended Fix

All instances of:
- `prepreprepreload` should be replaced with `preload`
- `preprepreload` should be replaced with `preload`

## Files to Exclude from Fix

The following directories should be excluded when applying fixes:
- `backups_*` directories
- `syntax_fix_backup_*` directories
- Any `.uid` files

## Next Steps

1. Create an automated script to fix all malformed preload statements
2. Validate the fixes don't break any functionality
3. Test the project after applying fixes
4. Create a pre-commit hook to prevent future occurrences