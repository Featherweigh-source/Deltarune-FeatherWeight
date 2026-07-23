var _up_key     = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
var _down_key   = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
var _left_key   = keyboard_check(vk_left)          || keyboard_check(ord("A"));
var _right_key  = keyboard_check(vk_right)         || keyboard_check(ord("D"));
var _left_tap   = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
var _right_tap  = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var _select_key = keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter);
var _back_key   = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("X"));

if (menu_state == "listening") {
    if (keyboard_check_pressed(vk_anykey)) {
        if (keyboard_lastkey != vk_escape && keyboard_lastkey != vk_enter) {
            if (menu_index == 0) global.key_left  = keyboard_lastkey;
            if (menu_index == 1) global.key_right = keyboard_lastkey;
            if (menu_index == 2) global.key_jump  = keyboard_lastkey;
            if (menu_index == 3) global.key_slash = keyboard_lastkey;
            if (menu_index == 4) global.key_run   = keyboard_lastkey;
            audio_play_sound(sndConfirm, 8, false);
            menu_state = "controls";
        }
    }
    exit;
}

if (menu_state == "char_select") {
    if (_left_tap) {
        p1_char_index--;
        if (p1_char_index < 0) p1_char_index = array_length(char_list) - 1;
        audio_play_sound(sndSelect, 8, false);
    }
    if (_right_tap) {
        p1_char_index++;
        if (p1_char_index >= array_length(char_list)) p1_char_index = 0;
        audio_play_sound(sndSelect, 8, false);
    }
    
    if (_select_key) {
        audio_play_sound(sndConfirm, 8, false);
        global.p1_selected_char = char_list[p1_char_index];
        global.p1_needs_respawn = false;
        global.p1_respawn_timer = 0;
        
        if (global.spawn_cpu) {
            menu_state = "cpu_select";
        } else {
            audio_stop_all();
            room_goto(rm_battle_arena_test);
        }
    }
    
    if (_back_key) {
        audio_play_sound(sndConfirm, 8, false);
        menu_state = "main";
        menu_options = main_options;
        menu_total = array_length(menu_options);
        menu_index = 0;
    }
    
    exit;
}

if (menu_state == "cpu_select") {
    if (_up_key) {
        menu_index--;
        if (menu_index < 0) menu_index = 3; 
        audio_play_sound(sndSelect, 8, false);
    }
    if (_down_key) {
        menu_index++;
        if (menu_index > 3) menu_index = 0;
        audio_play_sound(sndSelect, 8, false);
    }

    if (menu_index == 0) {
        if (_left_tap)  { cpu_char_index = (cpu_char_index - 1 + array_length(char_list)) % array_length(char_list); audio_play_sound(sndSelect, 8, false); }
        if (_right_tap) { cpu_char_index = (cpu_char_index + 1) % array_length(char_list); audio_play_sound(sndSelect, 8, false); }
    }
    else if (menu_index == 1) {
        if (_left_tap)  { global.cpu_count = max(1, global.cpu_count - 1); audio_play_sound(sndSelect, 8, false); }
        if (_right_tap) { global.cpu_count = min(4, global.cpu_count + 1); audio_play_sound(sndSelect, 8, false); }
    }
    else if (menu_index == 2) {
        if (_left_tap || _right_tap) {
            if (!variable_global_exists("teams_enabled")) global.teams_enabled = false;
            global.teams_enabled = !global.teams_enabled;
            audio_play_sound(sndSelect, 8, false);
        }
    }
    else if (menu_index == 3) {
        if (_left_tap)  { global.stock_limit = max(0, global.stock_limit - 1); audio_play_sound(sndSelect, 8, false); }
        if (_right_tap) { global.stock_limit = min(10, global.stock_limit + 1); audio_play_sound(sndSelect, 8, false); }
    }
    
    if (_select_key) {
        audio_play_sound(sndConfirm, 8, false);
        global.cpu_selected_char = char_list[cpu_char_index];
        global.cpu_needs_respawn = false;
        global.cpu_respawn_timer = 0;
        audio_stop_all();
        room_goto(rm_battle_arena_test);
    }
    
    if (_back_key) {
        audio_play_sound(sndConfirm, 8, false);
        menu_state = "char_select";
        menu_index = 0;
    }
    
    exit;
}

if (_up_key)   { menu_index--; audio_play_sound(sndSelect, 8, false); }
if (_down_key) { menu_index++; audio_play_sound(sndSelect, 8, false); }

if (menu_index < 0) menu_index = menu_total - 1;
if (menu_index >= menu_total) menu_index = 0;

