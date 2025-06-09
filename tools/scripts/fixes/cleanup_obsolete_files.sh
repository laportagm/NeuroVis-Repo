#!/bin/bash
# NeuroVis Project Cleanup Script
# Removes deprecated, obsolete, and backup files
# Run with: ./cleanup_obsolete_files.sh

echo "🧹 NeuroVis Project Cleanup"
echo "This will remove deprecated and obsolete files."
echo "Make sure you have committed any important changes!"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 1
fi

echo "📁 Creating backup archive before cleanup..."
tar -czf cleanup_backup_$(date +%Y%m%d_%H%M%S).tar.gz \
    scenes/main/node_3d_*.gd \
    scenes/ui_info_panel*.* \
    ui/panels/minimal_info_panel.gd \
    ui/panels/ModernInfoDisplay.gd \
    tmp/ \
    temp_syntax_check/ \
    2>/dev/null || true

echo "🗑️  Removing backup files..."
rm -f scenes/main/node_3d_backup.gd
rm -f scenes/main/node_3d_backup.gd.uid
rm -f scenes/ui_info_panel_backup.tscn
rm -f project.godot.backup
rm -f core/interaction/BrainStructureSelectionManagerBackup.gd
rm -f core/interaction/BrainStructureSelectionManagerBackup.gd.uid

echo "🗑️  Removing deprecated UI panels..."
rm -f ui/panels/minimal_info_panel.gd
rm -f ui/panels/minimal_info_panel.gd.uid
rm -f ui/panels/ModernInfoDisplay.gd
rm -f ui/panels/ModernInfoDisplay.gd.uid
rm -f scenes/ui_info_panel.gd
rm -f scenes/ui_info_panel.gd.uid

echo "🗑️  Removing experimental node_3d versions..."
rm -f scenes/main/node_3d_modified.gd
rm -f scenes/main/node_3d_modified.gd.uid
rm -f scenes/main/node_3d_robust.gd
rm -f scenes/main/node_3d_robust.gd.uid
rm -f scenes/main/node_3d_simple.gd
rm -f scenes/main/node_3d_simple.gd.uid
rm -f scenes/main/node_3d_enhanced.gd
rm -f scenes/main/node_3d_enhanced.gd.uid
rm -f scenes/main/node_3d_hybrid.gd
rm -f scenes/main/node_3d_hybrid.gd.uid
rm -f scenes/main/node_3d_components.gd
rm -f scenes/main/node_3d_components.gd.uid
rm -f scenes/node_3d_new.tscn

echo "🗑️  Removing old UI panel variants..."
rm -f scenes/ui_info_panel_fixed.tscn
rm -f scenes/ui_info_panel_new.tscn
rm -f scenes/ui_info_panel_enhanced.gd
rm -f scenes/ui_info_panel_enhanced.gd.uid
rm -f scenes/ui_info_panel_enhanced.tscn
rm -f scenes/ui_info_panel_unified.gd
rm -f scenes/ui_info_panel_unified.gd.uid

echo "🗑️  Removing temporary files and directories..."
rm -f temp_line_reader.py
rm -rf temp_syntax_check/
rm -rf tmp/

echo "🗑️  Removing test logs..."
rm -f test_*.log

echo "🗑️  Removing duplicate files..."
rm -f quick_test.gd
rm -f quick_test.gd.uid
rm -f validate_core_dev_mode.gd
rm -f validate_core_dev_mode.gd.uid
rm -f validate_ai_commands.gd
rm -f validate_ai_commands.gd.uid
rm -f quick_debug_demo.gd.uid

echo "🗑️  Removing standalone test files from root..."
rm -f test_responsive_minimal.gd
rm -f test_responsive_minimal.gd.uid
rm -f test_responsive.gd
rm -f test_responsive.gd.uid
rm -f test_progressive_ui.gd
rm -f test_progressive_ui.gd.uid
rm -f test_syntax.gd
rm -f test_syntax.gd.uid
rm -f test_name_mapping.gd
rm -f test_name_mapping.gd.uid
rm -f test_in_game.gd
rm -f test_in_game.gd.uid
rm -f test_ui_safety.gd
rm -f test_ui_safety.gd.uid
rm -f test_debug_commands.gd
rm -f test_debug_commands.gd.uid

echo "✅ Cleanup complete!"
echo ""
echo "📊 Summary:"
echo "- Backup archive created: cleanup_backup_*.tar.gz"
echo "- Removed backup files, deprecated UI panels, experimental versions"
echo "- Removed temporary directories and test artifacts"
echo ""
echo "💡 Next steps:"
echo "1. Run 'git status' to see removed files"
echo "2. Test the project to ensure nothing critical was removed"
echo "3. Commit the cleanup: git add -A && git commit -m 'chore: remove deprecated and obsolete files'"