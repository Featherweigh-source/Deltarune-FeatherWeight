character_id = "ralsei";

event_inherited();

var _data = get_fighter_data(character_id);
sprites = _data.sprites;
attacks = _data.attacks;

var _perf_down = struct_exists(_data.perform_special, "down") ? _data.perform_special.down : function() {};
var _perf_up   = struct_exists(_data.perform_special, "up")   ? _data.perform_special.up   : function() {};
var _cast_down = struct_exists(_data.cast_special, "down")    ? _data.cast_special.down    : function() {};
var _cast_up   = struct_exists(_data.cast_special, "up")      ? _data.cast_special.up      : function() {};

perform_special = {
    down : method(id, _perf_down),
    up   : method(id, _perf_up)
};

cast_special = {
    down : method(id, _cast_down),
    up   : method(id, _cast_up)
};

// 4. Display and Control settings
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