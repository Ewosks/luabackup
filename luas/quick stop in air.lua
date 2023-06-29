-- local variables for API functions. any changes to the line below will be lost on re-generation
local bit_band, client_current_threat, client_eye_position, client_trace_bullet, entity_get_local_player, entity_get_origin, entity_get_player_weapon, entity_get_prop, entity_is_alive, globals_curtime, math_abs, math_floor, math_sqrt, renderer_indicator, ui_get, ui_new_checkbox, ui_new_hotkey, ui_new_slider, ui_reference, pairs, ui_set, ui_set_callback, ui_set_visible = bit.band, client.current_threat, client.eye_position, client.trace_bullet, entity.get_local_player, entity.get_origin, entity.get_player_weapon, entity.get_prop, entity.is_alive, globals.curtime, math.abs, math.floor, math.sqrt, renderer.indicator, ui.get, ui.new_checkbox, ui.new_hotkey, ui.new_slider, ui.reference, pairs, ui.set, ui.set_callback, ui.set_visible

-- Requires
local vector = require 'vector'

-- UI Elements
local cs 	= {
	enable = ui_new_checkbox('Rage', 'Other', 'Quick stop in air'),
	hotkey = ui_new_hotkey('Rage', 'Other', 'Quick stop in air hotkey', true),
	indic = ui_new_checkbox('Rage', 'Other', 'Indicator'),
	peak = ui_new_checkbox('Rage', 'Other', 'Only at peak height'),
	dmg = ui_new_slider('Rage', 'Other', 'Minimum damage', 10, 110, 10, true),
	delay = ui_new_slider('Rage', 'Other', 'Delay', 0, 15, 8, true, '\''),
  dist = ui_new_slider('Rage', 'Other', 'Maximum distance', 100, 750, 350, true, 'u'),
	strafe = ui_reference('Misc', 'Movement', 'Air strafe'),
	easy = ui_reference('Misc', 'Movement', 'Easy strafe'),
}
local blacklist = { 'enable', 'strafe', 'easy' }

-- Variables
local tick, height, logged
local indicator_text = 'AS'
local r, g, b, a = 230, 50, 50, 255

-- C+P contains function
local function contains(table, key)
  for _, value in pairs(table) do
    if value == key then
      return true
    end
  end
  return false
end

-- Checking if number is in range [-amount, amount]
local function in_range(number, amount)
	return -amount <= number and number <= amount
end

-- Calculates an adaptive move amount
local function calc_add(amt)
	if -amt > 0 then return -amt + -50 end
	if -amt < 0 then return -amt + 50 end
	return -amt
end

-- Checking if local player can fire a shot
local can_fire = function(local_player)
  local local_weapon = entity_get_player_weapon(local_player)
  if local_weapon == nil then  return  end
  local local_weapon_id = entity_get_prop(local_weapon, 'm_iItemDefinitionIndex')
  local shootable = entity_get_prop(local_player, "m_flNextAttack") <= globals_curtime() and entity_get_prop(local_weapon, "m_flNextPrimaryAttack") <= globals_curtime()
  return (local_weapon_id == 40 and shootable) and true or false
end

-- Checking if target can be hit by local player, accounting for minimum damage and 
local hittable = function(local_player)
  if not client_current_threat() then return false end
  local target_origin = vector(entity_get_origin(client_current_threat()))
  if not target_origin then return false end
  local local_origin = vector(client_eye_position())
  local _, dmg = client_trace_bullet(local_player, local_origin.x, local_origin.y, local_origin.z, target_origin.x, target_origin.y, target_origin.z)
  return dmg >= ui_get(cs.dmg) and local_origin:dist(target_origin) <= ui_get(cs.dist) and can_fire(local_player)
end

-- Just an easier function than doing this multiple times
local function stop_strafe(bool)
	ui_set(cs.strafe, bool)
	ui_set(cs.easy, bool)
  if bool == true then
    indicator_text, r, g, b = 'AS', 230, 240, 100
  else
    indicator_text, r, g, b = 'AS STOPPING', 230, 50, 50
  end
end

-- Main logic
local function on_setup_command(cmd)
	local player = entity_get_local_player()
	if not player or not entity_is_alive(player) then return end
  local weapon = entity_get_player_weapon(player)
	if not weapon then return end
	if not tick then tick = cmd.command_number end
	local origin = vector(entity_get_origin(player))
	local flags = entity_get_prop(player, "m_fFlags")
	local onground = bit_band(flags, 1) ~= 0
	if ui_get(cs.hotkey) and not onground then
		if logged or ui_get(cs.delay) == 0 or ui_get(cs.peak) then
			if hittable(player) and can_fire(player) then
				if in_range(math_abs(math_floor(origin.z) - height), 1) and ui_get(cs.peak) then
					stop_strafe(false)
					cmd.forwardmove = calc_add(cmd.forwardmove)
					cmd.sidemove = calc_add(cmd.sidemove)
					cmd.in_duck = 1
					logged = false
				else
					if ui_get(cs.peak) then
						height = math_floor(origin.z)
					elseif ui_get(cs.delay) == 0 then
						stop_strafe(false)
						cmd.forwardmove = calc_add(cmd.forwardmove)
            cmd.sidemove = calc_add(cmd.sidemove)
            cmd.in_duck = 1
            logged = false
					elseif cmd.command_number >= tick then
						stop_strafe(false)
						cmd.forwardmove = calc_add(cmd.forwardmove)
            cmd.sidemove = calc_add(cmd.sidemove)
            cmd.in_duck = 1
            logged = false
					end
				end
			else
				stop_strafe(true)
			end
		else
			tick = cmd.command_number + ui_get(cs.delay)
			logged = true
		end
	else
		stop_strafe(true)
		logged, height = false, 0
	end
end

-- Render indicator
local on_paint = function()
  local player = entity_get_local_player()
  if not player or not entity_is_alive(player) then return end
  if ui_get(cs.indic) and ui_get(cs.hotkey) then
    renderer_indicator(r, g, b, a, indicator_text)
  end
end

-- Callbacks
local function callbacks(state)
	local callback = (state) and client.set_event_callback or client.unset_event_callback
	callback('setup_command', on_setup_command)
  callback('paint', on_paint)
end

-- Handle menu item visibility, set callbacks when lua enabled
local function visibility(ref)
	local enabled = ui_get(ref)
	for i, v in pairs(cs) do
		if not contains(blacklist, i) then
			ui_set_visible(cs[i], enabled)
		end
	end
	callbacks(enabled)
end

ui_set_callback(cs.enable, visibility)
visibility(cs.enable)