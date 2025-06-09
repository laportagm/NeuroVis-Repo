# Multi-Structure Selection System Documentation

## Overview

The NeuroVis educational platform now features a comprehensive multi-structure selection system that allows students to select and compare up to 3 anatomical structures simultaneously. This system is designed specifically for educational effectiveness in neuroanatomy learning.

## Key Features

### 1. Multi-Structure Selection Manager
- **Location**: `core/interaction/MultiStructureSelectionManager.gd`
- **Extends**: BrainStructureSelectionManager
- **Purpose**: Manages selection of up to 3 structures with clear visual hierarchy

#### Selection States
- **Primary (Gold)**: Main focus structure with highest visual prominence
- **Secondary (Dark Turquoise)**: First comparison structure
- **Tertiary (Medium Purple)**: Second comparison structure

#### Interaction Patterns
- **Normal Click**: Select single structure (replaces all)
- **Ctrl+Click**: Toggle selection (add/remove)
- **Shift+Click**: Add to comparison
- **Escape**: Clear all selections
- **Tab**: Cycle primary selection (when multiple selected)

### 2. Comparative Information Panel
- **Location**: `ui/panels/ComparativeInfoPanel.gd`
- **Purpose**: Display information for multiple structures in comparative format

#### Features
- Side-by-side structure information
- Anatomical relationship detection
- Focus buttons for individual structures
- Clear visual hierarchy matching selection states
- Responsive layout for different screen sizes

### 3. Visual Feedback System Integration
The multi-selection system integrates with the existing visual feedback system:
- Distinct colors for each selection state
- Colorblind-friendly color schemes
- Hierarchical outline thickness
- Smooth transitions between states

## Implementation Details

### Selection Management
```gdscript
# Handle selection with modifiers
func handle_selection_at_position(screen_position: Vector2, modifiers: Dictionary) -> void:
    if modifiers.get("ctrl", false):
        _handle_ctrl_selection(mesh)  # Toggle
    elif modifiers.get("shift", false):
        _handle_shift_selection(mesh)  # Add to comparison
    else:
        _handle_normal_selection(mesh)  # Replace all
```

### Visual Hierarchy
```gdscript
const SELECTION_COLORS: Dictionary = {
    SelectionState.PRIMARY: {
        "default": Color("#FFD700"),      # Gold
        "emission": 1.0,
        "outline": 3.0
    },
    SelectionState.SECONDARY: {
        "default": Color("#00CED1"),      # Dark turquoise
        "emission": 0.7,
        "outline": 2.0
    },
    SelectionState.TERTIARY: {
        "default": Color("#9370DB"),      # Medium purple
        "emission": 0.5,
        "outline": 1.0
    }
}
```

### Relationship Detection
The system automatically detects and displays relationships between selected structures:
- Limbic system membership
- Basal ganglia components
- Diencephalon structures
- Brainstem regions

## Educational Benefits

### 1. Comparative Learning
- Students can directly compare related structures
- Visual hierarchy guides attention appropriately
- Relationships are automatically highlighted

### 2. Cognitive Load Management
- Maximum 3 structures prevents overload
- Clear visual indicators for selection state
- Intuitive interaction patterns

### 3. Progressive Disclosure
- Single selection shows traditional info panel
- Multiple selections switch to comparative view
- Relationships revealed when relevant

## Usage Guide

### For Students

#### Selecting Structures
1. **Single Structure**: Right-click any brain structure
2. **Add to Comparison**: Hold Ctrl and right-click another structure
3. **Quick Add**: Hold Shift and right-click to add structures

#### Managing Selections
- Press **Escape** to clear all selections
- Press **Tab** to cycle which structure is primary
- Click "Focus" button to center camera on a structure
- Click "Clear All" to reset comparison

#### Understanding Visual Feedback
- **Gold highlight**: Your primary focus structure
- **Turquoise highlight**: First comparison structure
- **Purple highlight**: Second comparison structure
- **Relationship lines**: Show connected anatomy (planned feature)

### For Developers

#### Extending the System

##### Adding New Relationships
Edit the `_check_anatomical_relationships()` method in MultiStructureSelectionManager:
```gdscript
var relationships = {
    ["structure1", "structure2"]: "relationship_name",
    // Add new relationships here
}
```

##### Customizing Visual Hierarchy
Modify the `SELECTION_COLORS` constant to adjust colors, emission, or outline thickness.

##### Changing Selection Limits
Update `MAX_SELECTIONS` constant (not recommended above 3 for educational effectiveness).

## Integration Points

### Main Scene Integration
The main scene (`scenes/main/node_3d.gd`) handles:
- Input routing with modifier keys
- Multi-selection signal connections
- UI panel switching logic
- Selection state display

### Signal Flow
1. User input → MultiStructureSelectionManager
2. Selection state change → multi_selection_changed signal
3. Main scene updates UI panels
4. Comparative panel displays information

## Performance Considerations

### Optimizations
- Material caching for selection states
- Efficient signal handling
- Minimal UI updates on state changes
- Smart panel creation/destruction

### Memory Management
- Maximum 3 selections limits memory usage
- Panels created on-demand
- Proper cleanup on selection clear

## Accessibility

### Keyboard Support
- Full keyboard navigation
- Clear keyboard shortcuts
- Tab cycling for selections

### Visual Accessibility
- Colorblind-friendly selection colors
- High contrast options
- Clear visual hierarchy
- Non-color dependent indicators

## Testing

### Manual Testing Checklist
- [ ] Single selection works normally
- [ ] Ctrl+click toggles selection
- [ ] Shift+click adds to comparison
- [ ] Maximum 3 selections enforced
- [ ] Visual hierarchy clear
- [ ] Comparative panel shows correctly
- [ ] Relationships detected
- [ ] Escape clears all
- [ ] Tab cycles primary
- [ ] Focus buttons work

### Debug Commands
```gdscript
# In F1 console:
multiselect_test     # Test multi-selection system
multiselect_debug    # Toggle debug visualization
multiselect_report   # Show current selection state
```

## Future Enhancements

### Planned Features
1. Visual relationship lines between structures
2. Animation transitions between selection states
3. Selection history/undo
4. Grouped selection presets
5. Export comparison data

### Research Opportunities
1. Eye tracking integration for selection
2. Learning analytics on comparison patterns
3. Adaptive selection suggestions
4. Collaborative selection sharing

## Troubleshooting

### Common Issues

#### Selections Not Working
- Check if MultiStructureSelectionManager is properly initialized
- Verify input modifiers are being passed correctly
- Ensure visual feedback system is active

#### Comparative Panel Not Showing
- Verify ComparativeInfoPanel scene exists
- Check UI_Layer node presence
- Confirm panel creation in _show_comparative_panel()

#### Visual Feedback Issues
- Check AccessibilityManager settings
- Verify material application in selection manager
- Ensure visual feedback system initialized

## Conclusion

The multi-structure selection system provides a powerful educational tool for comparative anatomy learning. It maintains intuitive interaction patterns while enabling sophisticated comparison workflows. The clear visual hierarchy and thoughtful interaction design support effective learning without overwhelming students.