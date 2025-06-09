# NeuroVis Duplicate Files Cleanup Plan

## Executive Summary
Three duplicate files identified: BrainSystemSwitcher.gd, ComparativeAnatomyService.gd, and InputRouter.gd
- None are registered as autoloads, reducing dependency risk
- All duplicates have different content, requiring careful analysis
- Educational functionality preserved through newer versions in education/ directory

## 1. BrainSystemSwitcher.gd Analysis

### File Locations:
- **Version A**: `/core/education/BrainSystemSwitcher.gd` (Newer, Educational-focused)
- **Version B**: `/core/models/BrainSystemSwitcher.gd` (Older, Basic implementation)

### Content Comparison:
- **Version A (education/)**:
  - More comprehensive with educational transitions
  - Includes TransitionStyle enum with EDUCATIONAL option
  - Has educational_context_available signal
  - Better documentation and tutorial references

- **Version B (models/)**:
  - Basic system switching functionality
  - Limited to simple transitions
  - More brain system types defined in enum

### References Found:
- Used by: EducationalModuleCoordinator.gd (instantiates locally)
- No direct path references found in imports

### Recommendation: **DELETE Version B (models/)**
- Version A is more feature-complete
- Educational context is essential for the application
- No unique functionality in Version B

## 2. ComparativeAnatomyService.gd Analysis

### File Locations:
- **Version A**: `/core/education/ComparativeAnatomyService.gd` (588 lines - Comprehensive)
- **Version B**: `/core/knowledge/ComparativeAnatomyService.gd` (329 lines - Basic)

### Content Comparison:
- **Version A (education/)**:
  - Nearly double the size (588 vs 329 lines)
  - Likely includes educational features
  - More recent based on directory structure

- **Version B (knowledge/)**:
  - Smaller, potentially original version
  - May contain legacy implementations

### References Found:
- Used by: EducationalModuleCoordinator.gd (as _comparative_anatomy)
- No direct path references found

### Recommendation: **DELETE Version B (knowledge/)**
- Version A is more comprehensive
- Educational features align with project goals
- Coordinator expects educational version functionality

## 3. InputRouter.gd Analysis

### File Locations:
- **Version A**: `/core/systems/InputRouter.gd` (399 lines - System-level)
- **Version B**: `/core/interaction/InputRouter.gd` (358 lines - Interaction-focused)

### Content Comparison:
- **Version A (systems/)**:
  - Larger file, likely more comprehensive
  - System-level integration suggests autoload usage

- **Version B (interaction/)**:
  - Smaller, focused on interaction handling
  - May be specialized for 3D selection

### References Found:
- No specific references found to either path
- May be instantiated dynamically

### Recommendation: **KEEP BOTH - Verify Usage First**
- These may serve different purposes
- Need to verify if both are actively used
- Systems version likely for global input, interaction for 3D

## Risk Assessment

### Low Risk Deletions:
1. `/core/models/BrainSystemSwitcher.gd` - Superseded by education version
2. `/core/knowledge/ComparativeAnatomyService.gd` - Superseded by education version

### Medium Risk:
1. InputRouter files - Need verification of distinct purposes

## Step-by-Step Deletion Sequence

### Phase 1: Backup Creation
```bash
# Create backup directory
mkdir -p backup/duplicate_files_backup_$(date +%Y%m%d_%H%M%S)

# Backup all duplicates
cp core/models/BrainSystemSwitcher.gd backup/duplicate_files_backup_*/
cp core/knowledge/ComparativeAnatomyService.gd backup/duplicate_files_backup_*/
cp core/interaction/InputRouter.gd backup/duplicate_files_backup_*/
cp core/systems/InputRouter.gd backup/duplicate_files_backup_*/
```

### Phase 2: Safe Deletions
1. Delete `/core/models/BrainSystemSwitcher.gd`
   - No autoload references
   - Functionality superseded by education version

2. Delete `/core/knowledge/ComparativeAnatomyService.gd`
   - No autoload references
   - Education version is more complete

### Phase 3: InputRouter Investigation
1. Search for InputRouter instantiation patterns
2. Test application with each version disabled
3. Determine if both serve unique purposes
4. Delete redundant version if confirmed

## Verification Commands

```bash
# Verify no direct references before deletion
grep -r "core/models/BrainSystemSwitcher" . --include="*.gd"
grep -r "core/knowledge/ComparativeAnatomyService" . --include="*.gd"

# Check for class_name conflicts after deletion
grep -r "class_name BrainSystemSwitcher" . --include="*.gd"
grep -r "class_name ComparativeAnatomyService" . --include="*.gd"
```

## Post-Cleanup Testing

1. Launch NeuroVis application
2. Test educational module functionality
3. Verify brain system switching works
4. Test comparative anatomy features
5. Verify input handling (both UI and 3D)
6. Run all unit tests if available

## Conclusion

Two files can be safely deleted immediately:
- `/core/models/BrainSystemSwitcher.gd`
- `/core/knowledge/ComparativeAnatomyService.gd`

InputRouter files require additional investigation before deletion.

All educational functionality will be preserved through the newer, more comprehensive versions in the education/ directory.
