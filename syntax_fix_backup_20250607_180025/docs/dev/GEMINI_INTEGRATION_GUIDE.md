# Google Gemini AI Integration Guide for NeuroVis

This guide documents the integration of Google Gemini AI into the NeuroVis educational platform. The implementation provides an alternative AI provider option for the anatomical assistant features.

## Overview

Google Gemini AI integration adds a powerful alternative to the existing AI assistant functionality, allowing educators and students to utilize Google's advanced large language models for educational neuroanatomy assistance.

## Architecture Overview

The Gemini integration consists of several key components that work together to provide a seamless AI experience for neuroanatomy education:

1. **Core Service**: `GeminiAIService` class (autoloaded as `GeminiAI`)
2. **UI Components**: 
   - `GeminiModelSelector` - Model selection dropdown
   - `GeminiSetupDialog` - API key configuration dialog
3. **Integration Layer**: Integration with existing `AIAssistantService`

```
┌─────────────────────┐      ┌──────────────────────┐
│                     │      │                      │
│  AIAssistantPanel   │◄─────┤   AIAssistantService │
│  (User Interface)   │      │   (Service Facade)   │
│                     │      │                      │
└────────┬────────────┘      └──────────┬───────────┘
         │                              │
         │                              │
         │                              ▼
┌────────▼────────────┐      ┌──────────────────────┐
│                     │      │                      │
│ GeminiModelSelector │◄─────┤    GeminiAIService   │
│ GeminiSetupDialog   │      │    (Core Service)    │
│                     │      │                      │
└─────────────────────┘      └──────────────────────┘
```

### Key Files

1. **`core/ai/GeminiAIService.gd`** - Core service that handles Gemini API communications
2. **`ui/panels/GeminiSetupDialog.gd`** - Configuration dialog for API keys and model settings  
3. **`ui/components/controls/GeminiModelSelector.gd`** - UI component for model selection
4. **Existing files with Gemini integration**:
   - `core/ai/AIAssistantService.gd` - Updated with Gemini integration
   - `ui/components/panels/AIAssistantPanel.gd` - Updated with provider selection UI

## Implementation Details

### GeminiAIService

The `GeminiAIService` class provides a dedicated service for interacting with Google's Gemini API. Key features include:

- API key validation and secure storage
- Model selection (Gemini Pro, Pro Vision, Flash)
- Safety settings configuration
- Temperature and output token control
- HTTP request handling and response parsing
- Built-in rate limiting (60 requests per minute)

```gdscript
# Example: Using the GeminiAI autoload
var response = await GeminiAI.ask_question(
    "What is the function of the hippocampus?",
    {"structure": "hippocampus"}
)

# Example: Validating API key
var success = await GeminiAI.setup_api_key("YOUR_API_KEY")
if success:
    print("API key configured successfully")

# Example: Generating content
var explanation = GeminiAI.generate_content(
    "Explain the role of the hippocampus in memory formation"
)
```

### GeminiSetupDialog (Streamlined)

The `GeminiSetupDialog` has been redesigned as a streamlined, user-friendly interface optimized for medical students and educational users:

- 4-state flow designed for simplicity and speed
- Consumer-friendly language (no technical jargon)
- Auto-validation of API keys
- Educational defaults for optimal learning
- WCAG 2.1 AA accessibility compliance
- Theme adaptation for both Enhanced and Minimal educational modes
- Reduced setup time (<30 seconds vs. previous 5+ minutes)

#### State Machine Flow

The dialog implements a simple 4-state flow:

1. **INITIAL**: Welcome screen with educational context
2. **GOOGLE_CONSOLE**: Browser integration with guidance for key creation
3. **RETURN_WITH_KEY**: API key input with auto-validation
4. **SUCCESS**: Celebration screen with educational examples

```gdscript
# Example: Showing the setup dialog
var setup_dialog = GeminiSetupDialog.new()
add_child(setup_dialog)
setup_dialog.setup_completed.connect(_on_setup_completed)
setup_dialog.show_dialog()

# Handling setup completion
func _on_setup_completed(successful: bool, api_key: String) -> void:
    if successful:
        print("Gemini setup completed successfully")
    else:
        print("Gemini setup failed")
```

### GeminiModelSelector

The `GeminiModelSelector` is a reusable UI component that:
- Displays available Gemini models in a dropdown
- Shows connection status with a color indicator
- Provides a settings button to open configuration dialog
- Automatically synchronizes with the GeminiAIService

```gdscript
# Example: Adding the model selector to your UI
var selector = GeminiModelSelector.new()
add_child(selector)

# Connect signals
selector.model_changed.connect(_on_model_changed)
selector.settings_requested.connect(_on_settings_requested)
```

### AIAssistantPanel Integration

The `AIAssistantPanel` has been enhanced to support provider switching between different AI backends:

