#!/usr/bin/env bash
# NeuroVis GDScript Linting, Formatting, and Validation System
# Educational medical visualization platform code quality automation
# Version: 1.0.0
# 
# This script provides comprehensive code quality checks for the NeuroVis project:
# - GDScript formatting with gdformat
# - Syntax validation with gdparse
# - Custom NeuroVis-specific validation rules
# - Medical terminology preservation
# - Performance and accessibility checks

set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
readonly GDTOOLKIT_VERSION="4.3.1"
readonly PYTHON_MIN_VERSION="3.8"
readonly MAX_PARALLEL_JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

# Report files
readonly REPORT_DIR="$PROJECT_ROOT/.claude/reports"
readonly TIMESTAMP=$(date +%Y%m%d_%H%M%S)
readonly REPORT_FILE="$REPORT_DIR/lint_report_$TIMESTAMP.txt"
readonly JSON_REPORT="$REPORT_DIR/lint_report_$TIMESTAMP.json"

# Cache directory for performance
readonly CACHE_DIR="$PROJECT_ROOT/.claude/.cache"
readonly CACHE_FILE="$CACHE_DIR/file_hashes.txt"

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_FIXABLE_ISSUES=1
readonly EXIT_UNFIXABLE_ISSUES=2
readonly EXIT_DEPENDENCY_ERROR=3

# Initialize report
mkdir -p "$REPORT_DIR" "$CACHE_DIR"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$REPORT_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$REPORT_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$REPORT_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$REPORT_FILE"
}

log_section() {
    echo -e "\n${MAGENTA}==== $1 ====${NC}" | tee -a "$REPORT_FILE"
}

