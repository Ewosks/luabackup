local a = require("vector")
local b = ui.new_multiselect("VISUALS", "Other ESP", "Grenades", "Bar", "Text")
local c = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Molotov")
local d = ui.new_color_picker("VISUALS", "Other ESP", "Grenades: Molotov", 255, 0, 0, 50)
local e = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Smoke")
local f = ui.new_color_picker("VISUALS", "Other ESP", "Grenades: Smoke", 122, 154, 214, 30)
local g = 17.55
local h = 7
local i = 15
local j = 64
local k = a(client.screen_size())
local l = math.pi * 2
local function m(n, o)
    return math.sqrt((o.x - n.x) ^ 2 + (o.y - n.y) ^ 2 + (o.z - n.z) ^ 2)
end
local function p(q, r, s)
    if q < r then
        return r
    elseif q > s then
        return s
    end
    return q
end
local function t(u, v)
    for w, x in pairs(u) do
        if x == v then
            return true
        end
    end
    return false
end
local u = ui.get(b)
local y = t(u, "Bar")
local z = t(u, "Text")
local A = entity.get_local_player()
local function B(C, D, E, F, G)
    local H = 50
    local I = E
    local J = E + D
    local K = entity.get_prop(G, "m_bDidSmokeEffect") == 1
    if not K then
        return
    end
    local L = {entity.get_prop(G, "m_vecOrigin")}
    local M = a(L[1], L[2], L[3])
    local N, O = renderer.world_to_screen(M.x, M.y, M.z)
    local P = entity.get_prop(G, "m_nSmokeEffectTickBegin")
    local Q = globals.tickcount() - P
    local R = globals.tickinterval() * Q
    local S = (Q < i and Q or i) / i
    local T = p(1 - R / g, 0, 1)
    if S ~= 1 then
        C = C * S
    end
    for w = I, J, H do
        local U = w + H > J and J or w + H
        local V = a(M.x + C * math.cos(w), M.y + C * math.sin(w))
        local W = a(M.x + C * math.cos(U), M.y + C * math.sin(U))
        local X, Y = renderer.world_to_screen(V.x, V.y, M.z)
        local Z, _ = renderer.world_to_screen(W.x, W.y, M.z)
        if not (X == nil or Z == nil) then
            local a0 = 255
            if S ~= 1 then
                a0 = 255 * S
            end
            if T < 0.2 then
                a0 = 255 * (T + T * 4)
            end
            renderer.line(X, Y, Z, _, F[1], F[2], F[3], a0)
        end
    end
    if F[4] > 1 then
        for w = 0, l, H do
            local U = w + H > l and 0 or w + H
            local V = a(M.x + C * math.cos(w), M.y + C * math.sin(w))
            local W = a(M.x + C * math.cos(U), M.y + C * math.sin(U))
            local X, Y = renderer.world_to_screen(V.x, V.y, M.z)
            local Z, _ = renderer.world_to_screen(W.x, W.y, M.z)
            if not (X == nil or Z == nil or N == nil) then
                local a0 = F[4]
                if S ~= 1 then
                    a0 = F[4] * S
                end
                if T < 0.2 then
                    a0 = F[4] * (T + T * 4)
                end
                renderer.triangle(X, Y, Z, _, N, O, F[1], F[2], F[3], a0)
            end
        end
    end
    if N ~= nil and g - R > 0 then
        local a1 = 1
        if T < 0.2 then
            a1 = T + T * 4
        end
        if y then
            local a2 = 26
            local a3 = N - a2 / 2 + 2
            local a4 = p(1 - R / g, 0, 1)
            renderer.rectangle(a3, O + 17, a2, 4, 0, 0, 0, 150 * a1)
            renderer.rectangle(a3 + 1, O + 18, p(a2 * a4 - 2, 0, a2), 2, F[1], F[2], F[3], 255)
        end
        if z then
            renderer.text(N, O + (y and 25 or 20), 255, 255, 255, 200 * a1, "c-", 0, string.format("%.1f", g - R))
        end
    end
