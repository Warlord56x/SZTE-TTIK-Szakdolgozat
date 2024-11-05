shader_type canvas_item;

uniform float time;                       // Time variable for animation
uniform float speed = 2.0;                // Speed of the water flow
uniform float wave_amplitude = 10.0;      // Height of the waves
uniform float wave_frequency = 4.0;       // Frequency of the waves
uniform vec2 uv_scale = vec2(1.0, 1.0);   // Scale of UV mapping
uniform vec4 water_color = vec4(0.0, 0.5, 1.0, 0.5); // Color of the water

void vertex() {
    vec2 uv = UV * uv_scale;

    // Calculate wave displacement
    float wave = sin(uv.x * wave_frequency + TIME * speed) * wave_amplitude;
    VERTEX.y += wave;

    // Optional horizontal movement
    VERTEX.x += sin(TIME * speed + uv.y * wave_frequency) * 0.5;
}

void fragment() {
    // Sample the texture color
    vec4 color = texture(TEXTURE, UV);
    COLOR = color * water_color; // Blend texture color with water color
}
