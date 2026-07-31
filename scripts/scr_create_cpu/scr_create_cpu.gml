function scr_create_cpu(_x, _y, _character, _stocks)
{
    var _cpu = instance_create_layer(_x, _y, "Instances", obj_cpu);

    with (_cpu)
    {
        is_cpu = true;
        team_id = 2;
        stocks_left = _stocks;

        character_id = string_lower(object_get_name(_character));

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

    return _cpu;
}