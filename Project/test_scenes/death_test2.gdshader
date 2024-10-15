shader_type canvas_item;

uniform float radius: hint_range(0.0, 1.0, 0.01) = 0.5;

void fragment() {
    // Get the original UV coordinates (typically passed in as varying)
    vec2 centeredUV = UV - vec2(0.5, 0.5);
    
    // Convert to polar coordinates
    float r = length(centeredUV);  // Distance from the center
    float theta = atan(centeredUV.y, centeredUV.x);  // Angle around the center

    // Scale r to fit within the texture size (keep all pixels)
    r = r / radius; // Normalize radius to fit in the range [0.0, 1.0]
    
    // Remap back to Cartesian coordinates
    vec2 polarUV = vec2(r * cos(theta), r * sin(theta));

    // Shift back to the original texture coordinates
    vec2 newUV = polarUV + vec2(0.5, 0.5);

    // Sample the texture using the new coordinates
    COLOR = texture(TEXTURE, newUV);
}
