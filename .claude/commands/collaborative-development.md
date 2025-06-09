# Command: Collaborative Development

**Purpose**: Facilitate effective collaborative development for NeuroVis educational platform through GitHub integration, team knowledge management, and structured educational review processes ensuring medical accuracy and pedagogical excellence.

**MCPs Used**: `github` (primary), `filesystem`, `memory`, `sequential-thinking`, `sqlite`

## Overview
This command establishes comprehensive collaborative development workflows for NeuroVis educational platform, integrating medical expertise, educational design, and software development while maintaining strict standards for medical accuracy and educational effectiveness.

## Collaborative Development Pipeline

### Phase 1: Team Structure & Role Definition
**Use MCP `sequential-thinking`** to establish collaborative framework:
- Define roles for medical experts, educational designers, and developers
- Establish review processes for different types of content and code
- Create approval workflows for medical accuracy and educational effectiveness
- Plan integration between technical development and educational content creation

**Educational Development Team Roles**:
- **Medical Content Reviewers**: Neuroanatomists, neurologists, medical educators
- **Educational Designers**: Learning experience designers, accessibility specialists
- **Technical Developers**: GDScript developers, 3D artists, UI/UX designers
- **Quality Assurance**: Testing specialists, accessibility auditors
- **Project Coordinators**: Development managers, educational program coordinators

**Use MCP `memory`** to:
- Store team member profiles and expertise areas
- Track review assignments and specialization mapping
- Maintain educational project context and requirements
- Create relationships between team roles and project components

### Phase 2: GitHub Repository Organization
**Use MCP `github`** to establish repository structure:
- Configure branch protection rules for medical content
- Set up review requirements for educational components
- Create issue templates for different types of educational development
- Establish pull request templates with educational validation checklists

**GitHub Repository Configuration**:
```bash
# Create educational development branches
github.create_branch("main", "educational-content-development")
github.create_branch("main", "medical-accuracy-review")
github.create_branch("main", "accessibility-enhancement")
github.create_branch("main", "3d-model-integration")

# Configure branch protection for medical content
github.update_branch_protection("main", {
  "required_reviews": 2,
  "medical_expert_review_required": true,
  "educational_designer_approval": true,
  "accessibility_compliance_check": true
})
```

**Use MCP `filesystem`** to create collaborative templates:
```markdown
# .github/pull_request_template.md
## Educational Development Pull Request

### Educational Context
- [ ] **Learning Objectives**: Clearly defined educational goals
- [ ] **Target Audience**: Medical students/Researchers/Healthcare professionals
- [ ] **Educational Level**: Beginner/Intermediate/Advanced
- [ ] **Clinical Relevance**: Medical significance documented

### Medical Accuracy Review
- [ ] **Anatomical Accuracy**: Structures and relationships verified
- [ ] **Clinical Information**: Pathology and treatment data validated
- [ ] **Terminology**: Standard medical nomenclature used
- [ ] **Research Currency**: Current medical knowledge incorporated

### Technical Quality
- [ ] **Code Quality**: Follows NeuroVis GDScript standards
- [ ] **Performance**: Maintains 60fps educational interactions
- [ ] **Integration**: Compatible with existing autoload services
- [ ] **Testing**: Educational workflows validated

### Accessibility Compliance
- [ ] **WCAG 2.1 AA**: Accessibility standards met
- [ ] **Screen Reader**: Compatible with assistive technologies
- [ ] **Keyboard Navigation**: Full keyboard accessibility
- [ ] **Visual Design**: High contrast and readable fonts

### Review Assignments
- **Medical Expert Review**: @neuroanatomist @neurologist
- **Educational Design**: @learning-designer @accessibility-specialist
- **Technical Review**: @gdscript-developer @3d-specialist
- **Quality Assurance**: @qa-tester @accessibility-auditor

### Educational Impact Assessment
Describe how this change enhances learning outcomes for medical education:

### Medical Accuracy Validation
Detail medical sources and expert review process:

### Accessibility Considerations
Explain accessibility features and inclusive design choices:
```

### Phase 3: Educational Content Collaboration
**Use MCP `memory`** to manage educational content development:
- Track educational content creation and review status
- Store expert reviewer feedback and recommendations
- Maintain educational content relationships and dependencies
- Create knowledge graphs for anatomical concept connections

