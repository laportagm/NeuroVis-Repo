#!/usr/bin/env python3
"""
Check proper usage of NeuroVis autoload services in GDScript files
"""

import re
import sys
from pathlib import Path


# NeuroVis autoload services and their purposes
AUTOLOAD_SERVICES = {
    "KB": {
        "purpose": "Legacy Knowledge Base",
        "status": "deprecated",
        "replacement": "KnowledgeService",
        "methods": ["get_structure_info", "search_structures"]
    },
    "KnowledgeService": {
        "purpose": "Modern Educational Content Service",
        "status": "active",
        "methods": ["get_structure", "search_structures", "get_all_structures"]
    },
    "AIAssistant": {
        "purpose": "AI Educational Support",
        "status": "active", 
        "methods": ["query", "get_context", "is_available"]
    },
    "UIThemeManager": {
        "purpose": "Theme Management",
        "status": "active",
        "methods": ["set_theme_mode", "get_current_theme", "apply_theme"]
    },
    "ModelSwitcherGlobal": {
        "purpose": "3D Model Visibility Control",
        "status": "active",
        "methods": ["switch_model", "get_current_model", "list_models"]
    },
    "StructureAnalysisManager": {
        "purpose": "Structure Analysis",
        "status": "active",
        "methods": ["analyze_structure", "get_analysis_results"]
    },
    "DebugCmd": {
        "purpose": "Debug Commands",
        "status": "active",
        "methods": ["execute", "register_command", "list_commands"]
    }
}


def check_autoload_usage(filepath, content):
    """Check autoload service usage in a GDScript file"""
    issues = []
    lines = content.splitlines()
    
    # Track which autoloads are used
    used_autoloads = set()
    
    for line_num, line in enumerate(lines, 1):
        # Check for autoload usage
        for service, info in AUTOLOAD_SERVICES.items():
            # Pattern to match service usage
            pattern = rf'\b{service}\.'
            if re.search(pattern, line):
                used_autoloads.add(service)
                
                # Check if using deprecated service
                if info['status'] == 'deprecated':
                    replacement = info.get('replacement', 'a modern alternative')
                    issues.append({
                        'line': line_num,
                        'level': 'warning',
                        'message': f"Using deprecated autoload '{service}', consider using '{replacement}' instead"
                    })
                
                # Check if method exists
                method_pattern = rf'{service}\.(\w+)\('
                method_match = re.search(method_pattern, line)
                if method_match:
                    method_name = method_match.group(1)
                    known_methods = info.get('methods', [])
                    
                    # Only warn about unknown methods for well-documented services
                    if known_methods and method_name not in known_methods:
                        # Check if it's a common Godot method that would be valid
                        common_methods = ['connect', 'disconnect', 'call_deferred', 'is_inside_tree']
                        if method_name not in common_methods:
                            issues.append({
                                'line': line_num,
                                'level': 'info',
                                'message': f"Unknown method '{method_name}' called on autoload '{service}'"
                            })
                
                # Check for proper null checking
                if not check_null_safety(lines, line_num, service):
                    issues.append({
                        'line': line_num,
                        'level': 'info', 
                        'message': f"Consider adding null check for autoload '{service}' before use"
                    })
    
    # Check if file documents autoload dependencies
    if used_autoloads and not has_autoload_documentation(content):
        issues.append({
            'line': 1,
            'level': 'info',
            'message': f"File uses autoloads ({', '.join(used_autoloads)}) but lacks documentation. Consider adding '## Dependencies: {', '.join(used_autoloads)}'"
        })
    
    return issues


def check_null_safety(lines, current_line, service):
    """Check if there's null safety checking for the autoload"""
    # Look in previous lines for null checks
    start = max(0, current_line - 10)
    
    for i in range(start, current_line):
        if i < len(lines):
            line = lines[i]
            # Check for various null check patterns
            null_patterns = [
                rf'if\s+{service}\s*:',
                rf'if\s+{service}\s*!=\s*null',
                rf'if\s+is_instance_valid\({service}\)',
                rf'if\s+{service}\.has_method\(',
                rf'assert\({service}\s*!=\s*null'
            ]
            
            for pattern in null_patterns:
                if re.search(pattern, line):
                    return True
    
    return False


def has_autoload_documentation(content):
    """Check if file has autoload dependency documentation"""
    doc_patterns = [
        r'##\s*Dependencies:',
        r'##\s*Autoloads:',
        r'##\s*Required\s+autoloads:',
        r'#\s*Uses\s+autoloads:'
    ]
    
    for pattern in doc_patterns:
        if re.search(pattern, content, re.IGNORECASE):
            return True
    
    return False


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
        
        issues = check_autoload_usage(filepath, content)
        
        if issues:
            # Only fail on warnings, not info
            has_warnings = any(issue['level'] == 'warning' for issue in issues)
            if has_warnings:
                exit_code = 1
            
            for issue in issues:
                level = issue['level'].upper()
                print(f"{filepath}:{issue['line']}: {level}: {issue['message']}")
    
    return exit_code


if __name__ == "__main__":
    sys.exit(main())