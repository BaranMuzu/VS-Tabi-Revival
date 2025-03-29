#pragma header

// this is bbpanzus bloom shader combined with an overlay shader i tried to make 

//BLOOM SHADER BY BBPANZU

const float amount = 2.0;

// GAUSSIAN BLUR SETTINGS (For Bloom)
float dim = 1.8;
float Directions = 16.0;
float Quality = 5.0; 
float Size = 18.0; 
vec2 Radius = Size / openfl_TextureSize.xy;

void main() {
    vec2 uv = openfl_TextureCoordv.xy;
    float Pi = 6.28318530718; // Pi * 2
    
    vec4 base = flixel_texture2D(bitmap, uv);
    vec4 Color = base;

    for (float d = 0.0; d < Pi; d += Pi / Directions) {
        for (float i = 1.0 / Quality; i <= 1.0; i += 1.0 / Quality) {
            float ex = (cos(d) * Size * i) / openfl_TextureSize.x;
            float why = (sin(d) * Size * i) / openfl_TextureSize.y;
            Color += flixel_texture2D(bitmap, uv + vec2(ex, why));
        }
    }
    Color /= (dim * Quality) * Directions - 15.0;
    vec4 bloom = (base / dim) + Color;

    vec4 overlay = vec4(1.0, 0.5, 0.0, 1.0);
    float baseLuminance = (bloom.r + bloom.g + bloom.b) / 3.0;
    vec3 result;

    if (baseLuminance < 0.5) {
        result = 2.0 * bloom.rgb * overlay.rgb;
    } else {
        result = 1.0 - 2.0 * (1.0 - bloom.rgb) * (1.0 - overlay.rgb);
    }

    gl_FragColor = vec4(result, bloom.a);
}
