var _input = input;

if tp >= tpmax { tp = tpmax };

if (_input.jump_pressed) { JumpKeyBuffered = true; }

if (place_meeting(x, y, PlayerKill)) { isDead = true; }
if (hp <= 0) { isDead = true; }

if (isDead) {
    if (is_cpu && instance_exists(obj_game_manager)) {
        array_push(obj_game_manager.cpu_respawn_queue, {
            char_obj: global.cpu_selected_char,
            stocks_left: variable_instance_exists(id, "stocks_left") ? stocks_left : 0,
            timer: obj_game_manager.respawn_delay_frames
        });
    }
    
    instance_destroy();
}

if (onGround) {
    jumpcount = 0;
    peak_freeze_timer = 0;
    has_peak_frozen = false;
    can_air_attack = true;
}

if (state != "attack" && state != "airattack" && state != "special" && state != "hitstun") {
    
    if (jumpcount == 1 && yspd >= -1 && yspd <= 1 && !has_peak_frozen) {
        peak_freeze_timer = 4;
        has_peak_frozen = true;
    }
    
    if (peak_freeze_timer > 0) {
        yspd = 0;
        peak_freeze_timer--;
    } else {
        yspd += grav;
    }

    if (yspd < -2 && !_input.jump) {
        yspd = lerp(yspd, 0, 0.4);
        peak_freeze_timer = 0;
    }
} 
else if (state == "attack" || state == "special") {
    yspd = 0;
} 
else if (state == "airattack" || state == "hitstun") {
    yspd += grav;
}

if (JumpKeyBuffered && jumpcount < jumpmax && state != "attack" && state != "airattack" && state != "special" && state != "crouch" && state != "jumpstart" && state != "hitstun") {
    state = "jumpstart";
    sprite_index = sprites.jump_start;
    image_index = 0;
    image_speed = 1;
}

if (dash_timer_right > 0) dash_timer_right--;
if (dash_timer_left > 0)  dash_timer_left--;

if (_input.right_pressed) {
    if (dash_timer_right > 0) is_sprinting = true; else dash_timer_right = 15;
}
if (_input.left_pressed) {
    if (dash_timer_left > 0) is_sprinting = true; else dash_timer_left = 15;
}

if (state == "stop" && (_input.right || _input.left)) {
    state = "move";
}

if (state == "attack" || state == "special") {
    xspd = lerp(xspd, 0, 0.15);
}
else if (state == "airattack") {
    moveDir = _input.right - _input.left;
    runType = (_input.run || is_sprinting) ? 1 : 0;
    xspd = moveDir * moveSpd[runType];
}
else if (state == "stop" || state == "crouch") {
    xspd = 0;
    if (state == "stop") {
        skid_speed = lerp(skid_speed, 0, 0.15);
        xspd = facingDir * skid_speed;
    }
}
else if (state == "hitstun") {
    xspd = lerp(xspd, 0, 0.1);
}
else { 
    moveDir = _input.right - _input.left;
    if (moveDir == 0) is_sprinting = false;
    runType = (_input.run || is_sprinting) ? 1 : 0;
    xspd = moveDir * moveSpd[runType];
}

if (xspd > 0 && state != "stop" && state != "hitstun") facingDir = 1;
if (xspd < 0 && state != "stop" && state != "hitstun") facingDir = -1;

var _subPixel = 0.5;

if (place_meeting(x + xspd, y, Wall)) {
    var _pixelcheck = _subPixel * sign(xspd);
    while (!place_meeting(x + _pixelcheck, y, Wall)) { x += _pixelcheck; }
    xspd = 0; 
    skid_speed = 0;
}
x += xspd;

if (place_meeting(x, y + yspd, Wall)) {
    var _pixelcheck = _subPixel * sign(yspd);
    while (!place_meeting(x, y + _pixelcheck, Wall)) { y += _pixelcheck; }
    yspd = 0;
}

if (yspd >= 0 && place_meeting(x, y + 1, Wall)) {
    if (!onGround && state != "land" && state != "attack" && state != "special" && state != "hitstun") {
        state = "land"; 
        image_index = 0; 
        combo_step = 0; 
        stop_frame = 0;
        if (moveDir != 0) sprite_index = sprites.land_slant; else sprite_index = sprites.land_norm;
    }
    onGround = true;
} else {
    onGround = false;
}
y += yspd;

