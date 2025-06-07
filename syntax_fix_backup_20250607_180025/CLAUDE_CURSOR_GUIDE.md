# Claude AI in Cursor - NeuroVis Project Guide

This guide provides instructions for using Claude AI effectively in Cursor for the NeuroVis project.

## 🚀 Getting Started

Claude has been configured with the following settings:
- Model: `claude-3-haiku-20240307` (fast, efficient for coding)
- Inline suggestions enabled
- Custom keyboard shortcuts

## ⌨️ Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Start Claude chat | `Alt+L` |
| Toggle inline suggestions | `Alt+\` |
| Accept suggestion | `Tab` |
| Cancel suggestion | `Escape` |
| Open context panel | `Cmd+K Cmd+C` |
| Edit selected code | `Cmd+K Cmd+E` |
| Edit entire document | `Cmd+K Cmd+D` |
| Generate tests | `Cmd+K Cmd+T` |
| Fix selected code | `Cmd+K Cmd+F` |

## 📋 Helpful Snippets

Type these prefixes and press `Tab` to expand:

- `claude-context` - Add detailed context for Claude about NeuroVis
- `gdclass` - Create a new GDScript class with proper documentation
- `claude-help` - Quick template to ask Claude for help

## 🧠 Using Claude Context Effectively

For best results with Claude AI in the NeuroVis project:

1. **Add Clear Context**
   ```gdscript
   // @claude context:
   // This is a GDScript file for NeuroVis, an educational brain visualization platform
   // Current file handles [specific purpose]
   // Related files: [list related files]
   ```

2. **Explain Project Patterns**
   - Mention it's an educational project for medical students
   - Explain the file is part of core/ai, ui/components, etc.
   - Reference design patterns we follow

3. **Use Specific Prompts**
   - "Implement a method that..." (specific task)
   - "Debug this error: ..." (paste error)
   - "Refactor this code to..." (clear goal)

## 🔄 Godot-Specific Tips

- When writing GDScript, Claude understands Godot's node structure
- Explain signal connections and scene tree relationships
- Tell Claude which autoloads are available (KB, KnowledgeService, etc.)
- For complex Godot nodes, briefly explain their purpose

## 📂 Example Workflow

1. Open a file you want to modify
2. Add context with `claude-context` snippet
3. Press `Alt+L` to open Claude chat
4. Ask Claude to help with a specific task
5. Review suggestions and accept with `Tab`
6. Test in Godot to ensure it works

## 🔧 Customizing Further

To adjust Claude settings:
1. Open settings with `Cmd+,`
2. Search for "cursor.ai" to find all Claude-related settings
3. Modify to your preferences

---

Happy coding with Claude in the NeuroVis project!