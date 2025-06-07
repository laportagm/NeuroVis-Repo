#!/bin/bash
# NeuroVis Build and Package Script
# Creates distributable packages for Windows and macOS

set -e # Exit on error

echo "🏗️  NeuroVis Build & Package Script"
echo "==================================="
echo ""

# Configuration
PROJECT_NAME="NeuroVis"
PROJECT_PATH="/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy"
BUILD_PATH="$PROJECT_PATH/builds"
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"
VERSION="1.0.0"
BUILD_DATE=$(date +%Y%m%d)

# Check Godot installation
if [ ! -f "$GODOT_PATH" ]; then
    echo "❌ Error: Godot not found at $GODOT_PATH"
    exit 1
fi

# Create build directory
mkdir -p "$BUILD_PATH"
mkdir -p "$BUILD_PATH/windows"
mkdir -p "$BUILD_PATH/macos"
mkdir -p "$BUILD_PATH/linux"

# Function to build for a platform
build_platform() {
    local platform=$1
    local output_path=$2
    local export_preset=$3
    
    echo "📦 Building for $platform..."
    
    "$GODOT_PATH" --headless --path "$PROJECT_PATH" \
        --export-release "$export_preset" "$output_path"
    
    if [ $? -eq 0 ]; then
        echo "✅ $platform build complete!"
    else
        echo "❌ $platform build failed!"
        return 1
    fi
}

# Function to create macOS DMG
create_macos_dmg() {
    echo "💿 Creating macOS DMG..."
    
    local app_path="$BUILD_PATH/macos/$PROJECT_NAME.app"
    local dmg_path="$BUILD_PATH/$PROJECT_NAME-$VERSION-macOS.dmg"
    
    # Create temporary directory for DMG contents
    local temp_dir="$BUILD_PATH/dmg_temp"
    rm -rf "$temp_dir"
    mkdir -p "$temp_dir"
    
    # Copy app to temp directory
    cp -R "$app_path" "$temp_dir/"
    
    # Create Applications symlink
    ln -s /Applications "$temp_dir/Applications"
    
    # Create DMG
    hdiutil create -volname "$PROJECT_NAME $VERSION" \
        -srcfolder "$temp_dir" \
        -ov -format UDZO "$dmg_path"
    
    # Clean up
    rm -rf "$temp_dir"
    
    echo "✅ DMG created: $dmg_path"
}

