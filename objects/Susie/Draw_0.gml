draw_sprite_ext(sprite_index, image_index, x, y, facingDir, 1, 0, c_white, 1);

draw_set_font(Font1);

draw_text_color(x - 30, y - 50, $"{takendmg}", c_yellow, c_yellow, #FAB13A, #FAB13A, drawalpha);

if (instance_exists(obj_debug_menu))
{
    if (global.debug_show_player_collision)
    {
        draw_set_color(c_red);

        draw_rectangle(
            bbox_left,
            bbox_top,
            bbox_right,
            bbox_bottom,
            true
        );
    }

    if (global.debug_show_hurtboxes)
    {
        draw_set_color(c_lime);

        draw_rectangle(
            bbox_left,
            bbox_top,
            bbox_right,
            bbox_bottom,
            true
            );
    }
}