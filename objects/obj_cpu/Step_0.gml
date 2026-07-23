if (variable_instance_exists(id, "hit_by") && instance_exists(hit_by)) {
    if (hit_by.id != id && !hit_by.isDead && hit_by.team_id != team_id) {
        target = hit_by;
        hit_by = noone;
    }
}

var _leash_range = 350;
if (instance_exists(target)) {
    if (target.isDead || distance_to_object(target) > _leash_range) {
        target = noone;
    }
}

if (!instance_exists(target) || ai_decision_timer <= 0) {
    target = noone;
    var _closest_dist = 999999;
    
    with (obj_fighter_parent) {
        if (id != other.id && !isDead && team_id != other.team_id) {
            var _dist = distance_to_object(other);
            if (_dist < _closest_dist) {
                _closest_dist = _dist;
                other.target = id;
            }
        }
    }
}

if (instance_exists(target)) {
    var _dx = target.x - x;
    var _dy = target.y - y;
    var _dist = abs(_dx);

    if (state != "attack" && state != "hitstun") {
        if (_dx > 2)  facingDir = 1;
        if (_dx < -2) facingDir = -1;
    }

    if (state == "attack") {
        if (can_combo_buffer && random(1) < 0.60) {
            ai_want_hit = true;
        }
    } 
    else if (ai_decision_timer <= 0) {
        ai_decision_timer = ai_decision_interval;

        ai_want_left  = false;
        ai_want_right = false;
        ai_want_down  = false;
        ai_want_hit   = false;

        if (_dist <= ai_attack_range && ai_attack_cooldown <= 0) {
            ai_state = "attack";
        } 
        else if (_dist < ai_attack_range + 40 && ai_attack_cooldown > 0) {
            ai_state = "walk";
        } 
        else if (_dist > ai_run_range + 20) {
            ai_state = "approach";
        } 
        else {
            ai_state = (random(1) < 0.6) ? "approach" : "walk";
        }

        if (onGround) {
            if (_dy < -30 || (ai_state == "walk" && random(1) < 0.15)) {
                ai_want_jump = true;
                ai_jump_hold_timer = (_dy < -65) ? ai_jump_hold_max : 8;
            }
        } else if (jumpcount < jumpmax && _dy < -20 && random(1) < 0.3) {
            ai_want_jump = true;
        }
    } else {
        ai_decision_timer--;
    }

    switch (ai_state) {
        case "approach":
            ai_want_left  = (_dx < -4);
            ai_want_right = (_dx > 4);
            ai_want_run   = (_dist > ai_run_range);
            break;

        case "attack":
            if (state != "attack") {
                ai_want_hit = true;
                ai_attack_cooldown = ai_attack_cooldown_max;
            }
            break;

        case "walk":
            if (ai_walk_timer <= 0) {
                ai_walk_timer = choose(15, 25, 35);
                ai_walk_dir   = choose(-1, 1, (_dx > 0 ? -1 : 1));
            } else {
                ai_walk_timer--;
            }

            ai_want_left  = (ai_walk_dir == -1);
            ai_want_right = (ai_walk_dir == 1);
            ai_want_run   = false;
            break;
    }
} else {
    if (ai_decision_timer > 0) ai_decision_timer--;
}

if (ai_attack_cooldown > 0) ai_attack_cooldown--;

if (ai_jump_hold_timer > 0) {
    ai_jump_hold_timer--;
    ai_want_jump = true; 
}

var _jump_pressed  = (ai_want_jump  && !ai_prev_jump);
var _left_pressed  = (ai_want_left  && !ai_prev_left);
var _right_pressed = (ai_want_right && !ai_prev_right);
var _hit_pressed   = (ai_want_hit   && !ai_prev_hit);

ai_prev_jump  = ai_want_jump;
ai_prev_left  = ai_want_left;
ai_prev_right = ai_want_right;
ai_prev_hit   = ai_want_hit;

input = {
    left         : ai_want_left,
    right        : ai_want_right,
    down         : ai_want_down,
    left_pressed : _left_pressed,
    right_pressed: _right_pressed,
    jump         : ai_want_jump,
    jump_pressed : _jump_pressed,
    run          : ai_want_run,
    hit_pressed  : _hit_pressed
};

event_inherited();