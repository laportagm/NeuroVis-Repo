#!/usr/bin/env python3
"""
Comprehensive Godot 4 Syntax Fixer
==================================

This script automatically fixes Godot 3 syntax patterns to Godot 4 syntax.
It handles all the issues found by the validation script.

Usage:
    python3 fix_godot4_syntax_comprehensive.py

Features:
- Creates automatic backup before fixing
- Fixes onready var -> @onready
- Fixes export(...) -> @export
- Fixes signal connections/disconnections/emissions
- Fixes variable name conflicts
- Fixes indentation issues
- Preserves educational context and medical terminology
"""

import os
import re
import shutil
import sys
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Tuple

class GodotSyntaxFixer:
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.backup_dir = None
        self.fixed_files = []
        self.errors = []
        
        # Directories to ignore
        self.ignore_dirs = {
            '.godot', '.git', 'node_modules', 'exports', 
            'temp_syntax_check', 'syntax_fix_backup_'
        }
        
        # Files that should be skipped (already backups)
        self.ignore_patterns = [
            r'.*backup.*\.gd$',
            r'.*_backup\.gd$',
            r'syntax_fix_backup_.*',
        ]
        
    def create_backup(self) -> bool:
        """Create a complete backup of the project before making changes"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        self.backup_dir = self.project_root / f"syntax_fix_backup_{timestamp}"
        
        try:
            print(f"🔄 Creating backup at: {self.backup_dir}")
            shutil.copytree(self.project_root, self.backup_dir, 
                          ignore=shutil.ignore_patterns(
                              '.godot', '.git', 'node_modules', 'exports',
                              'temp_syntax_check', 'syntax_fix_backup_*'
                          ))
            print("✅ Backup created successfully")
            return True
        except Exception as e:
            print(f"❌ Failed to create backup: {e}")
            return False
    
    def should_ignore_file(self, file_path: Path) -> bool:
        """Check if file should be ignored"""
        # Check if it's in an ignored directory
        for part in file_path.parts:
            if any(ignore in part for ignore in self.ignore_dirs):
                return True
        
        # Check ignore patterns
        file_str = str(file_path)
        for pattern in self.ignore_patterns:
            if re.match(pattern, file_str):
                return True
        
        return False
    
    def fix_onready_syntax(self, content: str) -> Tuple[str, int]:
        """Fix onready var -> @onready"""
        pattern = r'^(\s*)onready\s+var\s+'
        fixes = 0
        
        lines = content.split('\n')
        for i, line in enumerate(lines):
            match = re.match(pattern, line)
            if match:
                indent = match.group(1)
                # Replace onready var with @onready\nvar
                new_line = re.sub(pattern, f'{indent}@onready\n{indent}var ', line)
                lines[i] = new_line
                fixes += 1
        
        return '\n'.join(lines), fixes
    
    def fix_export_syntax(self, content: str) -> Tuple[str, int]:
        """Fix export(...) -> @export"""
        fixes = 0
        
        # Pattern for export(Type) var name
        pattern = r'^(\s*)export\s*\(\s*([^)]+)\s*\)\s+var\s+'
        lines = content.split('\n')
        
        for i, line in enumerate(lines):
            match = re.match(pattern, line)
            if match:
                indent = match.group(1)
                export_type = match.group(2).strip()
                
                # Convert common export types
                if export_type == 'String':
                    new_export = '@export'
                elif export_type == 'int' or export_type == 'Int':
                    new_export = '@export'
                elif export_type == 'float' or export_type == 'Float':
                    new_export = '@export'
                elif export_type == 'bool' or export_type == 'Bool':
                    new_export = '@export'
                elif export_type.startswith('Resource'):
                    new_export = '@export'
                elif 'Range' in export_type:
                    # Extract range values if possible
                    range_match = re.search(r'Range\s*\(\s*([^)]+)\s*\)', export_type)
                    if range_match:
                        range_args = range_match.group(1)
                        new_export = f'@export_range({range_args})'
                    else:
                        new_export = '@export'
                else:
                    new_export = '@export'
                
                new_line = re.sub(pattern, f'{indent}{new_export}\n{indent}var ', line)
                lines[i] = new_line
                fixes += 1
        
        return '\n'.join(lines), fixes
    
    def fix_signal_connections(self, content: str) -> Tuple[str, int]:
        """Fix old signal connection syntax"""
        fixes = 0
        
        # Fix .connect("signal_name", ...) -> signal_name.connect(...)
        pattern = r'(\w+)\.connect\s*\(\s*["\']([^"\']+)["\']\s*,\s*([^)]+)\)'
        def replace_connect(match):
            nonlocal fixes
            fixes += 1
            object_name = match.group(1)
            signal_name = match.group(2)
            callback = match.group(3)
            return f'{object_name}.{signal_name}.connect({callback})'
        
        content = re.sub(pattern, replace_connect, content)
        
        # Fix .disconnect("signal_name", ...) -> signal_name.disconnect(...)
        pattern = r'(\w+)\.disconnect\s*\(\s*["\']([^"\']+)["\']\s*,\s*([^)]+)\)'
        def replace_disconnect(match):
            nonlocal fixes
            fixes += 1
            object_name = match.group(1)
            signal_name = match.group(2)
            callback = match.group(3)
            return f'{object_name}.{signal_name}.disconnect({callback})'
        
        content = re.sub(pattern, replace_disconnect, content)
        
        # Fix .is_connected("signal_name", ...) -> signal_name.is_connected(...)
        pattern = r'(\w+)\.is_connected\s*\(\s*["\']([^"\']+)["\']\s*,\s*([^)]+)\)'
        def replace_is_connected(match):
            nonlocal fixes
            fixes += 1
            object_name = match.group(1)
            signal_name = match.group(2)
            callback = match.group(3)
            return f'{object_name}.{signal_name}.is_connected({callback})'
        
        content = re.sub(pattern, replace_is_connected, content)
        
        return content, fixes
    
    def fix_emit_signal(self, content: str) -> Tuple[str, int]:
        """Fix emit_signal("name", ...) -> signal_name.emit(...)"""
        fixes = 0
        
        # Pattern for emit_signal("signal_name", args...)
        pattern = r'emit_signal\s*\(\s*["\']([^"\']+)["\']\s*,?\s*([^)]*)\)'
        
        def replace_emit(match):
            nonlocal fixes
            fixes += 1
            signal_name = match.group(1)
            args = match.group(2).strip()
            if args:
                return f'{signal_name}.emit({args})'
            else:
                return f'{signal_name}.emit()'
        
        content = re.sub(pattern, replace_emit, content)
        return content, fixes
    
    def fix_tool_syntax(self, content: str) -> Tuple[str, int]:
        """Fix tool -> @tool"""
        fixes = 0
        lines = content.split('\n')
        
        for i, line in enumerate(lines):
            stripped = line.strip()
            if stripped == 'tool':
                # Replace with @tool
                indent = line[:len(line) - len(line.lstrip())]
                lines[i] = f'{indent}@tool'
                fixes += 1
        
        return '\n'.join(lines), fixes
    
    def fix_yield_syntax(self, content: str) -> Tuple[str, int]:
        """Fix yield(...) -> await"""
        fixes = 0
        
        # Simple yield() replacement
        pattern = r'yield\s*\(\s*([^)]+)\s*\)'
        def replace_yield(match):
            nonlocal fixes
            fixes += 1
            args = match.group(1)
            return f'await {args}'
        
        content = re.sub(pattern, replace_yield, content)
        return content, fixes
    
    def fix_variable_conflicts(self, content: str) -> Tuple[str, int]:
        """Fix variable name conflicts like duplicate 'err' variables"""
        fixes = 0
        lines = content.split('\n')
        
        # Track variable names in current scope
        declared_vars = set()
        
        for i, line in enumerate(lines):
            # Look for variable declarations
            var_match = re.search(r'^\s*var\s+(\w+)', line)
            if var_match:
                var_name = var_match.group(1)
                if var_name in declared_vars:
                    # Rename the variable
                    new_name = f'{var_name}_2'
                    counter = 2
                    while new_name in declared_vars:
                        counter += 1
                        new_name = f'{var_name}_{counter}'
                    
                    # Replace in this line
                    lines[i] = line.replace(f'var {var_name}', f'var {new_name}')
                    declared_vars.add(new_name)
                    fixes += 1
                else:
                    declared_vars.add(var_name)
        
        return '\n'.join(lines), fixes
    
    def fix_indentation_issues(self, content: str) -> Tuple[str, int]:
        """Fix common indentation issues that cause parse errors"""
        fixes = 0
        lines = content.split('\n')
        
        # Look for lines that start with unexpected indentation
        for i, line in enumerate(lines):
            # Skip empty lines and comments
            if not line.strip() or line.strip().startswith('#'):
                continue
            
            # Check for unexpected indentation at class level
            if i > 0:
                prev_line = lines[i-1].strip()
                if (line.startswith('    ') and 
                    not prev_line.endswith(':') and 
                    not prev_line.startswith('func ') and
                    not prev_line.startswith('class ') and
                    not prev_line.startswith('if ') and
                    not prev_line.startswith('else') and
                    not prev_line.startswith('elif ') and
                    not prev_line.startswith('for ') and
                    not prev_line.startswith('while ') and
                    not prev_line.startswith('match ') and
                    not prev_line.startswith('try:') and
                    not prev_line.startswith('finally:')):
                    
                    # Remove unexpected indentation
                    lines[i] = line.lstrip()
                    fixes += 1
        
        return '\n'.join(lines), fixes
    
    def fix_file(self, file_path: Path) -> Dict:
        """Fix a single GDScript file"""
        if not file_path.suffix == '.gd':
            return {'success': False, 'reason': 'Not a GDScript file'}
        
        if self.should_ignore_file(file_path):
            return {'success': False, 'reason': 'File ignored'}
        
        try:
            # Read file
            with open(file_path, 'r', encoding='utf-8') as f:
                original_content = f.read()
            
            content = original_content
            total_fixes = 0
            
            # Apply all fixes
            content, fixes = self.fix_indentation_issues(content)
            total_fixes += fixes
            
            content, fixes = self.fix_tool_syntax(content)
            total_fixes += fixes
            
            content, fixes = self.fix_onready_syntax(content)
            total_fixes += fixes
            
            content, fixes = self.fix_export_syntax(content)
            total_fixes += fixes
            
            content, fixes = self.fix_signal_connections(content)
            total_fixes += fixes
            
            content, fixes = self.fix_emit_signal(content)
            total_fixes += fixes
            
            content, fixes = self.fix_yield_syntax(content)
            total_fixes += fixes
            
            content, fixes = self.fix_variable_conflicts(content)
            total_fixes += fixes
            
            # Write back if changes were made
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                
                return {
                    'success': True, 
                    'fixes': total_fixes,
                    'file': str(file_path)
                }
            else:
                return {'success': False, 'reason': 'No changes needed'}
                
        except Exception as e:
            return {'success': False, 'reason': f'Error: {e}', 'file': str(file_path)}
    
    def fix_all_files(self) -> None:
        """Fix all GDScript files in the project"""
        print("🔧 Starting comprehensive Godot 4 syntax fixes...")
        
        total_files = 0
        fixed_files = 0
        total_fixes = 0
        
        # Walk through all .gd files
        for gd_file in self.project_root.rglob('*.gd'):
            total_files += 1
            result = self.fix_file(gd_file)
            
            if result['success']:
                fixed_files += 1
                fixes = result['fixes']
                total_fixes += fixes
                relative_path = gd_file.relative_to(self.project_root)
                print(f"✅ Fixed {relative_path} ({fixes} issues)")
                self.fixed_files.append(result)
            elif 'reason' in result and result['reason'] != 'No changes needed' and result['reason'] != 'File ignored':
                relative_path = gd_file.relative_to(self.project_root)
                print(f"⚠️  Could not fix {relative_path}: {result['reason']}")
                self.errors.append(result)
        
        print(f"\n📊 Summary:")
        print(f"   Files scanned: {total_files}")
        print(f"   Files fixed: {fixed_files}")
        print(f"   Total fixes applied: {total_fixes}")
        print(f"   Errors: {len(self.errors)}")
        
        if self.errors:
            print(f"\n❌ Files with errors:")
            for error in self.errors:
                print(f"   {error.get('file', 'Unknown')}: {error['reason']}")

def main():
    """Main function"""
    project_root = os.getcwd()
    
    print("🔧 Comprehensive Godot 4 Syntax Fixer")
    print("=====================================")
    print(f"Project: {project_root}")
    print()
    
    # Create fixer instance
    fixer = GodotSyntaxFixer(project_root)
    
    # Create backup
    if not fixer.create_backup():
        print("❌ Cannot proceed without backup")
        sys.exit(1)
    
    # Fix all files
    fixer.fix_all_files()
    
    print()
    print("✅ Godot 4 syntax fixing complete!")
    print(f"💾 Backup saved at: {fixer.backup_dir}")
    print()
    print("Next steps:")
    print("1. Run './validate_godot4_syntax_fixed.sh' to verify fixes")
    print("2. Test your project in Godot 4")
    print("3. If issues remain, check the error list above")

if __name__ == "__main__":
    main()