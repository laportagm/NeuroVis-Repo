#!/usr/bin/env python3
"""
NeuroVis GDScript Syntax Fixer - FIXED VERSION
Fixes common GDScript syntax issues including indentation, class structure, and control flow problems.
"""

import os
import re
import sys
import glob
import shutil
from pathlib import Path
from datetime import datetime

class GDScriptSyntaxFixer:
    def __init__(self, project_path):
        self.project_path = Path(project_path)
        self.backup_dir = self.project_path / f"syntax_fix_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        self.issues_fixed = 0
        self.files_processed = 0

    def fix_indentation_issues(self, content: str) -> str:
        """Fix common indentation problems in GDScript"""
        lines = content.split('\n')
        fixed_lines = []
        current_indent = 0

        for i, line in enumerate(lines):
            stripped = line.strip()

            # Skip empty lines
            if not stripped:
                fixed_lines.append('')
                continue

            # Skip comments
            if stripped.startswith('#'):
                fixed_lines.append('\t' * current_indent + stripped)
                continue

            # Determine proper indentation level
            if self._is_class_level_statement(stripped):
                current_indent = 0
            elif self._is_function_definition(stripped):
                current_indent = 0
            elif self._is_block_start(stripped):
                # This line starts a new block
                pass
            elif self._is_block_end(stripped) or self._is_continuation(stripped):
                # Maintain current indent
                pass
            elif self._should_be_indented(stripped, i, lines):
                current_indent = max(1, current_indent)

            # Apply indentation
            if stripped:
                fixed_lines.append('\t' * current_indent + stripped)

                # Update indent for next line
                if self._increases_indent(stripped):
                    current_indent += 1
                elif self._decreases_indent(stripped):
                    current_indent = max(0, current_indent - 1)
            else:
                fixed_lines.append('')

        return '\n'.join(fixed_lines)

    def fix_class_structure(self, content: str) -> str:
        """Fix class structure issues"""
        lines = content.split('\n')
        fixed_lines = []
        in_function = False
        function_indent = 0

        for line in lines:
            stripped = line.strip()

            # Skip empty lines and comments
            if not stripped or stripped.startswith('#'):
                fixed_lines.append(line)
                continue

            # Handle class-level statements
            if self._is_class_level_statement(stripped):
                in_function = False
                fixed_lines.append(stripped)
                continue

            # Handle function definitions
            if self._is_function_definition(stripped):
                in_function = True
                function_indent = 1
                fixed_lines.append(stripped)
                continue

            # Handle statements that should be inside functions
            if self._needs_function_wrapper(stripped) and not in_function:
                # Wrap orphaned statements in a function
                fixed_lines.append('func _fix_orphaned_code():')
                fixed_lines.append('\t' + stripped)
                in_function = True
                function_indent = 1
                continue

            # Regular line processing
            if in_function:
                # Ensure proper indentation inside functions
                if not line.startswith('\t') and stripped:
                    fixed_lines.append('\t' * function_indent + stripped)
                else:
                    fixed_lines.append(line)
            else:
                fixed_lines.append(line)

        return '\n'.join(fixed_lines)

    def fix_control_flow(self, content: str) -> str:
        """Fix control flow statement placement"""
        lines = content.split('\n')
        fixed_lines = []

        for i, line in enumerate(lines):
            stripped = line.strip()

            # Fix orphaned control flow statements
            if re.match(r'^(if|elif|else|for|while|match|return|break|continue)\b', stripped):
                # Ensure these are properly indented and in function context
                if not self._is_in_function_context(i, lines):
                    # Skip or wrap in function if needed
                    continue

            # Fix return statements outside functions
            if stripped.startswith('return ') and not self._is_in_function_context(i, lines):
                continue  # Remove orphaned return statements

            fixed_lines.append(line)

        return '\n'.join(fixed_lines)

    def fix_syntax_errors(self, content: str) -> str:
        """Fix common syntax errors"""
        # Fix variable declarations
        content = re.sub(r'^(\s*)var\s+if\b', r'\1var temp_var\n\1if', content, flags=re.MULTILINE)

        # Fix malformed if statements
        content = re.sub(r'^\s*if\s*$', '', content, flags=re.MULTILINE)

        # Fix incomplete function definitions
        content = re.sub(r'^(\s*)func\s*$', r'\1func placeholder():', content, flags=re.MULTILINE)

        # Remove orphaned colons
        content = re.sub(r'^(\s*):(\s*)$', r'', content, flags=re.MULTILINE)

        # Fix malformed class declarations
        content = re.sub(r'^(\s*)class_name\s*$', r'\1class_name PlaceholderClass', content, flags=re.MULTILINE)

        return content

    def _is_class_level_statement(self, line: str) -> bool:
        """Check if line is a class-level statement"""
        return (line.startswith(('extends ', 'class_name ', 'signal ', '@export', '@onready', 'const ', 'enum ')) or
                line.startswith(('var ', 'func ')) and not line.strip().endswith(':'))

    def _is_function_definition(self, line: str) -> bool:
        """Check if line is a function definition"""
        return line.startswith('func ') and line.endswith(':')

    def _is_block_start(self, line: str) -> bool:
        """Check if line starts a new block"""
        return line.endswith(':')

    def _is_block_end(self, line: str) -> bool:
        """Check if line ends a block"""
        return line in ['pass', 'break', 'continue'] or line.startswith('return')

    def _is_continuation(self, line: str) -> bool:
        """Check if line is a continuation of previous statement"""
        return line.startswith(('and ', 'or ', '.', '+', '-', '*', '/', '='))

    def _should_be_indented(self, line: str, line_num: int, lines: list) -> bool:
        """Check if line should be indented"""
        if line_num == 0:
            return False
        prev_line = lines[line_num - 1].strip()
        return prev_line.endswith(':') or self._is_inside_block(line_num, lines)

    def _is_inside_block(self, line_num: int, lines: list) -> bool:
        """Check if line is inside a code block"""
        # Look backward for block start
        for i in range(line_num - 1, -1, -1):
            stripped = lines[i].strip()
            if stripped.endswith(':'):
                return True
            if stripped.startswith(('func ', 'class ', 'if ', 'for ', 'while ')):
                return True
        return False

    def _increases_indent(self, line: str) -> bool:
        """Check if line increases indentation for next line"""
        return line.endswith(':')

    def _decreases_indent(self, line: str) -> bool:
        """Check if line decreases indentation for next line"""
        return False  # Simplified for now

    def _needs_function_wrapper(self, line: str) -> bool:
        """Check if line needs to be wrapped in a function"""
        return (line.startswith(('if ', 'for ', 'while ', 'return ', 'print(', 'var ')) and
                not line.startswith(('var ', 'const ', 'signal ', 'func ')))

    def _is_in_function_context(self, line_num: int, lines: list) -> bool:
        """Check if line is inside a function"""
        for i in range(line_num, -1, -1):
            stripped = lines[i].strip()
            if stripped.startswith('func ') and stripped.endswith(':'):
                return True
            if stripped.startswith(('class_name ', 'extends ')):
                return False
        return False

    def process_file(self, file_path: Path) -> bool:
        """Process a single GDScript file"""
        try:
            print(f"🔧 Processing: {file_path.relative_to(self.project_path)}")

            # Read original content
            with open(file_path, 'r', encoding='utf-8') as f:
                original_content = f.read()

            # Create backup
            backup_path = self.backup_dir / file_path.relative_to(self.project_path)
            backup_path.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(file_path, backup_path)

            # Apply fixes
            fixed_content = original_content
            fixed_content = self.fix_syntax_errors(fixed_content)
            fixed_content = self.fix_class_structure(fixed_content)
            fixed_content = self.fix_control_flow(fixed_content)
            fixed_content = self.fix_indentation_issues(fixed_content)

            # Write fixed content
            if fixed_content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(fixed_content)
                print(f"  ✅ Fixed syntax issues")
                self.issues_fixed += 1
                return True
            else:
                print(f"  ℹ️  No issues found")
                return False

        except Exception as e:
            print(f"  ❌ Error processing file: {e}")
            return False

    def find_gdscript_files(self) -> list:
        """Find all GDScript files in the project"""
        gdscript_files = []

        for root, dirs, files in os.walk(self.project_path):
            # Skip backup and .godot directories
            dirs[:] = [d for d in dirs if not d.startswith(('.godot', 'backup', 'temp_', 'syntax_fix_backup_'))]

            for file in files:
                if file.endswith('.gd'):
                    gdscript_files.append(Path(root) / file)

        return gdscript_files

    def run(self):
        """Run the syntax fixer"""
        print("🔧 NeuroVis GDScript Syntax Fixer")
        print("=" * 40)

        # Create backup directory
        self.backup_dir.mkdir(exist_ok=True)
        print(f"📁 Backup directory: {self.backup_dir}")

        # Find GDScript files
        gdscript_files = self.find_gdscript_files()
        print(f"📄 Found {len(gdscript_files)} GDScript files")

        # Process each file
        for file_path in gdscript_files:
            self.process_file(file_path)
            self.files_processed += 1

        # Summary
        print("\n" + "=" * 40)
        print(f"✅ Processing complete!")
        print(f"   Files processed: {self.files_processed}")
        print(f"   Files with fixes: {self.issues_fixed}")
        print(f"   Backup location: {self.backup_dir}")

        if self.issues_fixed > 0:
            print("\n💡 Next steps:")
            print("   1. Test your project in Godot")
            print("   2. If issues persist, check the backup directory")
            print("   3. Run the Godot validation script again")

def main():
    # Get project path
    if len(sys.argv) > 1:
        project_path = sys.argv[1]
    else:
        project_path = os.getcwd()

    # Run the fixer
    fixer = GDScriptSyntaxFixer(project_path)
    fixer.run()

if __name__ == "__main__":
    main()
