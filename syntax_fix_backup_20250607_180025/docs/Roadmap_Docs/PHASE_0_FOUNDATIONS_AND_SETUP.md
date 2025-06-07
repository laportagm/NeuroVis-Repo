**Phase 0: Foundations, Initial Documentation & Setup**. This document will serve as your comprehensive guide and checklist to ensure every foundational aspect is covered and "perfected" to a satisfactory level before you proceed to actual feature development in Phase 1.

Remember to use your AI assistants (Claude Max, Gemini Advanced, ChatGPT Pro) actively throughout this phase for research, command generation, troubleshooting, and drafting content for the various documentation files you'll be creating.

---

### `PHASE_0_FOUNDATIONS_AND_SETUP.md`

**Project:** AI-Enhanced Brain Anatomy Visualizer (Desktop)
**Phase:** 0 - Foundations, Initial Documentation & Setup
**Version:** 1.0
**Date:** Thursday, May 15, 2025
**Location:** Ardmore, Pennsylvania, United States

**Phase Goal:** To establish a comprehensive and robust foundation for the project by finalizing the initial vision and scope, setting up the complete development environment, making informed preliminary technology choices through exploration, creating a full suite of initial planning documents, and gathering essential starting assets.

---

**1. Introduction**

Phase 0 is the most critical preparatory stage for the AI-Enhanced Brain Anatomy Visualizer. Its purpose is to ensure that all groundwork is meticulously laid before active coding on the application's features begins. This includes clearly defining the project, setting up all necessary tools and accounts, exploring technology options to make an informed (though still tentative) choice, creating comprehensive initial documentation that will guide development, and collecting initial assets.

Successfully completing this phase with attention to detail will significantly streamline subsequent development phases, improve the quality of AI-assisted development, and increase the overall likelihood of project success. Consider this phase "perfected" when all checkpoints are met and you feel confident and clear about the project's direction and your immediate next steps.

---

**2. Prerequisites for Starting Phase 0**

- Access to a macOS computer (as this is the primary development OS).
- Reliable internet connection (for research, downloads, AI assistant access).
- Access to your AI assistants: Claude Max, Gemini Advanced, ChatGPT Pro.
- Time and focus dedicated to planning, research, setup, and documentation.

---

**3. Core Principles Guiding Phase 0**

While all 13 software development principles discussed earlier apply throughout the project, in Phase 0, we especially emphasize:

- **Clarity of Vision & Scope:** Defining "Must-Haves" vs. "Nice-to-Haves" and clear project boundaries from the start (`PROJECT_BRIEF.md`, `USER_STORIES.md`).
- **Informed Technology Choices:** Exploration helps prevent costly changes later (`TECHNICAL_SPECIFICATIONS.md`).
- **Structured Planning:** Documenting the "how" (`DEVELOPMENT_PLAN_AND_PROCESS.md`, `AI_MODULARITY_FOR_BUILDING.md`).
- **Data Strategy:** Thinking about data early (`DATA_STORAGE_AND_ACCESS_PLAN.md`, `KNOWLEDGE_BASE_SCHEMA_AND_CONTENT_PLAN.md`, `CONTENT_EXPANSION_PLAN.md`).
- **AI-Assisted Design:** Actively using AI to draft, refine, and structure these foundational documents and plans.

---

**4. Detailed Tasks, Checkpoints & AI Integration**

**Task 1: Vision & Scope Finalization**

- **Activity:** Revisit and solidify the core vision, target audience, the problem your application solves, and high-level goals. This involves critically reviewing and refining the initial ideas.
- **Key Documentation to Create/Update:** `PROJECT_BRIEF.md` (Sections: Vision Statement, Target Audience, Core Problem/Need Addressed, Key Goals & Objectives).
- **AI Assistant Role:**
  - "Help me refine this vision statement for my Brain Anatomy Visualizer to be more impactful: [Your Draft Vision]."
  - "Based on my target audience (medical students, researchers, curious learners), what are the primary needs this app should address?"
  - "Review my project goals. Are they S.M.A.R.T. (Specific, Measurable, Achievable, Relevant, Time-bound) for a solo developer's initial project?"
- **Checkpoint/Perfection Criteria:**
  - **[ ]** Vision statement is clear, concise, and inspiring.
  - **[ ]** Target audience segments are well-defined.
  - **[ ]** Core problem/need is articulated accurately.
  - **[ ]** Key goals are actionable and aligned with the vision.
  - **[ ]** Relevant sections in `PROJECT_BRIEF.md` are complete and reviewed.

**Task 2: Initial Feature Definition, Prioritization & Boundaries**

