**Phase 1: Core 3D Visualization & Basic Interaction**.

This document assumes you have successfully completed all tasks and met all checkpoints outlined in `PHASE_0_FOUNDATIONS_AND_SETUP.md`. You should have your development environment ready, a chosen (even if still tentative) primary framework (Electron or Godot), your initial documentation suite, and your starting 3D model asset.

---

### `PHASE_1_CORE_3D_VISUALIZATION_AND_BASIC_INTERACTION.md`

**Project:** AI-Enhanced Brain Anatomy Visualizer (Desktop)
**Phase:** 1 - Core 3D Visualization & Basic Interaction
**Version:** 1.0
**Date:** Thursday, May 15, 2025
**Location:** Ardmore, Pennsylvania, United States

**Phase Goal:** To bring the static 3D brain model to life within the chosen desktop application framework by successfully loading and displaying it, implementing intuitive mouse-driven camera controls (orbit, zoom, pan), enabling click-to-select functionality for distinct model parts with visual highlighting, and displaying the name of the selected part in a simple UI label. This phase creates the foundational interactive experience.

---

**1. Introduction**

Welcome to Phase 1! This is where your planning from Phase 0 starts to take tangible shape. The primary objective here is to get your 3D brain model rendered within your application window and make it interactive in a basic way. By the end of this phase, you will have a "walking skeleton" of the core 3D viewing experience. We will focus on the "Must-Have" features related to basic 3D interaction.

---

**2. Prerequisites for Starting Phase 1**

- **[ ] All Phase 0 tasks and checkpoints are completed and "perfected."**
  - Development environment (macOS) is fully operational.
  - All nine initial documentation files (Project Brief, Tech Specs, Dev Plan, User Stories, UI/UX Notes, KB Schema, Data Storage Plan, Content Expansion Plan, AI Modularity Plan) are drafted.
  - A tentative primary development framework (Electron + Three.js OR Godot Engine) has been chosen.
  - The main project directory is set up for the chosen framework and under Git version control, linked to a remote repository.
  - At least one suitable 3D brain model (GLTF) is acquired and accessible in your project's assets.
  - You have identified the names/IDs of a few distinct meshes within this model for selection testing.

---

**3. Applying Core Development Principles in Phase 1**

Remember to actively apply the 13 development principles discussed as you work through this phase:

- **Feature Categorization/Boundaries:** We are focusing _only_ on M1-M4 and parts of M5/M6 from `PROJECT_BRIEF.md` (3D display, navigation, selection, highlight, basic name label). No anatomical data loading from JSON yet, no in-app AI.
- **Performance:** Aim for smooth rendering (30-60 FPS) and responsive controls with your chosen 3D model.
- **UI/UX Sketching:** Your UI for this phase is minimal (the 3D view and a text label). Refer to `UI_UX_DESIGN_NOTES.md` for placement ideas for the label.
- **Data Management:** Data is primarily the 3D model file and mesh names. Highlighting involves temporarily managing material states.
- **Walking Skeleton:** Completing this phase _is_ achieving the first critical version of your walking skeleton – an app that loads, displays, and allows basic interaction with the core 3D content.
- **Incremental Development:** Each task below is broken into smaller steps. Test frequently. Commit to Git after each successful small step.
- **AI-Assisted Development:** Use your AI assistants (Claude, Gemini, ChatGPT Pro) for generating code for specific tasks, explaining new concepts, debugging issues, and suggesting clean code practices.
- **Clean, Readable, Maintainable Code:** Use meaningful names, keep functions focused, add comments for complex logic. Ask AI to review snippets.
- **Error Handling:** Implement basic error checking, especially for file loading and user interactions. Log errors to the console.
- **Testing and Debugging:** Manually test all interactions. Use Electron DevTools or Godot's debugger.
- **Deployment Strategy Considerations:** Ensure asset paths are relative. Confirm basic app window functionality.
- **AI for Documentation:** After completing the phase, update your `README.md` and other relevant documents with AI help to reflect the new capabilities.

---

**4. Key Concepts to Learn/Understand in Phase 1**