if (menu_state == "options") {
    if (menu_index == 0) {
        if (_left_tap)  { res_index--; audio_play_sound(sndSelect, 8, false); }
        if (_right_tap) { res_index++; audio_play_sound(sndSelect, 8, false); }
        if (res_index < 0) res_index = array_length(res_options) - 1;
        if (res_index >= array_length(res_options)) res_index = 0;
        if (_left_tap || _right_tap) {
            if (res_index == 0) { window_set_size(640, 480); surface_resize(application_surface, 640, 480); }
            if (res_index == 1) { window_set_size(1280, 720); surface_resize(application_surface, 1280, 720); }
            if (res_index == 2) { window_set_size(1920, 1080); surface_resize(application_surface, 1920, 1080); }
        }
    }
    if (menu_index == 1 && (_left_tap || _right_tap || _select_key)) {
        is_fullscreen = !is_fullscreen; window_set_fullscreen(is_fullscreen); audio_play_sound(sndSelect, 8, false);
    }
    if (menu_index == 2 && (_left_tap || _right_tap || _select_key)) {
        is_vsync = !is_vsync; display_reset(0, is_vsync); audio_play_sound(sndSelect, 8, false);
    }
    if (menu_index == 3 && (_left_tap || _right_tap || _select_key)) {
        music_enabled = !music_enabled; audio_play_sound(sndSelect, 8, false);
        if (!music_enabled) audio_sound_gain(musBackground, 0, 0); else audio_sound_gain(musBackground, master_volume, 0);
    }
    if (menu_index == 4) {
        if (_left_key) master_volume -= 0.01; if (_right_key) master_volume += 0.01;
        master_volume = clamp(master_volume, 0, 1);
        if (music_enabled) audio_sound_gain(musBackground, master_volume, 0);
        audio_master_gain(master_volume);
    }
    if (menu_index == 5 && (_left_tap || _right_tap || _select_key)) {
        show_fps = !show_fps; audio_play_sound(sndSelect, 8, false);
    }
    if (menu_index == 6) {
        if (_left_tap)  { fps_limit_index--; audio_play_sound(sndSelect, 8, false); }
        if (_right_tap) { fps_limit_index++; audio_play_sound(sndSelect, 8, false); }
        if (fps_limit_index < 0) fps_limit_index = array_length(fps_limit_options) - 1;
        if (fps_limit_index >= array_length(fps_limit_options)) fps_limit_index = 0;
        
        if (_left_tap || _right_tap) {
            var _target_fps = 60;
            switch (fps_limit_index) {
                case 0: _target_fps = 1; break;
                case 1: _target_fps = 5; break;
                case 2: _target_fps = 10; break;
                case 3: _target_fps = 15; break;
                case 4: _target_fps = 30; break;
                case 5: _target_fps = 60; break;
                case 6: _target_fps = 120; break;
                case 7: _target_fps = 144; break;
                case 8: _target_fps = 240; break;
                case 9: _target_fps = 9999; break;
            }
            game_set_speed(_target_fps, gamespeed_fps);
        }
    }
    if (menu_index == 7) {
        if (_left_tap) { sound_test_index--; audio_play_sound(sndSelect, 8, false); }
        if (_right_tap) { sound_test_index++; audio_play_sound(sndSelect, 8, false); }
        if (sound_test_index < 0) sound_test_index = array_length(sound_test_names) - 1;
        if (sound_test_index >= array_length(sound_test_names)) sound_test_index = 0;
    }
}

if (_select_key) {
    if (menu_state == "main") {
        audio_play_sound(sndConfirm, 8, false);
        switch (menu_index) {
            case 0: 
                global.spawn_cpu = false; 
                menu_state = "char_select"; 
                break;
            case 1: 
                global.spawn_cpu = true;  
                menu_state = "char_select";
                global.cpu_count = 1; 
                break;
            case 2: 
                menu_state = "options"; 
                menu_options = options_labels; 
                menu_total = array_length(menu_options); 
                menu_index = 0; 
                break;
            case 3: 
                menu_state = "controls"; 
                menu_options = controls_labels; 
                menu_total = array_length(menu_options); 
                menu_index = 0; 
                break;
            case 4: 
                game_end(); 
                break;
        }
    }
    else if (menu_state == "options") {
        if (menu_index == 7) {
            audio_stop_all(); 
            audio_play_sound(sound_test_assets[sound_test_index], 10, false);
        }
        else if (menu_index == 8) {
            audio_play_sound(sndConfirm, 8, false); 
            menu_state = "main"; 
            menu_options = main_options; 
            menu_total = array_length(menu_options); 
            menu_index = 2;
        }
    }
    else if (menu_state == "controls") {
        if (menu_index == 5) {
            audio_play_sound(sndConfirm, 8, false); 
            menu_state = "main"; 
            menu_options = main_options; 
            menu_total = array_length(menu_options); 
            menu_index = 3;
        } else {
            audio_play_sound(sndSelect, 8, false); 
            menu_state = "listening";
        }
    }
}

