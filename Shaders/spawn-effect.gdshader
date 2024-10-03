shader_type canvas_item;

uniform float spawn_progress : hint_range(0.0,1.0) = 1.0;
uniform sampler2D noise_texture;
uniform float tolerance = 0.05;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.y -= clamp(1.0 - UV.y, 0.5, 1.0) * ((1.0 - pow(spawn_progress, 5.0)) * 64.0);
}

void fragment() {
	float clamped_spawn_progress = clamp(spawn_progress, 0.0, 1.0);
	float clamped_spawn_progress_powered = pow(clamped_spawn_progress, 1.5);
	float clamped_tolerance = clamp(tolerance, SCREEN_PIXEL_SIZE.y, 1.0);
	
	float noise_value = texture(noise_texture, UV*0.69).r;
	
	float one_minus_UVy = 1.0 - UV.y;
	
	float uv_mask = clamp(one_minus_UVy + clamped_spawn_progress, 0.0, 1.0);
	
	float per_pixel_progress = ((noise_value+one_minus_UVy) - 2.0*clamped_spawn_progress_powered) * COLOR.a;
	float per_pixel_progress_offset = ((noise_value+one_minus_UVy) - (2.0*clamped_spawn_progress_powered) - clamped_tolerance) * COLOR.a;
	float mask_original = ceil(clamp(per_pixel_progress, 0.0, 1.0));
	float mask_border = mask_original - ceil(clamp(per_pixel_progress_offset, 0.0, 1.0));
	vec4 pink = mix(vec4(1.0,1.0,1.0,1.0), vec4(1.0,0.75,1.0, 1.0),  clamped_spawn_progress);
	COLOR.rgba = mix(vec4(pink.rgb,0.0), COLOR, clamped_spawn_progress_powered );
	COLOR.rgba = mix(COLOR, vec4(0.0,0.0,0.0,0.0), mask_original );
	COLOR.rgba = mix(COLOR, pink, mask_border );
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
