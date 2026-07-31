if (keyboard_check_pressed(vk_f1))
{
    global.debug_open = !global.debug_open;
	global.input_locked = global.debug_open;
}

if (!instance_exists(obj_debug_cpu_manager))
{
    instance_create_layer(0, 0, "Instances", obj_debug_cpu_manager);
}

if (!global.debug_open) exit;

if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
{
    menu_index--;

    if (menu_index < 0)
        menu_index = array_length(menu_items) - 1;
}

if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
{
    menu_index++;

    if (menu_index >= array_length(menu_items))
        menu_index = 0;
}

// Player

if (menu_state == "player" && menu_index == 0)
{
    if (instance_exists(global.debug_target))
    {
        if (keyboard_check_pressed(vk_left))
        {
            global.debug_target.hp = max(0, global.debug_target.hp - 10);
        }

        if (keyboard_check_pressed(vk_right))
        {
            global.debug_target.hp = min(global.debug_target.max_hp, global.debug_target.hp + 10);
        }
    }
}

if (menu_state == "player" && menu_index == 1)
{
    if (instance_exists(global.debug_target))
    {
        if (keyboard_check_pressed(vk_left))
        {
            global.debug_target.tp = max(0, global.debug_target.tp - 10);
        }

        if (keyboard_check_pressed(vk_right))
        {
            global.debug_target.tp = min(global.debug_target.tpmax, global.debug_target.tp + 10);
        }
    }
}

if (menu_state == "player" && menu_index == 2)
{
    if (keyboard_check_pressed(vk_left))
    {
        spawn_character_index--;

        if (spawn_character_index < 0)
            spawn_character_index = array_length(spawn_character_names) - 1;

        var xx = global.debug_target.x;
        var yy = global.debug_target.y;
        var lay = layer_get_name(global.debug_target.layer);

        with (global.debug_target)
        {
            instance_destroy();
        }

        global.debug_target = instance_create_layer(xx, yy, lay, spawn_character_objects[spawn_character_index]);
    }

    if (keyboard_check_pressed(vk_right))
    {
        spawn_character_index++;

        if (spawn_character_index >= array_length(spawn_character_names))
            spawn_character_index = 0;

        var xx = global.debug_target.x;
        var yy = global.debug_target.y;
        var lay = layer_get_name(global.debug_target.layer);

        with (global.debug_target)
        {
            instance_destroy();
        }

        global.debug_target = instance_create_layer(xx, yy, lay, spawn_character_objects[spawn_character_index]);
    }
}

// Combat

if (menu_state == "combat" && menu_index == 0)
{
    if (keyboard_check_pressed(ord("Z"))) || keyboard_check_pressed(vk_enter)
    {
        if (!instance_exists(obj_dummy))
        {
            global.debug_dummy = instance_create_layer(176, 128, "Instances", obj_dummy);
        }
    }
}

if (menu_state == "spawn_cpu" && menu_index == 0)
{
    if (keyboard_check_pressed(vk_left))
    {
        cpu_char_index--;

        if (cpu_char_index < 0)
            cpu_char_index = array_length(char_list) - 1;

        global.cpu_selected_char = char_list[cpu_char_index];
    }

    if (keyboard_check_pressed(vk_right))
    {
        cpu_char_index++;

        if (cpu_char_index >= array_length(char_list))
            cpu_char_index = 0;

        global.cpu_selected_char = char_list[cpu_char_index];
    }
}

if (menu_state == "spawn_cpu" && menu_index == 1)
{
    if (keyboard_check_pressed(vk_left))
    {
        global.cpu_count = max(1, global.cpu_count - 1);
    }

    if (keyboard_check_pressed(vk_right))
    {
        global.cpu_count = min(20, global.cpu_count + 1);
    }
}

if (menu_state == "spawn_cpu" && menu_index == 2)
{
    if (keyboard_check_pressed(vk_left))
    {
        global.stock_limit = max(1, global.stock_limit - 1);
    }

    if (keyboard_check_pressed(vk_right))
    {
        global.stock_limit = min(99, global.stock_limit + 1);
    }
}
// Animation

if (menu_state == "animation" && menu_index == 0)
{
    if (keyboard_check_pressed(vk_left))
    {
        animation_index--;

        if (animation_index < 0)
            animation_index = array_length(animation_names) - 1;
    }

    if (keyboard_check_pressed(vk_right))
    {
        animation_index++;

        if (animation_index >= array_length(animation_names))
            animation_index = 0;
    }

    if (instance_exists(global.debug_target))
	{
		if (global.debug_target.sprite_index != animation_sprites[animation_index])
		{
			global.debug_target.sprite_index = animation_sprites[animation_index];
			global.debug_target.image_index = 0;
		}

		if (animation_paused)
			global.debug_target.image_speed = 0;
		else
			global.debug_target.image_speed = animation_speed;
	}
}

if (menu_state == "animation" && menu_index == 1)
{
    if (keyboard_check_pressed(vk_left))
    {
        frame_index--;

        if (frame_index < -1)
            frame_index = 7;
    }

    if (keyboard_check_pressed(vk_right))
    {
        frame_index++;

        if (frame_index > 7)
            frame_index = -1;
    }

    if (instance_exists(global.debug_target))
    {
        if (frame_index == -1)
		{
			global.debug_target.image_speed = animation_paused ? 0 : animation_speed;
		}
		else
		{
			global.debug_target.image_speed = 0;
			global.debug_target.image_index = min(frame_index, global.debug_target.image_number - 1);
		}
    }
}

