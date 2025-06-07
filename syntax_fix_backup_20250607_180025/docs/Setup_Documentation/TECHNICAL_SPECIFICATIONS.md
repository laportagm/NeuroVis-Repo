TECHNICAL_SPECIFICATIONS.md

# Technical Specifications: AI-Enhanced Brain Anatomy Visualizer (Desktop)

**Version:** 0.1
**Date:** May 15, 2025

## 1. Application Type

- Desktop Application

## 2. Target Operating Systems

- **Primary:** Windows (10 and newer), macOS (latest 2-3 versions).
- **Development OS:** macOS.

## 3. Development Environment

- **Primary Editor:** Visual Studio Code (VS Code).
- **Version Control:** Git, hosted on GitHub or GitLab.
- **Key Languages (depending on chosen framework):** JavaScript, HTML, CSS (for Electron path); GDScript or C# (for Godot Engine path).
- **AI Development Assistants:** Claude Max, Gemini Advanced, ChatGPT Pro.

## 4. Core Technologies (Exploration & Tentative Choices)

- **Primary Framework (To be finalized after Phase 0 Exploration):**
  - **Option A: Electron:**
    - UI: HTML, CSS, JavaScript.
    - 3D Rendering: Three.js or Babylon.js within Electron's Chromium renderer.
    - Backend Logic (if any beyond file system access): Node.js integrated with Electron.
  - **Option B: Godot Engine:**
    - UI: Godot's built-in Control nodes.
    - 3D Rendering: Godot's built-in 3D engine.
    - Scripting: GDScript (preferred for ease of learning) or C#.
- **Rationale for Exploration:** Evaluate ease of learning for a beginner, 3D integration capabilities, performance for specified model sizes, packaging simplicity, and quality of AI assistant support for the chosen path.

## 5. 3D Model Specifications

- **Format:** GLTF (.glb or .gltf) preferred for web-friendliness (Electron) and good support in Godot.
- **Size:** Individual models expected to be in the 10MB - 55MB range.
- **Content:** Anatomically reasonably accurate representations of the human brain with distinct, selectable structures/meshes.
- **Licensing:** Must be free/openly licensed for use in a free application.

## 6. Data Management Strategy

- **Phase 1-2 (Initial):**
  - **3D Models:** Stored as local files within the application package/installation directory (e.g., in an `assets` folder).
  - **Anatomical Information (Names, Descriptions, Functions):** Stored in a local, structured text file (e.g., JSON). This file will be curated manually and bundled with the application. It will be read into memory on startup or as needed.
- **Future Considerations (Post-MVP):**
  - Potentially a simple local database (e.g., SQLite) if data becomes more complex or user-specific annotations are added (though this increases complexity).
  - No cloud-based database for user data to maintain zero cost for users and developer.

## 7. In-App AI Assistant Approach

- **Core Functionality:** Provide dynamic explanations for selected anatomical structures and answer user questions related to neuroanatomy.
- **Technology (Initial):** Relies on **online API calls to a third-party LLM service that offers a generous free tier.**
  - The desktop application will make HTTP requests to this API.
  - The specific LLM API provider will be chosen based on the quality of its free tier, ease of integration, and suitability for Q&A/explanation tasks (e.g., Groq, Fireworks AI, OpenRouter, or direct provider free tiers if terms allow).
  - An internet connection will be required for these AI features.
- **Local AI Model (Future Consideration, highly advanced):** Exploration of running a very small, efficient reasoning model locally (e.g., a quantized GGUF model via llama.cpp bindings, or similar if feasible within the chosen framework) is a long-term goal, only if it doesn't compromise ease of development/maintenance for a solo developer or significantly bloat the application/impact performance excessively. This is NOT an MVP requirement.
- **Prompt Engineering:** Prompts will be designed to be concise and provide context (e.g., the currently selected brain structure) to the LLM.

## 8. Performance Considerations

- **Responsiveness:** UI interactions (clicks, camera controls) should feel immediate.
- **3D Rendering:** Smooth frame rates (aiming for 30-60 FPS) when viewing and interacting with models up to 55MB on reasonably modern desktop hardware.
- **Startup Time:** Application should launch within a reasonable timeframe (e.g., < 5-10 seconds).
- **Memory Usage:** Should be manageable and not excessively consume system resources for the displayed content.
- **API Calls (for AI features):** Should have reasonable timeouts and handle potential network latency or errors gracefully, possibly with loading indicators.

## 9. Distribution Method

- **Initial:** Downloadable installer package from a simple, free-to-host website (e.g., GitHub Pages, Itch.io, or similar).
- **Package Formats:**
  - Windows: `.exe` installer or portable executable.
  - macOS: `.dmg` disk image or `.app` bundle.
- **No initial plans for App Store distribution** due to potential costs and complexities, unless this becomes very easy with the chosen framework.

---
