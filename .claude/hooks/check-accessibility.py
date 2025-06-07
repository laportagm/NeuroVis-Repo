#!/usr/bin/env python3
"""
Check accessibility compliance for NeuroVis UI components
Ensures WCAG 2.1 AA compliance for educational platform
"""

import re
import sys
from pathlib import Path


# WCAG 2.1 AA Requirements
WCAG_REQUIREMENTS = {
    "min_contrast_ratio": 4.5,
    "min_font_size": 16,
    "min_touch_target": 44,  # pixels
    "max_animation_duration": 5.0,  # seconds
    "focus_visible": True,
    "keyboard_navigation": True
}

# Required accessibility features for UI components
ACCESSIBILITY_FEATURES = {
    "tooltip": "Provides context for screen readers",
    "hint_tooltip": "Alternative tooltip property",
    "focus_mode": "Keyboard navigation support",
    "focus_neighbor": "Directional navigation",
    "focus_next": "Tab order control",
    "focus_previous": "Shift+Tab order control",
    "mouse_filter": "Proper mouse interaction handling"
}

# Accessibility annotations to check
ACCESSIBILITY_ANNOTATIONS = [
    "@accessibility",
    "# Accessibility:",
    "## Accessibility",
    "# WCAG",
    "@wcag"
]


def check_accessibility_compliance(filepath, content):
    """Check UI component for accessibility compliance"""
    issues = []
    lines = content.splitlines()
    
    # Check if it's actually a UI component
    if not is_ui_component(content):
        return issues
    
    # Check for accessibility documentation
    has_accessibility_docs = check_accessibility_documentation(lines)
    if not has_accessibility_docs:
        issues.append({
            'line': 1,
            'level': 'warning',
            'message': "UI component lacks accessibility documentation (@accessibility annotation)"
        })
    
    # Check for required accessibility features
    missing_features = check_accessibility_features(content)
    if missing_features:
        issues.append({
            'line': 1,
            'level': 'info',
            'message': f"Consider adding accessibility features: {', '.join(missing_features)}"
        })
    
    # Check specific accessibility patterns
    issues.extend(check_color_usage(lines))
    issues.extend(check_font_size(lines))
    issues.extend(check_interactive_elements(lines))
    issues.extend(check_focus_handling(lines))
    issues.extend(check_animations(lines))
    
    return issues


def is_ui_component(content):
    """Check if file is a UI component"""
    ui_indicators = [
        r"extends\s+Control\b",
        r"extends\s+Panel\b",
        r"extends\s+Container\b",
        r"extends\s+Button\b",
        r"extends\s+Label\b",
        r"extends\s+.*Dialog\b",
        r"extends\s+.*Panel\b",
        r"class_name.*Panel\b",
        r"class_name.*Dialog\b",
        r"class_name.*Component\b"
    ]
    
    for pattern in ui_indicators:
        if re.search(pattern, content):
            return True
    
    return False


def check_accessibility_documentation(lines):
    """Check for accessibility documentation"""
    # Check first 30 lines for documentation
    for line in lines[:30]:
        for annotation in ACCESSIBILITY_ANNOTATIONS:
            if annotation in line:
                return True
    return False


def check_accessibility_features(content):
    """Check which accessibility features are missing"""
    missing = []
    
    for feature, description in ACCESSIBILITY_FEATURES.items():
        if feature not in content:
            # Some features might be set in the scene file, so only suggest
            missing.append(f"{feature} ({description})")
    
    # Only return top 3 missing features to avoid noise
    return missing[:3]


def check_color_usage(lines):
    """Check color contrast compliance"""
    issues = []
    color_pattern = r'Color\s*\(\s*([0-9.]+)\s*,\s*([0-9.]+)\s*,\s*([0-9.]+)'
    
    for line_num, line in enumerate(lines, 1):
        # Check for hardcoded colors
        if 'Color(' in line or 'Color.' in line:
            # Check if it's using theme colors
            if 'get_theme_color' not in line and 'theme_' not in line.lower():
                issues.append({
                    'line': line_num,
                    'level': 'info',
                    'message': "Consider using theme colors instead of hardcoded values for better accessibility"
                })
            
            # Check for low opacity that might affect contrast
            match = re.search(r'Color\s*\([^)]+,\s*([0-9.]+)\s*\)', line)
            if match:
                alpha = float(match.group(1))
                if alpha < 0.7:
                    issues.append({
                        'line': line_num,
                        'level': 'warning',
                        'message': f"Low opacity ({alpha}) may not meet WCAG contrast requirements"
                    })
    
    return issues


