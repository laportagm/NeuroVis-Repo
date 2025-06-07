#!/bin/bash
# NeuroVis Code Formatter
# Automatically formats GDScript files according to project standards

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
BACKUP_DIR="$PROJECT_ROOT/tmp/format-backups"

# Formatting options
FIX_INDENTATION=true
FIX_WHITESPACE=true
FIX_NEWLINES=true
ORGANIZE_IMPORTS=true
DRY_RUN=false
STAGED_ONLY=false
CREATE_BACKUP=true
VERBOSE=false

# Statistics
total_files=0
files_modified=0

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to print section headers
print_section() {
    echo ""
    print_status $BLUE "=== $1 ==="
}

# Function to get GDScript files to format
get_gdscript_files() {
    if [[ "$STAGED_ONLY" == true ]]; then
        # Get staged files only
        git diff --cached --name-only --diff-filter=ACM | grep -E '\.gd$' || true
    else
        # Get all GDScript files in project
        find "$PROJECT_ROOT" -name "*.gd" \
            -not -path "*/.godot/*" \
            -not -path "*/tmp/*" \
            -not -path "*/build/*" \
            -not -path "*/export/*" \
            | sort
    fi
}

# Function to create backup of file
create_backup() {
    local file=$1
    
    if [[ "$CREATE_BACKUP" != true ]]; then
        return 0
    fi
    
    local backup_file="$BACKUP_DIR/$(basename "$file").$(date +%Y%m%d_%H%M%S).bak"
    mkdir -p "$BACKUP_DIR"
    cp "$file" "$backup_file"
    
    if [[ "$VERBOSE" == true ]]; then
        echo "    📄 Backup created: $backup_file"
    fi
}

# Function to fix indentation
fix_indentation() {
    local file=$1
    local modified=false
    
    if [[ "$FIX_INDENTATION" != true ]]; then
        return 0
    fi
    
    # Convert spaces to tabs (4 spaces = 1 tab)
    if grep -q "^    " "$file"; then
        if [[ "$DRY_RUN" != true ]]; then
            # Replace leading 4-space groups with tabs
            sed -i '' 's/^    /\t/g' "$file"
            
            # Handle nested indentation (8 spaces = 2 tabs, etc.)
            sed -i '' 's/^\t    /\t\t/g' "$file"
            sed -i '' 's/^\t\t    /\t\t\t/g' "$file"
            sed -i '' 's/^\t\t\t    /\t\t\t\t/g' "$file"
        fi
        modified=true
        
        if [[ "$VERBOSE" == true ]]; then
            echo "    🔧 Fixed indentation (spaces → tabs)"
        fi
    fi
    
    return $modified
}

# Function to fix whitespace issues
fix_whitespace() {
    local file=$1
    local modified=false
    
    if [[ "$FIX_WHITESPACE" != true ]]; then
        return 0
    fi
    
    # Remove trailing whitespace
    if grep -q " $" "$file"; then
        if [[ "$DRY_RUN" != true ]]; then
            sed -i '' 's/[[:space:]]*$//' "$file"
        fi
        modified=true
        
        if [[ "$VERBOSE" == true ]]; then
            echo "    🔧 Removed trailing whitespace"
        fi
    fi
    
    # Remove tabs in the middle of lines (except leading tabs)
    if grep -q $'\t' "$file" | grep -v "^[[:space:]]*$"; then
        if [[ "$DRY_RUN" != true ]]; then
            # Replace mid-line tabs with appropriate spaces
            sed -i '' 's/\([^[:space:]]\)\t\([^[:space:]]\)/\1 \2/g' "$file"
        fi
        
        if [[ "$VERBOSE" == true ]]; then
            echo "    🔧 Fixed mid-line tabs"
        fi
    fi
    
    return $modified
}

