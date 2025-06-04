## AIAssistantService.gd
## AI Assistant Service for NeuroVis - Medical Educational Platform
##
## Provides intelligent Q&A and educational assistance for brain anatomy learning.
## Designed specifically for medical students and healthcare professionals,
## supporting multiple AI providers with medical accuracy emphasis.
##
## Medical Context:
## - Temperature 0.7: Balances medical accuracy with educational engagement
## - Conversation history: Enables progressive learning and concept building
## - System prompts: Emphasize clinical relevance and pedagogical effectiveness
## - Mock responses: Medically accurate fallbacks for offline learning
##
## @tutorial: Medical AI integration guide
## @tutorial: Educational prompt engineering

class_name AIAssistantService
extends Node

# Preload the GeminiAIService class to ensure it's available
const GeminiAIServiceClass = preload("res://core/ai/GeminiAIService.gd")

# === AI SERVICE SIGNALS ===
## Emitted when AI provides educational response
signal response_received(user_question: String, ai_response: String)
## Emitted when service encounters error requiring user notification
signal error_occurred(error_message: String)
## Emitted when anatomical context changes for targeted learning
signal context_updated(structure_name: String)
## Emitted when new learning session begins
signal conversation_started()
## Emitted when learning session ends
signal conversation_ended()

# === AI PROVIDERS ===
enum AIProvider {
	OPENAI_GPT,
	ANTHROPIC_CLAUDE,
	GOOGLE_GEMINI,
	GEMINI_USER, # User's own Gemini API key for personalized learning
	LOCAL_MODEL,
	MOCK_RESPONSES # Medically accurate offline responses
}

# === CONFIGURATION ===
@export var ai_provider: AIProvider = AIProvider.MOCK_RESPONSES
@export var api_key: String = "" # Set via environment or config
@export var max_tokens: int = 500 # Sufficient for concise medical explanations

## Temperature 0.7: Medical education sweet spot
## - Lower values: Too rigid, misses educational nuances
## - Higher values: Risk of medical inaccuracies
## - 0.7: Optimal for accurate yet engaging explanations
@export var temperature: float = 0.7

@export var enable_context_memory: bool = true # Essential for progressive learning
@export var max_conversation_history: int = 10 # ~5 Q&A pairs per learning topic

# === STATE VARIABLES ===
var current_structure: String = "" # Currently selected anatomical structure
var conversation_history: Array[Dictionary] = [] # Typed array for conversation tracking
var is_initialized: bool = false
var request_timeout: float = 30.0 # Reasonable timeout for medical queries
var user_gemini_service: Node # Reference to user's personalized Gemini service

# === HTTP CLIENT ===
var http_request: HTTPRequest

# === EDUCATIONAL CONTEXT ===
## System prompts optimized for medical education
## Emphasizes clinical relevance and structured learning
var educational_prompts: Dictionary = {
	"system_prompt": """You are NeuroBot, an expert neuroanatomy tutor for medical professionals.
Provide accurate, clinically-relevant explanations about brain structures, their functions, and relationships.
Structure responses for optimal medical learning:
1. Core anatomical facts
2. Clinical significance
3. Common pathologies
4. Memory aids when helpful
Keep responses concise but comprehensive, suitable for medical students and residents.""",

	"structure_context_template": "The user is currently examining the {structure_name}. Provide anatomically accurate, clinically relevant information.",

	"question_types": {
		"function": "Explain the primary functions and clinical significance of the {structure_name}.",
		"location": "Describe the anatomical location of the {structure_name} using standard medical terminology.",
		"connections": "Detail the anatomical connections and pathways of the {structure_name}.",
		"clinical": "Explain clinical presentations when the {structure_name} is damaged or diseased.",
		"development": "Describe the embryological development and clinical implications for the {structure_name}.",
		"comparison": "Compare and contrast the {structure_name} with {other_structure} anatomically and functionally."
	}
}

