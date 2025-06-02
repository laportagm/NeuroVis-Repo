# Command: A1-NeuroVis Project Analysis and Refactoring Assistance



You are an AI assistant for the A1-NeuroVis Godot project. Please process the following tasks sequentially. Provide the complete output for each task before moving to the next. Ensure all responses are tailored to the A1-NeuroVis project context, leveraging provided documentation paths and project-specific details.



## AI Task Todo List:



### ☐ Task 1: Optimize GDScript Code



**ROLE:** You are an expert Godot Engine (v4.x) GDScript optimizer.

**PROJECT CONTEXT:** A1-NeuroVis, a 3D desktop application for visualizing brain anatomy. Key project documents are in `ai_docs/`, including `scripting_conventions.md`. The project uses Godot 4.2 and GDScript.

**TASK:** Analyze the following GDScript code snippet from the A1-NeuroVis project. (Assume the user will paste the GDScript code snippet immediately after this task block if it's not provided inline). The script's primary role is [USER TO SPECIFY, e.g., 'managing the main 3D scene and model loading' or 'handling UI updates for the information panel'].



---

 **REQUEST:**

1.  Identify potential performance bottlenecks in this GDScript code, specifically considering its use within a Godot 4.x 3D application.

2.  Suggest up to three specific, actionable optimizations that would improve its execution speed or reduce resource usage (CPU, memory) while adhering to Godot best practices and the conventions in `ai_docs/scripting_conventions.md`.

3.  For each suggestion, explain *why* it's an optimization and provide the refactored code snippet.

4.  Prioritize optimizations that do not significantly reduce code readability for a beginner developer.



---



### ☐ Task 2: Update Documentation Based on Git Changes



You are a version-control assistant for the A1-NeuroVis Godot project. Your primary goal is to ensure project documentation accurately reflects code changes being committed.



**INSTRUCTION FOR AI:** Indicate you are ready to receive the `git diff` input for this task. Once the `git diff` is provided, proceed with the steps below.



**INPUT**

— The staged `git diff` will be provided by the user.



**GOAL**

Update relevant A1-NeuroVis project documentation, specifically:

    * `ai_docs/project_overview.md` (located at `/Users/gagelaporta/A1-NeuroVis/ai_docs/project_overview.md`)

    * A new `ai_docs/api_changelog.md` (to be created at `/Users/gagelaporta/A1-NeuroVis/ai_docs/api_changelog.md` if it doesn't exist), which should track changes to public GDScript interfaces like classes, functions, signals, and exported properties as defined in `ai_docs/scripting_conventions.md`.



**STEPS**

1.  Thoroughly scan the provided git diff for any changes that affect user-observable behavior, modify existing public GDScript interfaces (e.g., `class_name` definitions, public functions, signals, `@export` variables in scripts within `res://scripts/` as per `ai_docs/scripting_conventions.md`), or introduce new public interfaces.



2.  Regarding `ai_docs/project_overview.md` (located at `/Users/gagelaporta/A1-NeuroVis/ai_docs/project_overview.md`):

    * If behavioral changes are identified in the diff that alter the project's overall functionality or user interaction described in this document, edit `ai_docs/project_overview.md` in place.

    * Modify only the directly affected sections or sentences to reflect the changes.

    * Preserve all existing headings and the overall structure of the document.

    * If no such behavioral changes are found, leave this file untouched.

    *(User Note: If you have a different primary "Project Requirement Document" or "Product Context" file, like `docs/Project_Context_PRD.md`, you can instruct the AI to target that file instead of `ai_docs/project_overview.md` for these types of high-level behavioral updates.)*



3.  Regarding `ai_docs/api_changelog.md` (to be located at `/Users/gagelaporta/A1-NeuroVis/ai_docs/api_changelog.md`):

    * If this file does not yet exist, create it with the following initial content:

        ```markdown

        # API Changelog for A1-NeuroVis



        This document tracks new and modified public interfaces (GDScript classes, functions, signals, exported properties) within the A1-NeuroVis project. Refer to `ai_docs/scripting_conventions.md` for definitions.



        ## Changes

        ```

    * For every new or significantly changed public interface (e.g., a new `class_name`, a new public function in a script, a new signal, changes to parameters or return types of existing public functions/signals, new `@export` variables):

        * Append ONE new bullet point to the end of the "## Changes" section in `ai_docs/api_changelog.md`.

        * Each bullet point should be concise (ideally ≤ 120 characters).

        * Format: `- **<Scope e.g., scripts/core/AnatomicalKnowledgeDatabase.gd>:** <Brief description, e.g., Added function get_structure_by_id(id: String) -> Dictionary or null.>. Refer to `CLAUDE.md` for key script paths.`

    * If no new or changed interfaces are found, leave this file untouched (or do not create it if it doesn't exist and no changes are needed).



4.  Ensure all other content in any modified files, and all other project files, remain entirely untouched.



**OUTPUT**

If any updates were made to `ai_docs/project_overview.md` or `ai_docs/api_changelog.md`, reply with:



### CHANGES

<unified diff for `ai_docs/project_overview.md` (if changed) and `ai_docs/api_changelog.md` (if changed or created with new entries)>



If no documentation updates are needed based on the diff, reply with:



### NO CHANGES



---



### ☐ Task 3: Analyze `node_3d.gd` Responsibilities for Refactoring



**ROLE:** Senior GDScript architect specializing in Godot Engine 4.x project refactoring.

**PROJECT CONTEXT:** A1-NeuroVis, currently undergoing a modular refactoring. The primary monolithic script being analyzed is `res://scenes/node_3d.gd`, which acts as the main scene script (as potentially referenced in `ai_docs/scene_architecture.md` or `CLAUDE.md`). The goal is to extract logic into components as per `docs/refactoring/main_scene_refactor_plan.md`.

**TASK:**

1.  Analyze the current version of `res://scenes/node_3d.gd` (Assume user will provide the content of this script if requested, or that it's known from the broader project context provided).

2.  Identify all distinct responsibilities currently handled by this script (e.g., UI management, 3D model interaction, data handling, camera control, state management).

3.  Based on `docs/refactoring/main_scene_refactor_plan.md`, create a detailed component extraction map.

**OUTPUT:**

Provide a Markdown table with the following columns:

* `Original Function/Variable Name` (from `node_3d.gd`)

* `Approximate Line Numbers` (in `node_3d.gd`)

* `Identified Responsibility`

* `Proposed Target Component` (e.g., BrainVisualizer, UIManager, InteractionHandler, StateManager as per the refactor plan)

* `Brief Rationale for Assignment`



---



### ☐ Task 4: Audit Error Handling in `node_3d.gd`



**ROLE:** Code quality auditor specializing in GDScript and Godot 4.x best practices.

**PROJECT CONTEXT:** A1-NeuroVis project, specifically the `res://scenes/node_3d.gd` script which is being refactored to eliminate over-engineered error handling as per `docs/refactoring/error_handling_cleanup.md`. Refer to `ai_docs/scripting_conventions.md` for project-specific coding standards.

**TASK:**

1.  Scan the provided `res://scenes/node_3d.gd` script (Assume user will provide the content of this script if requested, or that it's known from the broader project context).

2.  Identify all instances of the following defensive programming patterns:

    * Backup reference variables (e.g., `camera_backup`).

    * Initialization retry logic (e.g., `initialization_attempt_count`).

    * Excessive or overly nested null checking for node existence.

    * Fallback UI/node creation logic if primary nodes are not found.

**OUTPUT:**

Provide a categorized Markdown list:

* For each pattern instance:

    * Specify the pattern type.

    * List the starting line number(s).

    * Provide the relevant code snippet.

    * Assess its severity/impact on complexity and maintainability within the A1-NeuroVis context (e.g., High, Medium, Low).

    * Suggest the preferred approach as per `docs/refactoring/error_handling_cleanup.md` (e.g., "Replace with assertion" or "Ensure node exists via scene setup").



---

**Instructions for AI performing these tasks:**

* Address each task under its respective "Task X" heading.

* For tasks requiring code input (like Task 1, 3, and 4 for `node_3d.gd`), if the code is not pasted directly into the prompt by the user, please state that you require the content of the specified script to proceed with that task.

* For Task 2, explicitly state "Ready to receive git diff input." before expecting the diff.

* Ensure all outputs are clearly formatted as requested in each task.