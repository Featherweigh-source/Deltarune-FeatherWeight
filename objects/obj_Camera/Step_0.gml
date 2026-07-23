cam = view_camera[0];

var players = [];

with (obj_fighter_parent) {
    array_push(players, id);
}

var num_players = array_length(players);

if (num_players > 0) {

    var target_x = 0;
    var target_y = 0;
    for (var i = 0; i < num_players; i++) {
        target_x += players[i].x;
        target_y += players[i].y;
    }
    target_x /= num_players;
    target_y /= num_players;

    var max_dist_x = 0;
    var max_dist_y = 0;
    for (var i = 0; i < num_players; i++) {
        for (var j = i + 1; j < num_players; j++) {
            var dist_x = abs(players[i].x - players[j].x);
            var dist_y = abs(players[i].y - players[j].y);

            if (dist_x > max_dist_x) max_dist_x = dist_x;
            if (dist_y > max_dist_y) max_dist_y = dist_y;
        }
    }

    var target_zoom = max(
        1.0,
        (max_dist_x + zoom_border) / base_width,
        (max_dist_y + zoom_border) / base_height
    );
    target_zoom = clamp(target_zoom, 1.0, max_zoom_out);

    var current_width  = camera_get_view_width(cam);
    var current_height = camera_get_view_height(cam);
    var new_width  = lerp(current_width,  base_width  * target_zoom, smooth_speed);
    var new_height = lerp(current_height, base_height * target_zoom, smooth_speed);

    var current_x = camera_get_view_x(cam);
    var current_y = camera_get_view_y(cam);

    var new_x = lerp(current_x, target_x - (new_width / 2), smooth_speed);
    var new_y = lerp(current_y, target_y - (new_height / 2), smooth_speed);

    camera_set_view_pos(cam, new_x, new_y);
    camera_set_view_size(cam, new_width, new_height);
}