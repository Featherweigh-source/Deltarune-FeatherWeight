if (!global.debug_open) exit;

draw_set_alpha(0.9);
draw_set_color(c_black);

draw_rectangle(0, 0, 200, display_get_gui_height(), false);

draw_set_alpha(1);



draw_set_font(Font1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_white);

var start_x = 25;
var start_y = 25;
var line_h = 22;

for (var i = 0; i < array_length(menu_items); i++)
{
    var yy = start_y + i * line_h;
    if (i == menu_index)
    {
        draw_set_color(c_yellow);
        draw_text(start_x - 15, yy, "■");
    }
    draw_set_color(c_white);
    draw_text(start_x, yy, menu_items[i]);
}