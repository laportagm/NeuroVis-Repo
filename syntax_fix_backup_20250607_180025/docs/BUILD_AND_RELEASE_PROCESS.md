# NeuroVis Build and Release Process

## Overview
This document outlines the complete build and release process for NeuroVis, including version management, building for multiple platforms, testing procedures, and distribution.

## Table of Contents
1. [Version Management](#version-management)
2. [Pre-Build Checklist](#pre-build-checklist)
3. [Build Process](#build-process)
4. [Testing Procedures](#testing-procedures)
5. [Release Process](#release-process)
6. [Post-Release Tasks](#post-release-tasks)

---

## Version Management

### Version Numbering
We follow Semantic Versioning (SemVer): `MAJOR.MINOR.PATCH`

- **MAJOR**: Incompatible API changes or major feature additions
- **MINOR**: Backwards-compatible functionality additions
- **PATCH**: Backwards-compatible bug fixes

### Version Locations
Update version numbers in these files:
1. `project.godot` - application/config/version
2. `scripts/build_and_package.sh` - VERSION variable
3. `docs/CHANGELOG.md` - Add new version entry
4. `README.md` - Update version badge

---

## Pre-Build Checklist

### Code Quality
- [ ] All tests pass: `./run_tests.sh all`
- [ ] No critical performance issues: Check PerformanceMonitor
- [ ] Code linting passes (if configured)
- [ ] No debug print statements in production code

### Documentation
- [ ] README.md is up to date
- [ ] CHANGELOG.md includes all changes
- [ ] API documentation is current
- [ ] User guide reflects new features

### Assets
- [ ] All 3D models are optimized
- [ ] Textures are compressed appropriately
- [ ] Icons are present for all platforms:
  - Windows: `icon.ico` (256x256)
  - macOS: `icon.icns` (1024x1024)
  - Linux: `icon.png` (512x512)

### Legal
- [ ] LICENSE file is present
- [ ] Third-party licenses documented in LICENSES.md
- [ ] Copyright headers updated

---

## Build Process

### Prerequisites

#### macOS
```bash
# Install Godot 4.4.1
brew install --cask godot

# For DMG creation
brew install create-dmg

# For code signing (optional)
# Requires Apple Developer account
```

#### Windows
```powershell
# Install Godot 4.4.1
winget install GodotEngine.GodotEngine

# Install NSIS for installer creation
winget install NSIS.NSIS

# Install Visual Studio Build Tools
winget install Microsoft.VisualStudio.2022.BuildTools
```

#### Linux
```bash
# Install Godot 4.4.1
sudo snap install godot-4 --classic

# For AppImage creation
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
```

### Export Presets Configuration

1. Open project in Godot
2. Go to Project → Export
3. Add presets for each platform:

#### Windows Desktop
- **Export Path**: `builds/windows/NeuroVis.exe`
- **Binary Format**: 64-bit
- **Icon**: Set custom icon
- **Company Name**: NeuroVis Team
- **Product Name**: NeuroVis
- **File Version**: Match project version
- **Product Version**: Match project version

#### macOS
- **Export Path**: `builds/macos/NeuroVis.app`
- **Application Bundle Identifier**: `com.neurovis.app`
- **Icon**: Set custom .icns file
- **Version**: Match project version
- **Copyright**: Current year and team
- **High Resolution**: Yes
- **Code Signing**: Enable if certificates available

#### Linux/X11
- **Export Path**: `builds/linux/NeuroVis`
- **Binary Format**: 64-bit
- **Icon**: Set custom icon

### Building

#### Automated Build
```bash
# Build all platforms
./scripts/build_and_package.sh all

# Build specific platform
./scripts/build_and_package.sh windows
./scripts/build_and_package.sh macos
./scripts/build_and_package.sh linux
```

#### Manual Build
1. Open Godot
2. Project → Export
3. Select platform preset
4. Click "Export Project"
5. Choose release mode
6. Export to appropriate directory

### Platform-Specific Post-Processing

#### Windows
1. Run NSIS installer script:
   ```cmd
   cd builds\windows
   makensis installer.nsi
   ```

2. Sign the executable (optional):
   ```powershell
   signtool sign /t http://timestamp.digicert.com /f certificate.pfx /p password NeuroVis.exe
   ```

#### macOS
1. Code sign the app (requires Apple Developer account):
   ```bash
   codesign --deep --force --verify --verbose --sign "Developer ID Application: Your Name" NeuroVis.app
   ```

2. Create DMG:
   ```bash
   ./scripts/create_dmg.sh
   ```

3. Notarize the DMG:
   ```bash
   xcrun notarytool submit NeuroVis-1.0.0-macOS.dmg --apple-id your@email.com --team-id TEAMID --wait
   ```

#### Linux
1. Create AppImage:
   ```bash
   ./appimagetool-x86_64.AppImage builds/linux/NeuroVis.AppDir
   ```

2. Make executable:
   ```bash
   chmod +x NeuroVis-x86_64.AppImage
   ```

---

## Testing Procedures

### Automated Testing
```bash
# Run all tests
./run_tests.sh all

# Platform-specific tests
./run_tests.sh windows  # Run on Windows
./run_tests.sh macos    # Run on macOS
./run_tests.sh linux    # Run on Linux
```

### Manual Testing Checklist

#### Core Functionality
- [ ] Application launches without errors
- [ ] 3D models load correctly
- [ ] Camera controls work (orbit, pan, zoom)
- [ ] Structure selection works
- [ ] Information panels display correctly
- [ ] AI Assistant connects and responds

#### Platform-Specific
- [ ] **Windows**: Installer works correctly
- [ ] **Windows**: Start menu shortcuts created
- [ ] **Windows**: Uninstaller removes all files
- [ ] **macOS**: DMG mounts correctly
- [ ] **macOS**: App runs without security warnings
- [ ] **macOS**: Retina display support works
- [ ] **Linux**: AppImage runs on Ubuntu 20.04+
- [ ] **Linux**: Desktop integration works

#### Performance
- [ ] Maintains 60 FPS with all models loaded
- [ ] Memory usage under 2GB
- [ ] No memory leaks during extended use

#### Edge Cases
- [ ] Works without internet connection
- [ ] Handles missing data files gracefully
- [ ] Recovers from API failures

---

## Release Process

### 1. Final Checks
```bash
# Ensure clean working directory
git status

# Run final test suite
./run_tests.sh all

# Build all platforms
./scripts/build_and_package.sh all
```

### 2. Create Release Tag
```bash
# Create annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tag
git push origin v1.0.0
```

### 3. GitHub Release
1. Go to GitHub repository → Releases → Create new release
2. Select the version tag
3. Title: "NeuroVis v1.0.0"
4. Description: Copy from CHANGELOG.md
5. Upload built files:
   - `NeuroVis-1.0.0-Setup.exe`
   - `NeuroVis-1.0.0-macOS.dmg`
   - `NeuroVis-x86_64.AppImage`
   - SHA256 checksum files

### 4. Distribution Channels

#### Official Website
```bash
# Upload to web server
scp builds/*.{exe,dmg,AppImage} user@server:/var/www/downloads/

# Update download page
# Update version in download links
```

#### Package Managers

**Homebrew (macOS)**
```ruby
# Update homebrew-neurovis/Formula/neurovis.rb
class Neurovis < Formula
  desc "3D Brain Visualization and Learning Tool"
  homepage "https://neurovis.app"
  url "https://github.com/neurovis/neurovis/releases/download/v1.0.0/NeuroVis-1.0.0-macOS.dmg"
  sha256 "YOUR_SHA256_HERE"
  version "1.0.0"
end
```

**Scoop (Windows)**
```json
{
    "version": "1.0.0",
    "description": "3D Brain Visualization and Learning Tool",
    "homepage": "https://neurovis.app",
    "license": "MIT",
    "url": "https://github.com/neurovis/neurovis/releases/download/v1.0.0/NeuroVis-1.0.0-Setup.exe",
    "hash": "YOUR_SHA256_HERE",
    "installer": {
        "script": "Start-Process -FilePath \"$dir\\NeuroVis-1.0.0-Setup.exe\" -ArgumentList '/S' -Wait"
    }
}
```

---

## Post-Release Tasks

### Immediate
- [ ] Announce release on social media
- [ ] Update website with new version
- [ ] Send release newsletter
- [ ] Monitor error reporting for critical issues

### Within 24 Hours
- [ ] Respond to user feedback
- [ ] Check download statistics
- [ ] Monitor performance metrics
- [ ] Address any critical bugs with hotfix

### Within 1 Week
- [ ] Gather user feedback
- [ ] Plan next version features
- [ ] Update roadmap
- [ ] Write blog post about release

### Hotfix Process
If critical issues are found:
1. Fix on `hotfix/1.0.1` branch
2. Test thoroughly
3. Build and release as patch version
4. Follow expedited release process

---

## Troubleshooting

### Common Build Issues

**Godot export templates missing**
```bash
# Download export templates
godot --download-export-templates
```

**Code signing failures (macOS)**
```bash
# Check certificate
security find-identity -v -p codesigning

# Clear code signature
xattr -cr NeuroVis.app
```

**NSIS compilation errors (Windows)**
- Ensure all referenced files exist
- Check path separators (use \\ in NSIS)
- Verify icon file format

### Performance Issues
- Enable release optimizations in export settings
- Ensure debug symbols are stripped
- Check texture import settings

---

## Appendix

### Build Script Options
```bash
./scripts/build_and_package.sh [options]
  windows  - Build Windows executable and installer
  macos    - Build macOS app and DMG
  linux    - Build Linux binary and AppImage
  all      - Build for all platforms
  clean    - Clean build directories
  test     - Run tests before building
```

### Environment Variables
```bash
export GODOT_PATH="/path/to/godot"
export SIGN_IDENTITY="Developer ID Application: Name"
export NOTARY_APPLE_ID="your@email.com"
export NOTARY_TEAM_ID="TEAMID"
```

### CI/CD Integration
For automated builds, see `.github/workflows/build.yml` for GitHub Actions configuration.
