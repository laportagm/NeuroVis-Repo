#!/usr/bin/env python3
"""
Fix all syntax errors in NeuroVis GDScript files.
This script fixes:
1. Multiple "pre" prefixes in preload statements
2. _fix_orphaned_code wrapper functions
3. Orphaned code blocks
"""

import os
import re
from pathlib import Path

def fix_preload_syntax(content):
    """Fix multiple 'pre' prefixes in preload statements."""
    # Pattern to match preprepreprepreload and similar
    pattern = r'pre(?:pre)+load\('
    replacement = 'preload('
    return re.sub(pattern, replacement, content)

def remove_fix_orphaned_code_wrappers(content):
    """Remove _fix_orphaned_code wrapper functions and preserve their content."""
    lines = content.split('\n')
    new_lines = []
    i = 0

    while i < len(lines):
        line = lines[i]

        # Check if this is a _fix_orphaned_code function
        if re.match(r'^func\s+_fix_orphaned_code\s*\(\s*\)\s*:', line):
            # Skip the function definition line
            i += 1
            indent_level = None

            # Process the function body
            while i < len(lines):
                current_line = lines[i]

                # Skip empty lines at the beginning
                if current_line.strip() == '' and indent_level is None:
                    i += 1
                    continue

                # Determine the indent level of the function body
                if indent_level is None and current_line.strip():
                    indent_level = len(current_line) - len(current_line.lstrip())

                # Check if we've exited the function
                if current_line.strip() and indent_level is not None:
                    current_indent = len(current_line) - len(current_line.lstrip())
                    if current_indent < indent_level:
                        # We've exited the function, don't include this line
                        break

                # Remove one level of indentation from the function body
                if indent_level is not None and current_line.strip():
                    if current_line.startswith('\t' * (indent_level // 4)):
                        current_line = current_line[indent_level:]
                    elif current_line.startswith(' ' * indent_level):
                        current_line = current_line[indent_level:]

                new_lines.append(current_line)
                i += 1
        else:
            new_lines.append(line)
            i += 1

    return '\n'.join(new_lines)

def fix_orphaned_code_blocks(content):
    """Fix orphaned code blocks that are not properly indented."""
    lines = content.split('\n')
    new_lines = []

    for i, line in enumerate(lines):
        # Skip if line is already properly indented or empty
        if not line.strip() or line[0] in [' ', '\t', '#']:
            new_lines.append(line)
            continue

        # Check for orphaned variable declarations
        if re.match(r'^var\s+\w+', line) and i > 0:
            # This might be orphaned code - check context
            prev_non_empty = None
            for j in range(i-1, -1, -1):
                if lines[j].strip():
                    prev_non_empty = lines[j]
                    break

            # If previous line is a closing brace or similar, this is likely orphaned
            if prev_non_empty and (prev_non_empty.strip().endswith('}') or
                                  prev_non_empty.strip().endswith(')')):
                # Comment out orphaned code
                new_lines.append('# FIXED: Orphaned code - ' + line)
                continue

        new_lines.append(line)

    return '\n'.join(new_lines)

def process_file(filepath):
    """Process a single GDScript file to fix syntax errors."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        original_content = content

        # Apply fixes
        content = fix_preload_syntax(content)
        content = remove_fix_orphaned_code_wrappers(content)
        content = fix_orphaned_code_blocks(content)

        # Only write if changes were made
        if content != original_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        return False
    except Exception as e:
        print(f"Error processing {filepath}: {e}")
        return False

def main():
    """Main function to process all GDScript files."""
    # Use current working directory as project root
    project_root = Path.cwd()

    # Files with known issues
    problem_files = [
        "ui/theme/StyleEngine.gd",
        "ui/state/ComponentStateManager.gd",
        "ui/panels/GeminiSetupDialog.gd",
        "ui/panels/EducationalTooltipManager.gd",
        "ui/integration/FoundationDemo.gd",
        "ui/core/ComponentRegistryCompat.gd",
        "ui/core/ComponentRegistry.gd",
        "ui/components/panels/EnhancedAIAssistant.gd",
        "ui/components/fragments/SectionComponent.gd",
        "ui/components/fragments/HeaderComponent.gd",
        "ui/components/fragments/ContentComponent.gd",
        "ui/components/fragments/ActionsComponent.gd",
        "ui/components/core/BaseUIComponent.gd",
        "ui/components/InfoPanelComponent.gd",
        "ui/components/core/UIComponentFactory.gd",
        "ui/panels/EnhancedInformationPanel.gd",
        "ui/panels/LoadingOverlay_Enhanced.gd",
        "ui/panels/EducationalNotificationSystem.gd",
        "tools/scripts/test_refactoring.gd",
        "scenes/main/components/AICoordinator.gd",
        "ui/panels/ThemeToggle.gd"
    ]

    fixed_count = 0

    # First, fix the known problem files
    print("Fixing known problem files...")
    for file_path in problem_files:
        full_path = project_root / file_path
        if full_path.exists():
            print(f"Processing: {file_path}")
            if process_file(full_path):
                fixed_count += 1
                print(f"  ✓ Fixed")
            else:
                print(f"  - No changes needed")
        else:
            print(f"  ✗ File not found: {file_path}")

    # Then scan for any other GDScript files with these issues
    print("\nScanning for other files with syntax errors...")
    for gd_file in project_root.rglob("*.gd"):
        # Skip already processed files
        relative_path = gd_file.relative_to(project_root)
        if str(relative_path) in problem_files:
            continue

        try:
            with open(gd_file, 'r', encoding='utf-8') as f:
                content = f.read()

            # Check if file has any of our target issues
            if ('preprepreprepreload' in content or
                'preprepreload' in content or
                'prepreload' in content or
                '_fix_orphaned_code' in content):

                print(f"Processing: {relative_path}")
                if process_file(gd_file):
                    fixed_count += 1
                    print(f"  ✓ Fixed")
        except Exception as e:
            pass  # Skip files that can't be read

    print(f"\nTotal files fixed: {fixed_count}")

if __name__ == "__main__":
    main()
