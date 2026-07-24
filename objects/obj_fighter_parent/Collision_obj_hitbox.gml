if (instance_exists(other.owner) && other.owner != id) {
    if (!variable_global_exists("teams_enabled") || !global.teams_enabled || other.owner.team_id != team_id) {
        
        xspd = variable_instance_exists(other, "knockback_x") ? (other.owner.facingDir * other.knockback_x) : 0;
        yspd = variable_instance_exists(other, "knockback_y") ? other.knockback_y : 0;
        
        state = "hitstun";
        hitstun_timer = 15;
        
        audio_play_sound(sndCritical, 8, false);
        hp -= other.damage;
        takendmg = other.damage;
        
        var _hit_tp = variable_instance_exists(other, "tp") ? other.tp : 10;
        
        if (_hit_tp <= 10) {
            tp += _hit_tp * 0.9;
            if (instance_exists(other.owner)) {
                other.owner.tp += _hit_tp * 1.1;
            }
        } else {
            tp += _hit_tp * 0.6;
            if (instance_exists(other.owner)) {
                other.owner.tp += _hit_tp * 0.9;
            }
        }
        
        with (other) { instance_destroy(); }
        drawalpha = 1;
    }
}