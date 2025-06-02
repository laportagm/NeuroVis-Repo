# AI Assistant Service for NeuroVis
# Provides intelligent Q&A and educational assistance for brain anatomy
class_name AIAssistantService
extends Node

# Preload the GeminiAIService class to ensure it's available
const GeminiAIServiceClass = preload("res://core/ai/GeminiAIService.gd")

# === AI SERVICE SIGNALS ===
signal response_received(question: String, response: String)
signal error_occurred(error_message: String)
signal context_updated(structure_name: String)
signal conversation_started()
signal conversation_ended()
# === AI PROVIDERS ===
enum AIProvider {
    OPENAI_GPT,
    ANTHROPIC_CLAUDE,
    GOOGLE_GEMINI,
    GEMINI_USER, # User's own Gemini API key
    LOCAL_MODEL,
    MOCK_RESPONSES # For testing without API
}

# === CONFIGURATION ===
@export var ai_provider: AIProvider = AIProvider.MOCK_RESPONSES
@export var api_key: String = "" # Set via environment or config
@export var max_tokens: int = 500
@export var temperature: float = 0.7
@export var enable_context_memory: bool = true
@export var max_conversation_history: int = 10

# === STATE VARIABLES ===
var current_structure: String = ""
var conversation_history: Array = []
var is_initialized: bool = false
var request_timeout: float = 30.0
var user_gemini_service: Node # Reference to user's Gemini service

# === HTTP CLIENT ===
var http_request: HTTPRequest

# === EDUCATIONAL CONTEXT ===
var educational_prompts = {
    "system_prompt": "You are NeuroBot, an expert neuroanatomy tutor. Provide clear, educational explanations about brain structures, their functions, and relationships. Keep responses concise but informative, suitable for medical students.",

    "structure_context_template": "The user is currently examining the {structure_name}. Answer questions in this context.",

    "question_types": {
        "function": "Explain the primary functions of the {structure_name}.",
        "location": "Describe where the {structure_name} is located in the brain.",
        "connections": "What structures does the {structure_name} connect to?",
        "clinical": "What happens when the {structure_name} is damaged?",
        "development": "How does the {structure_name} develop?",
        "comparison": "How does the {structure_name} compare to {other_structure}?"
    }
}

# === MOCK RESPONSES (for testing) ===
var mock_responses = {
    "hippocampus": {
        "function": "The hippocampus is crucial for forming new memories and spatial navigation. It helps encode declarative memories and plays a key role in learning.",
        "location": "The hippocampus is located in the medial temporal lobe, beneath the cerebral cortex. There's one in each hemisphere of the brain.",
        "connections": "The hippocampus connects to the fornix, mammillary bodies, septal nuclei, and various cortical areas through the entorhinal cortex.",
        "clinical": "Damage to the hippocampus can cause severe memory problems, including inability to form new memories (anterograde amnesia).",
        "default": "The hippocampus is a seahorse-shaped structure essential for memory formation and spatial navigation."
    },
    "amygdala": {
        "function": "The amygdala processes emotions, particularly fear and threat detection. It's part of the limbic system and influences fight-or-flight responses.",
        "location": "The amygdala is located in the anterior temporal lobe, adjacent to the hippocampus.",
        "connections": "The amygdala connects to the hypothalamus, brainstem, prefrontal cortex, and sensory processing areas.",
        "clinical": "Amygdala damage can lead to reduced fear responses, poor threat assessment, and emotional processing difficulties.",
        "default": "The amygdala is an almond-shaped structure that processes emotions and fear responses."
    },
    "cerebellum": {
        "function": "The cerebellum coordinates movement, balance, and motor learning. It also contributes to cognitive functions and language processing.",
        "location": "The cerebellum is located at the back of the brain, beneath the cerebral cortex and behind the brainstem.",
        "connections": "The cerebellum connects to the brainstem via cerebellar peduncles and receives input from the spinal cord and cerebral cortex.",
        "clinical": "Cerebellar damage can cause ataxia (loss of coordination), balance problems, and difficulties with motor learning.",
        "default": "The cerebellum is the 'little brain' responsible for motor coordination and balance."
    },
    "general": {
        "greeting": "Hello! I'm NeuroBot, your brain anatomy assistant. I can help explain brain structures, their functions, and how they work together. What would you like to learn about?",
        "unknown_structure": "I don't have specific information about that structure. Could you select a brain structure from the 3D model for more detailed assistance?",
        "help": "I can help you understand brain anatomy! Try asking about:\n• Functions: 'What does the hippocampus do?'\n• Location: 'Where is the amygdala?'\n• Connections: 'What connects to the cerebellum?'\n• Clinical: 'What happens if the frontal cortex is damaged?'",
        "default": "I'm here to help you learn about brain anatomy. Feel free to ask me questions about any brain structure you're exploring!"
    }
}

