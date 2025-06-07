#!/usr/bin/env python3
"""
Validate Godot scene files (.tscn) for broken references and structure issues
"""

import re
import sys
import os
from pathlib import Path


def validate_scene_file(filepath):
    """Validate a single scene file"""
    errors = []
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            lines = content.splitlines()
    except Exception as e:
        return [f"Failed to read file: {e}"]
    
    # Check file header
    if not lines or not lines[0].startswith("[gd_scene"):
        errors.append("Invalid scene file header")
    
    # Extract and validate resource references
    res_pattern = re.compile(r'(?:path|script|texture|font)="(res://[^"]+)"')
    line_num = 0
    
    for line in lines:
        line_num += 1
        matches = res_pattern.findall(line)
        
        for resource_path in matches:
            # Convert res:// path to actual file path
            actual_path = resource_path.replace("res://", "")
            
            # Check if file exists
            if not os.path.exists(actual_path):
                # Check with .import extension for imported resources
                if not os.path.exists(actual_path + ".import"):
                    errors.append(f"Line {line_num}: Broken reference: {resource_path}")
    
    # Check for node path references
    node_pattern = re.compile(r'NodePath\("([^"]+)"\)')
    for i, line in enumerate(lines):
        matches = node_pattern.findall(line)
        for node_path in matches:
            # Basic validation - check for invalid characters
            if ".." in node_path and node_path.count("..") > 10:
                errors.append(f"Line {i+1}: Suspicious node path with many parent references: {node_path}")
    
    # Check for duplicate node names in same level
    node_names = {}
    current_parent = ""
    node_pattern = re.compile(r'\[node name="([^"]+)".*parent="([^"]*)"')
    
    for i, line in enumerate(lines):
        match = node_pattern.search(line)
        if match:
            name = match.group(1)
            parent = match.group(2)
            
            key = f"{parent}/{name}"
            if key in node_names:
                errors.append(f"Line {i+1}: Duplicate node name '{name}' under parent '{parent}'")
            node_names[key] = i + 1
    
    return errors


def main():
    """Main entry point"""
    exit_code = 0
    
    for filepath in sys.argv[1:]:
        if not filepath.endswith('.tscn'):
            continue
            
        errors = validate_scene_file(filepath)
        
        if errors:
            print(f"\n{filepath}:")
            for error in errors:
                print(f"  ERROR: {error}")
            exit_code = 1
    
    return exit_code


if __name__ == "__main__":
    sys.exit(main())