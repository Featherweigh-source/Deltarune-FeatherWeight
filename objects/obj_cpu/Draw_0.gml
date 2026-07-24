draw_sprite_ext(sprite_index, image_index, x, y, facingDir, 1, 0, make_color_rgb(255, 160, 160), 1);

draw_set_font(Font1);

draw_text_color(x + 30, y - 50, $"{takendmg}", c_red, c_red, c_maroon, c_maroon, drawalpha);