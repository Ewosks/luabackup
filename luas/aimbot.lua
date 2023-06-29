local renderer = _G['renderer']
local ui = _G['ui']
local client = _G['client']
local bit = require "bit"
local antiaim_funcs = require("gamesense/antiaim_funcs")
local ffi = require("ffi") or error("Failed to require FFI, please make sure Allow unsafe scripts is enabled!", 2)
local vector = require("vector") or error("missing vector",2)
local base64 = require("gamesense/base64")
local clipboard = require("gamesense/clipboard") or error("download clipboard from workshop")
local easing = require 'gamesense/easing'

function RGBtoHEX(redArg, greenArg, blueArg)

	return string.format('%.2x%.2x%.2xFF', redArg, greenArg, blueArg)

end


local hitlog = function()
    
    local menu = {}

    local callback = {}
    local new = function(register)
        table.insert(callback, register)
        return register
    end
    menu.create = function()
        menu.master_switch = new(ui.new_checkbox('LUA','B','Log switch'))
        menu.animate_speed = new(ui.new_slider('LUA','B','Animation speed',4,24,6))
        menu.flags = new(ui.new_combobox('LUA','B','Font flags',{" ","-","b"}))
        menu.addmode = new(ui.new_combobox('LUA','B','Log mode',{'+','-'}))
        menu.yoffset = new(ui.new_slider('LUA','B','Y offset',0,1650,1075))
		menu.xoffset = new(ui.new_slider('LUA','B','X offset',0,2560,1915))
        menu.add_y = new(ui.new_slider('LUA','B','split offset',0,30,18))
        menu.animate_select = new(ui.new_multiselect('LUA','B','Animate select','x','y','alpha'))
        menu.extra_features = new(ui.new_multiselect('LUA','B','Extra features','blur','gradient','timer bar'))

        menu.hit_color = new(ui.new_color_picker('LUA','B','color 1',255,255,255,255))
        menu.miss_color = new(ui.new_color_picker('LUA','B','color 2',255,255,255,255))

    end

    menu.visible = function()
        local switch = ui.get(menu.master_switch)

        ui.set_visible(menu.animate_speed,switch)
        ui.set_visible(menu.animate_select,switch)
        ui.set_visible(menu.hit_color,switch)
        ui.set_visible(menu.miss_color,switch)
        ui.set_visible(menu.flags,switch)
        ui.set_visible(menu.addmode,switch)
        ui.set_visible(menu.yoffset,switch)
		ui.set_visible(menu.xoffset,switch)
        ui.set_visible(menu.add_y,switch)
        ui.set_visible(menu.extra_features,switch)

    end

    menu.callbacks = function()
        for k, v in pairs(callback) do
            ui.set_callback(v,menu.visible)
        end
    end

    menu.create()
    menu.visible()
    menu.callbacks()

    local table_contains = function(tbl, val)
        for i=1,#tbl do
            if tbl[i] == val then
                return true
            end
        end
        return false
    end


    local animate = (function()
        local anim = {}

        local lerp = function(start, vend)
            local anim_speed = ui.get(menu.animate_speed)
            return start + (vend - start) * (globals.frametime() * anim_speed)
        end


        anim.new = function(value,startpos,endpos,condition)
            if condition ~= nil then
                if condition then
                    return lerp(value,startpos)
                else
                    return lerp(value,endpos)
                end

            else
                return lerp(value,startpos)
            end

        end


        return anim
    end)()


    local multitext = function(x,y,_table)
        for k, v in pairs(_table) do
            v.color = v.color or {255,255,255,255}
            v.color[4] = v.color[4] or 255
            renderer.text(x,y,v.color[1],v.color[2],v.color[3],v.color[4],v.flags,v.width,v.text)
            local text_size_x,text_size_y = renderer.measure_text(v.flags,v.text)
            x = x + text_size_x
        end
    end



