local player_models = {
    -- [Menu name] = path to model
    ["Spiderman"] = "models/player/custom_player/kuristaja/spiderman/spiderman.mdl",
    ["Ash"] = "models/player/custom_player/kuristaja/ash/ash.mdl",
    ["T Arctic"] = "models/player/custom_player/eminem/css/t_arctic.mdl",
    ["Maozi"] = "models/player/custom_player/darnias/sas_william_fix.mdl",
    ["GL"] = "models/player/custom_player/kaesar/ghostface/ghostface.mdl",
    ["Slingshot"] = "models/player/custom_player/legacy/tm_phoenix_variantg.mdl",
    ["Jumpsuit"] = "models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl",
    ["Dangerzone1"] = "models/player/custom_player/legacy/tm_jumpsuit_variantb.mdl",
    ["Dangerzone2"] = "models/player/custom_player/legacy/tm_jumpsuit_variantc.mdl",
    ["Local T Agent"] = "models/player/custom_player/legacy/tm_phoenix.mdl",
    ["Local CT Agent"] = "models/player/custom_player/legacy/ctm_sas.mdl", 
    ["Silent | Sir Bloody Darryl"] = "models/player/custom_player/legacy/tm_professional_varf1.mdl",
    ["Vypa Sista of the Revolution | Guerrilla Warfare"] = "models/player/custom_player/legacy/tm_jungle_raider_variante.mdl",
    ["'Medium Rare' Crasswater | Guerrilla Warfare"] = "models/player/custom_player/legacy/tm_jungle_raider_variantb2.mdl",
    ["Crasswater The Forgotten | Guerrilla Warfare"]= "models/player/custom_player/legacy/tm_jungle_raider_variantb.mdl",
    ["Skullhead | Sir Bloody Darryl"] ="models/player/custom_player/legacy/tm_professional_varf2.mdl", 
    ["Chef d'Escadron Rouchard | Gendarmerie Nationale"]= "models/player/custom_player/legacy/ctm_gendarmerie_variantc.mdl", 
    ["Cmdr. Frank 'Wet Sox' Baroud | SEAL Frogman"]= "models/player/custom_player/legacy/ctm_diver_variantb.mdl", 
    ["Cmdr. Davida 'Goggles' Fernandez | SEAL Frogman"]= "models/player/custom_player/legacy/ctm_diver_varianta.mdl", 
    ["Royale | Sir Bloody Darryl"]= "models/player/custom_player/legacy/tm_professional_varf3.mdl",
    ["Loudmouth | Sir Bloody Darryl"]= "models/player/custom_player/legacy/tm_professional_varf4.mdl",
    ["Miami | Sir Bloody Darryl"]= "models/player/custom_player/legacy/tm_professional_varf.mdl", 
    ["Getaway Sally | Professional"]= "models/player/custom_player/legacy/tm_professional_varj.mdl", 
    ["Elite Trapper Solman | Guerrilla Warfare"]= "models/player/custom_player/legacy/tm_jungle_raider_varianta.mdl", 
    [ "Bloody Darryl The Strapped | The Professionals"]= "models/player/custom_player/legacy/tm_professional_varf5.mdl", 
    [ "Chem-Haz Capitaine | Gendarmerie Nationale"]= "models/player/custom_player/legacy/ctm_gendarmerie_variantb.mdl", 
    [ "Lieutenant Rex Krikey | SEAL Frogman"]= "models/player/custom_player/legacy/ctm_diver_variantc.mdl", 
    ["Arno The Overgrown | Guerrilla Warfare"]= "models/player/custom_player/legacy/tm_jungle_raider_variantс.mdl", 
    ["Col. Mangos Dabisi | Guerrilla Warfare"]= "models/player/custom_player/legacy/tm_jungle_raider_variantd.mdl", 
    ["Officer Jacques Beltram | Gendarmerie Nationale"]= "models/player/custom_player/legacy/ctm_gendarmerie_variante.mdl", 
    ["Trapper | Guerrilla Warfare"]= "models/player/custom_player/legacy/tm_jungle_raider_variantf2.mdl", 
    ["Lieutenant 'Tree Hugger' Farlow | SWAT"]= "models/player/custom_player/legacy/ctm_swat_variantk.mdl", 
    ["Sous-Lieutenant Medic | Gendarmerie Nationale"]= "models/player/custom_player/legacy/ctm_gendarmerie_varianta.mdl", 
    ["Primeiro Tenente | Brazilian 1st Battalion"]= "models/player/custom_player/legacy/ctm_st6_variantn.mdl", 
    ["D Squadron Officer | NZSAS"]= "models/player/custom_player/legacy/ctm_sas_variantg.mdl", 
    ["Trapper Aggressor | Guerrilla Warfare"]= "models/player/custom_player/legacy/tm_jungle_raider_variantf.mdl", 
    ["Aspirant | Gendarmerie Nationale"]= "models/player/custom_player/legacy/ctm_gendarmerie_variantd.mdl",
    ["AGENT Gandon | Professional"]="models/player/custom_player/legacy/tm_professional_vari.mdl", 
    ["Safecracker Voltzmann | Professinal"]= "models/player/custom_player/legacy/tm_professional_varg.mdl", 
    ["Little Kev | Professinal"] ="models/player/custom_player/legacy/tm_professional_varh.mdl", 
    ["Blackwolf | Sabre"]= "models/player/custom_player/legacy/tm_balkan_variantj.mdl", 
    ["Rezan the Redshirt | Sabre"]= "models/player/custom_player/legacy/tm_balkan_variantk.mdl", 
    ["Rezan The Ready | Sabre"]="models/player/custom_player/legacy/tm_balkan_variantg.mdl", 
    ["Maximus | Sabre"]= "models/player/custom_player/legacy/tm_balkan_varianti.mdl", 
    ["Dragomir | Sabre"] ="models/player/custom_player/legacy/tm_balkan_variantf.mdl", 
    ["Dragomir | Sabre Footsoldier"]= "models/player/custom_player/legacy/tm_balkan_variantl.mdl", 
    ["Lt. Commander Ricksaw | NSWC SEAL"]="models/player/custom_player/legacy/ctm_st6_varianti.mdl", 
    ["'Two Times' McCoy | USAF TACP"]= "models/player/custom_player/legacy/ctm_st6_variantm.mdl", 
    ["'Two Times' McCoy | USAF Cavalry"]= "models/player/custom_player/legacy/ctm_st6_variantl.mdl", 
    ["Buckshot | NSWC SEAL"]= "models/player/custom_player/legacy/ctm_st6_variantg.mdl", 
    ["'Blueberries' Buckshot | NSWC SEAL"] ="models/player/custom_player/legacy/ctm_st6_variantj.mdl", 
    ["Seal Team 6 Soldier | NSWC SEAL"]= "models/player/custom_player/legacy/ctm_st6_variante.mdl", 
    ["3rd Commando Company | KSK"] ="models/player/custom_player/legacy/ctm_st6_variantk.mdl",
    ["'The Doctor' Romanov | Sabre"] ="models/player/custom_player/legacy/tm_balkan_varianth.mdl", 
    ["Michael Syfers  | FBI Sniper"]= "models/player/custom_player/legacy/ctm_fbi_varianth.mdl", 
    ["Markus Delrow | FBI HRT"] ="models/player/custom_player/legacy/ctm_fbi_variantg.mdl", 
    ["Cmdr. Mae | SWAT"]= "models/player/custom_player/legacy/ctm_swat_variante.mdl", 
    ["1st Lieutenant Farlow | SWAT"]= "models/player/custom_player/legacy/ctm_swat_variantf.mdl", 
    ["John 'Van Healen' Kask | SWAT"] ="models/player/custom_player/legacy/ctm_swat_variantg.mdl", 
    ["Bio-Haz Specialist | SWAT"]= "models/player/custom_player/legacy/ctm_swat_varianth.mdl",
    ["Chem-Haz Specialist | SWAT"]= "models/player/custom_player/legacy/ctm_swat_variantj.mdl", 
    ["Sergeant Bombson | SWAT"]= "models/player/custom_player/legacy/ctm_swat_varianti.mdl", 		
    ["Operator | FBI SWAT"]="models/player/custom_player/legacy/ctm_fbi_variantf.mdl",
    ["Street Soldier | Phoenix"]= "models/player/custom_player/legacy/tm_phoenix_varianti.mdl", 
    ["Slingshot | Phoenix"] ="models/player/custom_player/legacy/tm_phoenix_variantg.mdl", 
    ["Enforcer | Phoenix"]= "models/player/custom_player/legacy/tm_phoenix_variantf.mdl", 
    ["Soldier | Phoenix"] ="models/player/custom_player/legacy/tm_phoenix_varianth.mdl",
    ["The Elite Mr. Muhlik | Elite Crew"]= "models/player/custom_player/legacy/tm_leet_variantf.mdl", 
    ["Prof. Shahmat | Elite Crew"]= "models/player/custom_player/legacy/tm_leet_varianti.mdl",
    ["Osiris | Elite Crew"] ="models/player/custom_player/legacy/tm_leet_varianth.mdl",
    ["Ground Rebel  | Elite Crew"]= "models/player/custom_player/legacy/tm_leet_variantg.mdl",
    ["Special Agent Ava | FBI"]= "models/player/custom_player/legacy/ctm_fbi_variantb.mdl", 
    ["B Squadron Officer | SAS"]= "models/player/custom_player/legacy/ctm_sas_variantf.mdl"
}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local ffi = require("ffi")

