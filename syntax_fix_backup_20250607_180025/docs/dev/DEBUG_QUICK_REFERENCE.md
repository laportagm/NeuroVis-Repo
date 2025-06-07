# 🚀 A1-NeuroVis Debug Quick Reference

## 🎮 How to Access Debug Tools

### 1. Launch Application
```bash
cd /Users/gagelaporta/A1-NeuroVis
/Applications/Godot.app/Contents/MacOS/Godot --path .
```

### 2. Open Debug Console
- Press **F1** in the application
- Or use DevConsole system built-in

### 3. Run Interactive Demo
```bash
# Run the demo scene to see everything in action:
/Applications/Godot.app/Contents/MacOS/Godot --path . debug_demo_scene.tscn
```

## ⚡ Essential Commands

### System Health
```bash
health_status          # Current system health snapshot
performance_report     # Detailed performance analysis
toggle_monitoring      # Enable/disable health monitoring
```

### Error Management
```bash
error_summary         # Show error log summary
save_error_report     # Export detailed error report
clear_errors          # Clear error log
```

### Brain Debugging
```bash
validate_models       # Check all brain models
analyze_mesh         # Analyze mesh performance
test_selection       # Test selection accuracy
analyze_materials    # Check materials/textures
```

### Testing
```bash
run_tests            # Execute full test suite
stress_test          # Run stress tests only
test_results         # Show latest test results
```

### Visual Dashboard
```bash
show_dashboard       # Show visual debug interface
toggle_dashboard     # Toggle dashboard visibility
```

## 🧪 Manual Testing Examples

### Test Error Logging
```bash
# In debug console:
ErrorTracker.log_error(ErrorTracker.ErrorLevel.WARNING, ErrorTracker.ErrorCategory.MODEL_LOADING, "Test message")
error_summary
```

### Test Brain Models
```bash
validate_models
analyze_mesh
analyze_materials
```

### Performance Testing
```bash
health_status
stress_test
performance_report
```

## 📊 What Each System Does

| System | Purpose | Key Features |
|--------|---------|--------------|
| **ErrorTracker** | Error Management | Auto-recovery, categorization, stack traces |
| **HealthMonitor** | System Health | Real-time FPS/memory, component health |
| **TestFramework** | Automated Testing | Integration, stress, performance tests |
| **BrainVisDebugger** | Neural Debugging | Model validation, mesh analysis |

## 🎯 Quick Start Workflow

1. **Launch** → `/Applications/Godot.app/Contents/MacOS/Godot --path .`
2. **Debug Console** → Press `F1`
3. **Check Health** → `health_status`
4. **Validate Models** → `validate_models`
5. **Run Tests** → `run_tests`
6. **Show Dashboard** → `show_dashboard`

## 🚨 Troubleshooting

| Problem | Solution |
|---------|----------|
| F1 doesn't work | Click in game window first |
| Commands not found | Wait for initialization to complete |
| Performance issues | Run `health_status` and `performance_report` |
| Model problems | Use `validate_models` and `analyze_mesh` |

---

📚 **For complete documentation, see `DEBUG_USER_GUIDE.md`**

🎬 **For interactive demo, run `debug_demo_scene.tscn`**