#!/bin/bash
# NeuroVis Project Context Updater for Optimal Claude Performance

echo "🔄 Updating NeuroVis project context for Claude optimization..."

# Create context file
CONTEXT_FILE=".claude/current-project-state.md"
mkdir -p .claude

echo "# NeuroVis Current Project State - $(date)" > $CONTEXT_FILE
echo "## ALWAYS REFERENCE THIS FOR MAXIMUM CLAUDE EFFECTIVENESS" >> $CONTEXT_FILE
echo "" >> $CONTEXT_FILE

# Project Overview
echo "## 🎯 PROJECT OVERVIEW" >> $CONTEXT_FILE
echo "- **Platform**: Educational neuroscience visualization for medical students" >> $CONTEXT_FILE
echo "- **Architecture**: Modular Godot 4.4.1 with educational focus" >> $CONTEXT_FILE
echo "- **Performance Targets**: 60fps, <500MB memory, <100 draw calls" >> $CONTEXT_FILE
echo "- **Standards**: WCAG 2.1 AA accessibility + medical accuracy" >> $CONTEXT_FILE
echo "" >> $CONTEXT_FILE

# Current Codebase Analysis
echo "## 📊 CURRENT CODEBASE ANALYSIS" >> $CONTEXT_FILE
echo "### File Statistics:" >> $CONTEXT_FILE
echo "- GDScript files: $(find . -name "*.gd" 2>/dev/null | wc -l | tr -d ' ')" >> $CONTEXT_FILE
echo "- Scene files: $(find . -name "*.tscn" 2>/dev/null | wc -l | tr -d ' ')" >> $CONTEXT_FILE
echo "- Educational components: $(grep -r "Educational Purpose" --include="*.gd" . 2>/dev/null | wc -l | tr -d ' ')" >> $CONTEXT_FILE
echo "- Total lines of code: $(find . -name "*.gd" -exec cat {} \; 2>/dev/null | wc -l | tr -d ' ')" >> $CONTEXT_FILE
echo "" >> $CONTEXT_FILE

# Architecture Analysis
echo "## 🏗️ ARCHITECTURE OVERVIEW" >> $CONTEXT_FILE
echo "### Directory Structure:" >> $CONTEXT_FILE
ls -la | grep ^d | awk '{print "- " $9}' | grep -v "\.$" >> $CONTEXT_FILE
echo "" >> $CONTEXT_FILE

echo "### Core Components:" >> $CONTEXT_FILE
if [ -d "core" ]; then
    find core -name "*.gd" 2>/dev/null | head -10 | sed 's/^/- /' >> $CONTEXT_FILE
fi
echo "" >> $CONTEXT_FILE

echo "### UI Components:" >> $CONTEXT_FILE
if [ -d "ui" ]; then
    find ui -name "*.gd" 2>/dev/null | head -10 | sed 's/^/- /' >> $CONTEXT_FILE
fi
echo "" >> $CONTEXT_FILE

# Recent Development Activity
echo "## 📈 RECENT DEVELOPMENT" >> $CONTEXT_FILE
echo "### Git History (Last 10 commits):" >> $CONTEXT_FILE
if command -v git &> /dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
    git log --oneline -10 2>/dev/null | sed 's/^/- /' >> $CONTEXT_FILE || echo "- No git history available" >> $CONTEXT_FILE
else
    echo "- No git repository initialized" >> $CONTEXT_FILE
fi
echo "" >> $CONTEXT_FILE

# Active Features
echo "## 🔧 ACTIVE FEATURES" >> $CONTEXT_FILE
echo "### Educational Components:" >> $CONTEXT_FILE
grep -r "class_name" --include="*.gd" . 2>/dev/null | sed 's/.*class_name /- /' | sort | uniq >> $CONTEXT_FILE
echo "" >> $CONTEXT_FILE

# Known Issues (from common error patterns)
echo "## ⚠️ KNOWN ISSUES TO WATCH" >> $CONTEXT_FILE
echo "### Common NeuroVis Development Challenges:" >> $CONTEXT_FILE
echo "- VBoxContainer configure() method calls - ensure ContentComponent has proper methods" >> $CONTEXT_FILE
echo "- Type hint compliance - all functions must have parameter and return types" >> $CONTEXT_FILE
echo "- Educational documentation - all components need learning objectives" >> $CONTEXT_FILE
echo "- Performance optimization - maintain 60fps for 3D brain interactions" >> $CONTEXT_FILE
echo "- Accessibility compliance - WCAG 2.1 AA for diverse learning needs" >> $CONTEXT_FILE
echo "" >> $CONTEXT_FILE

# Development Priorities
echo "## 🎯 CURRENT DEVELOPMENT PRIORITIES" >> $CONTEXT_FILE
echo "### Next Steps:" >> $CONTEXT_FILE
echo "- Fix any ContentComponent configure() method issues" >> $CONTEXT_FILE
echo "- Ensure all educational components have proper documentation" >> $CONTEXT_FILE
echo "- Validate medical accuracy of anatomical content" >> $CONTEXT_FILE
echo "- Optimize performance for educational interactions" >> $CONTEXT_FILE
echo "- Test accessibility compliance for learning tools" >> $CONTEXT_FILE
echo "" >> $CONTEXT_FILE

# Performance Indicators
echo "## 📊 PERFORMANCE INDICATORS" >> $CONTEXT_FILE
echo "### Code Quality Metrics:" >> $CONTEXT_FILE
echo "- Classes with educational documentation: $(grep -r "Educational Purpose" --include="*.gd" . 2>/dev/null | wc -l | tr -d ' ')" >> $CONTEXT_FILE
echo "- Functions with type hints: $(grep -r "func.*->.*:" --include="*.gd" . 2>/dev/null | wc -l | tr -d ' ')" >> $CONTEXT_FILE
echo "- Signal declarations: $(grep -r "signal " --include="*.gd" . 2>/dev/null | wc -l | tr -d ' ')" >> $CONTEXT_FILE
echo "" >> $CONTEXT_FILE

echo "## 🛡️ CLAUDE OPTIMIZATION NOTES" >> $CONTEXT_FILE
echo "### For Maximum Effectiveness:" >> $CONTEXT_FILE
echo "- Always reference this file for current project state" >> $CONTEXT_FILE
echo "- Use enhanced standards enforcement (Ctrl+Shift+U)" >> $CONTEXT_FILE
echo "- Include educational context in all development requests" >> $CONTEXT_FILE
echo "- Validate medical accuracy for anatomical content" >> $CONTEXT_FILE
echo "- Ensure accessibility compliance in UI changes" >> $CONTEXT_FILE
echo "- Maintain performance budgets for educational platform" >> $CONTEXT_FILE

echo "✅ Project context updated! Claude now has optimal NeuroVis development context."
echo "📍 Context saved to: $CONTEXT_FILE"
echo "🚀 Use this file reference in your Claude requests for maximum effectiveness!"
