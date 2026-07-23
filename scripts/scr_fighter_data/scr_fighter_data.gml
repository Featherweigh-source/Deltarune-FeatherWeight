function get_fighter_data(_character_id) {
    static roster = {
        "kris": {
            sprites: {
                healthbar    : krishpbar,   
                idle         : krisidle1,
                walk         : kriswalk,
                run          : krisrun,
                stop         : kris_stop,
                crouch       : kriscrouch,
                jump_start   : krisjumpstart,
                jump         : krisjump,
                jump_norm    : krisnormaljump,
                fall_straight: krisfall_straight,
                fall_slanted : krisfall_slanted,
                walk_fall    : kriswalkfall,
                land_norm    : krisland_normal,
                land_slant   : krisland_slanted,
                slash1       : krisslash1,
                slash2       : krisslash2,
                slash3       : krisslash3,
                air_slash1   : krisslash_air1,
                special      : krisslash3
            },

            attacks: {
                hp : 100,
                slash1:     { damage: 3,  knockback_x: 3, knockback_y: -2,  lifetime: 4, tpvalue: 3, sprite: krisslash1hitbox },
                slash2:     { damage: 5,  knockback_x: 4, knockback_y: -3,  lifetime: 4, tpvalue: 3, sprite: krisslash2hitbox },
                slash3:     { damage: 6,  knockback_x: 8, knockback_y: -6,  lifetime: 6, tpvalue: 3, sprite: krisslash3hitbox },
                air_slash1: { damage: 6,  knockback_x: 4, knockback_y:  2,  lifetime: 5, tpvalue: 3, sprite: krisairslashhitbox },
                special:    { damage: 15, knockback_x: 10, knockback_y: -8, lifetime: 8, tpcost: 32, tpvalue: 10, sprite: krisslash3hitbox }
            },

            perform_special: function() {
                xspd = facingDir * atkLungeSpd * 1.2; 
                audio_play_sound(sndCritical, 8, false);
                create_hitbox(attacks.special);
            },

            cast_special: function() {}
        },
        
        "susie": {
            sprites: {
                healthbar    : krishpbar,   
                idle         : susieidle,
                walk         : susie_run,
                run          : susie_run,
                stop         : susie_break,
                crouch       : kriscrouch,
                jump_start   : susie_jumpprepare,
                jump         : susiejump,
                jump_norm    : susiejump,
                fall_straight: recoverballS,
                fall_slanted : recoverballS,
                walk_fall    : recoverballS,
                land_norm    : krisland_normal,
                land_slant   : krisland_slanted,
                slash1       : susieslash1,
                slash2       : susieslash2,
                slash3       : susieslash3,
                air_slash1   : airfrontslash_susie,
                special      : susie_rudebuster
            },

            attacks: {
                hp : 200,
                slash1:     { damage: 5,  knockback_x: 3, knockback_y: -2,  lifetime: 4, tpvalue: 3, sprite: susieslash1hitbox },
                slash2:     { damage: 7,  knockback_x: 4, knockback_y: -3,  lifetime: 4, tpvalue: 3, sprite: susieslash2hitbox },
                slash3:     { damage: 12, knockback_x: 8, knockback_y: -6,  lifetime: 6, tpvalue: 3, sprite: susieslash3hitbox },
                air_slash1: { damage: 6,  knockback_x: 4, knockback_y:  2,  lifetime: 5, tpvalue: 3, sprite: krisairslashhitbox },
                special:    { damage: 25, knockback_x: 12, knockback_y: -4, lifetime: 10, tpcost: 50, tpvalue: 10, sprite: buster }
            },
            
            perform_special: function() {
                xspd = facingDir * atkLungeSpd * 0.5;
                audio_play_sound(sndCritical, 8, false);
            },

            cast_special: function() {
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
                    damage = _self_id.attacks.special.damage;
                    tp = variable_struct_exists(_self_id.attacks.special, "tpvalue") ? _self_id.attacks.special.tpvalue : 10;
                    knockback_x = variable_struct_exists(_self_id.attacks.special, "knockback_x") ? _self_id.attacks.special.knockback_x : 8;
                    knockback_y = variable_struct_exists(_self_id.attacks.special, "knockback_y") ? _self_id.attacks.special.knockback_y : -4;
                    direction = (_self_id.facingDir == 1) ? 0 : 180;
                    image_angle = direction;
                }
            }
        }
    };

    if (struct_exists(roster, _character_id)) {
        return roster[$ _character_id];
    } else {
        return roster.kris;
    }
}