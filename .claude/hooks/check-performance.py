#!/usr/bin/env python3
"""
Check performance annotations and optimizations in GDScript files
Ensures 60fps target for NeuroVis educational platform
"""

import re
import sys
from pathlib import Path


# Performance-critical functions that need annotations
PERFORMANCE_CRITICAL = {
    "_process": {
        "max_ms": 16.67,  # 60fps target
        "requires": ["delta usage", "performance annotation"]
    },
    "_physics_process": {
        "max_ms": 16.67,
        "requires": ["delta usage", "performance annotation"]
    },
    "_draw": {
        "max_ms": 8.0,  # Half frame budget for drawing
        "requires": ["draw call optimization", "performance annotation"]
    },
    "_input": {
        "max_ms": 2.0,  # Quick input processing
        "requires": ["early return pattern", "performance annotation"]
    },
    "_unhandled_input": {
        "max_ms": 2.0,
        "requires": ["early return pattern", "performance annotation"]
    }
}

# Functions that commonly cause performance issues
PERFORMANCE_WARNINGS = {
    "get_children": "Consider caching children if called frequently",
    "get_tree().get_nodes_in_group": "Consider caching group members",
    "find_node": "Avoid in performance-critical code, use direct references",
    "duplicate": "Expensive operation, avoid in loops",
    "instance": "Consider object pooling for frequent instantiation",
    "queue_free": "Consider object pooling instead of frequent creation/destruction",
    "add_child": "Batch node additions when possible",
    "remove_child": "Batch node removals when possible"
}


def check_performance_annotations(filepath, content):
    """Check for performance annotations and patterns"""
    issues = []
    lines = content.splitlines()
    
    # Check each performance-critical function
    for func_name, requirements in PERFORMANCE_CRITICAL.items():
        func_pattern = rf'^\s*func\s+{func_name}\s*\('
        
        for line_num, line in enumerate(lines, 1):
            if re.match(func_pattern, line):
                # Found critical function, check requirements
                func_issues = check_function_requirements(
                    lines, line_num, func_name, requirements
                )
                issues.extend(func_issues)
    
    # Check for performance anti-patterns
    issues.extend(check_performance_antipatterns(lines))
    
    # Check for 3D rendering optimizations if it's a 3D-related file
    if is_3d_related(filepath, content):
        issues.extend(check_3d_optimizations(lines))
    
    return issues


def check_function_requirements(lines, func_line, func_name, requirements):
    """Check if a performance-critical function meets requirements"""
    issues = []
    
    # Check for performance annotation
    has_annotation = False
    annotation_line = max(0, func_line - 4)
    
    for i in range(annotation_line, func_line):
        if i < len(lines):
            line = lines[i]
            if any(marker in line for marker in ["@performance", "# Performance:", "## Performance"]):
                has_annotation = True
                break
    
    if not has_annotation and "performance annotation" in requirements["requires"]:
        issues.append({
            'line': func_line,
            'level': 'warning',
            'message': f"Performance-critical function '{func_name}' lacks performance annotation"
        })
    
    # Check for delta usage in process functions
    if "delta usage" in requirements["requires"] and func_name in ["_process", "_physics_process"]:
        if not check_delta_usage(lines, func_line, func_name):
            issues.append({
                'line': func_line,
                'level': 'info',
                'message': f"Function '{func_name}' should use delta parameter for frame-independent movement"
            })
    
    # Check for early returns in input functions
    if "early return pattern" in requirements["requires"]:
        if not check_early_returns(lines, func_line):
            issues.append({
                'line': func_line,
                'level': 'info',
                'message': f"Input function '{func_name}' should use early returns to minimize processing"
            })
    
    return issues


def check_delta_usage(lines, func_line, func_name):
    """Check if process function properly uses delta"""
    # Look for delta parameter and usage
    func_end = find_function_end(lines, func_line)
    
    has_delta_param = "delta" in lines[func_line - 1]
    uses_delta = False
    
    for i in range(func_line, func_end):
        if i < len(lines) and "delta" in lines[i]:
            uses_delta = True
            break
    
    return has_delta_param and uses_delta


def check_early_returns(lines, func_line):
    """Check if function uses early return pattern"""
    func_end = find_function_end(lines, func_line)
    
    # Look for return statements before the end
    for i in range(func_line, func_end - 1):
        if i < len(lines) and "return" in lines[i]:
            return True
    
    return False


