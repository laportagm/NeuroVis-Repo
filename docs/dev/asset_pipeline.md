# A1-NeuroVis Asset Pipeline

This document outlines the preferred formats, import settings, and organization for various assets used in the A1-NeuroVis project.

## General Asset Organization:
- All project-specific assets should be stored within the `res://assets/` directory.
- Subdirectories within `assets/` are used to categorize asset types:
    - `assets/data/`: For raw data files (e.g., `.json`, `.csv` defining neural networks).
    - `assets/icons/`: For UI icons and other 2D graphical elements.
    - `assets/models/`: For 3D models (e.g., neuron representations, environment elements).
    - `assets/textures/`: For image textures used by 3D models or UI.
    - `assets/materials/`: (Consider creating if custom materials become numerous) For saved Godot Material resources (`.tres` or `.material`).
    - `assets/shaders/`: (This is a top-level directory, but related to assets) For `.gdshader` files.

## 3D Models:
-   **Preferred Format:** `glTF 2.0` (either `.glb` for binary or `.gltf` + associated files). This format is well-supported by Godot and generally includes materials, textures, and animations.
-   **Import Settings (Defaults & Key Considerations):**
    -   When importing, review Godot's import dock settings.
    -   **Meshes:** Ensure `Save to File` is often enabled for meshes to allow easier reuse and prevent data loss if the source file is moved. Consider compression settings if performance becomes an issue.
    -   **Materials:** Decide whether to keep materials embedded or save them as separate `.tres` files (useful for sharing materials across multiple models).
    -   **Textures:** Similar to materials, decide on embedding or externalizing.
    -   **Animation:** If models have animations, ensure they are imported correctly.
-   **Scale:** Ensure models are exported from their creation software at a scale appropriate for the Godot scene, or adjust import scale settings in Godot.

## Textures:
-   **Preferred Formats:**
    -   `.png`: For general-purpose textures, especially those requiring transparency.
    -   `.jpg`: For opaque textures where file size is a concern and slight quality loss is acceptable (e.g., some environment textures).
    -   `.exr` or `.hdr`: For High Dynamic Range (HDR) textures, typically used for skyboxes or emission maps.
-   **Import Settings:**
    -   **Compression:** Use `VRAM Compressed` for most textures to save memory on the GPU. Choose `Lossless`, `Lossy`, or `Uncompressed` based on quality needs.
    -   **Mipmaps:** Generally enable `Generate Mipmaps` for 3D textures to improve rendering quality at a distance and reduce aliasing.
    -   **sRGB:** Ensure `sRGB` is set correctly (usually `Enabled` for color textures, `Disabled` for normal maps, roughness, metallic, etc.).
    -   **Repeat/Filter:** Set as needed (e.g., `Enabled` for tiling textures).

## Icons & 2D Graphics (UI):
-   **Preferred Format:** `.svg` (Scalable Vector Graphics) for icons that need to scale cleanly. `.png` is also acceptable.
-   **Import Settings:**
    -   For `.svg`, Godot typically handles scaling well.
    -   For `.png` icons, ensure `Filter` is disabled if pixel-perfect rendering is desired, or enabled for smoother scaling.

## Data Files (e.g., Network Definitions):
-   **Preferred Formats:**
    -   `.json`: Easy to parse in GDScript, human-readable.
    -   `.csv`: Suitable for tabular data.
-   **Storage:** Store in `res://assets/data/`.
-   **Loading:** Use Godot's `FileAccess` class or `JSON.parse_string()` for loading and parsing.

## Shaders:
-   Custom shaders (`.gdshader` files) are stored in the top-level `res://shaders/` directory.
-   Clearly comment shaders regarding their purpose and parameters.

*(This document should be updated if new asset types are introduced or conventions change.)*