**Educational Content Workflow**:
```bash
# Create educational content entities
memory.create_entities([
  {
    "name": "HippocampusEducationalModule",
    "entityType": "educational_content",
    "observations": [
      "Target: Medical students learning memory systems",
      "Content: 3D visualization with clinical cases",
      "Reviewer: Dr. Sarah Chen (Neuroanatomist)",
      "Status: Medical accuracy review in progress"
    ]
  },
  {
    "name": "MemoryPathwayLearningObjectives",
    "entityType": "learning_design",
    "observations": [
      "Level: Intermediate medical education",
      "Objectives: Identify, understand, apply memory concepts",
      "Assessment: Interactive quiz with clinical scenarios",
      "Designer: Prof. Michael Torres (Educational Technology)"
    ]
  }
])

# Establish content relationships
memory.create_relations([
  {
    "from": "HippocampusEducationalModule",
    "to": "MemoryPathwayLearningObjectives",
    "relationType": "supports_learning_objective"
  },
  {
    "from": "HippocampusEducationalModule",
    "to": "ClinicalMemoryDisorders",
    "relationType": "provides_clinical_context"
  }
])
```

### Phase 4: Medical Expert Review Integration
**Use MCP `github`** to implement expert review workflow:
- Create specialized review assignments for medical content
- Establish expert approval requirements for anatomical accuracy
- Configure automated notifications for medical content changes
- Implement review tracking for regulatory compliance

**Medical Review Workflow Implementation**:
```bash
# Create medical review issue template
github.create_issue("NeuroVis-Educational-Platform", {
  "title": "Medical Accuracy Review: Hippocampus Educational Module",
  "body": "## Medical Content Review Request\n\n**Content Type**: Educational anatomical module\n**Structure**: Hippocampus\n**Educational Level**: Intermediate\n**Clinical Context**: Memory disorders and neurodegeneration\n\n### Review Criteria\n- [ ] Anatomical structure accuracy\n- [ ] Spatial relationship validation\n- [ ] Clinical information verification\n- [ ] Pathology description accuracy\n- [ ] Treatment information currency\n\n### Expert Assignments\n- **Neuroanatomist**: @dr-sarah-chen\n- **Neurologist**: @dr-james-rodriguez  \n- **Medical Educator**: @prof-maria-williams\n\n### Validation Sources\n- Gray's Anatomy (Latest Edition)\n- Netter's Atlas of Human Anatomy\n- Current neuroanatomy research (PubMed)\n- WHO International Classification of Diseases\n\n### Approval Requirements\nAll assigned medical experts must approve before educational deployment.",
  "labels": ["medical-review", "educational-content", "high-priority"],
  "assignees": ["dr-sarah-chen", "dr-james-rodriguez", "prof-maria-williams"]
})

# Track review progress
github.add_issue_comment("issue_number", {
  "body": "## Medical Review Update\n\n**Neuroanatomist Review**: ✅ Approved with minor terminology updates\n**Neurologist Review**: 🔄 In progress - reviewing clinical correlations\n**Medical Educator Review**: ⏳ Pending assignment\n\n**Next Steps**: Address terminology updates and await neurologist approval."
})
```

### Phase 5: Educational Design Collaboration
**Use MCP `sqlite`** to track educational design decisions:
- Log learning objective development and validation
- Store accessibility design choices and rationale
- Track user experience testing results for educational effectiveness
- Maintain educational assessment integration planning

**Educational Design Tracking**:
```sql
-- Educational design collaboration schema
CREATE TABLE educational_design_decisions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content_module TEXT NOT NULL,
    design_decision TEXT NOT NULL,
    educational_rationale TEXT,
    accessibility_impact TEXT,
    learning_outcome_supported TEXT,
    designer_id TEXT,
    approval_status TEXT DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accessibility_review_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    component_name TEXT NOT NULL,
    wcag_criteria TEXT,
    compliance_status TEXT,
    testing_method TEXT,
    reviewer_id TEXT,
    recommendations TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE learning_outcome_validation (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    module_id TEXT,
    learning_objective TEXT,
    assessment_method TEXT,
    validation_results TEXT,
    effectiveness_score REAL,
    validator_id TEXT,
    validation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert educational design decisions
INSERT INTO educational_design_decisions
(content_module, design_decision, educational_rationale, accessibility_impact, designer_id)
VALUES
('hippocampus_module', 'Interactive 3D rotation with guided highlights',
 'Spatial understanding enhanced through kinesthetic interaction',
 'Keyboard navigation alternative provided for motor accessibility',
 'prof_maria_williams'),
('memory_pathway_quiz', 'Progressive disclosure of clinical scenarios',
 'Scaffolded learning reduces cognitive load for complex cases',
 'Screen reader compatible with clear content structure',
 'dr_accessibility_specialist');
```

