// Cross-Section Shader for NeuroVis
// Clips geometry based on slice plane position
shader_type spatial;

// Uniforms
uniform int slice_axis = 0; // 0: Sagittal, 1: Coronal, 2: Axial
uniform float slice_position = 0.0;
uniform float slice_thickness = 0.01;
uniform vec3 slice_color = vec3(1.0, 0.0, 0.0);
uniform float slice_edge_glow = 2.0;

// Textures
uniform sampler2D albedo_texture : source_color;
uniform sampler2D normal_texture : hint_normal;

varying vec3 world_pos;
varying vec3 view_dir;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    view_dir = (INV_VIEW_MATRIX * vec4(0.0, 0.0, -1.0, 0.0)).xyz;
}

void fragment() {
    // Get position along the slice axis
    float pos = 0.0;
    vec3 normal_axis = vec3(0.0);
    
    if (slice_axis == 0) { // Sagittal (X-axis)
        pos = world_pos.x;
        normal_axis = vec3(1.0, 0.0, 0.0);
    } else if (slice_axis == 1) { // Coronal (Z-axis)
        pos = world_pos.z;
        normal_axis = vec3(0.0, 0.0, 1.0);
    } else { // Axial (Y-axis)
        pos = world_pos.y;
        normal_axis = vec3(0.0, 1.0, 0.0);
    }
    
    // Calculate distance from slice plane
    float distance = abs(pos - slice_position);
    
    // Discard fragments beyond the slice
    if (pos > slice_position + slice_thickness) {
        discard;
    }
    
    // Base color from texture
    vec4 tex_color = texture(albedo_texture, UV);
    ALBEDO = tex_color.rgb;
    
    // Add edge glow for slice plane
    if (distance < slice_thickness * 2.0) {
        float edge_factor = 1.0 - (distance / (slice_thickness * 2.0));
        EMISSION = slice_color * edge_factor * slice_edge_glow;
    }
    
    // Normal mapping
    NORMAL_MAP = texture(normal_texture, UV).xyz;
    
    // Metallic and roughness
    METALLIC = 0.0;
    ROUGHNESS = 0.8;
    
    // Alpha handling
    ALPHA = tex_color.a;
}
