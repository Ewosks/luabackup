--[[
    Credits ::
        Bassn / hitome56 - For his menu and this credit note :)
        pSilent   		 - Old ESP Preview code
]]
local ffi = require "ffi"
local images = require "gamesense/images"
local csgo_weapons = require "gamesense/csgo_weapons"
local http = require "gamesense/http"

local get_absoluteframetime, globals_curtime, globals_realtime = globals.absoluteframetime, globals.curtime, globals.realtime
local database_read, database_write = database.read, database.write
local math_sin, math_pi, math_floor, math_random, math_min, math_max, math_abs = math.sin, math.pi, math.floor, client.random_int, math.min, math.max, math.abs
local ui_get, ui_set, ui_new_checkbox, ui_new_slider, ui_new_combobox, ui_new_listbox, ui_new_label, ui_set_visible, ui_reference, ui_new_hotkey = ui.get, ui.set, ui.new_checkbox, ui.new_slider, ui.new_combobox, ui.new_listbox, ui.new_label, ui.set_visible, ui.reference, ui.new_hotkey
local ui_menu_position, ui_new_multiselect, ui_menu_size, ui_is_menu_open, ui_mouse_position, ui_set_callback = ui.menu_position, ui.new_multiselect, ui.menu_size, ui.is_menu_open, ui.mouse_position, ui.set_callback
local client_color_log, client_screen_size, client_key_state, client_set_event_callback, client_userid_to_entindex, client_exec, client_delay_call = client.color_log, client.screen_size, client.key_state, client.set_event_callback, client.userid_to_entindex, client.exec, client.delay_call
local renderer_line, renderer_rectangle, renderer_gradient, renderer_text = renderer.line, renderer.rectangle, renderer.gradient, renderer.text
local entity_get_prop, entity_get_local_player, entity_get_player_name = entity.get_prop, entity.get_local_player, entity.get_player_name

local winpos = ui_new_combobox("VISUALS", "Other ESP", "ESP Preview", "Off", "Left", "Right")

--- references ---
local name_esp, name_color = ui_reference("VISUALS", "Player ESP", "Name")
local box_esp, box_color = ui_reference("VISUALS", "Player ESP", "Bounding box")
local health_esp = ui_reference("VISUALS", "Player ESP", "Health bar")
local flags_esp = ui_reference("VISUALS", "Player ESP", "Flags")
local skeleton_esp, skeleton_color = ui_reference("VISUALS", "Player ESP", "Skeleton")
local glow, glow_color = ui_reference("VISUALS", "Player ESP", "Glow")
local weapon_esp_text = ui_reference("VISUALS", "Player ESP", "Weapon text")
local weapon_esp_icon, weapon_esp_icon_color = ui_reference("VISUALS", "Player ESP", "Weapon icon")
local ammo_esp, ammo_color = ui_reference("VISUALS", "Player ESP", "Ammo")
local distance_esp = ui_reference("VISUALS", "Player ESP", "Distance")
local money_esp = ui_reference("VISUALS", "Player ESP", "Money")
local chams, chams_color  = ui_reference("VISUALS", "Colored models", "Player")
local chamsb, chams_colorb, chams_combobox, chams_glow_color  = ui_reference("VISUALS", "Colored models", "Player behind wall")
local menu_hotkey_reference = ui_reference("MISC", "Settings", "Menu key")
local dpi_scale = ui_reference("MISC", "Settings", "DPI scale")

--main variables
local s = tonumber(ui_get(dpi_scale):sub(1, -2))/100
local b_w = 7-- border width
local screen_w, screen_h = client_screen_size()
local key_pressed_prev = false
local menu_open = true
local last_change = globals_realtime()-1

local url = {
	"https://i.imgur.com/CnvxZmf.png", -- main model
	"https://i.imgur.com/Qyl2vbF.png", -- glow
	"https://i.imgur.com/vWbnWQa.png", -- default
	"https://i.imgur.com/vpe917C.png", -- solid
	"https://i.imgur.com/mfPcmHG.png", -- inner glow
	"https://i.imgur.com/cC2dfK8.png", -- bubble
	"https://i.imgur.com/xBWF7zS.png", -- shaded
	"https://i.imgur.com/aMsSqqs.png", -- metallic
}

