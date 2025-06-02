# AI Modularity for Building: AI-Enhanced Brain Anatomy Visualizer (Desktop)

**Version:** 0.1
**Date:** May 15, 2025
**Project Phase:** Initial Planning & Phase 1 Start
**Location:** Ardmore, Pennsylvania, United States

## 1. Introduction

This document outlines the philosophy and practical strategies for leveraging AI assistants (Claude Max, Gemini Advanced, ChatGPT Pro) as collaborative partners in the solo development of the Brain Anatomy Visualizer. The approach emphasizes modularity in task breakdown, code design, and AI interaction to maximize efficiency, learning, and maintainability for a developer with limited prior programming experience.

## 2. Core Philosophy: AI as a "Smart Junior Developer & Tutor"

- AI assistants will not "build the app" autonomously. The developer drives the project.
- AI will be used for specific, well-defined tasks: code generation, debugging, explanation, research, refactoring, documentation drafting.
- The developer is responsible for understanding, integrating, testing, and refining all AI-generated contributions.
- AI interaction is a learning opportunity to grasp new concepts and coding patterns.

## 3. Modular Task Breakdown for AI Collaboration

To effectively use AI, features and development phases will be decomposed into small, manageable, and clearly defined tasks.

- **Principle:** Instead of asking "Build the 3D selection feature," break it down:
  1.  "Explain raycasting in [Three.js/Godot] for a beginner."
  2.  "Write a [JS/GDScript] function to get normalized mouse coordinates on canvas click."
  3.  "Show me how to set up a Raycaster and perform an intersection test with scene objects in [Three.js/Godot]."
  4.  "Write a function to change the material color of a clicked mesh in [Three.js/Godot]."
  5.  "How do I revert the material of a previously selected object?"
- **Benefit:** Smaller tasks yield more accurate and usable AI responses. Easier for the developer to understand and integrate. Allows for iterative testing.

## 4. Structuring Prompts for Effective AI Code Generation

- **Provide Context:**
  - **Project Goal:** Briefly mention "for my Brain Anatomy Visualizer desktop app."
  - **Technology Stack:** Specify "using Electron with Three.js" or "using Godot Engine with GDScript."
  - **Current Code (If any):** Paste relevant existing functions or a summary of the setup.
  - **Desired Outcome:** Clearly state what the code should do.
- **Specify Inputs & Outputs:** For functions, define what parameters it takes and what it should return.
- **Ask for Explanations:** _Always_ request explanations, especially for new concepts or complex logic: "Please explain this generated code, particularly [specific part]."
- **Request Alternatives:** "Is there a simpler or more idiomatic way to achieve this in [language/framework]?"
- **Specify Constraints:** "Keep the solution suitable for a beginner," or "Avoid using advanced library X for now."

## 5. Managing AI-Generated Code

1.  **Review & Understand:**
    - Read through the generated code carefully. Does it make logical sense?
    - Ask the AI to clarify any parts you don't understand _before_ integrating.
2.  **Integrate Thoughtfully:**
    - Don't just copy-paste. Adapt variable names, ensure it fits your existing code structure.
    - Start by integrating small pieces.
3.  **Test Rigorously:**
    - Manually test the functionality the code is supposed to provide.
    - Check for edge cases or unintended side effects.
4.  **Debug (with AI help):**
    - If issues arise, provide the AI with your integrated code, the AI's original suggestion (if different), and the error message or observed misbehavior.
5.  **Refactor (Iterative Improvement):**
    - Once working, you can ask AI: "Can this AI-generated function be made cleaner or more efficient?" or "Are there any potential bugs in this AI-generated code I should be aware of?"

## 6. Modular Code Design Principles (Aiding AI and Maintainability)

Adopting these principles will make it easier for AI to generate useful code and for you to manage the project solo:

- **Single Responsibility Principle (SRP):**
  - Each function, class, or script should do _one thing_ well.
  - _Benefit:_ Easier to prompt AI for ("Write a function that _only_ handles mouse click to world coordinate conversion"). Easier to test and debug.
- **Clear Function Signatures/Interfaces:**
  - Well-defined inputs (parameters) and outputs (return values).
  - _Benefit:_ AI can easily understand how to call your functions or how its generated function should behave.
- **Avoid Deep Nesting & Overly Complex Logic:**
  - Break complex operations into smaller helper functions.
  - _Benefit:_ Simpler for AI to generate and for you to understand.
- **Meaningful Naming:** Use clear names for variables, functions, files, and (in Godot) nodes.
- **Configuration over Hardcoding:**
  - For values that might change (e.g., API keys, default colors, file paths), consider loading them from a configuration file or constants module rather than hardcoding them everywhere.
  - _Benefit:_ Easier to change later. AI can help create scripts to read/write config files.
- **Event-Driven Architecture (where appropriate):**
  - **Electron:** Uses DOM events, Node.js events, and IPC messages between main/renderer.
  - **Godot:** Uses Signals extensively.
  - _Benefit:_ Decouples components. AI can help "Write a function that emits a signal when X happens" or "How do I listen for Y event and call a function?"

## 7. Modular Design for In-App AI Features

If/when building the in-app AI features (that call an online API):

- **Isolate AI Interaction Logic:** Create a specific module/class/script (e.g., `AIService.js` or `ai_service.gd`) responsible for:
  - Formatting prompts.
  - Making HTTP API calls to the LLM.
  - Handling API responses (parsing JSON, error checking).
  - Managing API keys (if applicable, and with security considerations from `TECHNICAL_SPECIFICATIONS.md`).
- **Define a Clear Interface:** This module should expose simple functions to the rest of the app, e.g.:
  - `async function getExplanationForStructure(structureName): string`
  - `async function answerQuestion(questionText, contextStructureName): string`
- **Benefits:**
  - The rest of your application doesn't need to know the specifics of the LLM API.
  - Easier to change LLM providers or API endpoints later by only modifying this module.
  - Easier to ask AI for help: "My `AIService.js` module needs to make a POST request to [API_URL]...".

## 8. Iterative Loop with AI Assistants

Embrace an iterative development cycle for each small feature or function:

1.  **Define:** Clearly define the small piece of functionality you need.
2.  **Prompt AI:** Craft a specific prompt to an AI assistant.
3.  **Receive & Review:** Analyze the AI's suggestion (code, explanation).
4.  **Integrate & Test:** Add it to your project and test it thoroughly.
5.  **Debug/Refine (with AI):** If it doesn't work or isn't quite right, go back to the AI with more specific feedback, error messages, or refinement requests.
6.  **Learn:** Ask the AI to explain any parts you found confusing or new.
7.  **Commit:** Once working and understood, commit to Git.
8.  **Repeat:** Move to the next small piece.

## 9. Using Different AIs for Different Strengths

You have access to Claude Max, Gemini Advanced, and ChatGPT Pro. You might find:

- One is better at generating boilerplate for a specific framework.
- Another excels at debugging or explaining complex concepts.
- A third might be great for brainstorming UI ideas or drafting text content.
- Experiment and use them to complement each other. You can even present a problem to multiple AIs to see different approaches.

## 10. Version Control as a Critical Safeguard

- **Commit Before Integrating:** Always commit your _working_ project to Git _before_ pasting in or trying to integrate significant new code, especially AI-generated code.
- **Branch for Experiments:** If trying a complex AI suggestion that might break things, consider creating a new Git branch first. You can easily discard the branch if it doesn't work out.

By structuring your approach this way, you can make the AI assistants powerful extensions of your own development capabilities, facilitating both the building process and your learning journey.

---
