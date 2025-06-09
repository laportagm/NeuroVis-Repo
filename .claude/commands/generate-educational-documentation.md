# Command: Generate Educational Documentation

**Purpose**: Create comprehensive, accessible, and educationally-focused documentation for NeuroVis platform using automated generation, knowledge synthesis, and medical accuracy validation for diverse educational audiences.

**MCPs Used**: `filesystem` (primary), `memory`, `codecmcp`, `sequential-thinking`, `fetch`

## Overview
This command generates complete educational documentation for NeuroVis platform, ensuring medical accuracy, educational effectiveness, and accessibility compliance while serving medical students, healthcare professionals, educators, and developers.

## Educational Documentation Generation Pipeline

### Phase 1: Documentation Architecture & Planning
**Use MCP `sequential-thinking`** to design comprehensive documentation framework:
- Map documentation needs for different educational audiences
- Establish medical accuracy standards for educational content
- Plan accessibility compliance for documentation formats
- Design knowledge organization for optimal learning outcomes

**Educational Documentation Categories**:
- **User Documentation**: Medical students, healthcare professionals, educators
- **Technical Documentation**: Developers, system administrators, technical support
- **Educational Guides**: Learning objectives, assessment integration, curriculum alignment
- **Medical Reference**: Anatomical accuracy, clinical relevance, pathology information
- **Accessibility Documentation**: Inclusive design, assistive technology support

**Use MCP `memory`** to:
- Store documentation structure and relationships
- Track educational content organization patterns
- Maintain medical terminology and accuracy standards
- Create knowledge graphs for documentation navigation

### Phase 2: Automated Documentation Generation
**Use MCP `codecmcp`** to generate technical documentation from codebase:
- Extract educational component documentation from GDScript classes
- Generate API documentation for NeuroVis autoload services
- Create code examples for educational feature implementation
- Generate technical integration guides for educational workflows

**Code Documentation Generation Implementation**:
```python
# Educational Documentation Generator
import ast
import re
from typing import Dict, List, Any

class NeuroVisEducationalDocGenerator:
    def __init__(self, codebase_path: str):
        self.codebase_path = codebase_path
        self.educational_components = {}
        self.medical_accuracy_notes = {}
        self.accessibility_features = {}

    def generate_comprehensive_documentation(self) -> Dict[str, Any]:
        """Generate complete educational documentation from NeuroVis codebase"""
        documentation = {
            "educational_components": self.extract_educational_components(),
            "medical_accuracy_validation": self.extract_medical_validation(),
            "accessibility_features": self.extract_accessibility_features(),
            "learning_objectives": self.extract_learning_objectives(),
            "api_reference": self.generate_api_reference(),
            "integration_guides": self.generate_integration_guides()
        }

        return documentation

    def extract_educational_components(self) -> Dict[str, Any]:
        """Extract educational component documentation with learning context"""
        components = {}

        # Scan for educational GDScript files
        educational_files = self.find_educational_files()

        for file_path in educational_files:
            component_info = self.parse_educational_component(file_path)
            if component_info:
                components[component_info['name']] = component_info

        return components

    def parse_educational_component(self, file_path: str) -> Dict[str, Any]:
        """Parse GDScript file for educational documentation"""
        with open(file_path, 'r') as f:
            content = f.read()

        # Extract class documentation
        class_doc = self.extract_class_documentation(content)

        # Extract educational metadata
        educational_metadata = self.extract_educational_metadata(content)

        # Extract learning objectives
        learning_objectives = self.extract_file_learning_objectives(content)

        # Extract accessibility features
        accessibility_info = self.extract_file_accessibility_features(content)

        return {
            "name": self.extract_class_name(content),
            "file_path": file_path,
            "class_documentation": class_doc,
            "educational_purpose": educational_metadata.get("purpose", ""),
            "clinical_relevance": educational_metadata.get("clinical_relevance", ""),
            "target_audience": educational_metadata.get("target_audience", ""),
            "learning_objectives": learning_objectives,
            "accessibility_features": accessibility_info,
            "api_methods": self.extract_public_methods(content),
            "signals": self.extract_signals(content),
            "educational_examples": self.extract_educational_examples(content)
        }

    def extract_educational_metadata(self, content: str) -> Dict[str, str]:
        """Extract educational metadata from GDScript comments"""
        metadata = {}

        # Pattern for educational metadata comments
        patterns = {
            "purpose": r"##\s*Educational purpose:\s*(.+)",
            "clinical_relevance": r"##\s*Clinical relevance:\s*(.+)",
            "target_audience": r"##\s*Target audience:\s*(.+)",
            "educational_level": r"##\s*Educational level:\s*(.+)",
            "accessibility": r"##\s*Accessibility:\s*(.+)"
        }

        for key, pattern in patterns.items():
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                metadata[key] = match.group(1).strip()

        return metadata

    def generate_api_reference(self) -> Dict[str, Any]:
        """Generate API reference for NeuroVis educational services"""
        api_docs = {}

        # Document autoload services
        autoload_services = [
            "KnowledgeService",
            "AIAssistant",
            "UIThemeManager",
            "StructureAnalysisManager",
            "DebugCmd"
        ]

        for service in autoload_services:
            service_file = self.find_service_file(service)
            if service_file:
                api_docs[service] = self.generate_service_documentation(service_file)

        return api_docs

    def generate_service_documentation(self, file_path: str) -> Dict[str, Any]:
        """Generate documentation for specific NeuroVis service"""
        with open(file_path, 'r') as f:
            content = f.read()

        return {
            "service_description": self.extract_class_documentation(content),
            "educational_purpose": self.extract_educational_metadata(content).get("purpose", ""),
            "public_methods": self.extract_documented_methods(content),
            "signals": self.extract_documented_signals(content),
            "usage_examples": self.extract_usage_examples(content),
            "educational_integration": self.extract_educational_integration_notes(content)
        }
```

