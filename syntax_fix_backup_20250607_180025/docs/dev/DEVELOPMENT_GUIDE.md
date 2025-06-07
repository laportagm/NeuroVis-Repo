# A1-NeuroVis Development Guide

## 🧠 Project Overview
A1-NeuroVis is an advanced neural visualization system built with Godot 4.x for interactive brain anatomy exploration.

## 🚀 Quick Start (Enhanced Setup)

### VS Code Setup
1. **Open Project**: Open the A1-NeuroVis folder in VS Code
2. **Extensions**: Ensure Godot Tools extension is installed
3. **Launch**: Press `F5` or `Globe+F5` to launch with debugging

### Development Workflow
1. **Code in VS Code**: Write scripts with full IntelliSense support
2. **Test in Godot**: Use Godot editor for scene editing and testing
3. **Debug**: Set breakpoints and use VS Code's debug features
4. **Performance**: Use built-in profiling tools

## 🛠️ Enhanced Features

### Custom Snippets
- `ndebug` - Neural debug print
- `perf` - Performance timing
- `modelswitch` - Switch neural models
- `kbquery` - Query knowledge base
- `vdebug` - Visual debug toggle

### Development Tools
- **ProjectProfiler**: Performance monitoring
- **DevConsole**: Enhanced debugging console
- **TestRunner**: Automated testing framework

### Tasks (Cmd+Shift+P → Tasks)
- `🚀 Quick Launch A1-NeuroVis` - Launch project quickly
- `🧹 Clean Godot Cache` - Clear .godot directory
- `📊 Check Project Health` - Analyze project structure
- `🔍 Analyze Neural Models` - List 3D models

## 🧪 Testing

### Run Tests
```gdscript
# In Godot console or debug scene
TestRunner.run_all_tests()
TestRunner.quick_test()
TestRunner.test_performance()
```

### Performance Monitoring
```gdscript
# Start timing
ProjectProfiler.start_timer("model_loading")

# Your code here

# End timing
ProjectProfiler.end_timer("model_loading")
ProjectProfiler.print_performance_report()
```

## 🎮 Debug Console

### Activation
- Press `F1 + Enter` to toggle dev console
- Use shortcuts for common operations:
  - `perf` - Performance report
  - `models` - List neural models
  - `scenes` - List scenes
  - `nodes` - Print scene tree
  - `memory` - Memory usage

### Debug Commands
Your existing DebugCommands system is enhanced with:
- Better error handling
- Performance monitoring
- Visual feedback
- Command history

## 📁 Project Structure (Enhanced)

```
A1-NeuroVis/
├── .vscode/
│   ├── settings.json      # Enhanced VS Code settings
│   ├── launch.json        # Debug configurations
│   ├── tasks.json         # Development tasks
│   └── snippets/          # Custom GDScript snippets
├── scripts/
│   ├── dev_utils/         # Development utilities
│   │   ├── ProjectProfiler.gd
│   │   └── DevConsole.gd
│   └── [existing scripts]
├── tests/
│   └── TestRunner.gd      # Automated testing
├── scenes/
│   └── [existing scenes]
└── [other folders]
```

## 🔧 Configuration Files

### VS Code Settings
- Enhanced Godot Tools integration
- Optimized file watching
- GitHub Copilot configured
- Performance optimizations

### Launch Configurations
- 🚀 Launch A1-NeuroVis Project
- 🎯 Launch Current Scene
- 🧪 Launch Debug Scene
- 🔍 Attach to Running Godot

## 🎯 Best Practices

### Code Organization
1. Use meaningful class names and documentation
2. Implement error handling in all functions
3. Use performance profiling for critical operations
4. Write tests for new features

### Debugging
1. Set strategic breakpoints in VS Code
2. Use neural debug prints (`ndebug` snippet)
3. Monitor performance with ProjectProfiler
4. Use DevConsole for real-time debugging

### Performance
1. Profile model loading operations
2. Monitor memory usage
3. Use caching for frequently accessed data
4. Optimize scene tree structure

## 🚨 Troubleshooting

### Common Issues
1. **VS Code not connecting**: Restart both VS Code and Godot
2. **Breakpoints not working**: Ensure LSP is enabled in Godot
3. **Performance issues**: Use ProjectProfiler to identify bottlenecks
4. **Missing autoloads**: Check project.godot configuration

### Health Check
Run the project health check task to verify:
- All autoloads are working
- Scene files exist
- Scripts are properly configured
- Neural models are accessible

## 🔄 Version Control

### Git Configuration
- Optimized .gitignore for Godot projects
- Automatic file watching exclusions
- Smart commit features enabled

### Recommended Workflow
1. Create feature branches for new development
2. Use descriptive commit messages
3. Test changes before merging
4. Keep main branch stable

## 📈 Performance Metrics

The enhanced setup includes built-in performance monitoring:
- Model loading times
- Scene transition performance
- Memory usage tracking
- Rendering performance metrics

## 🎉 Ready to Develop!

Your A1-NeuroVis project is now fully optimized for professional development with:
- ✅ Enhanced VS Code integration
- ✅ Custom debugging tools
- ✅ Performance monitoring
- ✅ Automated testing
- ✅ Development utilities
- ✅ Professional workflow setup

Use `F5` to launch and start developing!
