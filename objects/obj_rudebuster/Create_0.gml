event_inherited();

spd = 8;
lifetime = 120;
homing_intensity = 0.1;
target = noone;
owner = noone;
damage = 10;
tp = 10;
knockback_x = 8;
knockback_y = -4;
facing_dir = 1;
turn_speed = 0.9;




var _my_owner = owner;
var _closest_dist = 999999;

with (obj_fighter_parent) {
    if (id != other.owner && !isDead) {
        var _d = point_distance(other.x, other.y, x, y);
        if (_d < _closest_dist) {
            _closest_dist = _d;
            other.target = id;
        }
    }
}

direction = (facing_dir == 1) ? 0 : 180;
image_angle = direction;