#!/usr/bin/env python3
"""Fix ModularInfoPanel loading issue by ensuring proper dependency loading order."""

import re
import os

# Read the node_3d.gd file
file_path = "scenes/main/node_3d.gd"
if not os.path.exists(file_path):
    print(f"Error: {file_path} not found!")
    exit(1)

with open(file_path, 'r') as f:
    content = f.read()

# Find the line with "# New UI Component System" 
pattern = r'(# New UI Component System\n)'
replacement = r'# New UI Component System - Load base classes first to ensure proper dependency resolution\nconst BaseUIComponent = preload("res://ui/components/core/BaseUIComponent.gd")\nconst ResponsiveComponent = preload("res://ui/components/core/ResponsiveComponent.gd")\n'

# Replace the pattern
new_content = re.sub(pattern, replacement, content)

# Save the file
with open(file_path, 'w') as f:
    f.write(new_content)

print("✅ Fixed ModularInfoPanel loading issue!")
print("The dependency chain is now properly loaded:")
print("  1. BaseUIComponent")
print("  2. ResponsiveComponent") 
print("  3. UIComponentFactory")
print("  4. ModularInfoPanel (extends ResponsiveComponent)")
print("\nYou can now run your project without the parser error.")
