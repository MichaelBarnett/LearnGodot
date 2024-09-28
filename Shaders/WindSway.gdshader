shader_type canvas_item;
render_mode world_vertex_coords;

void vertex() {
	// Called for every vertex the material is visible on.
	float amplitude_1 = 3.0;
	float amplitude_2 = 1.0;
	float period_1 = 1.0;
	float period_2 = 5.33;
    vec4 world_position = MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0);
	float x = TIME + world_position.x;
	VERTEX.x += (1.0 - UV.y) * ((amplitude_1 * sin(x * period_1)) + (amplitude_2 * sin(x * period_2)));
	VERTEX.y += (1.0 - UV.y) * (amplitude_2 * sin(x * period_1));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
