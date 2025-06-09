#!/bin/bash
# NeuroVis Duplicate File Cleanup Script
# This script safely removes confirmed duplicate files after creating backups

echo "=== NeuroVis Duplicate File Cleanup ==="
echo "Starting cleanup process..."

# Create backup directory with timestamp
BACKUP_DIR="backup/duplicate_files_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "Created backup directory: $BACKUP_DIR"

# Backup all duplicate files before deletion
echo ""
echo "Creating backups..."
cp -v core/models/BrainSystemSwitcher.gd "$BACKUP_DIR/" 2>/dev/null || echo "Warning: core/models/BrainSystemSwitcher.gd not found"
cp -v core/knowledge/ComparativeAnatomyService.gd "$BACKUP_DIR/" 2>/dev/null || echo "Warning: core/knowledge/ComparativeAnatomyService.gd not found"
cp -v core/interaction/InputRouter.gd "$BACKUP_DIR/" 2>/dev/null || echo "Warning: core/interaction/InputRouter.gd not found"
cp -v core/systems/InputRouter.gd "$BACKUP_DIR/" 2>/dev/null || echo "Warning: core/systems/InputRouter.gd not found"

# Verify no direct path references exist
echo ""
echo "Verifying no direct path references..."
echo "Checking for core/models/BrainSystemSwitcher references..."
grep -r "core/models/BrainSystemSwitcher" . --include="*.gd" --include="*.tscn" 2>/dev/null || echo "✓ No references found"

echo "Checking for core/knowledge/ComparativeAnatomyService references..."
grep -r "core/knowledge/ComparativeAnatomyService" . --include="*.gd" --include="*.tscn" 2>/dev/null || echo "✓ No references found"

# Delete confirmed safe duplicates
echo ""
echo "Deleting confirmed duplicate files..."

# Delete older BrainSystemSwitcher
if [ -f "core/models/BrainSystemSwitcher.gd" ]; then
    rm -v core/models/BrainSystemSwitcher.gd
    echo "✓ Deleted core/models/BrainSystemSwitcher.gd (superseded by education version)"
else
    echo "✗ File not found: core/models/BrainSystemSwitcher.gd"
fi

# Delete older ComparativeAnatomyService
if [ -f "core/knowledge/ComparativeAnatomyService.gd" ]; then
    rm -v core/knowledge/ComparativeAnatomyService.gd
    echo "✓ Deleted core/knowledge/ComparativeAnatomyService.gd (superseded by education version)"
else
    echo "✗ File not found: core/knowledge/ComparativeAnatomyService.gd"
fi

# Report on InputRouter files (not deleting - they serve different purposes)
echo ""
echo "=== InputRouter Analysis ==="
echo "Two InputRouter files found serving different purposes:"
echo "1. core/systems/InputRouter.gd - Educational system-level routing with modes"
echo "2. core/interaction/InputRouter.gd - Basic input handling for camera/selection"
echo "⚠️  Both files kept as they appear to serve distinct functions"

# Final verification
echo ""
echo "=== Post-Cleanup Verification ==="
echo "Remaining files:"
find . -name "BrainSystemSwitcher.gd" -type f 2>/dev/null | grep -v backup
find . -name "ComparativeAnatomyService.gd" -type f 2>/dev/null | grep -v backup
find . -name "InputRouter.gd" -type f 2>/dev/null | grep -v backup

echo ""
echo "=== Cleanup Complete ==="
echo "Backup location: $BACKUP_DIR"
echo ""
echo "Next steps:"
echo "1. Launch NeuroVis and test educational modules"
echo "2. Verify brain system switching works correctly"
echo "3. Test comparative anatomy features"
echo "4. If any issues occur, restore from: $BACKUP_DIR"
echo ""
echo "To restore if needed:"
echo "cp $BACKUP_DIR/BrainSystemSwitcher.gd core/models/"
echo "cp $BACKUP_DIR/ComparativeAnatomyService.gd core/knowledge/"