### Phase 3: Educational Content Synthesis
**Use MCP `memory`** to synthesize educational knowledge:
- Integrate anatomical knowledge base with documentation
- Create learning pathway documentation from knowledge relationships
- Generate educational workflow guides from component interactions
- Synthesize medical accuracy validation documentation

**Educational Content Synthesis**:
```bash
# Synthesize educational content from knowledge graph
memory.search_nodes("educational_components")
memory.open_nodes(["BrainStructureSelectionManager", "EducationalInfoPanel", "KnowledgeService"])

# Create comprehensive educational documentation
memory.create_entities([
  {
    "name": "EducationalDocumentationFramework",
    "entityType": "documentation_system",
    "observations": [
      "Comprehensive user guides for medical education",
      "Technical documentation for educational feature development",
      "Accessibility documentation for inclusive learning",
      "Medical accuracy validation procedures"
    ]
  }
])

# Establish documentation relationships
memory.create_relations([
  {
    "from": "EducationalDocumentationFramework",
    "to": "MedicalEducationStandards",
    "relationType": "complies_with"
  },
  {
    "from": "UserDocumentation",
    "to": "AccessibilityStandards",
    "relationType": "implements"
  }
])
```

### Phase 4: Medical Accuracy Documentation
**Use MCP `fetch`** to validate and enhance medical documentation:
- Cross-reference anatomical information with medical databases
- Validate clinical terminology and definitions
- Update pathology information with current medical knowledge
- Ensure medical education standard compliance

**Medical Documentation Validation**:
```bash
# Validate anatomical terminology in documentation
fetch("https://www.ncbi.nlm.nih.gov/mesh/", {
  "query": "hippocampus anatomical documentation validation",
  "validation_type": "medical_terminology"
})

# Cross-reference clinical information
fetch("https://www.who.int/classifications/icd/browse/", {
  "query": "neurological pathology documentation accuracy",
  "validation_type": "clinical_accuracy"
})

# Verify educational medical standards
fetch("https://www.lcme.org/standards/", {
  "query": "medical education curriculum standards",
  "validation_type": "educational_compliance"
})
```

### Phase 5: Accessibility Documentation Generation
**Use MCP `filesystem`** to create comprehensive accessibility documentation:
- Generate accessibility feature documentation
- Create inclusive design guidelines for educational content
- Document assistive technology compatibility
- Provide accessibility testing procedures

