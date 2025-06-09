# AI Assistant & Gemini Integration Test Guide

## Overview
This guide explains how to test the AI Assistant integration with the user's Gemini API service in NeuroVis.

## Prerequisites
1. Launch the NeuroVis application
2. Press `F1` to open the debug console
3. Ensure you have your Gemini API key ready (if not already configured)

## Test Commands

### 1. Check AI Services Status
```
ai_status
```
This command shows:
- AIAssistant service status
- GeminiAI service status
- Setup completion status
- Rate limit information

### 2. Test Basic AI Assistant
```
ai_test
```
This command:
- Verifies AIAssistant service is available
- Shows current service configuration
- Tests with a sample question about the hippocampus
- Uses the current AI provider setting

### 3. Test Gemini Integration
```
ai_gemini_test
```
This command:
- Checks if GeminiAI service is available
- Verifies Gemini setup status
- Switches AI provider to GEMINI_USER
- Sends a test question via user's Gemini API
- Shows rate limit status

### 4. Setup Gemini (if needed)
```
ai_gemini_setup
```
This command opens the Gemini setup dialog where you can:
- Enter your API key
- Select model (gemini-pro recommended)
- Configure safety settings
- Test and save configuration

## Expected Results

### Successful Integration
When everything is working correctly, you should see:
1. ✅ AIAssistant service: ACTIVE
2. ✅ GeminiAI service: ACTIVE
3. ✅ Gemini is configured and ready
4. ✅ AI Response received with actual response text

### Common Issues

#### "GeminiAI service not found"
- The GeminiAI autoload may not be registered in project.godot
- Solution: Check that GeminiAI is in the autoload list

#### "Gemini needs setup"
- Your API key hasn't been configured yet
- Solution: Run `ai_gemini_setup` command

#### "Empty response from Gemini"
- API key might be invalid
- Rate limit might be exceeded
- Network connectivity issues

## Testing Workflow

1. **Initial Check**
   ```
   ai_status
   ```

2. **Setup Gemini (if needed)**
   ```
   ai_gemini_setup
   ```

3. **Test Integration**
   ```
   ai_gemini_test
   ```

4. **Interactive Testing**
   - Select a brain structure (right-click on 3D model)
   - Open AI panel in the UI
   - Ask questions about the selected structure
   - Verify responses are coming from Gemini

## Integration Points

### AIAssistantService Changes
- Added GEMINI_USER to AIProvider enum
- Integrated with user's GeminiAI service
- Handles response/error signals from GeminiAI
- Includes Gemini status in service status report

### Debug Commands Added
- `ai_test` - General AI Assistant test
- `ai_gemini_test` - Specific Gemini integration test
- `ai_status` - Comprehensive status check

## Troubleshooting

### Check Console Output
The debug console will show detailed information:
- Service initialization messages
- API request/response flow
- Error messages with context

### Verify Autoloads
```
test autoloads
```
This ensures all required services are loaded.

### Check Syntax
```
syntax_check
```
Verifies no syntax errors in core files.

## Next Steps

After successful testing:
1. The AI Assistant will use your Gemini API for all queries
2. You can ask educational questions about brain structures
3. The system will maintain conversation context
4. Rate limits are tracked to prevent overuse

## Notes

- The integration respects rate limits set by Google
- Responses are cached to minimize API calls
- Educational context is automatically included
- The system falls back to mock responses if Gemini is unavailable