_(Refer to Phase 0, Task 3 in `PHASE_0_FOUNDATIONS_AND_SETUP.md` for AI prompt ideas to learn these if you haven't already. Understanding these is crucial for effective AI collaboration and debugging.)_

- **Core 3D Graphics:** Coordinate Systems, Meshes, Vertices, Materials, Scene Graph, Cameras, Lighting.
- **Interaction:** Raycasting, Event Handling (mouse clicks, movement, scroll).
- **Framework-Specifics:**
  - **Electron + Three.js:** `Scene`, `Camera`, `Renderer`, `GLTFLoader`, `OrbitControls`, DOM manipulation, Electron Main vs. Renderer processes.
  - **Godot Engine:** Nodes (`Node3D`, `MeshInstance3D`, `Camera3D`, `Light3D`s, `Control` nodes like `Label`), Scenes, GDScript, Signals, Input event handling, `WorldEnvironment`.

---

**5. Essential Tools & Resources for Phase 1**

- **[ ] Your Chosen Code Editor:** VS Code.
- **[ ] Your Chosen Framework & Associated Tools:**
  - **Electron Path:** Node.js, npm, Electron, Three.js library.
    - Electron Docs: [https://www.electronjs.org/docs/latest](https://www.electronjs.org/docs/latest)
    - Three.js Docs: [https://threejs.org/docs/](https://threejs.org/docs/)
  - **Godot Engine Path:** Godot Engine application.
    - Godot Docs: [https://docs.godotengine.org/en/stable/](https://docs.godotengine.org/en/stable/) (ensure you're viewing docs for your installed Godot version, e.g., 3.x or 4.x)
- **[ ] Your 3D Brain Model File** (e.g., `brain_model.glb` in `assets/models/`).
- **[ ] Your Project Documentation Files** (for reference and updates).
- **[ ] Git Client / Command Line.**

---

**6. Detailed Tasks, Checkpoints & AI Integration**

_(Follow the subsection relevant to your chosen technology: **A for Electron + Three.js**, or **B for Godot Engine**.)_

**A. Path: Electron + Three.js**

- **Task 1: Basic Scene Setup & Window Confirmation**

  - **Activity:** Ensure your Electron project (from Phase 0, Task 7) correctly opens a window and that your `renderer.js` (or equivalent) is linked and ready to host Three.js. This builds upon the "Hello World" test from Phase 0 but in your main project.
  - **UI/UX:** The application window should appear as expected by the OS.
  - **Error Handling:** Check Electron main process logs and Renderer DevTools console for any startup errors.
  - **Steps:**
    1.  **[ ] Verify `main.js`:** Ensure it creates a `BrowserWindow` and loads your main HTML file (e.g., `index.html`).
    2.  **[ ] Verify `index.html`:** It should have a container `div` (e.g., `<div id="scene-container"></div>`) for Three.js and correctly link to your `renderer.js`.
    3.  **[ ] Basic `renderer.js`:** For now, it can just have a `console.log("Renderer script loaded!");`
        - **_AI Assist:_** "Provide a minimal `main.js` for Electron that creates an 800x600 window and loads `index.html`. Also, a minimal `index.html` that includes a `div` with id `scene-container` and loads `renderer.js` as a module. Finally, a `renderer.js` that just logs a message to the console."
  - **Checkpoint/Perfection Criteria:**
    - **[ ]** Running `npm start` (or your configured script) launches the Electron application window.
    - **[ ]** The window displays the basic HTML content (if any, might be blank if styled to fill).
    - **[ ]** The "Renderer script loaded!" message appears in the Electron Developer Tools console (View > Toggle Developer Tools). No critical errors.

- **Task 2: Load and Display 3D Brain Model**

  - **Activity:** Write Three.js code in `renderer.js` to initialize a scene, camera, renderer, load your `brain_model.glb`, add basic lighting, and render it.
  - **Performance:** Model should load within a few seconds. Initial render should be quick. FPS should be high for a static scene.
  - **Data Management:** Accessing the local `.glb` file.
  - **Error Handling:** Implement `onError` for `GLTFLoader`.
  - **Steps:**
    1.  **[ ] Initialize Three.js Core Components:** In `renderer.js`, import `THREE`. Set up `Scene`, `PerspectiveCamera`, `WebGLRenderer` (append to `#scene-container`).
    2.  **[ ] Add Lighting:** Add `AmbientLight` and `DirectionalLight` to the scene. Position them appropriately.
    3.  **[ ] Implement Render Loop:** Use `requestAnimationFrame` to continuously render the scene.
        - **_AI Assist (for 1-3):_** "In my Electron `renderer.js`, using Three.js (ESM import), set up a basic scene: initialize Scene, PerspectiveCamera (fov 75, positioned at `(0,10,20)` looking at origin), WebGLRenderer attached to `#scene-container`. Add an AmbientLight (intensity 0.7) and a DirectionalLight (intensity 1.0, positioned at `(10,15,10)`). Create a render loop."
    4.  **[ ] Load GLTF Model:** Import `GLTFLoader`. Instantiate it. Use `loader.load()` to load your `brain_model.glb` (e.g., path `'./assets/models/brain_model.glb'`).
    5.  **[ ] Add Model to Scene & Adjust:** In the `onLoad` callback of the loader, add `gltf.scene` to your `THREE.Scene`. You will likely need to adjust `gltf.scene.scale.set(s,s,s)` and `gltf.scene.position.set(x,y,z)` to make the model visible and appropriately sized. You might also need to traverse the loaded scene to center it or adjust materials if they appear too dark/light.
        - **_AI Assist (for 4-5):_** "Now, in the same `renderer.js`, import `GLTFLoader`. Load my model from `'./assets/models/brain_model.glb'`. In the loader's callback, add the `gltf.scene` to my Three.js scene. Show how to log loading progress and handle loading errors. If the model is not centered or is too large, how can I programmatically try to center it (e.g., using `Box3().setFromObject().getCenter()`) and scale it (e.g., `gltf.scene.scale.set(0.1, 0.1, 0.1)`)?"
  - **Checkpoint/Perfection Criteria:**
    - **[ ]** The 3D brain model is clearly visible, well-lit, and reasonably centered in the application window when launched.
    - **[ ]** No errors in the console related to model loading or rendering.
    - **[ ]** You understand the basic code for loading and displaying the model.

- **Task 3: Implement Camera Controls (Orbit, Zoom, Pan)**

  - **Activity:** Integrate `OrbitControls` (or a similar controller) from Three.js to allow mouse-driven camera manipulation.
  - **UI/UX:** Interaction should feel intuitive and smooth.
  - **Performance:** Camera movements should not cause stuttering or significant FPS drops.
  - **Steps:**
    1.  **[ ] Import and Instantiate `OrbitControls`:** In `renderer.js`, import `OrbitControls` from `three/examples/jsm/controls/OrbitControls.js`. After your `camera` and `renderer.domElement` are initialized, create `new OrbitControls(camera, renderer.domElement)`.
    2.  **[ ] Update Controls in Render Loop:** If required by the version of `OrbitControls` or if you enable damping, call `controls.update()` inside your `requestAnimationFrame` loop.
        - **_AI Assist:_** "In my Electron/Three.js `renderer.js`, how do I add `OrbitControls` to my camera? Show the import and instantiation. Do I need to call `controls.update()` in my render loop, and if so, why?"
    3.  **[ ] Configure Controls (Optional initial step):** Adjust properties like `controls.enableDamping = true; controls.dampingFactor = 0.05;` for smoother motion if desired. `controls.target.set(x,y,z)` can set the orbit center if your model isn't at `(0,0,0)`.
        - **_AI Assist:_** "My OrbitControls feel a bit abrupt. What properties like `enableDamping` can I use to make the camera movement smoother in Three.js? How do I set the target point around which the camera orbits?"
  - **Checkpoint/Perfection Criteria:**
    - **[ ]** User can left-click and drag to orbit the camera around the brain model.
    - **[ ]** User can use the mouse scroll wheel to zoom in and out.
    - **[ ]** User can right-click (or middle-click/modifier) and drag to pan the camera view.
    - **[ ]** Controls feel reasonably smooth and predictable.

- **Task 4: Object Selection via Raycasting & Visual Highlighting**

  - **Activity:** Implement logic to detect which specific mesh within the brain model is clicked by the user and change its appearance to indicate selection.
  - **Data Management:** Will need to temporarily store/manage the original material of a selected object to allow reversion.
  - **Error Handling:** Handle cases where a click doesn't intersect an interactable object.
  - **Clean Code:** Encapsulate selection and highlighting logic into well-named functions.
  - **Steps:**
    1.  **[ ] Setup Raycaster and Mouse Vector:** In `renderer.js`, initialize `THREE.Raycaster()` and `THREE.Vector2()` (for mouse coordinates).
    2.  **[ ] Add Mouse Click Event Listener:** Listen for a 'click' (or 'mousedown') event on `renderer.domElement`.
    3.  **[ ] Raycasting Logic:**
        - Inside the event listener, calculate normalized device coordinates (NDC) for the mouse position.
        - Update the raycaster: `raycaster.setFromCamera(mouseNDC, camera)`.
        - Perform intersection: `const intersects = raycaster.intersectObjects(brainModelScene.children, true);` (assuming `brainModelScene` holds your `gltf.scene`). The `true` makes it recursive.
    4.  **[ ] Highlighting Logic:**
        - Keep track of `let previouslySelectedObject = null;` and `let originalMaterial = null;`.
        - If `intersects.length > 0`:
          - Let `selectedObject = intersects[0].object;` (ensure it's a `THREE.Mesh` and one you want to be selectable, e.g., by checking its name or userData).
          - If `previouslySelectedObject` exists and is different from `selectedObject`, revert its material: `previouslySelectedObject.material = originalMaterial;`.
          - Store the new `selectedObject`'s material: `originalMaterial = selectedObject.material.clone();` (Clone to avoid issues if multiple meshes share materials).
          - Apply a highlight: Create a new highlight material (e.g., `const highlightMaterial = selectedObject.material.clone(); highlightMaterial.color.set(0x00ff00);` or `highlightMaterial.emissive.set(0x00ff00); highlightMaterial.emissiveIntensity = 1;`) and assign it: `selectedObject.material = highlightMaterial;`.
          - Update `previouslySelectedObject = selectedObject;`.
        - Else (no intersection or not a selectable mesh):
          - If `previouslySelectedObject` exists, revert its material: `previouslySelectedObject.material = originalMaterial; previouslySelectedObject = null; originalMaterial = null;`.
        - **_AI Assist:_** "Provide the complete JavaScript code for `renderer.js` (Three.js/Electron) to implement click-based selection and highlighting for meshes within my loaded GLTF model (`brainModelScene`):
          1.  Set up Raycaster and mouse coordinate normalization on click.
          2.  Perform intersection tests specifically with children of `brainModelScene`.
          3.  If a mesh is clicked:
              a. Revert the material of any `previouslySelectedObject` to its `originalMaterial`.
              b. Store the newly clicked mesh as `previouslySelectedObject` and save its `material.clone()` as `originalMaterial`.
              c. Apply a new highlight material (e.g., clone original, then set `color.set(0x00ff00)` or `emissive.set(0x00ff00)` with `emissiveIntensity = 0.5`) to the `previouslySelectedObject`.
          4.  If the click is not on a model mesh and something was previously selected, revert its material.
              Ensure this handles distinct parts of the brain model correctly, assuming they are separate meshes."
  - **Checkpoint/Perfection Criteria:**
    - **[ ]** Clicking on a distinct, known part of the brain model visually highlights it (e.g., turns green).
    - **[ ]** Clicking on another distinct part highlights the new part and removes the highlight from the previously selected part.
    - **[ ]** Clicking on the background (off the model) deselects and unhighlights any selected part.
    - **[ ]** Selection is reasonably accurate.

- **Task 5: Display Static Name of Selected Object**
  - **Activity:** Create a minimal UI text label in your HTML and update it with the `name` property of the selected Three.js mesh.
  - **UI/UX:** Label should be unobtrusive but clear. Updates should be immediate.
  - **Data Management:** Accessing the `name` property from the `THREE.Mesh` object.
  - **Steps:**
    1.  **[ ] Add HTML Element for Label:** In `index.html`, add `<div id="info-bar" style="position: absolute; bottom: 10px; left: 10px; background-color: rgba(0,0,0,0.5); color: white; padding: 5px;">Selected: <span id="object-name-label">None</span></div>`.
    2.  **[ ] Update Label in JavaScript:** In `renderer.js`, within your selection logic (Task 4), when an object is successfully selected (or deselected):
        - Get the DOM element: `const nameLabel = document.getElementById('object-name-label');`
        - If `selectedObject` exists: `nameLabel.textContent = selectedObject.name || 'Unnamed Part';` (Use `selectedObject.name`. Meshes in GLTF files often have names. If not, you'll need another way to map them, which comes in Phase 2).
        - If deselected: `nameLabel.textContent = 'None';`
        - **_AI Assist:_** "In my Three.js selection logic, when `selectedObject` is defined (or becomes null), how do I get its `.name` property and update the text content of an HTML span with `id='object-name-label'`? Handle the case where `selectedObject.name` might be undefined."
  - **Checkpoint/Perfection Criteria:**
    - **[ ]** When a highlightable part of the brain model is clicked, its mesh name (as defined in the GLTF file) appears in the designated label area.
    - **[ ]** When selection is cleared, the label updates to "None" or similar.

**(End of Electron + Three.js Path for Phase 1)**

---

**B. Path: Godot Engine**

- **Task 1: Basic Scene Setup & Window Confirmation**

  - **Activity:** Ensure your Godot project (from Phase 0, Task 7) correctly opens a window with your main 3D scene.
  - **UI/UX:** Window appears as per OS defaults.
  - **Error Handling:** Check Godot's Output and Debugger panels for startup errors.
  - **Steps:**
    1.  **[ ] Verify Main Scene:** In Godot, ensure your `main_3d_scene.tscn` (or equivalent) is set as the "Main Scene" in Project > Project Settings > Application > Run.
    2.  **[ ] Basic Scene Contents:** Your main 3D scene should have a root `Node3D`, a `Camera3D` positioned to view the origin, a `WorldEnvironment` node, and at least one `DirectionalLight3D`.
        - **_AI Assist:_** "I'm starting Phase 1 in Godot. Remind me of the minimal nodes needed in a 3D scene (`MyMainScene.tscn`) to just see a lit environment when I run the project: Root Node, Camera, WorldEnvironment, and a Light. What are typical initial property settings for these to ensure visibility?"
  - **Checkpoint/Perfection Criteria:**
    - **[ ]** Running the Godot project (F5) opens the application window and displays an empty, lit 3D scene.
    - **[ ]** No critical errors in Godot's Output or Debugger panels.

- **Task 2: Load and Display 3D Brain Model**

  - **Activity:** Import your `brain_model.glb` into the Godot project and instance it into your main 3D scene.
  - **Performance:** Model should import and instance quickly.
  - **Data Management:** `res://` path to the imported model asset.
  - **Error Handling:** Check Godot's output for import errors.
  - **Steps:**
    1.  **[ ] Import GLTF Model:** Drag `brain_model.glb` into Godot's FileSystem dock. Select it, review Import settings (defaults usually okay initially, but ensure meshes are preserved). Re-import if settings are changed.
    2.  **[ ] Instance Model in Scene:** Drag the imported model (e.g., `brain_model.tscn` or the `.glb` itself if instancing directly) from the FileSystem dock into your `main_3d_scene.tscn` as a child of the root `Node3D`.
    3.  **[ ] Position and Scale Model:** Use the editor's transform gizmos (select the instanced model node, press W for move, E for rotate, R for scale) or the Inspector panel to position and scale the model so it's visible and appropriately sized in front of the camera.
        - **_AI Assist:_** "I've dragged my `brain_model.glb` into Godot's FileSystem.
          1.  What are important settings in the 'Import' dock for a GLTF model that I intend to select individual parts of later?
          2.  After instancing it in my 3D scene, how can I use the editor tools or Inspector to precisely set its position to `(0,0,0)` and scale it uniformly if it's too large or small?"
  - **Checkpoint/Perfection Criteria:**
    - **[ ]** The 3D brain model is clearly visible, well-lit, and reasonably centered when the project runs.
    - **[ ]** No errors related to model importing or instancing.

- **Task 3: Implement Camera Controls (Orbit, Zoom, Pan)**

  - **Activity:** Create and attach a GDScript to your `Camera3D` node to handle mouse-driven orbit, zoom, and pan.
  - **UI/UX:** Controls should feel intuitive and smooth.
  - **Performance:** Camera movements should be fluid.
  - **Steps:**
    1.  **[ ] Create Camera Script:** Select `Camera3D`, click the "Attach Script" icon, create a new GDScript (e.g., `orbit_camera.gd`).
    2.  **[ ] Implement Orbit Logic:**
        - Variables for `target` (e.g., `Vector3.ZERO`), `distance`, `rotation_speed`, `min_max_pitch`.
        - In `_input(event)`: if `event is InputEventMouseMotion` and left button pressed, get `event.relative` and update yaw/pitch angles. Clamp pitch.
        - In `_process(delta)`: Calculate camera position based on target, distance, yaw, and pitch. Use `transform.looking_at(target, Vector3.UP)`.
    3.  **[ ] Implement Zoom Logic:** In `_input(event)`: if `event is InputEventMouseButton`: if `event.button_index == MOUSE_BUTTON_WHEEL_UP`, decrease distance; if `MOUSE_BUTTON_WHEEL_DOWN`, increase distance. Clamp distance.
    4.  **[ ] Implement Pan Logic:** In `_input(event)`: if `event is InputEventMouseMotion` and right/middle button pressed, calculate camera's right/up vectors and move the `target` based on `event.relative` scaled by these vectors.
        - **_AI Assist:_** "Provide a complete GDScript for an `orbit_camera.gd` (for Godot 4.x or 3.x, please specify which) to attach to a Camera3D. It should:
          1.  Orbit around a `target` point (initially `Vector3.ZERO`) using left-mouse-drag (affecting yaw and pitch).
          2.  Zoom by changing `distance` to target using mouse wheel.
          3.  Pan by moving the `target` point using right-mouse-drag (or middle-mouse-drag).
          4.  Include variables for sensitivity, zoom speed, and pitch limits. Explain how `_input` and `_process` are used."
  - **Checkpoint/Perfection Criteria:**
    - **[ ]** User can left-click and drag to orbit the camera around the brain model.
    - **[ ]** User can use the mouse scroll wheel to zoom in and out.
    - **[ ]** User can right-click (or middle-click) and drag to pan the camera view.
    - **[ ]** Controls feel reasonably smooth and predictable.

- **Task 4: Object Selection via Raycasting & Visual Highlighting**

  - **Activity:** Implement logic (likely in a script attached to your main scene root or a dedicated interaction manager node) to detect which `MeshInstance3D` within the brain model is clicked and change its material to indicate selection.
  - **Data Management:** Store/revert original materials.
  - **Error Handling:** Clicks not hitting anything interactable.
  - **Clean Code:** Separate functions for raycasting, highlighting, unhighlighting.
  - **Crucial Prerequisite:** Your `MeshInstance3D` parts _must_ have `CollisionShape3D` nodes for raycasting to detect them.
    1.  **[ ] Add Collision Shapes:** In the Godot editor, select your instanced brain model. For each distinct `MeshInstance3D` part you want to be selectable: select the mesh, go to the "Mesh" menu at the top of the 3D viewport editor, and choose "Create Trimesh Static Body" (or "Create Single Convex Collision Sibling" if parts are simple and convex). This adds a `StaticBody3D` parent with a `CollisionShape3D` child. Ensure the `StaticBody3D` is on a collision layer that your raycast will check.
        - **_AI Assist:_** "My imported GLTF brain model in Godot has several `MeshInstance3D` children. How do I add `CollisionShape3D`s to each of these parts so they can be detected by a physics raycast? Explain the 'Create Trimesh Static Body' option."
  - **Steps (Scripting):**
    1.  **[ ] Attach Script for Raycasting:** (e.g., to your main scene's root `Node3D`).
    2.  **[ ] Implement Raycasting in `_unhandled_input(event)`:**
        - Check for left mouse button press (`event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()`).
        - Get camera, mouse position. Project ray: `var from = camera.project_ray_origin(event.position); var to = from + camera.project_ray_normal(event.position) * RAY_LENGTH;` (Define `RAY_LENGTH` like 1000).
        - Get physics space: `var space_state = get_world_3d().direct_space_state;`
        - Intersect ray: `var query = PhysicsRayQueryParameters3D.new(); query.from = from; query.to = to; query.collide_with_areas = true; query.collide_with_bodies = true; var result = space_state.intersect_ray(query);` (Godot 4.x syntax slightly different from 3.x for query).
    3.  **[ ] Highlighting Logic:**
        - Keep track of `var previously_selected_object = null` and `var original_material = null`.
        - If `result` is not empty (i.e., `result.has("collider")`):
          - Let `selected_object = result.collider`. Check if it's a `MeshInstance3D` and if it's part of your brain model (e.g., by checking its group or parent).
          - If `previously_selected_object` exists and is different, revert its material: `previously_selected_object.set_surface_material(0, original_material)`.
          - Store new selection: `previously_selected_object = selected_object`. `original_material = selected_object.get_surface_material(0).duplicate(true)` (Duplicate to avoid modifying shared resources, `true` for deep copy).
          - Apply highlight: `var highlight_material = original_material.duplicate(true); highlight_material.albedo_color = Color.GREEN; selected_object.set_surface_material(0, highlight_material);`
        - Else (no valid intersection):
          - If `previously_selected_object` exists, revert it: `previously_selected_object.set_surface_material(0, original_material); previously_selected_object = null; original_material = null;`
        - **_AI Assist:_** "Provide GDScript (Godot 4.x or 3.x) for a script attached to my main scene root. It should:
          1.  In `_unhandled_input(event)`, perform a raycast from a left mouse click.
          2.  If it hits a `MeshInstance3D` (which has a `StaticBody3D` parent), store it as `selected_object`.
          3.  If a `previously_selected_object` exists, revert its material using a stored `original_material`.
          4.  Store the `selected_object`'s current surface material (index 0) as `original_material` (ensure it's a duplicated/unique instance).
          5.  Set the `selected_object`'s surface material (index 0) to a new material with `albedo_color = Color.GREEN`.
          6.  Update `previously_selected_object`. If click is not on a mesh, revert any selection."
  - **Checkpoint/Perfection Criteria:**
    - **[ ]** Clicking on a distinct part of the brain model (that has a collision shape) visually highlights it (e.g., turns green).
    - **[ ]** Clicking on another distinct part highlights the new part and removes the highlight from the previously selected part.
    - **[ ]** Clicking off the model deselects and unhighlights any selected part.

- **Task 5: Display Static Name of Selected Object**
  - **Activity:** Create a Godot `Label` node in your UI and update it with the `name` property of the selected `MeshInstance3D`.
  - **UI/UX:** Label is unobtrusive but clear; updates immediately.
  - **Data Management:** Accessing the `name` property of the Godot node.
  - **Steps:**
    1.  **[ ] Add UI Label Node:** In your main 3D scene, add a `CanvasLayer` node. As a child of `CanvasLayer`, add a `Label` node. Position it using anchors/margins (e.g., top-left, or bottom-left via Layout presets). In the Inspector, name this Label node (e.g., `ObjectNameLabel`). Set its initial text to "Selected: None".
    2.  **[ ] Update Label in Script:** In the script handling selection (from Task 4):
        - Get a reference to the label, e.g., `onready var object_name_label = $CanvasLayer/ObjectNameLabel` (or use unique names `%ObjectNameLabel` in Godot 4).
        - When an object is selected: `object_name_label.text = "Selected: " + selected_object.name` (The `selected_object` is the `MeshInstance3D`. Its `name` is its node name in the scene tree, which usually defaults to the mesh name from the GLTF if not renamed).
        - When deselected: `object_name_label.text = "Selected: None"`.
        - **_AI Assist:_** "In my Godot scene script that handles selection, I have a reference to a Label node: `onready var object_name_label = $CanvasLayer/ObjectNameLabel`. When a `MeshInstance3D` called `selected_object` is successfully selected (or becomes `null` upon deselection), show me the GDScript to update `object_name_label.text` with its `name` property (or 'None')."
  - **Checkpoint/Perfection Criteria:**
    - **[ ]** When a highlightable part of the brain model is clicked, its Godot node name appears in the Label UI.
    - **[ ]** When selection is cleared, the label updates to "None."

**(End of Godot Engine Path for Phase 1)**

---

**7. Common Challenges & Troubleshooting in Phase 1:**

- **Model not visible:** Check camera position/direction, near/far clipping planes, lighting, model scale/position, errors in console/output.
- **Controls unresponsive/erratic:** Sensitivity settings, correct update loop usage (Three.js), input event logic (Godot), target point for orbit.
- **Selection not working:**
  - **Both:** Incorrect mouse coordinate conversion, raycaster not aimed correctly, target object list for raycaster is wrong.
  - **Godot:** Crucially, `MeshInstance3D`s _must_ have `CollisionShape3D` siblings (often under a `StaticBody3D` parent) for physics raycasts to detect them. Check collision layers/masks.
- **Highlighting issues:** Modifying shared materials (always `clone()`/`duplicate()` material before changing if it might be shared), incorrect material property being changed, highlight color too similar to original.
- **_AI Assist for Debugging:_** "My [Electron/Three.js OR Godot] app isn't [specific problem, e.g., highlighting the clicked mesh]. Here's my code for [selection/highlighting logic]: [paste code]. I've verified [any steps you've already checked]. What could be wrong?"

**8. Leveraging Your AI Assistants Effectively in Phase 1:**

- **Framework-Specific Boilerplate:** "Generate the Three.js code to..." or "Show me the GDScript to..."
- **Understanding API calls:** "Explain the parameters for `raycaster.setFromCamera()` in Three.js." or "What does `get_world_3d().direct_space_state.intersect_ray()` return in Godot?"
- **Debugging Logic:** "My camera in Godot seems to flip upside down when I orbit past a certain point. Here's my camera script [paste]. How can I clamp the pitch rotation?"
- **Refactoring:** "This selection function in [JavaScript/GDScript] works but looks messy [paste code]. Can you help me refactor it for better readability?"

**9. Phase 1 Completion Criteria / "Definition of Done"**

You have "perfected" and completed Phase 1 when:

- **[ ]** Your chosen framework (Electron+Three.js OR Godot) successfully loads and displays your primary 3D brain model clearly within the application window.
- **[ ]** Mouse-driven camera controls (orbit, zoom, pan) are implemented and function smoothly and intuitively.
- **[ ]** Clicking on at least 3-5 distinct, pre-identified parts of the 3D model correctly triggers a visual highlight on the selected part.
- **[ ]** Highlighting is exclusive: selecting a new part removes the highlight from the previously selected part. Clicking off the model clears any selection/highlight.
- **[ ]** A simple UI label correctly displays the static name (mesh name/node name) of the currently selected part, updating with each valid selection.
- **[ ]** The application runs without critical errors related to these core features.
- **[ ]** All code developed in this phase has been committed to your Git repository with clear messages.
- **[ ]** You understand the fundamental code and concepts implemented in this phase.
- **[ ]** Your `README.md` and potentially `UI_UX_DESIGN_NOTES.md` have been updated to reflect the current state.

---

**10. Next Steps (Transition to Phase 2)**

Congratulations on completing the core interactive 3D foundation! This is a major milestone.

The next step is **Phase 2: Basic Information Display & Local Knowledge Base Integration**. In Phase 2, you will:

- Curate your initial `anatomical_data.json` file with actual names, descriptions, and functions for the selectable parts.
- Implement logic to load this JSON data.
- Enhance your UI to display this richer information when a brain structure is selected, replacing the static mesh name display with more meaningful content.

---

Take your time with Phase 1. It involves many new concepts. Test each small step, use your AI assistants extensively for both coding and explanation, and don't hesitate to revisit or relearn concepts as needed. Good luck!
