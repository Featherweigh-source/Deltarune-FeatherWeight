var _p1_exists = false;
with (obj_fighter_parent) {
    if (!is_cpu) _p1_exists = true;
}

if (!_p1_exists && p1_respawn_timer < 0) {
    if (stock_limit == 0 || p1_stocks_left > 1) {
        if (stock_limit > 0) p1_stocks_left--;
        p1_respawn_timer = respawn_delay_frames;
    }
}

if (p1_respawn_timer > 0) {
    p1_respawn_timer--;
} else if (p1_respawn_timer == 0) {
    var _p1 = instance_create_layer(p1_spawn_x, p1_spawn_y, "Instances", global.p1_selected_char);
    
    with (_p1) {
        is_cpu = false;
        team_id = 1;
        
        if (variable_global_exists("p1_character_id")) {
            character_id = global.p1_character_id;
        }
        
        var _data = get_fighter_data(character_id);
        sprites = _data.sprites;
        attacks = _data.attacks;

        var _perf_down = struct_exists(_data.perform_special, "down") ? _data.perform_special.down : function() {};
        var _perf_up   = struct_exists(_data.perform_special, "up")   ? _data.perform_special.up   : function() {};
        var _cast_down = struct_exists(_data.cast_special, "down")    ? _data.cast_special.down    : function() {};
        var _cast_up   = struct_exists(_data.cast_special, "up")      ? _data.cast_special.up      : function() {};

        perform_special = {
            down : method(id, _perf_down),
            up   : method(id, _perf_up)
        };

        cast_special = {
            down : method(id, _cast_down),
            up   : method(id, _cast_up)
        };

        sprite_index = sprites.idle;
    }
    
    p1_respawn_timer = -1;
}

if (global.spawn_cpu) {
    for (var i = array_length(cpu_respawn_queue) - 1; i >= 0; i--) {
        cpu_respawn_queue[i].timer--;
        
        if (cpu_respawn_queue[i].timer <= 0) {
            var _remaining_stocks = cpu_respawn_queue[i].stocks_left;
            
            if (stock_limit == 0 || _remaining_stocks > 1) {
                var _spawn_x = cpu_spawn_base_x + (i * cpu_spawn_offset);
                var _cpu_inst = instance_create_layer(_spawn_x, cpu_spawn_y, "Instances", obj_cpu);
                
                with (_cpu_inst) {
                    is_cpu = true;
                    team_id = 2;
                    stocks_left = (other.stock_limit == 0) ? 0 : (_remaining_stocks - 1);
                    character_id = string_lower(object_get_name(global.cpu_selected_char));
                    var _data = get_fighter_data(character_id);
                    sprites = _data.sprites;
                    attacks = _data.attacks;

                    var _perf_down = struct_exists(_data.perform_special, "down") ? _data.perform_special.down : function() {};
                    var _perf_up   = struct_exists(_data.perform_special, "up")   ? _data.perform_special.up   : function() {};
                    var _cast_down = struct_exists(_data.cast_special, "down")    ? _data.cast_special.down    : function() {};
                    var _cast_up   = struct_exists(_data.cast_special, "up")      ? _data.cast_special.up      : function() {};

                    perform_special = {
                        down : method(id, _perf_down),
                        up   : method(id, _perf_up)
                    };

                    cast_special = {
                        down : method(id, _cast_down),
                        up   : method(id, _cast_up)
                    };

                    sprite_index = sprites.idle;
                    
                    target = noone;
                    ai_decision_timer = 0;
                    
                    input = {
                        left          : false,
                        right         : false,
                        up            : false,
                        down          : false,
                        left_pressed  : false,
                        right_pressed : false,
                        up_pressed    : false,
                        down_pressed  : false,
                        jump          : false,
                        jump_pressed  : false,
                        run           : false,
                        hit_pressed   : false
                    };
                }
            }
            
            array_delete(cpu_respawn_queue, i, 1);
        }
    }
}

if p1_stocks_left <= 0
{ room_goto(rm_main_menu) };