# === MOCK RESPONSES (Medically Accurate Offline Content) ===
## Curated medical content for offline learning
## All responses verified for anatomical accuracy
var mock_responses: Dictionary = {
	"hippocampus": {
		"function": """The hippocampus is crucial for declarative memory consolidation and spatial navigation.
Key functions include:
• Converting short-term to long-term memories
• Spatial memory and navigation (place cells)
• Pattern separation and completion
Clinical correlation: Essential for forming new episodic memories.""",
		
		"location": """The hippocampus is located in the medial temporal lobe, within the hippocampal formation.
Anatomical landmarks:
• Medial to the inferior horn of lateral ventricle
• Part of the limbic system
• C-shaped structure in coronal section
• Extends from amygdala anteriorly to splenium posteriorly""",
		
		"connections": """Major hippocampal connections include:
• Input: Entorhinal cortex (perforant pathway)
• Output: Fornix → mammillary bodies, septal nuclei, anterior thalamus
• Commissural: Hippocampal commissure
• Circuit: Papez circuit for memory processing""",
		
		"clinical": """Hippocampal damage presents with:
• Anterograde amnesia (inability to form new memories)
• Temporally graded retrograde amnesia
• Preserved procedural memory
Common causes: Alzheimer's disease, hypoxic injury, temporal lobe epilepsy, HSV encephalitis""",
		
		"default": "The hippocampus is a seahorse-shaped structure in the medial temporal lobe essential for memory formation and spatial navigation."
	},
	
	"amygdala": {
		"function": """The amygdala processes emotions, particularly fear and threat detection.
Key functions:
• Fear conditioning and emotional memory
• Autonomic responses to emotional stimuli
• Social behavior and recognition
• Modulation of memory consolidation during emotional events""",
		
		"location": """The amygdala is located in the anterior medial temporal lobe.
Anatomical position:
• Anterior to hippocampus
• Medial to uncus
• Superior to parahippocampal gyrus
• Comprises multiple nuclei (lateral, basal, central)""",
		
		"connections": """Key amygdalar connections:
• Inputs: Sensory thalamus, sensory cortices, hippocampus
• Outputs: Hypothalamus (stress response), brainstem (autonomic), prefrontal cortex (regulation)
• Stria terminalis: Major output pathway
• Ventral amygdalofugal pathway: To hypothalamus and brainstem""",
		
		"clinical": """Amygdala lesions result in:
• Klüver-Bucy syndrome (bilateral damage): hyperorality, hypersexuality, visual agnosia
• Impaired fear conditioning
• Reduced emotional recognition
• Inappropriate social behavior
Associated with: PTSD, anxiety disorders, autism spectrum disorder""",
		
		"default": "The amygdala is an almond-shaped structure that processes emotions, fear responses, and emotional memory formation."
	},
	
	"cerebellum": {
		"function": """The cerebellum coordinates movement, balance, and motor learning.
Functions include:
• Motor coordination and timing
• Balance and posture via vestibular connections
• Motor learning and adaptation
• Cognitive functions: language, attention, executive function
• Predictive motor control""",
		
		"location": """The cerebellum occupies the posterior fossa.
Anatomical features:
• Inferior to occipital lobes
• Posterior to brainstem
• Separated from cerebrum by tentorium cerebelli
• Three lobes: anterior, posterior, flocculonodular""",
		
		"connections": """Cerebellar connections via three peduncles:
• Superior: Efferent to thalamus and motor cortex
• Middle: Afferent from pontine nuclei (corticopontocerebellar)
• Inferior: Afferent from spinal cord and vestibular nuclei
Deep nuclei: Dentate, emboliform, globose, fastigial""",
		
		"clinical": """Cerebellar damage manifests as:
• Ataxia: gait, limb, truncal
• Dysmetria and intention tremor
• Dysdiadochokinesia
• Nystagmus
• Dysarthria
Causes: Stroke, tumors, alcohol, paraneoplastic, hereditary ataxias""",
		
		"default": "The cerebellum is the 'little brain' in the posterior fossa responsible for motor coordination, balance, and motor learning."
	},
	
	"general": {
		"greeting": """Hello! I'm NeuroBot, your neuroanatomy learning assistant.
I provide medically accurate information about brain structures, their functions, and clinical significance.
Select a brain structure to begin, or ask me any neuroanatomy question!""",
		
		"unknown_structure": "I don't have specific information about that structure. Please select a brain structure from the 3D model for detailed anatomical and clinical information.",
		
		"help": """I can help you understand neuroanatomy for medical practice!
Ask me about:
• Anatomy: 'Where is the hippocampus located?'
• Function: 'What does the amygdala do?'
• Clinical: 'What happens in cerebellar stroke?'
• Connections: 'What are the outputs of the basal ganglia?'
• Development: 'How does the corpus callosum develop?'""",
		
		"default": "I'm here to help you master neuroanatomy. Feel free to ask about any brain structure's anatomy, function, or clinical significance!"
	}
}

