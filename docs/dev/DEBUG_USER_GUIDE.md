# 🧪 A1-NeuroVis Debugging Infrastructure User Guide

This guide shows you how to use and test the comprehensive debugging infrastructure built for A1-NeuroVis.

## 🚀 Quick Start

### 1. Launch the Application
```bash
cd /Users/gagelaporta/A1-NeuroVis
/Applications/Godot.app/Contents/MacOS/Godot --path .
```

### 2. Access the Debug Console
- **In-Game**: Press `F1` to open the debug console
- **Alternative**: Use the DevConsole system built into the application

### 3. Essential Debug Commands
Once in the debug console, try these commands:

```bash
# System Health
health_status          # Show current system health
performance_report     # Detailed performance analysis

# Error Tracking
error_summary         # Show error log summary
save_error_report     # Save detailed error report

# Brain Debugging
validate_models       # Check brain model integrity
analyze_mesh         # Analyze mesh performance
test_selection       # Test selection system accuracy

# Testing
run_tests            # Execute comprehensive test suite
stress_test          # Run stress tests only
```

## 📊 Using the Visual Debug Dashboard

### Enable the Dashboard
```bash
# In debug console:
show_dashboard       # Show visual debugging interface
toggle_dashboard     # Toggle dashboard visibility
```

### Dashboard Features
- **Performance Tab**: Real-time FPS and memory graphs
- **Errors Tab**: Live error log with color coding
- **Health Tab**: Component health status
- **Tests Tab**: Interactive test execution

## 🔍 Error Tracking System

### Manual Error Testing
```gdscript
# In your code or debug console:
ErrorTracker.log_error(ErrorTracker.ErrorLevel.INFO, ErrorTracker.ErrorCategory.SYSTEM, "Test message")
ErrorTracker.log_error(ErrorTracker.ErrorLevel.WARNING, ErrorTracker.ErrorCategory.MODEL_LOADING, "Model optimization needed")
ErrorTracker.log_error(ErrorTracker.ErrorLevel.ERROR, ErrorTracker.ErrorCategory.UI_INTERACTION, "UI responsiveness issue")
```

### Error Categories
- `SYSTEM` - General system issues
- `MODEL_LOADING` - 3D model loading problems
- `UI_INTERACTION` - User interface issues
- `CAMERA_CONTROL` - Camera system problems
- `KNOWLEDGE_BASE` - Data access issues
- `PERFORMANCE` - Performance degradation
- `NETWORK` - Network connectivity (future use)
- `FILE_SYSTEM` - File access problems

### Automatic Recovery
The system automatically attempts recovery for ERROR and CRITICAL level issues:
- Model loading failures → Switch to working model
- UI issues → Reset UI state
- Camera problems → Reset camera position
- Knowledge base errors → Reload data

## 💚 Health Monitoring

### Real-Time Monitoring
The HealthMonitor continuously tracks:
- **FPS**: Frame rate with performance thresholds
- **Memory**: Usage patterns and leak detection
- **Components**: Camera, models, UI, knowledge base health
- **Performance Trends**: Stability analysis over time

### Health Commands
```bash
health_status        # Current health snapshot
performance_report   # Detailed health analysis
toggle_monitoring    # Enable/disable monitoring
```

### Health Thresholds
- **FPS Warning**: Below 45 FPS
- **FPS Critical**: Below 30 FPS
- **Memory Leak**: 1MB+ increase per minute
- **GPU Memory**: 80%+ usage warning

## 🧪 Comprehensive Testing

### Test Categories
1. **Integration Tests**: Component interaction validation
2. **Stress Tests**: High-load performance testing
3. **Performance Tests**: Frame rate and memory analysis
4. **Memory Leak Tests**: Automated leak detection
5. **UI Interaction Tests**: Interface responsiveness

### Running Tests
```bash
# Full test suite (recommended)
run_tests

# Specific test categories
stress_test          # Stress testing only
test_results         # Show latest test results
```

### Test Configuration
- **Stress Duration**: 30 seconds
- **Performance Samples**: 60 data points
- **Memory Threshold**: 1MB leak detection
- **UI Delay**: 0.1s interaction testing

## 🧠 Brain Visualization Debugging

### Model Validation
```bash
validate_models      # Check all brain models
analyze_mesh         # Analyze mesh performance
analyze_materials    # Check materials and textures
test_selection       # Test selection accuracy
```

### What Gets Validated
- **Model Structure**: Node hierarchy and transforms
- **Mesh Integrity**: Vertex counts, surface validation
- **Collision Shapes**: Proper collision detection setup
- **Materials**: Texture and shader validation
- **Performance**: Vertex/triangle counts and ratings

### Performance Ratings
- **EXCELLENT**: <5K vertices, <3 surfaces
- **GOOD**: <20K vertices, <8 surfaces
- **FAIR**: <50K vertices, <15 surfaces
- **POOR**: >50K vertices, >15 surfaces

