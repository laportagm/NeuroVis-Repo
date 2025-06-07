# Google Gemini AI Integration for NeuroVis

This document describes the implementation of the Google Gemini AI service in NeuroVis, focusing on the new simplified `GeminiAI` global service.

## Overview

The Google Gemini AI integration provides an alternative AI provider for the NeuroVis educational platform's neuroanatomy assistance features. This implementation focuses on simplicity, performance, and user privacy.

## Key Files

- **`core/ai/GeminiAIService.gd`** - Core service for Gemini API communication (available as `GeminiAI` singleton)
- **`project.godot`** - Contains the autoload configuration for the GeminiAI service

## Features

- **API Key Management**
  - Secure, encrypted local storage
  - Validation against the Gemini API
  - No hardcoded keys or credentials

- **Rate Limiting**
  - Built-in rate limit tracking (60 requests per minute)
  - Automatic reset mechanism
  - User feedback on limits

- **Educational Context**
  - Specialized prompt building for neuroanatomy
  - Structure-specific context injection
  - Educational focus for medical students

- **Error Handling**
  - Comprehensive HTTP error management
  - Response validation
  - Clear error reporting via signals

## Usage Guide

### Basic Usage

```gdscript
# Check if setup is needed
if GeminiAI.needs_setup():
    # Show setup UI to user
    show_api_key_dialog()
else:
    # Use the service
    var response = await GeminiAI.ask_question(
        "Explain the function of the hippocampus",
        {"structure": "hippocampus"}
    )
```

### Setting Up the API Key

```gdscript
# When user provides their API key
func _on_api_key_submitted(api_key: String):
    var success = await GeminiAI.setup_api_key(api_key)
    if success:
        show_success_message("Gemini AI configured successfully!")
    else:
        show_error_message("Failed to configure Gemini AI. Please check your API key.")
```

### Connecting to Signals

```gdscript
func _ready():
    # Connect to signals
    GeminiAI.response_received.connect(_on_ai_response)
    GeminiAI.error_occurred.connect(_on_ai_error)
    GeminiAI.rate_limit_updated.connect(_on_rate_limit_changed)
    
func _on_ai_response(response: String):
    # Handle the AI response
    display_response(response)
    
func _on_ai_error(error: String):
    # Handle errors
    show_error_notification(error)
    
func _on_rate_limit_changed(used: int, limit: int):
    # Update UI showing rate limit
    update_rate_limit_indicator(used, limit)
```

### Rate Limit Monitoring

```gdscript
func check_rate_limits():
    var status = GeminiAI.get_rate_limit_status()
    
    # Show in UI
    rate_label.text = "Requests: %d/%d - Reset in %d seconds" % [
        status.used,
        status.limit,
        status.reset_in
    ]
```

## Integration with Existing AI System

The `GeminiAI` service can be used alongside the existing `AIAssistant` service. While `AIAssistant` provides a unified interface for multiple AI providers, the `GeminiAI` service offers a simpler, direct implementation focused specifically on Google Gemini.

### Comparison with Existing AIAssistantService

| Feature | GeminiAI | AIAssistant |
|---------|----------|-------------|
| Focus | Google Gemini only | Multiple AI providers |
| API Key | User provides own | Centralized API key |
| Storage | Encrypted local file | ConfigFile |
| Rate Limiting | Built-in tracking | Not implemented |
| Complexity | Simple, focused | More complex, flexible |

## Security Considerations

1. **API Key Storage**
   - Keys are stored in an encrypted file using the device's unique ID as the encryption key
   - Keys are never transmitted to any server except Google's API

2. **User Privacy**
   - All processing happens directly between the user's device and Google's API
   - No intermediary servers or logging

3. **Rate Limiting**
   - Prevents accidental API abuse
   - Protects user from unexpected usage charges

## Error Handling

The service emits descriptive error messages through the `error_occurred` signal for various failure scenarios:

- Invalid API key format
- Authentication failures
- Network connectivity issues
- Rate limit exceeded
- Malformed responses

## Implementation Details

### Request Flow

1. User asks question through UI
2. Question is passed to `GeminiAI.ask_question()`
3. Service builds educational prompt with context
4. HTTP request is made to Google Gemini API
5. Response is parsed and returned through signal or awaitable

### Response Parsing

The service handles the specific JSON format of the Gemini API, extracting the content from:

```
response.candidates[0].content.parts[0].text
```

## Testing

To verify the integration is working:

1. Ensure the autoload is properly registered in project.godot
2. Check the console for the "[GeminiAI] Service initialized" message on startup
3. Try setting up with a test API key and verify validation
4. Send a test question and check the response

## Limitations

- Currently only supports the gemini-pro model
- No streaming support for partial responses
- No image input support (gemini-pro-vision model not yet implemented)

## Future Enhancements

- Add support for streaming responses
- Implement gemini-pro-vision for image analysis
- Add user preference for model selection
- Implement content safety configuration options

---

Created for NeuroVis Educational Platform - 2024