# === GEMINI INTEGRATION ===
var gemini_service: GeminiAIServiceClass

func _ready() -> void:
	"""Initialize the AI Assistant Service for medical education"""
	_initialize_ai_service()

func _initialize_ai_service() -> void:
	"""Setup the AI service based on selected provider"""
	if OS.is_debug_build():
		print("[AI] Debug: Initializing Medical AI Assistant Service...")

	# Create HTTP request node for API calls
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_api_response_received)
	http_request.timeout = request_timeout

	# Initialize Gemini services if needed
	_initialize_gemini_service()
	_initialize_user_gemini_service()

	# Load API configuration if available
	_load_api_configuration()

	# Initialize conversation for new learning session
	conversation_history.clear()

	is_initialized = true
	conversation_started.emit()

	if OS.is_debug_build():
		print("[AI] Debug: Medical AI Assistant initialized with provider: %s" % AIProvider.keys()[ai_provider])

func _initialize_gemini_service() -> void:
	"""Initialize Gemini AI service for medical queries"""
	# Check if GeminiAI is already available as autoload
	gemini_service = get_node_or_null("/root/GeminiAI")

	# If not available as autoload, create instance
	if not gemini_service and ai_provider == AIProvider.GOOGLE_GEMINI:
		if OS.is_debug_build():
			print("[AI] Debug: Creating local Gemini service instance")
		gemini_service = GeminiAIServiceClass.new()
		add_child(gemini_service)

func _initialize_user_gemini_service() -> void:
	"""Initialize user's personalized Gemini AI service"""
	# Get reference to the GeminiAI autoload
	user_gemini_service = get_node_or_null("/root/GeminiAI")

	if user_gemini_service:
		if OS.is_debug_build():
			print("[AI] Debug: Connected to user's GeminiAI service")
		if not user_gemini_service.response_received.is_connected(_on_user_gemini_response):
			user_gemini_service.response_received.connect(_on_user_gemini_response)
		if not user_gemini_service.error_occurred.is_connected(_on_user_gemini_error):
			user_gemini_service.error_occurred.connect(_on_user_gemini_error)
	else:
		push_warning("[AI] Service discovery: User's GeminiAI service not found")

func _load_api_configuration() -> void:
	"""Load API configuration from secure sources"""
	# Try to load from environment variables first (secure)
	var env_api_key: String = OS.get_environment("NEUROVIS_AI_API_KEY")
	if env_api_key != "":
		api_key = env_api_key
		if OS.is_debug_build():
			print("[AI] Debug: API key loaded from environment")

	# TODO: Add config file loading for development
	# For now, we'll use medically accurate mock responses

# === PUBLIC API ===
## Set the current anatomical structure for contextual learning
## @param structure_name: Medical name of the brain structure
func set_current_structure(structure_name: String) -> void:
	"""Set the current brain structure for medical context"""
	current_structure = structure_name
	context_updated.emit(structure_name)
	if OS.is_debug_build():
		print("[AI] Debug: Medical context updated to: %s" % structure_name)

## Submit a medical/educational question to the AI
## @param user_question: The learner's neuroanatomy question
func ask_question(user_question: String) -> void:
	"""Ask a medical question to the AI assistant"""
	if not is_initialized:
		error_occurred.emit("Medical AI Assistant not initialized")
		return

	if OS.is_debug_build():
		print("[AI] Debug: Processing medical question: %s" % user_question)

	# Add to conversation history for progressive learning
	_add_to_history("user", user_question)

	match ai_provider:
		AIProvider.MOCK_RESPONSES:
			_handle_mock_response(user_question)
		AIProvider.OPENAI_GPT:
			_send_openai_request(user_question)
		AIProvider.ANTHROPIC_CLAUDE:
			_send_claude_request(user_question)
		AIProvider.GOOGLE_GEMINI:
			_send_gemini_request(user_question)
		AIProvider.GEMINI_USER:
			_send_user_gemini_request(user_question)
		_:
			error_occurred.emit("Unsupported AI provider")

