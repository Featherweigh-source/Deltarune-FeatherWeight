if (!variable_global_exists("key_left"))  global.key_left  = vk_left;
if (!variable_global_exists("key_right")) global.key_right = vk_right;
if (!variable_global_exists("key_jump"))  global.key_jump  = vk_space;
if (!variable_global_exists("key_slash")) global.key_slash = ord("Z");
if (!variable_global_exists("key_run"))   global.key_run   = ord("X");

if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_main_menu);
    audio_stop_all();
}

input = {
    left         : keyboard_check(global.key_left),
    right        : keyboard_check(global.key_right),
    down         : keyboard_check(vk_down) || keyboard_check(ord("S")),
    left_pressed : keyboard_check_pressed(global.key_left)  || keyboard_check_pressed(ord("A")),
    right_pressed: keyboard_check_pressed(global.key_right) || keyboard_check_pressed(ord("D")),
    jump         : keyboard_check(global.key_jump),
    jump_pressed : keyboard_check_pressed(global.key_jump),
    run          : keyboard_check(global.key_run),
    hit_pressed  : keyboard_check_pressed(global.key_slash) || gamepad_button_check_pressed(0, gp_face3)
};

if (state == "stop" && (input.left || input.right)) {
    state = "move";
}

event_inherited();