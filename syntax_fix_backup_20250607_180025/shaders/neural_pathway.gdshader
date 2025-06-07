// Neural Pathway Shader for NeuroVis
// Creates glowing neural pathway effects
shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_opaque, depth_test_disabled;

// Uniforms
uniform vec3 pathway_color : source_color = vec3(0.0, 0.85, 1.0);
uniform float glow_intensity : hint_range(0.0, 5.0) = 2.0;
uniform float pulse_speed : hint_range(0.0, 10.0) = 2.0;
uniform float line_thickness : hint_range(0.001, 0.1) = 0.01;
uniform float flow_speed : hint_range(0.0, 5.0) = 1.0;

// Signal flow animation
uniform sampler2D flow_texture : hint_default_white;
uniform float signal_size : hint_range(0.0, 1.0) = 0.1;
uniform float signal_spacing : hint_range(0.0, 2.0) = 0.5;

varying float line_coord;
varying vec3 world_position;

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    line_coord = UV.x; // Assuming UV.x represents position along the line
}

void fragment() {
    // Pulsing effect
    float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
    
    // Flow animation
    float flow_offset = TIME * flow_speed;
    float signal_pattern = fract(line_coord * signal_spacing + flow_offset);
    
    // Create signal "blobs" moving along the pathway
    float signal = smoothstep(signal_size, 0.0, abs(signal_pattern - 0.5) * 2.0);
    
    // Combine base glow with signal
    float intensity = glow_intensity * (0.7 + 0.3 * pulse);
    vec3 base_glow = pathway_color * intensity;
    vec3 signal_glow = pathway_color * signal * 3.0;
    
    // Edge fade for smooth line appearance
    float edge_fade = 1.0 - smoothstep(0.0, line_thickness, abs(UV.y - 0.5));
    
    // Final color
    EMISSION = (base_glow + signal_glow) * edge_fade;
    ALPHA = edge_fade;
    
    // Add some variation based on world position
    float noise = sin(world_position.x * 10.0) * sin(world_position.y * 10.0) * sin(world_position.z * 10.0);
    EMISSION += pathway_color * noise * 0.1;
}
