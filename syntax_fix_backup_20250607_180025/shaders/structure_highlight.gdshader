// Structure Highlight Shader for NeuroVis
// Highlights brain structures with customizable effects
shader_type spatial;

// Uniforms
uniform vec3 highlight_color : source_color = vec3(0.0, 1.0, 1.0);
uniform float highlight_strength : hint_range(0.0, 5.0) = 2.0;
uniform float rim_power : hint_range(0.0, 10.0) = 2.0;
uniform float pulse_speed : hint_range(0.0, 5.0) = 2.0;
uniform bool use_rim_lighting = true;
uniform bool use_pulse = true;

// Textures
uniform sampler2D albedo_texture : source_color;
uniform sampler2D normal_texture : hint_normal;
uniform sampler2D emission_texture : hint_default_black;

// Pattern overlay
uniform sampler2D pattern_texture : hint_default_white;
uniform float pattern_scale : hint_range(0.1, 10.0) = 2.0;
uniform float pattern_strength : hint_range(0.0, 1.0) = 0.3;

varying vec3 world_normal;
varying vec3 view_vector;
varying vec3 world_pos;

void vertex() {
    world_normal = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
    vec4 world_position = MODEL_MATRIX * vec4(VERTEX, 1.0);
    world_pos = world_position.xyz;
    view_vector = normalize(CAMERA_POSITION_WORLD - world_position.xyz);
}

void fragment() {
    // Base color
    vec4 albedo = texture(albedo_texture, UV);
    ALBEDO = albedo.rgb;
    
    // Normal mapping
    vec3 normal_map = texture(normal_texture, UV).xyz;
    NORMAL_MAP = normal_map;
    
    // Calculate rim lighting
    float rim = 1.0;
    if (use_rim_lighting) {
        float fresnel = dot(world_normal, view_vector);
        rim = 1.0 - clamp(fresnel, 0.0, 1.0);
        rim = pow(rim, rim_power);
    }
    
    // Pulse effect
    float pulse = 1.0;
    if (use_pulse) {
        pulse = sin(TIME * pulse_speed) * 0.3 + 0.7;
    }
    
    // Pattern overlay
    vec2 pattern_uv = world_pos.xz * pattern_scale;
    float pattern = texture(pattern_texture, pattern_uv).r;
    pattern = mix(1.0, pattern, pattern_strength);
    
    // Combine effects
    vec3 highlight_emission = highlight_color * highlight_strength;
    highlight_emission *= rim * pulse * pattern;
    
    // Add base emission texture
    vec3 base_emission = texture(emission_texture, UV).rgb;
    
    // Final emission
    EMISSION = base_emission + highlight_emission;
    
    // Material properties
    METALLIC = 0.0;
    ROUGHNESS = 0.7;
    SPECULAR = 0.5;
    
    // Subtle subsurface scattering effect for organic look
    RIM = rim * 0.2;
    RIM_TINT = 0.5;
    
    // Alpha
    ALPHA = albedo.a;
}

// Custom lighting function for enhanced highlight effect
void light() {
    // Get light direction and view direction
    vec3 light_dir = normalize(LIGHT);
    vec3 view_dir = normalize(VIEW);
    vec3 half_vector = normalize(light_dir + view_dir);
    
    // Enhanced specular for highlighted structures
    float spec = pow(max(dot(NORMAL, half_vector), 0.0), 32.0);
    SPECULAR_LIGHT += spec * highlight_color * highlight_strength * 0.5;
}