- **Activity:** Brainstorm all desired features. Categorize them into "Must-Have" (for MVP v1.0), "Nice-to-Have" (post-MVP), and "Future Considerations." Explicitly define what the MVP v1.0 _will not_ do to prevent scope creep. Translate "Must-Have" features into initial user stories.
- **Key Documentation to Create/Update:**
  - `PROJECT_BRIEF.md` (Sections: High-Level Feature List, Project Boundaries).
  - `USER_STORIES.md` (Initial draft focusing on MVP "Must-Have" features).
- **AI Assistant Role:**
  - "Given my project vision, help me brainstorm a list of features. Then, help me categorize them into 'Must-Have for MVP', 'Nice-to-Have', and 'Future'."
  - "For my MVP focusing on [list 2-3 core MVP aspects], what specific functionalities should I explicitly state the application _will not_ include initially?"
  - "Take this MVP 'Must-Have' feature: '[Feature description]'. Help me draft 2-3 user stories for it from the perspective of a medical student and a curious learner."
- **Checkpoint/Perfection Criteria:**
  - **[ ]** Feature list in `PROJECT_BRIEF.md` is categorized.
  - **[ ]** Project boundaries in `PROJECT_BRIEF.md` are clearly defined for the MVP.
  - **[ ]** Initial draft of `USER_STORIES.md` exists, containing several user stories for each "Must-Have" MVP feature.
  - **[ ]** You have a clear understanding of the MVP's scope.

**Task 3: Initial Technical, Data, and Process Planning Documentation**

- **Activity:** Draft initial plans for technical specifications, data management (storage, access, content expansion), development processes, and how AI will be used for building.
- **Key Documentation to Create/Update:**
  - `TECHNICAL_SPECIFICATIONS.md` (Initial draft covering target OS, dev environment, tech exploration paths, 3D model specs, initial data thoughts, AI in-app approach, performance ideas, distribution method).
  - `DEVELOPMENT_PLAN_AND_PROCESS.md` (Initial draft covering philosophy, phased roadmap overview, AI dev roles, version control, initial testing/doc thoughts).
  - `DATA_STORAGE_AND_ACCESS_PLAN.md` (Initial draft outlining types of data, bundled vs. user-dir storage, initial access strategies).
  - `CONTENT_EXPANSION_PLAN.md` (Initial draft on scope of content, process for adding anatomical info, initial prioritization).
  - `KNOWLEDGE_BASE_SCHEMA_AND_CONTENT_PLAN.md` (Initial draft defining JSON schema, example entries, initial structure list, curation sources).
  - `AI_MODULARITY_FOR_BUILDING.md` (Initial draft on philosophy, modular task breakdown, prompt structuring, managing AI code, modular code design).
  - `UI_UX_DESIGN_NOTES.md` (Initial draft: overall philosophy, very high-level layout ideas for main window and info display, core interaction flow descriptions).
- **AI Assistant Role:**
  - For each document: "Help me create an initial draft/outline for a `[Document Name]` for my Brain Anatomy Visualizer desktop app. Key aspects to cover are [list 2-3 key points from the document's purpose description above]."
  - "What are common approaches for [storing bundled 3D models in Electron / accessing resources in Godot]?"
  - "Suggest a basic JSON schema for storing anatomical data including an ID, display name, short description, and functions."
  - "How can I best structure my prompts to you (AI) when I need help generating a specific function in [JavaScript/GDScript]?"
- **Checkpoint/Perfection Criteria:**
  - **[ ]** First drafts of all seven documents listed above (`TECHNICAL_SPECIFICATIONS.md`, `DEVELOPMENT_PLAN_AND_PROCESS.md`, `DATA_STORAGE_AND_ACCESS_PLAN.md`, `CONTENT_EXPANSION_PLAN.md`, `KNOWLEDGE_BASE_SCHEMA_AND_CONTENT_PLAN.md`, `AI_MODULARITY_FOR_BUILDING.md`, `UI_UX_DESIGN_NOTES.md`) are created.
  - **[ ]** Each document contains relevant initial information, even if some sections are marked as "To Be Detailed Further."
  - **[ ]** You understand the purpose and initial content of each planning document.

**Task 4: macOS Development Environment Setup**

