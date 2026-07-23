if (sprite_index == sprites.stop) {
    is_stopping = false;
    sprite_index = sprites.run;
    image_index = 0;
    image_speed = 0;
}

if (sprite_index == sprites.land_norm || sprite_index == sprites.land_slant) {
    is_landing = false;
}