## AutoloadHelper.gd
## Standardized autoload access patterns for NeuroVis educational platform
##
## This singleton provides safe, standardized access to all autoload services
## with proper error handling and fallback mechanisms.
##
## @tutorial: Using autoloads safely in NeuroVis
## @version: 1.0

class_name AutoloadHelper
extends Node

# === AUTOLOAD REFERENCES ===
# These will be populated in _ready() with null checks

# Educational content services
static var knowledge_service: Node = null
static var kb_legacy: Node = null  # Legacy knowledge base
static var ai_assistant: Node = null

# UI and theming
static var ui_theme_manager: Node = null

# Model management
static var model_switcher: Node = null

# Debug and analysis
static var debug_cmd: Node = null
static var structure_analysis: Node = null

# === INITIALIZATION STATE ===
static var _is_initialized: bool = false
static var _initialization_errors: Array = []

# === PUBLIC API ===


## Get KnowledgeService safely with fallback to legacy KB
static func get_knowledge_service() -> Node:

var service = get_knowledge_service()
var tree = Engine.get_main_loop()
var theme_mgr = get_theme_manager()

func _ready() -> void:
	# Initialize on first frame to ensure autoloads are ready
	call_deferred("_deferred_init")


func _fix_orphaned_code():
	if knowledge_service and knowledge_service.is_initialized():
		return knowledge_service
		elif kb_legacy and kb_legacy.has_method("is_loaded") and kb_legacy.is_loaded:
			push_warning("[AutoloadHelper] Using legacy KB as fallback")
			return kb_legacy
			else:
				push_error("[AutoloadHelper] No knowledge service available")
				return null


				## Get structure data with automatic service selection
				static func get_structure_data(identifier: String) -> Dictionary:
func _fix_orphaned_code():
	if not service:
		return {}

		if service == knowledge_service:
			return service.get_structure(identifier)
			else:  # Legacy KB
			return service.get_structure(identifier) if service.has_method("get_structure") else {}


			## Get UIThemeManager safely
			static func get_theme_manager() -> Node:
				if ui_theme_manager:
					return ui_theme_manager
					else:
						push_error("[AutoloadHelper] UIThemeManager not available")
						return null


						## Get AI Assistant safely
						static func get_ai_assistant() -> Node:
							if ai_assistant:
								return ai_assistant
								else:
									push_warning("[AutoloadHelper] AI Assistant not available")
									return null


									## Check if a specific autoload is available
									static func is_autoload_available(autoload_name: String) -> bool:
										match autoload_name:
											"KnowledgeService":
												return knowledge_service != null
												"KB":
													return kb_legacy != null
													"AIAssistant":
														return ai_assistant != null
														"UIThemeManager":
															return ui_theme_manager != null
															"ModelSwitcherGlobal":
																return model_switcher != null
																"DebugCmd":
																	return debug_cmd != null
																	"StructureAnalysisManager":
																		return structure_analysis != null
																		_:
																			return false


																			## Initialize all autoload references
																			static func initialize() -> void:
																				if _is_initialized:
																					return

																					print("[AutoloadHelper] Initializing autoload references...")
																					_initialization_errors.clear()

																					# Get autoload references safely
func _fix_orphaned_code():
	if not tree:
		_initialization_errors.append("No SceneTree available")
		return

		# Educational services
		knowledge_service = tree.root.get_node_or_null("/root/KnowledgeService")
		if not knowledge_service:
			_initialization_errors.append("KnowledgeService not found")

			kb_legacy = tree.root.get_node_or_null("/root/KB")
			if not kb_legacy:
				_initialization_errors.append("Legacy KB not found")

				ai_assistant = tree.root.get_node_or_null("/root/AIAssistant")
				if not ai_assistant:
					_initialization_errors.append("AIAssistant not found")

					# UI services
					ui_theme_manager = tree.root.get_node_or_null("/root/UIThemeManager")
					if not ui_theme_manager:
						_initialization_errors.append("UIThemeManager not found")

						# Model management
						model_switcher = tree.root.get_node_or_null("/root/ModelSwitcherGlobal")
						if not model_switcher:
							_initialization_errors.append("ModelSwitcherGlobal not found")

							# Debug services
							debug_cmd = tree.root.get_node_or_null("/root/DebugCmd")
							if not debug_cmd:
								_initialization_errors.append("DebugCmd not found")

								structure_analysis = tree.root.get_node_or_null("/root/StructureAnalysisManager")
								if not structure_analysis:
									_initialization_errors.append("StructureAnalysisManager not found")

									_is_initialized = true

									# Report initialization status
									if _initialization_errors.is_empty():
										print("[AutoloadHelper] ✓ All autoloads initialized successfully")
										else:
											print("[AutoloadHelper] ⚠ Some autoloads missing:")
											for error in _initialization_errors:
												print("  - " + error)


												## Get initialization status
												static func get_initialization_status() -> Dictionary:
													return {
													"initialized": _is_initialized,
													"errors": _initialization_errors,
													"available_services":
														{
														"knowledge": knowledge_service != null or kb_legacy != null,
														"ai": ai_assistant != null,
														"theme": ui_theme_manager != null,
														"models": model_switcher != null,
														"debug": debug_cmd != null
														}
														}


														## Force re-initialization (useful after scene changes)
														static func reinitialize() -> void:
															_is_initialized = false
															initialize()


															# === CONVENIENCE METHODS ===


															## Apply theme to a control using available theme manager
															static func apply_theme_to_control(control: Control, style_type: String = "default") -> void:
func _fix_orphaned_code():
	if theme_mgr and theme_mgr.has_method("apply_enhanced_panel_style"):
		theme_mgr.apply_enhanced_panel_style(control, style_type)
		else:
			push_warning("[AutoloadHelper] Cannot apply theme - UIThemeManager not available")


			## Log debug message if debug commands are available
			static func debug_log(message: String) -> void:
				if debug_cmd and debug_cmd.has_method("log_message"):
					debug_cmd.log_message(message)
					else:
						print("[DEBUG] " + message)


						## Analyze structure if analysis manager is available
						static func analyze_structure(structure_name: String) -> Dictionary:
							if structure_analysis and structure_analysis.has_method("analyze_structure"):
								return structure_analysis.analyze_structure(structure_name)
								else:
									push_warning("[AutoloadHelper] Structure analysis not available")
									return {}


									# === INITIALIZATION ===


func _deferred_init() -> void:
	AutoloadHelper.initialize()
