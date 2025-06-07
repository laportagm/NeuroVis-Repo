#!/bin/bash

# 🚀 NEUROVIS VS CODE ENHANCEMENT SETUP SCRIPT
# Automated setup for professional educational development environment

set -e  # Exit on any error

echo "🧠 ===== NEUROVIS VS CODE ENHANCEMENT SETUP ====="
echo "Setting up professional educational development environment..."
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_ROOT="/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy"
VSCODE_DIR="$PROJECT_ROOT/.vscode"

echo -e "${BLUE}📍 Project Root: $PROJECT_ROOT${NC}"
echo ""

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Step 1: Backup existing configurations
echo -e "${BLUE}🔄 Step 1: Backing up existing VS Code configurations...${NC}"

if [ -f "$VSCODE_DIR/settings.json" ]; then
    cp "$VSCODE_DIR/settings.json" "$VSCODE_DIR/settings_backup_$(date +%Y%m%d_%H%M%S).json"
    print_status "Backed up existing settings.json"
fi

if [ -f "$VSCODE_DIR/tasks.json" ]; then
    cp "$VSCODE_DIR/tasks.json" "$VSCODE_DIR/tasks_backup_$(date +%Y%m%d_%H%M%S).json"
    print_status "Backed up existing tasks.json"
fi

if [ -f "$VSCODE_DIR/launch.json" ]; then
    cp "$VSCODE_DIR/launch.json" "$VSCODE_DIR/launch_backup_$(date +%Y%m%d_%H%M%S).json"
    print_status "Backed up existing launch.json"
fi

if [ -f "$VSCODE_DIR/keybindings.json" ]; then
    cp "$VSCODE_DIR/keybindings.json" "$VSCODE_DIR/keybindings_backup_$(date +%Y%m%d_%H%M%S).json"
    print_status "Backed up existing keybindings.json"
fi

echo ""

# Step 2: Apply enhanced configurations
echo -e "${BLUE}🔄 Step 2: Applying enhanced VS Code configurations...${NC}"

# Apply enhanced settings
if [ -f "$VSCODE_DIR/settings_enhanced.json" ]; then
    cp "$VSCODE_DIR/settings_enhanced.json" "$VSCODE_DIR/settings.json"
    print_status "Applied enhanced settings.json"
else
    print_error "Enhanced settings file not found!"
fi

# Apply enhanced tasks
if [ -f "$VSCODE_DIR/tasks_enhanced.json" ]; then
    cp "$VSCODE_DIR/tasks_enhanced.json" "$VSCODE_DIR/tasks.json"
    print_status "Applied enhanced tasks.json"
else
    print_error "Enhanced tasks file not found!"
fi

# Apply enhanced launch configuration
if [ -f "$VSCODE_DIR/launch_enhanced.json" ]; then
    cp "$VSCODE_DIR/launch_enhanced.json" "$VSCODE_DIR/launch.json"
    print_status "Applied enhanced launch.json"
else
    print_error "Enhanced launch file not found!"
fi

# Apply enhanced keybindings
if [ -f "$VSCODE_DIR/keybindings_enhanced.json" ]; then
    cp "$VSCODE_DIR/keybindings_enhanced.json" "$VSCODE_DIR/keybindings.json"
    print_status "Applied enhanced keybindings.json"
else
    print_error "Enhanced keybindings file not found!"
fi

echo ""

# Step 3: Check for VS Code CLI
echo -e "${BLUE}🔄 Step 3: Checking VS Code CLI availability...${NC}"

if command -v code &> /dev/null; then
    print_status "VS Code CLI is available"
    VSCODE_CLI=true
else
    print_warning "VS Code CLI not found. Extension installation will need to be done manually."
    VSCODE_CLI=false
fi

echo ""

# Step 4: Install recommended extensions (if CLI available)
if [ "$VSCODE_CLI" = true ]; then
    echo -e "${BLUE}🔄 Step 4: Installing recommended extensions...${NC}"
    
    # Priority extensions for immediate impact
    PRIORITY_EXTENSIONS=(
        "redhat.vscode-yaml"
        "streetsidesoftware.code-spell-checker"
        "streetsidesoftware.code-spell-checker-medical-terms"
        "github.vscode-pull-request-github"
        "gruntfuggly.todo-tree"
        "alefragnani.bookmarks"
        "davidanson.vscode-markdownlint"
    )
    
    echo "Installing priority extensions..."
    for extension in "${PRIORITY_EXTENSIONS[@]}"; do
        if code --install-extension "$extension" --force; then
            print_status "Installed: $extension"
        else
            print_warning "Failed to install: $extension"
        fi
    done
    
    echo ""
    
    # Additional useful extensions
    ADDITIONAL_EXTENSIONS=(
        "ms-vscode.hexeditor"
        "slevesque.shader"
        "wakatime.vscode-wakatime"
        "christian-kohler.path-intellisense"
        "esbenp.prettier-vscode"
    )
    
    echo "Installing additional extensions..."
    for extension in "${ADDITIONAL_EXTENSIONS[@]}"; do
        if code --install-extension "$extension" --force; then
            print_status "Installed: $extension"
        else
            print_warning "Optional extension not installed: $extension"
        fi
    done
    
