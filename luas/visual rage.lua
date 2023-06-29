local aimbot_on = ui.reference("RAGE", "Aimbot", "Enabled")
local min_dmg = ui.reference("RAGE", "Aimbot", "Minimum damage")
local autowall = ui.reference("RAGE", "Aimbot", "Automatic penetration")
local fake_duck = ui.reference("RAGE", "Other", "Duck peek assist")
local t_hitboxes = ui.reference("RAGE", "Aimbot", "Target hitbox")
local v_a, v_a_color = ui.reference("VISUALS", "Player ESP", "Visualize aimbot")
local hitboxes = {Head = 0, Chest = 3}
local lp = entity.get_local_player

client.set_event_callback("paint", function()
	if not lp() then return end
	if (entity.get_prop(lp(), "m_flDuckAmount") > 0.5 or ui.get(fake_duck)) and ui.get(v_a) then
		local r,g,b,a = ui.get(v_a_color)
		local x,y,z = entity.get_origin(lp())
		local th = ui.get(t_hitboxes)
		local players = entity.get_players(true)
		for i, player in ipairs(players) do
			if player ~= lp() and not entity.is_dormant(player) and entity.is_alive(player) and entity.is_enemy(player) then
				for j=1, #th do
					local his_x, his_y, his_z = entity.hitbox_position(player, hitboxes[th[j]])
					if his_x ~= nil then
						local _, damage = client.trace_bullet(lp(),x,y,z+64,his_x,his_y,his_z)
						if ui.get(autowall) and damage > ui.get(min_dmg) then
							local x, y = renderer.world_to_screen(his_x,his_y,his_z)
							renderer.circle(x, y, r, g, b, a, 2, 0, 1)
						else
							local fraction, _ = client.trace_line(lp(),x,y,z+64, his_x,his_y,his_z)
							if fraction > 0.9 and damage > ui.get(min_dmg) then
								local x, y = renderer.world_to_screen(his_x, his_y, his_z)
								renderer.circle(x, y, r, g, b, a, 2, 0, 1)
							end
						end
					end
				end
			end
		end
	end
end)