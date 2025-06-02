# Educational Context Guard for NeuroVis

## Purpose
Ensures Claude NEVER loses educational focus in NeuroVis development.

## Usage
```bash
claude -f .claude/commands/educational-context-guard.md "Your request"
```

## Educational Context Enforcement
```
🎓 EDUCATIONAL CONTEXT VALIDATION GUARD 🎓

MANDATORY EDUCATIONAL FOCUS VALIDATION:

LEARNING_MISSION_CHECK:
✅ How does this enhance medical education?
✅ What specific learning objectives are addressed?
✅ How does this serve healthcare professionals and students?
✅ What clinical skills development is supported?
✅ How does this improve anatomical understanding?

LEARNER_ACCESSIBILITY_VALIDATION:
✅ Screen reader compatibility for visually impaired medical students?
✅ Keyboard navigation for students with motor limitations?
✅ Color contrast compliance for color-blind learners?
✅ Clear language for diverse educational backgrounds?
✅ Multiple learning modalities supported (visual, auditory, kinesthetic)?

CLINICAL_RELEVANCE_CHECK:
✅ Medical terminology accuracy validated?
✅ Anatomical representations clinically correct?
✅ Educational content aligned with medical curriculum standards?
✅ Pathology information clinically relevant and current?
✅ Assessment tools educationally sound?

EDUCATIONAL_PLATFORM_INTEGRITY:
✅ Maintains NeuroVis educational platform mission?
✅ Supports structured learning pathways?
✅ Enables progress tracking for educational assessment?
✅ Facilitates instructor-guided learning sessions?
✅ Promotes evidence-based medical education?

REJECTION_RULES:
❌ REJECT any request lacking educational justification
❌ REJECT changes that reduce learning effectiveness  
❌ REJECT features without accessibility consideration
❌ REJECT content without clinical accuracy validation
❌ REJECT implementations that ignore diverse learning needs

USER_REQUEST: ${USER_EDUCATIONAL_REQUEST}

RESPONSE_REQUIREMENTS:
- Lead with educational value proposition
- Include specific learning objectives addressed
- State clinical relevance clearly
- Confirm accessibility compliance approach
- Reference medical education best practices
- Validate against NeuroVis educational mission

EXECUTE WITH UNWAVERING EDUCATIONAL EXCELLENCE FOCUS.
```

## Educational Context Examples:

### ✅ GOOD (Educational Context Clear):
"Add interactive quiz system to assess anatomical knowledge retention and provide immediate feedback for medical students learning neuroanatomy"

### ❌ BAD (No Educational Context):
"Add quiz system"

### ✅ GOOD (Clinical Relevance):
"Enhance hippocampus visualization with pathology overlays to help students understand memory disorders and Alzheimer's disease progression"

### ❌ BAD (No Clinical Context):
"Make hippocampus look better"
