# Command: Accessibility Compliance Check

**Purpose**: Ensure comprehensive WCAG 2.1 AA accessibility compliance for NeuroVis educational platform through automated testing, manual auditing, and inclusive design validation for diverse learning needs.

**MCPs Used**: `playwright` (primary), `sequential-thinking`, `filesystem`, `memory`, `sqlite`

## Overview
This command provides complete accessibility compliance validation for NeuroVis educational platform, ensuring inclusive design that supports all learners including those with visual, auditory, motor, and cognitive disabilities in medical education contexts.

## Accessibility Compliance Pipeline

### Phase 1: Accessibility Standards Framework
**Use MCP `sequential-thinking`** to establish comprehensive accessibility framework:
- Map WCAG 2.1 AA requirements to educational platform components
- Identify specific accessibility needs for medical education contexts
- Establish testing methodologies for 3D educational interactions
- Plan inclusive design patterns for diverse learning disabilities

**WCAG 2.1 AA Educational Requirements**:
- **Perceivable**: Visual, auditory, and tactile alternatives for anatomical content
- **Operable**: Keyboard navigation for all educational interactions
- **Understandable**: Clear language and consistent educational navigation
- **Robust**: Compatible with assistive technologies and screen readers

**Use MCP `memory`** to:
- Store accessibility testing patterns and best practices
- Track compliance validation for different educational components
- Maintain relationships between accessibility features and learning outcomes
- Create knowledge base of inclusive design solutions

### Phase 2: Automated Accessibility Testing
**Use MCP `playwright`** to implement comprehensive automated accessibility testing:
- Test educational UI components for WCAG compliance
- Validate keyboard navigation through learning workflows
- Check color contrast ratios for medical content visibility
- Verify screen reader compatibility with anatomical information

