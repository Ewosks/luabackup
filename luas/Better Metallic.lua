local refs = {
    weapon_V = {ui.reference('Visuals', 'Colored Models', 'Weapon viewmodel')},
    check = ui.new_checkbox('Visuals', 'Colored Models', 'Better Metallic'),
    label = ui.new_label('Visuals', 'Colored Models', 'Best to use with Default chams')
}

client.set_event_callback('pre_render', function()

    r, g, b, a = ui.get(refs.weapon_V[2])
    if not ui.get(refs.weapon_V[1]) then return end

    if ui.get(refs.weapon_V[3]) == 'Default' or ui.get(refs.weapon_V[3]) == 'Shaded' or ui.get(refs.weapon_V[3]) == 'Metallic' then
        local material = materialsystem.viewmodel_material()
        local arm_material = materialsystem.arms_material()
        if material == nil or arm_material == nil then return end
        if ui.get(refs.check) then
            material:set_shader_param('$basetexture', 'vgui/white')
            material:set_shader_param('$envmap', 'models/effects/crystal_cube_vertigo_hdr')
            material:set_shader_param('$envmapfresnel', '1')
            material:set_shader_param('$envmapfresnelminmaxexp', '[0 1 2]')
            material:set_shader_param('$envmaptint')
            material:color_modulate(r, g, b)
            material:alpha_modulate(a)
            
            arm_material:set_shader_param('$basetexture', 'vgui/white')
            arm_material:set_shader_param('$envmap', 'models/effects/crystal_cube_vertigo_hdr')
            arm_material:set_shader_param('$envmapfresnel', '1')
            arm_material:set_shader_param('$envmapfresnelminmaxexp', '[0 1 2]')
            arm_material:set_shader_param('$envmaptint')
            arm_material:color_modulate(r, g, b)
            arm_material:alpha_modulate(a)
        else
            material:reload()
            arm_material:reload()
        end
    end

end)