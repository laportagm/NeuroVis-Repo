#!/usr/bin/env python3
"""Fix remaining syntax issues in NeuroVis GDScript files."""

import re
from pathlib import Path

def fix_indentation_and_structure(content):
    """Fix severe indentation and structural issues."""
    lines = content.split('\n')
    fixed_lines = []
    current_indent = 0
    in_function = False
    function_has_return = False
    last_was_return = False

    for i, line in enumerate(lines):
        stripped = line.strip()

        # Skip empty lines
        if not stripped:
            fixed_lines.append('')
            continue

        # Handle comments
        if stripped.startswith('#'):
            # Keep orphaned code comments but properly indent them
            if 'FIXED: Orphaned code' in stripped:
                fixed_lines.append('\t' * current_indent + stripped)
            else:
                fixed_lines.append(line)
            continue

        # Detect function declarations
        if re.match(r'^(static\s+)?func\s+\w+.*\)\s*(->\s*\w+)?\s*:', stripped):
            # End previous function if needed
            if in_function and not function_has_return:
                # Add a return statement if missing
                if '->' in fixed_lines[-10:] if len(fixed_lines) > 10 else fixed_lines:
                    # Find the return type
                    for prev_line in reversed(fixed_lines[-10:]):
                        if 'func' in prev_line and '->' in prev_line:
                            return_type = re.search(r'->\s*(\w+)', prev_line)
                            if return_type:
                                rtype = return_type.group(1)
                                if rtype == 'void':
                                    fixed_lines.append('\t' * current_indent + 'pass')
                                elif rtype == 'bool':
                                    fixed_lines.append('\t' * current_indent + 'return false')
                                elif rtype == 'int':
                                    fixed_lines.append('\t' * current_indent + 'return 0')
                                elif rtype == 'float':
                                    fixed_lines.append('\t' * current_indent + 'return 0.0')
                                elif rtype == 'String':
                                    fixed_lines.append('\t' * current_indent + 'return ""')
                                elif rtype == 'Dictionary':
                                    fixed_lines.append('\t' * current_indent + 'return {}')
                                elif rtype == 'Array':
                                    fixed_lines.append('\t' * current_indent + 'return []')
                                elif rtype == 'Control' or rtype == 'Node':
                                    fixed_lines.append('\t' * current_indent + 'return null')
                                else:
                                    fixed_lines.append('\t' * current_indent + 'return null')
                            break

            # Reset for new function
            current_indent = 0
            in_function = True
            function_has_return = False

            # Check if it's a static function
            if stripped.startswith('static'):
                fixed_lines.append('static ' + stripped[7:])
            else:
                fixed_lines.append(stripped)
            current_indent = 1
            continue

        # Handle class declaration
        if re.match(r'^class_name\s+\w+', stripped):
            current_indent = 0
            fixed_lines.append(stripped)
            continue

        # Handle extends
        if re.match(r'^extends\s+\w+', stripped):
            current_indent = 0
            fixed_lines.append(stripped)
            continue

        # Handle const/var at class level
        if re.match(r'^(const|var|@export|@onready)\s+', stripped) and current_indent == 0:
            fixed_lines.append(stripped)
            continue

        # Handle return statements
        if stripped.startswith('return'):
            function_has_return = True
            last_was_return = True
            fixed_lines.append('\t' * current_indent + stripped)
            continue

        # Handle match statements
        if re.match(r'^match\s+.+:', stripped):
            fixed_lines.append('\t' * current_indent + stripped)
            current_indent += 1
            continue

        # Handle match cases (pattern:)
        if re.match(r'^["\']?\w+["\']?\s*:', stripped) and current_indent > 0:
            # This might be a match case
            fixed_lines.append('\t' * (current_indent - 1) + stripped)
            continue

        # Default: maintain current indentation
        fixed_lines.append('\t' * current_indent + stripped)

        # Track if we had a return
        if not stripped.startswith('return'):
            last_was_return = False

    # Handle final function if needed
    if in_function and not function_has_return:
        # Add a return statement if missing
        for prev_line in reversed(fixed_lines[-10:]):
            if 'func' in prev_line and '->' in prev_line:
                return_type = re.search(r'->\s*(\w+)', prev_line)
                if return_type:
                    rtype = return_type.group(1)
                    if rtype == 'void':
                        fixed_lines.append('\tpass')
                    elif rtype == 'bool':
                        fixed_lines.append('\treturn false')
                    elif rtype == 'int':
                        fixed_lines.append('\treturn 0')
                    elif rtype == 'float':
                        fixed_lines.append('\treturn 0.0')
                    elif rtype == 'String':
                        fixed_lines.append('\treturn ""')
                    elif rtype == 'Dictionary':
                        fixed_lines.append('\treturn {}')
                    elif rtype == 'Array':
                        fixed_lines.append('\treturn []')
                    elif rtype == 'Control' or rtype == 'Node':
                        fixed_lines.append('\treturn null')
                    else:
                        fixed_lines.append('\treturn null')
                break

    return '\n'.join(fixed_lines)