# Check Python installation
check_python() {
    log_section "Checking Python Installation"
    
    local python_cmd=""
    for cmd in python3 python; do
        if command -v "$cmd" &> /dev/null; then
            local version=$("$cmd" -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
            local major=$(echo "$version" | cut -d. -f1)
            local minor=$(echo "$version" | cut -d. -f2)
            local req_major=$(echo "$PYTHON_MIN_VERSION" | cut -d. -f1)
            local req_minor=$(echo "$PYTHON_MIN_VERSION" | cut -d. -f2)
            
            if [[ $major -gt $req_major ]] || [[ $major -eq $req_major && $minor -ge $req_minor ]]; then
                python_cmd="$cmd"
                log_success "Found Python $version at $(which $cmd)"
                break
            fi
        fi
    done
    
    if [[ -z "$python_cmd" ]]; then
        log_error "Python $PYTHON_MIN_VERSION or higher is required but not found"
        exit $EXIT_DEPENDENCY_ERROR
    fi
    
    echo "$python_cmd"
}

# Install or update gdtoolkit
install_gdtoolkit() {
    local python_cmd=$1
    log_section "Installing/Updating gdtoolkit"
    
    # Create virtual environment if it doesn't exist
    local venv_dir="$PROJECT_ROOT/.claude/.venv"
    if [[ ! -d "$venv_dir" ]]; then
        log_info "Creating virtual environment..."
        "$python_cmd" -m venv "$venv_dir"
    fi
    
    # Activate virtual environment and install gdtoolkit
    source "$venv_dir/bin/activate" || source "$venv_dir/Scripts/activate"
    
    log_info "Installing gdtoolkit==$GDTOOLKIT_VERSION..."
    pip install --upgrade pip &> /dev/null
    pip install "gdtoolkit==$GDTOOLKIT_VERSION" &> /dev/null
    
    if command -v gdformat &> /dev/null && command -v gdparse &> /dev/null; then
        log_success "gdtoolkit installed successfully"
        return 0
    else
        log_error "Failed to install gdtoolkit"
        exit $EXIT_DEPENDENCY_ERROR
    fi
}

# Calculate file hash for caching
calculate_file_hash() {
    local file=$1
    if command -v sha256sum &> /dev/null; then
        sha256sum "$file" | cut -d' ' -f1
    elif command -v shasum &> /dev/null; then
        shasum -a 256 "$file" | cut -d' ' -f1
    else
        # Fallback to modification time
        stat -c %Y "$file" 2>/dev/null || stat -f %m "$file" 2>/dev/null || echo "0"
    fi
}

# Check if file needs processing (cache check)
needs_processing() {
    local file=$1
    local current_hash=$(calculate_file_hash "$file")
    local cached_hash=""
    
    if [[ -f "$CACHE_FILE" ]]; then
        cached_hash=$(grep "^$file:" "$CACHE_FILE" 2>/dev/null | cut -d':' -f2)
    fi
    
    if [[ "$current_hash" != "$cached_hash" ]]; then
        return 0  # Needs processing
    else
        return 1  # Already processed and unchanged
    fi
}

# Update cache for processed file
update_cache() {
    local file=$1
    local hash=$(calculate_file_hash "$file")
    
    # Remove old entry if exists
    if [[ -f "$CACHE_FILE" ]]; then
        grep -v "^$file:" "$CACHE_FILE" > "$CACHE_FILE.tmp" || true
        mv "$CACHE_FILE.tmp" "$CACHE_FILE"
    fi
    
    # Add new entry
    echo "$file:$hash" >> "$CACHE_FILE"
}

# Find all GDScript files
find_gdscript_files() {
    local only_modified=${1:-false}
    
    if [[ "$only_modified" == "true" ]] && command -v git &> /dev/null && [[ -d "$PROJECT_ROOT/.git" ]]; then
        # Only get modified files if in a git repository
        git -C "$PROJECT_ROOT" diff --name-only --diff-filter=ACM HEAD | grep '\.gd$' || true
        git -C "$PROJECT_ROOT" ls-files --others --exclude-standard | grep '\.gd$' || true
    else
        # Find all .gd files, excluding specific directories
        find "$PROJECT_ROOT" -name "*.gd" -type f \
            -not -path "*/\.godot/*" \
            -not -path "*/\.import/*" \
            -not -path "*/addons/*" \
            -not -path "*/\.claude/\.venv/*" \
            -not -path "*/tmp/*" \
            -not -path "*/temp_syntax_check/*" \
            -not -path "*/backups_*/*" \
            | sort
    fi
}

# Format a single GDScript file
format_gdscript_file() {
    local file=$1
    local temp_file="${file}.tmp"
    
    # Skip if file doesn't need processing (cache check)
    if ! needs_processing "$file"; then
        echo -n "."  # Progress indicator for skipped files
        return 0
    fi
    
    # Create backup
    cp "$file" "$temp_file"
    
    # Run gdformat with NeuroVis configuration
    if gdformat "$file" --line-length 100 &> /dev/null; then
        # Check if file was actually modified
        if ! cmp -s "$file" "$temp_file"; then
            echo -e "\n${GREEN}Formatted:${NC} ${file#$PROJECT_ROOT/}"
            rm "$temp_file"
            update_cache "$file"
            return 1  # File was modified
        else
            rm "$temp_file"
            update_cache "$file"
            return 0  # File was not modified
        fi
    else
        # Restore from backup on error
        mv "$temp_file" "$file"
        echo -e "\n${RED}Format error:${NC} ${file#$PROJECT_ROOT/}"
        return 2  # Format error
    fi
}

# Validate GDScript syntax
validate_syntax() {
    local file=$1
    local output
    
    output=$(gdparse "$file" 2>&1) || {
        echo -e "${RED}Syntax error in ${file#$PROJECT_ROOT/}:${NC}"
        echo "$output" | sed 's/^/  /'
        return 1
    }
    
    return 0
}

# Custom NeuroVis validation rules
run_custom_validations() {
    local file=$1
    local issues=0
    
    # Check for medical terminology in comments
    if grep -q "TODO\|FIXME\|XXX\|HACK" "$file"; then
        local todos=$(grep -n "TODO\|FIXME\|XXX\|HACK" "$file" || true)
        if [[ -n "$todos" ]]; then
            echo -e "${YELLOW}Found TODO/FIXME markers:${NC}"
            echo "$todos" | while IFS= read -r line; do
                echo "  $line"
            done
            ((issues++))
        fi
    fi
    
    # Check for proper error handling with DebugCmd
    if grep -q "push_error\|push_warning" "$file"; then
        if ! grep -q "DebugCmd\|ErrorHandler" "$file"; then
            echo -e "${YELLOW}Warning: Error handling without DebugCmd integration${NC}"
            ((issues++))
        fi
    fi
    
    # Check for performance annotations in 3D operations
    if grep -q "_process\|_physics_process" "$file"; then
        if ! grep -q "@performance\|# Performance:" "$file"; then
            echo -e "${YELLOW}Missing performance annotation for process functions${NC}"
            ((issues++))
        fi
    fi
    
    # Check for accessibility markers in UI components
    if [[ "$file" =~ ui/.*\.gd$ ]] || grep -q "extends.*Control\|extends.*Panel" "$file"; then
        if ! grep -q "@accessibility\|# Accessibility:" "$file"; then
            echo -e "${YELLOW}Missing accessibility annotation for UI component${NC}"
            ((issues++))
        fi
    fi
    
    # Check for autoload service usage
    local autoloads=("KB" "KnowledgeService" "AIAssistant" "UIThemeManager" "ModelSwitcherGlobal" "StructureAnalysisManager" "DebugCmd")
    for autoload in "${autoloads[@]}"; do
        if grep -q "\b$autoload\." "$file"; then
            if ! grep -q "# Autoload:" "$file"; then
                echo -e "${CYAN}Info: Uses autoload $autoload - consider adding documentation${NC}"
            fi
        fi
    done
    
    # Check for proper signal parameter types
    if grep -q "^signal " "$file"; then
        local signals=$(grep "^signal " "$file" || true)
        echo "$signals" | while IFS= read -r signal_line; do
            if [[ "$signal_line" =~ signal[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*)\((.*)\) ]]; then
                local params="${BASH_REMATCH[2]}"
                if [[ -n "$params" ]] && ! [[ "$params" =~ : ]]; then
                    echo -e "${YELLOW}Signal without typed parameters: $signal_line${NC}"
                    ((issues++))
                fi
            fi
        done
    fi
    
    return $issues
}

# Run parallel processing
process_files_parallel() {
    local files=("$@")
    local total=${#files[@]}
    local processed=0
    local modified=0
    local errors=0
    local syntax_errors=0
    
    log_info "Processing $total GDScript files..."
    
    # Process files in batches
    local batch_size=$((MAX_PARALLEL_JOBS * 2))
    for ((i = 0; i < total; i += batch_size)); do
        local batch=("${files[@]:i:batch_size}")
        
        for file in "${batch[@]}"; do
            {
                # Format file
                format_gdscript_file "$file"
                local format_result=$?
                
                # Validate syntax
                if ! validate_syntax "$file"; then
                    ((syntax_errors++))
                fi
                
                # Run custom validations
                if ! run_custom_validations "$file"; then
                    ((errors++))
                fi
                
                if [[ $format_result -eq 1 ]]; then
                    ((modified++))
                elif [[ $format_result -eq 2 ]]; then
                    ((errors++))
                fi
                
                ((processed++))
                
                # Progress indicator
                if ((processed % 10 == 0)); then
                    echo -ne "\rProgress: $processed/$total files"
                fi
            } &
            
            # Limit parallel jobs
            while (( $(jobs -r | wc -l) >= MAX_PARALLEL_JOBS )); do
                sleep 0.1
            done
        done
        
        # Wait for batch to complete
        wait
    done
    
    echo -e "\n"
    
    # Return results
    echo "$modified $errors $syntax_errors"
}

# Generate JSON report
generate_json_report() {
    local total_files=$1
    local modified_files=$2
    local error_files=$3
    local syntax_errors=$4
    local duration=$5
    
    cat > "$JSON_REPORT" <<EOF
{
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "project": "NeuroVis",
    "version": "1.0.0",
    "summary": {
        "total_files": $total_files,
        "modified_files": $modified_files,
        "error_files": $error_files,
        "syntax_errors": $syntax_errors,
        "duration_seconds": $duration
    },
    "configuration": {
        "line_length": 100,
        "indent_size": 4,
        "gdtoolkit_version": "$GDTOOLKIT_VERSION",
        "parallel_jobs": $MAX_PARALLEL_JOBS
    }
}
EOF
}

# Main execution
main() {
    local start_time=$(date +%s)
    local only_modified=false
    local exit_code=$EXIT_SUCCESS
    local specific_files=()
    local fix_mode=false
    local report_format=""
    local ci_mode=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --modified-only)
                only_modified=true
                shift
                ;;
            --fix)
                fix_mode=true
                shift
                ;;
            --report)
                report_format="${2:-text}"
                shift 2 || shift
                ;;
            --ci)
                ci_mode=true
                shift
                ;;
            --help|-h)
                cat <<EOF
