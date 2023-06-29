local ui_get, client_set_event_callback = ui.get, client.set_event_callback
local enabled = ui.new_checkbox("VISUALS", "Effects", "Thanos snap")
cvar.cl_ragdoll_physics_enable = cvar["cl_ragdoll_physics_enable"]

client_set_event_callback("paint", function()
    local value = ui_get(enabled) and 0 or 1
    if cvar.cl_ragdoll_physics_enable:get_int() ~= value then
        cvar.cl_ragdoll_physics_enable:set_int(value)
    end
end)