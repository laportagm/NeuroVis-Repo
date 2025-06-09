#!/bin/bash
# Setup script for the new AI architecture

echo "Setting up AI architecture..."

# Create directories if they don't exist
mkdir -p core/ai/providers core/ai/ui/setup core/ai/config

# Copy and update files
echo "Updating main scene..."
cp scenes/main/node_3d_updated.gd scenes/main/node_3d.gd

# Add autoloads to project.godot (would require a proper Godot editor command)
echo "NOTE: You need to manually add the following autoloads in the Godot editor:"
echo "- AIConfig: res://core/ai/config/AIConfigurationManager.gd"
echo "- AIRegistry: res://core/ai/AIProviderRegistry.gd"

# Run test
echo "To test the implementation, create a new scene with a Node as root and attach:"
echo "- test_ai_integration.gd"

echo "AI architecture setup complete!"
echo "Please see docs/dev/AI_ARCHITECTURE_GUIDE.md for more information."