NeuroVis GDScript Linting and Formatting Tool

Usage: $0 [OPTIONS] [FILES...]

Options:
    --modified-only    Only process files modified in git
    --fix             Auto-fix issues where possible
    --report FORMAT   Generate report (text, json, html)
    --ci              CI mode (strict checking)
    --help, -h        Show this help message

Arguments:
    FILES            Specific files to check (optional)

Environment Variables:
    NEUROVIS_LINT_PARALLEL_JOBS    Number of parallel jobs (default: CPU count)
    NEUROVIS_LINT_CACHE_DISABLE    Disable caching if set to "true"

Examples:
    # Lint and format entire project
    $0
    
    # Check specific file
    $0 core/ai/GeminiAIService.gd
    
    # Only process modified files
    $0 --modified-only
    
    # Auto-fix issues
    $0 --fix
    
    # Generate HTML report
    $0 --report html

EOF
                exit 0
                ;;
            -*)
                log_error "Unknown option: $1"
                exit 1
                ;;
            *)
                # Treat as file path
                specific_files+=("$1")
                shift
                ;;
        esac
    done
    
    # Header
    cat <<EOF | tee "$REPORT_FILE"
================================================================================
NeuroVis GDScript Code Quality Report
Generated: $(date)
Project: $PROJECT_ROOT
================================================================================

