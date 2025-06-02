Okay, fantastic\! With Phase 1 successfully behind you, you have an interactive 3D model. Now, in **Phase 2: Basic Information Display & Local Knowledge Base Integration**, we'll connect that interactivity to meaningful educational content.

This document will guide you through creating your initial knowledge base, loading it into your application, and displaying information dynamically when the user selects a brain structure.

---

### `PHASE_2_BASIC_INFORMATION_DISPLAY_AND_LOCAL_KNOWLEDGE_BASE_INTEGRATION.md`

**Project:** AI-Enhanced Brain Anatomy Visualizer (Desktop)
**Phase:** 2 - Basic Information Display & Local Knowledge Base Integration
**Version:** 1.0
**Date:** Thursday, May 15, 2025
**Location:** Ardmore, Pennsylvania, United States

**Phase Goal:** To enable the application to display basic, curated anatomical information (name, short description, key functions) for a selected 3D brain structure. This involves creating an initial local knowledge base (as a JSON file), implementing logic to load and parse this data, designing a simple UI panel for information display, and dynamically updating this panel based on user selections in the 3D view. This phase focuses on implementing "Must-Have" feature M5.

---

**1. Introduction**

Phase 2 bridges the gap between visual interaction and informational content. You'll be creating the first version of your application's "brain" – its knowledge base – and making that knowledge accessible to the user. This phase is crucial for establishing the core educational value of the visualizer. We will focus on local data management and clear presentation of information.

---

**2. Prerequisites for Starting Phase 2**

- **[ ] All Phase 1 tasks and checkpoints are completed and "perfected."**
  - Application loads and displays the 3D brain model.
  - Camera controls (orbit, zoom, pan) are functional.
  - User can click to select and visually highlight distinct parts of the 3D model.
  - A simple UI label displays the _mesh name_ of the selected part.
  - Project is under Git version control with Phase 1 work committed.
  - You have your primary framework (Electron + Three.js OR Godot Engine) set up.
  - You have your initial documentation suite, particularly `KNOWLEDGE_BASE_SCHEMA_AND_CONTENT_PLAN.md` (which defines the JSON structure) and `UI_UX_DESIGN_NOTES.md` (with initial ideas for an info panel).

---

**3. Applying Core Development Principles in Phase 2**

- **Feature Categorization/Boundaries:** Focus _only_ on M5 (Display basic information from a _local_ data source). The info panel UI (part of M6) will be very simple. No online AI (M7) yet.
- **Performance:** JSON parsing of a small-to-medium file should be quick on startup. UI updates should be instant on selection.
- **UI/UX Sketching:** Refine your sketch for the information display panel from `UI_UX_DESIGN_NOTES.md`. How will the name, description, and functions be laid out for readability?
- **Data Management:** This phase _is_ about initial data management: creating, structuring, loading, and accessing the `anatomical_data.json` file.
- **Walking Skeleton:** This significantly enhances the walking skeleton by adding the "information retrieval" component to the "see-select" loop.
- **Incremental Development:** Curate a few JSON entries, then implement loading. Then design the UI panel. Then link selection to UI update. Test at each sub-step.
- **AI-Assisted Development:** Use AI for JSON formatting, code to load/parse JSON, UI element creation for your chosen framework, and logic to update UI.
- **Clean, Readable, Maintainable Code:** Structure data loading and UI update logic clearly. Use meaningful variable names for data fields.
- **Error Handling:** Crucial for file loading (file not found, invalid JSON format). Provide fallback or clear error messages.
- **Testing and Debugging:** Manually verify that selecting different 3D parts displays the correct corresponding information. Use debuggers/consoles for issues.
- **Deployment Strategy Considerations:** Confirm the `anatomical_data.json` file is correctly bundled with the application and accessible at runtime.
- **AI for Documentation:** Update `README.md`, `KNOWLEDGE_BASE_SCHEMA_AND_CONTENT_PLAN.md` (with actual fields used), and `DATA_STORAGE_AND_ACCESS_PLAN.md` to reflect the implementation.

---

**4. Key Concepts to Learn/Understand in Phase 2**

- **JSON (JavaScript Object Notation):** Structure (objects `{}` and arrays `[]`), key-value pairs, data types (strings, numbers, booleans, arrays, objects).

