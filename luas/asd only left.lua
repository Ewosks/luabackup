local client_size = client.screen_size
local client_draw = client.draw_text
local client_draw_indicator = client.draw_indicator
local client_set_event_callback = client.set_event_callback

local ui_get = ui.get
local ui_set = ui.set
local ui_reference = ui.reference
local ui_new_hotkey = ui.new_hotkey
local ui_new_slider = ui.new_slider

local entity_get_local_player = entity.get_local_player
local entity_get_prop = entity.get_prop

local mindmg = ui_reference("rage", "aimbot", "minimum damage")
local change = ui_new_hotkey("rage", "other", "min dmg")
local dmg = ui_new_slider('rage', 'other', 'min dmg 1', 0, 126, 0, true)
local dmg2 = ui_new_slider('rage', 'other', 'min dmg 2', 0, 126, 0, true)





local last_value = 0
local should = false
local dmg_type = 0
local once = false

local function on_paint(c)

	
	
	local sw, sh = client_size()
	local x, y = sw / 2, sh - 200

	if not ui_get(change) and once then
		once = false
	end
	
	if ui_get(change) and not once then
		once = true
		dmg_type = dmg_type +1
		if dmg_type >= 3 then dmg_type = 0 end
	end
		

	
	client_draw_indicator(c, 255, 255, 255, 255, ui_get(mindmg))
	client_draw_indicator(c, 255, 255, 255, 255, dmg_type)
	

end

client_set_event_callback('paint', on_paint)