### Phase 6: Technical Development Coordination
**Use MCP `filesystem`** to coordinate technical implementation:
- Manage educational component development across team members
- Coordinate integration between 3D models and educational content
- Organize code reviews for educational feature development
- Maintain technical documentation for educational platform architecture

**Technical Coordination Implementation**:
```gdscript
## CollaborativeDevelopmentCoordinator.gd
## Coordinates technical development for educational features

class_name CollaborativeDevelopmentCoordinator
extends Node

# === DEVELOPMENT COORDINATION ===
signal development_milestone_reached(milestone: String, team_members: Array)
signal review_required(component: String, review_type: String, assignees: Array)

# === TEAM COORDINATION ===
var _team_assignments: Dictionary = {}
var _component_dependencies: Dictionary = {}
var _review_requirements: Dictionary = {}

func _ready() -> void:
    _initialize_team_structure()
    _setup_component_dependencies()

## Assign educational component development to team members
## @param component_name String - Educational component identifier
## @param team_assignments Dictionary - Team member assignments by role
func assign_educational_component_development(component_name: String, team_assignments: Dictionary) -> void:
    _team_assignments[component_name] = {
        "medical_expert": team_assignments.get("medical_expert", ""),
        "educational_designer": team_assignments.get("educational_designer", ""),
        "technical_developer": team_assignments.get("technical_developer", ""),
        "accessibility_specialist": team_assignments.get("accessibility_specialist", ""),
        "assignment_date": Time.get_datetime_string_from_system()
    }

    # Create GitHub issue for component development
    _create_development_issue(component_name, team_assignments)

## Coordinate review process for educational content
## @param component String - Component requiring review
## @param review_type String - Type of review needed
func initiate_educational_review(component: String, review_type: String) -> void:
    var reviewers: Array = _get_required_reviewers(review_type)

    review_required.emit(component, review_type, reviewers)

    # Update component status
    _update_component_status(component, "under_review")

    # Notify assigned reviewers
    _notify_reviewers(component, review_type, reviewers)

func _get_required_reviewers(review_type: String) -> Array:
    match review_type:
        "medical_accuracy":
            return ["neuroanatomist", "neurologist", "medical_educator"]
        "educational_effectiveness":
            return ["learning_designer", "accessibility_specialist", "educational_assessment"]
        "technical_quality":
            return ["gdscript_reviewer", "3d_specialist", "performance_tester"]
        "accessibility_compliance":
            return ["accessibility_auditor", "screen_reader_tester", "keyboard_navigation_specialist"]
        _:
            return []

## Track development progress and dependencies
## @param component String - Component identifier
## @param progress_update Dictionary - Progress information
func update_development_progress(component: String, progress_update: Dictionary) -> void:
    var current_progress = _team_assignments.get(component, {})
    current_progress["progress"] = progress_update
    current_progress["last_updated"] = Time.get_datetime_string_from_system()

    # Check if milestone reached
    if progress_update.get("milestone_completed", false):
        var milestone = progress_update.get("milestone_name", "unknown")
        var team_members = _get_component_team_members(component)
        development_milestone_reached.emit(milestone, team_members)

    # Check dependencies
    _check_component_dependencies(component)

func _check_component_dependencies(component: String) -> void:
    var dependencies = _component_dependencies.get(component, [])

    for dependency in dependencies:
        var dep_status = _get_component_status(dependency)
        if dep_status != "completed":
            print("[DevCoordinator] Dependency not met: %s requires %s" % [component, dependency])
```

### Phase 7: Quality Assurance & Integration
**Use MCP `github`** to implement comprehensive QA workflow:
- Automate educational workflow testing on pull requests
- Integrate accessibility testing with development pipeline
- Coordinate medical accuracy validation with code changes
- Establish deployment approval process for educational content