- **Data Serialization/Deserialization (Parsing):** Converting JSON text into a usable in-memory data structure (like JavaScript objects/arrays or Godot Dictionaries/Arrays) and vice-versa (though you're mostly reading in this phase).

- **File System Access (Basic):** How your chosen framework reads local files bundled with the application.

- **Data Structures in Code:** How to work with arrays and objects/dictionaries in your chosen language (JavaScript or GDScript) to access the parsed JSON data.

- **UI Elements for Text Display:**

  - **Electron/HTML:** `<div>`, `<p>`, `<h1>-<h6>`, `<ul>`, `<li>` for structured text.
  - **Godot:** `Label` node (for single lines or simple text), `RichTextLabel` node (for formatted text, multiple lines, basic styling).

- **Dynamic UI Updates:** How to change the content of UI elements programmatically based on application state or user interaction.

- **ID Matching:** The critical concept of having a shared identifier between a selectable 3D mesh and its corresponding entry in the JSON knowledge base.

- **_AI Assist Prompt Idea for any concept:_** "Explain JSON parsing in [JavaScript for an Electron app / GDScript for Godot]. How does it convert a JSON string into a data structure I can use in my code?"

---

**5. Essential Tools & Resources for Phase 2**

- **[ ] Your Chosen Code Editor:** VS Code (excellent for editing JSON too).
- **[ ] Your `anatomical_data.json` file:** You will be creating and populating this.
- **[ ] Your Chosen Framework & Associated Tools:**
  - **Electron Path:** Node.js (`fs` module for file system), Electron APIs.
  - **Godot Engine Path:** Godot editor, `FileAccess` class, `JSON` class.
- **[ ] Project Documentation:** Especially `KNOWLEDGE_BASE_SCHEMA_AND_CONTENT_PLAN.md` (for schema) and `UI_UX_DESIGN_NOTES.md` (for UI panel ideas).
- **[ ] Reliable Anatomical Information Sources:** (Textbooks, reputable websites – as defined in Phase 0).

---

**6. Detailed Tasks, Checkpoints & AI Integration**

**Task 1: Curate Initial Local Knowledge Base (`anatomical_data.json`)**

- **Activity:** Create and populate your `anatomical_data.json` file. For this phase, aim for **5-10 key brain structures** that are clearly identifiable and selectable in your 3D model. For each structure, include at least:
  - `id`: This **MUST** precisely match the name or a unique identifier of the corresponding selectable mesh in your 3D model (e.g., `FrontalLobe_Mesh`, `Cerebellum_Part_01`). You noted these down in Phase 0/1. Consistency here is paramount for linking.
  - `displayName`: The common, human-readable name (e.g., "Frontal Lobe").
  - `shortDescription`: A concise 1-3 sentence summary.
  - `functions`: An array of strings, each listing a key function.
- **Data Management:** This is the core data creation step. Adhere strictly to the schema defined in `KNOWLEDGE_BASE_SCHEMA_AND_CONTENT_PLAN.md`.
- **Error Handling:** Ensure your JSON is syntactically correct. Use VS Code's JSON validation or an online JSON validator.
- **Steps:**
  1.  **[ ] Create `anatomical_data.json`:** In your project's `assets/data/` folder (create if it doesn't exist), create this empty JSON file. Start with an empty array `[]`.
  2.  **[ ] Identify Target Structures & Their 3D Model IDs:** Review your 3D model and your notes from Phase 0/1. List 5-10 distinct meshes and their exact names/IDs as they appear in your 3D software or as logged during Phase 1 selection.
  3.  **[ ] Research & Write Content:** For each target structure, use your authoritative sources to write the `displayName`, `shortDescription`, and a list of `functions`. _VERIFY ALL FACTUAL INFORMATION METICULOUSLY._
  4.  **[ ] Populate JSON Entries:** Carefully add an object for each structure to the JSON array, matching the schema. Pay close attention to syntax (commas, quotes, brackets).
      - **_AI Assist:_** "I have the following verified information for the 'Hippocampus': Name: Hippocampus, ID in 3D model: 'HC_Mesh_Left', Short Desc: 'Crucial for memory formation and spatial navigation.', Functions: ['Consolidating new memories', 'Spatial learning and navigation']. Can you format this into a JSON object that fits this schema: [paste your schema for one entry from `KNOWLEDGE_BASE_SCHEMA_AND_CONTENT_PLAN.md`]?" (Repeat for each structure).
  5.  **[ ] Validate JSON:** After adding entries, copy-paste the entire content of `anatomical_data.json` into an online JSON validator (e.g., JSONLint) to ensure it's syntactically correct. VS Code will also often highlight JSON errors.