**Automated Accessibility Testing Implementation**:
```javascript
// Educational Accessibility Test Suite
class NeuroVisAccessibilityTester {
    constructor(page) {
        this.page = page;
        this.violations = [];
        this.wcagLevel = 'AA';
    }

    async runComprehensiveAccessibilityAudit() {
        console.log('[AccessibilityTester] Starting comprehensive WCAG 2.1 AA audit for NeuroVis educational platform');
        
        // Test educational UI components
        await this.testEducationalUIAccessibility();
        
        // Test 3D interaction accessibility
        await this.test3DEducationalInteractions();
        
        // Test learning workflow accessibility
        await this.testLearningWorkflowAccessibility();
        
        // Test theme accessibility (Enhanced/Minimal)
        await this.testEducationalThemeAccessibility();
        
        // Generate comprehensive report
        return this.generateAccessibilityReport();
    }

    async testEducationalUIAccessibility() {
        console.log('[AccessibilityTester] Testing educational UI component accessibility');
        
        // Navigate to educational interface
        await this.page.goto('file://educational_ui_test.html');
        
        // Test info panel accessibility
        await this.page.waitForSelector('.educational-info-panel');
        await this.testInfoPanelAccessibility();
        
        // Test navigation accessibility
        await this.testEducationalNavigationAccessibility();
        
        // Test form accessibility (quiz components)
        await this.testEducationalFormsAccessibility();
    }

    async testInfoPanelAccessibility() {
        // Test screen reader compatibility
        const infoPanelTitle = await this.page.locator('.info-panel-title');
        const hasAriaLabel = await infoPanelTitle.getAttribute('aria-label');
        
        if (!hasAriaLabel) {
            this.violations.push({
                type: 'missing-aria-label',
                element: 'info-panel-title',
                severity: 'high',
                wcagCriteria: '4.1.2',
                impact: 'Screen readers cannot identify educational content panel'
            });
        }
        
        // Test keyboard navigation
        await this.page.keyboard.press('Tab');
        const focusedElement = await this.page.evaluate(() => document.activeElement.className);
        
        if (!focusedElement.includes('info-panel')) {
            this.violations.push({
                type: 'keyboard-navigation-failure',
                element: 'info-panel',
                severity: 'high',
                wcagCriteria: '2.1.1',
                impact: 'Educational content inaccessible via keyboard'
            });
        }
        
        // Test color contrast for medical content
        await this.validateEducationalContentContrast();
    }

    async validateEducationalContentContrast() {
        const contrastResults = await this.page.evaluate(() => {
            const textElements = document.querySelectorAll('.educational-text, .medical-terminology, .clinical-notes');
            const results = [];
            
            for (const element of textElements) {
                const computedStyle = window.getComputedStyle(element);
                const textColor = computedStyle.color;
                const backgroundColor = computedStyle.backgroundColor;
                
                // Calculate contrast ratio (simplified)
                const contrastRatio = this.calculateContrastRatio(textColor, backgroundColor);
                
                results.push({
                    element: element.className,
                    textColor: textColor,
                    backgroundColor: backgroundColor,
                    contrastRatio: contrastRatio,
                    passes: contrastRatio >= 4.5 // WCAG AA standard
                });
            }
            
            return results;
        });
        
        for (const result of contrastResults) {
            if (!result.passes) {
                this.violations.push({
                    type: 'insufficient-color-contrast',
                    element: result.element,
                    severity: 'medium',
                    wcagCriteria: '1.4.3',
                    contrastRatio: result.contrastRatio,
                    impact: 'Medical content may be difficult to read for users with visual impairments'
                });
            }
        }
    }

    async test3DEducationalInteractions() {
        console.log('[AccessibilityTester] Testing 3D educational interaction accessibility');
        
        // Test alternative text for 3D models
        await this.test3DModelAccessibility();
        
        // Test keyboard alternatives for mouse interactions
        await this.testKeyboard3DNavigation();
        
        // Test audio descriptions for visual 3D content
        await this.testAudioDescriptions();
    }

    async test3DModelAccessibility() {
        // Navigate to 3D brain visualization
        await this.page.goto('file://3d_brain_test.html');
        
        // Check for alternative text descriptions
        const brainModelContainer = await this.page.locator('.brain-model-container');
        const hasAltDescription = await brainModelContainer.getAttribute('aria-describedby');
        
        if (!hasAltDescription) {
            this.violations.push({
                type: 'missing-3d-alt-description',
                element: 'brain-model-container',
                severity: 'high',
                wcagCriteria: '1.1.1',
                impact: 'Anatomical 3D content inaccessible to screen reader users'
            });
        }
        
        // Test structure selection accessibility
        await this.testStructureSelectionAccessibility();
    }

    async testStructureSelectionAccessibility() {
        // Test keyboard-based structure selection
        await this.page.keyboard.press('Tab');
        await this.page.keyboard.press('Enter'); // Select structure
        
        // Verify accessible feedback
        const selectionFeedback = await this.page.locator('[role="status"]');
        const feedbackText = await selectionFeedback.textContent();
        
        if (!feedbackText || feedbackText.trim() === '') {
            this.violations.push({
                type: 'missing-selection-feedback',
                element: 'structure-selection',
                severity: 'high',
                wcagCriteria: '4.1.3',
                impact: 'Users cannot receive feedback about selected anatomical structures'
            });
        }
    }

    async testLearningWorkflowAccessibility() {
        console.log('[AccessibilityTester] Testing learning workflow accessibility');
        
        // Test quiz accessibility
        await this.testEducationalQuizAccessibility();
        
        // Test progress tracking accessibility
        await this.testProgressTrackingAccessibility();
        
        // Test help and documentation accessibility
        await this.testHelpDocumentationAccessibility();
    }

    async testEducationalQuizAccessibility() {
        await this.page.goto('file://educational_quiz_test.html');
        
        // Test form labels and descriptions
        const questionElements = await this.page.locator('.quiz-question');
        const questionCount = await questionElements.count();
        
        for (let i = 0; i < questionCount; i++) {
            const question = questionElements.nth(i);
            const hasLabel = await question.locator('label').count() > 0;
            const hasFieldset = await question.locator('fieldset').count() > 0;
            
            if (!hasLabel && !hasFieldset) {
                this.violations.push({
                    type: 'missing-form-labels',
                    element: `quiz-question-${i}`,
                    severity: 'high',
                    wcagCriteria: '3.3.2',
                    impact: 'Educational quiz questions inaccessible to assistive technologies'
                });
            }
        }
        
        // Test error handling accessibility
        await this.testQuizErrorHandling();
    }

    async testEducationalThemeAccessibility() {
        console.log('[AccessibilityTester] Testing educational theme accessibility');
        
        // Test Enhanced theme accessibility
        await this.page.evaluate(() => {
            UIThemeManager.set_theme_mode(UIThemeManager.ThemeMode.ENHANCED);
        });
        await this.validateThemeAccessibility('enhanced');
        
        // Test Minimal theme accessibility
        await this.page.evaluate(() => {
            UIThemeManager.set_theme_mode(UIThemeManager.ThemeMode.MINIMAL);
        });
        await this.validateThemeAccessibility('minimal');
    }

    async validateThemeAccessibility(themeName) {
        // Test theme-specific contrast ratios
        const themeContrast = await this.page.evaluate(() => {
            const primaryText = window.getComputedStyle(document.querySelector('.primary-text'));
            const secondaryText = window.getComputedStyle(document.querySelector('.secondary-text'));
            const background = window.getComputedStyle(document.body);
            
            return {
                primaryContrast: this.calculateContrastRatio(primaryText.color, background.backgroundColor),
                secondaryContrast: this.calculateContrastRatio(secondaryText.color, background.backgroundColor)
            };
        });
        
        if (themeContrast.primaryContrast < 4.5) {
            this.violations.push({
                type: 'theme-contrast-failure',
                element: `${themeName}-theme-primary-text`,
                severity: 'high',
                wcagCriteria: '1.4.3',
                contrastRatio: themeContrast.primaryContrast,
                impact: `${themeName} theme primary text fails contrast requirements`
            });
        }
    }

    generateAccessibilityReport() {
        const report = {
            testDate: new Date().toISOString(),
            wcagLevel: this.wcagLevel,
            totalViolations: this.violations.length,
            violationsBySeverity: this.groupViolationsBySeverity(),
            violationsByWCAGCriteria: this.groupViolationsByWCAGCriteria(),
            educationalAccessibilityScore: this.calculateEducationalAccessibilityScore(),
            violations: this.violations,
            recommendations: this.generateRecommendations()
        };
        
        return report;
    }

    calculateEducationalAccessibilityScore() {
        // Calculate accessibility score based on educational impact
        const totalTests = 50; // Total accessibility test points
        const violationPenalties = this.violations.reduce((total, violation) => {
            const penalties = { 'high': 5, 'medium': 2, 'low': 1 };
            return total + (penalties[violation.severity] || 0);
        }, 0);
        
        const score = Math.max(0, ((totalTests - violationPenalties) / totalTests) * 100);
        return Math.round(score * 10) / 10; // Round to 1 decimal place
    }
}
```