- **Activity:** Install and configure all necessary software tools on your Mac development machine.
- **Tools:** Xcode Command Line Tools, Homebrew, Git, VS Code (with relevant extensions like Prettier, ESLint for JS; Godot Tools for Godot), Node.js & npm (via nvm).
- **AI Assistant Role:**
  - "What is the current command to install Homebrew on macOS?"
  - "Provide the sequence of commands to install nvm and then use it to install the latest LTS version of Node.js and npm on macOS."
  - "How do I verify that Git, Node.js, and npm are installed correctly and show their versions in the Terminal?"
  - "Suggest essential VS Code extensions for [Electron with JavaScript / Godot with GDScript] development."
  - "How do I configure Git globally with my username and email on macOS?"
- **Performance Requirements (for Setup):** Tools should install without critical errors. Commands should run as expected.
- **Error Handling (for Setup):** If an installation fails, copy the error message from the terminal and ask your AI assistant: "I got this error while trying to install [tool]: [error message]. What could be the cause and how can I fix it?"
- **Debugging (for Setup):** Check tool versions (`git --version`, `node -v`, `npm -v`, `brew --version`). Ensure paths are correct if issues arise.
- **Checkpoint/Perfection Criteria:**
  - **[ ]** Xcode Command Line Tools are installed.
  - **[ ]** Homebrew is installed and functional.
  - **[ ]** Git is installed, `git --version` works, and global `user.name` and `user.email` are configured.
  - **[ ]** VS Code is installed and launches. Recommended extensions (if any) are installed.
  - **[ ]** Node.js and npm are installed via nvm (if chosen path) and `node -v`, `npm -v` report correct versions.

**Task 5: Technology Exploration & Tentative Choice (Electron vs. Godot)**

- **Activity:** Create minimal "Hello World" and "Simple 3D Rotating Cube" test projects for _both_ Electron (using Three.js) and Godot Engine. The goal is to get a basic feel for the development workflow, project structure, ease of 3D integration, and AI assistant support for each.
- **Incremental Development:** Build the "Hello World" first for each, then add the 3D cube. Test at each stage.
- **AI-Assisted Development:** Heavily rely on AI for the boilerplate code for these small test projects.
  - "Generate the minimal files (`main.js`, `preload.js`, `index.html`, `renderer.js`) for an Electron app that displays 'Hello Electron!' in a window."
  - "Now, modify the Electron `renderer.js` and `index.html` to use Three.js to display a simple, unlit, rotating cube in the center of the window."
  - "Guide me step-by-step to create a new Godot project. In this project, create a 2D scene that displays a Label node with the text 'Hello Godot!'. Then, show me how to run this scene."
  - "Next, in a new 3D scene in the same Godot project, show me how to add a simple rotating `MeshInstance3D` cube with a `Camera3D` and a `DirectionalLight3D`."
- **Clean Code (for tests):** Even for these small tests, ask AI to explain the code so you understand it.
- **Error Handling/Debugging (for tests):** Use Electron DevTools and Godot's debugger/output panel to resolve any issues in these test projects with AI help.
- **Checkpoint/Perfection Criteria:**
  - **[ ]** A functional "Hello Electron + Rotating Three.js Cube" application runs successfully.
  - **[ ]** A functional "Hello Godot + Rotating 3D Cube" application runs successfully.
  - **[ ]** You have spent some time looking at the project structure and code for both, noting differences.
  - **[ ]** You have a subjective "feel" for which framework might be more approachable or better supported by AI for _your current skill level and project goals_.

**Task 6: Tentative Primary Framework Choice & Main Project Setup**

- **Activity:** Based on the exploration in Task 5, make a _tentative_ primary choice of framework (Electron or Godot). Initialize your main project folder (`~/Projects/BrainVisualizerDesktop` or similar) with the basic structure for this chosen framework.
- **AI Assistant Role:**
  - "I've decided to tentatively proceed with [Electron/Godot]. What's the recommended way to scaffold a new project for this framework (e.g., using `npm create electron-app@latest my-app` with Electron Forge, or just creating a new project via Godot editor and setting up folder structure)? What would be a good initial folder structure within the project for assets, scripts, scenes (if Godot), UI components, etc.?"
- **Checkpoint/Perfection Criteria:**
  - **[ ]** A tentative decision for the primary development framework is made and noted (e.g., in `TECHNICAL_SPECIFICATIONS.md`).
  - **[ ]** The main project directory is created.
  - **[ ]** The basic project files and folder structure for the chosen framework are in place inside the main project directory.

**Task 7: Version Control Initialization for Main Project**

- **Activity:** Initialize a Git repository in your main project folder. Create an appropriate `.gitignore` file. Create and link a remote private repository (GitHub/GitLab). Make an initial commit.
- **AI Assistant Role:**
  - "Generate a comprehensive `.gitignore` file for a new [Electron with Node.js and potential build artifacts / Godot Engine] project."
  - "I have initialized a local git repository in my project folder. I've also created a new empty private repository on [GitHub/GitLab] with the URL [URL]. What are the git commands to link my local repo to this remote and push my initial commit (e.g., containing the project structure and .gitignore)?"
