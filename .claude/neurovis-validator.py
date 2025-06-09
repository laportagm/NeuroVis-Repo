#!/usr/bin/env python3
"""
NeuroVis Custom Validation Script
Educational medical visualization platform code quality checks

This script performs project-specific validations that go beyond standard
linting, including medical terminology validation, educational metadata checks,
and performance/accessibility annotations.
"""

import json
import os
import re
import sys
from collections import defaultdict
from pathlib import Path
from typing import Dict, List, Set, Tuple

# NeuroVis project constants
AUTOLOAD_SERVICES = {
    "KB": "Knowledge Base (Legacy)",
    "KnowledgeService": "Educational Content Service",
    "AIAssistant": "AI Educational Support",
    "UIThemeManager": "Theme Management",
    "ModelSwitcherGlobal": "3D Model Visibility",
    "StructureAnalysisManager": "Structure Analysis",
    "DebugCmd": "Debug Commands"
}

MEDICAL_TERMS = {
    # Brain structures
    "hippocampus", "amygdala", "thalamus", "hypothalamus", "cerebellum",
    "cortex", "brainstem", "pons", "medulla", "midbrain", "striatum",
    "putamen", "caudate", "nucleus", "gyrus", "sulcus", "fissure",
    "ventricle", "corpus callosum", "fornix", "cingulate", "insula",

    # Medical conditions
    "alzheimer", "parkinson", "epilepsy", "stroke", "tumor", "lesion",
    "atrophy", "hemorrhage", "ischemia", "infarction", "dementia",

    # Clinical terms
    "diagnosis", "prognosis", "pathology", "etiology", "symptom",
    "syndrome", "disorder", "disease", "condition", "treatment",

    # Anatomical directions
    "anterior", "posterior", "superior", "inferior", "medial", "lateral",
    "rostral", "caudal", "dorsal", "ventral", "sagittal", "coronal",
    "axial", "transverse"
}

# Performance critical functions
PERFORMANCE_CRITICAL_FUNCTIONS = {
    "_process", "_physics_process", "_draw", "_input",
    "raycast", "intersect", "collision", "mesh_update"
}

# UI component patterns
UI_COMPONENT_PATTERNS = [
    r"extends\s+(?:Control|Panel|Container|Button|Label)",
    r"class_name.*(?:Panel|Dialog|Component|Widget)",
    r"ui/.*\.gd$"
]


