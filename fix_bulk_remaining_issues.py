#!/usr/bin/env python3
"""
Bulk Fix for Remaining Godot 3 Syntax Issues
==========================================

This script targets the most common remaining patterns in the 5,406 issues
to achieve maximum impact with focused fixes.

Usage:
    python3 fix_bulk_remaining_issues.py
"""

import os
import re
from pathlib import Path

class BulkSyntaxFixer:
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.ignore_dirs = {
            '.godot', '.git', 'node_modules', 'exports', 
            'temp_syntax_check', 'syntax_fix_backup_'
        }
        
    def should_ignore_file(self, file_path: Path) -> bool:
        """Check if file should be ignored"""
        for part in file_path.parts:
            if any(ignore in part for ignore in self.ignore_dirs):
                return True
        return False
    
    def fix_onready_bulk(self, content: str) -> tuple[str, int]:
        """Bulk fix onready patterns more aggressively"""
        fixes = 0
        
        # Replace all onready var patterns
        def replace_onready(match):
            nonlocal fixes
            fixes += 1
            indent = match.group(1)
            var_declaration = match.group(2)
            return f'{indent}@onready\\n{indent}var {var_declaration}'
        
        # More comprehensive pattern
        pattern = r'^(\\s*)onready\\s+var\\s+(.+)$'
        content = re.sub(pattern, replace_onready, content, flags=re.MULTILINE)
        
        return content, fixes
    
    def fix_export_bulk(self, content: str) -> tuple[str, int]:
        """Bulk fix export patterns"""
        fixes = 0
        
        # Simple replacement of export(...) with @export
        def replace_export(match):
            nonlocal fixes
            fixes += 1
            indent = match.group(1)
            var_part = match.group(2)
            return f'{indent}@export\\n{indent}var {var_part}'
        
        pattern = r'^(\\s*)export\\s*\\([^)]*\\)\\s+var\\s+(.+)$'
        content = re.sub(pattern, replace_export, content, flags=re.MULTILINE)
        
        return content, fixes
    
    def fix_signals_bulk(self, content: str) -> tuple[str, int]:
        """Bulk fix signal patterns"""
        fixes = 0
        
        # Fix emit_signal patterns
        patterns_replacements = [
            # emit_signal("name") -> name.emit()
            (r'emit_signal\\s*\\(\\s*["\']([^"\']+)["\']\\s*\\)', lambda m: f'{m.group(1)}.emit()'),
            
            # emit_signal("name", arg) -> name.emit(arg)
            (r'emit_signal\\s*\\(\\s*["\']([^"\']+)["\']\\s*,\\s*([^)]+)\\)', lambda m: f'{m.group(1)}.emit({m.group(2)})'),
            
            # object.connect("signal", target) -> object.signal.connect(target)
            (r'(\\w+)\\.connect\\s*\\(\\s*["\']([^"\']+)["\']\\s*,\\s*([^)]+)\\)', lambda m: f'{m.group(1)}.{m.group(2)}.connect({m.group(3)})'),
            
            # object.disconnect("signal", target) -> object.signal.disconnect(target)
            (r'(\\w+)\\.disconnect\\s*\\(\\s*["\']([^"\']+)["\']\\s*,\\s*([^)]+)\\)', lambda m: f'{m.group(1)}.{m.group(2)}.disconnect({m.group(3)})'),
            
            # object.is_connected("signal", target) -> object.signal.is_connected(target)
            (r'(\\w+)\\.is_connected\\s*\\(\\s*["\']([^"\']+)["\']\\s*,\\s*([^)]+)\\)', lambda m: f'{m.group(1)}.{m.group(2)}.is_connected({m.group(3)})'),
        ]
        
        for pattern, replacement in patterns_replacements:
            def count_replace(match):
                nonlocal fixes
                fixes += 1
                return replacement(match)
            
            content = re.sub(pattern, count_replace, content)
        
        return content, fixes
    
    def fix_tool_bulk(self, content: str) -> tuple[str, int]:
        """Bulk fix tool syntax"""
        fixes = 0
        
        # Replace standalone 'tool' with '@tool'
        def replace_tool(match):
            nonlocal fixes
            fixes += 1
            indent = match.group(1)
            return f'{indent}@tool'
        
        pattern = r'^(\\s*)tool\\s*$'
        content = re.sub(pattern, replace_tool, content, flags=re.MULTILINE)
        
        return content, fixes
    
    def fix_file_bulk(self, file_path: Path) -> dict:
        """Apply bulk fixes to a single file"""
        if not file_path.suffix == '.gd' or self.should_ignore_file(file_path):
            return {'success': False, 'reason': 'Skipped'}
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                original_content = f.read()
            
            content = original_content
            total_fixes = 0
            
            # Apply bulk fixes
            content, fixes = self.fix_tool_bulk(content)
            total_fixes += fixes
            
            content, fixes = self.fix_onready_bulk(content)
            total_fixes += fixes
            
            content, fixes = self.fix_export_bulk(content)
            total_fixes += fixes
            
            content, fixes = self.fix_signals_bulk(content)
            total_fixes += fixes
            
            # Write back if changes were made
            if content != original_content and total_fixes > 0:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                
                return {'success': True, 'fixes': total_fixes, 'file': str(file_path)}
            else:
                return {'success': False, 'reason': 'No changes needed'}
                
        except Exception as e:
            return {'success': False, 'reason': f'Error: {e}', 'file': str(file_path)}
    
    def fix_all_files_bulk(self) -> None:
        """Apply bulk fixes to all files"""
        print("🔧 Running bulk fixes for remaining Godot 3 syntax...")
        
        total_files = 0
        fixed_files = 0
        total_fixes = 0
        
        for gd_file in self.project_root.rglob('*.gd'):
            total_files += 1
            result = self.fix_file_bulk(gd_file)
            
            if result['success']:
                fixed_files += 1
                fixes = result['fixes']
                total_fixes += fixes
                relative_path = gd_file.relative_to(self.project_root)
                print(f"✅ {relative_path} ({fixes} fixes)")
        
        print(f"\\n📊 Bulk Fix Summary:")
        print(f"   Files scanned: {total_files}")
        print(f"   Files fixed: {fixed_files}")
        print(f"   Total fixes applied: {total_fixes}")

def main():
    """Main function"""
    project_root = os.getcwd()
    
    print("🔧 Bulk Godot 3 → Godot 4 Syntax Fixer")
    print("=====================================")
    print("Targeting remaining 5,406 syntax issues...")
    print()
    
    fixer = BulkSyntaxFixer(project_root)
    fixer.fix_all_files_bulk()
    
    print("\\n✅ Bulk syntax fixing complete!")
    print("\\nNext: Run validation to check final results")

if __name__ == "__main__":
    main()