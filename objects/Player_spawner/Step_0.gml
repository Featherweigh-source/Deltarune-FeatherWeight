if (global.p1_needs_respawn && !instance_exists(obj_fighter_parent)) {
    if (global.p1_respawn_timer > 0) {
        global.p1_respawn_timer--;
    } else {
        instance_create_layer(x, y, layer, global.p1_selected_char);
        global.p1_needs_respawn = false;
    }
}