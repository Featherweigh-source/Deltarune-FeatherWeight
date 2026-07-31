stock_limit = global.stock_limit;
respawn_delay_frames = 60;

p1_spawn_x = 100;
p1_spawn_y = 200;

cpu_spawn_base_x = 300;
cpu_spawn_y      = 200;
cpu_spawn_offset = 50;

p1_stocks_left   = stock_limit;
p1_respawn_timer = -1;

cpu_respawn_queue = [];

var _p1_exists = false;
with (obj_fighter_parent) {
    if (!is_cpu) _p1_exists = true;
}

if (!_p1_exists) {
    var _p1 = instance_create_layer(p1_spawn_x, p1_spawn_y, "Instances", global.p1_selected_char);
    
    with (_p1) {
        is_cpu  = false;
        team_id = 1;
        
        character_id = string_lower(object_get_name(global.p1_selected_char));
        var _data = get_fighter_data(character_id);
        sprites = _data.sprites;
        attacks = _data.attacks;
        sprite_index = sprites.idle;
    }
}

if (global.spawn_cpu)
{
    for (var i = 0; i < global.cpu_count; i++)
    {
        var cpu = scr_create_cpu(
            cpu_spawn_base_x + (i * cpu_spawn_offset),
            cpu_spawn_y,
            global.cpu_selected_char,
            stock_limit
        );

        if (variable_global_exists("teams_enabled") && global.teams_enabled)
        {
            cpu.team_id = 2;
        }
        else
        {
            cpu.team_id = 2 + i;
        }

        with (obj_debug_cpu_manager)
        {
            array_push(debug_cpus, cpu);
        }
    }
}

