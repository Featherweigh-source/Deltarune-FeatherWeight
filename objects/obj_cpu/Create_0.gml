show_debug_message("--------------------------------------------------");
show_debug_message("SPAWNED " + object_get_name(object_index) + " (ID: " + string(id) + ")");
show_debug_message("CALL STACK:");
var _stack = debug_get_callstack();
for (var i = 0; i < array_length(_stack); i++) {
    show_debug_message("  " + string(_stack[i]));
}
show_debug_message("--------------------------------------------------");

if (!variable_instance_exists(id, "character_id")) {
    var _char_obj = variable_global_exists("cpu_selected_char") ? global.cpu_selected_char : Kris;
    character_id = string_lower(object_get_name(_char_obj));
}
is_cpu = true;

event_inherited();

target = noone;

ai_decision_timer      = 0;
ai_decision_interval   = 10;

ai_attack_range        = 55;
ai_run_range           = 110;
ai_attack_cooldown     = 0;
ai_attack_cooldown_max = 20;

ai_state               = "walk"; 
ai_walk_timer      = 0;
ai_walk_dir        = 1;

ai_jump_hold_timer     = 0;
ai_jump_hold_max       = 16;

ai_want_jump  = false;
ai_want_left  = false;
ai_want_right = false;
ai_want_down  = false;
ai_want_run   = false;
ai_want_hit   = false;

ai_prev_jump  = false;
ai_prev_left  = false;
ai_prev_right = false;
ai_prev_hit   = false;