# NeuroVis AI Implementation Quick Reference

## 🚀 Quick Start Commands

### Setup
```bash
cd '/Users/gagelaporta/11A-NeuroVis copy3'
git checkout -b ai-refactoring
./quick_test.sh  # Always test first!
```

### Component Extraction Pattern
```bash
claude -p "Role: GDScript architect. Extract [ComponentName] from node_3d.gd to core/components/[component_name].gd. Maintain signals, preserve functionality. Test with ./quick_test.sh. Output: diff patch."
```

### Batch Operations
```bash
claude -p "In parallel: 1) Fix style in core/, 2) Generate tests for components/, 3) Update documentation. Execute simultaneously for efficiency."
```

## 📋 Task Templates

### Refactoring Template
```xml
<task>
  <role>Senior GDScript developer</role>
  <context>NeuroVis [specific area] refactoring</context>
  <objective>[Specific goal]</objective>
  <constraints>
    - Maintain all functionality
    - Follow CLAUDE.md patterns
    - Test continuously
  </constraints>
  <validation>./quick_test.sh passes</validation>
  <output>unified_diff_patch</output>
</task>
```

### Debug Template
```bash
claude "Debug: [error message]. Check: 1) Node paths in scene, 2) Initialization order, 3) Signal connections. Fix root cause, not symptoms."
```

## 🔧 Common Fixes

### Null Reference Error
```bash
# DON'T: Add null checks everywhere
# DO: Fix the scene structure
claude "Fix null reference at [file:line]. Ensure node exists in scene at path [path]. Update scene if needed."
```

### Performance Issue
```bash
claude "Profile [operation]. Replace polling with signals. Measure before/after. Target: <16ms per frame."
```

## 📊 Progress Tracking

### After Each Component
1. ✅ Run `./quick_test.sh`
2. ✅ Check line count reduction
3. ✅ Verify no functionality lost
4. ✅ Update progress.md

### Daily Checklist
- [ ] Morning: Review plan for day
- [ ] Code: Implement with validation
- [ ] Test: Run test suite
- [ ] Document: Update as you go
- [ ] Commit: Small, working increments

## ⚡ Efficiency Tips

### Context Management
```bash
/clear  # Between major phases
/recall # Resume previous work
--continue # Keep context in claude
```

### Parallel Execution
Always request parallel when possible:
- "Simultaneously analyze X, implement Y, document Z"
- "In parallel: create tests, fix style, update docs"

### Smart References
```bash
# Reference docs efficiently
"Using CLAUDE.md section 3..." # Not full doc
"Following refactor plan step 2.1..." # Specific
"Apply pattern from component_base.gd..." # Reuse
```

## 🚨 Emergency Commands

### Revert Changes
```bash
git stash && git checkout main
./quick_test.sh
```

### Debug Scene Issues  
```bash
claude "List all required nodes for [Component]. Verify scene structure. Generate missing node report."
```

### Performance Emergency
```bash
claude "Emergency performance fix: Profile startup, identify operations >100ms, apply quick wins only."
```

## 📈 Key Metrics

Track these after each phase:
- **Lines of Code**: Main scene target < 200
- **Startup Time**: Target < 2 seconds  
- **Test Coverage**: Target > 80%
- **Performance**: Consistent 60fps
- **Errors**: Zero null references

## 🎯 Success Patterns

### Component Creation
1. Define clear responsibility
2. Extract related functions
3. Create clean public API
4. Use signals for communication
5. Test in isolation

### Error Handling
- ❌ Backup references
- ❌ Retry logic
- ❌ Fallback UI
- ✅ Fix scene structure
- ✅ Clear requirements
- ✅ Fail fast in dev

### Documentation
- ✅ Doc comments on public API
- ✅ Update CLAUDE.md patterns
- ✅ Progress tracking
- ✅ Architecture diagrams

---

**Golden Rule**: Make it work ➡️ Make it right ➡️ Make it fast