# === GEMINI INTEGRATION ===
var gemini_service: GeminiAIServiceClass

func _ready() -> void:
    """Initialize the AI Assistant Service"""
    _initialize_ai_service()

func _initialize_ai_service() -> void:
    """Setup the AI service based on selected provider"""
    print("[AI] Initializing AI Assistant Service...")

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

    # Initialize conversation
    conversation_history.clear()

    is_initialized = true
    conversation_started.emit()

    print("[AI] AI Assistant initialized with provider: %s" % AIProvider.keys()[ai_provider])

func _initialize_gemini_service() -> void:
    """Initialize Gemini AI service for integration"""
    # Check if GeminiAI is already available as autoload
    gemini_service = get_node_or_null("/root/GeminiAI")

    # If not available as autoload, create instance
    if not gemini_service and ai_provider == AIProvider.GOOGLE_GEMINI:
        print("[AI] Creating local Gemini service instance")
        gemini_service = GeminiAIServiceClass.new()
        add_child(gemini_service)

func _initialize_user_gemini_service() -> void:
    """Initialize user's own Gemini AI service"""
    # Get reference to the GeminiAI autoload
    user_gemini_service = get_node_or_null("/root/GeminiAI")

    if user_gemini_service:
        print("[AI] Connected to user's GeminiAI service")
        if not user_gemini_service.response_received.is_connected(_on_user_gemini_response):
            user_gemini_service.response_received.connect(_on_user_gemini_response)
        if not user_gemini_service.error_occurred.is_connected(_on_user_gemini_error):
            user_gemini_service.error_occurred.connect(_on_user_gemini_error)
    else:
        print("[AI] User's GeminiAI service not found")

func _load_api_configuration() -> void:
    """Load API configuration from environment or config file"""
    # Try to load from environment variables first
    var env_api_key = OS.get_environment("NEUROVIS_AI_API_KEY")
    if env_api_key != "":
        api_key = env_api_key
        print("[AI] API key loaded from environment")

    # TODO: Add config file loading if needed
    # For now, we'll use mock responses for demonstration

# === PUBLIC API ===
func set_current_structure(structure_name: String) -> void:
    """Set the current brain structure for context"""
    current_structure = structure_name
    context_updated.emit(structure_name)
    print("[AI] Context updated to: %s" % structure_name)

func ask_question(question: String) -> void:
    """Ask a question to the AI assistant"""
    if not is_initialized:
        error_occurred.emit("AI Assistant not initialized")
        return

    print("[AI] Processing question: %s" % question)

    # Add to conversation history
    _add_to_history("user", question)

    match ai_provider:
        AIProvider.MOCK_RESPONSES:
            _handle_mock_response(question)
        AIProvider.OPENAI_GPT:
            _send_openai_request(question)
        AIProvider.ANTHROPIC_CLAUDE:
            _send_claude_request(question)
        AIProvider.GOOGLE_GEMINI:
            _send_gemini_request(question)
        AIProvider.GEMINI_USER:
            _send_user_gemini_request(question)
        _:
            error_occurred.emit("Unsupported AI provider")

func ask_about_current_structure(question_type: String = "function") -> void:
    """Ask a specific question about the currently selected structure"""
    if current_structure.is_empty():
        error_occurred.emit("No structure currently selected")
        return

    var question = ""
    match question_type:
        "function":
            question = "What are the main functions of the %s?" % current_structure
        "location":
            question = "Where is the %s located in the brain?" % current_structure
        "connections":
            question = "What brain structures does the %s connect to?" % current_structure
        "clinical":
            question = "What happens when the %s is damaged or impaired?" % current_structure
        "development":
            question = "How does the %s develop during brain development?" % current_structure
        _:
            question = "Tell me about the %s." % current_structure

    ask_question(question)

func get_conversation_history() -> Array:
    """Get the current conversation history"""
    return conversation_history.duplicate()