### Phase 3: Manual Accessibility Auditing
**Use MCP `filesystem`** to implement manual accessibility testing procedures:
- Screen reader testing with NVDA, JAWS, and VoiceOver
- Keyboard-only navigation testing for educational workflows
- Motor accessibility testing for 3D interaction alternatives
- Cognitive accessibility evaluation for educational content clarity

**Manual Accessibility Testing Checklist**:
```markdown
# NeuroVis Educational Platform Manual Accessibility Audit

## Screen Reader Testing
### NVDA (Windows)
- [ ] **Educational Content Navigation**: All anatomical information announced clearly
- [ ] **3D Model Descriptions**: Alternative text provides meaningful spatial information
- [ ] **Quiz Components**: Questions and answers properly labeled and navigable
- [ ] **Progress Indicators**: Learning progress announced and understandable
- [ ] **Error Messages**: Validation errors clearly communicated

### JAWS (Windows)
- [ ] **Table Navigation**: Anatomical data tables properly structured
- [ ] **Form Controls**: All educational input controls labeled and functional
- [ ] **Heading Structure**: Educational content hierarchy logical and navigable
- [ ] **Landmark Navigation**: Page sections properly identified
- [ ] **Live Regions**: Dynamic content updates announced appropriately

### VoiceOver (macOS)
- [ ] **Rotor Navigation**: Educational content accessible through VoiceOver rotor
- [ ] **Gesture Support**: Educational interactions work with VoiceOver gestures
- [ ] **3D Content**: Spatial relationships conveyed through audio descriptions
- [ ] **Theme Switching**: Enhanced/Minimal theme changes announced
- [ ] **AI Assistant**: Educational AI responses properly formatted for screen readers

## Keyboard Navigation Testing
### Educational Workflow Navigation
- [ ] **Tab Order**: Logical progression through educational interface
- [ ] **Focus Indicators**: Clear visual focus indicators for all interactive elements
- [ ] **Keyboard Shortcuts**: Educational shortcuts documented and functional
- [ ] **Modal Dialogs**: Educational popups keyboard accessible and properly trapped
- [ ] **3D Alternatives**: Keyboard alternatives for mouse-based 3D interactions

### Specialized Educational Controls
- [ ] **Structure Selection**: Keyboard methods for selecting anatomical structures
- [ ] **Zoom Controls**: Keyboard accessible zoom for detailed examination
- [ ] **Layer Visibility**: Keyboard toggles for anatomical layer visibility
- [ ] **Quiz Navigation**: Complete keyboard access for educational assessments
- [ ] **Progress Tracking**: Keyboard accessible learning progress review

## Motor Accessibility Testing
### Alternative Interaction Methods
- [ ] **Large Click Targets**: Educational buttons meet 44px minimum size
- [ ] **Sticky Keys Support**: Complex keyboard combinations work with accessibility tools
- [ ] **Hover Alternatives**: Important information not dependent on mouse hover
- [ ] **Drag Alternatives**: Keyboard alternatives for drag-and-drop educational activities
- [ ] **Timeout Extensions**: Adequate time limits for educational activities

## Cognitive Accessibility Testing
### Educational Content Clarity
- [ ] **Plain Language**: Medical terminology explained in accessible language
- [ ] **Consistent Navigation**: Educational interface follows predictable patterns
- [ ] **Error Prevention**: Clear guidance prevents educational workflow errors
- [ ] **Content Structure**: Complex anatomical information well-organized
- [ ] **Progressive Disclosure**: Information revealed in manageable chunks

### Learning Support Features
- [ ] **Help Documentation**: Accessible help for educational features
- [ ] **Context Sensitivity**: Relevant help available when needed
- [ ] **Memory Aids**: Educational bookmarks and progress saving functional
- [ ] **Customization**: Accessibility preferences preserved across sessions
- [ ] **Simplified Mode**: Option for reduced complexity in educational interface
```

