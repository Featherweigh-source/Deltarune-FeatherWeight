cam = view_camera[0];

base_width = 480;
base_height = 270;

bg_width = 1480;
bg_height = 1250;

max_zoom_out = min(bg_width / base_width, bg_height / base_height);

zoom_border = 64;
smooth_speed = 0.1;

room_x_min = 0;
room_y_min = 0;
room_x_max = bg_width;
room_y_max = bg_height;

display_set_gui_size(base_width, base_height);