- Provider selection dropdown
- Gemini-specific model selector
- Seamless integration with existing chat functionality
- Automatic dialog for first-time Gemini setup

## User API Key Setup

The Gemini integration uses the user's own API key rather than a centralized key. This design provides several benefits:

1. **User Privacy**: Processing happens directly between user and Google
2. **Cost Control**: Users manage their own API usage and billing
3. **Sustainability**: Not dependent on a centralized API budget
4. **Customization**: Users can configure their own models and settings

### Setup Process

1. User selects "GEMINI_USER" as AI provider in the assistant panel
2. System detects no API key is configured
3. `GeminiSetupDialog` is displayed
4. User enters their API key (obtained from Google AI Studio)
5. Key is validated against the Gemini API
6. On success, key is encrypted and stored locally

## Configuration & Storage

### User Settings

The Gemini API configuration is stored securely:

- File: `user://gemini_settings.dat`
- Encryption: Encrypted using device unique ID
- Contents:
  - API key (encrypted in storage)
  - Selected model (via internal state)
  - Generation parameters
  - Safety settings

### Configuration Security

The API key is:
- Stored only on the user's local device
- Never transmitted except to Google's API
- Shown in masked form in the UI ("configured" placeholder)
- Encrypted with device-specific encryption

## Integration with AIAssistantService

The Gemini integration plugs into the existing AIAssistantService through:

1. **Provider Enumeration**: Added as `GEMINI_USER` provider option
2. **Service Detection**: Automatic detection of available GeminiAI service
3. **Request Routing**: Questions routed to GeminiAI when selected
4. **Fallback Mechanism**: Falls back to mock responses if configuration fails

```gdscript
# In AIAssistantService.gd
func _send_user_gemini_request(question: String) -> void:
    if not user_gemini_service:
        error_occurred.emit("User's Gemini AI service not available")
        _handle_mock_response(question) # Fallback to mock
        return
        
    if not user_gemini_service.check_setup_status():
        error_occurred.emit("Gemini AI needs setup")
        return
    
    # Create context with current structure
    var context = {}
    if not current_structure.is_empty():
        context["structure"] = current_structure
    
    # Send request using user's Gemini service
    user_gemini_service.ask_question(question, context)
```

## Adding Gemini to Autoload

For global access to the Gemini service, it is added as an autoload in `project.godot`:

```
[autoload]
GeminiAI="*res://core/ai/GeminiAIService.gd"
```

## Usage Guide

### For Educational Platform Users

1. Open the AI Assistant panel
2. Select "GEMINI_USER" from the provider dropdown
3. Enter your API key in the setup dialog that appears
4. Select desired model and settings
5. Begin asking questions about neuroanatomy

### For Developers

#### Using the GeminiAI Service

```gdscript
# Access as global singleton
var gemini = get_node_or_null("/root/GeminiAI")
if gemini and gemini.is_api_key_valid():
    # Ask a question with educational context
    var response = await gemini.ask_question(
        "What are the primary connections of the amygdala?",
        {"structure": "amygdala"}
    )
    
    # Update model configuration
    gemini.set_model(GeminiAIService.GeminiModel.GEMINI_PRO)
    
    # Monitor rate limits
    var limits = gemini.get_rate_limit_status()
    print("Requests used: %d/%d" % [limits.used, limits.limit])
```

## Error Handling

The integration includes comprehensive error handling:

1. **API Key Validation**: Checks before allowing operations
2. **Network Failures**: Graceful handling of connection issues
3. **Rate Limiting**: Proactive prevention of limit exceeding
4. **Response Validation**: Ensuring valid responses before processing
5. **UI Feedback**: Clear error messages for user troubleshooting

Error messages are emitted through the `error_occurred` signal for various failure scenarios:

- Invalid API key format
- Authentication failures
- Network connectivity issues
- Rate limit exceeded
- Malformed responses

## API Reference

### GeminiAIService

**Signals**:
- `response_received(response)` - Emitted when response is received
- `error_occurred(error)` - Emitted when an error occurs
- `rate_limit_updated(used, limit)` - Emitted when rate limit changes
- `setup_completed()` - Emitted when setup is completed
- `api_key_validated(success, message)` - Emitted after key validation
- `model_list_updated(models)` - Emitted when model list is updated
- `config_changed(model_name, settings)` - Emitted when configuration is changed

**Methods**:
- `setup_api_key(key)` - Sets up and validates API key
- `ask_question(question, context)` - Sends question to Gemini API
- `check_setup_status()` - Checks if Gemini is set up
- `needs_setup()` - Checks if setup is needed
- `is_api_key_valid()` - Checks if API key is valid
- `get_api_key()` - Gets the API key (masked)
- `validate_api_key(key)` - Validates API key and emits result
- `get_model_name()` - Gets current model name
- `get_model_list()` - Gets available models
- `update_available_models()` - Updates list of available models
- `set_model(model_name_or_id)` - Sets model by name or enum value
- `get_configuration()` - Gets current configuration
- `save_configuration(key, model)` - Saves configuration
- `set_safety_settings(settings)` - Updates safety settings
- `get_safety_settings()` - Gets current safety settings
- `generate_content(prompt)` - Generates content with specified prompt
- `reset_settings()` - Clears API key and settings
- `get_rate_limit_status()` - Gets current rate limit status

