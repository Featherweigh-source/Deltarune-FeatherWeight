menu_state = "main";
main_menu = ["Player","Combat","Animation","Hitboxes","Exit"];
player_menu = ["HP","TP","Character", "Back"];
combat_menu = ["Spawn Dummy","Spawn CPUs","Reset Battle","Back"];
spawn_cpu_menu = ["Character","Amount","Lives","Spawn","Back"];
animation_menu = ["Animation", "Frame", "Speed", "Pause","Back"];
hitboxes_menu = ["Player Collision", "Hurtboxes", "Hitboxes", "Back"];
menu_items = main_menu;
menu_index = 0;

global.debug_open = false;
global.input_locked = false;

hp_min = 0;
hp_max = 200;
hp_bar_segments = 10;

spawn_character_objects = global.char_list;
spawn_character_names = global.char_names;
spawn_character_index = 0;

char_list = global.char_list;
char_names = global.char_names;
cpu_char_index = 0;

animation_names = [];
animation_sprites = [];
animation_index = 0;

frame_index = -1;

animation_speed = 0.2;

animation_paused = false;

global.debug_dummy = noone; 

animation_paused = false;

global.debug_show_player_collision = false;
global.debug_show_hurtboxes = false;
global.debug_show_hitboxes = false;

global.cpu_selected_char = char_list[cpu_char_index];

if (!variable_global_exists("cpu_count"))
    global.cpu_count = 1;

if (!variable_global_exists("stock_limit"))
    global.stock_limit = 3;
if (!variable_global_exists("cpu_count")) global.cpu_count = 1;
if (!variable_global_exists("stock_limit")) global.stock_limit = 3;

cpu_spawn_x = 500;
cpu_spawn_y = 300;
cpu_spawn_spacing = 80;