### Phase 4: Assistive Technology Integration
**Use MCP `playwright`** to test integration with assistive technologies:
- Screen reader API integration testing
- Voice control software compatibility
- Eye-tracking technology support for 3D navigation
- Switch navigation device support

**Assistive Technology Testing**:
```javascript
// Assistive Technology Integration Tests
async function testAssistiveTechnologyIntegration(page) {
    console.log('[AccessibilityTester] Testing assistive technology integration');
    
    // Test screen reader API integration
    await testScreenReaderAPI(page);
    
    // Test voice control compatibility
    await testVoiceControlSupport(page);
    
    // Test switch navigation
    await testSwitchNavigationSupport(page);
}

async function testScreenReaderAPI(page) {
    // Test ARIA live regions for dynamic content
    await page.evaluate(() => {
        // Simulate structure selection
        BrainStructureSelectionManager.select_structure('hippocampus');
    });
    
    // Verify live region updates
    const liveRegion = await page.locator('[aria-live="polite"]');
    const liveContent = await liveRegion.textContent();
    
    if (!liveContent.includes('hippocampus')) {
        console.error('Live region not updating for structure selection');
    }
    
    // Test accessible name computation
    const structureInfo = await page.locator('.structure-info');
    const accessibleName = await structureInfo.getAttribute('aria-labelledby');
    
    if (!accessibleName) {
        console.error('Structure info missing accessible name');
    }
}

async function testVoiceControlSupport(page) {
    // Test voice command integration
    const voiceCommands = [
        'select hippocampus',
        'show functions',
        'next structure',
        'start quiz'
    ];
    
    for (const command of voiceCommands) {
        // Simulate voice command execution
        await page.evaluate((cmd) => {
            if (window.VoiceControlInterface) {
                window.VoiceControlInterface.executeCommand(cmd);
            }
        }, command);
        
        // Verify command execution
        await page.waitForTimeout(500);
        // Additional verification logic here
    }
}
```

### Phase 5: Educational Accessibility Optimization
**Use MCP `sequential-thinking`** to analyze accessibility optimization opportunities:
- Identify accessibility barriers specific to medical education
- Develop inclusive design solutions for 3D anatomical content
- Create accessibility enhancement strategies for different learning disabilities
- Plan accessibility feature integration with educational workflows

**Use MCP `memory`** to:
- Store successful accessibility solutions and patterns
- Track accessibility improvement effectiveness
- Maintain relationships between accessibility features and educational outcomes
- Create knowledge base of inclusive medical education design

### Phase 6: Accessibility Documentation & Training
**Use MCP `filesystem`** to create comprehensive accessibility documentation:
- Accessibility guidelines for educational content creators
- Testing procedures for ongoing accessibility validation
- User guides for accessibility features in educational platform
- Developer documentation for accessible educational component creation

