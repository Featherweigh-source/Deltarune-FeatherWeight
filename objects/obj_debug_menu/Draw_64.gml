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
        draw_text(start_x - 15, yy, "█");
    }
    draw_set_color(c_white);
    draw_text(start_x, yy, menu_items[i]);
	
	if (menu_state == "animation" && i == 0)
	{
		draw_text(start_x + 95, yy, "< " + animation_names[animation_index] + " >");
	}
	
	if (menu_state == "animation" && i == 1)
	{
		var txt = "Auto";
		
		if (frame_index != -1)
			txt = string(frame_index);

		draw_text(start_x + 95, yy, "< " + txt + " >");
	}
	
	if (menu_state == "animation" && i == 2)
	{
		draw_text(start_x + 95, yy, "< " + string_format(animation_speed, 1, 1) + " >");
	}
	
	if (menu_state == "animation" && i == 3)
	{
		draw_text(start_x + 95, yy, "< " + (animation_paused ? "ON" : "OFF") + " >");
	}
	
	if (menu_state == "hitboxes" && i == 0)
	{
		draw_text(start_x + 185, yy, "< " + (global.debug_show_player_collision ? "ON" : "OFF") + " >");
	}

	if (menu_state == "hitboxes" && i == 1)
	{
		draw_text(start_x + 185, yy, "< " + (global.debug_show_hurtboxes ? "ON" : "OFF") + " >");
	}

	if (menu_state == "hitboxes" && i == 2)
	{
		draw_text(start_x + 185, yy, "< " + (global.debug_show_hitboxes ? "ON" : "OFF") + " >");
	}

	if (menu_state == "player" && i == 0)
	{
		if (instance_exists(global.debug_target))
		{
			var filled = round((global.debug_target.hp / global.debug_target.max_hp) * hp_bar_segments);
			
			var bar = "";

			for (var j = 0; j < hp_bar_segments; j++)
			{
				if (j < filled)
					bar += "/";
				else
					bar += "_";
			}

        draw_text(start_x + 95, yy, "- [" + bar + "] +");
		}
	}
	if (menu_state == "player" && i == 1)
	{
		if (instance_exists(global.debug_target))
		{
			var segments = 10;
			var filled = round((global.debug_target.tp / global.debug_target.tpmax) * segments);
			
			var bar = "";
			
			for (var j = 0; j < segments; j++)
			{
				if (j < filled)
					bar += "/";
				else
					bar += "_";
			}

        draw_text(start_x + 95, yy, "- [" + bar + "] +");
		}
	}
	if (menu_state == "player" && i == 2)
	{
		draw_text(start_x + 95, yy, "< " + spawn_character_names[spawn_character_index] + " >");
	}
	if (menu_state == "spawn_cpu" && i == 0)
	{
		draw_text(start_x + 95, yy, "< " + char_names[cpu_char_index] + " >");
	}

	if (menu_state == "spawn_cpu" && i == 1)
	{
		draw_text(start_x + 95, yy, "< " + string(global.cpu_count) + " >");
	}

	if (menu_state == "spawn_cpu" && i == 2)
	{
		draw_text(start_x + 95, yy, "< " + string(global.stock_limit) + " >");
	}
}

