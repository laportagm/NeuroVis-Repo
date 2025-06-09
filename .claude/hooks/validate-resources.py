#!/usr/bin/env python3
"""
Validate Godot resource files (.tres, .res) for structure and references
"""

import re
import sys
import os
from pathlib import Path


def validate_resource_file(filepath):
    """Validate a single resource file"""
    errors = []

    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            lines = content.splitlines()
    except Exception as e:
        return [f"Failed to read file: {e}"]

    # Check file header
    if not lines:
        errors.append("Empty resource file")
        return errors

    # Valid headers for resource files
    valid_headers = ["[gd_resource", "[gd_scene", "[resource"]
    has_valid_header = any(lines[0].strip().startswith(header) for header in valid_headers)

    if not has_valid_header:
        errors.append(f"Invalid resource file header: {lines[0]}")

    # Check format version
    if "format=" in lines[0]:
        match = re.search(r'format=(\d+)', lines[0])
        if match:
            format_version = int(match.group(1))
            if format_version < 2:
                errors.append(f"Resource uses old format version {format_version}, consider updating")

    # Validate resource paths
    res_pattern = re.compile(r'(?:path|script|texture|font|mesh|material)="(res://[^"]+)"')
    line_num = 0

    for line in lines:
        line_num += 1
        matches = res_pattern.findall(line)

        for resource_path in matches:
            # Convert res:// path to actual file path
            actual_path = resource_path.replace("res://", "")

            # Skip built-in resources
            if "<built-in>" in actual_path:
                continue

            # Check if file exists
            if not os.path.exists(actual_path):
                # Check with .import extension
                if not os.path.exists(actual_path + ".import"):
                    errors.append(f"Line {line_num}: Broken reference: {resource_path}")

    # Check for ExtResource references
    ext_resource_pattern = re.compile(r'\[ext_resource.*id="([^"]+)".*path="([^"]+)"')
    resource_ids = {}

    for i, line in enumerate(lines):
        match = ext_resource_pattern.search(line)
        if match:
            res_id = match.group(1)
            res_path = match.group(2)

            if res_id in resource_ids:
                errors.append(f"Line {i+1}: Duplicate ExtResource ID: {res_id}")
            resource_ids[res_id] = res_path

    # Validate SubResource sections
    sub_resource_pattern = re.compile(r'\[sub_resource.*id="([^"]+)"')
    sub_resource_ids = {}

    for i, line in enumerate(lines):
        match = sub_resource_pattern.search(line)
        if match:
            sub_id = match.group(1)

            if sub_id in sub_resource_ids:
                errors.append(f"Line {i+1}: Duplicate SubResource ID: {sub_id}")
            sub_resource_ids[sub_id] = i + 1

    # Check for references to non-existent resources
    ref_pattern = re.compile(r'ExtResource\("([^"]+)"\)')
    for i, line in enumerate(lines):
        matches = ref_pattern.findall(line)
        for ref_id in matches:
            if ref_id not in resource_ids:
                errors.append(f"Line {i+1}: Reference to non-existent ExtResource: {ref_id}")

    return errors


def main():
    """Main entry point"""
    exit_code = 0

    for filepath in sys.argv[1:]:
        if not filepath.endswith(('.tres', '.res')):
            continue

        errors = validate_resource_file(filepath)

        if errors:
            print(f"\n{filepath}:")
            for error in errors:
                print(f"  ERROR: {error}")
            exit_code = 1

    return exit_code


if __name__ == "__main__":
    sys.exit(main())
