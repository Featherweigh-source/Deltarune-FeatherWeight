function Script3()
{
    if (!instance_exists(obj_debug_cpu_manager))
        exit;

    with (obj_debug_cpu_manager)
    {
        for (var i = 0; i < array_length(debug_cpus); i++)
        {
            if (instance_exists(debug_cpus[i]))
                with (debug_cpus[i])
                    instance_destroy();
        }

        debug_cpus = [];
    }
}