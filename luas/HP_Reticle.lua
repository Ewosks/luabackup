--[[credits: 
	Aviarita: thanks for the source
	Bacalhauz: Fix MinDamage, MaxDamage, FakeDuck Z Pos.
]]
--! YOU CAN EDIT YOUR TEXT POSITION OR SIZE HERE!

local TextPos = {
    ["X"] = 40, 
    ["Y"] = -12,
}

--EDIT YOUR TEXT SIZE HERE (DPI Scaled):
-- [-] = Small Text Size --> (My personal favorite.)
-- [ ] = Default Text Size
-- [+] = Lange Text Size

local TextSize = "cb"

--END OF EDITABLES

local sin, cos, rad = math.sin, math.cos, math.rad
local ui_get = ui.get
local get_prop = entity.get_prop
local GetLocalPlayer, GetWeapon, GetClassname = entity.get_local_player, entity.get_player_weapon, entity.get_classname
local camera_angles, eye_position = client.camera_angles, client.eye_position
local trace_line, trace_bullet = client.trace_line, client.trace_bullet
local screen_size = client.screen_size
local RenderText = renderer.text

local new_checkbox, new_color_picker, new_multiselect, new_label, reference = ui.new_checkbox, ui.new_color_picker, ui.new_multiselect, ui.new_label, ui.reference
local set_visible, set_callback = ui.set_visible, ui.set_callback
local HP_MSettings = {"HS Critical", "Extra information"}

local HP_Reticle = new_checkbox("LUA", "B", "HP Reticle")
local HP_MainColor = new_color_picker("LUA", "B", "HP Reticle", "255", "255", "255", "255")
local HP_Settings = new_multiselect("LUA", "B", "HP Reticle Settings:", HP_MSettings)
local HP_Critical =  new_label("LUA", "B", "HS Critical")
local HP_CritColor = new_color_picker("LUA", "B", "HS Critical", "242", "152", "64", "255")

local RefFakeduck = reference("RAGE", "Other", "Duck peek assist")

local weapons_ignored = {
    "CKnife",
    "CWeaponTaser",
    "CC4",
    "CHEGrenade",
    "CSmokeGrenade",
    "CMolotovGrenade",
    "CSensorGrenade",
    "CFlashbang",
    "CDecoyGrenade",
    "CIncendiaryGrenade"
}

local function contains(tab, val, pure_verify)
    for index, value in ipairs(pure_verify and tab or ui_get(tab)) do
        if value == val then 
            return true 
        end
    end
    return false
end

--Store boolean values from HP settings
local SettingsInfo = {}

--R, G, B, A
local HPColor = {0,0,0,0}

local LocalInfo = {
    Damage = 0,
    MaxDamage = 0,
    FixZ = 0,
    StoreZ = true,
}

local LocalPlayer = nil

local function ProcessReticle()
    LocalPlayer = GetLocalPlayer()

    if not entity.is_alive(LocalPlayer) or LocalPlayer == nil then return end

    local Weapon = GetWeapon(LocalPlayer)
    if Weapon == nil or contains(weapons_ignored, GetClassname(Weapon), true) then
        LocalInfo.Damage = -1
        return
    end
    
    local pitch, yaw, roll = camera_angles()
    local sin_pitch = sin( rad( pitch ))
    local cos_pitch = cos( rad( pitch ))
    local sin_yaw   = sin( rad( yaw ))
    local cos_yaw   = cos( rad( yaw ))

    --@Overide
    pitch = cos_pitch * cos_yaw
    yaw = cos_pitch * sin_yaw
    roll = -sin_pitch

    local EyeX, EyeY, EyeZ = eye_position()

    --Quick Fakeduck Eye Pos Fix
    if ui_get(RefFakeduck) then
        if EyeZ ~= LocalInfo.FixZ and LocalInfo.StoreZ then
            LocalInfo.FixZ = EyeZ
            LocalInfo.StoreZ = false
        end
    else
        LocalInfo.FixZ = EyeZ
        if not LocalInfo.StoreZ then
            LocalInfo.StoreZ = true
        end
    end

    local start_pos = { EyeX, EyeY, LocalInfo.FixZ }

    local fraction = trace_line(LocalPlayer, 
    start_pos[1],
    start_pos[2],
    start_pos[3],
    start_pos[1] + (pitch * 8192),
    start_pos[2] + (yaw * 8192),
    start_pos[3] + (roll * 8192))

    local end_pos = {
        start_pos[1] + (pitch * (8192 * fraction + 32)),
        start_pos[2] + (yaw * (8192 * fraction + 32)),
        start_pos[3] + (roll * (8192 * fraction + 32)),
    }

    if fraction > 0 and fraction < 1 then

        local _, dmg = trace_bullet(LocalPlayer, start_pos[1], start_pos[2], start_pos[3], end_pos[1], end_pos[2], end_pos[3], false)

        local maxdmg = 2*(dmg + dmg % 400) -- Don't ask why i made it back in 2019...

        LocalInfo.Damage, LocalInfo.MaxDamage = dmg, maxdmg

        --I do not expect you to understand this if you're new in lua. i was speedrunning and it's a easy inline IF.
        HPColor = SettingsInfo[1] and (maxdmg > 0 and maxdmg < 100 and {ui_get(HP_MainColor)} or {ui_get(HP_CritColor)}) or {ui_get(HP_MainColor)}

        --print(table.concat(HPColor, ", "))
    end

end

local function DrawReticle()

    if not entity.is_alive(LocalPlayer) or LocalPlayer == nil then return end
    local screen_width, screen_height = screen_size()
    if LocalInfo.Damage > 0 then
        local ExtraInfo = SettingsInfo[2] and string.format("(%d)",LocalInfo.MaxDamage) or ""
        RenderText(screen_width/2+TextPos["X"], screen_height/2+TextPos["Y"], HPColor[1], HPColor[2], HPColor[3], HPColor[4],"d"..TextSize, 0, LocalInfo.Damage, ExtraInfo)
    end
end


--! Below this line it only has good pratices for handling Events / Visibility, you should learn if you want absolute performance in your scripts...

local BlacklistedCallbacks = {
    HP_Critical,
    HP_CritColor,
}

local HandleVisibility = function() end --placeholder

local MultiExec = function(func, list, callback)
    for ref, val in pairs(list) do
        func(ref, val)
        if callback then
            if not contains(BlacklistedCallbacks, ref, true) then
                set_callback(ref, function() HandleVisibility() end)
            end
        end
    end
end

function HandleVisibility(AllowSetCallback)
    local vis = ui_get(HP_Reticle)
    local HPC = contains(HP_Settings, HP_MSettings[1])
    local HPI = contains(HP_Settings, HP_MSettings[2])

    SettingsInfo = {HPC, HPI}

    MultiExec(set_visible, {
        [HP_MainColor] = vis,
        [HP_Settings]  = vis,
        [HP_Critical]  = vis and HPC,
        [HP_CritColor] = vis and HPC,
    }, AllowSetCallback == true)
end
--Initialization
HandleVisibility(true)

set_callback(HP_Reticle, function(self)
    local GetStatus = ui_get(self)

    local SetOrUnset = GetStatus and "set" or "unset"

    client[SetOrUnset.."_event_callback"]("setup_command", ProcessReticle)
    client[SetOrUnset.."_event_callback"]("paint", DrawReticle)
    HandleVisibility()
end)