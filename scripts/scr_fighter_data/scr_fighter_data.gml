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
                special      : {
                    down    : krisslash3,
                    up      : krisjump
                }
            },

            attacks: {
                hp : 100,
                slash1:     { damage: 3,  knockback_x: 3, knockback_y: -2,  lifetime: 4, tpvalue: 3, sprite: krisslash1hitbox },
                slash2:     { damage: 5,  knockback_x: 4, knockback_y: -3,  lifetime: 4, tpvalue: 3, sprite: krisslash2hitbox },
                slash3:     { damage: 6,  knockback_x: 8, knockback_y: -6,  lifetime: 6, tpvalue: 3, sprite: krisslash3hitbox },
                air_slash1: { damage: 6,  knockback_x: 4, knockback_y:  2,  lifetime: 5, tpvalue: 3, sprite: krisairslashhitbox },
                
                special: {
                    down:    { damage: 15, knockback_x: 10, knockback_y: -8, lifetime: 8, tpcost: 32, tpvalue: 10, sprite: krisslash3hitbox },
                    up:      { damage: 10, knockback_x: 2,  knockback_y: -10, lifetime: 8, tpcost: 25, tpvalue: 5,  sprite: krisslash3hitbox }
                }
            },

            perform_special: {
                down: function() {
                    xspd = facingDir * atkLungeSpd * 1.2; 
                    audio_play_sound(sndCritical, 8, false);
                    create_hitbox(attacks.special.down);
                },
                up: function() {
                    yspd = jspd * 1.2;
                    create_hitbox(attacks.special.up);
                }
            },

            cast_special: {
                down: function() {},
                up: function() {}
            }
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
                special      : {
                    down    : susie_rudebuster,
                    up      : susie_rudebuster
                }
            },

            attacks: {
                hp : 200,
                slash1:     { damage: 5,  knockback_x: 3, knockback_y: -2,  lifetime: 4, tpvalue: 3, sprite: susieslash1hitbox },
                slash2:     { damage: 7,  knockback_x: 4, knockback_y: -3,  lifetime: 4, tpvalue: 3, sprite: susieslash2hitbox },
                slash3:     { damage: 12, knockback_x: 8, knockback_y: -6,  lifetime: 6, tpvalue: 3, sprite: susieslash3hitbox },
                air_slash1: { damage: 6,  knockback_x: 4, knockback_y:  2,  lifetime: 5, tpvalue: 3, sprite: krisairslashhitbox },
                
                special: {
                    down:    { damage: 25, knockback_x: 12, knockback_y: -4, lifetime: 10, tpcost: 50, tpvalue: 10, sprite: buster },
                    up:      { damage: 14, knockback_x: 3,  knockback_y: -4, lifetime: 6,  tpcost: 25, tpvalue: 5,  sprite: susiejump }
                }
            },
            
            perform_special: {
                down: function() {
                    xspd = facingDir * atkLungeSpd * 0.5;
                    audio_play_sound(sndCritical, 8, false);
                },
                up: function() {
                    xspd = facingDir * atkLungeSpd * 0.5;
                    audio_play_sound(sndCritical, 8, false);
                }
            },

            cast_special: {
                down: function() {
                    var _target_inst = noone;
                    var _self = id;
                    
                    with (obj_fighter_parent) {
                        if (id != _self && !isDead) {
                            _target_inst = id;
                        }
                    }

                    var _spawn_x = x + (facingDir * 32);
                    var _spawn_y = y - 16;
                    
                    var _sp_data = struct_exists(attacks.special, "down") ? attacks.special.down : {};
                    var _dmg  = variable_struct_exists(_sp_data, "damage") ? _sp_data.damage : 25;
                    var _tp   = variable_struct_exists(_sp_data, "tpvalue") ? _sp_data.tpvalue : 10;
                    var _kb_x = variable_struct_exists(_sp_data, "knockback_x") ? _sp_data.knockback_x : 12;
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
                },
                up: function() {
    var _self = id;
    
    var _target_inst = noone;
    var _closest_dist = 999999;
    with (obj_fighter_parent) {
        if (id != _self && !isDead && team_id != _self.team_id) {
            var _dist = distance_to_object(_self);
            if (_dist < _closest_dist) {
                _closest_dist = _dist;
                _target_inst = id;
            }
        }
    }

    var _sp_data = struct_exists(attacks.special, "up") ? attacks.special.up : 
                  (struct_exists(attacks.special, "down") ? attacks.special.down : {});
                  
    var _base_dmg = struct_exists(_sp_data, "damage") ? _sp_data.damage : 25;
    var _tp       = struct_exists(_sp_data, "tpvalue") ? _sp_data.tpvalue : 5;
    var _kb_x     = struct_exists(_sp_data, "knockback_x") ? _sp_data.knockback_x : 8;
    var _kb_y     = struct_exists(_sp_data, "knockback_y") ? _sp_data.knockback_y : -5;

    var _mini_dmg  = floor(_base_dmg * 0.5);
    var _base_dir  = (facingDir == 1) ? 0 : 180;
    var _angles    = [15, -15];
    var _y_offsets = [-24, -8];

    for (var i = 0; i < 2; i++) {
        var _spawn_x = x + (facingDir * 28);
        var _spawn_y = y + _y_offsets[i];
        var _launch_dir = _base_dir + (_angles[i] * facingDir);

        var _proj = instance_create_depth(_spawn_x, _spawn_y, depth - 1, obj_rudebuster);
        
        with (_proj) {
            owner            = _self;
            target           = _target_inst;
            spd              = 9;
            lifetime         = 90;
            homing_intensity = 1;
            damage           = _mini_dmg;
            tp               = _tp;
            knockback_x      = _kb_x;
            knockback_y      = _kb_y;
            direction        = _launch_dir;
            image_angle      = direction;
            

            image_xscale     = 0.6;
            image_yscale     = 0.6;
        }
    }
}
                    
                }
        },
        
        "ralsei": {
            sprites: {
                healthbar    : ralseihpbar,   
                idle         : RalIdle1,
                walk         : RalRun,
                run          : RalHover,
                stop         : kris_stop,
                crouch       : kriscrouch,
                jump_start   : krisjumpstart,
                jump         : RalHover,
                jump_norm    : RalHover,
                fall_straight: RalHover,
                fall_slanted : RalHover,
                walk_fall    : RalHover,
                land_norm    : RalHover,
                land_slant   : RalHover,
                slash1       : RalAtk,
                slash2       : RalAtk,
                slash3       : RalAtk,
                air_slash1   : RalAtk,
                special      : {
                    down    : RalFire,
                    up      : RalHeal 
                }
            },

            attacks: {
                hp : 85,
                slash1:     { damage: 2,  knockback_x: 3, knockback_y: -2,  lifetime: 4, tpvalue: 3, sprite: krisslash1hitbox },
                slash2:     { damage: 3,  knockback_x: 4, knockback_y: -3,  lifetime: 4, tpvalue: 3, sprite: krisslash2hitbox },
                slash3:     { damage: 4,  knockback_x: 8, knockback_y: -6,  lifetime: 6, tpvalue: 3, sprite: krisslash3hitbox },
                air_slash1: { damage: 4,  knockback_x: 4, knockback_y:  2,  lifetime: 5, tpvalue: 3, sprite: krisairslashhitbox },
                
                special: {
                    down:    { damage: 15, knockback_x: 6, knockback_y: -3, lifetime: 120, tpcost: 25, tpvalue: 5, sprite: krisslash3hitbox },
                    up:      { damage: 15, knockback_x: 0, knockback_y: 0,  lifetime: 0,   tpcost: 32, tpvalue: 0, sprite: krisslash3hitbox }
                }
            },

            perform_special: {
                down: function() {
                    xspd = 0;
                    audio_play_sound(sndCritical, 8, false);
                },
                up: function() {
                    audio_play_sound(sndBump, 8, false);
                    yspd = jspd * 0.8;
                }
            },

            cast_special: {
                down: function() {

                    var _target_inst = noone;
                    var _closest_dist = 99999;
                    var _self = id;
                    
                    with (obj_fighter_parent) {
                        if (id != _self && !isDead) {
                            var _dist = distance_to_object(_self);
                            if (_dist < _closest_dist) {
                                _closest_dist = _dist;
                                _target_inst = id;
                            }
                        }
                    }

                    var _spawn_x = x + (facingDir * 24);
                    var _spawn_y = y - 12;
                    
                    var _sp_data = attacks.special.down;
                    var _proj = instance_create_depth(_spawn_x, _spawn_y, depth - 1, obj_rfire);
                    with (_proj) {
                        owner = _self;
                        target = _target_inst;
                        spd = 6;
                        lifetime = _sp_data.lifetime;
                        homing_intensity = 0.35; 
                        damage = _sp_data.damage;
                        tp = _sp_data.tpvalue;
                        knockback_x = _sp_data.knockback_x;
                        knockback_y = _sp_data.knockback_y;
                        
                        if (_target_inst != noone) {
                            direction = point_direction(x, y, _target_inst.x, _target_inst.y - 16);
                        } else {
                            direction = (_self.facingDir == 1) ? 0 : 180;
                        }
                        image_angle = direction;
                    }
                },
                up: function() {

                    var _heal_amount = attacks.special.up.damage;
                    if (hp < max_hp) { 
                        hp = min(max_hp, hp + _heal_amount); 
                    }
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