- **Checkpoint/Perfection Criteria:**
  - **[ ]** `anatomical_data.json` exists in the correct project location.
  - **[ ]** The file contains 5-10 valid JSON objects, each representing a brain structure and adhering to your defined schema.
  - **[ ]** The `id` field for each entry accurately matches a selectable mesh name/ID from your 3D model.
  - **[ ]** The anatomical information (`displayName`, `shortDescription`, `functions`) is accurate (as per your verified research) and well-written for the target audience.
  - **[ ]** The entire JSON file is syntactically valid.

**Task 2: Implement JSON Data Loading and Parsing**

- **Activity:** Write code in your application to read the `anatomical_data.json` file from your bundled assets when the application starts and parse its content into an in-memory data structure (e.g., an array of JavaScript objects or a Godot Array of Dictionaries).

- **Performance:** For 5-10 entries, loading and parsing on startup will be very fast.

- **Error Handling:** Implement checks for file not found or invalid JSON content.

- **Steps (Choose A or B based on your framework):**

  **A. Electron + Three.js Path:**

  1.  **[ ] Data Loading Logic (`main.js` or a utility module loaded by main):** It's often best to load data in the main process and then send it to the renderer process via IPC (Inter-Process Communication) if it's static and needed by the UI. Alternatively, for a simple app and a small JSON file, the renderer can fetch it if it's treated as a static asset. Let's try the simpler fetch for now, assuming your bundler (like Electron Forge) copies assets correctly.

      - In `renderer.js`, at the beginning (e.g., in an `async function init() {}` called on load):

        ```javascript
        let anatomicalData = [] // To store the loaded data

        async function loadKnowledgeBase() {
          try {
            // Adjust path if your assets folder is structured differently
            // relative to your HTML file or how Electron serves/bundles them.
            const response = await fetch("./assets/data/anatomical_data.json")
            if (!response.ok) {
              throw new Error(`HTTP error! status: ${response.status}`)
            }
            anatomicalData = await response.json()
            console.log("Knowledge base loaded successfully:", anatomicalData)
          } catch (error) {
            console.error("Failed to load knowledge base:", error)
            // Display a user-friendly error in the UI if possible
            // For now, an alert or console error is fine
            alert(
              "Error: Could not load anatomical data. Some features may not work."
            )
          }
        }

        // Call this early in your renderer's setup
        // await loadKnowledgeBase(); // if inside an async function
        // Or:
        // loadKnowledgeBase().then(() => { /* proceed with app init */ });
        ```

      - **_AI Assist:_** "In my Electron `renderer.js`, I want to load `anatomical_data.json` from `./assets/data/anatomical_data.json` using `Workspace`. Store the parsed array of objects in a global variable `anatomicalData`. Include error handling for file not found or invalid JSON, logging errors to the console and showing a basic `alert()` to the user if loading fails. Show me how to call this loading function when the script starts."

  **B. Godot Engine Path:**

  1.  **[ ] Data Loading Logic (e.g., in your main scene script or an autoload singleton):**

      - In a script (e.g., `main_3d_scene.gd` or a new autoload script called `KnowledgeBase.gd`):

        ```gdscript
        # In KnowledgeBase.gd (Autoload Singleton)
        extends Node

        var anatomical_data: Array = []

        func _ready():
            load_data()

        func load_data():
            var file_path = "res://assets/data/anatomical_data.json"
            var file = FileAccess.open(file_path, FileAccess.READ)

            if FileAccess.file_exists(file_path) and file: # Check existence before opening
                var json_string = file.get_as_text()
                file.close() # Close file immediately after reading

                var json = JSON.new()
                var error = json.parse(json_string) # Godot 4.x
                # For Godot 3.x: var error = json.parse_string(json_string);

                if error == OK:
                    anatomical_data = json.get_data() # Godot 4.x
                    # For Godot 3.x: anatomical_data = json.get_data() if json.get_data() else json.result (check type)
                    if typeof(anatomical_data) == TYPE_ARRAY:
                        print("Knowledge base loaded successfully: ", anatomical_data.size(), " entries.")
                    else:
                        printerr("Failed to parse JSON or data is not an array. Parsed type: ", typeof(anatomical_data))
                        anatomical_data = [] # Ensure it's an empty array on failure
                        # Optionally, show a user-friendly error in UI
                else:
                    printerr("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
                    # Optionally, show a user-friendly error in UI
            else:
                printerr("Failed to open knowledge base file: ", file_path, " Error code: ", FileAccess.get_open_error())
                # Optionally, show a user-friendly error in UI

        func get_structure_info(structure_id: String):
            for entry in anatomical_data:
                if entry.has("id") and entry.id == structure_id:
                    return entry
            return null # Not found
        ```

      - To make `KnowledgeBase.gd` an autoload, go to Project \> Project Settings \> Autoload, add the script, and give it a global name (e.g., `KB`). You can then access its data via `KB.anatomical_data` or `KB.get_structure_info("some_id")`.
      - **_AI Assist:_** "Create a GDScript (Godot 4.x) for an Autoload Singleton named `KnowledgeBase`. It should:
        1.  Have a variable `anatomical_data` (Array).
        2.  In `_ready()`, call a function `load_data()`.
        3.  `load_data()` should:
            a. Open `res://assets/data/anatomical_data.json`.
            b. Read its text content.
            c. Parse the JSON string into `anatomical_data`.
            d. Include robust error handling for file not found and JSON parsing errors (print errors to console).
            e. Log success and the number of entries loaded.
        4.  Add a helper function `get_structure_info(structure_id: String)` that searches `anatomical_data` for an entry with a matching `id` and returns the entry (or null)."

