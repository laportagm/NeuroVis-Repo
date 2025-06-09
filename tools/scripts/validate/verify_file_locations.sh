#!/bin/bash

echo "Verifying NeuroVis file locations..."
echo "=================================="

# Check AccessibilityManager location
echo ""
echo "AccessibilityManager.gd location:"
if [ -f "core/systems/AccessibilityManager.gd" ]; then
    echo "✓ Found at correct location: core/systems/AccessibilityManager.gd"
    echo "  File size: $(wc -l < core/systems/AccessibilityManager.gd) lines"
else
    echo "✗ NOT FOUND at expected location!"
fi

# Check if there's a wrong location
if [ -f "ui/components/controls/AccessibilityManager.gd" ]; then
    echo "⚠️  WARNING: Found AccessibilityManager.gd at WRONG location: ui/components/controls/"
    echo "  This file should be removed!"
else
    echo "✓ No file at incorrect location (ui/components/controls/)"
fi

# Check SafeAutoloadAccess
echo ""
echo "SafeAutoloadAccess.gd location:"
if [ -f "ui/components/core/SafeAutoloadAccess.gd" ]; then
    echo "✓ Found at correct location: ui/components/core/SafeAutoloadAccess.gd"
    echo "  File size: $(wc -l < ui/components/core/SafeAutoloadAccess.gd) lines"
else
    echo "✗ NOT FOUND at expected location!"
fi

# Verify autoload entries in project.godot
echo ""
echo "Autoload configuration in project.godot:"
echo "---------------------------------------"
grep -E "(AccessibilityManager|SafeAutoloadAccess)" project.godot || echo "No autoload entries found"

echo ""
echo "=================================="
echo "Verification complete!"
