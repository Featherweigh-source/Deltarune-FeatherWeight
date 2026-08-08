if (!variable_instance_exists(id, "owner"))        owner = noone;
if (!variable_instance_exists(id, "damage"))       damage = 0;
if (!variable_instance_exists(id, "knockback_x"))  knockback_x = 0;
if (!variable_instance_exists(id, "knockback_y"))  knockback_y = 0;
if (!variable_instance_exists(id, "lifespan"))     lifespan = 10;
if (!variable_instance_exists(id, "max_lifespan")) max_lifespan = 10;

image_speed = 0;
image_alpha = 1;
hit_list = [];