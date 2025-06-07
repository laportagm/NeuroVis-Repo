# 🔧 Godot Tools Troubleshooting Guide

## ✅ **Step-by-Step Fix Process**

### **1. Close Everything First**
1. **Close VS Code** completely
2. **Close Godot** if it's running
3. **Wait 5 seconds**

### **2. Start Godot First**
1. **Open Godot Engine**
2. **Import your project** (`/Users/gagelaporta/A1-NeuroVis/project.godot`)
3. **Wait for project to fully load**
4. **Verify Language Server is enabled**:
   - Go to: **Editor → Editor Settings**
   - Navigate to: **Text Editor → External**  
   - ✅ Check: **"Use External Editor"**
   - ✅ Check: **"Use Language Server"**
   - **Port should be: 6008**

### **3. Then Start VS Code**
1. **Open VS Code**
2. **Open your project folder** (`/Users/gagelaporta/A1-NeuroVis`)
3. **Wait 10-15 seconds** for connection
4. **Check status bar** for "Godot Tools" indicator

## 🔧 **Fixed Configuration**

### **VS Code Settings (Fixed)**
- ✅ Godot executable path: `/Applications/Godot.app/Contents/MacOS/Godot`
- ✅ Language server port: `6008` (matches Godot)
- ✅ Editor version: `4.x`

### **Project Settings (Fixed)** 
- ✅ Remote port: `6008`
- ✅ Language server enabled
- ✅ Autoloads properly configured

## 🚨 **If Still Not Working**

### **Option 1: Manual Godot Path Selection**
1. **In VS Code**, when you see the error
2. **Click "Select Godot executable"**
3. **Navigate to**: `/Applications/Godot.app`
4. **Select the Godot.app file**

### **Option 2: Alternative Godot Paths**
If standard path doesn't work, try:
- `/Applications/Godot_v4.4.app/Contents/MacOS/Godot`
- `/Applications/Godot_mono.app/Contents/MacOS/Godot`  
- `/usr/local/bin/godot`
- Check where you actually installed Godot

### **Option 3: Find Your Godot Installation**
Open Terminal and run:
```bash
find /Applications -name "*Godot*" -type d 2>/dev/null
which godot
```

### **Option 4: Reset Everything**
1. **Delete `.vscode` folder** in your project
2. **Restart VS Code**
3. **Reinstall Godot Tools extension**
4. **Reconfigure from scratch**

## 🎯 **Testing Your Setup**

### **1. Quick Test**
1. **Open any `.gd` file** in VS Code
2. **Type**: `print("hello")`
3. **You should see**: IntelliSense suggestions

### **2. Debug Test**
1. **Press F5** in VS Code
2. **Select**: "🚀 Launch A1-NeuroVis Project"
3. **Should**: Launch Godot with your project

### **3. Language Server Test**
- **Look at bottom of VS Code** for status indicator
- **Should show**: "Godot Tools" with connection status

## ✅ **Success Indicators**

### **You'll Know It's Working When:**
- ✅ No error messages in VS Code
- ✅ IntelliSense works in `.gd` files
- ✅ "Godot Tools" shows as connected in status bar
- ✅ F5 successfully launches your project
- ✅ Syntax highlighting works properly

## 🔄 **Correct Startup Order**

**Always follow this order:**
1. 🎮 **Start Godot** → Load project → Wait for full load
2. 💻 **Start VS Code** → Open project folder → Wait for connection
3. 🧪 **Test connection** → Open .gd file → Check IntelliSense

## 📞 **Still Having Issues?**

If you're still seeing errors after following these steps:

1. **Take a screenshot** of the exact error message
2. **Check**: Does `/Applications/Godot.app` actually exist on your system?
3. **Verify**: Is your Godot version 4.x?
4. **Try**: Restarting your Mac completely

The key is making sure Godot is running with the Language Server enabled BEFORE opening VS Code. This allows VS Code to connect to the already-running language server.

---
*Fixed configurations have been applied to your project files*
