## MockAIProvider.gd
## Mock implementation of the AI provider interface for testing
##
## This provider implements the AIProviderInterface with predefined
## mock responses for testing without requiring an actual AI service.
##
## @version: 1.0

class_name MockAIProvider
extends AIProviderInterface

# === CONFIGURATION ===

var mock_responses: Dictionary = {
	"hippocampus":
	{
		"function":
		"The hippocampus is crucial for forming new memories and spatial navigation. It helps encode declarative memories and plays a key role in learning.",
		"location":
		"The hippocampus is located in the medial temporal lobe, beneath the cerebral cortex. There's one in each hemisphere of the brain.",
		"connections":
		"The hippocampus connects to the fornix, mammillary bodies, septal nuclei, and various cortical areas through the entorhinal cortex.",
		"clinical":
		"Damage to the hippocampus can cause severe memory problems, including inability to form new memories (anterograde amnesia).",
		"default":
		"The hippocampus is a seahorse-shaped structure essential for memory formation and spatial navigation."
	},
	"amygdala":
	{
		"function":
		"The amygdala processes emotions, particularly fear and threat detection. It's part of the limbic system and influences fight-or-flight responses.",
		"location":
		"The amygdala is located in the anterior temporal lobe, adjacent to the hippocampus.",
		"connections":
		"The amygdala connects to the hypothalamus, brainstem, prefrontal cortex, and sensory processing areas.",
		"clinical":
		"Amygdala damage can lead to reduced fear responses, poor threat assessment, and emotional processing difficulties.",
		"default":
		"The amygdala is an almond-shaped structure that processes emotions and fear responses."
	},
	"cerebellum":
	{
		"function":
		"The cerebellum coordinates movement, balance, and motor learning. It also contributes to cognitive functions and language processing.",
		"location":
		"The cerebellum is located at the back of the brain, beneath the cerebral cortex and behind the brainstem.",
		"connections":
		"The cerebellum connects to the brainstem via cerebellar peduncles and receives input from the spinal cord and cerebral cortex.",
		"clinical":
		"Cerebellar damage can cause ataxia (loss of coordination), balance problems, and difficulties with motor learning.",
		"default":
		"The cerebellum is the 'little brain' responsible for motor coordination and balance."
	},
	"general":
	{
		"greeting":
		"Hello! I'm MockBot, a simulated brain anatomy assistant. I can help explain brain structures, their functions, and how they work together. What would you like to learn about?",
		"unknown_structure":
		"I don't have specific information about that structure. Could you select a brain structure from the 3D model for more detailed assistance?",
		"help":
		"I can help you understand brain anatomy! Try asking about:\n• Functions: 'What does the hippocampus do?'\n• Location: 'Where is the amygdala?'\n• Connections: 'What connects to the cerebellum?'\n• Clinical: 'What happens if the frontal cortex is damaged?'",
		"default":
		"I'm a mock AI assistant for testing the NeuroVis application. In a real session, you would be connected to an actual AI service."
	}
}

var current_structure: String = ""
var mock_delay: float = 0.5


# === IMPLEMENTATION OF REQUIRED METHODS ===
	var response = "This is a mock response generated from: " + _prompt

	# Add some educational context
	response += "\n\nIn a real implementation, this would provide detailed educational content about brain anatomy, functions, and clinical relevance."

	# Schedule a delayed response
	get_tree().create_timer(mock_delay).timeout.connect(func(): response_received.emit(response))

	# Return empty string since the response will be sent via signal
	return ""


	var lower_question = question.to_lower()
	var response = ""

	# Check if asking about current structure
	if not current_structure.is_empty():
		var structure_lower = current_structure.to_lower()
		var structure_responses = mock_responses.get(structure_lower, {})

		# Match question type to appropriate response
		if "function" in lower_question or "do" in lower_question:
			response = structure_responses.get("function", "")
		elif "location" in lower_question or "where" in lower_question:
			response = structure_responses.get("location", "")
		elif "connect" in lower_question or "connection" in lower_question:
			response = structure_responses.get("connections", "")
		elif (
			"damage" in lower_question or "clinical" in lower_question or "injury" in lower_question
		):
			response = structure_responses.get("clinical", "")
		else:
			response = structure_responses.get("default", "")

	# Fallback to general responses
	if response.is_empty():
		if "hello" in lower_question or "hi" in lower_question:
			response = mock_responses.general.greeting
		elif "help" in lower_question:
			response = mock_responses.general.help
		else:
			response = mock_responses.general.default

	# Add mock AI disclaimer
	response += "\n\n[Note: This is a mock response for testing. Connect to a real AI provider for full functionality.]"

	# Emit the response
	response_received.emit(response)

func initialize() -> bool:
	print("[MockAI] Mock AI provider initialized")
	return true


func setup_api_key(_key: String) -> bool:
	await get_tree().create_timer(0.5).timeout
	print("[MockAI] Mock API key setup (always succeeds)")
	setup_completed.emit()
	return true


func ask_question(question: String, context: Dictionary = {}) -> String:
	print("[MockAI] Mock ask_question: %s" % question)

	# Update current structure if provided in context
	if context.has("structure"):
		current_structure = context.structure

	# Schedule a delayed response
	get_tree().create_timer(mock_delay).timeout.connect(func(): _send_mock_response(question))

	# Return empty string since the response will be sent via signal
	return ""


func generate_content(_prompt: String) -> String:
	print("[MockAI] Mock generate_content: %s" % _prompt)

	# Generate a simple response based on the prompt
func check_setup_status() -> bool:
	return true


func needs_setup() -> bool:
	return false


func validate_api_key(_key: String) -> void:
	print("[MockAI] Mock validating API key: %s" % _key)

	# Always succeed after a delay
	get_tree().create_timer(0.8).timeout.connect(
		func(): api_key_validated.emit(true, "Mock API key validation successful")
	)


func get_service_status() -> Dictionary:
	return {
		"initialized": true,
		"setup_complete": true,
		"api_configured": true,
		"provider": "mock",
		"current_structure": current_structure
	}


func get_available_models() -> Array:
	return ["mock-basic", "mock-advanced", "mock-educational"]


func set_model(_model_name_or_id: String) -> void:
	print("[MockAI] Mock set_model: %s" % str(_model_name_or_id))


func get_configuration() -> Dictionary:
	return {
		"provider": "mock",
		"model": "mock-educational",
		"models":
		{
			"mock-basic": {"description": "Basic mock model"},
			"mock-advanced": {"description": "Advanced mock model"},
			"mock-educational": {"description": "Educational mock model"}
		},
		"settings": {"mock_delay": mock_delay}
	}


func set_configuration(_config: Dictionary) -> void:
	"""Update provider configuration"""
	print("[MockAI] Mock set_configuration")
	if _config.has("settings") and _config.settings.has("mock_delay"):
		mock_delay = _config.settings.mock_delay


func save_configuration(_key: String, _model: String) -> void:
	print("[MockAI] Mock save_configuration")


func reset_settings() -> bool:
	print("[MockAI] Mock reset_settings")
	return true


# === ADDITIONAL METHODS ===
func set_mock_delay(delay: float) -> void:
	"""Set the mock delay for simulating network latency"""
	mock_delay = delay


func set_current_structure(structure: String) -> void:
	"""Set the current structure context"""
	current_structure = structure


# === PRIVATE METHODS ===

func _send_mock_response(question: String) -> void:
	"""Generate and send a mock response based on the question"""
