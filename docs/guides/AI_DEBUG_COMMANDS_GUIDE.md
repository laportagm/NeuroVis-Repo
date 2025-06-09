# AI Debug Commands Guide

## Overview
This guide documents the new AI debug commands added to NeuroVis for testing and managing the AI Assistant and Gemini integration.

## How to Use Debug Commands
1. Launch NeuroVis
2. Press `F1` to open the debug console
3. Type the command and press Enter

## AI Assistant Commands

### `ai_status`
Shows the current status of the AI Assistant service.

**Output includes:**
- Provider name (e.g., MOCK_RESPONSES, GEMINI_USER)
- Initialization status
- API configuration status
- Current anatomical structure context (if any)
- Gemini rate limit info (if using GEMINI_USER provider)

**Example:**
```
ai_status
```

### `ai_provider [provider_name]`
Changes the AI provider used by the AI Assistant.

**Available providers:**
- `openai` - OpenAI GPT
- `claude` - Anthropic Claude
- `gemini` - Google Gemini (built-in)
- `gemini_user` - User's own Gemini API key
- `mock` - Mock responses for testing

**Example:**
```
ai_provider gemini_user
```

### `ai_test [question]`
Tests the AI Assistant with a question. If no question is provided, uses "What is the hippocampus?" as default.

**Examples:**
```
ai_test
ai_test "What are the functions of the amygdala?"
```

## Gemini-Specific Commands

### `ai_gemini_status`
Shows detailed status of the GeminiAI service.

**Output includes:**
- Setup completion status
- Rate limit usage (used/limit)
- Time until rate limit reset
- API key configuration status

**Example:**
```
ai_gemini_status
```

### `ai_gemini_setup`
Opens the Gemini setup dialog to configure your API key and settings.

**Note:** This command attempts to open the setup dialog. If it fails, you may need to restart the application and configure Gemini through the main interface.

**Example:**
```
ai_gemini_setup
```

### `ai_gemini_reset`
Resets all Gemini configuration settings. Use this if you need to reconfigure your API key or if you're experiencing issues.

**Example:**
```
ai_gemini_reset
```

## Typical Workflow

1. **Check initial status:**
   ```
   ai_status
   ai_gemini_status
   ```

2. **Configure Gemini (if needed):**
   ```
   ai_gemini_setup
   ```

3. **Set AI provider to use your Gemini API:**
   ```
   ai_provider gemini_user
   ```

4. **Test the integration:**
   ```
   ai_test "Hello, can you respond?"
   ```

5. **Verify status after testing:**
   ```
   ai_status
   ai_gemini_status
   ```

## Troubleshooting

### "AI Assistant service not found"
- The AIAssistant autoload may not be registered
- Check project.godot for AIAssistant in the autoload section

### "GeminiAI service not found"
- The GeminiAI autoload may not be registered
- Check project.godot for GeminiAI in the autoload section

### "Cannot open setup dialog from here"
- The setup dialog requires the main scene to be loaded
- Restart the application and try again

### Rate limit errors
- Check `ai_gemini_status` to see rate limit usage
- Wait for the reset time shown
- Consider implementing caching to reduce API calls

## Integration Notes

- The AI Assistant automatically includes anatomical structure context when available
- Responses are logged to the debug console with truncation for long responses
- Error messages are shown in red for easy identification
- Success messages are shown in green
- All commands support the standard debug console color formatting

## Related Commands

- `test autoloads` - Verify all autoload services are loaded
- `tree /root` - Show scene tree to find services
- `help` - Show all available debug commands