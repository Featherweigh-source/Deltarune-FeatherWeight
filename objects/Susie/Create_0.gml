character_id = "kris";

event_inherited();
var _data    = get_fighter_data(character_id);
sprites      = _data.sprites;
attacks      = _data.attacks;

perform_special = method(id, _data.perform_special);
cast_special    = method(id, _data.cast_special);

var _monitor_w = display_get_width();
var _monitor_h = display_get_height();
surface_resize(application_surface, _monitor_w, _monitor_h);
gpu_set_texfilter(false);

global.key_left  = vk_left;
global.key_right = vk_right;
global.key_up    = vk_up;
global.key_down  = vk_down;
global.key_jump  = vk_space;
global.key_slash = ord("Z");
global.key_run   = ord("X");