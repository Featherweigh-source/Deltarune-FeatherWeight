draw_sprite_ext(
    sprite_index,
    image_index,
    x,
    y,
    image_xscale,
    image_yscale,
    image_angle,
    c_white,
    image_alpha
);

if instance_exists(obj_debug_menu) 
{
    if (global.debug_show_hitboxes)
    {
        draw_set_color(c_aqua);

        draw_rectangle(
            bbox_left,
            bbox_top,
            bbox_right,
            bbox_bottom,
            true
        );
    }
}