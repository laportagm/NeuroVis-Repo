# Cleanup Folder Analysis

**Purpose:** Deep folder analysis to identify problematic, unused, and deprecated files in NeuroVis project
**MCP Servers:** filesystem, sequential-thinking, memory
**Autoload Integration:** Analyzes impact on NeuroVis core services and educational workflows

## Command

```bash
claude execute --mcp-server filesystem,sequential-thinking,memory --prompt 'You are an expert NeuroVis project cleanup specialist with deep Godot 4.4, GDScript, and educational medical visualization expertise. Perform comprehensive analysis of the specified folder to identify problematic files.

TARGET FOLDER: ${1:-/Users/gagelaporta/Desktop/Neuro/NeuroVis-Repo/}

CLEANUP ANALYSIS WORKFLOW:

**Phase 1: File Discovery & Cataloging**
1. Recursively scan target folder and all subfolders
2. Create comprehensive file inventory with metadata
3. Categorize by file type (.gd, .tscn, .tres, .json, .md, etc.)
4. Identify file relationships and dependencies
5. Map educational content and medical accuracy implications

**Phase 2: Backup & Duplicate Detection**
1. Identify backup files (*.backup, *_backup.*, *_old.*, etc.)
2. Find duplicate class names across different locations
3. Detect versioned files (*_v1.*, *_v2.*, *_old, *_new, etc.)
4. Locate temporary files (*~, *.tmp, *.temp, etc.)
5. Identify conflicting educational content duplicates

**Phase 3: Deprecated & Unused File Analysis**
1. Scan for outdated Godot 3.x syntax in .gd files
2. Identify unused scene files not referenced in project
3. Find orphaned educational assets and 3D models
4. Detect deprecated autoload service implementations
5. Locate unused UI themes and educational components

**Phase 4: Conflict & Error Source Detection**
1. Find class name conflicts causing "hides global script class" errors
2. Identify files with parse errors and syntax issues
3. Detect broken educational workflow dependencies
4. Locate files causing autoload service conflicts
5. Find accessibility compliance violations in UI files

**Phase 5: Educational Integrity Assessment**
1. Identify outdated medical terminology or accuracy standards
2. Find deprecated learning pathway implementations
3. Detect unused 3D brain model variations
4. Locate obsolete accessibility compliance code
5. Identify conflicting educational objective definitions

**Phase 6: Performance Impact Analysis**
1. Find files causing 60fps performance degradation
2. Identify memory-intensive unused educational modules
3. Detect oversized 3D assets not meeting optimization standards
4. Locate inefficient rendering code in visualization components
5. Find accessibility overhead in unused UI components

**ANALYSIS CRITERIA FOR NEUROVIS:**
- **Educational Relevance:** Does file serve current learning objectives?
- **Medical Accuracy:** Is content medically current and accurate?
- **Accessibility Compliance:** Meets WCAG 2.1 AA standards?
- **Performance Impact:** Affects 60fps educational experience?
- **Autoload Integration:** Conflicts with core services?
- **3D Visualization:** Supports current brain model standards?
- **Code Quality:** Follows GDScript 4.4 best practices?

**CLEANUP RECOMMENDATIONS:**
For each problematic file, provide:
1. **Issue Type:** Backup/Duplicate/Deprecated/Conflict/Unused
2. **Educational Impact:** Effect on learning workflows
3. **Medical Accuracy Risk:** Potential for outdated content
4. **Performance Cost:** Memory/CPU/rendering impact
5. **Safe Removal:** Whether file can be safely deleted
6. **Alternative Action:** Move to archive, update, or refactor
7. **Dependencies:** What relies on this file

**OUTPUT FORMAT:**
```
# FOLDER CLEANUP ANALYSIS: [FOLDER_PATH]

## SUMMARY
- Total Files Scanned: [count]
- Problematic Files Found: [count]
- Safe Deletions: [count]
- Requires Review: [count]
- Educational Impact: [Low/Medium/High]

## CRITICAL ISSUES (Fix First)
### Class Name Conflicts
- [filename] - Conflicts with [other_file] - BLOCKS PROJECT COMPILATION
- [educational_impact_assessment]

### Parse Error Sources
- [filename] - [specific_error] - PREVENTS AUTOLOAD LOADING
- [medical_accuracy_risk_assessment]

## SAFE DELETIONS
### Backup Files
- [filename] - Created [date] - Safe to delete
- [educational_content_verification]

### Duplicate Educational Content
- [filename] - Duplicate of [primary_file] - Safe to remove
- [medical_accuracy_maintained_by_primary]

## REQUIRES REVIEW
### Potentially Deprecated
- [filename] - Last modified [date] - Check educational relevance
- [learning_objective_impact]

### Performance Impact
- [filename] - [impact_description] - Consider optimization
- [60fps_target_assessment]

## RECOMMENDED ACTIONS
1. **Immediate Deletions:** [count] files
2. **Archive Candidates:** [count] files
3. **Update Required:** [count] files
4. **Further Investigation:** [count] files

## EDUCATIONAL WORKFLOW PROTECTION
- Core learning pathways: [PROTECTED/AT_RISK]
- Medical accuracy systems: [PROTECTED/AT_RISK]
- 3D brain visualization: [PROTECTED/AT_RISK]
- Accessibility compliance: [PROTECTED/AT_RISK]
```

Store analysis in memory with tags: ["cleanup-analysis", "folder-[folder_name]", "maintenance"] for tracking cleanup progress.'
```

## Usage Examples

**Clean specific problem area:**
```bash
claude-code cleanup-folder core/ai/
```

**Clean backup contamination:**
```bash
claude-code cleanup-folder backups_20250607_150730/
```