local model = {}
for i=1, 8 do
	http.get(url[i], function(s, r)
		if s and r.status == 200 then
			model[i] = images.load(r.body)
		end  
	end)
end
local function menu(s_x, s_y, s_w, s_h, s_alpha, do_gradient)
    renderer_rectangle(s_x - 6, s_y - 6, s_w + 12, s_h + 12, 12, 12, 12, s_alpha)
    renderer_rectangle(s_x - 5, s_y - 5, s_w + 10, s_h + 10, 60, 60, 60, s_alpha)
    renderer_rectangle(s_x - 4, s_y - 4, s_w + 8, s_h + 8, 40, 40, 40, s_alpha)
    renderer_rectangle(s_x - 1, s_y - 1, s_w + 2, s_h + 2, 60, 60, 60, s_alpha)
    renderer_rectangle(s_x, s_y, s_w, s_h, 23, 23, 23, s_alpha)
    if do_gradient then
        renderer_gradient(s_x + 1, s_y + 1, s_w / 2 - 1, s, 55, 177, 218, s_alpha, 201, 84, 205, s_alpha, true)
        renderer_gradient(s_x + s_w / 2 - 1, s_y + 1, s_w / 2, s, 201, 84, 205, s_alpha, 204, 207, 53, s_alpha, true)
    end
end

