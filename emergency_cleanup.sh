#!/bin/bash
# Emergency Backup Cleanup Script
# Removes problematic backup directories causing syntax errors

echo "🧹 Emergency Backup Cleanup"
echo "Removing problematic backup directories..."

# Remove backup directories that are causing syntax errors
rm -rf backups_20250606_205608
rm -rf backups_20250607_150730  
rm -rf backups_20250607_165202
rm -rf backups_20250607_173928

# Remove syntax fix backup directories (keep only the latest one)
rm -rf syntax_fix_backup_20250607_173847
rm -rf syntax_fix_backup_20250607_174148
rm -rf syntax_fix_backup_20250607_174307
rm -rf syntax_fix_backup_20250607_174324
rm -rf syntax_fix_backup_20250607_174708
rm -rf syntax_fix_backup_20250607_174733
rm -rf syntax_fix_backup_20250607_174756
# Keep the latest: syntax_fix_backup_20250607_174821

# Remove old backup archives that are taking up space
rm -f cleanup_backup_20250607_165135.tar.gz
rm -f cleanup_backup_20250607_173917.tar.gz

# Remove old logs
rm -f fix_all_20250606_205608.log
rm -f fix_all_20250607_150730.log
rm -f fix_all_20250607_165202.log  
rm -f fix_all_20250607_173928.log

echo "✅ Backup cleanup complete!"
echo "Removed problematic backup directories that were causing syntax errors."