**Accessibility Documentation Implementation**:
```markdown
# NeuroVis Educational Platform Accessibility Guidelines

## Accessible Educational Content Creation

### Anatomical Information Accessibility
1. **Alternative Text for 3D Models**
   - Provide comprehensive descriptions of anatomical structures
   - Include spatial relationships and clinical significance
   - Use progressive disclosure for complex anatomical systems

2. **Educational Video Accessibility**
   - Captions for all educational video content
   - Audio descriptions for visual anatomical demonstrations
   - Transcript availability for all educational media

3. **Interactive Content Accessibility**
   - Keyboard alternatives for all mouse-based interactions
   - Clear instructions for assistive technology users
   - Consistent navigation patterns throughout educational workflows

### Medical Terminology Accessibility
1. **Plain Language Explanations**
   - Define medical terms in accessible language
   - Provide pronunciation guides for complex terminology
   - Offer multiple explanation levels for different audiences

2. **Glossary Integration**
   - Accessible glossary with screen reader support
   - Search functionality for terminology lookup
   - Contextual definitions within educational content

## Accessibility Testing Procedures

### Automated Testing Integration
1. **Continuous Accessibility Monitoring**
   - Automated WCAG 2.1 AA validation in CI/CD pipeline
   - Real-time accessibility score tracking
   - Regression prevention for accessibility features

2. **Educational Workflow Testing**
   - Specialized tests for 3D educational interactions
   - Quiz and assessment accessibility validation
   - Progress tracking accessibility verification

### Manual Testing Requirements
1. **Screen Reader Testing**
   - NVDA testing for Windows users
   - JAWS compatibility verification
   - VoiceOver testing for macOS users

2. **Keyboard Navigation Testing**
   - Complete educational workflow keyboard accessibility
   - Focus management in complex 3D interfaces
   - Keyboard shortcut documentation and testing

## Accessibility Feature Implementation

### Screen Reader Support
```gdscript
## AccessibleEducationalComponent.gd
## Base class for accessible educational components

class_name AccessibleEducationalComponent
extends Control

# === ACCESSIBILITY FEATURES ===
@export var aria_label: String = ""
@export var aria_description: String = ""
@export var keyboard_shortcuts: Array[String] = []

func _ready() -> void:
    _setup_accessibility_features()

func _setup_accessibility_features() -> void:
    # Configure ARIA attributes
    if not aria_label.is_empty():
        set_meta("aria-label", aria_label)
    
    if not aria_description.is_empty():
        set_meta("aria-describedby", aria_description)
    
    # Setup keyboard navigation
    _configure_keyboard_navigation()
    
    # Enable screen reader support
    _enable_screen_reader_support()

func _enable_screen_reader_support() -> void:
    # Announce educational content changes
    var live_region = Label.new()
    live_region.name = "educational_announcements"
    live_region.set_meta("aria-live", "polite")
    add_child(live_region)

## Announce educational content to screen readers
## @param message String - Educational information to announce
func announce_educational_content(message: String) -> void:
    var live_region = get_node("educational_announcements")
    if live_region:
        live_region.text = message

## Configure keyboard navigation for educational workflow
func _configure_keyboard_navigation() -> void:
    # Enable focus for keyboard navigation
    focus_mode = Control.FOCUS_ALL
    
    # Setup keyboard shortcuts
    for shortcut in keyboard_shortcuts:
        _register_keyboard_shortcut(shortcut)

func _register_keyboard_shortcut(shortcut: String) -> void:
    # Implementation for educational keyboard shortcuts
    pass
```
```

### Phase 7: Accessibility Compliance Tracking
**Use MCP `sqlite`** to track accessibility compliance metrics:
- Log accessibility test results and improvements
- Track WCAG 2.1 AA compliance scores over time
- Monitor accessibility feature usage and effectiveness
- Store accessibility audit results for regulatory compliance

**Accessibility Compliance Tracking Schema**:
```sql
-- Accessibility compliance tracking database
CREATE TABLE accessibility_test_results (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    test_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    component_name TEXT NOT NULL,
    wcag_criteria TEXT NOT NULL,
    compliance_status TEXT CHECK (compliance_status IN ('pass', 'fail', 'partial')),
    severity_level TEXT CHECK (severity_level IN ('low', 'medium', 'high', 'critical')),
    testing_method TEXT,
    tester_id TEXT,
    remediation_required BOOLEAN DEFAULT FALSE,
    remediation_completed BOOLEAN DEFAULT FALSE
);

CREATE TABLE accessibility_metrics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    measurement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    overall_compliance_score REAL,
    wcag_aa_compliance_percentage REAL,
    educational_accessibility_score REAL,
    screen_reader_compatibility REAL,
    keyboard_navigation_score REAL,
    cognitive_accessibility_score REAL
);

CREATE TABLE accessibility_user_feedback (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    feedback_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_disability_type TEXT,
    assistive_technology_used TEXT,
    educational_context TEXT,
    accessibility_rating INTEGER CHECK (accessibility_rating BETWEEN 1 AND 5),
    feedback_text TEXT,
    improvement_suggestions TEXT
);

-- Insert sample accessibility compliance data
INSERT INTO accessibility_test_results 
(component_name, wcag_criteria, compliance_status, severity_level, testing_method)
VALUES 
('educational_info_panel', '1.4.3', 'pass', 'medium', 'automated_contrast_check'),
('3d_brain_model', '1.1.1', 'fail', 'high', 'screen_reader_test'),
('quiz_component', '3.3.2', 'pass', 'high', 'manual_form_testing'),
('navigation_menu', '2.1.1', 'pass', 'medium', 'keyboard_navigation_test');
```