if (menu_state == "animation" && menu_index == 2)
{
    if (keyboard_check_pressed(vk_left))
    {
        animation_speed = max(0, animation_speed - 0.1);
    }

    if (keyboard_check_pressed(vk_right))
    {
        animation_speed = min(3, animation_speed + 0.1);
    }

    animation_speed = round(animation_speed * 10) / 10;

    if (instance_exists(global.debug_target) && frame_index == -1)
	{
		global.debug_target.image_speed = animation_paused ? 0 : animation_speed;
	}
}

if (menu_state == "animation" && menu_index == 3)
{
    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right))
    {
        animation_paused = !animation_paused;

        if (instance_exists(global.debug_target))
        {
            if (animation_paused)
                global.debug_target.image_speed = 0;
            else if (frame_index == -1)
                global.debug_target.image_speed = animation_speed;
        }
    }
}
// hitboxes

if (menu_state == "hitboxes")
{
    if (menu_index == 0)
    {
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right))
            global.debug_show_player_collision = !global.debug_show_player_collision;
    }

    if (menu_index == 1)
    {
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right))
            global.debug_show_hurtboxes = !global.debug_show_hurtboxes;
    }

    if (menu_index == 2)
    {
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right))
            global.debug_show_hitboxes = !global.debug_show_hitboxes;
    }
}

//...

if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z")))
{
    switch (menu_state)
    {
        case "main":

            switch (menu_index)
            {
                case 0:
                    menu_state = "player";
                    menu_items = player_menu;
                    menu_index = 0;
                break;

                case 1:
                    menu_state = "combat";
                    menu_items = combat_menu;
                    menu_index = 0;
                break;

                case 2:
                    menu_state = "animation";
					menu_items = animation_menu;
					menu_index = 0;
					
					if (instance_exists(global.debug_target))
					{
						var s = global.debug_target.sprites;
						
						animation_names = [
						"Idle",
						"Walk",
						"Run",
						"Jump Start",
						"Jump",
						"Jump Normal",
						"Fall Slanted",
						"Fall Straight",
						"Walk Fall",
						"Crouch",
						"Stop",
						"Land Normal",
						"Land Slanted",
						"Slash 1",
						"Slash 2",
						"Slash 3",
						"Air Slash 1"
						];

						animation_sprites = [
						s.idle,
						s.walk,
						s.run,
						s.jump_start,
						s.jump,
						s.jump_norm,
						s.fall_slanted,
						s.fall_straight,
						s.walk_fall,
						s.crouch,
						s.stop,
						s.land_norm,
						s.land_slant,
						s.slash1,
						s.slash2,
						s.slash3,
						s.air_slash1
						];

						animation_index = 0;
						
						original_xscale = global.debug_target.image_xscale;
						flip_left = (original_xscale < 0);
						
					}
				break;

                case 3:
					menu_state = "hitboxes";
					menu_items = hitboxes_menu;
					menu_index = 0;
				break;

                case 4:
					
				break;

                case 5:
                    show_debug_message("Camera");
                break;

                case 6:
                    show_debug_message("Developer");
                break;

                case 7:
					audio_stop_sound(musBackground);
                    room_goto(rm_main_menu);
                break;
            }
			
        break;

        case "player":
            if (menu_items[menu_index] == "Back")
            {
                menu_state = "main";
                menu_items = main_menu;
                menu_index = 0;
            }

        break;

        case "combat":
			if (menu_items[menu_index] == "Spawn CPUs")
			{
				menu_state = "spawn_cpu";
				menu_items = spawn_cpu_menu;
				menu_index = 0;
			}
			
			if (menu_items[menu_index] == "Reset Battle")
			{
				scr_debug_reset_battle();
			}

			
			if (menu_items[menu_index] == "Back")
            {
                menu_state = "main";
                menu_items = main_menu;
                menu_index = 0;
            }
		break;
		
		case "spawn_cpu":

			if (menu_items[menu_index] == "Spawn")
			{
				Script3();

				for (var i = 0; i < global.cpu_count; i++)
				{
					var cpu = scr_create_cpu(
					cpu_spawn_x + i * cpu_spawn_spacing,
					cpu_spawn_y,
					global.cpu_selected_char,
					global.stock_limit
					);

					with (obj_debug_cpu_manager)
					{
						array_push(debug_cpus, cpu);
					}
				}
			}

			if (menu_items[menu_index] == "Back")
			{
				menu_state = "combat";
				menu_items = combat_menu;
				menu_index = 0;
			}

		break;
		
		case "animation":
            if (menu_items[menu_index] == "Back")
            {
				if (instance_exists(global.debug_target))
				{
					global.debug_target.image_speed = 1;
				}

			frame_index = -1;
            menu_state = "main";
            menu_items = main_menu;
            menu_index = 0;
            }

        break;
		
		case "hitboxes":
		if (menu_items[menu_index] == "Back")
		{
			menu_state = "main";
			menu_items = main_menu;
			menu_index = 0;
		}
		break;
    }
}