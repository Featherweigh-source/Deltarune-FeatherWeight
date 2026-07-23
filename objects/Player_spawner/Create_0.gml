if (!variable_global_exists("p1_selected_char")) {
    global.p1_selected_char = Kris;
}

if (!variable_global_exists("p1_needs_respawn")) global.p1_needs_respawn = false;
if (!variable_global_exists("p1_respawn_timer"))  global.p1_respawn_timer = 0;

show_debug_message("SPAWNING CHARACTER: " + object_get_name(global.p1_selected_char));

if (!instance_exists(obj_fighter_parent)) {
    instance_create_layer(x, y, layer, global.p1_selected_char);
}