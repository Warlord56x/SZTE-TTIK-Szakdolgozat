shader_type canvas_item;

uniform bool waves_enabled = true;
uniform float wave_height : hint_range(0.0, 10.0) = 4.0;
uniform float wave_speed : hint_range(0.0, 10.0) = 4.0;
uniform float wave_width : hint_range(0.0, 100.0) = 16.0;

void fragment() {
    vec2 uv = UV;

    // Time-based wave offset
    float time = TIME * wave_speed;

    // Apply wave effect using sine waves
    float wave = sin((uv.x / wave_width) + time) * wave_height;
    float wave_color = clamp(0.5 + wave * 0.1, 0.0, 1.0);

    // Apply color gradient for water effect
    vec4 water_color = mix(vec4(0.2, 0.4, 0.8, 1.0), vec4(0.1, 0.3, 0.6, 1.0), uv.y + wave * 0.05);

    // Blend wave height into the color
    COLOR = mix(vec4(0.2, 0.4, 0.8, 1.0), water_color, wave_color);
}
