if (!variable_global_exists("p1_selected_char"))  global.p1_selected_char  = Kris; 
if (!variable_global_exists("cpu_selected_char")) global.cpu_selected_char = Susie;
if (!variable_global_exists("p1_needs_respawn"))   global.p1_needs_respawn  = false;
if (!variable_global_exists("p1_respawn_timer"))   global.p1_respawn_timer  = 0;

if (!variable_global_exists("cpu_count"))   global.cpu_count   = 1;
if (!variable_global_exists("stock_limit"))  global.stock_limit  = 3;

char_list  = [Kris, Susie, Ralsei];
char_names = ["KRIS", "SUSIE", "RALSEI"];

p1_char_index  = 0; 
cpu_char_index = 1;

audio_play_sound(musMenu, 5, true);

menu_state = "main"; 
menu_index = 0;

global.spawn_cpu = false;

main_options = ["START GAME", "VS CPU", "OPTIONS", "CONTROLS", "QUIT"];
options_labels = ["RESOLUTION", "FULLSCREEN", "VSYNC", "MUSIC", "VOLUME", "FPS DISPLAY", "FPS LIMIT", "SOUND TEST", "BACK"];
controls_labels = ["MOVE LEFT", "MOVE RIGHT", "JUMP", "SWORD SLASH", "RUN", "BACK"];

res_options = ["640x480", "1280x720", "1920x1080"];
res_index = 1;

is_fullscreen = false;
is_vsync = true;
show_fps = false;

music_enabled = true;
master_volume = 0.8;

sound_test_names = ["BGM: MENU", "BGM: BACKGROUND", "SFX: SELECT", "SFX: CONFIRM", "SFX: JUMP", "SFX: SWORD SLASH", "SFX: CRITICAL CHIME"];
sound_test_assets = [musMenu, musBackground, sndSelect, sndConfirm , sndJump, sndSlash, sndCritical];
sound_test_index = 0;

fps_limit_options = ["1", "5", "10", "15", "30", "60", "120", "144", "240", "UNLIMITED"];
fps_limit_index = 5; 

menu_options = main_options;
menu_total = array_length(menu_options);