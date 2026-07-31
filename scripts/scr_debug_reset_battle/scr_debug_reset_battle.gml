function scr_debug_reset_battle()
{
    with (obj_fighter_parent)
    {
        instance_destroy();
    }

    if (instance_exists(obj_debug_cpu_manager))
    {
        with (obj_debug_cpu_manager)
        {
            debug_cpus = [];
        }
    }

    with (obj_debug_manager)
    {
        instance_destroy();
    }

    instance_create_layer(0, 0, "Instances", obj_debug_manager);
}