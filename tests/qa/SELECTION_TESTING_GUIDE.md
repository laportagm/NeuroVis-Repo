# NeuroVis Selection Reliability Testing Guide

## Quick Start

### Running Automated Tests

1. **Launch NeuroVis**
   ```bash
   godot --path "/Users/gagelaporta/11A-NeuroVis copy3"
   ```

2. **Open Debug Console** (Press F1)

3. **Run Tests**
   ```
   # Full test (all 25 structures, all angles) - ~15 minutes
   qa_test full
   
   # Quick test (5 structures, 3 angles) - ~3 minutes
   qa_test quick
   
   # Single structure test
   qa_test structure Hippocampus
   ```

4. **Monitor Progress**
   ```
   qa_status
   ```

5. **View Results**
   - Reports saved to: `test_reports/selection_reliability_[timestamp].md`

## Manual Testing Protocol

### 1. Edge Case Testing

#### Small Structures
Test these notoriously difficult structures:
- **Pineal Gland** - Very small, center of brain
- **Pituitary Gland** - Small, base of brain
- **Subthalamic Nucleus** - Tiny, deep structure
- **Substantia Nigra** - Thin structure

**Test Steps:**
1. Zoom in close (mouse wheel)
2. Try clicking on edges
3. Try clicking when partially obscured
4. Document if selection "feels" imprecise

#### Overlapping Structures
Test selection when structures overlap:
- **Caudate Nucleus + Putamen** (part of Striatum)
- **Hippocampus + Amygdala** (adjacent structures)
- **Thalamus + Hypothalamus** (stacked structures)

**Test Steps:**
1. Position camera to create overlap
2. Click on boundary areas
3. Note which structure gets selected
4. Document any "wrong" selections

### 2. Visual Feedback Testing

#### Hover Feedback
1. Move mouse slowly over structures
2. Check hover highlight (orange glow):
   - Does it appear immediately?
   - Does it follow mouse smoothly?
   - Does it disappear properly?

#### Selection Feedback
1. Right-click to select
2. Check selection highlight (cyan):
   - Is the color clearly visible?
   - Does animation play smoothly?
   - Is selected state persistent?

#### Success Feedback
1. After selection, check green flash
2. Verify label updates correctly
3. Check info panel displays

### 3. Camera Angle Testing

Test each structure from these critical angles:

#### Front View (Press 1)
- Best for: Frontal/Parietal lobes
- Challenges: Deep structures hidden

#### Side View (Press 3)
- Best for: Temporal lobe, Hippocampus
- Challenges: Midline structures overlap

#### Top View (Press 7)
- Best for: Corpus Callosum
- Challenges: Vertical structures compressed

#### Custom Angles
1. Orbit camera (left-click + drag)
2. Test selection at oblique angles
3. Note any "dead zones" where selection fails

### 4. Zoom Level Testing

#### Close Zoom (Scroll wheel in)
- Structure fills most of screen
- Test if selection works on all parts
- Check for "too close" issues

#### Medium Zoom (Default)
- Structure clearly visible
- Should be optimal distance
- Baseline for comparison

#### Far Zoom (Scroll wheel out)
- Multiple structures visible
- Test selection precision
- Check for misclicks

## Debug Console Commands

### Analysis Commands
```
# Analyze selection system configuration
qa_analyze

# Show structure bounds visualization
qa_bounds Hippocampus

# Simulate clicks on a structure
qa_simulate Thalamus 10
```

### Testing Commands
```
# Run full test suite
qa_test full

# Quick 5-structure test
qa_test quick

# Test specific structure
qa_test structure Cerebellum

# Check test progress
qa_status

# Stop running test
qa_stop
```

### General Debug Commands
```
# Show all available models
models

# Check knowledge base
kb status

# Search for structures
kb search memory

# Tree view of scene
tree BrainModel

# Show collision shapes
collision
```

## Common Issues to Look For

### 1. **Phantom Clicks**
- Click appears to hit structure but nothing selected
- Usually indicates collision shape mismatch

### 2. **Wrong Structure Selected**
- Different structure highlighted than clicked
- Often happens with overlapping geometry

### 3. **Inconsistent Hover**
- Hover highlight flickers or disappears
- May indicate performance issues

### 4. **Edge Selection Failures**
- Can't select structure near edges
- Collision shape may be smaller than visual

### 5. **Camera-Dependent Issues**
- Structure selectable from one angle but not another
- May indicate normal-based culling issues

## Performance Monitoring

During testing, monitor:
- **Frame Rate**: Should maintain 60 FPS
- **Selection Response**: Should be instant (<100ms)
- **Memory Usage**: Should stay under 300MB

Use debug commands:
```
performance
memory
```

## Reporting Issues

When documenting failures, include:
1. **Structure name**
2. **Camera angle** (front/side/top/custom)
3. **Zoom level** (close/medium/far)
4. **Click coordinates** (from test output)
5. **What happened** (nothing/wrong structure/etc)
6. **Reproducibility** (always/sometimes/once)

## Test Report Structure

After automated testing, review the generated report for:

1. **Overall Statistics**
   - Total success rate
   - Structure difficulty rankings

2. **Per-Structure Analysis**
   - Success rates by camera angle
   - Success rates by zoom level
   - Common failure patterns

3. **Priority Recommendations**
   - Critical issues (>70 difficulty score)
   - High priority issues (50-70 score)

4. **Failure Coordinates**
   - Exact positions where clicks failed
   - Patterns in failure locations

## Best Practices

1. **Run tests in consistent environment**
   - Same window size
   - No other applications interfering
   - Stable lighting conditions

2. **Test systematically**
   - Complete one structure before moving to next
   - Test all angles for each structure
   - Document immediately

3. **Verify automated results**
   - Manually test structures that fail automated tests
   - Confirm edge cases identified by automation

4. **Consider user experience**
   - Note which structures "feel" hard to select
   - Document any frustrating interactions
   - Think like a student using the tool

## Next Steps After Testing

1. **Review test reports** in `test_reports/` directory
2. **Prioritize fixes** based on difficulty scores
3. **Implement improvements** to selection system
4. **Re-run tests** to verify improvements
5. **Document changes** in improvement tracking