**Accessibility Documentation Implementation**:
```markdown
# NeuroVis Educational Platform Accessibility Documentation

## Overview
The NeuroVis educational platform is designed with accessibility as a core principle, ensuring that all medical students and healthcare professionals can effectively use the platform regardless of disability status.

## Accessibility Features

### Screen Reader Support
The NeuroVis platform provides comprehensive screen reader support for all educational content:

#### Anatomical 3D Model Accessibility
- **Alternative Descriptions**: Every 3D brain model includes detailed textual descriptions
- **Spatial Relationships**: Screen readers announce anatomical spatial relationships
- **Progressive Disclosure**: Complex anatomical information revealed in manageable chunks
- **Navigation Cues**: Clear audio navigation cues for 3D exploration

#### Educational Content Accessibility
- **Semantic Markup**: All educational content uses proper HTML semantic structure
- **ARIA Labels**: Interactive elements include appropriate ARIA labels and descriptions
- **Live Regions**: Dynamic content updates announced to screen readers
- **Keyboard Navigation**: All educational workflows accessible via keyboard

### Keyboard Navigation
Complete keyboard accessibility for all educational features:

#### 3D Model Navigation
- **Tab Navigation**: Sequential navigation through anatomical structures
- **Arrow Keys**: Spatial navigation within 3D models
- **Enter/Space**: Selection and activation of anatomical structures
- **Escape**: Return to main navigation from detailed views

#### Educational Workflows
- **Quiz Navigation**: Complete keyboard access for assessments
- **Progress Tracking**: Keyboard accessible learning progress review
- **Content Search**: Keyboard-driven search through anatomical knowledge
- **Help Access**: Context-sensitive help via keyboard shortcuts

### Visual Accessibility
Support for users with visual impairments:

#### High Contrast Mode
- **Enhanced Theme**: High contrast educational interface option
- **Color Independence**: Information not dependent on color alone
- **Text Scaling**: Support for large text display preferences
- **Focus Indicators**: Clear visual focus indicators for interactive elements

#### Color Vision Accessibility
- **Color Blind Support**: Educational content accessible without color dependency
- **Pattern Alternatives**: Visual patterns supplement color coding
- **Contrast Validation**: All text meets WCAG 2.1 AA contrast requirements

### Motor Accessibility
Accommodations for users with motor impairments:

#### Alternative Interaction Methods
- **Large Click Targets**: Educational buttons meet 44px minimum size requirement
- **Sticky Keys Support**: Complex keyboard combinations work with accessibility tools
- **Timeout Extensions**: Adequate time limits for educational activities
- **Hover Alternatives**: Important information not dependent on mouse hover

### Cognitive Accessibility
Support for diverse learning needs:

#### Content Clarity
- **Plain Language**: Medical terminology explained in accessible language
- **Consistent Navigation**: Predictable educational interface patterns
- **Progressive Disclosure**: Complex information revealed gradually
- **Memory Aids**: Educational bookmarks and progress saving

#### Error Prevention and Recovery
- **Clear Error Messages**: Specific guidance for resolving educational workflow errors
- **Confirmation Dialogs**: Important actions require confirmation
- **Undo Functionality**: Ability to reverse educational workflow actions
- **Help Documentation**: Context-sensitive help for educational features

## Implementation Guidelines

### For Content Creators
1. **Alternative Text**: Provide meaningful alternative text for all visual educational content
2. **Heading Structure**: Use proper heading hierarchy (h1, h2, h3) for educational content
3. **Link Text**: Write descriptive link text that explains educational destinations
4. **Form Labels**: Label all educational form controls clearly and descriptively

### For Developers
1. **ARIA Implementation**: Use ARIA attributes appropriately for complex educational interfaces
2. **Focus Management**: Implement proper focus management for educational workflows
3. **Keyboard Support**: Ensure all mouse interactions have keyboard alternatives
4. **Testing**: Regular accessibility testing with automated tools and manual verification

## Testing Procedures

### Automated Testing
- **WCAG 2.1 AA Validation**: Continuous accessibility compliance monitoring
- **Screen Reader Testing**: Automated verification of screen reader compatibility
- **Keyboard Navigation**: Automated testing of keyboard accessibility
- **Color Contrast**: Automated validation of contrast ratios

### Manual Testing
- **Screen Reader Verification**: Manual testing with NVDA, JAWS, and VoiceOver
- **Keyboard-Only Navigation**: Complete educational workflow testing without mouse
- **Cognitive Load Assessment**: Evaluation of educational content clarity
- **User Testing**: Regular testing with users who have disabilities

## Compliance Standards
The NeuroVis educational platform meets or exceeds:
- **WCAG 2.1 AA**: Web Content Accessibility Guidelines Level AA
- **Section 508**: U.S. federal accessibility requirements
- **AODA**: Accessibility for Ontarians with Disabilities Act
- **EN 301 549**: European accessibility standard
```

