function scr_debug_spawn_cpu(_x, _y, _character, _stocks)
{
    if (!instance_exists(obj_debug_cpu_manager))
        instance_create_layer(0, 0, "Instances", obj_debug_cpu_manager);

    var cpu = instance_create_layer(
        _x,
        _y,
        "Instances",
        obj_cpu
    );

    cpu.character_id = string_lower(object_get_name(_character));
    cpu.stock = _stocks;
    cpu.is_cpu = true;

    with (obj_debug_cpu_manager)
    {
        array_push(debug_cpus, cpu);
    }

    return cpu;
}