#!/usr/bin/env python3
"""
Final Comprehensive Godot 4 Syntax Fixer
========================================

This script performs a final pass to fix all remaining Godot 3 syntax patterns
identified by the validation system. It addresses the 5,406 remaining issues.

Usage:
    python3 fix_all_remaining_syntax.py
"""

import os
import re
import sys
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Tuple

class FinalSyntaxFixer:
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
    
    def fix_onready_comprehensive(self, content: str) -> Tuple[str, int]:
        """Comprehensive fix for onready var patterns"""
        fixes = 0
        lines = content.split('\n')
        
        for i, line in enumerate(lines):
            # Match onready var with proper indentation
            match = re.match(r'^(\s*)onready\s+var\s+(.+)', line)
            if match:
                indent = match.group(1)
                var_declaration = match.group(2)
                
                # Replace with @onready on separate line
                lines[i] = f'{indent}@onready\n{indent}var {var_declaration}'
                fixes += 1
        
        return '\n'.join(lines), fixes
    
    def fix_export_comprehensive(self, content: str) -> Tuple[str, int]:
        """Comprehensive fix for export patterns"""
        fixes = 0
        
        # Fix export(Type) var patterns
        def replace_export(match):
            nonlocal fixes
            fixes += 1
            indent = match.group(1)
            export_content = match.group(2).strip()
            var_part = match.group(3)
            
            # Determine appropriate @export annotation
            if 'Range' in export_content:
                # Handle Range exports
                range_match = re.search(r'Range\s*\(\s*([^)]+)\s*\)', export_content)
                if range_match:
                    range_args = range_match.group(1)
                    export_annotation = f'@export_range({range_args})'
                else:
                    export_annotation = '@export'
            elif export_content in ['String', 'int', 'float', 'bool']:
                export_annotation = '@export'
            elif 'Resource' in export_content:
                export_annotation = '@export'
            elif 'PackedScene' in export_content:
                export_annotation = '@export'
            else:
                export_annotation = '@export'
            
            return f'{indent}{export_annotation}\n{indent}var{var_part}'
        
        # Pattern for export(Type) var
        pattern = r'^(\s*)export\s*\(\s*([^)]+)\s*\)\s+(var\s+.+)'
        content = re.sub(pattern, replace_export, content, flags=re.MULTILINE)
        
        return content, fixes
    
    def fix_signal_syntax_comprehensive(self, content: str) -> Tuple[str, int]:
        """Comprehensive fix for signal-related syntax"""
        fixes = 0
        
        # Fix .connect("signal_name", target, callback)
        def replace_connect(match):
            nonlocal fixes
            fixes += 1
            prefix = match.group(1) if match.group(1) else ''
            object_ref = match.group(2)
            signal_name = match.group(3)
            args = match.group(4).strip()
            
            if args:
                return f'{prefix}{object_ref}.{signal_name}.connect({args})'
            else:
                return f'{prefix}{object_ref}.{signal_name}.connect()'
        
        # Pattern for object.connect("signal_name", ...)
        pattern = r'^(\s*)?(\w+)\.connect\s*\(\s*["\']([^"\']+)["\']\s*,?\s*([^)]*)\)'
        content = re.sub(pattern, replace_connect, content, flags=re.MULTILINE)
        
        # Fix .disconnect("signal_name", ...)
        def replace_disconnect(match):
            nonlocal fixes
            fixes += 1
            prefix = match.group(1) if match.group(1) else ''
            object_ref = match.group(2)
            signal_name = match.group(3)
            args = match.group(4).strip()
            
            if args:
                return f'{prefix}{object_ref}.{signal_name}.disconnect({args})'
            else:
                return f'{prefix}{object_ref}.{signal_name}.disconnect()'
        
        pattern = r'^(\s*)?(\w+)\.disconnect\s*\(\s*["\']([^"\']+)["\']\s*,?\s*([^)]*)\)'
        content = re.sub(pattern, replace_disconnect, content, flags=re.MULTILINE)
        
        # Fix .is_connected("signal_name", ...)
        def replace_is_connected(match):
            nonlocal fixes
            fixes += 1
            prefix = match.group(1) if match.group(1) else ''
            object_ref = match.group(2)
            signal_name = match.group(3)
            args = match.group(4).strip()
            
            if args:
                return f'{prefix}{object_ref}.{signal_name}.is_connected({args})'
            else:
                return f'{prefix}{object_ref}.{signal_name}.is_connected()'
        
        pattern = r'^(\s*)?(\w+)\.is_connected\s*\(\s*["\']([^"\']+)["\']\s*,?\s*([^)]*)\)'
        content = re.sub(pattern, replace_is_connected, content, flags=re.MULTILINE)
        
        # Fix emit_signal("signal_name", ...)
        def replace_emit_signal(match):
            nonlocal fixes
            fixes += 1
            prefix = match.group(1) if match.group(1) else ''
            signal_name = match.group(2)
            args = match.group(3).strip()
            
            if args:
                return f'{prefix}{signal_name}.emit({args})'
            else:
                return f'{prefix}{signal_name}.emit()'
        
        pattern = r'^(\s*)?emit_signal\s*\(\s*["\']([^"\']+)["\']\s*,?\s*([^)]*)\)'
        content = re.sub(pattern, replace_emit_signal, content, flags=re.MULTILINE)
        
        return content, fixes
    
    def fix_tool_syntax(self, content: str) -> Tuple[str, int]:
        """Fix tool -> @tool"""
        fixes = 0
        lines = content.split('\n')
        
        for i, line in enumerate(lines):
            stripped = line.strip()
            if stripped == 'tool' or (stripped.startswith('tool') and len(stripped.split()) == 1):
                # Replace with @tool, preserving indentation
                indent = line[:len(line) - len(line.lstrip())]
                lines[i] = f'{indent}@tool'
                fixes += 1
        
        return '\n'.join(lines), fixes
    
    def fix_yield_syntax(self, content: str) -> Tuple[str, int]:
        """Fix yield patterns"""
        fixes = 0
        
        # Simple yield replacement
        def replace_yield(match):
            nonlocal fixes
            fixes += 1
            prefix = match.group(1) if match.group(1) else ''
            args = match.group(2)
            return f'{prefix}await {args}'
        
        pattern = r'^(\s*)?yield\s*\(\s*([^)]+)\s*\)'
        content = re.sub(pattern, replace_yield, content, flags=re.MULTILINE)
        
        return content, fixes
    
    def fix_structural_issues(self, content: str) -> Tuple[str, int]:
        """Fix structural issues that cause parse errors"""
        fixes = 0
        lines = content.split('\n')
        fixed_lines = []
        
        i = 0
        while i < len(lines):
            line = lines[i]
            
            # Fix lines that start with class-level code outside functions
            if (line.strip() and 
                not line.strip().startswith('#') and
                not line.strip().startswith('class_name') and
                not line.strip().startswith('extends') and
                not line.strip().startswith('func ') and
                not line.strip().startswith('var ') and
                not line.strip().startswith('const ') and
                not line.strip().startswith('enum ') and
                not line.strip().startswith('signal ') and
                not line.strip().startswith('@') and
                not line.strip().startswith('if ') and
                not line.strip().startswith('else') and
                not line.strip().startswith('elif ') and
                not line.strip().startswith('for ') and
                not line.strip().startswith('while ') and
                not line.strip().startswith('match ') and
                not line.strip().startswith('return') and
                not line.strip().startswith('break') and
                not line.strip().startswith('continue') and
                not line.strip().startswith('pass') and
                line.startswith('\t') == False and
                '=' in line):
                
                # This looks like orphaned code - comment it out
                fixed_lines.append('# FIXME: Orphaned code - ' + line)
                fixes += 1
            else:
                fixed_lines.append(line)
            
            i += 1
        
        return '\n'.join(fixed_lines), fixes
    
    def fix_file(self, file_path: Path) -> Dict:
        """Fix a single GDScript file comprehensively"""
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
            
            # Apply all fixes in order
            content, fixes = self.fix_structural_issues(content)
            total_fixes += fixes
            
            content, fixes = self.fix_tool_syntax(content)
            total_fixes += fixes
            
            content, fixes = self.fix_onready_comprehensive(content)
            total_fixes += fixes
            
            content, fixes = self.fix_export_comprehensive(content)
            total_fixes += fixes
            
            content, fixes = self.fix_signal_syntax_comprehensive(content)
            total_fixes += fixes
            
            content, fixes = self.fix_yield_syntax(content)
            total_fixes += fixes
            
            # Write back if changes were made
            if content != original_content and total_fixes > 0:
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
        print("🔧 Running final comprehensive Godot 4 syntax fixes...")
        
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
            elif 'reason' in result and result['reason'] not in ['No changes needed', 'File ignored', 'Not a GDScript file']:
                relative_path = gd_file.relative_to(self.project_root)
                print(f"⚠️  Could not fix {relative_path}: {result['reason']}")
                self.errors.append(result)
        
        print(f"\n📊 Final Summary:")
        print(f"   Files scanned: {total_files}")
        print(f"   Files fixed: {fixed_files}")
        print(f"   Total fixes applied: {total_fixes}")
        print(f"   Errors: {len(self.errors)}")

def main():
    """Main function"""
    project_root = os.getcwd()
    
    print("🔧 Final Comprehensive Godot 4 Syntax Fixer")
    print("===========================================")
    print(f"Project: {project_root}")
    print("Targeting 5,406+ remaining syntax issues...")
    print()
    
    # Create fixer instance
    fixer = FinalSyntaxFixer(project_root)
    
    # Fix all files
    fixer.fix_all_files()
    
    print()
    print("✅ Final Godot 4 syntax fixing complete!")
    print()
    print("Next steps:")
    print("1. Run './validate_godot4_syntax_fixed.sh' to verify all fixes")
    print("2. Test project startup in Godot 4")
    print("3. Verify educational features are working")

if __name__ == "__main__":
    main()