## 🎯 Interactive Testing Examples

### Example 1: Test Error Handling
1. Open debug console (`F1`)
2. Run: `clear_errors`
3. Run: `ErrorTracker.log_error(ErrorTracker.ErrorLevel.ERROR, ErrorTracker.ErrorCategory.MODEL_LOADING, "Test error")`
4. Run: `error_summary`
5. Observe automatic recovery attempt

### Example 2: Performance Analysis
1. Run: `health_status`
2. Interact with the application (rotate camera, switch models)
3. Run: `performance_report`
4. Check for performance recommendations

### Example 3: Model Debugging
1. Run: `validate_models`
2. Run: `analyze_mesh`
3. Run: `analyze_materials`
4. Review validation results and performance ratings

### Example 4: Stress Testing
1. Run: `stress_test`
2. Monitor console output for test progress
3. Run: `test_results` to see outcomes
4. Check `health_status` for impact assessment

## 📈 Performance Optimization Workflow

### 1. Baseline Measurement
```bash
health_status        # Record initial performance
performance_report   # Get detailed baseline
```

### 2. Load Testing
```bash
stress_test          # Apply system load
validate_models      # Check model performance
```

### 3. Analysis
```bash
analyze_mesh         # Identify heavy meshes
performance_report   # Check for degradation
error_summary        # Review any issues
```

### 4. Optimization
- Follow performance recommendations
- Optimize high-vertex meshes
- Address memory leaks
- Fix component health issues

## 🚨 Troubleshooting Common Issues

### Debug Console Not Opening
- Ensure you're in the main application
- Try clicking in the game window first
- Check DevConsole initialization messages

### Commands Not Working
- Verify system initialization completed
- Check for error messages in console
- Try `help` command to see available commands

### Performance Issues
- Run `health_status` to identify problems
- Use `validate_models` for model-specific issues
- Check `error_summary` for underlying problems

### Memory Leaks
- Monitor with `performance_report`
- Run `stress_test` to reproduce
- Check component health for leak sources

## 📋 Debug Command Reference

### System Health
| Command | Description |
|---------|-------------|
| `health_status` | Current system health |
| `performance_report` | Detailed performance analysis |
| `toggle_monitoring` | Enable/disable health monitoring |

### Error Management
| Command | Description |
|---------|-------------|
| `error_summary` | Error log summary |
| `save_error_report` | Export detailed error report |
| `clear_errors` | Clear error log |
| `toggle_recovery` | Enable/disable auto recovery |

### Brain Debugging
| Command | Description |
|---------|-------------|
| `validate_models` | Validate all brain models |
| `analyze_mesh [name]` | Analyze mesh performance |
| `test_selection` | Test selection accuracy |
| `analyze_materials` | Check materials/textures |
| `clear_brain_cache` | Clear analysis cache |

### Testing
| Command | Description |
|---------|-------------|
| `run_tests` | Full test suite |
| `stress_test` | Stress testing only |
| `test_results` | Show latest results |

### Visual Interface
| Command | Description |
|---------|-------------|
| `show_dashboard` | Show debug dashboard |
| `hide_dashboard` | Hide debug dashboard |
| `toggle_dashboard` | Toggle dashboard visibility |

## 🎓 Advanced Usage

### Custom Error Logging
```gdscript
# In your scripts:
if some_error_condition:
    ErrorTracker.log_error(
        ErrorTracker.ErrorLevel.WARNING,
        ErrorTracker.ErrorCategory.CUSTOM,
        "Custom error message",
        {"additional_data": "value"}
    )
```

### Health Monitoring Integration
```gdscript
# Connect to health signals:
HealthMonitor.health_warning.connect(_on_health_warning)
HealthMonitor.performance_degradation.connect(_on_performance_issue)

func _on_health_warning(component: String, issue: String, severity: float):
    # Handle health warnings in your code
    pass
```

### Custom Test Creation
```gdscript
# Add to TestFramework:
func custom_test():
    TestFramework._start_test("Custom Test Name")
    var success = your_test_logic()
    TestFramework._complete_test("Custom Test Name", success, {"details": "info"})
```

## 🏆 Production Deployment

### Pre-Release Checklist
1. Run `run_tests` - Ensure all tests pass
2. Run `validate_models` - Verify model integrity
3. Run `health_status` - Confirm system health
4. Run `performance_report` - Check optimization
5. Run `save_error_report` - Export baseline report

### Monitoring in Production
- Enable HealthMonitor for continuous tracking
- Set up error report exports
- Monitor performance trends
- Use validation tools for updates

---

🎉 **You now have enterprise-grade debugging tools at your fingertips!** This infrastructure provides comprehensive testing, monitoring, and debugging capabilities specifically designed for neural visualization applications.

For questions or additional features, the debugging infrastructure is modular and extensible - you can add custom tests, error categories, and monitoring metrics as needed.