**Clean educational modules:**
```bash
claude-code cleanup-folder core/education/
```

**Clean UI components:**
```bash
claude-code cleanup-folder ui/panels/
```

**Clean entire project (use carefully):**
```bash
claude-code cleanup-folder ./
```

## Educational Context

This command protects NeuroVis educational integrity by:
- **Medical Accuracy:** Identifying outdated medical terminology or standards
- **Learning Workflows:** Protecting core educational pathways from broken dependencies
- **3D Visualization:** Maintaining brain model optimization and performance
- **Accessibility:** Preserving WCAG 2.1 AA compliance implementations
- **Student Experience:** Ensuring 60fps performance targets are maintained

## Safety Features

- **Educational Content Protection:** Never recommends deletion of active learning materials
- **Medical Accuracy Preservation:** Flags potential medical content risks
- **Accessibility Compliance:** Protects WCAG-critical implementations
- **Autoload Safety:** Identifies dependencies before suggesting removals
- **Performance Monitoring:** Considers impact on 60fps educational experience

## Integration with NeuroVis Architecture

- **Autoload Awareness:** Understands KB, KnowledgeService, AIAssistant dependencies
- **Educational Module Protection:** Preserves learning objective completion systems
- **3D Model Optimization:** Maintains brain visualization performance standards
- **UI Theme Consistency:** Protects Enhanced/Minimal educational theming
- **Medical Content Validation:** Ensures anatomical accuracy systems remain intact

## File Type Specific Analysis

### GDScript Files (.gd)
- **Class Name Conflicts:** Multiple classes with same name
- **Godot Version Compatibility:** Outdated syntax patterns
- **Autoload Dependencies:** Files breaking singleton services
- **Educational Logic:** Deprecated learning pathway implementations
- **Performance Code:** Inefficient 3D rendering or UI code

### Scene Files (.tscn)
- **Orphaned Scenes:** Not referenced in project structure
- **Broken Dependencies:** Missing script or resource references
- **Educational Workflows:** Deprecated learning interface scenes
- **Accessibility Issues:** Non-compliant UI implementations
- **Performance Overhead:** Unoptimized 3D or UI scenes

### Resource Files (.tres, .res)
- **Unused Resources:** Not referenced by active scenes
- **Educational Assets:** Outdated learning materials or assessments
- **Theme Resources:** Deprecated UI theme implementations
- **3D Assets:** Unoptimized brain models or materials
- **Audio Resources:** Unused educational narration or feedback

### Documentation Files (.md)
- **Outdated Documentation:** Inconsistent with current implementation
- **Duplicate Guides:** Multiple files covering same topics
- **Educational Content:** Deprecated learning objectives or standards
- **Architecture Docs:** Not reflecting current system design
- **Setup Instructions:** Obsolete installation or configuration steps

### Configuration Files (.json, .cfg)
- **Unused Configurations:** Not loaded by current systems
- **Educational Settings:** Deprecated learning preference files
- **Performance Configs:** Outdated optimization settings
- **Accessibility Configs:** Superseded compliance implementations
- **Development Configs:** Obsolete debugging or testing setups

## Cleanup Categories

### 🔴 Critical Issues (Fix Immediately)
- **Compilation Blockers:** Class conflicts, parse errors
- **Autoload Failures:** Broken singleton dependencies
- **Educational Workflow Breaks:** Learning pathway failures
- **Medical Accuracy Risks:** Outdated clinical information
- **Accessibility Violations:** WCAG compliance breaks

### 🟡 Safe Deletions (Remove After Verification)
- **Backup Files:** Clear timestamp and purpose backups
- **Duplicate Content:** Verified identical educational materials
- **Temporary Files:** Development artifacts and build residue
- **Version Archives:** Clearly marked historical versions
- **Unused Assets:** Confirmed non-referenced educational resources

### 🔵 Requires Review (Manual Decision Needed)
- **Potentially Deprecated:** May still serve educational purpose
- **Performance Impact:** Optimization vs. feature trade-offs
- **Educational Content:** Medical accuracy validation needed
- **Accessibility Features:** Compliance impact assessment required
- **Historical Documentation:** Educational value vs. maintenance cost

### 🟢 Archive Candidates (Preserve but Relocate)
- **Educational History:** Previous learning objective implementations
- **Research Code:** Experimental educational features
- **Reference Materials:** Educational standards or medical guidelines
- **Development Tools:** Project-specific utilities and scripts
- **Legacy Compatibility:** Backward compatibility implementations

## Memory Integration

Analysis results enable persistent cleanup tracking:
- **Progress Monitoring:** Track cleanup completion across sessions
- **Issue Correlation:** Identify patterns in problematic files
- **Educational Impact:** Monitor learning workflow stability
- **Performance Trends:** Track optimization improvements
- **Decision History:** Remember manual review outcomes

## Pre-Cleanup Checklist

Before running cleanup analysis:
1. **Backup Project:** Ensure recent backup of educational content
2. **Test Functionality:** Verify current educational workflows work
3. **Document Dependencies:** Note any manual dependency knowledge
4. **Review Autoloads:** Confirm critical services are stable
5. **Check Performance:** Baseline current 60fps educational experience

## Post-Cleanup Validation

After implementing cleanup recommendations:
1. **Test Educational Workflows:** Verify learning pathways function
2. **Validate Medical Accuracy:** Confirm content standards maintained
3. **Check Accessibility:** Ensure WCAG 2.1 AA compliance preserved
4. **Monitor Performance:** Verify 60fps target still achieved
5. **Test Autoload Services:** Confirm KB, KnowledgeService, AIAssistant work

This command serves as your comprehensive file maintenance tool for keeping the NeuroVis educational platform clean, optimized, and focused on delivering high-quality medical education experiences.