def find_function_end(lines, start_line):
    """Find where a function ends"""
    indent_level = len(lines[start_line - 1]) - len(lines[start_line - 1].lstrip())
    
    for i in range(start_line, len(lines)):
        line = lines[i]
        if line.strip() and not line.startswith(('\t', ' ')):
            return i
        if line.strip() and (len(line) - len(line.lstrip())) <= indent_level:
            if not line.lstrip().startswith('#'):
                return i
    
    return len(lines)


def check_performance_antipatterns(lines):
    """Check for common performance anti-patterns"""
    issues = []
    
    for line_num, line in enumerate(lines, 1):
        # Skip comments
        if line.strip().startswith('#'):
            continue
        
        # Check for performance-impacting function calls
        for func, warning in PERFORMANCE_WARNINGS.items():
            if func in line:
                # Check if it's in a loop
                if is_in_loop(lines, line_num):
                    issues.append({
                        'line': line_num,
                        'level': 'warning',
                        'message': f"'{func}' called in loop. {warning}"
                    })
                else:
                    # Only info level if not in loop
                    issues.append({
                        'line': line_num,
                        'level': 'info',
                        'message': f"Performance consideration: {warning}"
                    })
        
        # Check for string concatenation in loops
        if '+' in line and ('"' in line or "'" in line) and is_in_loop(lines, line_num):
            issues.append({
                'line': line_num,
                'level': 'warning',
                'message': "String concatenation in loop. Consider using String.format() or PoolStringArray"
            })
    
    return issues


def is_in_loop(lines, line_num):
    """Check if a line is inside a loop"""
    # Look backwards for loop indicators
    current_indent = len(lines[line_num - 1]) - len(lines[line_num - 1].lstrip())
    
    for i in range(line_num - 2, max(0, line_num - 20), -1):
        line = lines[i]
        line_indent = len(line) - len(line.lstrip())
        
        if line_indent < current_indent:
            # Check if this line starts a loop
            if any(keyword in line for keyword in ['for ', 'while ', 'for(']):
                return True
    
    return False


def is_3d_related(filepath, content):
    """Check if file is related to 3D rendering"""
    indicators = [
        'extends MeshInstance', 'extends Spatial', 'extends Node3D',
        'extends Camera3D', 'extends DirectionalLight', 'mesh', 'material',
        'draw_', 'render', 'viewport'
    ]
    
    filepath_str = str(filepath).lower()
    if any(term in filepath_str for term in ['render', '3d', 'mesh', 'visual', 'camera']):
        return True
    
    return any(indicator in content for indicator in indicators)


def check_3d_optimizations(lines):
    """Check for 3D-specific optimizations"""
    issues = []
    
    for line_num, line in enumerate(lines, 1):
        # Check for LOD usage
        if 'mesh' in line.lower() and 'lod' not in line.lower():
            # Only suggest LOD for certain contexts
            if any(term in line for term in ['load', 'instance', 'create']):
                issues.append({
                    'line': line_num,
                    'level': 'info',
                    'message': "Consider using LOD (Level of Detail) for better performance"
                })
        
        # Check for draw call batching
        if 'draw_' in line and is_in_loop(lines, line_num):
            issues.append({
                'line': line_num,
                'level': 'warning',
                'message': "Multiple draw calls in loop. Consider batching for better performance"
            })
        
        # Check material usage
        if '.material = ' in line and is_in_loop(lines, line_num):
            issues.append({
                'line': line_num,
                'level': 'warning',
                'message': "Setting materials in loop. Consider using material overrides or shared materials"
            })
    
    return issues


def main():
    """Main entry point"""
    exit_code = 0
    
    for filepath in sys.argv[1:]:
        if not filepath.endswith('.gd'):
            continue
        
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            print(f"Error reading {filepath}: {e}")
            exit_code = 1
            continue
        
        issues = check_performance_annotations(filepath, content)
        
        if issues:
            # Only fail on warnings
            has_warnings = any(issue['level'] == 'warning' for issue in issues)
            if has_warnings:
                exit_code = 1
            
            for issue in issues:
                level = issue['level'].upper()
                print(f"{filepath}:{issue['line']}: {level}: {issue['message']}")
    
    return exit_code


if __name__ == "__main__":
    sys.exit(main())