event_inherited();

var bar_w = 48;
var bar_h = 6;

var xx = x - bar_w * 0.5;
var yy = bbox_top - 20;

draw_set_color(c_black);
draw_rectangle(xx - 1, yy - 1, xx + bar_w + 1, yy + bar_h + 1, false);

draw_set_color(c_dkgray);
draw_rectangle(xx, yy, xx + bar_w, yy + bar_h, false);

var hp_percent = clamp(hp / max_hp, 0, 1);

draw_set_color(c_lime);
draw_rectangle(xx, yy, xx + bar_w * hp_percent, yy + bar_h, false);

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_text(x, yy - 2, string(hp) + "/" + string(max_hp));

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