## Accessibility Compliance Quality Checklist

### WCAG 2.1 AA Standards
- [ ] **Perceivable**: All educational content available through multiple sensory channels
- [ ] **Operable**: All educational interactions accessible via keyboard and assistive technologies
- [ ] **Understandable**: Educational content and navigation clear and predictable
- [ ] **Robust**: Educational platform compatible with current and future assistive technologies

### Educational Accessibility Features
- [ ] **3D Content Accessibility**: Alternative descriptions and keyboard navigation for anatomical models
- [ ] **Medical Terminology Support**: Pronunciation guides and plain language explanations
- [ ] **Progressive Disclosure**: Complex educational content presented in manageable chunks
- [ ] **Customizable Interface**: User preferences for accessibility needs preserved
- [ ] **Multi-modal Learning**: Educational content available through visual, auditory, and tactile channels

### Testing Coverage
- [ ] **Automated Testing**: Comprehensive WCAG validation integrated into development pipeline
- [ ] **Manual Testing**: Screen reader, keyboard navigation, and cognitive accessibility verified
- [ ] **User Testing**: Real users with disabilities validate educational accessibility
- [ ] **Assistive Technology**: Compatibility verified with major accessibility tools
- [ ] **Cross-Platform**: Accessibility consistent across all supported platforms

### Documentation & Training
- [ ] **Accessibility Guidelines**: Clear guidance for educational content creators
- [ ] **Testing Procedures**: Comprehensive accessibility validation processes documented
- [ ] **User Documentation**: Accessibility features clearly explained for all user types
- [ ] **Developer Training**: Team educated on accessible educational design principles
- [ ] **Compliance Tracking**: Regular accessibility audits and improvement planning

## MCP Integration Workflow

```bash
# 1. Initialize accessibility compliance framework
sequential_thinking.think("Design comprehensive accessibility compliance system for educational platform")
memory.create_entities([{
  "name": "AccessibilityCompliance",
  "entityType": "compliance_framework",
  "observations": ["WCAG 2.1 AA standards", "Educational accessibility needs", "Assistive technology support"]
}])

# 2. Automated accessibility testing
playwright.browser_navigate("neurovis://accessibility_test_suite")
playwright.browser_evaluate("runComprehensiveAccessibilityAudit()")
playwright.browser_take_screenshot("accessibility_test_results")

# 3. Manual testing documentation
filesystem.write_file("docs/accessibility/manual_testing_checklist.md", "accessibility_testing_procedures")
filesystem.create_directory("accessibility_reports/")

# 4. Track compliance metrics
sqlite.write_query("INSERT INTO accessibility_test_results ...")
memory.add_observations([{
  "entityName": "AccessibilityPatterns",
  "contents": ["Successful accessibility solutions", "Testing methodologies", "User feedback integration"]
}])

# 5. Generate compliance reports
filesystem.write_file("accessibility_reports/wcag_compliance_report.json", "compliance_data")
sqlite.read_query("SELECT * FROM accessibility_metrics ORDER BY measurement_date DESC LIMIT 10")
```

## Success Criteria

- Comprehensive WCAG 2.1 AA compliance achieved across all educational platform components
- Automated accessibility testing prevents compliance regressions in development pipeline
- Manual accessibility auditing validates real-world usability for diverse learners
- Screen reader compatibility ensures educational content accessible to visually impaired users
- Keyboard navigation provides complete access to all educational workflows
- 3D anatomical content includes meaningful alternatives for non-visual learners
- Educational platform supports wide range of assistive technologies
- Accessibility compliance tracking enables continuous improvement and regulatory compliance