if ((state == "attack" || state == "airattack") && _input.hit_pressed) { 
    can_combo_buffer = true; 
}


if ((state == "move" || state == "crouch") && _input.down && _input.hit_pressed) {

    var _sp_cost = 30;
    if (struct_exists(attacks, "special")) {
        if (variable_struct_exists(attacks.special, "tpcost")) _sp_cost = attacks.special.tpcost;
        else if (variable_struct_exists(attacks.special, "tpvalue")) _sp_cost = attacks.special.tpvalue;
    }
    
    if (tp >= _sp_cost) {
        state = "special";
        sprite_index = sprites.special;
        image_index = 0;
        stop_frame = 0;
        
        if (perform_special != noone) {
            perform_special();
        }
    }
}

else if (state == "move" && onGround && _input.hit_pressed) {
    state = "attack"; 
    combo_step = 1; 
    sprite_index = sprites.slash1; 
    stop_frame = 0; 
    image_index = 0; 
    can_combo_buffer = false;
    xspd = facingDir * atkLungeSpd * 0.6; 
    audio_play_sound(sndSlash, 8, false);
    create_hitbox(attacks.slash1);
}


if (state == "move" && !onGround && _input.hit_pressed && can_air_attack) {
    state = "airattack"; 
    combo_step = 1; 
    can_air_attack = false; 
    sprite_index = sprites.air_slash1; 
    stop_frame = 0; 
    image_index = 0; 
    can_combo_buffer = false;
    audio_play_sound(sndSlash, 8, false);
    create_hitbox(attacks.air_slash1);
}

