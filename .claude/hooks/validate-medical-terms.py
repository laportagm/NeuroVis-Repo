#!/usr/bin/env python3
"""
Validate medical terminology usage in NeuroVis project files
Ensures medical terms are used correctly and consistently
"""

import re
import sys
import json
from pathlib import Path


# Common medical term misspellings and corrections
MEDICAL_CORRECTIONS = {
    "hipocampus": "hippocampus",
    "amigdala": "amygdala", 
    "thalmus": "thalamus",
    "cerebelum": "cerebellum",
    "medula": "medulla",
    "alzheimers": "Alzheimer's",
    "parkinsons": "Parkinson's",
    "latereal": "lateral",
    "medail": "medial",
    "anteroir": "anterior",
    "posteroir": "posterior",
    "nuclues": "nucleus",
    "ventricel": "ventricle",
    "corupus": "corpus",
    "callosum": "callosum",
    "gryus": "gyrus",
    "sulcis": "sulcus"
}

# Medical terms that should be capitalized in certain contexts
PROPER_MEDICAL_TERMS = {
    "alzheimer", "parkinson", "huntington", "wernicke", "broca",
    "brodmann", "willis", "sylvian", "rolandic"
}

# Anatomical terms that need consistent usage
ANATOMICAL_PAIRS = [
    ("grey matter", "gray matter"),  # Prefer American spelling
    ("centre", "center"),  # Prefer American spelling
    ("fibre", "fiber"),  # Prefer American spelling
]


def check_medical_terminology(filepath, content):
    """Check medical terminology usage in a file"""
    errors = []
    warnings = []
    lines = content.splitlines()
    
    # Check for misspellings
    for line_num, line in enumerate(lines, 1):
        line_lower = line.lower()
        
        # Check common misspellings
        for misspelling, correct in MEDICAL_CORRECTIONS.items():
            if misspelling in line_lower:
                col = line_lower.index(misspelling)
                errors.append({
                    'line': line_num,
                    'col': col,
                    'message': f"Misspelled medical term '{misspelling}', should be '{correct}'"
                })
        
        # Check proper nouns that should be capitalized
        for term in PROPER_MEDICAL_TERMS:
            # Look for the term at word boundaries
            pattern = rf'\b{term}\b'
            matches = list(re.finditer(pattern, line, re.IGNORECASE))
            
            for match in matches:
                found_term = match.group()
                # Check if it's in a code comment or string
                if "#" in line[:match.start()] or '"' in line or "'" in line:
                    # Should be capitalized in comments and strings
                    if found_term[0].islower():
                        warnings.append({
                            'line': line_num,
                            'col': match.start(),
                            'message': f"Medical term '{found_term}' should be capitalized as '{found_term.capitalize()}'"
                        })
    
    # Check for inconsistent terminology
    full_content_lower = content.lower()
    for variant1, variant2 in ANATOMICAL_PAIRS:
        count1 = full_content_lower.count(variant1)
        count2 = full_content_lower.count(variant2)
        
        if count1 > 0 and count2 > 0:
            warnings.append({
                'line': 0,
                'col': 0,
                'message': f"Inconsistent terminology: file uses both '{variant1}' ({count1}x) and '{variant2}' ({count2}x). Prefer '{variant2}'"
            })
    
    # Special check for JSON files with anatomical data
    if filepath.endswith('.json'):
        try:
            data = json.loads(content)
            check_json_medical_data(data, errors, warnings)
        except json.JSONDecodeError:
            pass  # JSON syntax errors handled elsewhere
    
    return errors, warnings


def check_json_medical_data(data, errors, warnings):
    """Additional checks for JSON medical data"""
    if isinstance(data, dict) and 'structures' in data:
        for i, structure in enumerate(data.get('structures', [])):
            # Check displayName capitalization
            display_name = structure.get('displayName', '')
            if display_name and not display_name[0].isupper():
                warnings.append({
                    'line': 0,
                    'col': 0,
                    'message': f"Structure displayName '{display_name}' should start with capital letter"
                })
            
            # Check clinical relevance formatting
            clinical = structure.get('clinicalRelevance', '')
            if clinical and not clinical.strip().endswith('.'):
                warnings.append({
                    'line': 0,
                    'col': 0,
                    'message': f"Clinical relevance for '{display_name}' should end with period"
                })


def validate_file(filepath):
    """Validate a single file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return False
    
    errors, warnings = check_medical_terminology(filepath, content)
    
    has_issues = False
    
    if errors:
        has_issues = True
        for error in errors:
            if error['line'] > 0:
                print(f"{filepath}:{error['line']}:{error['col']}: ERROR: {error['message']}")
            else:
                print(f"{filepath}: ERROR: {error['message']}")
    
    if warnings and '--strict' in sys.argv:
        has_issues = True
        for warning in warnings:
            if warning['line'] > 0:
                print(f"{filepath}:{warning['line']}:{warning['col']}: WARNING: {warning['message']}")
            else:
                print(f"{filepath}: WARNING: {warning['message']}")
    
    return not has_issues


def main():
    """Main entry point"""
    # Remove --strict flag from file list
    files = [f for f in sys.argv[1:] if f != '--strict']
    
    if not files:
        print("No files to check")
        return 0
    
    all_valid = True
    
    for filepath in files:
        # Only check relevant file types
        if filepath.endswith(('.gd', '.md', '.json')):
            if not validate_file(filepath):
                all_valid = False
    
    return 0 if all_valid else 1


if __name__ == "__main__":
    sys.exit(main())