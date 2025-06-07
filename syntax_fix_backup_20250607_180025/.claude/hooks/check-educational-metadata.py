#!/usr/bin/env python3
"""
Check educational metadata in NeuroVis files
Ensures proper learning objectives and clinical relevance documentation
"""

import re
import sys
import json
from pathlib import Path


# Required educational metadata for different file types
EDUCATIONAL_METADATA = {
    "gdscript": {
        "educational_components": [
            "@tutorial",
            "@educational_level",
            "@learning_objectives",
            "@clinical_relevance"
        ],
        "optional": [
            "@prerequisites",
            "@assessment",
            "@references"
        ]
    },
    "json": {
        "structure_fields": [
            "educationalLevel",
            "learningObjectives",
            "clinicalRelevance",
            "commonPathologies"
        ],
        "optional": [
            "prerequisites",
            "assessmentQuestions",
            "references"
        ]
    }
}

# Educational levels
VALID_EDUCATIONAL_LEVELS = ["beginner", "intermediate", "advanced"]

# Component patterns that require educational metadata
EDUCATIONAL_COMPONENTS = [
    r"educational",
    r"learning",
    r"tutorial",
    r"lesson",
    r"module",
    r"pathway",
    r"clinical",
    r"medical",
    r"anatomy",
    r"knowledge"
]


def check_educational_metadata(filepath, content):
    """Check educational metadata based on file type"""
    issues = []

    if filepath.endswith('.gd'):
        issues.extend(check_gdscript_metadata(filepath, content))
    elif filepath.endswith('.json'):
        issues.extend(check_json_metadata(filepath, content))

    return issues


def check_gdscript_metadata(filepath, content):
    """Check educational metadata in GDScript files"""
    issues = []
    lines = content.splitlines()

    # Check if this is an educational component
    if not is_educational_component(filepath, content):
        return issues

    # Look for metadata in first 50 lines
    found_metadata = set()
    metadata_values = {}

    for i, line in enumerate(lines[:50]):
        for metadata in EDUCATIONAL_METADATA["gdscript"]["educational_components"]:
            if metadata in line:
                found_metadata.add(metadata)
                # Extract value if present
                match = re.search(rf'{metadata}:\s*(.+)', line)
                if match:
                    metadata_values[metadata] = match.group(1).strip()

    # Check for missing required metadata
    missing = set(EDUCATIONAL_METADATA["gdscript"]["educational_components"]) - found_metadata

    if missing:
        issues.append({
            'line': 1,
            'level': 'warning',
            'message': f"Educational component missing metadata: {', '.join(missing)}"
        })

    # Validate metadata values
    if "@educational_level" in metadata_values:
        level = metadata_values["@educational_level"].lower()
        if level not in VALID_EDUCATIONAL_LEVELS:
            issues.append({
                'line': 1,
                'level': 'warning',
                'message': f"Invalid educational level '{level}'. Must be one of: {', '.join(VALID_EDUCATIONAL_LEVELS)}"
            })

    # Check learning objectives format
    if "@learning_objectives" in metadata_values:
        objectives = metadata_values["@learning_objectives"]
        if not objectives or len(objectives) < 10:
            issues.append({
                'line': 1,
                'level': 'info',
                'message': "Learning objectives should be detailed and specific"
            })

    # Check for optional metadata
    found_optional = set()
    for metadata in EDUCATIONAL_METADATA["gdscript"]["optional"]:
        if any(metadata in line for line in lines[:50]):
            found_optional.add(metadata)

    if not found_optional:
        issues.append({
            'line': 1,
            'level': 'info',
            'message': "Consider adding optional metadata: @prerequisites, @assessment, or @references"
        })

    return issues


def check_json_metadata(filepath, content):
    """Check educational metadata in JSON files"""
    issues = []

    # Only check anatomical data files
    if "anatomical" not in filepath.lower() and "educational" not in filepath.lower():
        return issues

    try:
        data = json.loads(content)
    except json.JSONDecodeError:
        # JSON syntax errors handled elsewhere
        return issues

    # Check structures in anatomical data
    if isinstance(data, dict) and "structures" in data:
        for i, structure in enumerate(data.get("structures", [])):
            structure_name = structure.get("displayName", f"Structure {i}")

            # Check required fields
            missing_fields = []
            for field in EDUCATIONAL_METADATA["json"]["structure_fields"]:
                if field not in structure:
                    missing_fields.append(field)

            if missing_fields:
                issues.append({
                    'line': 0,
                    'level': 'warning',
                    'message': f"Structure '{structure_name}' missing educational fields: {', '.join(missing_fields)}"
                })

            # Validate educational level
            if "educationalLevel" in structure:
                level = structure["educationalLevel"]
                if level not in VALID_EDUCATIONAL_LEVELS:
                    issues.append({
                        'line': 0,
                        'level': 'warning',
                        'message': f"Structure '{structure_name}' has invalid educational level: {level}"
                    })

            # Check learning objectives
            if "learningObjectives" in structure:
                objectives = structure["learningObjectives"]
                if not isinstance(objectives, list) or len(objectives) < 2:
                    issues.append({
                        'line': 0,
                        'level': 'info',
                        'message': f"Structure '{structure_name}' should have at least 2 learning objectives"
                    })

            # Check clinical relevance
            if "clinicalRelevance" in structure:
                relevance = structure["clinicalRelevance"]
                if not relevance or len(relevance) < 20:
                    issues.append({
                        'line': 0,
                        'level': 'info',
                        'message': f"Structure '{structure_name}' needs more detailed clinical relevance"
                    })

    return issues


def is_educational_component(filepath, content):
    """Check if file is an educational component"""
    # Check filepath
    filepath_lower = filepath.lower()
    for pattern in EDUCATIONAL_COMPONENTS:
        if pattern in filepath_lower:
            return True

    # Check content
    content_lower = content.lower()
    for pattern in EDUCATIONAL_COMPONENTS:
        if pattern in content_lower:
            # Make sure it's significant usage, not just a comment
            count = content_lower.count(pattern)
            if count >= 2:  # Mentioned at least twice
                return True

    # Check class names
    class_pattern = r'class_name\s+(\w+)'
    match = re.search(class_pattern, content)
    if match:
        class_name = match.group(1).lower()
        for pattern in EDUCATIONAL_COMPONENTS:
            if pattern in class_name:
                return True

    return False


def main():
    """Main entry point"""
    exit_code = 0

    for filepath in sys.argv[1:]:
        if not filepath.endswith(('.gd', '.json')):
            continue

        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            print(f"Error reading {filepath}: {e}")
            exit_code = 1
            continue

        issues = check_educational_metadata(filepath, content)

        if issues:
            # Only fail on warnings
            has_warnings = any(issue['level'] == 'warning' for issue in issues)
            if has_warnings:
                exit_code = 1

            for issue in issues:
                level = issue['level'].upper()
                if issue['line'] > 0:
                    print(f"{filepath}:{issue['line']}: {level}: {issue['message']}")
                else:
                    print(f"{filepath}: {level}: {issue['message']}")

    return exit_code


if __name__ == "__main__":
    sys.exit(main())