- **Checkpoint/Perfection Criteria:**
  - **[ ]** `git init` has been run in the main project folder.
  - **[ ]** A relevant `.gitignore` file is present.
  - **[ ]** The local repository is successfully connected to a remote private repository.
  - **[ ]** At least one initial commit (e.g., "Initial project setup for [Framework]") has been made and pushed to the remote.

**Task 8: Initial Asset Gathering & Preliminary Review**

- **Activity:**
  1.  Download one suitable, openly licensed 3D brain model in GLTF format (10-55MB range). Place it in an `assets/models` subfolder within your main project.
  2.  Briefly inspect the model (e.g., using Blender, an online GLTF viewer, or even by attempting to load it in your chosen framework's "cube test" project). Identify the names or hierarchy of a few major, distinct meshes you could target for selection later.
  3.  Gather raw, unformatted anatomical information (name, 1-2 sentence description, 1-2 key functions) for these 3-5 identified parts from highly reliable sources (medical textbooks, university neuroscience websites). Store this raw text in a temporary file for now. _This is not about finalizing the knowledge base, just collecting initial samples._
- **AI Assistant Role:**
  - "Can you suggest 2-3 reputable online sources where I can find free, openly licensed (e.g., CC0, CC-BY) 3D human brain models in GLTF format, suitable for an educational app?"
  - "What free tools can I use on macOS to inspect the contents/mesh names of a GLTF file?"
  - "I need to find basic anatomical information (short description, key functions) for the 'Cerebellum'. Can you point me to 2-3 highly reputable online medical/educational resources where I can find this information, which I will then verify?" (Emphasize that you will do the verification from the suggested sources).
- **Data Management (for this task):** Model file stored locally. Raw text notes for anatomical info.
- **Checkpoint/Perfection Criteria:**
  - **[ ]** At least one GLTF brain model is downloaded, placed in project `assets`, and seems suitable (e.g., not overly complex, has some distinct parts).
  - **[ ]** You have noted down the names/IDs of 3-5 distinct meshes within this model.
  - **[ ]** Raw textual information (name, brief description, few functions) for these 3-5 parts has been collected from reliable sources and saved in a temporary notes file.

---

**5. Phase 0 Completion Criteria / "Definition of Done"**

You have "perfected" and completed Phase 0 when:

- **[ ]** All nine core project documentation files (`PROJECT_BRIEF.md`, `TECHNICAL_SPECIFICATIONS.md`, `DEVELOPMENT_PLAN_AND_PROCESS.md`, `USER_STORIES.md`, `UI_UX_DESIGN_NOTES.md`, `KNOWLEDGE_BASE_SCHEMA_AND_CONTENT_PLAN.md`, `DATA_STORAGE_AND_ACCESS_PLAN.md`, `CONTENT_EXPANSION_PLAN.md`, `AI_MODULARITY_FOR_BUILDING.md`) have been created and populated with sufficient initial detail to guide the next phase.
- **[ ]** Your macOS development environment is fully set up with all necessary tools installed and verified.
- **[ ]** The "Hello World + 3D Rotating Cube" exploratory projects for both Electron (with Three.js) and Godot Engine have been successfully completed and understood at a basic level.
- **[ ]** A _tentative_ primary development framework (Electron or Godot) has been chosen for proceeding to Phase 1.
- **[ ]** The main project directory has been created, appropriately structured for the chosen framework, and is under Git version control, linked to a remote private repository with an initial commit.
- **[ ]** At least one suitable 3D brain model (GLTF) has been acquired and added to the project assets.
- **[ ]** Preliminary raw anatomical data for a small, identifiable set of structures from the model has been gathered from reliable sources.
- **[ ]** You feel confident with the chosen setup, understand the initial project plan and scope, and are clear on how to proceed to Phase 1.

---

**6. Next Steps (Transition to Phase 1)**

Upon successful completion of all checkpoints in this Phase 0 document, you will be ready to transition to **Phase 1: Core 3D Visualization & Basic Interaction**. Phase 1 will focus on taking your chosen framework, your acquired 3D model, and your initial planning, and bringing the static 3D brain to life within your application window with basic user interaction.

---

This document for Phase 0 is designed to be exhaustive. Take your time with each step. The thoroughness here will pay dividends in all subsequent phases. Remember to commit your documentation files to your Git repository as you complete and refine them!