def fix_orphaned_variables(content):
    """Fix orphaned variable references from commented code."""
    lines = content.split('\n')
    fixed_lines = []

    # Track variables that were orphaned
    orphaned_vars = set()

    # First pass: identify orphaned variables
    for line in lines:
        if '# FIXED: Orphaned code' in line:
            # Extract variable names
            var_match = re.search(r'var\s+(\w+)', line)
            if var_match:
                orphaned_vars.add(var_match.group(1))

    # Second pass: fix references to orphaned variables
    for line in lines:
        if '# FIXED: Orphaned code' in line:
            fixed_lines.append(line)
            continue

        # Check if line references an orphaned variable
        modified_line = line
        for var in orphaned_vars:
            # Look for references to the variable (not declarations)
            if re.search(rf'\b{var}\b', line) and not re.search(rf'var\s+{var}\b', line):
                # Comment out lines that reference orphaned variables
                if not line.strip().startswith('#'):
                    modified_line = '\t# ORPHANED REF: ' + line.lstrip()
                    break

        fixed_lines.append(modified_line)

    return '\n'.join(fixed_lines)

def fix_specific_file_issues(filepath, content):
    """Apply file-specific fixes."""
    filename = Path(filepath).name

    if filename == "ComponentRegistryCompat.gd":
        # Fix the specific indentation cascade issue
        lines = content.split('\n')
        fixed_lines = []

        for line in lines:
            # Remove excessive indentation from static functions
            if '\t\t\t\t\t\t\t\t\t\t' in line:  # Way too much indentation
                # Count actual tabs needed
                stripped = line.lstrip()
                if stripped.startswith('static func'):
                    fixed_lines.append(stripped)
                elif stripped.startswith('return'):
                    fixed_lines.append('\t' + stripped)
                else:
                    fixed_lines.append(line)
            elif '\t\t\t' in line and 'static func' in line:
                # Fix cascading indented static functions
                fixed_lines.append(line.lstrip())
            else:
                fixed_lines.append(line)

        content = '\n'.join(fixed_lines)

    elif filename == "SimplifiedComponentFactory.gd":
        # Fix the match statement structure
        content = re.sub(r'^"(\w+)":\s*$', r'\t\t"\1":', content, flags=re.MULTILINE)
        # Fix orphaned returns
        content = re.sub(r'^return\s+', '\t\t\treturn ', content, flags=re.MULTILINE)

    return content

def process_file(filepath):
    """Process a single file."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        original = content

        # Apply general fixes
        content = fix_indentation_and_structure(content)
        content = fix_orphaned_variables(content)

        # Apply file-specific fixes
        content = fix_specific_file_issues(filepath, content)

        if content != original:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        return False

    except Exception as e:
        print(f"Error processing {filepath}: {e}")
        return False

def main():
    """Main function."""
    project_root = Path("/Users/gagelaporta/Desktop/Neuro/NeuroVis-Repo")

    # Priority files with known issues
    priority_files = [
        "ui/core/ComponentRegistryCompat.gd",
        "ui/core/SimplifiedComponentFactory.gd",
        "ui/core/ComponentRegistry.gd",
        "ui/integration/FoundationDemo.gd",
        "ui/panels/BrainAnalysisPanel.gd",
        "ui/panels/LoadingOverlay.gd",
        "ui/panels/InfoPanelFactory.gd"
    ]

    fixed_count = 0

    print("Fixing priority files with syntax issues...")
    for file_path in priority_files:
        full_path = project_root / file_path
        if full_path.exists():
            print(f"Processing: {file_path}")
            if process_file(full_path):
                fixed_count += 1
                print(f"  ✓ Fixed")
            else:
                print(f"  - No changes")

    # Now scan all GD files
    print("\nScanning all GDScript files...")
    for gd_file in project_root.rglob("*.gd"):
        relative_path = gd_file.relative_to(project_root)
        if str(relative_path) not in priority_files:
            try:
                with open(gd_file, 'r') as f:
                    content = f.read()

                # Check for issues
                if ('static func' in content and
                    ('\t\t\tstatic func' in content or
                     'return panel' in content and 'var panel' not in content)):

                    print(f"Processing: {relative_path}")
                    if process_file(gd_file):
                        fixed_count += 1
                        print(f"  ✓ Fixed")

            except Exception:
                pass

    print(f"\nTotal files fixed: {fixed_count}")

if __name__ == "__main__":
    main()
