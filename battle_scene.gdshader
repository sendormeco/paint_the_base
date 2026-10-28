shader_type canvas_item;

uniform sampler2D base_texture;
uniform sampler2D mask_texture;
uniform vec4 paint_color : source_color = vec4(0.0, 0.0, 0.0, 0.8); // Черный с прозрачностью
uniform float hardness = 0.5; // Жесткость границы (0.1 - мягкие, 0.9 - жесткие)

void fragment() {
    // Получаем базовый цвет и значение маски
    vec4 base = texture(base_texture, UV);
    vec4 mask = texture(mask_texture, UV);
    
    // Смешиваем цвета с учетом альфа-канала маски
    float blend_factor = smoothstep(0.0, hardness, mask.a);
    COLOR = mix(base, paint_color, blend_factor);
}
