#!/usr/bin/env python3
"""
Script to verify GDScript linting status after fixes.
Runs gdlint on the project and reports remaining issues.
"""

import subprocess
import sys
from pathlib import Path

def run_gdlint(project_root):
    """Run gdlint on the project and return results."""
    try:
        result = subprocess.run([
            'python', '-m', 'gdtoolkit.linter', '.'
        ], cwd=project_root, capture_output=True, text=True)
        
        return result.returncode, result.stdout, result.stderr
    except Exception as e:
        return -1, "", str(e)

def analyze_gdlint_output(stderr):
    """Analyze gdlint output and categorize errors."""
    lines = stderr.split('\n')
    errors = {
        'class-definitions-order': 0,
        'undeclared-variable': 0,
        'max-line-length': 0,
        'other': 0
    }
    
    error_files = set()
    
    for line in lines:
        if 'Error:' in line:
            error_files.add(line.split(':')[0])
            
            if 'class-definitions-order' in line:
                errors['class-definitions-order'] += 1
            elif 'not declared' in line:
                errors['undeclared-variable'] += 1
            elif 'max-line-length' in line:
                errors['max-line-length'] += 1
            else:
                errors['other'] += 1
    
    return errors, len(error_files)

def main():
    """Main function to verify linting status."""
    if len(sys.argv) > 1:
        project_root = sys.argv[1]
    else:
        project_root = "/Users/gagelaporta/Desktop/Neuro/NeuroVis-Repo"
    
    print("🔍 Running GDScript linting verification...")
    print(f"📁 Project: {project_root}")
    print("-" * 60)
    
    # Run gdlint
    returncode, stdout, stderr = run_gdlint(project_root)
    
    if returncode == -1:
        print(f"❌ Error running gdlint: {stderr}")
        return
    
    if returncode == 0:
        print("🎉 SUCCESS: No linting errors found!")
        print("✅ All GDScript files are properly formatted and error-free.")
        return
    
    # Analyze errors
    errors, file_count = analyze_gdlint_output(stderr)
    
    print(f"📊 LINTING SUMMARY:")
    print(f"   Files with errors: {file_count}")
    print(f"   Total errors: {sum(errors.values())}")
    print()
    
    print("📋 ERROR BREAKDOWN:")
    for error_type, count in errors.items():
        if count > 0:
            icon = "🔧" if error_type == "class-definitions-order" else "⚠️"
            print(f"   {icon} {error_type}: {count}")
    
    print()
    print("🛠️  RECOMMENDATIONS:")
    
    if errors['class-definitions-order'] > 0:
        print("   • Run the fix_class_order.py script to fix class definition order issues")
    
    if errors['undeclared-variable'] > 0:
        print("   • Manually review and fix undeclared variable errors")
        print("   • Add missing variable declarations with proper types")
    
    if errors['max-line-length'] > 0:
        print("   • Break long lines into multiple lines (max 100 characters)")
    
    if errors['other'] > 0:
        print("   • Review other errors manually")
    
    print()
    print(f"📄 Detailed output:")
    print(stderr[:1000] + "..." if len(stderr) > 1000 else stderr)

if __name__ == "__main__":
    main()