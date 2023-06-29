local vector = require("vector")

local positions = {}
local lc = false

client.set_event_callback("setup_command", function(cmd)
    local plocal = entity.get_local_player()
    local origin = vector(entity.get_origin(plocal))
    local time = 1 / globals.tickinterval()

    if cmd.chokedcommands == 0 then
        positions[#positions + 1] = origin

        if #positions >= time then
            local record = positions[time]
            lc = (origin - record):lengthsqr() > 4096
        end
    end

    if #positions > time then
        table.remove(positions, 1)
    end   
end)

client.set_event_callback("paint", function()
    local plocal = entity.get_local_player()
    local flags = entity.get_prop(plocal, "m_fFlags")

    if bit.band(flags, 1) == 1 and not lc or not entity.is_alive(plocal) then
        return
    end

    local r, g, b, a = 240, 15, 15, 240

    if lc then
        r, g, b = 160, 202, 43
    end
    
    renderer.indicator(r, g, b, a, "LC")
end)