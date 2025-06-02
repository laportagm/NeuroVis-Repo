# Intelligent File Organization Command

## Usage
```bash
claude -f .claude/commands/auto-organize.md
```

## Command
```
Role: NeuroVis project architect specializing in educational platform organization.

Context: Educational neuroscience visualization platform with modular architecture defined in CLAUDE.md.

Task: Analyze current project structure and automatically organize files according to NeuroVis educational standards.

Organization Rules:
1. **Core Systems** (`core/`)
   - `core/knowledge/` - Educational content services, search, normalization
   - `core/ai/` - Educational AI assistance, tutoring systems  
   - `core/interaction/` - 3D selection, camera controls, educational workflows
   - `core/models/` - Educational 3D model management, layer visualization
   - `core/systems/` - Educational analytics, progress tracking, debugging

2. **Educational UI** (`ui/`)
   - `ui/components/` - Reusable educational interface elements
   - `ui/panels/` - Educational information displays, study interfaces
   - `ui/theme/` - Educational design system, accessibility themes

3. **Educational Workflows** (`scenes/`)
   - `scenes/main/` - Primary educational interface scenes
   - `scenes/debug/` - Educational testing and debugging scenes

4. **Educational Assets** (`assets/`)
   - `assets/data/` - Anatomical knowledge base, educational metadata
   - `assets/models/` - 3D educational models with learning context

Process:
1. Scan all files for proper placement according to educational function
2. Identify misplaced files that violate NeuroVis architecture
3. Suggest safe file moves with educational context preservation
4. Validate naming conventions match directory standards
5. Ensure educational purpose is documented for new locations

Safety Rules:
- NEVER move files referenced in project.godot autoloads
- PRESERVE all educational 3D models in assets/models/
- MAINTAIN anatomical_data.json educational content integrity
- PROTECT .git/ and configuration files

Output:
- List of files requiring organization with educational rationale
- Safe move commands preserving educational context
- Updated import path suggestions for educational references
- Educational architecture compliance summary

Execute with educational platform focus and NeuroVis standards compliance.
```