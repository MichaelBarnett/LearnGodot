shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform int MaximumReflectionCheck = 10;

void fragment() {
	// Called for every pixel the material is visible on.
    vec4 TestPixel = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec2 TestUVIncrement = vec2(0.0, 0.0);
	int increment_count = 0;
	vec4 color_burn = vec4(0.0,0.0,0.0,0.0);

	if (TestPixel.rgb != vec3(1.0,0.0,1.0))
	{
		COLOR = TestPixel;
	}
	else
	{
		COLOR = vec4(0.1,0.2,0.8,1.0);
		while (TestPixel.rgb == vec3(1.0,0.0,1.0) && increment_count < MaximumReflectionCheck)
		{
			color_burn = vec4(0.0,0.0,1.0,0.0);
			increment_count++;
			TestUVIncrement += vec2(0.0,SCREEN_PIXEL_SIZE.y);
		    TestPixel = textureLod(screen_texture, SCREEN_UV - TestUVIncrement, 0.0);
		}
		
		TestUVIncrement = vec2(TestUVIncrement.x, TestUVIncrement.y * 2.0);
	    COLOR = clamp(
					textureLod(screen_texture, SCREEN_UV - TestUVIncrement, 0.0) + color_burn, 
					vec4(0.0,0.0,0.0,0.0),
					vec4(1.0,1.0,1.0,1.0)
					);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