switch (state)
{
    case "jumpstart":
        sprite_index = sprites.jump_start;
        
        stop_frame += 0.5;
        image_index = floor(stop_frame);

        if (stop_frame >= 2) { 
            JumpKeyBuffered = false; 
            JumpKeyBufferTimer = 0; 
            jumpcount++;
            audio_play_sound(sndJump, 8, false); 
            
            yspd = jspd;
            state = "move";
            stop_frame = 0;
        }
        break;

    case "special":
    image_speed = 0;
    stop_frame += 0.25;
    image_index = floor(stop_frame);
    
    var _max_frames = sprite_get_number(sprite_index);
        
    if (image_index >= _max_frames - 1 && !has_cast_special) {
        has_cast_special = true;

        if (character_id == "susie") {
            var _target_inst = noone;
            var _self_id = id;
            
            with (obj_fighter_parent) {
                if (id != _self_id && !isDead) {
                    _target_inst = id;
                }
            }

            var _spawn_x = x + (facingDir * 32);
            var _spawn_y = y - 16;
            
            var _proj = instance_create_depth(_spawn_x, _spawn_y, depth - 1, obj_rudebuster);
with (_proj) {
    owner = _self_id;
    target = _target_inst;
    spd = 8;
    lifetime = 120;
    
    homing_intensity = 0.2; 

    damage      = _self_id.attacks.special.damage;
    tp          = variable_struct_exists(_self_id.attacks.special, "tpvalue") ? _self_id.attacks.special.tpvalue : 10;
    knockback_x = variable_struct_exists(_self_id.attacks.special, "knockback_x") ? _self_id.attacks.special.knockback_x : 8;
    knockback_y = variable_struct_exists(_self_id.attacks.special, "knockback_y") ? _self_id.attacks.special.knockback_y : -4;
    
    direction = (_self_id.facingDir == 1) ? 0 : 180;
    image_angle = direction;
}
        }
    }


    if (stop_frame >= _max_frames - 1) {
        state = "move";
        stop_frame = 0;
        has_cast_special = false;
    }
    break;

    case "attack":
        image_speed = 0;
        
        if (combo_step == 1) {
            sprite_index = sprites.slash1; 
            stop_frame += 0.25; 
            image_index = floor(stop_frame);
            
            if (stop_frame >= sprite_get_number(sprites.slash1) - 1) {
                if (can_combo_buffer) {
                    combo_step = 2; 
                    sprite_index = sprites.slash2; 
                    stop_frame = 0; 
                    image_index = 0; 
                    can_combo_buffer = false;
                    xspd = facingDir * atkLungeSpd * 0.6; 
                    audio_play_sound(sndSlash, 8, false);
                    create_hitbox(attacks.slash2);
                } else { 
                    state = "move"; 
                    combo_step = 0; 
                }
            }
        }
        else if (combo_step == 2) {
            sprite_index = sprites.slash2; 
            stop_frame += 0.25; 
            image_index = floor(stop_frame);
            
            if (stop_frame >= sprite_get_number(sprites.slash2) - 1) {
                if (can_combo_buffer) {
                    combo_step = 3; 
                    sprite_index = sprites.slash3; 
                    stop_frame = 0; 
                    image_index = 0; 
                    can_combo_buffer = false;
                    xspd = facingDir * atkLungeSpd * 0.7; 
                    audio_play_sound(sndCritical, 8, false);
                    create_hitbox(attacks.slash3);
                } else { 
                    state = "move"; 
                    combo_step = 0; 
                }
            }
        }
        else if (combo_step == 3) {
            sprite_index = sprites.slash3;
            if (floor(stop_frame) == 4) stop_frame += 0.05; else stop_frame += 0.25;
            image_index = floor(stop_frame);
            
            if (stop_frame >= sprite_get_number(sprites.slash3) - 1) { 
                state = "move"; 
                combo_step = 0; 
                stop_frame = 0; 
                can_combo_buffer = false; 
            }
        }
        break;

    case "airattack":
        image_speed = 0;
        if (combo_step == 1) {
            sprite_index = sprites.air_slash1;
            var _air_freeze_frame = sprite_get_number(sprites.air_slash1) - 1;
            if (floor(stop_frame) == _air_freeze_frame) stop_frame += 0.05; else stop_frame += 0.25;
            image_index = floor(stop_frame);
            
            if (stop_frame >= sprite_get_number(sprites.air_slash1) - 1) { 
                state = "move"; 
                combo_step = 0; 
                can_combo_buffer = false; 
            }
        }
        break;

    case "hitstun":
        sprite_index = sprites.crouch;
        hitstun_timer--;
        if (hitstun_timer <= 0) {
            state = "move";
        }
        break;

    case "land":
        image_speed = 1; 
        if (image_index >= image_number - 1) state = "move"; 
        break;

    case "stop":
        sprite_index = sprites.stop; 
        image_speed = 0; 
        stop_frame += 0.2; 
        image_index = floor(stop_frame);
        
        var _skid_input = _input.right - _input.left;
        if (_skid_input != 0) {
            state = "move"; 
        } else if (stop_frame >= 3) { 
            state = "move"; 
            sprite_index = sprites.idle; 
            image_index = 0; 
            image_speed = 0; 
        }
        break;

    case "crouch":
        sprite_index = sprites.crouch;
        if (image_index >= image_number - 1) { 
            image_speed = 0; 
            image_index = image_number - 1; 
        } else { 
            image_speed = 1; 
        }
        if (!_input.down) { state = "move"; }
        break;

    case "move":
        if (!onGround) {
            if (is_sprinting || _input.run) {
                if (yspd < 2) sprite_index = sprites.jump; 
                else sprite_index = (moveDir != 0) ? sprites.fall_slanted : sprites.fall_straight;
            } else {
                if (yspd < 2) sprite_index = sprites.jump_norm; 
                else sprite_index = (moveDir != 0) ? sprites.fall_slanted : sprites.walk_fall;
            }
            image_speed = 1;
        }
        else {
            if (_input.down && xspd == 0) {
                state = "crouch"; 
                sprite_index = sprites.crouch; 
                image_index = 0;
            }
            else if (xspd != 0) {
                if (is_sprinting || _input.run) sprite_index = sprites.run; 
                else sprite_index = sprites.walk;
                image_speed = 1;
            }
            else {
                if (sprite_index == sprites.walk || sprite_index == sprites.run) {
                    state = "stop"; 
                    sprite_index = sprites.stop; 
                    stop_frame = 0; 
                    image_index = 0; 
                    skid_speed = moveSpd[runType];
                } else { 
                    sprite_index = sprites.idle; 
                    image_index = 0; 
                    image_speed = 0; 
                }
            }
        }
        break;
}

image_xscale = 1;
mask_index = spr_player_hitbox;