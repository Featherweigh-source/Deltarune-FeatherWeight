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
                healthbar    : susiehpbar,   
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
                show_debug_message("Casting Special!")
    var _target_inst = noone;
    var _self = id;
    
    with (obj_fighter_parent) {
        if (id != _self && !isDead) {
            _target_inst = id;
        }
    }

    var _spawn_x = x + (facingDir * 32);
    var _spawn_y = y - 16;
    
    var _sp_data = struct_exists(attacks, "special") ? attacks.special : {};
    var _dmg  = variable_struct_exists(_sp_data, "damage") ? _sp_data.damage : 15;
    var _tp   = variable_struct_exists(_sp_data, "tpvalue") ? _sp_data.tpvalue : 10;
    var _kb_x = variable_struct_exists(_sp_data, "knockback_x") ? _sp_data.knockback_x : 8;
    var _kb_y = variable_struct_exists(_sp_data, "knockback_y") ? _sp_data.knockback_y : -4;
    
    var _proj = instance_create_depth(_spawn_x, _spawn_y, depth - 1, obj_rudebuster);
    with (_proj) {
        owner = _self;
        target = _target_inst;
        spd = 8;
        lifetime = 120;
        homing_intensity = 0.2; 
        damage = _dmg;
        tp = _tp;
        knockback_x = _kb_x;
        knockback_y = _kb_y;
        direction = (_self.facingDir == 1) ? 0 : 180;
        image_angle = direction;
    }
}
        },
        
        "ralsei": {
            sprites: {
                healthbar    : ralseihpbar,   
                idle         : RalIdle1,
                walk         : RalWalk,
                run          : RalHover,
                stop         : kris_stop,
                crouch       : kriscrouch,
                jump_start   : krisjumpstart,
                jump         : RalHover,
                jump_norm     : RalHover,
                fall_straight: RalHover,
                fall_slanted : RalHover,
                walk_fall    : RalHover,
                land_norm    : RalHover,
                land_slant   : RalHover,
                slash1       : RalAtk,
                slash2       : RalAtk,
                slash3       : RalAtk,
                air_slash1   : RalAtk,
                special      : RalHeal
            },

            attacks: {
                hp : 100,
                slash1:     { damage: 3,  knockback_x: 3, knockback_y: -2,  lifetime: 4, tpvalue: 3, sprite: krisslash1hitbox },
                slash2:     { damage: 5,  knockback_x: 4, knockback_y: -3,  lifetime: 4, tpvalue: 3, sprite: krisslash2hitbox },
                slash3:     { damage: 6,  knockback_x: 8, knockback_y: -6,  lifetime: 6, tpvalue: 3, sprite: krisslash3hitbox },
                air_slash1: { damage: 6,  knockback_x: 4, knockback_y:  2,  lifetime: 5, tpvalue: 3, sprite: krisairslashhitbox },
                special:    { damage: 30, knockback_x: 0, knockback_y: 0, lifetime: 0, tpcost: 32, tpvalue: 0, sprite: krisslash3hitbox }
            },

            perform_special: function() {
                audio_play_sound(sndBump, 8, false);
                if hp < max_hp { hp += attacks.special.damage };
            },

            cast_special: function() {}
        },
        
    };

    if (struct_exists(roster, _character_id)) {
        return roster[$ _character_id];
    } else {
        return roster.kris;
    }
}