#!/bin/bash

echo "🔄 Restoring Full Systems (Re-enabling Complex Features)"
echo "====================================================="

# Step 1: Restore original configuration
echo "📁 Restoring original configuration..."
if [ -f "project.godot.backup" ]; then
    cp project.godot.backup project.godot
    echo "✅ Restored original project.godot"
else
    echo "❌ No backup found! You'll need to manually restore project.godot"
    exit 1
fi

# Step 2: Re-enable advanced FeatureFlags
echo ""
echo "🎛️  Re-enabling advanced features..."
cat > tools/scripts/enable_full_systems.gd << 'EOF'
#!/usr/bin/env gdscript
extends SceneTree

func _init():
	print("🚀 Re-enabling Full Systems...")
	
	# Apply development preset with all features
	FeatureFlags.apply_preset("development")
	
	# Enable advanced UI systems
	FeatureFlags.enable_feature(FeatureFlags.UI_MODULAR_COMPONENTS, true)
	FeatureFlags.enable_feature(FeatureFlags.UI_COMPONENT_POOLING, true)
	FeatureFlags.enable_feature(FeatureFlags.UI_STATE_PERSISTENCE, true)
	FeatureFlags.enable_feature(FeatureFlags.UI_STYLE_ENGINE, true)
	FeatureFlags.enable_feature(FeatureFlags.UI_ADVANCED_INTERACTIONS, true)
	
	# Enable all development features
	FeatureFlags.enable_feature(FeatureFlags.DEBUG_COMPONENT_INSPECTOR, true)
	FeatureFlags.enable_feature(FeatureFlags.DEBUG_PERFORMANCE_OVERLAY, true)
	FeatureFlags.enable_feature(FeatureFlags.PERFORMANCE_MONITORING, true)
	
	print("✅ Full Systems Re-enabled")
	print("📊 Current flag status:")
	FeatureFlags.print_flag_status()
	
	quit()
EOF

godot --headless --script tools/scripts/enable_full_systems.gd 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Advanced features re-enabled"
else
    echo "⚠️  Feature re-enablement may have failed - check manually"
fi

# Step 3: Clean up temporary files
echo ""
echo "🧹 Cleaning up..."
rm -f tools/scripts/enable_full_systems.gd
rm -f project_core_development.godot
echo "✅ Temporary files cleaned"

# Step 4: Validate restoration
echo ""
echo "✅ Validating system restoration..."
if [ -f "tools/scripts/quick_test.sh" ]; then
    echo "Running validation tests..."
    ./tools/scripts/quick_test.sh
else
    echo "⚠️  Quick test script not found - manual validation recommended"
fi

echo ""
echo "🎉 Full Systems Restored!"
echo ""
echo "📋 What was restored:"
echo "   - Original project.godot configuration"
echo "   - All FeatureFlags re-enabled for development"
echo "   - Complex UI systems available"
echo "   - Advanced debugging and performance tools active"
echo ""
echo "🚀 Your NeuroVis platform is back to full sophistication!"
echo ""