--字体c居中/r靠右/默认靠左
    local measure_multitext = function(flags,_table)
        local a = 0;
        for b in pairs(_table) do
            flags = flags or ''
            a = a + renderer.measure_text(flags, text)
        end
        return a
    end

    local notify = {}
    
    local paint = function()
        local sx,sy = client.screen_size()
        
        local y = sy - ui.get(menu.yoffset)
		local x = sx - ui.get(menu.xoffset)

        for k, info in pairs(notify) do
            if info.text ~= nil or info.text ~= '' then
                local check_hit = info.hit

                local r,g,b,a = info.color.r,info.color.g,info.color.b

                info.alpha = animate.new(info.alpha,0,1,(info.timer + 3.8 < globals.realtime() ))
                local alpha = 0
                if table_contains(ui.get(menu.animate_select),'alpha')then
                    alpha = info.alpha
                else
                    alpha = 1 
                end

                local text_sizexx,text_sizeyx = renderer.measure_text(ui.get(menu.flags),info.text)


                if ui.get(menu.master_switch) then
                    local _table = {
                        {text = ui.get(menu.flags) == '-' and string.upper(info.hit_miss) or info.hit_miss,color = {255,255,255,alpha * 255},flags = ui.get(menu.flags),width = 0},
                        {text = ui.get(menu.flags) == '-' and string.upper(info.target_name) or info.target_name,color = {r,g,b,alpha * 255},flags = ui.get(menu.flags),width =  0},
                        {text = ui.get(menu.flags) == '-' and string.upper(info.group) or info.group,color = {255,255,255,alpha * 255},flags = ui.get(menu.flags),width =  0},
                        {text = ui.get(menu.flags) == '-' and string.upper(info.group_idx) or info.group_idx,color = {r,g,b,alpha * 255},flags = ui.get(menu.flags),width = 0},
                        {text = ui.get(menu.flags) == '-' and string.upper(info.reason) or info.reason,color = {255,255,255,alpha * 255},flags = ui.get(menu.flags),width =  0},
                        {text = ui.get(menu.flags) == '-' and string.upper(info.reason_idx) or info.reason_idx,color = {r,g,b,alpha * 255},flags = ui.get(menu.flags),width =  0},
                        {text = ui.get(menu.flags) == '-' and string.upper(info.damage) or info.damage,color = {255,255,255,alpha * 255},flags = ui.get(menu.flags),width =  0},
                        {text = ui.get(menu.flags) == '-' and string.upper(info.damage_idx) or info.damage_idx,color = {r,g,b,alpha * 255},flags = ui.get(menu.flags),width =  0},
                        {text = ui.get(menu.flags) == '-' and string.upper(info.health) or info.health,color = {255,255,255,alpha * 255},flags = ui.get(menu.flags),width =  0},
                        {text = ui.get(menu.flags) == '-' and string.upper(info.health_idx) or info.health_idx,color = {r,g,b,alpha * 255},flags = ui.get(menu.flags),width =  0},

                    }
                    local text_sizex,text_sizey = measure_multitext(ui.get(menu.flags),_table)



                    if table_contains(ui.get(menu.extra_features),'blur') then

                        --renderer.blur(x/2 - text_sizex/2 + math.floor( table_contains(ui.get(menu.animate_select),'x') and ui.get(menu.add_y) * info.alpha or 0) - 3 ,y,(text_sizex + 6) * info.alpha,(text_sizeyx + 2) * info.alpha)
                     renderer.gradient(x/2 - text_sizexx/2 + math.floor( table_contains(ui.get(menu.animate_select),'x') and ui.get(menu.add_y) * info.alpha or 0) - 3 ,y,(text_sizex + 6) * info.alpha,(text_sizeyx + 2) * info.alpha,20,20,20,200 * alpha, 20,20,20,0,true)

                    end
                    multitext(x/2 - text_sizexx/2 + math.floor( table_contains(ui.get(menu.animate_select),'x') and ui.get(menu.add_y) * info.alpha or 0) ,y,_table)

                    if table_contains(ui.get(menu.extra_features),'gradient') then
                        local realpha_rect = function(x,y,width,height,r,g,b,a)
				    		
                            --renderer.gradient(x - width/2 + 1 ,y,width/2,height,r,g,b,0,r,g,b,a,true)
                            --renderer.gradient(x ,y,width/2,height,r,g,b,a,r,g,b,0,true)
                        end
                        realpha_rect(
                            x/2 + math.floor( table_contains(ui.get(menu.animate_select),'x') and ui.get(menu.add_y) * info.alpha or 0),
                            y,
                            text_sizex/2,
                            text_sizeyx,-----------
                            r,g,b,alpha * 40
                        )

                    end
                    if table_contains(ui.get(menu.extra_features),'timer bar') then
                        info.timerbar = animate.new(info.timerbar,((text_sizex + 2) * ((math.floor(((info.timer + 4)/ globals.realtime())*10000) - 10000 )/ 5))) 
                        renderer.rectangle(
                            x/2  - text_sizexx/2 + math.floor( table_contains(ui.get(menu.animate_select),'x') and ui.get(menu.add_y) * info.alpha or 0) - 2,
                            y,
                            info.timerbar,
                            1 ,-----------
                            r,g,b,alpha * 255
                        )
                    end


                    -- renderer.text(sx/2 - text_sizex/2,y,r,g,b,alpha * 255,ui.get(menu.flags),
                    -- ( table_contains(ui.get(menu.animate_select),'width')) and text_sizex * info.alpha + 80 or 0
                    -- ,ui.get(menu.flags) == '-' and string.upper(info.text) or info.text)
                end
                if ui.get(menu.addmode) == '+' then
                    y = y + math.floor(ui.get(menu.add_y) * ( table_contains(ui.get(menu.animate_select),'y') and info.alpha or 1))
                else
                    y = y - math.floor(ui.get(menu.add_y) * ( table_contains(ui.get(menu.animate_select),'y') and info.alpha or 1))
                end



                if info.timer + 4 < globals.realtime() then
                    table.remove(notify,k)
                end
            end
        end
    end

    local player_hurt = function(e)
        if not ui.get(menu.master_switch) then
            return
        end
        local attacker_id = client.userid_to_entindex(e.attacker)
        if attacker_id == nil then
            return
        end
    
        if attacker_id ~= entity.get_local_player() then
            return
        end
    
        local hitgroup_names = { "Body", "Head", "Chest", "Stomach", "Left arm", "Right arm", "Left leg", "Right leg", "Neck", "?"}
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        local target_id = client.userid_to_entindex(e.userid)
        local target_name = entity.get_player_name(target_id)
        local enemy_health = entity.get_prop(target_id, "m_iHealth")
        local rem_health = enemy_health - e.dmg_health
        if rem_health <= 0 then
            rem_health = 0
        end
    
        local message = "Hit " .. string.lower(target_name) .. ", Group: " .. group .. "  Damage: " .. e.dmg_health .. "  Health remain: " .. rem_health
        if rem_health <= 0 then
            message = message .. " (death)"
        end
        local r,g,b,a = ui.get(menu.hit_color)
        print(message)
        table.insert(notify,{
            hit_miss = "✔ Hit ",
            target_name = string.lower(target_name),
            group = ", Group: ",
            group_idx = group,
            reason = '',
            reason_idx = '',
            damage = "  Damage: ",
            damage_idx  = e.dmg_health,
            health = "  Health remain: ",
            health_idx = rem_health,
            alpha = 0,
            color = {
                r = r ,g = g , b = b
            },
            timer = globals.realtime(),
            timerbar = 0
        })

    end

    local aimmiss = function(e)
        if not ui.get(menu.master_switch) then
            return
        end

        if e == nil then return end
        local hitgroup_names = { "Body", "Head", "Chest", "Stomach", "Left arm", "Right arm", "Left leg", "Right leg", "Neck", "?"}
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        local target_name = entity.get_player_name(e.target)
        local reason
        if e.reason == "?" then
            reason = "resolver"
        else
            reason = e.reason
        end

        local message =  "Missed "..string.lower(target_name)..", Group: "..group..", Reason: "..reason
        local r,g,b,a = ui.get(menu.miss_color)
        print(message)
        table.insert(notify,{
            hit_miss = "✖ Missed ",
            target_name = string.lower(target_name),
            group = ", Group: ",
            group_idx = group,
            reason = ', Reason: ',
            reason_idx = reason,
            damage = "",
            damage_idx  = '',
            health = "",
            health_idx = '',
            alpha = 0,
            color = {
                r = r ,g = g , b = b
            },
            timer = globals.realtime(),
            timerbar = 0
        })
    end



    client.set_event_callback('paint',paint)
    client.set_event_callback('aim_miss',aimmiss)
    client.set_event_callback('player_hurt',player_hurt)
end

hitlog()