#!/bin/bash

# install_vscode_extensions.sh
# Script to install all recommended VS Code extensions for NeuroVis development

echo "========================================"
echo "VS Code Extension Installer for NeuroVis"
echo "========================================"
echo ""

# Check if VS Code CLI is available
if ! command -v code &> /dev/null; then
    echo "❌ Error: VS Code CLI 'code' command not found!"
    echo ""
    echo "To install it:"
    echo "1. Open VS Code"
    echo "2. Press Cmd+Shift+P"
    echo "3. Type 'Shell Command: Install 'code' command in PATH'"
    echo "4. Run this script again"
    exit 1
fi

echo "✅ VS Code CLI found"
echo ""

# Required extensions
echo "📦 Installing Required Extensions..."
echo "-----------------------------------"

echo "Installing Godot Tools..."
code --install-extension geequlim.godot-tools

echo "Installing C# Extensions..."
code --install-extension ms-dotnettools.csharp
code --install-extension ms-dotnettools.csdevkit
code --install-extension ms-vscode.csharp

echo ""
echo "📦 Installing Code Quality Extensions..."
echo "---------------------------------------"

echo "Installing EditorConfig..."
code --install-extension editorconfig.editorconfig

echo "Installing Prettier..."
code --install-extension esbenp.prettier-vscode

echo "Installing markdownlint..."
code --install-extension davidanson.vscode-markdownlint

echo ""
echo "📦 Installing Git Extensions..."
echo "-------------------------------"

echo "Installing GitLens..."
code --install-extension eamodio.gitlens

echo "Installing Git Graph..."
code --install-extension mhutchie.git-graph

echo ""
echo "📦 Installing Productivity Extensions..."
echo "---------------------------------------"

echo "Installing Todo Tree..."
code --install-extension gruntfuggly.todo-tree

echo "Installing Better Comments..."
code --install-extension aaron-bond.better-comments

echo "Installing Path Intellisense..."
code --install-extension christian-kohler.path-intellisense

echo "Installing Code Spell Checker..."
code --install-extension streetsidesoftware.code-spell-checker

echo "Installing Todo Highlight..."
code --install-extension wayou.vscode-todo-highlight

echo "Installing Error Lens..."
code --install-extension usernamehw.errorlens

echo ""
echo "📦 Installing Documentation Extensions..."
echo "----------------------------------------"

echo "Installing Draw.io..."
code --install-extension hediet.vscode-drawio

echo "Installing Markdown Preview Enhanced..."
code --install-extension shd101wyy.markdown-preview-enhanced

echo "Installing Markdown All in One..."
code --install-extension yzhang.markdown-all-in-one

echo "Installing Markdown Mermaid..."
code --install-extension bierner.markdown-mermaid

echo ""
echo "📦 Installing AI Assistant Extensions..."
echo "---------------------------------------"

echo "Installing GitHub Copilot..."
code --install-extension github.copilot

echo "Installing GitHub Copilot Chat..."
code --install-extension github.copilot-chat

echo ""
echo "📦 Installing Additional Extensions..."
echo "-------------------------------------"

echo "Installing Test Explorer UI..."
code --install-extension hbenl.vscode-test-explorer

echo "Installing Project Manager..."
code --install-extension alefragnani.project-manager

echo "Installing Rainbow CSV..."
code --install-extension mechatroner.rainbow-csv

echo "Installing XML Tools..."
code --install-extension DotJoshJohnson.xml

echo "Installing YAML Support..."
code --install-extension redhat.vscode-yaml

echo ""
echo "========================================"
echo "✅ Extension installation complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Restart VS Code"
echo "2. Open the workspace file: neurovis-enhanced.code-workspace"
echo "3. Check View → Extensions to verify all extensions are installed"
echo "4. Review docs/dev/VSCODE_EXTENSION_SETUP_GUIDE.md for configuration"
echo ""
echo "To apply enhanced settings:"
echo "- Copy settings from VSCODE_ENHANCED_SETTINGS.json to .vscode/settings.json"
echo ""

# Make the script executable
chmod +x "$0"