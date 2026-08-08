lifespan--;
if (lifespan <= 0) {
    instance_destroy();
    exit;
}

if (instance_exists(owner)) {
    x = owner.x;
    y = owner.y;
}

if (max_lifespan > 0 && sprite_exists(sprite_index)) {
    var _total_frames = sprite_get_number(sprite_index);
    var _progress = 1 - (lifespan / max_lifespan);
    image_index = clamp(floor(_progress * _total_frames), 0, _total_frames - 1);
}

if (instance_exists(obj_debug_menu)) {
    image_alpha = global.debug_show_hitboxes ? 1 : 0;
}