if (!is_cpu) {
    input = get_fighter_input();
}

var _input = variable_instance_exists(id, "input") ? input : {
    jump_pressed: false,
    hit_pressed: false,
    up: false,
    down: false,
    left: false,
    right: false,
    up_pressed: false,
    down_pressed: false
};

if (tp >= tpmax) { tp = tpmax; }

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
    exit;
}

if (onGround) {
    jumpcount = 0;
    jumpHoldTimer = 0;
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

    if (_input.jump && jumpHoldTimer < jumpHoldFrames && yspd < 0) {
        yspd += jspd * 0.08;
        jumpHoldTimer++;
    }

    if (!_input.jump && yspd < 0) {
        yspd *= 0.75;
        jumpHoldTimer = jumpHoldFrames;
    }

    yspd = min(yspd, termVel);
} 
else if (state == "attack" || state == "special") {
    yspd = 0;
} 
else if (state == "airattack" || state == "hitstun") {
    yspd += grav;
    yspd = min(yspd, termVel);
}

if (JumpKeyBuffered && jumpcount < jumpmax && state != "attack" && state != "airattack" && state != "special" && state != "crouch" && state != "jumpstart" && state != "hitstun") {
    if (onGround) {
        state = "jumpstart";
        sprite_index = sprites.jump_start;
        image_index = 0;
        image_speed = 1;
    } else {
        JumpKeyBuffered = false;
        jumpcount++;
        jumpHoldTimer = 0;
        yspd = jspd;
        state = "move";
        audio_play_sound(sndJump, 8, false);
    }
}

if (dash_timer_right > 0) dash_timer_right--;
if (dash_timer_left > 0)  dash_timer_left--;

if (_input.right_pressed) {
    if (dash_timer_right > 0) is_sprinting = true; else dash_timer_right = 15;
}
if (_input.left_pressed) {
    if (dash_timer_left > 0) is_sprinting = true; else dash_timer_left = 15;
}

moveDir = _input.right - _input.left;
if (moveDir == 0 && onGround) is_sprinting = false;
runType = (_input.run || is_sprinting) ? 1 : 0;

var _target_spd = moveDir * moveSpd[runType];
var _rate = onGround ? (moveDir != 0 ? accel : (1 - fric)) : (moveDir != 0 ? airAccel : (1 - airFric));

switch (state) {
    case "attack":
    case "special":
        xspd = lerp(xspd, 0, 0.15);
        break;

    case "airattack":
        if (moveDir != 0) {
            xspd = lerp(xspd, _target_spd, airAccel);
        } else {
            xspd *= airFric;
        }
        break;

    case "crouch":
        xspd = lerp(xspd, 0, 0.2);
        break;

    case "stop":
        xspd = lerp(xspd, 0, 0.15);
        break;

    case "hitstun":
        xspd = lerp(xspd, 0, 0.05);
        break;

    default:
        if (moveDir != 0) {
            xspd = lerp(xspd, _target_spd, _rate);
        } else {
            xspd *= fric;
            if (abs(xspd) < 0.05) xspd = 0;
        }
        break;
}

if (abs(xspd) > 0.2 && state != "stop" && state != "hitstun") {
    facingDir = sign(xspd);
}

var _subPixel = 0.5;

if (place_meeting(x + xspd, y, Wall)) {
    var _safety_counter = 0;
    while (!place_meeting(x + sign(xspd), y, Wall) && _safety_counter < 100) {
        x += sign(xspd);
        _safety_counter++;
    }
    xspd = 0;
}
x += xspd;

if (place_meeting(x, y + yspd, Wall)) {
    var _pixelcheck = _subPixel * sign(yspd);
    while (!place_meeting(x, y + _pixelcheck, Wall)) { y += _pixelcheck; }
    yspd = 0;
};

if (yspd >= 0 && place_meeting(x, y + 1, Wall)) {
    if (!onGround && state != "land" && state != "attack" && state != "special" && state != "hitstun") {
        state = "land"; 
        image_index = 0; 
        combo_step = 0; 
        stop_frame = 0;
        sprite_index = (moveDir != 0) ? sprites.land_slant : sprites.land_norm;
    }
    onGround = true;
} else {
    onGround = false;
}
y += yspd;

if ((state == "attack" || state == "airattack") && _input.hit_pressed) { 
    can_combo_buffer = true; 
}


var _up_held   = keyboard_check(global.key_up)   || (struct_exists(input, "up") && input.up);
var _down_held = keyboard_check(global.key_down) || (struct_exists(input, "down") && input.down);
var _hit       = input.hit_pressed || keyboard_check_pressed(global.key_slash);

if ((state == "move" || state == "crouch" || state == "jumpstart") && (_up_held || _down_held) && _hit) {
    
    current_special_type = _up_held ? "up" : "down";
    
    var _sp_cost = 30;
    if (is_struct(attacks) && struct_exists(attacks, "special")) {
        if (struct_exists(attacks.special, current_special_type)) {
            var _sp_data = attacks.special[$ current_special_type];
            if (is_struct(_sp_data)) {
                if (struct_exists(_sp_data, "tpcost"))       _sp_cost = _sp_data.tpcost;
                else if (struct_exists(_sp_data, "tpvalue")) _sp_cost = _sp_data.tpvalue;
            }
        }
    }

    if (tp >= _sp_cost) {
        tp -= _sp_cost;
        state = "special";
        image_index = 0;
        stop_frame = 0;
        has_cast_special = false;

        if (is_struct(sprites) && struct_exists(sprites, "special")) {
            if (is_struct(sprites.special) && struct_exists(sprites.special, current_special_type)) {
                sprite_index = sprites.special[$ current_special_type];
            } else if (!is_struct(sprites.special)) {
                sprite_index = sprites.special;
            }
        }

        if (is_struct(perform_special) && struct_exists(perform_special, current_special_type)) {
            var _perf_func = perform_special[$ current_special_type];
            if (is_callable(_perf_func)) _perf_func();
        } else if (is_callable(perform_special)) {
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
    
    xspd = (facingDir * atkLungeSpd) + (xspd * 0.2); 
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
            jumpHoldTimer = 0;
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
            
        if (stop_frame >= _max_frames - 1 && !has_cast_special) {
            has_cast_special = true;
            
            if (is_struct(cast_special) && struct_exists(cast_special, current_special_type)) {
                var _cast_func = cast_special[$ current_special_type];
                if (is_callable(_cast_func)) _cast_func();
            } else if (is_callable(cast_special)) {
                cast_special();
            }
        }

        if (stop_frame >= _max_frames) {
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
                    xspd = (facingDir * atkLungeSpd) + (xspd * 0.2); 
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
                    xspd = (facingDir * atkLungeSpd * 1.2) + (xspd * 0.2); 
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
            if (_input.down && abs(xspd) < 0.5) {
                state = "crouch"; 
                sprite_index = sprites.crouch; 
                image_index = 0;
            }
            else if (abs(xspd) > 0.2) {
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
                } else { 
                    sprite_index = sprites.idle; 
                    image_index = 0; 
                    image_speed = 0; 
                }
            }
        }
        break;
}

image_xscale = (facingDir != 0) ? facingDir : 1;
mask_index = spr_player_hitbox;