### Phase 6: Technical Integration Documentation
**Use MCP `codecmcp`** to generate technical integration guides:
- Create developer documentation for educational feature implementation
- Generate API integration examples for educational workflows
- Document technical architecture for educational platform components
- Provide troubleshooting guides for educational development

**Technical Documentation Generation**:
```gdscript
# Auto-generated technical documentation example

## KnowledgeService API Reference
### Educational Content Management System

The KnowledgeService provides comprehensive anatomical knowledge management for the NeuroVis educational platform.

#### Class: KnowledgeService
**Extends**: Node (Autoload)
**Purpose**: Manages anatomical knowledge base with educational metadata and medical accuracy validation

##### Public Methods

###### get_structure(structure_id: String) -> Dictionary
**Educational Purpose**: Retrieve comprehensive anatomical structure data for educational display
**Parameters**:
- `structure_id` (String): Anatomical structure identifier (e.g., "hippocampus", "cortex")
**Returns**: Dictionary containing educational structure data with medical accuracy validation
**Example**:
```gdscript
var hippocampus_data = KnowledgeService.get_structure("hippocampus")
if not hippocampus_data.is_empty():
    print("Educational Description: " + hippocampus_data.shortDescription)
    print("Clinical Relevance: " + hippocampus_data.clinicalRelevance)
    print("Learning Objectives: " + str(hippocampus_data.learningObjectives))
```

###### search_structures(search_term: String) -> Array
**Educational Purpose**: Search anatomical knowledge base for educational content discovery
**Parameters**:
- `search_term` (String): Search query for anatomical structures or functions
**Returns**: Array of matching structures with educational metadata
**Example**:
```gdscript
var memory_structures = KnowledgeService.search_structures("memory")
for structure in memory_structures:
    print("Structure: " + structure.displayName)
    print("Memory Function: " + structure.memoryFunction)
```

##### Signals

###### structure_data_updated(structure_id: String, updated_data: Dictionary)
**Educational Context**: Emitted when anatomical structure data is updated with new educational content
**Parameters**:
- `structure_id` (String): Identifier of updated structure
- `updated_data` (Dictionary): New educational data with medical validation

##### Integration with Educational Workflows
The KnowledgeService integrates with:
- **BrainStructureSelectionManager**: Provides anatomical data for selected structures
- **EducationalInfoPanel**: Supplies content for educational information display
- **AIAssistant**: Offers contextual anatomical knowledge for AI responses
- **AccessibilityManager**: Ensures educational content is accessible to all learners

##### Medical Accuracy Validation
All content served by KnowledgeService undergoes:
- Medical expert review for anatomical accuracy
- Clinical relevance validation by healthcare professionals
- Regular updates based on current medical research
- Compliance with medical education standards
```

### Phase 7: Multi-Format Documentation Generation
**Use MCP `filesystem`** to generate documentation in multiple accessible formats:
- HTML documentation with semantic markup and ARIA support
- PDF documentation with accessibility tags and bookmarks
- Markdown documentation for technical collaboration
- Interactive help system integration

**Multi-Format Documentation Implementation**:
```python
# Multi-format documentation generator
class MultiFormatDocumentationGenerator:
    def __init__(self, source_docs: Dict[str, Any]):
        self.source_docs = source_docs
        self.output_formats = ['html', 'pdf', 'markdown', 'interactive']

    def generate_all_formats(self) -> Dict[str, str]:
        """Generate documentation in all supported formats"""
        generated_docs = {}

        for format_type in self.output_formats:
            generated_docs[format_type] = self.generate_format(format_type)

        return generated_docs

    def generate_html_documentation(self) -> str:
        """Generate accessible HTML documentation"""
        html_template = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NeuroVis Educational Platform Documentation</title>
    <link rel="stylesheet" href="educational-docs.css">
</head>
<body>
    <nav aria-label="Documentation navigation">
        <h2>Table of Contents</h2>
        <ul>
            <li><a href="#overview">Platform Overview</a></li>
            <li><a href="#educational-features">Educational Features</a></li>
            <li><a href="#accessibility">Accessibility Support</a></li>
            <li><a href="#medical-accuracy">Medical Accuracy</a></li>
            <li><a href="#technical-reference">Technical Reference</a></li>
        </ul>
    </nav>

    <main>
        <section id="overview" aria-labelledby="overview-heading">
            <h1 id="overview-heading">NeuroVis Educational Platform</h1>
            <p>Comprehensive neuroanatomy education through interactive 3D visualization</p>
            <!-- Generated content inserted here -->
        </section>

        <section id="educational-features" aria-labelledby="features-heading">
            <h2 id="features-heading">Educational Features</h2>
            <!-- Educational feature documentation -->
        </section>

        <section id="accessibility" aria-labelledby="accessibility-heading">
            <h2 id="accessibility-heading">Accessibility Support</h2>
            <!-- Accessibility documentation -->
        </section>
    </main>

    <script src="educational-docs.js"></script>
</body>
</html>
        """
        return html_template

    def generate_pdf_documentation(self) -> str:
        """Generate accessible PDF with proper tagging"""
        # PDF generation with accessibility tags
        pass

    def generate_interactive_help(self) -> str:
        """Generate interactive help system integration"""
        # Interactive help system content
        pass
```

