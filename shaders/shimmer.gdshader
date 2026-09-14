shader_type canvas_item;

uniform vec4 shimmer_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float width : hint_range(0.0, 1.0) = 0.2;
uniform float speed : hint_range(0.1, 10.0) = 2.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    if (tex_color.a < 0.1) {
        discard;
    }

    float position_line = UV.x + UV.y;
    float time_offset = TIME * speed;

    float wave = mod(position_line - time_offset, 3.0);

    float shimmer = smoothstep(width, 0.0, abs(wave - 1.5));

    vec3 final_rgb = mix(tex_color.rgb, shimmer_color.rgb, shimmer * 0.8);

    COLOR = vec4(final_rgb, tex_color.a);
}
