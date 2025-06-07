# NeuroVis Linting and Code Quality System

This directory contains the comprehensive automated linting, formatting, and syntax validation system for the NeuroVis educational neuroscience visualization platform.

## 🚀 Quick Start

```bash
# Run linting on all files
./.claude/lint-and-fix.sh

# Run linting on specific file
./.claude/lint-and-fix.sh path/to/file.gd

# Auto-fix issues
./.claude/lint-and-fix.sh --fix

# Generate HTML report
./.claude/lint-and-fix.sh --report html
```

## 📋 Features

### 1. **GDScript Static Analysis**
- Syntax validation using `gdparse`
- Code formatting with `gdformat`
- Custom validation rules for educational software

### 2. **Medical Terminology Validation**
- Spell-checking for anatomical terms
- Consistency checking across codebase
- Suggestions for common misspellings

### 3. **Educational Metadata Enforcement**
- Learning objectives validation
- Clinical relevance checking
- Educational level verification

### 4. **Performance Optimization**
- 60fps target compliance
- Performance annotation requirements
- Draw call optimization checks

### 5. **Accessibility Compliance**
- WCAG 2.1 AA standard enforcement
- Keyboard navigation validation
- Screen reader compatibility checks

### 6. **Code Quality Standards**
- Naming convention enforcement (PascalCase/snake_case)
- Type hint requirements
- Error handling validation
- Documentation completeness

## 🛠️ Components

### Main Script
- `lint-and-fix.sh` - Central entry point for all linting operations

### Configuration Files
- `.gdscript_formatter.cfg` - GDScript formatting rules
- `neurovis-validator.py` - Custom validation logic

### Pre-commit Hooks
- `hooks/gdformat-hook.sh` - GDScript formatting
- `hooks/gdparse-hook.sh` - Syntax validation
- `hooks/validate-medical-terms.py` - Medical terminology
- `hooks/check-autoloads.py` - Autoload service validation
- `hooks/check-educational-metadata.py` - Educational content
- `hooks/check-performance.py` - Performance requirements
- `hooks/check-accessibility.py` - Accessibility standards

### Cache System
- `cache/` - File hash cache for incremental validation
- Automatic cache invalidation on file changes

## 📊 Reports

The system generates comprehensive reports in multiple formats:

### Text Report (Default)
```
=== NeuroVis Linting Report ===
Files checked: 150
Issues found: 12 (4 errors, 8 warnings)

core/interaction/BrainStructureSelectionManager.gd:45: ERROR: Missing type hint for parameter 'mesh'
ui/panels/EnhancedInformationPanel.gd:120: WARNING: Medical term 'hipocampus' should be 'hippocampus'
```

### JSON Report
```json
{
  "summary": {
    "total_files": 150,
    "files_with_issues": 8,
    "total_issues": 12,
    "errors": 4,
    "warnings": 8
  },
  "issues": [...]
}
```

### HTML Report
Interactive report with filtering, sorting, and code preview.

## 🔧 IDE Integration

### VSCode
Tasks are available in the Command Palette:
- `Lint: All Files` - Run complete linting
- `Lint: Current File` - Check active file
- `Auto-fix: Current File` - Fix issues automatically
- `Format: GDScript` - Format current file
- `Check: Medical Terms` - Validate terminology

### Pre-commit Hooks
Automatically run on every commit:
```bash
pre-commit install
```

## ⚙️ Configuration

### Environment Variables
- `NEUROVIS_LINT_PARALLEL` - Number of parallel jobs (default: CPU count)
- `NEUROVIS_LINT_CACHE` - Enable/disable caching (default: 1)
- `NEUROVIS_LINT_VERBOSE` - Verbose output (default: 0)

### Exit Codes
- `0` - Success, no issues found
- `1` - Issues found but fixable
- `2` - Critical errors found
- `3` - Dependency or configuration error

## 🏥 Medical Terminology

The system validates medical terms against a curated dictionary:

```python
MEDICAL_TERMS = {
    "hippocampus", "amygdala", "thalamus", "hypothalamus",
    "cerebellum", "cortex", "brainstem", "pons", "medulla",
    "midbrain", "striatum", "putamen", "caudate", "globus pallidus"
}
```

Common corrections are automatically suggested:
- `hipocampus` → `hippocampus`
- `amigdala` → `amygdala`
- `thalmus` → `thalamus`

## 📚 Educational Requirements

All educational components must include:

### GDScript Files
```gdscript
## @tutorial: Educational selection patterns
## @educational_level: intermediate
## @learning_objectives: Identify structures, understand functions
## @clinical_relevance: Related pathologies and conditions
```

### JSON Data
```json
{
  "educationalLevel": "intermediate",
  "learningObjectives": ["Identify location", "Understand function"],
  "clinicalRelevance": "Associated with memory disorders",
  "commonPathologies": ["Alzheimer's disease", "Epilepsy"]
}
```

## 🚀 Performance Guidelines

Critical functions require annotations:

```gdscript
# Performance: Optimized for 60fps
# Max execution time: 16.67ms
func _process(delta: float) -> void:
    # Use delta for frame-independent movement
    position += velocity * delta
```

## ♿ Accessibility Standards

UI components must include:

```gdscript
# Accessibility: WCAG 2.1 AA compliant
# - Keyboard navigation: Tab, Arrow keys
# - Screen reader: Structure descriptions
# - Focus indicators: Visible outline
```

## 🔄 Continuous Integration

GitHub Actions workflow runs on:
- Push to main/develop branches
- Pull requests
- Manual workflow dispatch

See `.github/workflows/lint.yml` for CI configuration.

## 🐛 Troubleshooting

### Common Issues

1. **"gdformat: command not found"**
   ```bash
   # Install gdtoolkit
   pip install gdtoolkit
   ```

2. **"Python version mismatch"**
   ```bash
   # Use Python 3.8+
   python3 --version
   ```

3. **"Cache permission denied"**
   ```bash
   # Fix cache permissions
   chmod -R 755 .claude/cache
   ```

### Debug Mode
```bash
# Enable verbose output
NEUROVIS_LINT_VERBOSE=1 ./.claude/lint-and-fix.sh
```

## 📈 Performance

- Parallel processing with configurable job count
- File hash caching reduces re-validation by ~80%
- Incremental validation for large codebases
- Average processing: ~100 files/second

## 🤝 Contributing

When adding new validation rules:

1. Add hook script to `.claude/hooks/`
2. Update `lint-and-fix.sh` to call new hook
3. Add pre-commit configuration
4. Document in this README
5. Add tests for the validation

## 📝 License

This linting system is part of the NeuroVis project and follows the same MIT license.