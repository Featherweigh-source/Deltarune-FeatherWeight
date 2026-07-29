draw_set_font(Font1);


var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _fighters = [];
with (obj_fighter_parent) {
    if (!isDead) array_push(_fighters, id);
}

var _count = array_length(_fighters);
if (_count == 0) exit;


var _base_scale = 0.12;

var _dynamic_scale = _base_scale;
if (_count > 2) {
    _dynamic_scale = _base_scale * (2 / _count); 
}

var _padding_x = _gui_w / (_count + 1);

var _bottom_margin = 80; 
var _hud_y = _gui_h - _bottom_margin;

for (var i = 0; i < _count; i++) {
    var _hud_x = _padding_x * (i + 1);
    
    with (_fighters[i]) {
        draw_fighter_hud(_hud_x, _hud_y, _dynamic_scale);
    }
}

draw_set_halign(fa_left);