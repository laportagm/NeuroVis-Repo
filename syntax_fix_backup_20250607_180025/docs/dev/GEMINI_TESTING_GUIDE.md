# Gemini AI Integration Testing Guide

This document provides step-by-step instructions for manually testing the Gemini AI integration in NeuroVis.

## Prerequisites

- NeuroVis application with Gemini integration installed
- Google Gemini API key (get one from https://ai.google.dev/)
- Internet connection for API communication

## Testing Process

### 1. Verify Autoload Services

1. Launch NeuroVis
2. Open the debug console (press F1)
3. Type `tree` and press Enter
4. Verify that both of these nodes appear in the tree:
   - `/root/AIAssistant` - The main AI assistant service
   - `/root/GeminiAI` - The Gemini service

### 2. Test AI Provider Selection

1. Open the AI Assistant panel in the UI
2. Look for the "AI Provider" dropdown at the top of the panel
3. Verify that "GEMINI_USER" appears in the dropdown
4. Select "GEMINI_USER" from the dropdown
5. Verify that the setup dialog appears (if not already configured)

### 3. Test Gemini Setup Dialog

1. When the setup dialog appears:
   - Verify all UI elements are displayed properly
   - Verify the API key input field is present
   - Verify the model selection dropdown has Gemini models
   - Verify advanced options appear (if enabled)
   - Verify safety settings appear (if enabled)

2. Test API key validation:
   - Enter your Google Gemini API key
   - Click "Validate Key"
   - Verify validation process works (shows success or error)

3. Test configuration saving:
   - Select a model (e.g., "gemini-pro")
   - Adjust any advanced settings if desired
   - Click "Save Configuration"
   - Verify the dialog closes and returns to the AI panel

### 4. Test Gemini Model Selector

1. After setting up, verify the Gemini model selector appears in the AI panel
2. Click the dropdown and verify all models are listed
3. Select different models and verify the selection changes
4. Click the settings button and verify it opens the setup dialog again

### 5. Test Question Asking

1. Type a question about brain anatomy in the input field, e.g., "What is the function of the hippocampus?"
2. Press Send or hit Enter
3. Verify that:
   - The question appears in the chat as your message
   - A loading indicator or "thinking" message appears
   - After a short delay, an answer is received from Gemini
   - The answer appears in the chat with proper formatting

### 6. Test Structure-Specific Questions

1. Select a brain structure in the 3D model (right-click)
2. Verify that the context in the AI panel updates to show the selected structure
3. Click one of the quick question buttons (Function, Location, etc.)
4. Verify that the question is automatically sent with the structure context
5. Verify that the response addresses the specific structure

### 7. Test Error Handling

1. Test API key validation failure:
   - Open the setup dialog again
   - Enter an invalid API key (too short or incorrect format)
   - Click "Validate Key"
   - Verify an appropriate error message is shown

2. Test network failure (if possible):
   - Disable your internet connection
   - Ask a question
   - Verify an appropriate error message is shown
   - Re-enable your internet connection

3. Test rate limiting (optional):
   - Send multiple questions in rapid succession
   - Verify rate limit tracking works
   - If rate limit is reached, verify appropriate message is shown

### 8. Test UI Responsiveness

1. Resize the AI panel window
2. Verify that the UI components adjust properly
3. Open and close the panel multiple times
4. Verify that the state is maintained between openings

## Expected Results

- ✅ GeminiAI service initializes on startup
- ✅ Setup dialog appears when first selecting Gemini
- ✅ API key validation works correctly
- ✅ Model selection changes are reflected in the service
- ✅ Questions receive appropriate educational responses
- ✅ Structure context is properly passed to questions
- ✅ Error handling provides clear feedback
- ✅ UI is responsive and maintains state

## Reporting Issues

If you encounter any issues during testing, please record:

1. Steps to reproduce the issue
2. Expected behavior
3. Actual behavior
4. Screenshots if applicable
5. Console output or error messages

## Test Completion

Once all tests have been completed successfully, the Gemini AI integration can be considered verified and ready for educational use.

---

Created for NeuroVis Educational Platform - 2024