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
    _p1.is_cpu = false;
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
                    stocks_left = (other.stock_limit == 0) ? 0 : (_remaining_stocks - 1);
                    character_id = string_lower(object_get_name(global.cpu_selected_char));
                    var _data = get_fighter_data(character_id);
                    sprites = _data.sprites;
                    attacks = _data.attacks;
                    sprite_index = sprites.idle;
                }
            }
            
            array_delete(cpu_respawn_queue, i, 1);
        }
    }
}