## Ask a structured question about the current anatomical structure
## @param question_type: Type of medical question (function, location, clinical, etc.)
func ask_about_current_structure(question_type: String = "function") -> void:
	"""Ask a specific medical question about the selected structure"""
	if current_structure.is_empty():
		error_occurred.emit("No anatomical structure currently selected")
		return

	var structured_question: String = ""
	match question_type:
		"function":
			structured_question = "What are the main functions and clinical significance of the %s?" % current_structure
		"location":
			structured_question = "Describe the anatomical location of the %s using medical terminology." % current_structure
		"connections":
			structured_question = "What are the anatomical connections and pathways of the %s?" % current_structure
		"clinical":
			structured_question = "What are the clinical presentations when the %s is damaged?" % current_structure
		"development":
			structured_question = "Describe the embryological development of the %s." % current_structure
		_:
			structured_question = "Provide medical information about the %s." % current_structure

	ask_question(structured_question)

## Get conversation history for learning review
## @returns: Array of conversation entries with medical Q&A
func get_conversation_history() -> Array[Dictionary]:
	"""Get the current conversation history for review"""
	return conversation_history.duplicate()

## Clear conversation to start new medical topic
func clear_conversation() -> void:
	"""Clear conversation history for new learning topic"""
	conversation_history.clear()
	conversation_ended.emit()
	conversation_started.emit()
	if OS.is_debug_build():
		print("[AI] Debug: Medical conversation history cleared")

# === MOCK RESPONSE HANDLER ===
func _handle_mock_response(user_question: String) -> void:
	"""Handle medically accurate mock responses for offline learning"""
	await get_tree().create_timer(1.0).timeout # Simulate API delay

	var mock_response: String = ""
	var lower_question: String = user_question.to_lower()

	# Check if asking about current anatomical structure
	if not current_structure.is_empty():
		var structure_key: String = current_structure.to_lower()
		var structure_responses: Dictionary = mock_responses.get(structure_key, {})

		# Match question type to appropriate medical response
		if "function" in lower_question or "do" in lower_question or "role" in lower_question:
			mock_response = structure_responses.get("function", "")
		elif "location" in lower_question or "where" in lower_question or "anatomy" in lower_question:
			mock_response = structure_responses.get("location", "")
		elif "connect" in lower_question or "pathway" in lower_question or "project" in lower_question:
			mock_response = structure_responses.get("connections", "")
		elif "damage" in lower_question or "clinical" in lower_question or "lesion" in lower_question or "disease" in lower_question:
			mock_response = structure_responses.get("clinical", "")
		else:
			mock_response = structure_responses.get("default", "")

	# Fallback to general medical responses
	if mock_response.is_empty():
		if "hello" in lower_question or "hi" in lower_question:
			mock_response = mock_responses.general.greeting
		elif "help" in lower_question:
			mock_response = mock_responses.general.help
		else:
			mock_response = mock_responses.general.default

	_add_to_history("assistant", mock_response)
	response_received.emit(user_question, mock_response)
	if OS.is_debug_build():
		print("[AI] Debug: Medical mock response sent")

# === API REQUEST HANDLERS ===
func _send_user_gemini_request(user_question: String) -> void:
	"""Send medical query to user's Gemini AI service"""
	if not user_gemini_service:
		error_occurred.emit("User's Gemini AI service not available")
		_handle_mock_response(user_question) # Fallback to medical mock
		return

	if not user_gemini_service.check_setup_status():
		if user_gemini_service.needs_setup():
			error_occurred.emit("Gemini AI needs setup. Please configure your API key.")
		else:
			error_occurred.emit("Gemini AI not properly configured")
		return

	# Create medical context with current structure
	var medical_context: Dictionary = {}
	if not current_structure.is_empty():
		medical_context["structure"] = current_structure

	# Send request using user's Gemini service
	if OS.is_debug_build():
		print("[AI] Debug: Sending medical query to user's Gemini AI")
	user_gemini_service.ask_question(user_question, medical_context)

