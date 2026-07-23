var _data    = get_fighter_data(character_id);
sprites      = _data.sprites;
attacks      = _data.attacks;
if (struct_exists(_data, "perform_special")) {
    perform_special = method(id, _data.perform_special);
} else {
    perform_special = noone;
}

team_id = 1;

isDead = false;
is_cpu = false;
moveDir = 0;
runType = 0;

moveSpd[0] = 3;
moveSpd[1] = 5;

xspd = 0;
yspd = 0;
tp = 0;
tpmax = 100;
atkLungeSpd = 1.5;

grav = 0.275;
termVel = 99999;
jspd = -6;
jumpmax = 1;
jumpcount = 0;
jumpHoldTimer = 0;
jumpHoldFrames = 18;
onGround = true;

peak_freeze_timer = 0;
has_peak_frozen = false;

facingDir = 1;
state = "move";
stop_frame = 0;

dash_timer_right = 0;
dash_timer_left = 0;
is_sprinting = false;

skid_speed = 0;

can_combo_buffer = false;
can_air_attack = true;
combo_step = 0;

BufferTime = 6;
JumpKeyBuffered = false;
JumpKeyBufferTimer = 0;

max_hp = attacks.hp;
hp = max_hp;

draw_fighter_hud = function(_x, _y, _scale) {
    if (!variable_struct_exists(sprites, "healthbar")) exit;

    var _slot_offset_l = variable_instance_exists(id, "slot_offset_left")   ? slot_offset_left   : 30;
    var _slot_offset_t = variable_instance_exists(id, "slot_offset_top")    ? slot_offset_top    : 200;
    var _slot_offset_r = variable_instance_exists(id, "slot_offset_right")  ? slot_offset_right  : 421;
    var _slot_offset_b = variable_instance_exists(id, "slot_offset_bottom") ? slot_offset_bottom : 282;

    var _hp_percent = clamp(hp / max_hp, 0, 1);

    var _spr = sprites.healthbar;
    var _spr_w = sprite_get_width(_spr) * _scale;
    var _spr_h = sprite_get_height(_spr) * _scale;

    var _top_left_x = _x - (_spr_w / 2);
    var _top_left_y = _y - (_spr_h / 2);

    var _slot_left   = _top_left_x + (_slot_offset_l * _scale);
    var _slot_top    = _top_left_y + (_slot_offset_t * _scale);
    var _slot_right  = _top_left_x + (_slot_offset_r * _scale);
    var _slot_bottom = _top_left_y + (_slot_offset_b * _scale);

    var _max_width     = _slot_right - _slot_left;
    var _current_width = _max_width * _hp_percent;

    if (_current_width > 0) {
        var _hp_color = make_color_rgb(255 * (1 - _hp_percent), 255 * _hp_percent, 50);
        
        draw_set_color(_hp_color);
        draw_rectangle(_slot_left, _slot_top, _slot_left + _current_width, _slot_bottom, false);
        draw_set_color(c_white);
    }

    draw_sprite_ext(_spr, 0, _x, _y, _scale, _scale, 0, c_white, 1);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(is_cpu ? c_red : c_yellow);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
};


image_xscale = 1;
mask_index = spr_player_hitbox;

input = {
    left: false, right: false, down: false,
    left_pressed: false, right_pressed: false,
    jump: false, jump_pressed: false,
    run: false, hit_pressed: false
};

create_hitbox = function(_attack_data) {
    var _hb = instance_create_depth(x, y, +1000, obj_hitbox);
    
    _hb.owner = id;
    _hb.sprite_index = _attack_data.sprite;
    _hb.mask_index   = _attack_data.sprite;
    _hb.image_xscale = facingDir;
    _hb.damage       = _attack_data.damage;
    _hb.tp           = _attack_data.tpvalue;
    _hb.knockback_x  = _attack_data.knockback_x * facingDir;
    _hb.knockback_y  = _attack_data.knockback_y;
    _hb.lifetime     = _attack_data.lifetime;
    _hb.image_alpha  = 1;  
    return _hb;
};

if (!variable_instance_exists(id, "character_id")) {
    character_id = "kris";
}

