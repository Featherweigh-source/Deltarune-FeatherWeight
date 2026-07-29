// Відкрити / закрити меню
if (keyboard_check_pressed(vk_f2))
{
    global.debug_open = !global.debug_open;
	global.input_locked = global.debug_open;
}

// Якщо меню закрите - більше нічого не робимо
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
                    show_debug_message("Spawn");
                break;

                case 3:
                    show_debug_message("Animation");
                break;

                case 4:
                    show_debug_message("Hitboxes");
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
            if (menu_items[menu_index] == "Back")
            {
                menu_state = "main";
                menu_items = main_menu;
                menu_index = 0;
            }

        break;
    }
}

if (keyboard_check_pressed(vk_f1))
{
    if (variable_global_exists("previous_room"))
    {
        audio_stop_sound(musBackground); // якщо випадково грає
		room_goto(global.previous_room);
    }
}