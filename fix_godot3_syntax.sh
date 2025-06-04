#!/bin/bash

# Fix Godot 3 to Godot 4 syntax issues in GDScript files

echo "🔧 Fixing Godot 3 syntax patterns..."

# Fix onready var to @onready var
echo "Updating onready syntax..."
find . -name "*.gd" -type f ! -path "./godot-mcp/*" -exec grep -l "^onready var" {} \; | while read file; do
    echo "  Updating: $file"
    sed -i.bak 's/^onready var/@onready var/g' "$file"
done

# Fix OS.get_window_size() to get_window().size
echo "Updating window size calls..."
find . -name "*.gd" -type f ! -path "./godot-mcp/*" -exec grep -l "OS\.get_window_size()" {} \; | while read file; do
    echo "  Updating: $file"
    sed -i.bak 's/OS\.get_window_size()/get_window().size/g' "$file"
done

# Fix Engine.editor_hint to Engine.is_editor_hint()
echo "Updating editor hint checks..."
find . -name "*.gd" -type f ! -path "./godot-mcp/*" -exec grep -l "Engine\.editor_hint" {} \; | while read file; do
    echo "  Updating: $file"
    sed -i.bak 's/Engine\.editor_hint/Engine.is_editor_hint()/g' "$file"
done

# Fix PoolStringArray to PackedStringArray
echo "Updating array types..."
find . -name "*.gd" -type f ! -path "./godot-mcp/*" -exec grep -l "PoolStringArray" {} \; | while read file; do
    echo "  Updating: $file"
    sed -i.bak 's/PoolStringArray/PackedStringArray/g' "$file"
done

# Fix empty() to is_empty()
echo "Updating empty() calls..."
find . -name "*.gd" -type f ! -path "./godot-mcp/*" -exec grep -l "\.empty()" {} \; | while read file; do
    echo "  Updating: $file"
    sed -i.bak 's/\.empty()/.is_empty()/g' "$file"
done

# Clean up backup files
echo "Cleaning up backup files..."
find . -name "*.gd.bak" -type f -delete

echo "✅ Syntax updates complete!"
echo ""
echo "⚠️  Please review the following:"
echo "1. Signal connections may need manual updates to use Callable syntax"
echo "2. Some renames may need context-specific adjustments"
echo "3. Test the project in Godot 4.4.1 to catch any remaining issues"