# Function to fix newline issues
fix_newlines() {
    local file=$1
    local modified=false
    
    if [[ "$FIX_NEWLINES" != true ]]; then
        return 0
    fi
    
    # Ensure file ends with newline
    if [[ -s "$file" ]] && [[ "$(tail -c1 "$file" | wc -l)" -eq 0 ]]; then
        if [[ "$DRY_RUN" != true ]]; then
            echo "" >> "$file"
        fi
        modified=true
        
        if [[ "$VERBOSE" == true ]]; then
            echo "    🔧 Added final newline"
        fi
    fi
    
    # Remove excessive blank lines (more than 2 consecutive)
    if grep -Pzo "(?s)\n\n\n\n" "$file" >/dev/null 2>&1; then
        if [[ "$DRY_RUN" != true ]]; then
            # Replace 3+ consecutive newlines with 2
            perl -i -pe 's/\n\n\n+/\n\n/g' "$file"
        fi
        modified=true
        
        if [[ "$VERBOSE" == true ]]; then
            echo "    🔧 Reduced excessive blank lines"
        fi
    fi
    
    # Ensure blank line after class_name declaration
    if grep -q "^class_name " "$file"; then
        if [[ "$DRY_RUN" != true ]]; then
            sed -i '' '/^class_name /a\
' "$file"
        fi
        
        if [[ "$VERBOSE" == true ]]; then
            echo "    🔧 Added blank line after class_name"
        fi
    fi
    
    return $modified
}

# Function to organize imports/preloads
organize_imports() {
    local file=$1
    local modified=false
    
    if [[ "$ORGANIZE_IMPORTS" != true ]]; then
        return 0
    fi
    
    # Check if file has preload statements that could be organized
    if grep -q "^const.*preload\|^var.*preload" "$file"; then
        # For now, just report that organization is available
        # Full implementation would require more complex parsing
        
        if [[ "$VERBOSE" == true ]]; then
            echo "    📝 Preload statements found (manual organization recommended)"
        fi
    fi
    
    return $modified
}

# Function to apply GDScript-specific formatting
apply_gdscript_formatting() {
    local file=$1
    local modified=false
    
    # Ensure proper spacing around operators
    if grep -q "=[^=]" "$file" && ! grep -q " = " "$file"; then
        if [[ "$DRY_RUN" != true ]]; then
            # Add spaces around = operator (but not ==, !=, etc.)
            sed -i '' 's/\([^!<>=]\)=\([^=]\)/\1 = \2/g' "$file"
        fi
        modified=true
        
        if [[ "$VERBOSE" == true ]]; then
            echo "    🔧 Added spaces around assignment operators"
        fi
    fi
    
    # Ensure proper spacing in function parameters
    if grep -q "func.*(" "$file"; then
        if [[ "$DRY_RUN" != true ]]; then
            # Add space after commas in parameter lists
            sed -i '' 's/,\([^[:space:]]\)/, \1/g' "$file"
        fi
        
        if [[ "$VERBOSE" == true ]]; then
            echo "    🔧 Fixed parameter spacing"
        fi
    fi
    
    # Ensure proper spacing in array/dictionary literals
    if grep -q "\[.*\]" "$file" || grep -q "{.*}" "$file"; then
        if [[ "$DRY_RUN" != true ]]; then
            # Add space after commas in arrays/dictionaries
            sed -i '' 's/,\([^[:space:]]\)/, \1/g' "$file"
        fi
        
        if [[ "$VERBOSE" == true ]]; then
            echo "    🔧 Fixed collection spacing"
        fi
    fi
    
    return $modified
}