func clear_conversation() -> void:
    """Clear the conversation history"""
    conversation_history.clear()
    conversation_ended.emit()
    conversation_started.emit()
    print("[AI] Conversation cleared")

# === MOCK RESPONSE HANDLER ===
func _handle_mock_response(question: String) -> void:
    """Handle mock responses for testing without API"""
    await get_tree().create_timer(1.0).timeout # Simulate API delay

    var response = ""
    var lower_question = question.to_lower()

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
        elif "damage" in lower_question or "clinical" in lower_question or "injury" in lower_question:
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

    _add_to_history("assistant", response)
    response_received.emit(question, response)
    print("[AI] Mock response sent")

# === API REQUEST HANDLERS ===
func _send_user_gemini_request(question: String) -> void:
    """Send request to user's Gemini AI service"""
    if not user_gemini_service:
        error_occurred.emit("User's Gemini AI service not available")
        _handle_mock_response(question) # Fallback to mock
        return

    if not user_gemini_service.check_setup_status():
        if user_gemini_service.needs_setup():
            error_occurred.emit("Gemini AI needs setup. Please configure your API key.")
        else:
            error_occurred.emit("Gemini AI not properly configured")
        return

    # Create context with current structure
    var context = {}
    if not current_structure.is_empty():
        context["structure"] = current_structure

    # Send request using user's Gemini service
    print("[AI] Sending request to user's Gemini AI service")
    user_gemini_service.ask_question(question, context)

func _send_openai_request(question: String) -> void:
    """Send request to OpenAI GPT API"""
    if api_key.is_empty():
        _handle_mock_response(question) # Fallback to mock
        return

    var url = "https://api.openai.com/v1/chat/completions"
    var headers = [
        "Content-Type: application/json",
        "Authorization: Bearer " + api_key
    ]

    var messages = _build_conversation_context()
    messages.append({"role": "user", "content": question})

    var body = {
        "model": "gpt-3.5-turbo",
        "messages": messages,
        "max_tokens": max_tokens,
        "temperature": temperature
    }

    var json_body = JSON.stringify(body)
    http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)

func _send_claude_request(question: String) -> void:
    """Send request to Anthropic Claude API"""
    if api_key.is_empty():
        _handle_mock_response(question) # Fallback to mock
        return

    var url = "https://api.anthropic.com/v1/messages"
    var headers = [
        "Content-Type: application/json",
        "x-api-key: " + api_key,
        "anthropic-version: 2023-06-01"
    ]

    var messages = _build_conversation_context()
    messages.append({"role": "user", "content": question})

    var body = {
        "model": "claude-3-haiku-20240307",
        "max_tokens": max_tokens,
        "messages": messages
    }

    var json_body = JSON.stringify(body)
    http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)

func _send_gemini_request(question: String) -> void:
    """Send request to Google Gemini API"""
    if not gemini_service or not gemini_service.is_api_key_valid():
        if api_key.is_empty():
            _handle_mock_response(question) # Fallback to mock
            return

        # Use built-in implementation if GeminiService not available
        var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=" + api_key
        var headers = ["Content-Type: application/json"]

        var prompt = _build_gemini_prompt(question)
        var body = {
            "contents": [ {
                "parts": [ {"text": prompt}]
            }],
            "generationConfig": {
                "maxOutputTokens": max_tokens,
                "temperature": temperature
            }
        }

        var json_body = JSON.stringify(body)
        http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)
    else:
        # Use dedicated GeminiService
        var prompt = _build_gemini_prompt(question)
        var result = await gemini_service.generate_content(prompt)
        if result != "PENDING":
            # If immediate error occurred
            error_occurred.emit("Gemini API error: " + result)
            return

