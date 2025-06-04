## BrainSystemSwitcher.gd
## Educational system for swapping complete brain visualization models
##
## This system manages the educational transition between different brain
## visualization models with educational context and smooth visual transitions.
## It supports whole brain, sectional, and internal structure views with
## appropriate educational guidance during transitions.
##
## @tutorial: educational_brain_system_switching
## @experimental: false

class_name BrainSystemSwitcher
extends Node

# === CONSTANTS ===
const TRANSITION_DURATION_DEFAULT: float = 0.8
const EDUCATIONAL_PAUSE_DURATION: float = 1.5

# === SIGNALS ===
## Emitted when a brain system transition begins
## @param from_system: Name of the source brain system
## @param to_system: Name of the target brain system
signal transition_started(from_system: String, to_system: String)

## Emitted when a brain system transition completes
## @param current_system: Name of the currently active brain system
signal transition_completed(current_system: String)

## Emitted when educational context is available during transition
## @param context: Educational context information about the transition
signal educational_context_available(context: Dictionary)

# === ENUMS ===
enum TransitionStyle {
    FADE,           # Simple fade transition
    EXPLODED_VIEW,  # Exploded view showing component relationships
    EDUCATIONAL     # Detailed educational transition with annotations
}

enum BrainSystem {
    WHOLE_BRAIN,    # Complete brain model
    HALF_SECTIONAL, # Hemispheric section view
    INTERNAL        # Deep brain structures
}

# === EXPORTS ===
## Default transition style for brain system switches
@export var default_transition_style: TransitionStyle = TransitionStyle.EDUCATIONAL

## Duration of transition animations (seconds)
@export var transition_duration: float = TRANSITION_DURATION_DEFAULT

## Whether to show educational context during transitions
@export var show_educational_context: bool = true

## Whether transitions should maintain current selection
@export var maintain_selection: bool = true

@export_group("Educational Features")
## Whether to provide audio narration during transitions
@export var audio_narration: bool = false

## Educational detail level (1-3)
@export_range(1, 3) var educational_detail: int = 2

# === PRIVATE VARIABLES ===
var _current_system: BrainSystem = BrainSystem.WHOLE_BRAIN
var _is_transitioning: bool = false
var _is_initialized: bool = false
var _model_registry: ModelRegistry
var _knowledge_service: Node
var _selection_manager: BrainStructureSelectionManager
var _educational_context: Dictionary = {}
var _current_educational_content: Array = []

# === LIFECYCLE METHODS ===
func _ready() -> void:
    """Initialize the BrainSystemSwitcher component"""
    _initialize()

# === PUBLIC METHODS ===
## Switch to the specified brain system with educational context
## @param target_system: The brain system to switch to
## @param transition_style: Visual style for the transition
## @return: bool - true if transition started successfully
func switch_to_system(target_system: BrainSystem, transition_style: TransitionStyle = -1) -> bool:
    """Switch to the specified brain system with educational context"""
    
    # Validation
    if not _is_initialized:
        push_error("[BrainSystemSwitcher] Not initialized")
        return false
    
    if _is_transitioning:
        push_warning("[BrainSystemSwitcher] Transition already in progress")
        return false
    
    if target_system == _current_system:
        push_warning("[BrainSystemSwitcher] Already in target system: " + str(target_system))
        return true
    
    # Use default transition style if not specified
    if transition_style < 0:
        transition_style = default_transition_style
    
    # Track transition state
    _is_transitioning = true
    
    # Prepare educational context for the transition
    _prepare_educational_context(_current_system, target_system)
    
    # Store current state if maintaining selection
    var current_selection = null
    if maintain_selection and _selection_manager != null:
        current_selection = _selection_manager.get_current_selection()
    
    # Emit start signal
    transition_started.emit(_get_system_name(_current_system), _get_system_name(target_system))
    
    # Perform appropriate transition based on style
    match transition_style:
        TransitionStyle.FADE:
            _perform_fade_transition(target_system)
        TransitionStyle.EXPLODED_VIEW:
            _perform_exploded_transition(target_system)
        TransitionStyle.EDUCATIONAL:
            _perform_educational_transition(target_system)
        _:
            _perform_fade_transition(target_system)
    
    # Update current system tracking
    _current_system = target_system
    
    return true