func _send_openai_request(user_question: String) -> void:
	"""Send medical query to OpenAI GPT API"""
	if api_key.is_empty():
		_handle_mock_response(user_question) # Fallback to medical mock
		return

	var url: String = "https://api.openai.com/v1/chat/completions"
	var headers: Array[String] = [
		"Content-Type: application/json",
		"Authorization: Bearer " + api_key
	]

	var messages: Array = _build_conversation_context()
	messages.append({"role": "user", "content": user_question})

	var request_body: Dictionary = {
		"model": "gpt-3.5-turbo",
		"messages": messages,
		"max_tokens": max_tokens,
		"temperature": temperature
	}

	var json_body: String = JSON.stringify(request_body)
	http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)

func _send_claude_request(user_question: String) -> void:
	"""Send medical query to Anthropic Claude API"""
	if api_key.is_empty():
		_handle_mock_response(user_question) # Fallback to medical mock
		return

	var url: String = "https://api.anthropic.com/v1/messages"
	var headers: Array[String] = [
		"Content-Type: application/json",
		"x-api-key: " + api_key,
		"anthropic-version: 2023-06-01"
	]

	var messages: Array = _build_conversation_context()
	messages.append({"role": "user", "content": user_question})

	var request_body: Dictionary = {
		"model": "claude-3-haiku-20240307",
		"max_tokens": max_tokens,
		"messages": messages
	}

	var json_body: String = JSON.stringify(request_body)
	http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)

func _send_gemini_request(user_question: String) -> void:
	"""Send medical query to Google Gemini API"""
	if not gemini_service or not gemini_service.is_api_key_valid():
		if api_key.is_empty():
			_handle_mock_response(user_question) # Fallback to medical mock
			return

		# Use built-in implementation if GeminiService not available
		var url: String = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=" + api_key
		var headers: Array[String] = ["Content-Type: application/json"]

		var medical_prompt: String = _build_gemini_prompt(user_question)
		var request_body: Dictionary = {
			"contents": [ {
				"parts": [ {"text": medical_prompt}]
			}],
			"generationConfig": {
				"maxOutputTokens": max_tokens,
				"temperature": temperature
			}
		}

		var json_body: String = JSON.stringify(request_body)
		http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)
	else:
		# Use dedicated GeminiService
		var medical_prompt: String = _build_gemini_prompt(user_question)
		var api_result = await gemini_service.generate_content(medical_prompt)
		if api_result != "PENDING":
			# If immediate error occurred
			error_occurred.emit("Gemini API error: " + api_result)
			return

# === RESPONSE PROCESSING ===
func _on_api_response_received(http_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	"""Handle API response with medical content"""
	if http_result != HTTPRequest.RESULT_SUCCESS:
		error_occurred.emit("Medical API request failed")
		return

	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())

	if parse_result != OK:
		error_occurred.emit("Failed to parse medical API response")
		return

	var response_data: Dictionary = json.get_data()
	var ai_response_text: String = ""

	# Parse response based on provider
	match ai_provider:
		AIProvider.OPENAI_GPT:
			ai_response_text = _parse_openai_response(response_data)
		AIProvider.ANTHROPIC_CLAUDE:
			ai_response_text = _parse_claude_response(response_data)
		AIProvider.GOOGLE_GEMINI:
			ai_response_text = _parse_gemini_response(response_data)

	if ai_response_text.is_empty():
		error_occurred.emit("Empty response from medical AI service")
		return

	var last_user_question: String = conversation_history[-1].content if conversation_history.size() > 0 else ""
	_add_to_history("assistant", ai_response_text)
	response_received.emit(last_user_question, ai_response_text)

func _parse_openai_response(response_data: Dictionary) -> String:
	"""Parse OpenAI API response for medical content"""
	if response_data.has("choices") and response_data.choices.size() > 0:
		return response_data.choices[0].message.content
	return ""

func _parse_claude_response(response_data: Dictionary) -> String:
	"""Parse Claude API response for medical content"""
	if response_data.has("content") and response_data.content.size() > 0:
		return response_data.content[0].text
	return ""

