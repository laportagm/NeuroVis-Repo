#!/usr/bin/env python3
"""
NeuroVis Preload Syntax Fix Script
Fixes malformed preload statements in GDScript files

This script safely replaces:
- prepreprepreload -> preload (4 pre's)  
- preprepreload -> preload (3 pre's)

Safety features:
- Creates backup before modifications
- Excludes backup directories
- Detailed logging of all changes
- Dry-run mode for testing
"""

import os
import re
import shutil
import sys
from datetime import datetime
from pathlib import Path
from typing import List, Tuple, Dict

class PreloadSyntaxFixer:
    def __init__(self, project_root: str, dry_run: bool = False):
        self.project_root = Path(project_root)
        self.dry_run = dry_run
        self.changes_made = []
        self.errors = []
        
        # Directories to exclude from processing
        self.excluded_dirs = [
            'backups_*',
            'syntax_fix_backup_*',
            '.godot',
            '.git',
            'node_modules'
        ]
        
        # Patterns to fix
        self.patterns = [
            (r'\bprepreprepreload\b', 'preload'),  # 4 pre's -> preload
            (r'\bpreprepreload\b', 'preload'),    # 3 pre's -> preload
        ]
    
    def create_backup(self) -> str:
        """Create a backup of the project before making changes"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_name = f"syntax_fix_backup_{timestamp}"
        backup_path = self.project_root / backup_name
        
        print(f"Creating backup at: {backup_path}")
        
        if not self.dry_run:
            # Copy only essential directories, exclude existing backups
            essential_dirs = ['core', 'ui', 'scenes', 'assets', 'tools', 'tests']
            backup_path.mkdir(exist_ok=True)
            
            for dir_name in essential_dirs:
                src_dir = self.project_root / dir_name
                if src_dir.exists():
                    dst_dir = backup_path / dir_name
                    if src_dir.is_dir():
                        shutil.copytree(src_dir, dst_dir, ignore=shutil.ignore_patterns('*.tmp'))
            
            # Copy individual important files
            important_files = ['project.godot', 'add_autoloads.gd']
            for file_name in important_files:
                src_file = self.project_root / file_name
                if src_file.exists():
                    shutil.copy2(src_file, backup_path / file_name)
        
        return str(backup_path)
    
    def should_exclude_path(self, path: Path) -> bool:
        """Check if path should be excluded from processing"""
        path_str = str(path)
        
        for pattern in self.excluded_dirs:
            if pattern.endswith('*'):
                pattern_base = pattern[:-1]
                if pattern_base in path_str:
                    return True
            else:
                if pattern in path_str:
                    return True
        
        return False
    
    def find_gdscript_files(self) -> List[Path]:
        """Find all GDScript files to process"""
        gdscript_files = []
        
        for file_path in self.project_root.rglob("*.gd"):
            if not self.should_exclude_path(file_path):
                gdscript_files.append(file_path)
        
        return sorted(gdscript_files)
    
    def fix_file(self, file_path: Path) -> Tuple[bool, int]:
        """Fix preload syntax in a single file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            changes_count = 0
            
            # Apply each pattern fix
            for pattern, replacement in self.patterns:
                matches = re.findall(pattern, content)
                if matches:
                    content = re.sub(pattern, replacement, content)
                    changes_count += len(matches)
            
            # Write changes if any were made
            if changes_count > 0:
                if not self.dry_run:
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(content)
                
                self.changes_made.append({
                    'file': str(file_path),
                    'changes': changes_count,
                    'relative_path': str(file_path.relative_to(self.project_root))
                })
                
                return True, changes_count
            
            return False, 0
            
        except Exception as e:
            error_msg = f"Error processing {file_path}: {str(e)}"
            self.errors.append(error_msg)
            print(f"ERROR: {error_msg}")
            return False, 0
    
    def generate_report(self) -> str:
        """Generate a detailed report of changes made"""
        report = []
        report.append("=" * 60)
        report.append("NEUROVIS PRELOAD SYNTAX FIX REPORT")
        report.append("=" * 60)
        report.append(f"Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report.append(f"Mode: {'DRY RUN' if self.dry_run else 'LIVE EXECUTION'}")
        report.append(f"Project Root: {self.project_root}")
        report.append("")
        
        if self.changes_made:
            report.append(f"FILES MODIFIED: {len(self.changes_made)}")
            total_changes = sum(change['changes'] for change in self.changes_made)
            report.append(f"TOTAL CHANGES: {total_changes}")
            report.append("")
            
            report.append("DETAILED CHANGES:")
            report.append("-" * 40)
            for change in self.changes_made:
                report.append(f"File: {change['relative_path']}")
                report.append(f"  Changes: {change['changes']} preload statements fixed")
                report.append("")
        else:
            report.append("NO CHANGES NEEDED - All preload statements are correct!")
        
        if self.errors:
            report.append("ERRORS ENCOUNTERED:")
            report.append("-" * 40)
            for error in self.errors:
                report.append(f"  {error}")
            report.append("")
        
        report.append("PATTERN FIXES APPLIED:")
        report.append("-" * 40)
        for pattern, replacement in self.patterns:
            report.append(f"  {pattern} -> {replacement}")
        
        return "\n".join(report)
    
    def run(self) -> bool:
        """Run the complete fix process"""
        print("NeuroVis Preload Syntax Fixer")
        print("=" * 40)
        print(f"Mode: {'DRY RUN' if self.dry_run else 'LIVE EXECUTION'}")
        print(f"Project: {self.project_root}")
        print()
        
        # Create backup (only in live mode)
        if not self.dry_run:
            backup_path = self.create_backup()
            print(f"Backup created: {backup_path}")
            print()
        
        # Find all GDScript files
        gdscript_files = self.find_gdscript_files()
        print(f"Found {len(gdscript_files)} GDScript files to process")
        print()
        
        # Process each file
        processed_count = 0
        for file_path in gdscript_files:
            changed, change_count = self.fix_file(file_path)
            if changed:
                print(f"✓ Fixed {change_count} statements in: {file_path.relative_to(self.project_root)}")
            processed_count += 1
        
        print()
        print(f"Processed {processed_count} files")
        print(f"Modified {len(self.changes_made)} files")
        
        if self.errors:
            print(f"Errors: {len(self.errors)}")
        
        # Generate and save report
        report = self.generate_report()
        report_file = self.project_root / f"preload_fix_report_{'dry_run_' if self.dry_run else ''}{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
        
        if not self.dry_run:
            with open(report_file, 'w', encoding='utf-8') as f:
                f.write(report)
            print(f"\nReport saved: {report_file}")
        
        print("\n" + report)
        
        return len(self.errors) == 0

def main():
    """Main entry point"""
    if len(sys.argv) < 2:
        print("Usage: python fix_preload_syntax.py <project_root> [--dry-run]")
        print("Example: python fix_preload_syntax.py /path/to/NeuroVis-Repo --dry-run")
        sys.exit(1)
    
    project_root = sys.argv[1]
    dry_run = '--dry-run' in sys.argv
    
    if not os.path.exists(project_root):
        print(f"Error: Project root '{project_root}' does not exist")
        sys.exit(1)
    
    fixer = PreloadSyntaxFixer(project_root, dry_run)
    success = fixer.run()
    
    if dry_run:
        print("\n" + "=" * 60)
        print("DRY RUN COMPLETED - No files were actually modified")
        print("Run without --dry-run to apply changes")
        print("=" * 60)
    
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()