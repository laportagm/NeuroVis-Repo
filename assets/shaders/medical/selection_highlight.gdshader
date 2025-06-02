shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_back;

// Highlight properties
uniform vec4 highlight_color : source_color = vec4(0.3, 0.7, 1.0, 0.3);
uniform float highlight_width : hint_range(0.0, 1.0) = 0.3;
uniform float highlight_intensity : hint_range(0.0, 2.0) = 1.0;
uniform float pulse_speed : hint_range(0.0, 10.0) = 3.0;
uniform bool enable_pulse = true;

// Outline settings
uniform bool outline_only = false;
uniform float outline_width : hint_range(0.0, 0.1) = 0.005;

// Depth settings
uniform bool depth_fade_enabled = true;
uniform float depth_fade_distance : hint_range(0.0, 10.0) = 2.0;

// Advanced settings
uniform bool educational_mode = false;
uniform vec4 educational_accent_color : source_color = vec4(1.0, 0.8, 0.0, 0.5);
uniform bool multi_selection = false;
uniform int selection_index = 0;

varying vec3 vertex_world_pos;
varying vec3 vertex_normal;
varying float vertex_depth;

void vertex() {
	// Standard vertex data
	vertex_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vertex_normal = NORMAL;
	
	// Calculate vertex depth for depth effects
	vertex_depth = length(CAMERA_POSITION_WORLD - vertex_world_pos);
	
	// For outline effect, slightly enlarge the mesh along normals
	if (outline_only) {
		VERTEX += NORMAL * outline_width;
	}
}

void fragment() {
	// Calculate view direction
	vec3 view_dir = normalize(CAMERA_POSITION_WORLD - vertex_world_pos);
	
	// Calculate fresnel effect for edge highlighting
	float fresnel = pow(1.0 - clamp(dot(vertex_normal, view_dir), 0.0, 1.0), 3.0);
	
	// Apply depth fade
	float alpha = highlight_color.a;
	if (depth_fade_enabled) {
		alpha *= 1.0 - exp(-vertex_depth / depth_fade_distance);
	}
	
	// Calculate pulsing effect
	float pulse = 1.0;
	if (enable_pulse) {
		pulse = 0.5 + 0.5 * sin(TIME * pulse_speed);
	}
	
	// Calculate final color
	vec4 final_color = highlight_color;
	
	// If educational mode, add visual accent
	if (educational_mode) {
		// In educational mode, make the highlight more distinctive
		final_color = mix(highlight_color, educational_accent_color, 0.5);
		
		// Add slight pattern in educational mode (subtle grid)
		float pattern = 0.0;
		if (mod(vertex_world_pos.x * 10.0, 1.0) < 0.1 || mod(vertex_world_pos.z * 10.0, 1.0) < 0.1) {
			pattern = 0.2;
		}
		final_color.rgb += pattern * educational_accent_color.rgb;
	}
	
	// For multi-selection, vary the color slightly based on index
	if (multi_selection && selection_index > 0) {
		// Create a subtle color variation based on selection index
		float hue_shift = float(selection_index) * 0.2; // Shift by 20% per index
		
		// Simple RGB rotation for different hues (not perfect, but adequate)
		final_color.r = highlight_color.r + sin(hue_shift) * 0.5;
		final_color.g = highlight_color.g + sin(hue_shift + 2.094) * 0.5; // 120 degrees
		final_color.b = highlight_color.b + sin(hue_shift + 4.189) * 0.5; // 240 degrees
		
		// Ensure colors stay in reasonable range
		final_color.rgb = clamp(final_color.rgb, 0.0, 1.0);
	}
	
	// Different rendering approaches based on mode
	if (outline_only) {
		// For outline mode, just use the color with distance falloff
		ALBEDO = final_color.rgb * highlight_intensity * pulse;
		ALPHA = alpha * highlight_intensity;
	} else {
		// For regular highlight, use fresnel for edge emphasis
		float edge_mask = smoothstep(1.0 - highlight_width, 1.0, fresnel);
		
		ALBEDO = final_color.rgb * highlight_intensity * pulse;
		ALPHA = edge_mask * alpha * highlight_intensity * pulse;
	}
	
	// Zero out metallic and roughness since we're using additive blending
	METALLIC = 0.0;
	ROUGHNESS = 1.0;
}