- **Checkpoint/Perfection Criteria:**

  - **[ ]** Application launches without errors related to data loading.
  - **[ ]** Console/Output logs indicate successful loading and parsing of `anatomical_data.json`, showing the correct number of entries.
  - **[ ]** If the JSON file is intentionally corrupted or missing, the application handles the error gracefully (e.g., logs error, perhaps shows a message, doesn't crash).
  - **[ ]** The parsed data is stored in an accessible variable/structure within your application.

**Task 3: Design and Implement Information Display UI Panel**

- **Activity:** Based on your `UI_UX_DESIGN_NOTES.md`, implement the actual UI elements that will display the structure's `displayName`, `shortDescription`, and `functions`. For now, these can be empty or show placeholder text.

- **UI/UX:** Refer to your sketches. Aim for clarity and readability. The panel should not obstruct the 3D view too much if it's an overlay, or should be neatly sectioned if it's a dedicated part of the layout.

- **Steps (Choose A or B):**

  **A. Electron + Three.js Path:**

  1.  **[ ] Add HTML Structure for Info Panel:** In `index.html`, add `div` elements for the panel and its internal components (title, description, functions list). Give them IDs.
      - Example:
        ```html
        <div
          id="info-panel"
          style="position: absolute; top: 10px; right: 10px; width: 250px; background-color: #f0f0f0; border: 1px solid #ccc; padding: 10px; display: none;"
        >
          <h3 id="info-displayName">Structure Name</h3>
          <p id="info-shortDescription">Short description goes here...</p>
          <h4>Functions:</h4>
          <ul id="info-functionsList">
            <li>Function 1...</li>
          </ul>
        </div>
        ```
  2.  **[ ] Style with CSS (Basic):** Add some basic CSS for positioning, padding, font sizes either inline or in a linked CSS file. Initially, you might set `display: none;` on the main panel div.
      - **_AI Assist:_** "I have an HTML `div` with `id='info-panel'` that contains an `h3` (id `info-displayName`), a `p` (id `info-shortDescription`), and a `ul` (id `info-functionsList`). Provide CSS to style this panel to be fixed to the top-right of the screen, with a width of 250px, light grey background, padding, and a border. Also, how can I make it initially hidden using CSS?"

  **B. Godot Engine Path:**

  1.  **[ ] Add UI Nodes:** In your main 3D scene (`main_3d_scene.tscn` or a dedicated UI scene instanced into it), under your `CanvasLayer` node:
      - Add a `PanelContainer` (e.g., name it `InfoPanel`). Set its layout (e.g., top-right using Anchors/Offsets in Layout panel, or center-right). Give it a stylebox for background/border.
      - Inside `InfoPanel`, add a `VBoxContainer` for vertical arrangement.
      - Inside `VBoxContainer`, add:
        - A `Label` node for the title (e.g., name `DisplayNameLabel`). Set its horizontal alignment to center or fill.
        - A `RichTextLabel` node for the description (e.g., name `ShortDescriptionLabel`). Set `Fit Content` to true.
        - Another `Label` for "Functions:" text.
        - A `VBoxContainer` or multiple `Label` nodes for the list of functions (e.g., name it `FunctionsListContainer`).
  2.  **[ ] Configure UI Node Properties:** Adjust font sizes, colors, alignment, margins in the Inspector for these nodes. Initially, `InfoPanel` can be set to `visible = false`.
      - **_AI Assist:_** "In my Godot UI (under a CanvasLayer), I want to create an information panel. It should contain:
        1.  A `Label` for a title (`DisplayNameLabel`).
        2.  A `RichTextLabel` for a multi-line description (`ShortDescriptionLabel`).
        3.  Another `Label` saying 'Functions:'.
        4.  A way to list 2-3 function strings vertically (perhaps another `VBoxContainer` with child `Label`s, or by setting `RichTextLabel` text).
            Arrange these vertically within a `PanelContainer` styled with a light background. How do I set this panel to be initially invisible?"

- **Checkpoint/Perfection Criteria:**

  - **[ ]** The UI elements for the information panel are present in the application window (even if hidden or showing placeholder text).
  - **[ ]** The layout roughly matches your UI sketch from `UI_UX_DESIGN_NOTES.md`.
  - **[ ]** The panel is styled minimally for readability.

**Task 4: Dynamically Display Information from Knowledge Base on Selection**

- **Activity:** Modify your 3D object selection logic (from Phase 1). When a mesh is selected, use its `name` or a custom ID property (which MUST match an `id` in your `anatomical_data.json`) to find the corresponding data in your loaded knowledge base. Then, update the UI panel (from Task 3) with this dynamic information.

- **Data Management:** The critical link here is matching the selected 3D object's identifier to the `id` field in your JSON entries.

- **Walking Skeleton:** This completes the core loop: See 3D -\> Select Part -\> Get Info from Data -\> Display Info in UI.

- **Clean Code:** Create a dedicated function `updateInfoPanel(structureData)` that takes the structure's data object and populates the UI.

- **Steps (Choose A or B):**

  **A. Electron + Three.js Path:**

  1.  **[ ] Modify Selection Logic:** In `renderer.js`, where you handle raycasting results (Phase 1, Task 4):

      - When `selectedObject` is identified, get its identifier. This is likely `selectedObject.name` if your GLTF meshes are well-named and these names match the `id` fields in your JSON. If not, you might need to have pre-processed your GLTF or have a mapping. For MVP, assume `selectedObject.name` is the key.
      - Find the corresponding entry in your `anatomicalData` array (loaded in Task 2).

        ```javascript
        // Inside your selection logic, after identifying selectedObject
        // Assume anatomicalData is the array of objects loaded from JSON
        const objectId = selectedObject.name // Or another unique property
        const structureInfo = anatomicalData.find(
          (entry) => entry.id === objectId
        )

        updateInfoPanel(structureInfo)
        ```

  2.  **[ ] Create `updateInfoPanel(structureInfo)` function:**

      ```javascript
      const infoPanel = document.getElementById("info-panel")
      const displayNameEl = document.getElementById("info-displayName")
      const shortDescEl = document.getElementById("info-shortDescription")
      const functionsListEl = document.getElementById("info-functionsList")

      function updateInfoPanel(data) {
        if (data) {
          displayNameEl.textContent = data.displayName || "N/A"
          shortDescEl.textContent =
            data.shortDescription || "No description available."

          functionsListEl.innerHTML = "" // Clear previous functions
          if (data.functions && data.functions.length > 0) {
            data.functions.forEach((func) => {
              const li = document.createElement("li")
              li.textContent = func
              functionsListEl.appendChild(li)
            })
          } else {
            const li = document.createElement("li")
            li.textContent = "No specific functions listed."
            functionsListEl.appendChild(li)
          }
          infoPanel.style.display = "block" // Show panel
        } else {
          infoPanel.style.display = "none" // Hide panel if no data (or deselected)
          // Optionally, reset the static label from Phase 1 if it's separate
          document.getElementById("object-name-label").textContent = "None"
        }
      }
      // In your deselection logic (click off model), call: updateInfoPanel(null);
      ```

      - Remember to also update the static label from Phase 1 to show `data.displayName` or hide it if the new panel replaces it.
      - **_AI Assist:_** "In my Electron `renderer.js`, I have:
        1.  An array `anatomicalData` loaded from JSON. Each object has `id`, `displayName`, `shortDescription`, `functions` (array of strings).
        2.  A `selectedObject` from Three.js raycasting, where `selectedObject.name` should match an `id` in `anatomicalData`.
        3.  HTML elements: `info-displayName` (h3), `info-shortDescription` (p), `info-functionsList` (ul), and `info-panel` (div).
            Write a JavaScript function `updateInfoPanel(objectId)` that:
            a. Finds the entry in `anatomicalData` where `entry.id === objectId`.
            b. If found, populates the HTML elements with `displayName`, `shortDescription`, and lists each function as an `<li>` in `info-functionsList`. It should also make `info-panel` visible.
            c. If not found (or `objectId` is null for deselection), it should hide `info-panel`.
            d. Show how to call this function from my selection logic."

  **B. Godot Engine Path:**

  1.  **[ ] Modify Selection Logic:** In your main scene script where raycasting is handled:

      - When `selected_object` (the `MeshInstance3D`) is identified, its `selected_object.name` should match an `id` in your JSON.
      - Call the `get_structure_info(structure_id)` function from your `KnowledgeBase` autoload (Task 2) using `selected_object.name`.

        ```gdscript
        # Inside your selection logic, after identifying selected_object
        var object_id = selected_object.name
        var structure_info = KB.get_structure_info(object_id) # Assuming KB is your autoload

        update_info_panel(structure_info)
        ```

  2.  **[ ] Create `update_info_panel(structure_data)` function:**

      - Get references to your UI nodes (e.g., `onready var display_name_label = %DisplayNameLabel` etc., using unique scene names is good).

        ```gdscript
        @onready var info_panel_node = $CanvasLayer/InfoPanel # Or %InfoPanel if unique name set
        @onready var display_name_label_node = %DisplayNameLabel # Assuming unique names
        @onready var short_desc_label_node = %ShortDescriptionLabel
        @onready var functions_list_container_node = %FunctionsListContainer
        # (Assuming FunctionsListContainer is a VBoxContainer where you'll add Labels for functions)

        func update_info_panel(data: Dictionary):
            if data:
                display_name_label_node.text = data.get("displayName", "N/A")
                short_desc_label_node.text = data.get("shortDescription", "No description available.")

                # Clear previous functions
                for child in functions_list_container_node.get_children():
                    child.queue_free()

                var functions_array = data.get("functions", [])
                if functions_array.size() > 0:
                    for func_text in functions_array:
                        var func_label = Label.new()
                        func_label.text = "- " + func_text
                        functions_list_container_node.add_child(func_label)
                else:
                    var func_label = Label.new()
                    func_label.text = "- No specific functions listed."
                    functions_list_container_node.add_child(func_label)

                info_panel_node.visible = true
            else:
                info_panel_node.visible = false
                # Optionally, reset the static label from Phase 1 if it's separate
                # object_name_label.text = "Selected: None"

        # In your deselection logic (click off model), call: update_info_panel(null)
        ```

      - The static label from Phase 1 can now be removed or repurposed to show `data.displayName`.
      - **_AI Assist:_** "In my Godot (GDScript) main scene script, I have:
        1.  Access to `KB.get_structure_info(id)` which returns a Dictionary with `displayName`, `shortDescription`, `functions` (Array of Strings), or null.
        2.  UI Nodes: `InfoPanel` (PanelContainer), `DisplayNameLabel` (Label), `ShortDescriptionLabel` (RichTextLabel), `FunctionsListContainer` (VBoxContainer). Assume I have `@onready` vars for these.
            Write a GDScript function `update_info_panel(structure_id: String)` that:
            a. Calls `KB.get_structure_info(structure_id)`.
            b. If data is found, it populates `DisplayNameLabel`, `ShortDescriptionLabel`. For functions, it clears `FunctionsListContainer` and adds a new Label child for each function string. It makes `InfoPanel` visible.
            c. If no data (or `structure_id` is null for deselection), it hides `InfoPanel`.
            Show how to call this from my selection logic where I have the `selected_object.name`."

- **Checkpoint/Perfection Criteria:**

  - **[ ]** When a 3D brain structure (for which you created a JSON entry with a matching `id`) is selected, the UI panel becomes visible.
  - **[ ]** The panel correctly displays the `displayName`, `shortDescription`, and list of `functions` from the corresponding entry in `anatomical_data.json`.
  - **[ ]** Information for different selectable structures is correctly displayed when they are selected one after another.
  - **[ ]** If a non-documented part is clicked, or selection is cleared, the info panel hides or shows appropriate "No information" text.
  - **[ ]** The old static mesh name label from Phase 1 is either correctly updated with `displayName` or has been removed/hidden if the new panel serves its purpose.

---

**7. Common Challenges & Troubleshooting in Phase 2:**

- **JSON file not loading:** Incorrect path, file not bundled correctly (check build process), permissions issues (less common for bundled read-only assets).
- **JSON parsing errors:** Syntax errors in `anatomical_data.json`. Use a validator. Check for missing commas, mismatched brackets/braces, incorrect string quoting.
- **Information not displaying or wrong information showing:**
  - **ID Mismatch:** The `id` in your JSON _must exactly match_ the identifier used for selection from the 3D model (e.g., `selectedObject.name`). Case sensitivity matters\! Log both the selected 3D object's ID and the IDs you are checking against in your JSON.
  - Logic errors in finding the correct entry in your parsed data array/dictionary.
  - UI elements not correctly referenced in code, or text not being set properly.
- **UI panel layout issues:** Consult CSS (Electron) or Godot's UI layout/container documentation. Use the editor's/browser's inspection tools.
- **_AI Assist for Debugging:_** "My `anatomical_data.json` seems to load, but when I click a 3D object named 'FrontalLobe_Mesh', its information doesn't appear in the UI. Here's my JSON entry: `[paste entry]` and here's my code that tries to find and display it: `[paste code]`. The console shows my selected object ID is indeed 'FrontalLobe_Mesh'. What could be wrong?"

**8. Leveraging Your AI Assistants Effectively in Phase 2:**

- **JSON Structure & Validation:** "Can you validate this JSON snippet for me?" "Is this an efficient way to structure my anatomical data in JSON for quick lookups by ID?"
- **File I/O Code:** "Show me the most robust way to read and parse a local JSON file on startup in [Electron renderer with error handling / Godot GDScript ensuring file closure]."
- **UI Population Logic:** "I have a JavaScript object `structureData` and HTML elements X, Y, Z. Write a function to populate these elements from the object's properties." (Similar for Godot and its UI nodes).
- **Debugging Data Issues:** "My function to find an object by ID in my `anatomicalData` array isn't returning the correct item. Here's the function and an example of my array: [paste]. Can you spot the error?"

**9. Phase 2 Completion Criteria / "Definition of Done"**

You have "perfected" and completed Phase 2 when:

- **[ ]** `anatomical_data.json` is created, validated, and populated with accurate initial information for at least 5-10 key structures with matching 3D model IDs.
- **[ ]** The application successfully loads and parses `anatomical_data.json` on startup without errors, making the data accessible internally. Graceful error handling is in place for file-not-found or parse errors.
- **[ ]** A designated UI panel/area for displaying anatomical information is implemented and styled for basic readability.
- **[ ]** Selecting a documented 3D brain structure _correctly and consistently_ updates the UI panel with its `displayName`, `shortDescription`, and `functions` retrieved from the loaded JSON data.
- **[ ]** Selecting a different documented structure updates the panel with the new information.
- **[ ]** If a non-documented part (or no part) is selected, the panel is hidden or displays a clear "No information available" or "None selected" message.
- **[ ]** All code developed in this phase is committed to Git with clear messages.
- **[ ]** You understand the flow of data from JSON file to in-memory structure to UI display.
- **[ ]** Core documentation (`KNOWLEDGE_BASE_SCHEMA_AND_CONTENT_PLAN.md`, `DATA_STORAGE_AND_ACCESS_PLAN.md`, `UI_UX_DESIGN_NOTES.md`, `README.md`) is updated to reflect the implemented features and data structures.

---

**10. Next Steps (Transition to Phase 3)**

Excellent work\! You now have an application that not only visualizes a 3D model but also provides valuable, context-specific information. This is a significant step towards an educational tool.

The next stage is **Phase 3: In-App AI Assistant (via Online API) & Basic Q\&A**. In Phase 3, you will:

- Research and select a free-tier online LLM API.
- Implement the logic to make API calls to this service.
- Design simple prompts to ask the AI for explanations or answers related to the selected brain structure.
- Display the AI's responses in your UI, adding another layer of interactive learning.

---

This phase requires meticulous attention to data accuracy and the crucial link between your 3D model's selectable parts and your knowledge base IDs. Double-check everything, test thoroughly, and leverage your AI assistants for any coding or conceptual hurdles.
