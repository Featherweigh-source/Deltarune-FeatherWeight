if (!variable_global_exists("key_left"))  global.key_left  = vk_left;
if (!variable_global_exists("key_right")) global.key_right = vk_right;
if (!variable_global_exists("key_jump"))  global.key_jump  = vk_space;
if (!variable_global_exists("key_slash")) global.key_slash = ord("Z");
if (!variable_global_exists("key_run"))   global.key_run   = ord("X");

gpu_set_texfilter(false);
draw_set_font(Font1);

function scr_get_key_name(_key) {
    if (_key >= 65 && _key <= 90) return chr(_key);
    if (_key == vk_left) return "LEFT ARROW";
    if (_key == vk_right) return "RIGHT ARROW";
    if (_key == vk_up) return "UP ARROW";
    if (_key == vk_down) return "DOWN ARROW";
    if (_key == vk_space) return "SPACEBAR";
    if (_key == vk_shift) return "SHIFT";
    if (_key == vk_control) return "CTRL";
    return "KEY " + string(_key);
}

if (room == rm_main_menu) {

    if (menu_state == "char_select") {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        draw_set_color(c_white);
        draw_text(room_width / 2, 40, "P1: CHOOSE YOUR FIGHTER");
        
        draw_set_color(c_yellow);
        draw_text(room_width / 2, 100, "<  " + char_names[p1_char_index] + "  >");
        
        draw_set_color(c_gray);
        draw_text(room_width / 2, 160, "[Z/ENTER] CONFIRM   [X/ESC] BACK");
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
    

    else if (menu_state == "cpu_select") {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        draw_set_color(c_white);
        draw_text(room_width / 2, 30, "VS CPU RULES & OPPONENT");
        
        var _start_y = 65;
        var _spacing = 22;
        
        if (!variable_global_exists("teams_enabled")) global.teams_enabled = false;

        draw_set_color(menu_index == 0 ? c_yellow : c_white);
        draw_text(room_width / 2, _start_y, "OPPONENT: < " + char_names[cpu_char_index] + " >");
        
        draw_set_color(menu_index == 1 ? c_yellow : c_white);
        draw_text(room_width / 2, _start_y + _spacing, "CPU COUNT: < " + string(global.cpu_count) + " >");
        
        draw_set_color(menu_index == 2 ? c_yellow : c_white);
        var _team_str = global.teams_enabled ? "ON (P1 vs CPUs)" : "OFF (FREE FOR ALL)";
        draw_text(room_width / 2, _start_y + (_spacing * 2), "TEAMS: < " + _team_str + " >");
        
        draw_set_color(menu_index == 3 ? c_yellow : c_white);
        var _stock_str = (global.stock_limit == 0) ? "INFINITE" : string(global.stock_limit) + " LIVES";
        draw_text(room_width / 2, _start_y + (_spacing * 3), "STOCK: < " + _stock_str + " >");
        
        draw_set_color(c_gray);
        draw_text(room_width / 2, 175, "[UP/DOWN] NAVIGATE   [Z/ENTER] START   [X/ESC] BACK");
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

    else {
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);

        for (var i = 0; i < menu_total; i++) {
            var _x_pos = 50;
            var _y_pos = 55 + (i * 22);
            
            if (i == menu_index && menu_state != "listening") {
                draw_set_color(c_yellow);
                draw_rectangle(_x_pos - 15, _y_pos - 2, _x_pos - 11, _y_pos + 2, false);
            } else {
                draw_set_color(c_white);
            }
            
            if (menu_state == "main") {
                draw_text(_x_pos, _y_pos, menu_options[i]);
            } 
            else if (menu_state == "options") {
                var _text_line = menu_options[i];
                if (i == 0) _text_line += ": < " + res_options[res_index] + " >";
                if (i == 1) _text_line += ": " + (is_fullscreen ? "< ON >" : "< OFF >");
                if (i == 2) _text_line += ": " + (is_vsync ? "< ON >" : "< OFF >");
                if (i == 3) _text_line += ": " + (music_enabled ? "< PLAYING >" : "< MUTED >");
                if (i == 4) {
                    var _bar_chunks = floor(master_volume * 10);
                    var _visual_bar = ""; for (var b = 0; b < 10; b++) _visual_bar += (b < _bar_chunks) ? "█" : "-";
                    _text_line += ": [ " + _visual_bar + " ] " + string(floor(master_volume * 100)) + "%";
                }
                if (i == 5) _text_line += ": " + (show_fps ? "< SHOW >" : "< HIDE >");
                if (i == 6) _text_line += ": < " + fps_limit_options[fps_limit_index] + " >";
                if (i == 7) _text_line += ": < " + sound_test_names[sound_test_index] + " >";
                draw_text(_x_pos, _y_pos, _text_line);
            }
            else if (menu_state == "controls" || menu_state == "listening") {
                var _text_line = menu_options[i];
                
                if (i == menu_index && menu_state == "listening") {
                    _text_line += ": [ PRESS ANY KEY ]";
                    draw_set_color(c_yellow);
                } else {
                    if (i == 0) _text_line += ": " + scr_get_key_name(global.key_left);
                    if (i == 1) _text_line += ": " + scr_get_key_name(global.key_right);
                    if (i == 2) _text_line += ": " + scr_get_key_name(global.key_jump);
                    if (i == 3) _text_line += ": " + scr_get_key_name(global.key_slash);
                    if (i == 4) _text_line += ": " + scr_get_key_name(global.key_run);
                }
                draw_text(_x_pos, _y_pos, _text_line);
            }
        }
    }
}

if (show_fps) {
    draw_set_color(c_lime); draw_set_halign(fa_right); draw_set_valign(fa_top);
    draw_text(room_width - 10, 10, "FPS: " + string(fps));
}

