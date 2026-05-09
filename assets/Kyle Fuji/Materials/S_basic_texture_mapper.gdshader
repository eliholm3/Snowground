shader_type spatial;

// color map expected is a basic black and white color map where
// color1 changes the colors mapped to white, and color2 to black
// roughness# and metallic# also do the same. This makes it a convenient
// and easy shader for objects with just 2 colors, like the presents
// and the candycane
uniform sampler2D color_map;
uniform vec3 color1 : source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 color2 : source_color = vec3(0.0, 0.0, 0.0);
uniform float metallic1 : hint_range(0.0, 1.0) = 0;
uniform float metallic2 : hint_range(0.0, 1.0) = 0;
uniform float roughness1 : hint_range(0.0, 1.0) = 0.5;
uniform float roughness2 : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec4 packed_data = texture(color_map, UV);
	vec4 inversed_data = vec4(1.0, 1.0, 1.0, 1.0) - packed_data;

	vec3 color_map1 = packed_data.rgb * color1;
	vec3 color_map2 = inversed_data.rgb * color2;

	float metal1 = metallic1 * packed_data.b;
	float metal2 = metallic2 * inversed_data.b;

	float rough1 = roughness1 * packed_data.r;
	float rough2 = roughness2 * inversed_data.r;

	ALBEDO = color_map1 + color_map2;
	METALLIC = metal1 + metal2;
	ROUGHNESS = rough1 + rough2;
}