end
local function a5(M, C, D, E, F, G)
    local H = 0.1
    local I = E
    local J = E + D
    local P = entity.get_prop(G, "m_nFireEffectTickBegin")
    local Q = globals.tickcount() - P
    local R = globals.tickinterval() * Q
    local S = (Q < j and Q or j) / j
    local T = p(1 - R / h, 0, 1)
    for w = I, J, H do
        local U = w + H > J and J or w + H
        local V = a(M.x + C * math.cos(w), M.y + C * math.sin(w))
        local W = a(M.x + C * math.cos(U), M.y + C * math.sin(U))
        local X, Y = renderer.world_to_screen(V.x, V.y, M.z)
        local Z, _ = renderer.world_to_screen(W.x, W.y, M.z)
        if X ~= nil and Z ~= nil then
            local a0 = 255
            if S ~= 1 then
                a0 = 255 * S
            end
            if T < 0.2 then
                a0 = 255 * (T + T * 4)
            end
            renderer.line(X, Y, Z, _, F[1], F[2], F[3], a0)
        end
    end
    local N, O = renderer.world_to_screen(M.x, M.y, M.z)
    if F[4] > 1 then
        for w = 0, l, H do
            local U = w + H > l and 0 or w + H
            local V = a(M.x + C * math.cos(w), M.y + C * math.sin(w))
            local W = a(M.x + C * math.cos(U), M.y + C * math.sin(U))
            local X, Y = renderer.world_to_screen(V.x, V.y, M.z)
            local Z, _ = renderer.world_to_screen(W.x, W.y, M.z)
            if not (X == nil or Z == nil or N == nil) then
                local a0 = F[4]
                if S ~= 1 then
                    a0 = F[4] * S
                end
                if T < 0.2 then
                    a0 = F[4] * (T + T * 4)
                end
                renderer.triangle(X, Y, Z, _, N, O, F[1], F[2], F[3], a0)
            end
        end
    end
    local a6 = {entity.get_prop(G, "m_vecOrigin")}
    local a7 = a(a6[1], a6[2], a6[3])
    N, O = renderer.world_to_screen(a7.x, a7.y, a7.z)
    if N ~= nil and h - R > 0 then
        local a1 = 1
        if T < 0.2 then
            a1 = T + T * 4
        end
        if y then
            local a2 = 26
            local a3 = N - a2 / 2 + 2
            local a4 = p(1 - R / h, 0, 1)
            renderer.rectangle(a3, O + 17, a2, 4, 0, 0, 0, 150 * a1)
            renderer.rectangle(a3 + 1, O + 18, p(a2 * a4 - 2, 0, a2), 2, F[1], F[2], F[3], 255)
        end
        if z then
            renderer.text(N, O + (y and 25 or 20), 255, 255, 255, 200 * a1, "c-", 0, string.format("%.1f", h - R))
        end
        local a8 = entity.get_prop(G, "m_hOwnerEntity")
        local a9 = entity.get_prop(a8, "m_iTeamNum") == entity.get_prop(A, "m_iTeamNum") and a8 ~= A
        local aa = {153, 255, 0}
        local ab = {255, 60, 0}
        local F = a9 and aa or ab
    end
end
local E = 0
client.set_event_callback(
    "paint",
    function()
        u = ui.get(b)
        y = t(u, "Bar")
        z = t(u, "Text")
        A = entity.get_local_player()
        E = E + l / 1.25 * globals.frametime()
        if E > l then
            E = 0
        end
        if ui.get(e) then
            local ac = {ui.get(f)}
            for ad, G in pairs(entity.get_all("CSmokeGrenadeProjectile")) do
                B(125, l * 0.5, E, ac, G)
            end
        end
        if ui.get(c) then
            local ae = {ui.get(d)}
            for q, G in pairs(entity.get_all("CInferno")) do
                local a6 = {entity.get_prop(G, "m_vecOrigin")}
                local af = a(a6[1], a6[2], a6[3])
                local ag = {}
                for w = 1, 20 do
                    local Q =
                        a(
                        entity.get_prop(G, "m_fireXDelta", w),
                        entity.get_prop(G, "m_fireYDelta", w),
                        entity.get_prop(G, "m_fireZDelta", w)
                    )
                    local ah = Q + af
                    ag[w] = ah
                end
                local ai, aj = 1, 1
                local ak = 0
                for w = 1, #ag do
                    local al = ag[w]
                    al.z = a6[3]
                    for am = 1, #ag do
                        local an = ag[am]
                        an.z = a6[3]
                        local ao = m(al, an)
                        if ao > ak then
                            ak = ao
                            ai, aj = w, am
                        end
                    end
                end
                local ap = ag[ai]
                local aq = ag[aj]
                local ar = a((ap.x + aq.x) / 2, (ap.y + aq.y) / 2, (ap.z + aq.z) / 2)
                a5(ar, ak * 0.65, l * 0.25, E, ae, G)
            end
        end
    end
)
