if (instance_exists(target) && variable_instance_exists(target, "isDead") && !target.isDead) {
    var _target_angle = point_direction(x, y, target.x, target.y - 16);
    var _angle_diff = angle_difference(_target_angle, direction);
    
    direction += clamp(_angle_diff, -homing_intensity, homing_intensity);
}

x += lengthdir_x(spd, direction);
y += lengthdir_y(spd, direction);

image_angle = direction;

lifetime--;
if (lifetime <= 0) {
    instance_destroy();
}