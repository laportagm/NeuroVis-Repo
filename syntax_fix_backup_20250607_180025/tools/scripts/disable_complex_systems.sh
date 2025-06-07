#!/bin/bash

echo "🔧 Disabling Complex Systems for Core Development"
echo "==============================================="

# Step 1: Backup current configuration
echo "📁 Creating backup..."
if [ ! -f "project.godot.backup" ]; then
    cp project.godot project.godot.backup
    echo "✅ Backed up project.godot"
else
    echo "⚠️  Backup already exists - skipping"
fi

# Step 2: Apply core development configuration
echo ""
echo "🔄 Applying core development configuration..."
if [ -f "project_core_development.godot" ]; then
    cp project_core_development.godot project.godot
    echo "✅ Applied simplified project configuration"
else
    echo "❌ project_core_development.godot not found!"
    exit 1
fi

# Step 3: Configure FeatureFlags for core development
echo ""
echo "🎛️  Configuring FeatureFlags..."
godot --headless --script tools/scripts/enable_core_development_mode.gd 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ FeatureFlags configured for core development"
else
    echo "⚠️  FeatureFlags configuration may have failed - check manually"
fi

# Step 4: Validate core systems
echo ""
echo "✅ Validating core systems..."
if [ -f "tools/scripts/quick_test.sh" ]; then
    echo "Running quick tests..."
    ./tools/scripts/quick_test.sh
else
    echo "⚠️  Quick test script not found - manual validation needed"
fi

echo ""
echo "🎉 Core Development Mode Enabled!"
echo ""
echo "📋 What was changed:"
echo "   - ComponentRegistry: Disabled (not in autoloads yet)"
echo "   - FeatureFlags: Set to conservative development preset"
echo "   - Complex UI systems: Disabled via feature flags"
echo "   - Essential systems: Kept active (KnowledgeService, UIThemeManager, etc.)"
echo ""
echo "🚀 Next steps:"
echo "   1. Launch Godot normally"
echo "   2. Test your core educational functionality"
echo "   3. If issues occur, run: ./tools/scripts/restore_full_systems.sh"
echo ""
echo "📈 To re-enable complex systems when ready:"
echo "   - Edit project.godot to uncomment advanced autoloads"
echo "   - Run FeatureFlags.apply_preset('development')"
echo ""