# Function to create Windows installer
create_windows_installer() {
    echo "💿 Creating Windows installer..."
    
    # Create NSIS script
    cat > "$BUILD_PATH/windows/installer.nsi" << EOF
!define APP_NAME "NeuroVis"
!define APP_VERSION "$VERSION"
!define APP_PUBLISHER "NeuroVis Team"
!define APP_URL "https://neurovis.app"
!define APP_EXE "NeuroVis.exe"

Name "\${APP_NAME} \${APP_VERSION}"
OutFile "..\NeuroVis-\${APP_VERSION}-Setup.exe"
InstallDir "\$PROGRAMFILES64\\\${APP_NAME}"
InstallDirRegKey HKLM "Software\\\${APP_NAME}" "Install_Dir"
RequestExecutionLevel admin

!include "MUI2.nsh"

!define MUI_ICON "..\..\assets\icons\neurovis.ico"
!define MUI_UNICON "..\..\assets\icons\neurovis.ico"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\..\LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

Section "MainSection" SEC01
    SetOutPath "\$INSTDIR"
    File /r "*.*"
    
    ; Create shortcuts
    CreateDirectory "\$SMPROGRAMS\\\${APP_NAME}"
    CreateShortcut "\$SMPROGRAMS\\\${APP_NAME}\\\${APP_NAME}.lnk" "\$INSTDIR\\\${APP_EXE}"
    CreateShortcut "\$SMPROGRAMS\\\${APP_NAME}\\Uninstall.lnk" "\$INSTDIR\\uninstall.exe"
    CreateShortcut "\$DESKTOP\\\${APP_NAME}.lnk" "\$INSTDIR\\\${APP_EXE}"
    
    ; Write registry
    WriteRegStr HKLM "Software\\\${APP_NAME}" "Install_Dir" "\$INSTDIR"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\\${APP_NAME}" "DisplayName" "\${APP_NAME}"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\\${APP_NAME}" "UninstallString" '"\$INSTDIR\\uninstall.exe"'
    WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\\${APP_NAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\\${APP_NAME}" "NoRepair" 1
    WriteUninstaller "uninstall.exe"
SectionEnd

Section "Uninstall"
    Delete "\$INSTDIR\\*.*"
    RMDir /r "\$INSTDIR"
    Delete "\$SMPROGRAMS\\\${APP_NAME}\\*.*"
    RMDir "\$SMPROGRAMS\\\${APP_NAME}"
    Delete "\$DESKTOP\\\${APP_NAME}.lnk"
    
    DeleteRegKey HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\\${APP_NAME}"
    DeleteRegKey HKLM "Software\\\${APP_NAME}"
SectionEnd
EOF
    
    echo "✅ NSIS installer script created"
    echo "⚠️  Run makensis on Windows to build the installer"
}

# Function to create Linux AppImage
create_linux_appimage() {
    echo "📦 Creating Linux AppImage..."
    
    local app_dir="$BUILD_PATH/linux/NeuroVis.AppDir"
    mkdir -p "$app_dir"
    
    # Copy executable
    cp "$BUILD_PATH/linux/NeuroVis" "$app_dir/AppRun"
    chmod +x "$app_dir/AppRun"
    
    # Create desktop file
    cat > "$app_dir/NeuroVis.desktop" << EOF
[Desktop Entry]
Name=NeuroVis
Exec=AppRun
Icon=neurovis
Type=Application
Categories=Education;Science;
Comment=3D Brain Visualization and Learning Tool
EOF
    
    # Copy icon
    cp "$PROJECT_PATH/assets/icons/neurovis.png" "$app_dir/neurovis.png"
    
    echo "✅ AppImage structure created"
    echo "⚠️  Use appimagetool to build the final AppImage"
}

# Main build process
main() {
    echo "🚀 Starting build process..."
    echo "Version: $VERSION"
    echo "Build Date: $BUILD_DATE"
    echo ""
    
    # Check export presets
    if [ ! -f "$PROJECT_PATH/export_presets.cfg" ]; then
        echo "❌ Error: export_presets.cfg not found!"
        echo "Please configure export presets in Godot first."
        exit 1
    fi
    
    # Build for each platform
    case "$1" in
        "windows")
            build_platform "Windows" "$BUILD_PATH/windows/NeuroVis.exe" "Windows Desktop"
            create_windows_installer
            ;;
        "macos")
            build_platform "macOS" "$BUILD_PATH/macos/NeuroVis.app" "macOS"
            create_macos_dmg
            ;;
        "linux")
            build_platform "Linux" "$BUILD_PATH/linux/NeuroVis" "Linux/X11"
            create_linux_appimage
            ;;
        "all")
            # Build all platforms
            build_platform "Windows" "$BUILD_PATH/windows/NeuroVis.exe" "Windows Desktop"
            create_windows_installer
            
            build_platform "macOS" "$BUILD_PATH/macos/NeuroVis.app" "macOS"
            create_macos_dmg
            
            build_platform "Linux" "$BUILD_PATH/linux/NeuroVis" "Linux/X11"
            create_linux_appimage
            ;;
        *)
            echo "Usage: $0 [windows|macos|linux|all]"
            echo ""
            echo "Options:"
            echo "  windows - Build for Windows"
            echo "  macos   - Build for macOS"
            echo "  linux   - Build for Linux"
            echo "  all     - Build for all platforms"
            exit 1
            ;;
    esac
    
    # Create checksums
    echo ""
    echo "📝 Creating checksums..."
    cd "$BUILD_PATH"
    
    if [ -f "$PROJECT_NAME-$VERSION-macOS.dmg" ]; then
        shasum -a 256 "$PROJECT_NAME-$VERSION-macOS.dmg" > "$PROJECT_NAME-$VERSION-macOS.dmg.sha256"
    fi
    
    if [ -f "$PROJECT_NAME-$VERSION-Setup.exe" ]; then
        shasum -a 256 "$PROJECT_NAME-$VERSION-Setup.exe" > "$PROJECT_NAME-$VERSION-Setup.exe.sha256"
    fi
    
    echo ""
    echo "✅ Build complete!"
    echo "📁 Output directory: $BUILD_PATH"
    
    # List built files
    echo ""
    echo "Built files:"
    ls -la "$BUILD_PATH"/*.{dmg,exe,AppImage} 2>/dev/null || true
}

# Run main function
main "$@"