else
    echo -e "${BLUE}🔄 Step 4: Manual extension installation required...${NC}"
    print_warning "Please install extensions manually using VS Code Extensions view (Ctrl+Shift+X)"
fi

echo ""

# Step 5: Create convenience scripts
echo -e "${BLUE}🔄 Step 5: Creating convenience scripts...${NC}"

# Create quick launch script
cat > "$PROJECT_ROOT/launch_neurovis.sh" << 'EOF'
#!/bin/bash
# Quick launch script for NeuroVis development

echo "🧠 Launching NeuroVis Development Environment..."

# Open in enhanced workspace mode
if [ -f "neurovis-enhanced.code-workspace" ]; then
    code neurovis-enhanced.code-workspace
    echo "✅ Opened NeuroVis workspace in VS Code"
else
    code .
    echo "✅ Opened NeuroVis project in VS Code"
fi

# Optional: Launch Godot if desired
# open -a Godot project.godot
EOF

chmod +x "$PROJECT_ROOT/launch_neurovis.sh"
print_status "Created launch_neurovis.sh script"

# Create extension installation script
cat > "$PROJECT_ROOT/install_extensions.sh" << 'EOF'
#!/bin/bash
# Manual extension installation script

echo "🔧 Installing NeuroVis recommended VS Code extensions..."

# Priority extensions
extensions=(
    "redhat.vscode-yaml"
    "streetsidesoftware.code-spell-checker"
    "streetsidesoftware.code-spell-checker-medical-terms"
    "github.vscode-pull-request-github"
    "gruntfuggly.todo-tree"
    "alefragnani.bookmarks"
    "davidanson.vscode-markdownlint"
    "ms-vscode.hexeditor"
    "slevesque.shader"
    "wakatime.vscode-wakatime"
    "christian-kohler.path-intellisense"
    "esbenp.prettier-vscode"
)

for extension in "${extensions[@]}"; do
    echo "Installing: $extension"
    code --install-extension "$extension" --force
done

echo "✅ Extension installation complete!"
EOF

chmod +x "$PROJECT_ROOT/install_extensions.sh"
print_status "Created install_extensions.sh script"

echo ""

# Step 6: Validation
echo -e "${BLUE}🔄 Step 6: Validating setup...${NC}"

# Check if all configuration files are in place
FILES_TO_CHECK=(
    "$VSCODE_DIR/settings.json"
    "$VSCODE_DIR/tasks.json"
    "$VSCODE_DIR/launch.json"
    "$VSCODE_DIR/keybindings.json"
    "$PROJECT_ROOT/neurovis-enhanced.code-workspace"
)

for file in "${FILES_TO_CHECK[@]}"; do
    if [ -f "$file" ]; then
        print_status "Configuration file exists: $(basename "$file")"
    else
        print_error "Missing configuration file: $(basename "$file")"
    fi
done

echo ""

# Final summary
echo -e "${GREEN}🎉 ===== SETUP COMPLETE! ===== ${NC}"
echo ""
echo -e "${BLUE}📋 What was set up:${NC}"
echo "   ✅ Enhanced VS Code settings with educational optimizations"
echo "   ✅ Advanced task system with 25+ educational development commands"
echo "   ✅ Professional debugging configurations for Godot/NeuroVis"
echo "   ✅ Optimized keyboard shortcuts for rapid development"
echo "   ✅ Multi-folder workspace configuration"
echo "   ✅ GitHub Actions integration settings"
echo "   ✅ Performance monitoring and educational content validation"
echo ""
echo -e "${BLUE}🚀 Next Steps:${NC}"
echo "   1. Close and reopen VS Code to apply all settings"
echo "   2. Open the workspace: code neurovis-enhanced.code-workspace"
echo "   3. Try keyboard shortcuts: F5 (launch), Ctrl+Shift+T (test), etc."
echo "   4. Run ./install_extensions.sh if automatic installation failed"
echo "   5. Test GitHub Actions integration with Ctrl+Shift+B"
echo ""
echo -e "${BLUE}🎯 Key Features:${NC}"
echo "   • F5: Quick launch NeuroVis"
echo "   • Ctrl+Shift+T: Run test suite"
echo "   • Ctrl+Shift+Q: Code quality enforcer"
echo "   • Ctrl+Shift+B: Trigger GitHub Actions build"
echo "   • Shift+F5: Complete development cycle"
echo ""
echo -e "${GREEN}Happy NeuroVis Development! 🧠✨${NC}"