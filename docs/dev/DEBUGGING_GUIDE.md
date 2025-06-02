# 🚀 Godot Tools Debugging Setup Guide

## 🎯 **Launch Configurations Created**

### **1. 🚀 Launch A1-NeuroVis (Main Scene)**
- **Use**: Primary debugging configuration
- **Launches**: Your main scene (node_3d.tscn)
- **Best for**: General development and testing

### **2. 🎯 Launch Current Scene** 
- **Use**: Debug whatever scene is currently open in Godot
- **Launches**: Currently active scene in Godot editor
- **Best for**: Scene-specific debugging

### **3. 🔗 Attach to Running Godot**
- **Use**: Connect to already-running Godot instance
- **Launches**: Nothing (attaches to existing)
- **Best for**: When Godot is already running your project

### **4. 🧪 Debug Mode (With Collisions & Paths)**
- **Use**: Visual debugging of physics and navigation
- **Shows**: Collision shapes, navigation paths, debug info
- **Best for**: Neural model interaction debugging

### **5. 🎮 Launch for Neural Viz Testing**
- **Use**: Specialized for neural visualization
- **Features**: Verbose output, optimized for 3D models
- **Best for**: Brain model loading and performance testing

### **6. 📱 Mobile Debug** 
- **Use**: Remote debugging (if deploying to mobile)
- **Connects**: To device at specified IP
- **Best for**: Mobile testing (optional)

## 🔧 **How to Use Debugging**

### **Setup Process:**
1. **Make sure Godot path is set** in VS Code settings
2. **Enable remote debugging in Godot**:
   - Project → Project Settings → Debug → Settings
   - ✅ **Remote Port**: 6007
   - ✅ **Remote Host**: 127.0.0.1

### **Debug Workflow:**

#### **Option A: Launch from VS Code (Recommended)**
1. **Set breakpoints** in your GDScript files
2. **Press F5** or go to Run → Start Debugging
3. **Select**: "🚀 Launch A1-NeuroVis (Main Scene)"
4. **VS Code will**: Launch Godot with your project
5. **Debug**: Breakpoints will trigger, inspect variables

#### **Option B: Attach to Running Godot**
1. **Start Godot manually** and run your project
2. **In VS Code**: Press F5 → Select "🔗 Attach to Running Godot"
3. **VS Code will**: Connect to the running instance
4. **Debug**: Set breakpoints and they'll work immediately

## 🎯 **Debugging Features Available**

### **Breakpoints**
- **Set**: Click left margin in .gd files
- **Conditional**: Right-click breakpoint → Edit Condition
- **Log Points**: Right-click → Edit Log Message

### **Variable Inspection**
- **Watch Panel**: Add variables to watch
- **Locals**: See current scope variables  
- **Call Stack**: See function call hierarchy

### **Debug Console**
- **Evaluate**: GDScript expressions
- **Call**: Functions in current context
- **Inspect**: Object properties

## 🧠 **A1-NeuroVis Specific Debugging**

### **For Neural Model Issues:**
```gdscript
# Set breakpoints in these key areas:
# 1. Model loading functions
# 2. ModelSwitcher.switch_to_model()
# 3. Camera controller movement
# 4. Selection manager click handlers
```

### **Performance Debugging:**
```gdscript
# Use the Neural Viz Testing configuration
# Monitor in debugger:
# - Frame rates during model switching
# - Memory usage with large brain models
# - Loading times for .glb files
```

### **Common Debug Scenarios:**

1. **Model Not Loading**:
   - Breakpoint in ModelSwitcher
   - Check file paths
   - Verify .glb imports

2. **Camera Not Moving**:
   - Breakpoint in CameraController._input()
   - Check input event handling
   - Verify node references

3. **Selection Not Working**:
   - Breakpoint in SelectionManager
   - Check collision detection
   - Verify 3D mouse picking

## ⚙️ **Advanced Debug Settings**

### **Project Settings to Enable:**
```
Project → Project Settings → Debug → Settings:
✅ Remote Port: 6007
✅ Remote Host: 127.0.0.1  
✅ Sync Scene Changes: true
✅ Sync Script Changes: true
```

### **Godot Editor Settings:**
```
Editor → Editor Settings → Text Editor → External:
✅ Use External Editor: true
✅ Use Language Server: true
✅ Exec Path: (VS Code path)
```

## 🚨 **Troubleshooting Debug Issues**

### **If Debugging Doesn't Work:**

1. **Check Ports**:
   ```bash
   # Verify port 6007 is available
   lsof -i :6007
   ```

2. **Restart Both**:
   - Close VS Code and Godot
   - Start VS Code first, then Godot
   - Try debugging again

3. **Check Firewall**:
   - Allow VS Code and Godot through firewall
   - Check network permissions

4. **Verify Paths**:
   - Confirm Godot executable path is correct
   - Check project path in launch.json

## 🎉 **Ready to Debug!**

Your A1-NeuroVis project now has professional debugging capabilities:

- ✅ **Multiple launch configurations** for different scenarios
- ✅ **Breakpoint debugging** with variable inspection  
- ✅ **Attach to running instances** for flexible workflow
- ✅ **Neural visualization specific** debug options
- ✅ **Performance debugging** for 3D models

**Press F5 and start debugging your neural visualization system!** 🧠🔍
