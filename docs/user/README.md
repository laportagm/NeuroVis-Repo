# NeruroVis-GoDot


---
## AI-Assisted Development Workflow

This project is structured to facilitate collaboration with AI coding assistants like Claude. To leverage this, key directories and files have been set up:

-   **`.claude/commands/context_prime.md`**: This is the primary prompt used to initialize an AI coding session. It provides the AI with essential context about the project's structure, conventions, and the location of more detailed documentation within `ai_docs/`. Before starting a new task with the AI, update the `{{SPEC_FILE_PATH}}` placeholder in this file to point to the relevant specification.

-   **`ai_docs/`**: This directory serves as the persistent knowledge base for the AI. It contains Markdown files detailing:
    -   `project_overview.md`: High-level goals, Godot version, and main entry points.
    -   `scene_architecture.md`: Descriptions of key scenes, their roles, and how they interact.
    -   `scripting_conventions.md`: GDScript coding standards, naming conventions, and best practices for this project.
    -   `asset_pipeline.md`: Guidelines for importing, organizing, and using project assets.
    *(This directory should be kept updated as the project evolves.)*

-   **`specs/`**: This directory holds detailed specifications (plans) for new features, bug fixes, or specific tasks the AI will help implement. Each `.md` file in `specs/` should outline the objective, requirements, key files/scenes to modify, and acceptance criteria for a distinct piece of work.

**Typical AI Workflow:**
1.  **Define the Task:** Create a new `.md` specification file in the `specs/` directory for the feature or bug you want to address.
2.  **Prime the AI:**
    * Open `.claude/commands/context_prime.md`.
    * Replace the `{{SPEC_FILE_PATH}}` placeholder with the relative path to your new spec file (e.g., `specs/my_new_feature_spec.md`).
    * Copy the entire updated content of `context_prime.md`.
3.  **Initiate AI Session:** Paste the copied context as the very first prompt to the AI assistant.
4.  **Collaborate:** Guide the AI based on the spec, refer it to `ai_docs/` for established conventions, and iterate on its suggestions.

This structured approach helps ensure the AI has the necessary context to provide relevant and useful assistance for developing the A1-NeuroVis Godot project.
