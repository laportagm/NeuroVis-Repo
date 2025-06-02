DEVELOPMENT_PLAN_AND_PROCESS.md

# Development Plan & Process: AI-Enhanced Brain Anatomy Visualizer (Desktop)

**Version:** 0.1
**Date:** May 15, 2025

## 1. Development Philosophy

- **Solo Developer:** The project will be undertaken by a single developer.
- **AI-Assisted:** Heavy reliance on AI assistants (Claude Max, Gemini Advanced, ChatGPT Pro) for:
  - Code generation, explanation, and debugging.
  - Researching technologies, libraries, and best practices.
  - Drafting documentation and content outlines.
  - Brainstorming solutions to technical challenges.
- **Incremental & Iterative:** Development will proceed in phases, with each phase building a small, working increment of the application. Functionality will be added iteratively.
- **Low-Cost/Free:** Focus on using free and open-source tools, libraries, and services. Free tiers of any necessary APIs will be prioritized. The end application will be free for users.
- **Beginner-Focused Learning:** The process is a learning opportunity for the developer, emphasizing understanding over speed where necessary.
- **Focus on Maintainability:** Code should be kept as clean, simple, and well-documented as possible for easier solo maintenance.

## 2. Phase-Based Roadmap Overview

The project will be developed through the following key phases:

- **Phase 0: Foundation & Focused Setup (Completed)**
  - Goal: Essential tools in place, core tech choices explored (Electron vs. Godot), initial assets identified, project structure initiated on macOS.
- **Phase 1: Core 3D Visualization & Basic Interaction**
  - Goal: Render 3D model, implement camera controls, enable click-to-select/highlight of model parts, display static name of selected part.
- **Phase 2: Basic Information Display & Local Knowledge Base v0.1**
  - Goal: Display more detailed information (name, description, functions) for selected structures from a local, manually curated JSON knowledge base.
- **Phase 3: In-App AI via Online API (Simple Q&A)**
  - Goal: Integrate a free-tier online LLM API to answer simple questions about selected structures or provide dynamic explanations. Requires internet.
- **Phase 4: Packaging and Distribution Prep**
  - Goal: Create functional, installable versions of the application for Windows and macOS. Set up a simple download page.
- **Phase 5: Refinement & Initial Content Expansion**
  - Goal: Improve UI/UX based on self-testing, significantly expand the local knowledge base content (more structures, detailed info), refine AI prompts.
- **Phase 6+: Advanced Features & Iteration (Post-MVP)**
  - Goal: Based on feedback and feasibility, explore "Nice-to-Have" features like pathway visualization, text/voice input for AI, improved offline fallbacks, etc.

## 3. Role of AI Assistants (Claude Max, Gemini Advanced, ChatGPT Pro)

AI assistants are integral to every step:

- **Planning & Design:** Brainstorming features, outlining UI/UX, suggesting data structures.
- **Research:** Comparing libraries, finding documentation, understanding new concepts.
- **Code Generation:** Generating boilerplate code, specific functions, UI components, and scripts in the chosen language (JavaScript/GDScript/C#).
- **Code Explanation:** Explaining generated code or existing code snippets line-by-line.
- **Debugging:** Analyzing error messages, suggesting fixes for problematic code.
- **Refactoring & Optimization:** Suggesting improvements for cleaner, more efficient code (within beginner scope).
- **Testing Ideas:** Suggesting simple ways to test functions or UI interactions.
- **Documentation:** Assisting in drafting README files, code comments, and summaries.
- **Learning:** Acting as a Socratic tutor to help the developer understand underlying principles.

**Process for using AI:**

1.  Define a small, specific task.
2.  Formulate a clear prompt, providing context (project, language, current code if any).
3.  Evaluate the AI's response critically.
4.  Ask for clarifications or iterate on the response.
5.  Integrate and test the AI-assisted solution.
6.  Ask the AI to explain any parts that are not fully understood.

## 4. Version Control Strategy

- **Tool:** Git.
- **Hosting:** Private repository on GitHub or GitLab.
- **Frequency:** Commit frequently – after every small, logical, working change (e.g., "Implemented model loading," "Fixed camera zoom bug").
- **Commit Messages:** Write clear, concise commit messages describing the change.
- **Branching (Simplified for Solo):** Work primarily on the `main` (or `master`) branch for simplicity. Consider feature branches for larger, experimental changes that might be risky, merging back to `main` when stable.
- **Tagging:** Use Git tags to mark releases or significant milestones (e.g., `v0.1-phase1-complete`).

## 5. Testing & Debugging Approach

- **Manual Testing:** Thoroughly test all implemented features manually after each incremental change, on the development OS (macOS) and periodically on a target OS (Windows, via VM or dual boot if possible).
- **Debugging Tools:**
  - **Electron:** Electron Developer Tools (Console for logs/errors, Sources for breakpoints, Elements for UI inspection).
  - **Godot:** Built-in debugger (Debugger panel for output/errors, script editor for breakpoints, Remote Scene Tree for inspecting live scene).
- **Logging:** Use `console.log()` (JavaScript) or `print()` (GDScript) extensively during development to trace execution and variable states. Remove or comment out excessive logs before "release" builds.
- **Error Handling:** Implement basic `try...catch` (JS) or error checking (GDScript `if error != OK:`) for operations prone to failure (file loading, API calls).
- **Unit Testing (Minimal Initial Focus):** For critical, isolated non-UI logic functions, simple assertion-based tests might be written. Full unit testing frameworks (Jest for JS, GUT for Godot) are a future consideration if complexity grows.

## 6. Documentation Strategy

- **Project Documentation (These Files):** `PROJECT_BRIEF.md`, `TECHNICAL_SPECIFICATIONS.md`, `DEVELOPMENT_PLAN_AND_PROCESS.md` – kept in project root or `/docs`. To be updated by the developer with AI assistance at the end of major phases or when significant changes occur.
- **`README.md`:** Main project README in the root. Contains a project overview, current features, setup/build instructions, and acknowledgments. AI will assist in drafting updates.
- **Inline Code Comments:** Explain complex logic, assumptions, or "why" something is done a certain way.
- **Function/Class Headers:** For significant custom functions/classes, add a comment block explaining purpose, parameters, and return values. AI can help generate these based on the code.
- **AI as "Live Documenter":** Use AI chat history as a form of development log and for understanding past decisions or code snippets.

---
