shader_type canvas_item;
uniform sampler2D noise_texture;

void fragment() {
	vec4 colour_1 = vec4(150.0/255.0,169.0/255.0,193.0/255.0, 1.0);
	vec4 colour_2 = vec4(64.0/255.0,82.0/255.0,115.0/255.0, 1.0);
	vec4 colour_foam = vec4(241.0/255.0,246.0/255.0,240.0/255.0, 1.0);

	float shore_distance_field = abs(UV.y-0.5)*2.0;
	float flow_speed = 0.2 * TIME * clamp(pow(1.0-shore_distance_field, 2), 0.01, 1.0);
	vec2 UV_FLOW_1 = fract(vec2(1.0*UV.x-flow_speed*0.33, UV.y * 0.001));
	vec2 UV_FLOW_2 = fract(vec2(1.1*UV.x-flow_speed*2.0, UV.y * 0.1 + 0.05));
	float noise_value_1 = texture(noise_texture, UV_FLOW_1).r;
	float noise_value_2 = texture(noise_texture, UV_FLOW_2).r;
	
	COLOR = mix(colour_1, colour_2, noise_value_1 * noise_value_2);
	float foam_mask = round(pow(noise_value_1 * noise_value_2,2) + clamp(shore_distance_field - 0.4, 0.0, 1.0));
	COLOR = mix(COLOR, colour_foam, foam_mask);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