class NeuroVisValidator:
    """Main validator class for NeuroVis-specific code quality checks"""

    def __init__(self):
        self.issues: List[Dict] = []
        self.warnings: List[Dict] = []
        self.info: List[Dict] = []
        self.stats = defaultdict(int)

    def validate_file(self, filepath: Path) -> bool:
        """Validate a single file based on its type"""
        self.current_file = filepath

        if filepath.suffix == ".gd":
            return self.validate_gdscript(filepath)
        elif filepath.suffix == ".json":
            return self.validate_json(filepath)
        elif filepath.suffix == ".tscn":
            return self.validate_scene(filepath)
        elif filepath.suffix in [".tres", ".res"]:
            return self.validate_resource(filepath)

        return True

    def validate_gdscript(self, filepath: Path) -> bool:
        """Validate GDScript file for NeuroVis requirements"""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
                lines = content.splitlines()
        except Exception as e:
            self.add_issue(f"Failed to read file: {e}", filepath, 0)
            return False

        # Check for required headers in educational components
        if self._is_educational_component(filepath, content):
            self._check_educational_headers(filepath, lines)

        # Check autoload usage
        self._check_autoload_usage(filepath, content)

        # Check performance annotations
        self._check_performance_annotations(filepath, content, lines)

        # Check accessibility in UI components
        if self._is_ui_component(filepath, content):
            self._check_accessibility_compliance(filepath, content, lines)

        # Check medical terminology usage
        self._check_medical_terminology(filepath, content, lines)

        # Check signal parameter types
        self._check_signal_types(filepath, lines)

        # Check error handling
        self._check_error_handling(filepath, content, lines)

        return len([i for i in self.issues if i['file'] == str(filepath)]) == 0

    def _is_educational_component(self, filepath: Path, content: str) -> bool:
        """Check if file is an educational component"""
        educational_patterns = [
            r"educational", r"learning", r"tutorial", r"lesson",
            r"knowledge", r"clinical", r"medical", r"anatomy"
        ]

        # Check filepath
        path_str = str(filepath).lower()
        if any(pattern in path_str for pattern in educational_patterns):
            return True

        # Check content
        content_lower = content.lower()
        return any(pattern in content_lower for pattern in educational_patterns)

    def _is_ui_component(self, filepath: Path, content: str) -> bool:
        """Check if file is a UI component"""
        path_str = str(filepath)

        # Check path
        if re.search(r"ui/.*\.gd$", path_str):
            return True

        # Check inheritance
        for pattern in UI_COMPONENT_PATTERNS:
            if re.search(pattern, content):
                return True

        return False

    def _check_educational_headers(self, filepath: Path, lines: List[str]):
        """Check for required educational metadata in headers"""
        required_metadata = {
            "@tutorial": "Tutorial reference",
            "@educational_level": "Target education level",
            "@learning_objectives": "Learning objectives",
            "@clinical_relevance": "Clinical relevance"
        }

        header_found = False
        metadata_found = set()

        # Check first 50 lines for headers
        for i, line in enumerate(lines[:50]):
            if line.strip().startswith("##"):
                header_found = True

            for metadata, desc in required_metadata.items():
                if metadata in line:
                    metadata_found.add(metadata)

        if not header_found:
            self.add_warning(
                "Educational component missing documentation header",
                filepath, 1
            )

        missing = set(required_metadata.keys()) - metadata_found
        if missing and header_found:
            self.add_info(
                f"Consider adding educational metadata: {', '.join(missing)}",
                filepath, 1
            )

    def _check_autoload_usage(self, filepath: Path, content: str):
        """Check proper autoload service usage"""
        for service, description in AUTOLOAD_SERVICES.items():
            pattern = rf"\b{service}\."
            matches = re.finditer(pattern, content)

            for match in matches:
                # Check if there's a comment explaining usage
                line_num = content[:match.start()].count('\n') + 1
                lines = content.splitlines()

                if line_num > 0:
                    line = lines[line_num - 1]
                    # Check for inline comment
                    if "#" not in line or "Autoload:" not in line:
                        # Check previous line for comment
                        if line_num > 1:
                            prev_line = lines[line_num - 2]
                            if not ("Autoload:" in prev_line or service in prev_line):
                                self.add_info(
                                    f"Consider documenting autoload usage: {service} ({description})",
                                    filepath, line_num
                                )

    def _check_performance_annotations(self, filepath: Path, content: str, lines: List[str]):
        """Check for performance annotations in critical functions"""
        for func in PERFORMANCE_CRITICAL_FUNCTIONS:
            pattern = rf"func\s+{func}\s*\("
            matches = re.finditer(pattern, content)

            for match in matches:
                line_num = content[:match.start()].count('\n') + 1

                # Check for performance annotation in surrounding lines
                start = max(0, line_num - 3)
                end = min(len(lines), line_num + 1)

                surrounding = lines[start:end]
                has_annotation = any(
                    "@performance" in line or "# Performance:" in line
                    for line in surrounding
                )

                if not has_annotation:
                    self.add_warning(
                        f"Performance-critical function '{func}' missing performance annotation",
                        filepath, line_num
                    )
                    self.stats['missing_performance_annotations'] += 1

    def _check_accessibility_compliance(self, filepath: Path, content: str, lines: List[str]):
        """Check accessibility compliance for UI components"""
        accessibility_checks = {
            "tooltip": "UI component should have tooltips for accessibility",
            "focus_": "UI component should handle focus for keyboard navigation",
            "theme_": "UI component should respect theme settings",
            "@accessibility": "UI component should have accessibility annotation"
        }

        found_accessibility = []
        for check, message in accessibility_checks.items():
            if check in content:
                found_accessibility.append(check)

        if not found_accessibility:
            self.add_warning(
                "UI component missing accessibility features",
                filepath, 1
            )
            self.stats['missing_accessibility'] += 1
        elif "@accessibility" not in found_accessibility:
            self.add_info(
                "Consider adding @accessibility annotation to document accessibility features",
                filepath, 1
            )

    def _check_medical_terminology(self, filepath: Path, content: str, lines: List[str]):
        """Validate medical terminology usage"""
        content_lower = content.lower()
        found_terms = set()

        for term in MEDICAL_TERMS:
            if term in content_lower:
                found_terms.add(term)

        # Check if medical terms are properly documented
        if found_terms:
            self.stats['files_with_medical_terms'] += 1

            # Look for medical glossary or terminology section
            has_medical_docs = any(
                keyword in content
                for keyword in ["Medical:", "Clinical:", "Anatomy:", "Terminology:"]
            )

            if not has_medical_docs and len(found_terms) > 3:
                self.add_info(
                    f"File contains medical terms ({len(found_terms)}), consider adding terminology documentation",
                    filepath, 1
                )

    def _check_signal_types(self, filepath: Path, lines: List[str]):
        """Check that signals have typed parameters"""
        for i, line in enumerate(lines):
            if line.strip().startswith("signal "):
                match = re.match(r"signal\s+(\w+)\s*\((.*)\)", line.strip())
                if match:
                    signal_name = match.group(1)
                    params = match.group(2).strip()

                    if params:  # Has parameters
                        # Check if parameters have types
                        param_parts = params.split(",")
                        untyped_params = []

                        for param in param_parts:
                            param = param.strip()
                            if param and ":" not in param:
                                untyped_params.append(param)

                        if untyped_params:
                            self.add_warning(
                                f"Signal '{signal_name}' has untyped parameters: {', '.join(untyped_params)}",
                                filepath, i + 1
                            )
                            self.stats['untyped_signals'] += 1

    def _check_error_handling(self, filepath: Path, content: str, lines: List[str]):
        """Check proper error handling patterns"""
        error_patterns = [
            (r"push_error\s*\(", "push_error"),
            (r"push_warning\s*\(", "push_warning"),
            (r"assert\s*\(", "assert")
        ]

        for pattern, name in error_patterns:
            matches = re.finditer(pattern, content)
            for match in matches:
                line_num = content[:match.start()].count('\n') + 1
                line = lines[line_num - 1] if line_num <= len(lines) else ""

                # Check if error has proper context
                if name in ["push_error", "push_warning"]:
                    # Should include context tag like [ComponentName]
                    if not re.search(r"\[\w+\]", line):
                        self.add_info(
                            f"{name} should include context tag like '[ComponentName]'",
                            filepath, line_num
                        )

    def validate_json(self, filepath: Path) -> bool:
        """Validate JSON files, especially anatomical_data.json"""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
        except json.JSONDecodeError as e:
            self.add_issue(f"Invalid JSON: {e}", filepath, e.lineno if hasattr(e, 'lineno') else 0)
            return False
        except Exception as e:
            self.add_issue(f"Failed to read JSON: {e}", filepath, 0)
            return False

        # Special validation for anatomical data
        if filepath.name == "anatomical_data.json":
            return self._validate_anatomical_data(filepath, data)

        return True

    def _validate_anatomical_data(self, filepath: Path, data: Dict) -> bool:
        """Validate anatomical data structure and content"""
        if "structures" not in data:
            self.add_issue("Missing 'structures' key in anatomical data", filepath, 0)
            return False

        required_fields = {
            "id", "displayName", "shortDescription", "functions",
            "clinicalRelevance", "educationalLevel", "learningObjectives"
        }

        for i, structure in enumerate(data.get("structures", [])):
            missing_fields = required_fields - set(structure.keys())
            if missing_fields:
                self.add_issue(
                    f"Structure {i} missing required fields: {', '.join(missing_fields)}",
                    filepath, 0
                )

            # Validate educational level
            if "educationalLevel" in structure:
                valid_levels = {"beginner", "intermediate", "advanced"}
                if structure["educationalLevel"] not in valid_levels:
                    self.add_warning(
                        f"Structure '{structure.get('id', i)}' has invalid educational level",
                        filepath, 0
                    )

        return len([i for i in self.issues if i['file'] == str(filepath)]) == 0

    def validate_scene(self, filepath: Path) -> bool:
        """Validate Godot scene files"""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            self.add_issue(f"Failed to read scene file: {e}", filepath, 0)
            return False

        # Check for broken node references
        node_refs = re.findall(r'path="([^"]+)"', content)
        for ref in node_refs:
            if ref.startswith("res://") and not os.path.exists(ref.replace("res://", "")):
                self.add_warning(f"Potentially broken reference: {ref}", filepath, 0)

        return True

    def validate_resource(self, filepath: Path) -> bool:
        """Validate Godot resource files"""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            self.add_issue(f"Failed to read resource file: {e}", filepath, 0)
            return False

        # Basic validation - check format
        if not content.strip().startswith("[gd_resource") and not content.strip().startswith("[gd_scene"):
            self.add_warning("Resource file may have invalid format", filepath, 0)

        return True

    def add_issue(self, message: str, filepath: Path, line: int):
        """Add an error issue"""
        self.issues.append({
            "type": "error",
            "message": message,
            "file": str(filepath),
            "line": line
        })

    def add_warning(self, message: str, filepath: Path, line: int):
        """Add a warning"""
        self.warnings.append({
            "type": "warning",
            "message": message,
            "file": str(filepath),
            "line": line
        })

    def add_info(self, message: str, filepath: Path, line: int):
        """Add an info message"""
        self.info.append({
            "type": "info",
            "message": message,
            "file": str(filepath),
            "line": line
        })

    def print_report(self):
        """Print validation report"""
        total_issues = len(self.issues) + len(self.warnings)

        if self.issues:
            print("\n=== ERRORS ===")
            for issue in self.issues:
                print(f"{issue['file']}:{issue['line']}: {issue['message']}")

        if self.warnings:
            print("\n=== WARNINGS ===")
            for warning in self.warnings:
                print(f"{warning['file']}:{warning['line']}: {warning['message']}")

        if self.info and os.environ.get("NEUROVIS_LINT_VERBOSE"):
            print("\n=== INFO ===")
            for info in self.info:
                print(f"{info['file']}:{info['line']}: {info['message']}")

        print("\n=== STATISTICS ===")
        print(f"Files with medical terms: {self.stats['files_with_medical_terms']}")
        print(f"Missing performance annotations: {self.stats['missing_performance_annotations']}")
        print(f"Missing accessibility features: {self.stats['missing_accessibility']}")
        print(f"Untyped signal parameters: {self.stats['untyped_signals']}")

        print(f"\nTotal issues: {total_issues}")
        print(f"  Errors: {len(self.issues)}")
        print(f"  Warnings: {len(self.warnings)}")
        print(f"  Info: {len(self.info)}")

        return len(self.issues) == 0


def main():
    """Main entry point"""
    if len(sys.argv) < 2:
        print("Usage: neurovis-validator.py <file_or_directory>")
        sys.exit(1)

    target = Path(sys.argv[1])
    validator = NeuroVisValidator()

    if target.is_file():
        success = validator.validate_file(target)
    elif target.is_dir():
        success = True
        for filepath in target.rglob("*"):
            if filepath.is_file() and filepath.suffix in [".gd", ".json", ".tscn", ".tres", ".res"]:
                if not validator.validate_file(filepath):
                    success = False
    else:
        print(f"Error: {target} is not a valid file or directory")
        sys.exit(1)

    validator.print_report()
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
