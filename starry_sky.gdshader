shader_type sky;

uniform float star_density : hint_range(0.9, 1.0) = 0.97;
uniform float star_brightness : hint_range(0.0, 5.0) = 2.0;
uniform vec4 sky_color : source_color = vec4(0.01, 0.01, 0.06, 1.0);
uniform vec4 horizon_color : source_color = vec4(0.04, 0.06, 0.15, 1.0);

// Returns a random value 0-1 for a given 2D grid cell.
float hash(vec2 cell) {
	return fract(sin(dot(cell, vec2(127.1, 311.7))) * 43758.5453);
}

// Returns how bright a star is at UV position uv, for a given grid scale.
float star_layer(vec2 uv, float scale) {
	vec2 grid = floor(uv * scale);
	vec2 local = fract(uv * scale);

	// Place the star at a random spot within its grid cell.
	vec2 star_pos = vec2(hash(grid + 0.3), hash(grid + 0.7));

	float h = hash(grid);
	if (h < star_density) return 0.0;

	float brightness = pow((h - star_density) / (1.0 - star_density), 2.0);
	float dist = length(local - star_pos);
	return brightness * star_brightness * smoothstep(0.1, 0.0, dist);
}

void sky() {
	vec3 dir = normalize(EYEDIR);

	// Convert 3D direction to 2D spherical UV for consistent star placement.
	vec2 uv = vec2(
		atan(dir.z, dir.x) / (2.0 * PI) + 0.5,
		dir.y * 0.5 + 0.5
	);

	// Dark sky fading to slightly lighter at the horizon.
	float horizon_blend = smoothstep(-0.05, 0.3, dir.y);
	vec3 color = mix(horizon_color.rgb, sky_color.rgb, horizon_blend);

	// Three layers of stars at different densities — fade them in above the horizon.
	float star_fade = smoothstep(0.0, 0.15, dir.y);
	float stars = 0.0;
	stars += star_layer(uv, 80.0);
	stars += star_layer(uv, 160.0) * 0.6;
	stars += star_layer(uv, 320.0) * 0.3;
	color += vec3(stars * star_fade);

	COLOR = color;
}