## Educational Documentation Quality Checklist

### Content Quality Standards
- [ ] **Medical Accuracy**: All anatomical and clinical information validated by medical experts
- [ ] **Educational Effectiveness**: Content supports clear learning objectives and outcomes
- [ ] **Accessibility Compliance**: Documentation meets WCAG 2.1 AA standards
- [ ] **Multi-Audience Support**: Content appropriate for students, professionals, and educators
- [ ] **Currency Maintenance**: Regular updates ensure medical information remains current

### Technical Documentation Standards
- [ ] **API Completeness**: All public methods and services documented with examples
- [ ] **Integration Guides**: Clear instructions for educational feature implementation
- [ ] **Code Examples**: Working examples for all educational development patterns
- [ ] **Troubleshooting**: Comprehensive problem resolution guides
- [ ] **Architecture Documentation**: Clear explanation of educational platform structure

### Accessibility Documentation Standards
- [ ] **Feature Coverage**: All accessibility features clearly documented
- [ ] **Testing Procedures**: Complete accessibility validation procedures provided
- [ ] **User Guidance**: Clear instructions for using accessibility features
- [ ] **Developer Guidelines**: Accessibility implementation standards for developers
- [ ] **Compliance Verification**: Regular accessibility audit procedures documented

### Educational Effectiveness Standards
- [ ] **Learning Objective Alignment**: Documentation supports educational goals
- [ ] **Progressive Complexity**: Information structured for different expertise levels
- [ ] **Clinical Context**: Medical relevance clearly explained throughout
- [ ] **Assessment Integration**: Documentation supports educational assessment
- [ ] **Curriculum Alignment**: Content aligns with medical education standards

## MCP Integration Workflow

```bash
# 1. Initialize documentation generation
sequential_thinking.think("Design comprehensive educational documentation framework")
memory.create_entities([{
  "name": "EducationalDocumentationSystem",
  "entityType": "documentation_framework",
  "observations": ["Multi-audience content", "Medical accuracy standards", "Accessibility compliance", "Technical integration"]
}])

# 2. Generate technical documentation
codecmcp.claude_code("Generate API documentation for NeuroVis educational services", "docs/")
filesystem.search_files("core/", "*.gd")  # Find educational components

# 3. Synthesize educational content
memory.search_nodes("educational_knowledge")
memory.add_observations([{
  "entityName": "DocumentationPatterns",
  "contents": ["User guide structures", "Technical reference formats", "Accessibility documentation standards"]
}])

# 4. Validate medical accuracy
fetch("https://www.ncbi.nlm.nih.gov/mesh/", "validate_anatomical_documentation")
fetch("https://www.lcme.org/standards/", "verify_medical_education_compliance")

# 5. Generate multi-format output
filesystem.write_file("docs/user-guide/educational-platform-guide.html", "accessible_html_documentation")
filesystem.write_file("docs/technical/api-reference.md", "technical_documentation")
filesystem.create_directory("docs/accessibility/")
```

## Success Criteria

- Comprehensive documentation serves all educational audiences (students, professionals, educators, developers)
- Medical accuracy validated through expert review and authoritative source cross-referencing
- Accessibility compliance ensures documentation usable by all learners regardless of disability
- Technical documentation enables efficient educational feature development
- Multi-format generation provides documentation in accessible and preferred formats
- Educational effectiveness supported through clear learning objectives and assessment integration
- Regular documentation updates maintain currency with medical knowledge and platform evolution
- User feedback integration continuously improves documentation quality and effectiveness
