# 🚨 EMERGENCY GODOT TOOLS FIX GUIDE

## 🎯 **CRITICAL: Follow This Exact Order**

### **PHASE 1: COMPLETE RESET** 
⚠️ **Do this first - no shortcuts!**

1. **Close EVERYTHING**
   ```bash
   # Close VS Code completely (Cmd+Q)
   # Close Godot completely 
   # Wait 10 seconds
   ```

2. **Reset VS Code Extension**
   - Open VS Code
   - Go to Extensions (Cmd+Shift+X)
   - Find "Godot Tools" 
   - Click **Disable**
   - Click **Uninstall**
   - **Restart VS Code**
   - **Reinstall** Godot Tools extension
   - **Restart VS Code again**

### **PHASE 2: FIND YOUR GODOT** 
🔍 **Critical - We need the exact path**

1. **Run Detection Script**
   ```bash
   cd /Users/gagelaporta/A1-NeuroVis
   chmod +x detect_godot.sh
   ./detect_godot.sh
   ```

2. **Copy the recommended path** from the output

3. **Manual Check** (if script doesn't work):
   - Open **Finder**
   - Go to **Applications** folder
   - Look for **Godot.app** (or similar)
   - Right-click → **Show Package Contents**
   - Navigate: **Contents → MacOS → Godot**
   - Copy this full path

### **PHASE 3: CONFIGURE VS CODE**

1. **Open VS Code Settings**
   - Press **Cmd+,**
   - Click **Open Settings (JSON)** in top-right

2. **Add Godot Path**
   ```json
   {
       "godot_tools.editor_path": "/YOUR/EXACT/PATH/HERE",
       "godot_tools.gdscript_lsp_server_port": 6005
   }
   ```

3. **Save and Restart VS Code**

### **PHASE 4: CONFIGURE GODOT**

1. **Open Godot Engine**
2. **Open your project** (`/Users/gagelaporta/A1-NeuroVis/project.godot`)
3. **Go to Editor Settings**:
   - **Editor → Editor Settings**
   - **Text Editor → External**
   - ✅ **Use External Editor** = ON
   - ✅ **Use Language Server** = ON
   - **Exec Path** = (should point to VS Code)

4. **Check Network Settings**:
   - **Editor → Editor Settings**
   - **Network → Language Server**
   - **Port** = 6005 (default)

### **PHASE 5: TEST CONNECTION**

1. **Start Godot FIRST**
   - Open Godot
   - Open your A1-NeuroVis project
   - **Wait for full load** (important!)

2. **Then Start VS Code**
   - Open VS Code
   - Open project folder
   - **Wait 15 seconds**

3. **Test Connection**:
   - Open any `.gd` file
   - Type: `print(`
   - **Should see autocomplete**

## 🚨 **TROUBLESHOOTING BY ERROR**

### **Error: "Cannot launch Godot editor"**
**Cause**: Wrong executable path
**Fix**: 
```bash
# Find your actual Godot path
find /Applications -name "Godot" -type f 2>/dev/null
# Use the EXACT path in VS Code settings
```

### **Error: "Couldn't connect to language server"**
**Cause**: Port mismatch or Godot not running
**Fix**:
1. **Check Godot is running first**
2. **Check port in Godot**: Editor Settings → Network → Language Server
3. **Match port in VS Code**: `godot_tools.gdscript_lsp_server_port`

### **Error: "Valid values: main, current, pinned"**
**Cause**: Invalid scene parameter in launch.json
**Fix**: ✅ **Already fixed in your project**

## 🎯 **QUICK DIAGNOSTIC COMMANDS**

```bash
# Check if Godot is installed
ls -la /Applications/Godot*

# Check if Godot is in PATH
which godot

# Check VS Code Godot Tools extension
code --list-extensions | grep godot

# Test network connection
nc -zv 127.0.0.1 6005
```

## ✅ **SUCCESS INDICATORS**

**You'll know it's working when:**
- ✅ No error popups in VS Code
- ✅ Bottom status bar shows "Godot Tools"
- ✅ Typing in .gd files shows autocompletion
- ✅ F5 launches your project successfully
- ✅ Syntax highlighting works in .gd files

## 🆘 **IF NOTHING WORKS**

### **Nuclear Option: Fresh Start**
1. **Delete** `.vscode` folder in your project
2. **Uninstall** Godot Tools extension
3. **Restart** VS Code completely
4. **Reinstall** Godot Tools extension
5. **Follow Phase 2-5 again**

### **Alternative: Use Godot's Built-in Editor**
If VS Code integration fails, you can still:
- Use Godot's built-in script editor
- Use external text editor mode
- Use VS Code without language server features

## 📞 **EMERGENCY SUPPORT**

If you're still stuck:
1. **Run the detection script** and share output
2. **Check what's in Applications folder**: `ls -la /Applications/Godot*`
3. **Share exact error messages** with screenshots
4. **Verify Godot version**: Should be 4.x

---
**⚡ The key is EXACT paths and CORRECT startup order!**