# Function to format a single file
format_file() {
    local file=$1
    local file_modified=false
    
    echo ""
    print_status $BLUE "📄 $(basename "$file")"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_status $YELLOW "    (DRY RUN - no changes will be made)"
    fi
    
    # Create backup before making changes
    if [[ "$DRY_RUN" != true ]]; then
        create_backup "$file"
    fi
    
    # Apply formatting fixes
    local indentation_modified=false
    local whitespace_modified=false
    local newlines_modified=false
    local imports_modified=false
    local gdscript_modified=false
    
    if fix_indentation "$file"; then
        indentation_modified=true
        file_modified=true
    fi
    
    if fix_whitespace "$file"; then
        whitespace_modified=true
        file_modified=true
    fi
    
    if fix_newlines "$file"; then
        newlines_modified=true
        file_modified=true
    fi
    
    if organize_imports "$file"; then
        imports_modified=true
        file_modified=true
    fi
    
    if apply_gdscript_formatting "$file"; then
        gdscript_modified=true
        file_modified=true
    fi
    
    # Report results
    if [[ "$file_modified" == true ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            print_status $YELLOW "  📝 Would be modified"
        else
            print_status $GREEN "  ✅ Formatted successfully"
            files_modified=$((files_modified + 1))
        fi
    else
        print_status $GREEN "  ✅ Already properly formatted"
    fi
    
    return 0
}

# Function to validate formatted files
validate_formatting() {
    local file=$1
    
    # Basic validation that the file is still valid GDScript
    # This is a simple check - more sophisticated validation could be added
    
    if [[ ! -f "$file" ]]; then
        print_status $RED "    ❌ File missing after formatting: $file"
        return 1
    fi
    
    # Check that the file is not empty (unless it was empty before)
    if [[ ! -s "$file" ]]; then
        print_status $YELLOW "    ⚠️  File is empty after formatting: $file"
    fi
    
    return 0
}

# Function to print usage
print_usage() {
    echo "NeuroVis Code Formatter"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --indentation      Fix indentation only"
    echo "  --whitespace       Fix whitespace only"
    echo "  --newlines         Fix newlines only"
    echo "  --imports          Organize imports only"
    echo "  --dry-run          Show what would be changed without making changes"
    echo "  --staged           Format staged files only"
    echo "  --no-backup        Don't create backup files"
    echo "  -v, --verbose      Verbose output"
    echo "  -h, --help         Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                 Format all files"
    echo "  $0 --dry-run       Show what would be changed"
    echo "  $0 --staged        Format staged files only"
    echo "  $0 --whitespace    Fix whitespace issues only"
}

# Function to clean up old backups
cleanup_backups() {
    if [[ -d "$BACKUP_DIR" ]]; then
        # Remove backups older than 7 days
        find "$BACKUP_DIR" -name "*.bak" -mtime +7 -delete 2>/dev/null || true
        
        # Remove empty backup directory
        rmdir "$BACKUP_DIR" 2>/dev/null || true
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --indentation)
            FIX_WHITESPACE=false
            FIX_NEWLINES=false
            ORGANIZE_IMPORTS=false
            shift
            ;;
        --whitespace)
            FIX_INDENTATION=false
            FIX_NEWLINES=false
            ORGANIZE_IMPORTS=false
            shift
            ;;
        --newlines)
            FIX_INDENTATION=false
            FIX_WHITESPACE=false
            ORGANIZE_IMPORTS=false
            shift
            ;;
        --imports)
            FIX_INDENTATION=false
            FIX_WHITESPACE=false
            FIX_NEWLINES=false
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --staged)
            STAGED_ONLY=true
            shift
            ;;
        --no-backup)
            CREATE_BACKUP=false
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            print_status $RED "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

# Main execution
main() {
    print_status $BLUE "🎨 NeuroVis Code Formatter"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_status $YELLOW "Mode: Dry run (no changes will be made)"
    elif [[ "$STAGED_ONLY" == true ]]; then
        print_status $BLUE "Mode: Staged files only"
    else
        print_status $BLUE "Mode: All project files"
    fi
    
    echo ""
    
    # Get files to format
    local files
    files=$(get_gdscript_files)
    
    if [[ -z "$files" ]]; then
        print_status $YELLOW "⚠️  No GDScript files found to format"
        exit 0
    fi
    
    total_files=$(echo "$files" | wc -l)
    print_status $BLUE "Found $total_files GDScript file(s) to format"
    
    # Format each file
    for file in $files; do
        format_file "$file"
        
        # Validate if not dry run
        if [[ "$DRY_RUN" != true ]]; then
            validate_formatting "$file"
        fi
    done
    
    # Clean up old backups
    if [[ "$CREATE_BACKUP" == true ]] && [[ "$DRY_RUN" != true ]]; then
        cleanup_backups
    fi
    
    # Print summary
    print_section "Formatting Summary"
    print_status $BLUE "Files processed: $total_files"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_status $YELLOW "This was a dry run - no files were modified"
        print_status $BLUE "Run without --dry-run to apply changes"
    else
        if [[ $files_modified -eq 0 ]]; then
            print_status $GREEN "Files modified: $files_modified"
            print_status $GREEN "🎉 All files were already properly formatted!"
        else
            print_status $GREEN "Files modified: $files_modified"
            print_status $GREEN "✅ Formatting complete!"
            
            if [[ "$CREATE_BACKUP" == true ]]; then
                print_status $BLUE "💾 Backups created in: $BACKUP_DIR"
            fi
        fi
    fi
}

# Run main function
main "$@"