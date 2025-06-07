shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

// Basic material properties
uniform vec4 albedo : source_color = vec4(0.8, 0.75, 0.7, 1.0);
uniform float roughness : hint_range(0.0, 1.0) = 0.7;
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform float specular : hint_range(0.0, 1.0) = 0.5;

// Subsurface scattering properties
uniform bool subsurface_scattering_enabled = true;
uniform float subsurface_scattering_strength : hint_range(0.0, 1.0) = 0.3;
uniform vec4 subsurface_scattering_color : source_color = vec4(1.0, 0.3, 0.2, 1.0);

// Normal mapping
uniform bool normal_enabled = false;
uniform sampler2D normal_map : hint_normal;
uniform float normal_scale : hint_range(-16.0, 16.0) = 1.0;

// Ambient occlusion
uniform bool ao_enabled = false;
uniform sampler2D ao_texture : hint_default_white;
uniform float ao_strength : hint_range(0.0, 1.0) = 0.5;

// Tissue depth simulation
uniform bool depth_fade_enabled = false;
uniform float depth_fade_distance : hint_range(0.0, 10.0) = 2.0;

// Edge highlighting for educational emphasis
uniform bool edge_highlight_enabled = false;
uniform float edge_highlight_width : hint_range(0.0, 1.0) = 0.1;
uniform vec4 edge_highlight_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);

// Selection highlighting
uniform bool selected = false;
uniform vec4 selection_color : source_color = vec4(0.3, 0.7, 1.0, 1.0);
uniform float selection_intensity : hint_range(0.0, 2.0) = 1.0;
uniform float selection_pulse_speed : hint_range(0.0, 10.0) = 3.0;

varying vec3 vertex_normal;
varying vec3 vertex_binormal;
varying vec3 vertex_tangent;
varying vec2 vertex_uv;
varying vec3 vertex_world_pos;
varying float vertex_depth;

void vertex() {
	// Pass data to fragment shader
	vertex_normal = NORMAL;
	vertex_tangent = TANGENT;
	vertex_binormal = BINORMAL;
	vertex_uv = UV;
	vertex_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	// Calculate vertex depth for depth effects
	vertex_depth = length(CAMERA_POSITION_WORLD - vertex_world_pos);
}

void fragment() {
	// Base color
	vec4 base_color = albedo;
	
	// Normal mapping
	vec3 normal = vertex_normal;
	if (normal_enabled) {
		normal = texture(normal_map, vertex_uv).rgb;
		normal = normal * 2.0 - 1.0;
		normal.xy *= normal_scale;
		normal = normalize(normal);
		
		// Convert from tangent space to world space
		vec3 world_normal;
		world_normal.x = dot(vec3(vertex_tangent.x, vertex_binormal.x, vertex_normal.x), normal);
		world_normal.y = dot(vec3(vertex_tangent.y, vertex_binormal.y, vertex_normal.y), normal);
		world_normal.z = dot(vec3(vertex_tangent.z, vertex_binormal.z, vertex_normal.z), normal);
		normal = normalize(world_normal);
	}
	
	// Calculate view direction
	vec3 view_dir = normalize(CAMERA_POSITION_WORLD - vertex_world_pos);
	
	// Fresnel effect for subsurface scattering edges
	float fresnel = pow(1.0 - clamp(dot(normal, view_dir), 0.0, 1.0), 5.0);
	
	// Apply ambient occlusion
	float ao = 1.0;
	if (ao_enabled) {
		ao = mix(1.0, texture(ao_texture, vertex_uv).r, ao_strength);
	}
	
	// Apply subsurface scattering
	vec4 final_color = base_color;
	if (subsurface_scattering_enabled) {
		// Simple approximation of subsurface scattering with fresnel
		vec4 scatter_color = mix(base_color, subsurface_scattering_color, subsurface_scattering_strength);
		final_color = mix(final_color, scatter_color, fresnel * subsurface_scattering_strength);
	}
	
	// Apply depth fade effect for thin tissue
	if (depth_fade_enabled) {
		float depth_fade = 1.0 - exp(-vertex_depth / depth_fade_distance);
		final_color.a *= depth_fade;
	}
	
	// Apply edge highlighting for educational emphasis
	if (edge_highlight_enabled) {
		float edge = pow(1.0 - dot(normal, view_dir), 4.0);
		edge = smoothstep(1.0 - edge_highlight_width, 1.0, edge);
		final_color.rgb = mix(final_color.rgb, edge_highlight_color.rgb, edge * edge_highlight_color.a);
	}
	
	// Apply selection highlight
	if (selected) {
		// Pulsing effect
		float pulse = 0.5 + 0.5 * sin(TIME * selection_pulse_speed);
		vec4 highlight = selection_color * pulse * selection_intensity;
		
		// Apply highlight based on fresnel for edge emphasis
		float edge_mask = pow(fresnel, 1.5); // Stronger at edges
		final_color.rgb = mix(final_color.rgb, highlight.rgb, edge_mask * highlight.a);
		
		// Add slight glow from within
		final_color.rgb += highlight.rgb * 0.2;
	}
	
	// Output
	ALBEDO = final_color.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	AO = ao;
	
	// Normal output
	NORMAL = normal;
	
	// Handle transparency
	ALPHA = final_color.a;
}

void light() {
	// Standard PBR lighting
	float attenuation = ATTENUATION;
	vec3 diffuse_light = ALBEDO * LIGHT_COLOR * attenuation * DIFFUSE_LIGHT;
	
	// Add subsurface scattering effect in lighting
	if (subsurface_scattering_enabled) {
		// Approximate subsurface scattering by allowing some light to pass through
		float sss_attenuation = exp(-0.5 * length(LIGHT) * (1.0 - subsurface_scattering_strength));
		float sss_dot_nl = max(0.0, -dot(NORMAL, LIGHT));
		
		vec3 sss_light = ALBEDO * LIGHT_COLOR * sss_attenuation * sss_dot_nl * subsurface_scattering_color.rgb;
		diffuse_light += sss_light * subsurface_scattering_strength;
	}
	
	DIFFUSE_LIGHT = diffuse_light;
	SPECULAR_LIGHT = SPECULAR_LIGHT * attenuation;
}