## Get the currently active brain system
## @return: BrainSystem - the current active system
func get_current_system() -> int:
    """Get the currently active brain system"""
    return _current_system

## Check if a transition is currently in progress
## @return: bool - true if transitioning
func is_transitioning() -> bool:
    """Check if a transition is currently in progress"""
    return _is_transitioning

## Get educational content for the current brain system
## @return: Array of educational content dictionaries
func get_educational_content() -> Array:
    """Get educational content for the current brain system"""
    return _current_educational_content

# === PRIVATE METHODS ===
func _initialize() -> void:
    """Initialize the component with default settings"""
    
    # Setup validation
    if not _validate_setup():
        push_error("[BrainSystemSwitcher] Failed to initialize - invalid setup")
        return
    
    # Initialize subsystems
    _setup_connections()
    _apply_initial_state()
    
    # Load initial educational content
    _update_educational_content()
    
    _is_initialized = true
    print("[BrainSystemSwitcher] Initialized successfully")

func _validate_setup() -> bool:
    """Validate that all required dependencies are available"""
    
    # Get the ModelRegistry reference
    _model_registry = get_node_or_null("/root/ModelRegistry") 
    if _model_registry == null:
        push_error("[BrainSystemSwitcher] ModelRegistry not found")
        return false
    
    # Get the KnowledgeService reference
    _knowledge_service = get_node_or_null("/root/KnowledgeService")
    if _knowledge_service == null:
        push_warning("[BrainSystemSwitcher] KnowledgeService not found - limited educational features")
    
    # Get the BrainStructureSelectionManager reference
    _selection_manager = get_node_or_null("../BrainStructureSelectionManager")
    if _selection_manager == null:
        push_warning("[BrainSystemSwitcher] BrainStructureSelectionManager not found - selection will not persist")
    
    return true

func _setup_connections() -> void:
    """Setup signal connections and dependencies"""
    
    # Connect completion timer
    var transition_timer = Timer.new()
    transition_timer.name = "TransitionTimer"
    transition_timer.one_shot = true
    add_child(transition_timer)
    transition_timer.timeout.connect(_on_transition_completed)

func _apply_initial_state() -> void:
    """Apply initial state and configuration"""
    
    # Determine initial brain system based on loaded models
    if _model_registry.is_model_loaded("Internal_Structures"):
        _current_system = BrainSystem.INTERNAL
    elif _model_registry.is_model_loaded("Half_Brain"):
        _current_system = BrainSystem.HALF_SECTIONAL
    else:
        _current_system = BrainSystem.WHOLE_BRAIN

func _perform_fade_transition(target_system: BrainSystem) -> void:
    """Perform a simple fade transition between brain systems"""
    
    # Hide current model
    _hide_current_system()
    
    # Small delay for visual effect
    await get_tree().create_timer(0.2).timeout
    
    # Show target model
    _show_target_system(target_system)
    
    # Set timer for transition completion
    var timer = get_node("TransitionTimer") as Timer
    timer.wait_time = transition_duration
    timer.start()

func _perform_exploded_transition(target_system: BrainSystem) -> void:
    """Perform an exploded view transition between brain systems"""
    
    # This would animate current system into exploded view
    # Then transition to the new system
    # For now, use fade transition as a fallback
    _perform_fade_transition(target_system)

func _perform_educational_transition(target_system: BrainSystem) -> void:
    """Perform an educational transition with anatomical context"""
    
    # Step 1: Initial fade out
    _hide_current_system()
    await get_tree().create_timer(0.2).timeout
    
    # Step 2: Show educational context if available
    if show_educational_context and not _educational_context.is_empty():
        educational_context_available.emit(_educational_context)
        await get_tree().create_timer(EDUCATIONAL_PAUSE_DURATION).timeout
    
    # Step 3: Show target system
    _show_target_system(target_system)
    
    # Step 4: Complete transition
    var timer = get_node("TransitionTimer") as Timer
    timer.wait_time = transition_duration
    timer.start()

func _hide_current_system() -> void:
    """Hide the currently active brain system"""
    
    match _current_system:
        BrainSystem.WHOLE_BRAIN:
            _model_registry.hide_model("Whole_Brain")
        BrainSystem.HALF_SECTIONAL:
            _model_registry.hide_model("Half_Brain")
        BrainSystem.INTERNAL:
            _model_registry.hide_model("Internal_Structures")