def check_font_size(lines):
    """Check font size compliance"""
    issues = []
    
    for line_num, line in enumerate(lines, 1):
        # Check for font size settings
        size_patterns = [
            r'font_size\s*=\s*(\d+)',
            r'size\s*=\s*(\d+)',
            r'\.size\s*=\s*(\d+)'
        ]
        
        for pattern in size_patterns:
            match = re.search(pattern, line)
            if match:
                size = int(match.group(1))
                if size < WCAG_REQUIREMENTS["min_font_size"]:
                    issues.append({
                        'line': line_num,
                        'level': 'warning',
                        'message': f"Font size {size}px is below WCAG AA minimum of {WCAG_REQUIREMENTS['min_font_size']}px"
                    })
    
    return issues


def check_interactive_elements(lines):
    """Check interactive elements for accessibility"""
    issues = []
    
    for line_num, line in enumerate(lines, 1):
        # Check button creation without accessible text
        if 'Button.new()' in line or 'button =' in line.lower():
            # Look for text assignment in next few lines
            has_text = False
            for i in range(line_num, min(line_num + 5, len(lines))):
                if i < len(lines):
                    check_line = lines[i]
                    if 'text =' in check_line or '.text =' in check_line:
                        has_text = True
                        break
            
            if not has_text:
                issues.append({
                    'line': line_num,
                    'level': 'warning',
                    'message': "Interactive element may lack accessible text/label"
                })
        
        # Check for custom clickable areas
        if '_gui_input' in line or '_input_event' in line:
            # Should have tooltip or accessibility label
            func_end = find_function_end(lines, line_num)
            has_accessibility = False
            
            for i in range(line_num, func_end):
                if i < len(lines):
                    check_line = lines[i]
                    if 'tooltip' in check_line or 'hint_tooltip' in check_line:
                        has_accessibility = True
                        break
            
            if not has_accessibility:
                issues.append({
                    'line': line_num,
                    'level': 'info',
                    'message': "Custom interactive element should have tooltip for accessibility"
                })
    
    return issues


def check_focus_handling(lines):
    """Check keyboard focus handling"""
    issues = []
    has_gui_input = False
    has_focus_handling = False
    
    for line_num, line in enumerate(lines, 1):
        if '_gui_input' in line:
            has_gui_input = True
            
        if any(term in line for term in ['focus', 'KEY_TAB', 'ui_focus', 'grab_focus']):
            has_focus_handling = True
    
    if has_gui_input and not has_focus_handling:
        issues.append({
            'line': 1,
            'level': 'info',
            'message': "UI component with input handling should implement keyboard focus support"
        })
    
    return issues


def check_animations(lines):
    """Check animations for accessibility"""
    issues = []
    
    for line_num, line in enumerate(lines, 1):
        # Check for animations without reduced motion support
        if any(term in line for term in ['tween', 'animate', 'transition']):
            # Look for accessibility checks
            has_motion_check = False
            start = max(0, line_num - 5)
            end = min(len(lines), line_num + 5)
            
            for i in range(start, end):
                if i < len(lines):
                    check_line = lines[i]
                    if 'prefers_reduced_motion' in check_line or 'reduce_motion' in check_line:
                        has_motion_check = True
                        break
            
            if not has_motion_check:
                issues.append({
                    'line': line_num,
                    'level': 'info',
                    'message': "Animation should respect user's reduced motion preference"
                })
    
    return issues


def find_function_end(lines, start_line):
    """Find where a function ends"""
    if start_line >= len(lines):
        return len(lines)
    
    indent_level = len(lines[start_line - 1]) - len(lines[start_line - 1].lstrip())
    
    for i in range(start_line, len(lines)):
        line = lines[i]
        if line.strip() and not line.startswith(('\t', ' ')):
            return i
        if line.strip() and (len(line) - len(line.lstrip())) <= indent_level:
            if not line.lstrip().startswith('#'):
                return i
    
    return len(lines)


def main():
    """Main entry point"""
    exit_code = 0
    
    for filepath in sys.argv[1:]:
        if not filepath.endswith('.gd'):
            continue
        
        # Only check UI files
        if 'ui/' not in filepath:
            continue
        
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            print(f"Error reading {filepath}: {e}")
            exit_code = 1
            continue
        
        issues = check_accessibility_compliance(filepath, content)
        
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