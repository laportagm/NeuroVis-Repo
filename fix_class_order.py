#!/usr/bin/env python3
"""
Script to automatically fix class-definitions-order errors in GDScript files.
This script reorganizes class members according to the GDScript style guide:

1. Class docstring
2. Signals
3. Enums
4. Constants
5. Exported variables (@export)
6. Public variables (var)
7. Private variables (var _name)
8. Onready variables (@onready var)
9. Built-in virtual methods (_init, _ready, _process, etc.)
10. Public methods
11. Private methods (func _name)
12. Signal callbacks
"""

import os
import re
import sys
from pathlib import Path
from typing import List, Dict, Tuple

class GDScriptClassReorganizer:
    def __init__(self):
        # Define the order of class members according to GDScript style guide
        self.member_order = [
            'docstring',
            'class_name_extends',
            'signals',
            'enums',
            'constants',
            'exports',
            'public_vars',
            'private_vars',
            'onready_vars',
            'builtin_methods',
            'public_methods',
            'private_methods',
            'signal_callbacks'
        ]

        # Patterns to identify different types of class members
        self.patterns = {
            'signal': re.compile(r'^signal\s+\w+'),
            'enum': re.compile(r'^enum\s+\w+'),
            'const': re.compile(r'^const\s+\w+'),
            'export': re.compile(r'^@export'),
            'onready': re.compile(r'^@onready\s+var'),
            'private_var': re.compile(r'^var\s+_\w+'),
            'public_var': re.compile(r'^var\s+[a-zA-Z]\w*'),
            'private_func': re.compile(r'^func\s+_\w+'),
            'public_func': re.compile(r'^func\s+[a-zA-Z]\w*'),
            'builtin_func': re.compile(r'^func\s+_(ready|init|process|unhandled_input|physics_process|enter_tree|exit_tree)'),
            'class_name': re.compile(r'^class_name\s+\w+'),
            'extends': re.compile(r'^extends\s+'),
        }

    def categorize_line(self, line: str) -> str:
        """Categorize a line of GDScript code."""
        line = line.strip()

        if not line or line.startswith('#'):
            return 'comment'

        # Check for class_name and extends
        if self.patterns['class_name'].match(line) or self.patterns['extends'].match(line):
            return 'class_name_extends'

        # Check for signals
        if self.patterns['signal'].match(line):
            return 'signals'

        # Check for enums
        if self.patterns['enum'].match(line):
            return 'enums'

        # Check for constants
        if self.patterns['const'].match(line):
            return 'constants'

        # Check for exports
        if self.patterns['export'].match(line):
            return 'exports'

        # Check for onready variables
        if self.patterns['onready'].match(line):
            return 'onready_vars'

        # Check for variables
        if self.patterns['private_var'].match(line):
            return 'private_vars'
        if self.patterns['public_var'].match(line):
            return 'public_vars'

        # Check for functions
        if self.patterns['builtin_func'].match(line):
            return 'builtin_methods'
        if self.patterns['private_func'].match(line):
            return 'private_methods'
        if self.patterns['public_func'].match(line):
            return 'public_methods'

        return 'other'

    def reorganize_file(self, filepath: str) -> bool:
        """Reorganize a single GDScript file."""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                lines = f.readlines()

            # Group lines by category
            categories = {cat: [] for cat in self.member_order}
            categories['other'] = []
            categories['comment'] = []

            current_category = None
            current_block = []

            for i, line in enumerate(lines):
                category = self.categorize_line(line)

                if category != 'comment' and category != 'other':
                    if current_category != category:
                        # Save previous block
                        if current_category and current_block:
                            categories[current_category].extend(current_block)
                        current_category = category
                        current_block = [line]
                    else:
                        current_block.append(line)
                else:
                    # Handle comments and other lines
                    if current_category:
                        current_block.append(line)
                    else:
                        if category == 'comment':
                            categories['comment'].append(line)
                        else:
                            categories['other'].append(line)

            # Save final block
            if current_category and current_block:
                categories[current_category].extend(current_block)

            # Reconstruct file in proper order
            new_lines = []

            # Add docstring/comments at the top
            new_lines.extend(categories['comment'])

            # Add class members in proper order
            for category in self.member_order:
                if categories[category]:
                    if new_lines and not new_lines[-1].strip() == '':
                        new_lines.append('\n')
                    new_lines.extend(categories[category])

            # Add any other lines at the end
            if categories['other']:
                new_lines.extend(categories['other'])

            # Write back to file
            with open(filepath, 'w', encoding='utf-8') as f:
                f.writelines(new_lines)

            return True

        except Exception as e:
            print(f"Error processing {filepath}: {e}")
            return False

def main():
    """Main function to process all GDScript files in the project."""
    if len(sys.argv) > 1:
        project_root = sys.argv[1]
    else:
        project_root = "/Users/gagelaporta/Desktop/Neuro/NeuroVis-Repo"

    reorganizer = GDScriptClassReorganizer()

    # Find all .gd files
    gd_files = list(Path(project_root).rglob("*.gd"))

    print(f"Found {len(gd_files)} GDScript files to process...")

    success_count = 0
    for gd_file in gd_files:
        print(f"Processing: {gd_file}")
        if reorganizer.reorganize_file(str(gd_file)):
            success_count += 1
        else:
            print(f"Failed to process: {gd_file}")

    print(f"\nCompleted! Successfully processed {success_count}/{len(gd_files)} files.")

if __name__ == "__main__":
    main()