func _show_target_system(target_system: BrainSystem) -> void:
    """Show the target brain system"""
    
    match target_system:
        BrainSystem.WHOLE_BRAIN:
            _model_registry.show_model("Whole_Brain")
        BrainSystem.HALF_SECTIONAL:
            _model_registry.show_model("Half_Brain")
        BrainSystem.INTERNAL:
            _model_registry.show_model("Internal_Structures")

func _prepare_educational_context(from_system: BrainSystem, to_system: BrainSystem) -> void:
    """Prepare educational context information for the transition"""
    
    _educational_context = {
        "from_system": _get_system_name(from_system),
        "to_system": _get_system_name(to_system),
        "educational_points": []
    }
    
    # Add specific educational context based on the transition
    if _knowledge_service == null:
        return
    
    # Get educational information about this transition
    if from_system == BrainSystem.WHOLE_BRAIN and to_system == BrainSystem.HALF_SECTIONAL:
        _educational_context["educational_points"] = [
            "Transitioning to sagittal section view",
            "This view reveals internal structures by cutting along the median plane",
            "Note how the cerebral hemispheres connect through the corpus callosum"
        ]
    elif from_system == BrainSystem.WHOLE_BRAIN and to_system == BrainSystem.INTERNAL:
        _educational_context["educational_points"] = [
            "Revealing deep brain structures",
            "These structures are normally hidden within the cerebral hemispheres",
            "Focus on relationships between the thalamus, basal ganglia, and limbic structures"
        ]
    elif from_system == BrainSystem.HALF_SECTIONAL and to_system == BrainSystem.INTERNAL:
        _educational_context["educational_points"] = [
            "Isolating internal brain structures",
            "Compare their positions to where they appeared in the sectional view",
            "Note the three-dimensional relationships between structures"
        ]
    # Add other transition educational points as needed

func _update_educational_content() -> void:
    """Update the educational content for the current brain system"""
    
    _current_educational_content = []
    
    if _knowledge_service == null:
        return
    
    # Add system-specific educational content
    match _current_system:
        BrainSystem.WHOLE_BRAIN:
            var cortex_info = _knowledge_service.get_structure("cerebral_cortex")
            if not cortex_info.is_empty():
                _current_educational_content.append(cortex_info)
                
            var lobes_info = [
                _knowledge_service.get_structure("frontal_lobe"),
                _knowledge_service.get_structure("parietal_lobe"),
                _knowledge_service.get_structure("temporal_lobe"),
                _knowledge_service.get_structure("occipital_lobe")
            ]
            
            for info in lobes_info:
                if not info.is_empty():
                    _current_educational_content.append(info)
                    
        BrainSystem.HALF_SECTIONAL:
            var corpus_callosum = _knowledge_service.get_structure("corpus_callosum")
            if not corpus_callosum.is_empty():
                _current_educational_content.append(corpus_callosum)
                
            var ventricle_info = _knowledge_service.get_structure("lateral_ventricle")
            if not ventricle_info.is_empty():
                _current_educational_content.append(ventricle_info)
                
        BrainSystem.INTERNAL:
            var deep_structures = [
                "thalamus",
                "hippocampus", 
                "amygdala",
                "basal_ganglia"
            ]
            
            for structure in deep_structures:
                var info = _knowledge_service.get_structure(structure)
                if not info.is_empty():
                    _current_educational_content.append(info)

func _get_system_name(system: BrainSystem) -> String:
    """Get the human-readable name for a brain system"""
    
    match system:
        BrainSystem.WHOLE_BRAIN:
            return "Whole Brain"
        BrainSystem.HALF_SECTIONAL:
            return "Sagittal Section"
        BrainSystem.INTERNAL:
            return "Internal Structures"
        _:
            return "Unknown System"

# === EVENT HANDLERS ===
func _on_transition_completed() -> void:
    """Handle transition completion"""
    
    _is_transitioning = false
    
    # Update educational content for new system
    _update_educational_content()
    
    # Emit completion signal
    transition_completed.emit(_get_system_name(_current_system))

# === CLEANUP ===
func _exit_tree() -> void:
    """Clean up when node is removed from tree"""
    
    if has_node("TransitionTimer"):
        get_node("TransitionTimer").queue_free()