**QA Integration Workflow**:
```bash
# Create comprehensive QA pull request review
github.create_pull_request_review("NeuroVis-Educational-Platform", 123, {
  "body": "## Educational Quality Assurance Review\n\n### Technical Quality ✅\n- GDScript standards compliance verified\n- Performance targets met (60fps maintained)\n- Memory usage within educational platform limits\n- Integration with NeuroVis autoloads successful\n\n### Educational Effectiveness ✅\n- Learning objectives clearly defined and measurable\n- Educational content appropriate for target audience\n- Assessment integration planned and validated\n- Progressive difficulty levels implemented\n\n### Medical Accuracy ✅\n- Anatomical terminology verified against medical standards\n- Clinical information cross-referenced with authoritative sources\n- Pathology descriptions reviewed by medical experts\n- Treatment information current and evidence-based\n\n### Accessibility Compliance ✅\n- WCAG 2.1 AA standards met\n- Screen reader compatibility validated\n- Keyboard navigation fully functional\n- Visual contrast ratios exceed minimum requirements\n\n**Approval**: Educational component ready for deployment",
  "event": "APPROVE"
})

# Track QA metrics
github.create_issue("NeuroVis-Educational-Platform", {
  "title": "Educational QA Metrics - Sprint 15",
  "body": "## Quality Assurance Summary\n\n### Educational Components Reviewed: 12\n- Medical accuracy validation: 100% passed\n- Educational effectiveness: 11/12 approved (1 pending)\n- Accessibility compliance: 100% WCAG 2.1 AA\n- Technical quality: 100% GDScript standards\n\n### Review Team Performance\n- Average medical review time: 2.3 days\n- Educational design review time: 1.8 days  \n- Technical review time: 1.2 days\n- Accessibility audit time: 1.5 days\n\n### Recommendations for Next Sprint\n- Expand medical expert reviewer pool\n- Implement automated accessibility testing\n- Enhance educational effectiveness metrics",
  "labels": ["qa-summary", "educational-metrics"]
})
```

### Phase 8: Knowledge Transfer & Documentation
**Use MCP `memory`** to maintain collaborative knowledge:
- Store team knowledge and best practices
- Track successful collaboration patterns
- Maintain educational development guidelines
- Create relationships between team expertise and project outcomes

**Use MCP `filesystem`** to maintain comprehensive documentation:
- Educational development guidelines and standards
- Medical review processes and criteria
- Accessibility compliance procedures
- Technical integration patterns for educational features

## Collaborative Development Quality Checklist

### Team Coordination
- [ ] Medical experts assigned to all anatomical content
- [ ] Educational designers involved in learning objective development
- [ ] Accessibility specialists review all user-facing components
- [ ] Technical reviewers validate GDScript standards and performance
- [ ] Cross-functional communication channels established

### Review Process Standards
- [ ] Medical accuracy review required for all anatomical content
- [ ] Educational effectiveness validation for all learning components
- [ ] Accessibility compliance testing integrated into development pipeline
- [ ] Technical quality review follows NeuroVis coding standards
- [ ] Multi-disciplinary approval process implemented

### Documentation & Knowledge Management
- [ ] Educational development guidelines accessible to all team members
- [ ] Medical review criteria clearly documented and standardized
- [ ] Accessibility standards and testing procedures established
- [ ] Technical integration patterns documented for educational features
- [ ] Collaborative knowledge continuously updated and maintained

### Quality Assurance Integration
- [ ] Automated testing validates educational workflow functionality
- [ ] Performance monitoring ensures 60fps educational interactions
- [ ] Medical accuracy validation integrated with content changes
- [ ] Accessibility testing prevents compliance regressions
- [ ] Educational effectiveness metrics tracked and improved

## MCP Integration Workflow

```bash
# 1. Initialize collaborative development
sequential_thinking.think("Design collaborative development workflow for educational platform")
memory.create_entities([{
  "name": "EducationalTeamCollaboration",
  "entityType": "development_workflow",
  "observations": ["Team roles", "Review processes", "Quality standards", "Educational requirements"]
}])

# 2. GitHub repository configuration
github.create_branch("main", "educational-content-development")
github.create_pull_request("Educational Feature: Memory System Module")
github.create_issue("Medical Accuracy Review: Hippocampus Module")

# 3. Track collaborative activities
sqlite.write_query("INSERT INTO educational_design_decisions ...")
memory.add_observations([{
  "entityName": "CollaborationPatterns",
  "contents": ["Successful review processes", "Team coordination strategies", "Quality outcomes"]
}])

# 4. Maintain development documentation
filesystem.write_file(".github/pull_request_template.md", "educational_pr_template")
filesystem.create_directory("docs/collaboration/")

# 5. Monitor team effectiveness
memory.search_nodes("collaboration effectiveness")
sqlite.read_query("SELECT * FROM educational_design_decisions WHERE approval_status = 'approved'")
```

## Success Criteria

- Multidisciplinary team effectively collaborates on educational content development
- Medical accuracy review process ensures all anatomical content meets professional standards
- Educational design review validates learning effectiveness and accessibility compliance
- Technical development maintains NeuroVis quality standards and performance targets
- GitHub workflow facilitates efficient collaboration while maintaining educational quality
- Knowledge management system preserves team expertise and successful patterns
- Quality assurance process prevents educational and technical regressions
- Documentation supports onboarding and knowledge transfer for educational development
