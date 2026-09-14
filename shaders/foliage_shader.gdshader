shader_type canvas_item;

uniform float wind_speed : hint_range(0.0, 10.0) = 3.0;
uniform float wind_strength : hint_range(0.0, 0.5) = 4.0;
uniform float right_bias : hint_range(0.0, 1.0) = 0.6;

void vertex() {
	float height_factor = 1.0 - UV.y;

	float world_x = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).x;
	float time = TIME * wind_speed + world_x * 0.05;

	float sway = sin(time) * wind_strength;
	sway += abs(sin(time * 0.5)) * right_bias * wind_strength;

	VERTEX.x += sway * height_factor;
}
