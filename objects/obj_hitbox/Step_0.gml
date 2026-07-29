lifetime--;
if (lifetime <= 0) {
    instance_destroy();
}

if image_alpha != 1
{ show_debug_message("hitbox not visible") } else { show_debug_message("hitbox visible") };

