# VS Code Extension Setup Guide for NeuroVis

This guide will help you properly configure all VS Code extensions for the NeuroVis educational neuroscience visualization platform.

## Table of Contents
1. [Required Extensions](#required-extensions)
2. [Recommended Extensions](#recommended-extensions)
3. [Extension Configuration](#extension-configuration)
4. [Workspace Settings](#workspace-settings)
5. [Debugging Setup](#debugging-setup)
6. [Code Quality Tools](#code-quality-tools)
7. [Troubleshooting](#troubleshooting)

## Required Extensions

These extensions are essential for NeuroVis development:

### 1. **Godot Tools** (`geequlim.godot-tools`)
- **Purpose**: GDScript language support, debugging, and IntelliSense
- **Install**: `code --install-extension geequlim.godot-tools`
- **Configuration**: Already configured in `.vscode/settings.json`

### 2. **C# Extension** (`ms-dotnettools.csharp`)
- **Purpose**: C# support for Godot C# scripts (if using)
- **Install**: `code --install-extension ms-dotnettools.csharp`

### 3. **C# Dev Kit** (`ms-dotnettools.csdevkit`)
- **Purpose**: Enhanced C# development experience
- **Install**: `code --install-extension ms-dotnettools.csdevkit`

## Recommended Extensions

### Code Quality & Formatting

#### 1. **EditorConfig** (`editorconfig.editorconfig`)
- **Purpose**: Maintain consistent coding styles across different editors
- **Install**: `code --install-extension editorconfig.editorconfig`

#### 2. **Prettier** (`esbenp.prettier-vscode`)
- **Purpose**: Code formatting for JSON, Markdown, YAML files
- **Install**: `code --install-extension esbenp.prettier-vscode`

#### 3. **markdownlint** (`davidanson.vscode-markdownlint`)
- **Purpose**: Markdown linting and style checking
- **Install**: `code --install-extension davidanson.vscode-markdownlint`

### Git & Version Control

#### 4. **GitLens** (`eamodio.gitlens`)
- **Purpose**: Enhanced Git capabilities and code authorship
- **Install**: `code --install-extension eamodio.gitlens`

#### 5. **Git Graph** (`mhutchie.git-graph`)
- **Purpose**: Visual Git history and branch management
- **Install**: `code --install-extension mhutchie.git-graph`

### Development Productivity

#### 6. **Todo Tree** (`gruntfuggly.todo-tree`)
- **Purpose**: Track TODO, FIXME, and other tags in code
- **Install**: `code --install-extension gruntfuggly.todo-tree`

#### 7. **Better Comments** (`aaron-bond.better-comments`)
- **Purpose**: Colorized comments for better code documentation
- **Install**: `code --install-extension aaron-bond.better-comments`

#### 8. **Path Intellisense** (`christian-kohler.path-intellisense`)
- **Purpose**: Autocomplete file paths in code
- **Install**: `code --install-extension christian-kohler.path-intellisense`

### Documentation & Visualization

#### 9. **Draw.io Integration** (`hediet.vscode-drawio`)
- **Purpose**: Create and edit diagrams within VS Code
- **Install**: `code --install-extension hediet.vscode-drawio`

#### 10. **Markdown Preview Enhanced** (`shd101wyy.markdown-preview-enhanced`)
- **Purpose**: Enhanced markdown preview with diagram support
- **Install**: `code --install-extension shd101wyy.markdown-preview-enhanced`

### AI & Productivity Assistants

#### 11. **GitHub Copilot** (`github.copilot`)
- **Purpose**: AI-powered code suggestions
- **Install**: `code --install-extension github.copilot`
- **Note**: Already configured in settings

#### 12. **GitHub Copilot Chat** (`github.copilot-chat`)
- **Purpose**: AI chat assistant for coding help
- **Install**: `code --install-extension github.copilot-chat`

### Testing & Debugging

#### 13. **Test Explorer UI** (`hbenl.vscode-test-explorer`)
- **Purpose**: UI for running and debugging tests
- **Install**: `code --install-extension hbenl.vscode-test-explorer`

### File Management

#### 14. **Project Manager** (`alefragnani.project-manager`)
- **Purpose**: Easily switch between projects
- **Install**: `code --install-extension alefragnani.project-manager`

## Extension Configuration

### Configure Godot Tools

The Godot extension is already configured in your project. Key settings:

```json
{
  "godot_tools.editor_path": "/Applications/Godot.app/Contents/MacOS/Godot",
  "godot_tools.gdscript.lsp.serverProtocol": "tcp",
  "godot_tools.gdscript.lsp.serverHost": "127.0.0.1",
  "godot_tools.gdscript.lsp.serverPort": 6005
}
```

### Configure Prettier

Add to your `.vscode/settings.json`:

```json
{
  "prettier.tabWidth": 4,
  "prettier.useTabs": true,
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[markdown]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```

### Configure Todo Tree

Add to your `.vscode/settings.json`:

```json
{
  "todo-tree.highlights.enabled": true,
  "todo-tree.highlights.defaultHighlight": {
    "icon": "alert",
    "type": "text",
    "foreground": "#ff0000",
    "background": "#ffffff",
    "opacity": 50,
    "iconColour": "#ff0000"
  },
  "todo-tree.general.tags": [
    "TODO",
    "FIXME",
    "XXX",
    "HACK",
    "WARNING",
    "NOTE",
    "EDUCATIONAL",
    "REFACTOR"
  ]
}
```

### Configure GitLens

Add to your `.vscode/settings.json`:

```json
{
  "gitlens.currentLine.enabled": false,
  "gitlens.hovers.currentLine.over": "line",
  "gitlens.codeLens.enabled": false
}
```

## Installation Script

Create and run this script to install all extensions at once:

```bash
#!/bin/bash
# install_vscode_extensions.sh

echo "Installing VS Code extensions for NeuroVis development..."

# Required extensions
code --install-extension geequlim.godot-tools
code --install-extension ms-dotnettools.csharp
code --install-extension ms-dotnettools.csdevkit

# Recommended extensions
code --install-extension editorconfig.editorconfig
code --install-extension esbenp.prettier-vscode
code --install-extension davidanson.vscode-markdownlint
code --install-extension eamodio.gitlens
code --install-extension mhutchie.git-graph
code --install-extension gruntfuggly.todo-tree
code --install-extension aaron-bond.better-comments
code --install-extension christian-kohler.path-intellisense
code --install-extension hediet.vscode-drawio
code --install-extension shd101wyy.markdown-preview-enhanced
code --install-extension github.copilot
code --install-extension github.copilot-chat
code --install-extension hbenl.vscode-test-explorer
code --install-extension alefragnani.project-manager

echo "Extension installation complete!"
```

## Workspace-Specific Settings

Your project uses a workspace file (`neurovis-enhanced.code-workspace`). To use it:

1. Open VS Code
2. File → Open Workspace from File...
3. Select `neurovis-enhanced.code-workspace`

This will apply all workspace-specific settings and folder organization.

## Debugging Setup

Your project has comprehensive debugging configurations in `.vscode/launch.json`:

1. **Launch Main Scene**: F5 to debug the main educational scene
2. **Launch Current Scene**: Debug the currently open scene
3. **Debug with Collisions**: Visual collision debugging
4. **Remote Debug Desktop**: For debugging exported builds
5. **Remote Debug Mobile**: For mobile platform debugging

## Code Quality Tools

### Pre-commit Hooks
Your project uses pre-commit hooks. Install them:

```bash
pre-commit install
```

### GDScript Linting
The project is configured for GDScript syntax validation and naming convention enforcement.

### Format on Save
Already configured in your settings:
- GDScript files format on save
- 4-space indentation (converted to tabs)
- Trailing whitespace removed

## Keyboard Shortcuts

Add these useful shortcuts to your `keybindings.json`:

```json
[
  {
    "key": "cmd+shift+g",
    "command": "workbench.action.tasks.runTask",
    "args": "Launch Godot Editor"
  },
  {
    "key": "cmd+shift+t",
    "command": "workbench.action.tasks.runTask",
    "args": "Run Tests"
  },
  {
    "key": "cmd+shift+d",
    "command": "workbench.action.tasks.runTask",
    "args": "Open Debug Console"
  }
]
```

## Troubleshooting

### Godot Tools Not Connecting

1. Ensure Godot editor is running
2. Check that Language Server Protocol is enabled in Godot:
   - Editor → Editor Settings → Network → Language Server
   - Enable "Use Language Server"
   - Set port to 6005

### Extensions Not Working

1. Reload VS Code window: `Cmd+Shift+P` → "Developer: Reload Window"
2. Check extension logs: View → Output → Select extension from dropdown
3. Ensure you're using the workspace file, not just opening the folder

### IntelliSense Issues

1. Delete `.godot` folder and restart Godot
2. In VS Code: `Cmd+Shift+P` → "Godot Tools: Restart Language Server"
3. Check that all autoload paths in `project.godot` are correct

## Next Steps

1. Install all recommended extensions
2. Open the workspace file
3. Run the project with F5 to test debugging
4. Try the various VS Code tasks (Cmd+Shift+P → "Tasks: Run Task")
5. Customize settings further based on your preferences

## Additional Resources

- [VS Code GDScript Guide](https://docs.godotengine.org/en/stable/tutorials/editor/external_editor.html)
- [NeuroVis Development Guide](./DEVELOPMENT_GUIDE.md)
- [Project Architecture Guide](./CORE_ARCHITECTURE_GUIDE.md)