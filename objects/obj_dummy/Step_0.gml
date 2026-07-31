input = {
    left: false,
    right: false,
    up: false,
    down: false,

    left_pressed: false,
    right_pressed: false,
    up_pressed: false,
    down_pressed: false,

    jump: false,
    jump_pressed: false,

    run: false,

    hit_pressed: false
};

sprites = {
    idle          : spr_dummy,
    walk          : spr_dummy,
    run           : spr_dummy,
    jump          : spr_dummy,
    jump_norm     : spr_dummy,
    fall_slanted  : spr_dummy,
    fall_straight : spr_dummy,
    walk_fall     : spr_dummy,
    crouch        : spr_dummy,
    stop          : spr_dummy,
    land_norm     : spr_dummy,
    land_slant    : spr_dummy,
    jump_start    : spr_dummy,
    slash1        : spr_dummy,
    slash2        : spr_dummy,
    slash3        : spr_dummy,
    air_slash1    : spr_dummy
};

event_inherited();

