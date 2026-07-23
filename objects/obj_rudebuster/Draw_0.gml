for (var i = array_length(trail_array) - 1; i >= 0; i--) {
    var _ghost = trail_array[i];
    var _gx    = _ghost[0];
    var _gy    = _ghost[1];
    var _gangle = _ghost[2];
    var _galpha = _ghost[3];

    if (_galpha > 0) {
draw_sprite_ext(
            sprite_index,
            image_index,
            _gx,
            _gy,
            image_xscale,
            image_yscale,
            _gangle,
            c_white,
            _galpha
        );
    }
}

event_inherited();