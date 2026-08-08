if (other.owner != noone && instance_exists(other.owner) && other.owner != id) {

    if (array_contains(other.hit_list, id)) exit;

    if (!variable_global_exists("teams_enabled") || !global.teams_enabled || other.owner.team_id != team_id) {
        
        array_push(other.hit_list, id);

        xspd = other.knockback_x;
        yspd = other.knockback_y;
        
        state = "hitstun";
        hitstun_timer = 15;
        
        audio_play_sound(sndCritical, 8, false);
        hp -= other.damage;
        takendmg = other.damage;
        drawalpha = 1;

        var _hit_tp = variable_instance_exists(other, "tp") ? other.tp : 10;
        if (_hit_tp <= 10) {
            tp += _hit_tp * 0.9;
            if (instance_exists(other.owner)) other.owner.tp += _hit_tp * 1.1;
        } else {
            tp += _hit_tp * 0.6;
            if (instance_exists(other.owner)) other.owner.tp += _hit_tp * 0.9;
        }
    }
}