### GeminiSetupDialog

**Signals**:
- `setup_completed(successful, api_key)` - Emitted when setup is completed
- `setup_cancelled()` - Emitted when setup is cancelled

**Methods**:
- `show_dialog()` - Shows the setup dialog

### GeminiModelSelector

**Signals**:
- `model_changed(model_name)` - Emitted when model is changed
- `settings_requested()` - Emitted when settings button is pressed

**Methods**:
- `get_current_model()` - Gets currently selected model
- `set_model(model_name)` - Sets model by name
- `refresh_status()` - Refreshes status indicator

## Performance Considerations

1. **Response Size**: Default max_tokens set to 2048 to balance detail and speed
2. **Request Throttling**: Rate limit tracking prevents API abuse
3. **Connection Timeouts**: 30-second timeout for slow connections
4. **UI Responsiveness**: Async operations to prevent blocking main thread

## Educational Context

This integration specifically enhances the educational capabilities of NeuroVis by:

1. **Improved Accuracy**: Gemini models offer advanced knowledge of neuroanatomy
2. **Tailored Educational Responses**: Specialized prompt building for neuroanatomy education
3. **Structure-specific Context**: Integration with the current selected brain structure
4. **Educational Consistency**: Maintains educational focus in AI interactions

## Future Enhancements

Planned improvements for the Gemini integration:

1. **Streaming Responses**: Implementing incremental response display
2. **Vision Support**: Adding image analysis with gemini-pro-vision model
3. **Conversation Memory**: Enhanced context preservation between questions
4. **Model Switching**: Dynamic model selection based on question complexity
5. **Educational Metrics**: Analytics on question types and response quality

## Troubleshooting

Common issues and solutions:

### Common Issues

1. **API Key Invalid**
   - Verify key was copied correctly from Google AI Studio
   - Check that the key has been activated
   - Ensure rate limits haven't been exceeded

2. **No Response from API**
   - Check internet connection
   - Verify firewall settings
   - Check if rate limits are reached

3. **Model Not Available**
   - Some models may be region-restricted
   - Check if the model is deprecated or in limited preview

### Logging

Diagnostic information is logged with the prefix `[GeminiAI]` for easier filtering and troubleshooting.

---

## Educational Impact

The Google Gemini integration enhances NeuroVis as an educational platform by providing:

1. **Choice of AI providers** for different educational needs and preferences
2. **Advanced neuroanatomical knowledge** through state-of-the-art language models
3. **Optimized educational defaults** for appropriate learning content
4. **Consistent educational experience** across different AI backends

### Enhanced Educational Focus

The streamlined setup process significantly improves the educational experience:

1. **Reduced Cognitive Load**: The simplified 4-state flow allows students to focus on learning anatomy, not configuring AI
2. **Faster Time-to-Value**: <30 seconds from launch to educational assistance (vs. previous 5+ minutes)
3. **Confidence Building**: Success celebration reinforces student's progress
4. **Learning Focus**: All UI elements emphasize educational value, not technical details
5. **Accessibility**: WCAG 2.1 AA compliance ensures all students can access the educational value

### Educational Workflows

The redesigned integration enhances specific educational workflows:

#### Anatomy Exploration Workflow

1. Student selects a brain structure using right-click
2. Information panel displays basic anatomical information
3. Student can ask Gemini AI specific questions about the structure
4. AI provides educational context, clinical relevance, and functional information

#### Clinical Correlation Workflow

1. Student views a structure associated with specific neurological conditions
2. Student can ask Gemini AI about pathologies related to this structure
3. AI provides educational information about related clinical conditions
4. Student gains understanding of the anatomical basis of neurological disorders

#### Comparative Learning Workflow

1. Student selects multiple structures to compare
2. Student can ask Gemini AI about relationships between these structures
3. AI provides information about functional connections and anatomical relationships
4. Student develops a more integrated understanding of brain systems

### Educational Value Examples

Students can ask questions like:

- "What are the main functions of the hippocampus?"
- "How does damage to the basal ganglia affect movement?"
- "Explain the relationship between the thalamus and cerebral cortex"
- "What blood vessels supply the brainstem?"
- "What symptoms would result from damage to the corpus callosum?"

This integration maintains the educational focus of NeuroVis while expanding its AI capabilities for more comprehensive neuroanatomy learning support.

---

Created for NeuroVis Educational Platform - 2024