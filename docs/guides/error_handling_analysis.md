# NeuroVis Error Handling Pattern Analysis

## 1. Files Using print_rich() for Colored Output (4 files)
Located in archived/disabled scripts:
- ./tmp/archive-disabled-scripts/dev_utils/ErrorTracker.gd
- ./tmp/archive-disabled-scripts/dev_utils/HealthMonitor.gd
- ./tmp/archive-disabled-scripts/dev_utils/ResourceLoadTracer.gd
- ./tmp/archive-disabled-scripts/dev_utils/TestFramework.gd

**Pattern Example:**
```gdscript
print_rich("[color=#FFA500]🔧 Attempting recovery for %s[/color]")
print_rich("[color=#00FF00]✅ Recovery successful[/color]")
```

## 2. Files Using Custom Error Signals (26 files)
Active in core systems:
- Core AI services (AIAssistantService, GeminiAIService, etc.)
- Model management (ModelLoader, ModelRegistry)
- System bootstrapping (CoreSystemsBootstrap, SystemBootstrap)
- UI components (UIComponentPool)

**Pattern Example:**
```gdscript
signal error_occurred(error_message: String)
```

## 3. Files Using console.* Methods (4 files)
Limited usage, mostly for Google Console URLs:
- ./core/ai/ui/setup/GeminiSetupDialog.gd
- ./test_browser_opening.gd
- ./tests/debug/AutoloadDebugTest.gd
- ./ui/panels/GeminiSetupDialog.gd

**Pattern Example:**
```gdscript
const GOOGLE_CONSOLE_URL = "https://console.cloud.google.com/apis/credentials"
```

## 4. Files With Non-Standard Error Formats (65 files)
Widespread across the codebase using various prefixes in print statements.

## 5. Files Mixing print() and push_error() (58 files)
Major inconsistency across core systems, UI components, and tests.

## Summary Statistics
- Total .gd files using standard push_error/push_warning: 94
- Files with inconsistent error handling: 58 (62% of error-handling files)
- Custom error patterns identified: 5 major categories