func _parse_gemini_response(response_data: Dictionary) -> String:
	"""Parse Gemini API response for medical content"""
	if response_data.has("candidates") and response_data.candidates.size() > 0:
		var candidate = response_data.candidates[0]
		if candidate.has("content") and candidate.content.has("parts"):
			return candidate.content.parts[0].text
	return ""

func _on_gemini_response_received(ai_response_text: String) -> void:
	"""Handle response from GeminiAIService"""
	if ai_response_text.is_empty():
		error_occurred.emit("Empty response from Gemini AI")
		return

	var last_user_question: String = conversation_history[-1].content if conversation_history.size() > 0 else ""
	_add_to_history("assistant", ai_response_text)
	response_received.emit(last_user_question, ai_response_text)

func _on_user_gemini_response(ai_response_text: String) -> void:
	"""Handle medical response from user's GeminiAI service"""
	if ai_response_text.is_empty():
		error_occurred.emit("Empty response from user's Gemini AI")
		return

	var last_user_question: String = conversation_history[-1].content if conversation_history.size() > 0 else ""
	_add_to_history("assistant", ai_response_text)
	response_received.emit(last_user_question, ai_response_text)

func _on_user_gemini_error(error_message: String) -> void:
	"""Handle error from user's GeminiAI service"""
	error_occurred.emit("Gemini API error: " + error_message)

# === CONVERSATION MANAGEMENT ===
func _add_to_history(role: String, content: String) -> void:
	"""Add message to medical conversation history"""
	conversation_history.append({
		"role": role,
		"content": content,
		"timestamp": Time.get_unix_time_from_system()
	})

	# Limit history size to maintain context relevance
	if conversation_history.size() > max_conversation_history:
		# Keep recent messages for continuous medical learning
		conversation_history = conversation_history.slice(-max_conversation_history)

func _build_conversation_context() -> Array:
	"""Build medical conversation context for API calls"""
	var messages: Array = []

	# Add medical system prompt
	var medical_prompt: String = educational_prompts.system_prompt
	if not current_structure.is_empty():
		medical_prompt += " " + educational_prompts.structure_context_template.format({"structure_name": current_structure})

	messages.append({"role": "system", "content": medical_prompt})

	# Add conversation history for progressive learning
	if enable_context_memory:
		for entry in conversation_history:
			if entry.role != "system": # Don't duplicate system messages
				messages.append({"role": entry.role, "content": entry.content})

	return messages

func _build_gemini_prompt(user_question: String) -> String:
	"""Build medical prompt for Gemini API"""
	var medical_prompt: String = educational_prompts.system_prompt

	if not current_structure.is_empty():
		medical_prompt += " " + educational_prompts.structure_context_template.format({"structure_name": current_structure})

	medical_prompt += "\n\nMedical Question: " + user_question
	return medical_prompt

# === UTILITY METHODS ===
## Get list of available AI providers
## @returns: Array of provider names
func get_available_providers() -> Array:
	"""Get list of available medical AI providers"""
	return AIProvider.keys()

## Change AI provider for medical queries
## @param provider: New AI provider to use
func set_provider(provider: AIProvider) -> void:
	"""Change medical AI provider"""
	ai_provider = provider
	if OS.is_debug_build():
		print("[AI] Debug: Medical provider changed to: %s" % AIProvider.keys()[provider])

## Check if API key is configured
## @returns: true if API is ready for medical queries
func is_api_key_configured() -> bool:
	"""Check if API key is configured for medical queries"""
	return not api_key.is_empty() or ai_provider == AIProvider.MOCK_RESPONSES

## Get comprehensive service status
## @returns: Dictionary with service health information
func get_service_status() -> Dictionary:
	"""Get current medical AI service status"""
	var status: Dictionary = {
		"initialized": is_initialized,
		"provider": AIProvider.keys()[ai_provider],
		"api_configured": is_api_key_configured(),
		"current_structure": current_structure,
		"conversation_length": conversation_history.size(),
		"educational_mode": "medical_professional"
	}
	
	# Add Gemini-specific status if using user's Gemini
	if ai_provider == AIProvider.GEMINI_USER and user_gemini_service:
		status["gemini_status"] = user_gemini_service.get_rate_limit_status()
	
	return status