client_set_event_callback("paint_ui", function() -- inventory handling
	local name_r, name_g, name_b, name_a = ui_get(name_color)
	local box_r, box_g, box_b, box_a = ui_get(box_color)
	local skeleton_r, skeleton_g, skeleton_b, skeleton_a = ui_get(skeleton_color)
	local ammo_r, ammo_g, ammo_b, ammo_a = ui_get(ammo_color)
	local icon_r, icon_g, icon_b, icon_a = ui_get(weapon_esp_icon_color)
	local glow_r, glow_g, glow_b, glow_a = ui_get(glow_color)
	local chams_r, chams_g, chams_b, chams_a = ui_get(chams_color)
	local chams_glow_r, chams_glow_g, chams_glow_b, chams_glow_a = ui_get(chams_glow_color)
	local flag_offset = 41
	local other_offset = 0
	local weapon_icon = images.get_weapon_icon("weapon_scar20")
	local menu_pos_x, menu_pos_y = ui_menu_position()          
	local menu_pos_w, menu_pos_h = ui_menu_size()
	if ui.get(winpos) == "Off" then
		return
	elseif ui.get(winpos) == "Left" then
		x_i, y_i = menu_pos_x - 205, menu_pos_y + 6
	elseif ui.get(winpos) == "Right" then
		x_i, y_i = menu_pos_x + menu_pos_w + 15, menu_pos_y + 6
	end
	local key_pressed = ui_get(menu_hotkey_reference)
	if key_pressed and not key_pressed_prev then
		menu_open = not menu_open
		last_change = globals_realtime()
	end
	key_pressed_prev = key_pressed
	local opacity_multiplier = 0
	if menu_open then
		opacity_multiplier = 1
	end
	if globals_realtime() - last_change < 0.15 then
		opacity_multiplier = (globals_realtime() - last_change) / 0.15
		if not menu_open then
			opacity_multiplier = 1 - opacity_multiplier
		end
	end
	for i=1, 8 do
		if model[i] == nil then
			return
		end
	end
	-- [ MENU ]
	menu(x_i, y_i, 185, 275, 255*opacity_multiplier, true)
	-- [ NAME ]
	if ui_get(name_esp) then
		renderer_text(x_i + 90, y_i + 35, name_r, name_g, name_b, name_a*opacity_multiplier, "c", 0, "Dave")
	end
	-- [ HEALTH ]
	if ui_get(health_esp) then
		renderer_rectangle(x_i + 34, y_i + 42, 2, 140, 0, 0, 0, 120*opacity_multiplier)
		renderer_rectangle(x_i + 34, y_i + 85, 2, 135, 71, 208, 63, 255*opacity_multiplier)
		renderer_text(x_i + 29, y_i + 79, 255, 255, 255, 255*opacity_multiplier, "-", 0, "76")
	end
	-- [ BOX ]
	if ui_get(box_esp) then
		renderer_line(x_i + 40, y_i + 42, x_i + 140, y_i + 42, box_r, box_g, box_b, box_a*opacity_multiplier)
		renderer_line(x_i + 40, y_i + 42, x_i + 40, y_i + 220, box_r, box_g, box_b, box_a*opacity_multiplier)
		renderer_line(x_i + 40, y_i + 220, x_i + 140, y_i + 220, box_r, box_g, box_b, box_a*opacity_multiplier)
		renderer_line(x_i + 140, y_i + 220, x_i + 140, y_i + 42, box_r, box_g, box_b, box_a*opacity_multiplier)
	end
	-- [ MONEY ]
	if ui_get(money_esp) then
		renderer_text(x_i + 143, y_i + 41, 115, 180, 25, 255*opacity_multiplier, "-", 0, "$1337")
		flag_offset = flag_offset + 9
	end
	-- [ FLAGS ]
	if ui_get(flags_esp) then
		renderer_text(x_i + 143, y_i + flag_offset, 255, 255, 255, 255*opacity_multiplier, "-", 0, "HK")
		renderer_text(x_i + 143, y_i + flag_offset + 9, 53, 166, 208, 255*opacity_multiplier, "-", 0, "ZOOM")
		renderer_text(x_i + 143, y_i + flag_offset + 18, 255, 255, 255, 255*opacity_multiplier, "-", 0, "FAKE")
		renderer_text(x_i + 143, y_i + flag_offset + 27, 255, 0, 0, 255*opacity_multiplier, "-", 0, "PIN")
	end
	-- [ AMMO ]
	if ui_get(ammo_esp) then
		renderer_rectangle(x_i + 40, y_i + 225 + other_offset, 100, 2, 0, 0, 0, 120*opacity_multiplier)
		renderer_rectangle(x_i + 40, y_i + 225 + other_offset, 65, 2, ammo_r, ammo_g, ammo_b, ammo_a*opacity_multiplier)
		renderer_text(x_i + 105, y_i + 227 + other_offset, 255, 255, 255, 255*opacity_multiplier, "c-", 0, "13")
		other_offset = other_offset + 10
	end
	-- [ DISTANCE ]
	if ui_get(distance_esp) then
		renderer_text(x_i + 85, y_i + 226 + other_offset, 255, 255, 255, 255*opacity_multiplier, "c-", 0, "70 FT")
		other_offset = other_offset + 10
	end
	-- [ WEAPON TEXT ]
	if ui_get(weapon_esp_text) then
		renderer_text(x_i + 85, y_i + 227 + other_offset, 255, 255, 255, 255*opacity_multiplier, "c-", 0, "SCAR-20")
		other_offset = other_offset + 10
	end
	-- [ WEAPON ICON ]
	if ui_get(weapon_esp_icon) then
		weapon_icon:draw(x_i + 70, y_i + 225 + other_offset, nil, 12, icon_r, icon_g, icon_b, icon_a*opacity_multiplier, 10, "")
		other_offset = other_offset + 10
	end
	-- [ GLOW ]
	if ui_get(glow) then
		model[2]:draw(x_i+35, y_i+35, nil, 180, glow_r, glow_g, glow_b, glow_a*opacity_multiplier)
	end	
	-- [ MODEL & CHAMS ]
	if ui_get(chams) == false then
		model[1]:draw(x_i+35, y_i+35, nil, 180, 255, 255, 255, 255*opacity_multiplier)
	elseif ui_get(chams_combobox) == "Default" then
		model[3]:draw(x_i+35, y_i+35, nil, 180, chams_r, chams_g, chams_b, chams_a*opacity_multiplier)
	elseif ui_get(chams_combobox) == "Solid" then
		model[4]:draw(x_i+35, y_i+35, nil, 180, chams_r, chams_g, chams_b, chams_a*opacity_multiplier)
	elseif ui_get(chams_combobox) == "Shaded" then
		model[3]:draw(x_i+35, y_i+35, nil, 180, chams_r, chams_g, chams_b, chams_a*opacity_multiplier)
		model[7]:draw(x_i+35, y_i+35, nil, 180, chams_glow_r, chams_glow_g, chams_glow_b, chams_glow_a*opacity_multiplier)
	elseif ui_get(chams_combobox) == "Glow" then
		model[3]:draw(x_i+35, y_i+35, nil, 180, chams_r, chams_g, chams_b, chams_a*opacity_multiplier)
		model[5]:draw(x_i+35, y_i+35, nil, 180, chams_glow_r, chams_glow_g, chams_glow_b, chams_glow_a*opacity_multiplier)
	elseif ui_get(chams_combobox) == "Bubble" then
		model[6]:draw(x_i+35, y_i+35, nil, 180, chams_r, chams_g, chams_b, chams_a*opacity_multiplier)
		model[7]:draw(x_i+35, y_i+35, nil, 180, chams_glow_r, chams_glow_g, chams_glow_b, chams_glow_a*opacity_multiplier)
	elseif ui_get(chams_combobox) == "Metallic" then
		model[3]:draw(x_i+35, y_i+35, nil, 180, chams_r, chams_g, chams_b, chams_a*opacity_multiplier)
		model[8]:draw(x_i+35, y_i+35, nil, 180, chams_glow_r, chams_glow_g, chams_glow_b, chams_glow_a/2*opacity_multiplier)
	elseif ui_get(chams_combobox) == "Original" then
		model[1]:draw(x_i+35, y_i+35, nil, 180, chams_r, chams_g, chams_b, chams_a*opacity_multiplier)
	end
	-- [ SKELETON ]
	if ui_get(skeleton_esp) then
		--body
		renderer_line(x_i + 90, y_i + 62, x_i + 86, y_i + 125, skeleton_r, skeleton_g, skeleton_b, skeleton_a*opacity_multiplier)
		--left leg
		renderer_line(x_i + 86, y_i + 125, x_i + 76, y_i + 140, skeleton_r, skeleton_g, skeleton_b, skeleton_a*opacity_multiplier)
		renderer_line(x_i + 76, y_i + 140, x_i + 78, y_i + 162, skeleton_r, skeleton_g, skeleton_b, skeleton_a*opacity_multiplier)
		renderer_line(x_i + 78, y_i + 162, x_i + 88, y_i + 195, skeleton_r, skeleton_g, skeleton_b, skeleton_a*opacity_multiplier)
		--right leg
		renderer_line(x_i + 86, y_i + 125, x_i + 98, y_i + 140, skeleton_r, skeleton_g, skeleton_b, skeleton_a*opacity_multiplier)
		renderer_line(x_i + 98, y_i + 140, x_i + 100, y_i + 168, skeleton_r, skeleton_g, skeleton_b, skeleton_a*opacity_multiplier)
		renderer_line(x_i + 100, y_i + 168, x_i + 108, y_i + 195, skeleton_r, skeleton_g, skeleton_b, skeleton_a*opacity_multiplier)
		--left arm
		renderer_line(x_i + 88, y_i + 85, x_i + 71, y_i + 88, skeleton_r, skeleton_g, skeleton_b, skeleton_a*opacity_multiplier)
		renderer_line(x_i + 71, y_i + 88, x_i + 62, y_i + 103, skeleton_r, skeleton_g, skeleton_b, skeleton_a*opacity_multiplier)
		renderer_line(x_i + 62, y_i + 103, x_i + 60, y_i + 82, skeleton_r, skeleton_g, skeleton_b, skeleton_a*opacity_multiplier)
		--right arm
		renderer_line(x_i + 88, y_i + 85, x_i + 107, y_i + 88, skeleton_r, skeleton_g, skeleton_b, skeleton_a*opacity_multiplier)
		renderer_line(x_i + 107, y_i + 88, x_i + 115, y_i + 101, skeleton_r, skeleton_g, skeleton_b, skeleton_a*opacity_multiplier)
		renderer_line(x_i + 115, y_i + 101, x_i + 110, y_i + 125, skeleton_r, skeleton_g, skeleton_b, skeleton_a*opacity_multiplier)
	end
end)