# === RESPONSE PROCESSING ===
func _on_api_response_received(result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
    """Handle API response"""
    if result != HTTPRequest.RESULT_SUCCESS:
        error_occurred.emit("API request failed")
        return

    var json = JSON.new()
    var parse_result = json.parse(body.get_string_from_utf8())

    if parse_result != OK:
        error_occurred.emit("Failed to parse API response")
        return

    var response_data = json.get_data()
    var response_text = ""

    # Parse response based on provider
    match ai_provider:
        AIProvider.OPENAI_GPT:
            response_text = _parse_openai_response(response_data)
        AIProvider.ANTHROPIC_CLAUDE:
            response_text = _parse_claude_response(response_data)
        AIProvider.GOOGLE_GEMINI:
            response_text = _parse_gemini_response(response_data)

    if response_text.is_empty():
        error_occurred.emit("Empty response from AI service")
        return

    var last_question = conversation_history[-1].content if conversation_history.size() > 0 else ""
    _add_to_history("assistant", response_text)
    response_received.emit(last_question, response_text)

func _parse_openai_response(data: Dictionary) -> String:
    """Parse OpenAI API response"""
    if data.has("choices") and data.choices.size() > 0:
        return data.choices[0].message.content
    return ""

func _parse_claude_response(data: Dictionary) -> String:
    """Parse Claude API response"""
    if data.has("content") and data.content.size() > 0:
        return data.content[0].text
    return ""

func _parse_gemini_response(data: Dictionary) -> String:
    """Parse Gemini API response"""
    if data.has("candidates") and data.candidates.size() > 0:
        var candidate = data.candidates[0]
        if candidate.has("content") and candidate.content.has("parts"):
            return candidate.content.parts[0].text
    return ""

func _on_gemini_response_received(response_text: String) -> void:
    """Handle response from GeminiAIService"""
    if response_text.is_empty():
        error_occurred.emit("Empty response from Gemini AI")
        return

    var last_question = conversation_history[-1].content if conversation_history.size() > 0 else ""
    _add_to_history("assistant", response_text)
    response_received.emit(last_question, response_text)

func _on_user_gemini_response(response_text: String) -> void:
    """Handle response from user's GeminiAI service"""
    if response_text.is_empty():
        error_occurred.emit("Empty response from user's Gemini AI")
        return

    var last_question = conversation_history[-1].content if conversation_history.size() > 0 else ""
    _add_to_history("assistant", response_text)
    response_received.emit(last_question, response_text)

func _on_user_gemini_error(error_message: String) -> void:
    """Handle error from user's GeminiAI service"""
    error_occurred.emit("Gemini API error: " + error_message)

# === CONVERSATION MANAGEMENT ===
func _add_to_history(role: String, content: String) -> void:
    """Add message to conversation history"""
    conversation_history.append({
        "role": role,
        "content": content,
        "timestamp": Time.get_unix_time_from_system()
    })

    # Limit history size
    if conversation_history.size() > max_conversation_history:
        conversation_history = conversation_history.slice(-max_conversation_history)

func _build_conversation_context() -> Array:
    """Build conversation context for API calls"""
    var messages = []

    # Add system prompt
    var system_prompt = educational_prompts.system_prompt
    if not current_structure.is_empty():
        system_prompt += " " + educational_prompts.structure_context_template.format({"structure_name": current_structure})

    messages.append({"role": "system", "content": system_prompt})

    # Add conversation history (if enabled)
    if enable_context_memory:
        for entry in conversation_history:
            if entry.role != "system": # Don't duplicate system messages
                messages.append({"role": entry.role, "content": entry.content})

    return messages

func _build_gemini_prompt(question: String) -> String:
    """Build prompt for Gemini API"""
    var prompt = educational_prompts.system_prompt

    if not current_structure.is_empty():
        prompt += " " + educational_prompts.structure_context_template.format({"structure_name": current_structure})

    prompt += "\n\nQuestion: " + question
    return prompt

# === UTILITY METHODS ===
func get_available_providers() -> Array:
    """Get list of available AI providers"""
    return AIProvider.keys()

func set_provider(provider: AIProvider) -> void:
    """Change AI provider"""
    ai_provider = provider
    print("[AI] Provider changed to: %s" % AIProvider.keys()[provider])

func is_api_key_configured() -> bool:
    """Check if API key is configured for current provider"""
    return not api_key.is_empty() or ai_provider == AIProvider.MOCK_RESPONSES

func get_service_status() -> Dictionary:
    """Get current service status"""
    var status = {
        "initialized": is_initialized,
        "provider": AIProvider.keys()[ai_provider],
        "api_configured": is_api_key_configured(),
        "current_structure": current_structure,
        "conversation_length": conversation_history.size()
    }
    
    # Add Gemini-specific status if using user's Gemini
    if ai_provider == AIProvider.GEMINI_USER and user_gemini_service:
        status["gemini_status"] = user_gemini_service.get_rate_limit_status()
    
    return status