ffi.cdef[[
    typedef struct 
    {
    	void*   fnHandle;        
    	char    szName[260];     
    	int     nLoadFlags;      
    	int     nServerCount;    
    	int     type;            
    	int     flags;           
    	float  vecMins[3];       
    	float  vecMaxs[3];       
    	float   radius;          
    	char    pad[0x1C];       
    }model_t;
    
    typedef int(__thiscall* get_model_index_t)(void*, const char*);
    typedef const model_t(__thiscall* find_or_load_model_t)(void*, const char*);
    typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
    typedef void*(__thiscall* find_table_t)(void*, const char*);
    typedef void(__thiscall* set_model_index_t)(void*, int);
    typedef int(__thiscall* precache_model_t)(void*, const char*, bool);
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
]]

local class_ptr = ffi.typeof("void***")

local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(class_ptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

local rawivmodelinfo = client.create_interface("engine.dll", "VModelInfoClient004") or error("VModelInfoClient004 wasnt found", 2)
local ivmodelinfo = ffi.cast(class_ptr, rawivmodelinfo) or error("rawivmodelinfo is nil", 2)
local get_model_index = ffi.cast("get_model_index_t", ivmodelinfo[0][2]) or error("get_model_info is nil", 2)
local find_or_load_model = ffi.cast("find_or_load_model_t", ivmodelinfo[0][39]) or error("find_or_load_model is nil", 2)

local rawnetworkstringtablecontainer = client.create_interface("engine.dll", "VEngineClientStringTable001") or error("VEngineClientStringTable001 wasnt found", 2)
local networkstringtablecontainer = ffi.cast(class_ptr, rawnetworkstringtablecontainer) or error("rawnetworkstringtablecontainer is nil", 2)
local find_table = ffi.cast("find_table_t", networkstringtablecontainer[0][3]) or error("find_table is nil", 2)

local cl_fullupdate = cvar.cl_fullupdate

local model_names = {}
for k,v in pairs(player_models) do
    table.insert(model_names, k)
end

local replace_localplayer_model = ui.new_checkbox("lua", "b", "Replace localplayer model")
local localplayer_model = ui.new_listbox("lua", "b", "\nmodel", model_names)

local function precache_model(modelname)
    local rawprecache_table = find_table(networkstringtablecontainer, "modelprecache") or error("couldnt find modelprecache", 2)
    if rawprecache_table then 
        local precache_table = ffi.cast(class_ptr, rawprecache_table) or error("couldnt cast precache_table", 2)
        if precache_table then 
            local add_string = ffi.cast("add_string_t", precache_table[0][8]) or error("add_string is nil", 2)

            find_or_load_model(ivmodelinfo, modelname)
            local idx = add_string(precache_table, false, modelname, -1, nil)
            if idx == -1 then 
                return false
            end
        end
    end
    return true
end

local function set_model_index(entity, idx)
    local raw_entity = get_client_entity(ientitylist, entity)
    if raw_entity then 
        local gce_entity = ffi.cast(class_ptr, raw_entity)
        local a_set_model_index = ffi.cast("set_model_index_t", gce_entity[0][75])
        if a_set_model_index == nil then 
            error("set_model_index is nil")
        end
        a_set_model_index(gce_entity, idx)
    end
end

local function change_model(ent, model)
    if model:len() > 5 then 
        if precache_model(model) == false then 
            error("invalid model", 2)
        end
        local idx = get_model_index(ivmodelinfo, model)
        if idx == -1 then 
            return
        end
        set_model_index(ent, idx)
    end
end

local update_skins = true
client.set_event_callback("pre_render", function()

    local me = entity.get_local_player()
    if me == nil then return end
	
	if ui.get(replace_localplayer_model) then 
		change_model(me, player_models[model_names[ui.get(localplayer_model) + 1]])
	end


end)