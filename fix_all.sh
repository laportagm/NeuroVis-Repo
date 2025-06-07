#!/usr/bin/env bash

# fix_all.sh - Comprehensive GDScript fixer for NeuroVis
# Fixes string multiplication patterns and formats GDScript files
# Compatible with macOS sed syntax

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="${SCRIPT_DIR}/backups_${TIMESTAMP}"
LOGFILE="${SCRIPT_DIR}/fix_all_${TIMESTAMP}.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${1}" | tee -a "${LOGFILE}"
}

# Error handling
error_exit() {
    log "${RED}ERROR: ${1}${NC}"
    exit 1
}

# Success message
success() {
    log "${GREEN}✓ ${1}${NC}"
}

# Warning message
warning() {
    log "${YELLOW}⚠ ${1}${NC}"
}

# Info message
info() {
    log "${BLUE}ℹ ${1}${NC}"
}

# Create backup directory
create_backup_dir() {
    if [[ ! -d "${BACKUP_DIR}" ]]; then
        mkdir -p "${BACKUP_DIR}" || error_exit "Failed to create backup directory: ${BACKUP_DIR}"
        success "Created backup directory: ${BACKUP_DIR}"
    fi
}

# Backup a file
backup_file() {
    local file="$1"
    local relative_path="${file#${SCRIPT_DIR}/}"
    local backup_path="${BACKUP_DIR}/${relative_path}"
    local backup_dir="$(dirname "${backup_path}")"
    
    # Create backup subdirectory if needed
    if [[ ! -d "${backup_dir}" ]]; then
        mkdir -p "${backup_dir}" || error_exit "Failed to create backup subdirectory: ${backup_dir}"
    fi
    
    # Copy file to backup
    cp "${file}" "${backup_path}" || error_exit "Failed to backup file: ${file}"
}

# Find gdformat executable
find_gdformat() {
    local gdformat_path=""
    
    # Check common locations
    if command -v gdformat >/dev/null 2>&1; then
        gdformat_path="gdformat"
    elif [[ -f "${HOME}/godot-env/bin/gdformat" ]]; then
        gdformat_path="${HOME}/godot-env/bin/gdformat"
    elif [[ -f "/usr/local/bin/gdformat" ]]; then
        gdformat_path="/usr/local/bin/gdformat"
    elif [[ -f "/opt/homebrew/bin/gdformat" ]]; then
        gdformat_path="/opt/homebrew/bin/gdformat"
    fi
    
    echo "${gdformat_path}"
}

# Fix string multiplication patterns in GDScript
fix_string_patterns() {
    local file="$1"
    local changes_made=false
    
    # Create temporary file for processing
    local temp_file="${file}.tmp"
    
    # Pattern 1: Fix string multiplication (e.g., "text" * 5 -> "text".repeat(5))
    if sed -E 's/\"([^\"]*)\"\s*\*\s*([0-9]+)/"\1".repeat(\2)/g' "${file}" > "${temp_file}"; then
        if ! cmp -s "${file}" "${temp_file}"; then
            mv "${temp_file}" "${file}"
            changes_made=true
            info "Fixed string multiplication patterns in: ${file}"
        else
            rm "${temp_file}"
        fi
    else
        rm -f "${temp_file}"
        warning "Failed to process string patterns in: ${file}"
    fi
    
    # Pattern 2: Fix deprecated Godot 3 to Godot 4 syntax
    # Fix load() to preload() where appropriate
    if sed -i "" -E 's/load\(\"res:\/\/([^\"]*\.gd)\"\)/preload("res:\/\/\1")/g' "${file}"; then
        info "Fixed load() to preload() patterns in: ${file}"
        changes_made=true
    fi
    
    # Pattern 3: Fix old signal syntax
    if sed -i "" -E 's/\.connect\(\s*\"([^\"]*)\"\s*,\s*self\s*,\s*\"([^\"]*)\"\s*\)/.connect(\"\1\", \2)/g' "${file}"; then
        info "Fixed signal connection syntax in: ${file}"
        changes_made=true
    fi
    
    # Pattern 4: Fix old export syntax
    if sed -i "" -E 's/export\s*\(\s*([^)]*)\s*\)\s*var/\@export var/g' "${file}"; then
        info "Fixed export syntax in: ${file}"
        changes_made=true
    fi
    
    if [[ "${changes_made}" == true ]]; then
        return 0
    else
        return 1
    fi
}

# Format GDScript file with gdformat
format_gdscript() {
    local file="$1"
    local gdformat_path="$2"
    
    if [[ -n "${gdformat_path}" ]]; then
        if "${gdformat_path}" "${file}" >/dev/null 2>&1; then
            success "Formatted: ${file}"
            return 0
        else
            warning "Failed to format: ${file}"
            return 1
        fi
    else
        warning "gdformat not available, skipping formatting for: ${file}"
        return 1
    fi
}

# Process a single GDScript file
process_file() {
    local file="$1"
    local gdformat_path="$2"
    local fixed=false
    
    info "Processing: ${file}"
    
    # Create backup
    backup_file "${file}"
    
    # Fix string patterns
    if fix_string_patterns "${file}"; then
        fixed=true
    fi
    
    # Format with gdformat
    if format_gdscript "${file}" "${gdformat_path}"; then
        fixed=true
    fi
    
    if [[ "${fixed}" == true ]]; then
        success "Processed: ${file}"
    else
        info "No changes needed: ${file}"
    fi
}

# Main execution
main() {
    log "${BLUE}=== NeuroVis GDScript Fixer Started ===${NC}"
    log "Timestamp: $(date)"
    log "Script directory: ${SCRIPT_DIR}"
    log "Log file: ${LOGFILE}"
    
    # Create backup directory
    create_backup_dir
    
    # Find gdformat
    local gdformat_path
    gdformat_path="$(find_gdformat)"
    
    if [[ -n "${gdformat_path}" ]]; then
        success "Found gdformat at: ${gdformat_path}"
    else
        warning "gdformat not found - will skip formatting step"
        warning "To install gdformat: pip install gdtoolkit"
    fi
    
    # Find all .gd files
    info "Searching for .gd files in: ${SCRIPT_DIR}"
    local file_count=0
    local processed_count=0
    
    # Use find to locate all .gd files, excluding backup directories
    while IFS= read -r -d '' file; do
        # Skip backup directories and .godot directory
        if [[ "${file}" == *"/backups_"* ]] || [[ "${file}" == *"/.godot/"* ]]; then
            continue
        fi
        
        ((file_count++))
        
        # Process the file
        if process_file "${file}" "${gdformat_path}"; then
            ((processed_count++))
        fi
        
    done < <(find "${SCRIPT_DIR}" -name "*.gd" -type f -print0)
    
    # Summary
    log ""
    log "${BLUE}=== Summary ===${NC}"
    log "Files found: ${file_count}"
    log "Files processed: ${processed_count}"
    log "Backup directory: ${BACKUP_DIR}"
    log "Log file: ${LOGFILE}"
    
    if [[ ${file_count} -gt 0 ]]; then
        success "GDScript fixing completed successfully!"
        info "Backups saved in: ${BACKUP_DIR}"
    else
        warning "No .gd files found to process"
    fi
}

# Cleanup function for trap
cleanup() {
    if [[ -f "${LOGFILE}" ]]; then
        info "Log file available at: ${LOGFILE}"
    fi
}

# Set trap for cleanup
trap cleanup EXIT

# Run main function
main "$@"