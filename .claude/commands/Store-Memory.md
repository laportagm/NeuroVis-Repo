# Command: Store Memory & Documentation Sync

**Purpose**: Advanced documentation synchronization using MCP memory system to maintain consistency across the NeuroVis educational platform.

**MCPs Used**: `memory`, `filesystem`, `sqlite`

## Overview
This command leverages MCP integrations to intelligently update project documentation, maintaining educational context and tracking API changes with persistent memory.

## Process

**INPUT**: Staged git diff for analysis

**GOAL**: Update relevant NeuroVis documentation using MCP integrations:
- **MCP `memory`**: Store and retrieve project knowledge patterns
- **MCP `filesystem`**: Read/write documentation files
- **MCP `sqlite`**: Track documentation changes and API evolution

STEPS
1.  Thoroughly scan the provided git diff for any changes that affect user-observable behavior, modify existing public interfaces (functions, signals, class properties in GDScript), or introduce new public interfaces.

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

        This document tracks new and modified public interfaces (GDScript classes, functions, signals, exported properties) within the A1-NeuroVis project.

        ## Changes
        ```
    * For every new or significantly changed public interface (e.g., a new `class_name`, a new public function in a script, a new signal, changes to parameters or return types of existing public functions/signals, new `@export` variables):
        * Append ONE new bullet point to the end of the "## Changes" section in `ai_docs/api_changelog.md`.
        * Each bullet point should be concise (ideally ≤ 120 characters).
        * Format: `- **`<Scope>`:** `Brief description of change/new interface`. (e.g., `- **`NeuralNet.gd`:** Added `select_neuron(id: String)` function.`, or `- **`NeuronDataResource`:** Changed `activation_level` property from `float` to `int`.`)
    * If no new or changed interfaces are found, leave this file untouched (or do not create it if it doesn't exist and no changes are needed).

4.  Ensure all other content in any modified files, and all other project files, remain entirely untouched.

OUTPUT
If any updates were made to `ai_docs/project_overview.md` or `ai_docs/api_changelog.md`, reply with:

### CHANGES
<unified diff for `ai_docs/project_overview.md` (if changed) and `ai_docs/api_changelog.md` (if changed or created with new entries)>

If no documentation updates are needed based on the diff, reply with:

### NO CHANGES