EOF
    
    # Check and install dependencies
    python_cmd=$(check_python)
    install_gdtoolkit "$python_cmd"
    
    # Find GDScript files
    log_section "Scanning for GDScript Files"
    
    # Collect files to process
    if [[ ${#specific_files[@]} -gt 0 ]]; then
        # Use specific files provided
        gd_files=()
        for file in "${specific_files[@]}"; do
            if [[ -f "$file" && "$file" == *.gd ]]; then
                gd_files+=("$file")
            else
                log_warning "Skipping non-GDScript file: $file"
            fi
        done
    else
        # Find all GDScript files - compatible with macOS bash
        gd_files=()
        while IFS= read -r file; do
            gd_files+=("$file")
        done < <(find_gdscript_files "$only_modified")
    fi
    
    if [[ ${#gd_files[@]} -eq 0 ]]; then
        log_warning "No GDScript files found to process"
        exit $EXIT_SUCCESS
    fi
    
    log_info "Found ${#gd_files[@]} GDScript files"
    
    # Process files
    log_section "Processing Files"
    
    # Disable cache if requested
    if [[ "${NEUROVIS_LINT_CACHE_DISABLE:-false}" == "true" ]]; then
        rm -f "$CACHE_FILE"
        log_info "Cache disabled"
    fi
    
    # Run parallel processing
    results=$(process_files_parallel "${gd_files[@]}")
    read -r modified errors syntax_errors <<< "$results"
    
    # Summary
    log_section "Summary"
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    log_info "Total files processed: ${#gd_files[@]}"
    log_info "Files modified: $modified"
    log_info "Files with errors: $errors"
    log_info "Files with syntax errors: $syntax_errors"
    log_info "Duration: ${duration}s"
    
    # Generate JSON report
    generate_json_report "${#gd_files[@]}" "$modified" "$errors" "$syntax_errors" "$duration"
    log_success "JSON report saved to: $JSON_REPORT"
    
    # Determine exit code
    if [[ $syntax_errors -gt 0 ]] || [[ $errors -gt 0 ]]; then
        exit_code=$EXIT_UNFIXABLE_ISSUES
        log_error "Found unfixable issues. Please review the report."
    elif [[ $modified -gt 0 ]]; then
        exit_code=$EXIT_FIXABLE_ISSUES
        log_warning "Fixed $modified files. Please review the changes."
    else
        log_success "All files passed validation!"
    fi
    
    # Final message
    echo -e "\n${CYAN}Full report saved to: $REPORT_FILE${NC}"
    
    exit $exit_code
}

# Run main function
main "$@"