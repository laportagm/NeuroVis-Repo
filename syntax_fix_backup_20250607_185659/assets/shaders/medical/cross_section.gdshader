shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

// Basic material properties
uniform vec4 albedo : source_color = vec4(0.8, 0.75, 0.7, 1.0);
uniform float roughness : hint_range(0.0, 1.0) = 0.7;
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform float specular : hint_range(0.0, 1.0) = 0.5;

// Cross section properties
uniform bool cross_section_enabled = true;
uniform vec3 cross_section_plane_normal = vec3(1.0, 0.0, 0.0); // Normal of the cutting plane
uniform float cross_section_plane_distance = 0.0; // Distance from origin along normal
uniform vec4 cross_section_edge_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Color for section edges
uniform float cross_section_edge_width : hint_range(0.0, 0.1) = 0.02; // Width of the section edge highlight

// Educational features
uniform bool educational_grid_enabled = false;
uniform float educational_grid_scale : hint_range(0.1, 10.0) = 1.0;
uniform vec4 educational_grid_color : source_color = vec4(0.2, 0.2, 0.2, 0.5);

// Depth features
uniform bool depth_coloring_enabled = false;
uniform vec4 depth_color_near : source_color = vec4(1.0, 0.2, 0.2, 1.0);
uniform vec4 depth_color_far : source_color = vec4(0.2, 0.2, 1.0, 1.0);
uniform float depth_range : hint_range(0.1, 10.0) = 5.0;

// Normal mapping
uniform bool normal_enabled = false;
uniform sampler2D normal_map : hint_normal;
uniform float normal_scale : hint_range(-16.0, 16.0) = 1.0;

varying vec3 vertex_normal;
varying vec3 vertex_binormal;
varying vec3 vertex_tangent;
varying vec2 vertex_uv;
varying vec3 vertex_world_pos;
varying float cross_section_value;

void vertex() {
	// Pass data to fragment shader
	vertex_normal = NORMAL;
	vertex_tangent = TANGENT;
	vertex_binormal = BINORMAL;
	vertex_uv = UV;
	vertex_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	// Calculate signed distance from cutting plane
	// Positive values are on the visible side, negative are on the cut side
	vec3 normalized_normal = normalize(cross_section_plane_normal);
	cross_section_value = dot(vertex_world_pos, normalized_normal) - cross_section_plane_distance;
}

void fragment() {
	// Discard fragments on the wrong side of the cutting plane if enabled
	if (cross_section_enabled && cross_section_value < 0.0) {
		discard;
	}
	
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
	
	// Apply edge highlighting for cross-section
	if (cross_section_enabled && cross_section_value < cross_section_edge_width) {
		// Calculate how close we are to the cutting edge
		float edge_factor = 1.0 - (cross_section_value / cross_section_edge_width);
		base_color = mix(base_color, cross_section_edge_color, edge_factor);
		
		// Increase specular at edge for highlighting
		specular += edge_factor * 0.5;
	}
	
	// Apply educational grid if enabled
	if (educational_grid_enabled) {
		// Create a grid based on world position
		float grid_x = abs(fract(vertex_world_pos.x * educational_grid_scale) - 0.5);
		float grid_y = abs(fract(vertex_world_pos.y * educational_grid_scale) - 0.5);
		float grid_z = abs(fract(vertex_world_pos.z * educational_grid_scale) - 0.5);
		
		float grid_factor = 0.0;
		if (grid_x < 0.05 || grid_y < 0.05 || grid_z < 0.05) {
			grid_factor = 1.0;
		}
		
		// Apply grid to the cross-section face only
		if (cross_section_enabled && cross_section_value < cross_section_edge_width * 2.0) {
			base_color.rgb = mix(base_color.rgb, educational_grid_color.rgb, grid_factor * educational_grid_color.a);
		}
	}
	
	// Apply depth-based coloring if enabled
	if (depth_coloring_enabled) {
		// Calculate depth based on cross-section plane
		float depth = abs(cross_section_value);
		float depth_factor = clamp(depth / depth_range, 0.0, 1.0);
		
		// Apply depth coloring to the cross-section face only
		if (cross_section_enabled && cross_section_value < cross_section_edge_width * 3.0) {
			vec4 depth_color = mix(depth_color_near, depth_color_far, depth_factor);
			base_color = mix(base_color, depth_color, 0.7); // Apply with 70% strength
		}
	}
	
	// Output
	ALBEDO = base_color.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	
	// Normal output
	NORMAL = normal;
}