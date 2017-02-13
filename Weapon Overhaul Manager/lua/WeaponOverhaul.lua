_G.WeaponOverhaulManager = _G.WeaponOverhaulManager or {}
WeaponOverhaulManager.ModPath = ModPath

if not tweak_data or not tweak_data.statistics then
	return
end

Hooks:Add("LocalizationManagerPostInit", "WeaponOverhaulManager_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["WeaponOverhaulManager_menu_title"] = "Weapon Overhaul Manager",
		["WeaponOverhaulManager_menu_desc"] = "Easy to create your own balance.",
		["WeaponOverhaulManager_menu_empty_desc"] = "...",
		["WeaponOverhaulManager_Save_button_title"] = "[ Save ]",
		["WeaponOverhaulManager_Save_button_SAVED_decs"] = "All data is saved",
		["WeaponOverhaulManager_menu.states.timers.reload_not_empty.title"] = "timers.reload_not_empty",
		["WeaponOverhaulManager_menu.states.timers.reload_empty.title"] = "timers.reload_empty",
		["WeaponOverhaulManager_menu.states.timers.unequip.title"] = "timers.unequip",
		["WeaponOverhaulManager_menu.states.timers.equip.title"] = "timers.equip",
		["WeaponOverhaulManager_menu.states.DAMAGE.title"] = "DAMAGE",
		["WeaponOverhaulManager_menu.states.CLIP_AMMO_MAX.title"] = "CLIP_AMMO_MAX",
		["WeaponOverhaulManager_menu.states.AMMO_MAX.title"] = "AMMO_MAX",
		["WeaponOverhaulManager_menu.states.NR_CLIPS_MAX.title"] = "NR_CLIPS_MAX",
		["WeaponOverhaulManager_menu.states.AMMO_PICKUP.1.title"] = "AMMO_PICKUP_LOW",
		["WeaponOverhaulManager_menu.states.AMMO_PICKUP.2.title"] = "AMMO_PICKUP_HIGH",
		["WeaponOverhaulManager_menu.states.stats.damage.title"] = "stats.damage",
		["WeaponOverhaulManager_menu.states.stats.spread.title"] = "stats.spread",
		["WeaponOverhaulManager_menu.states.stats.recoil.title"] = "stats.recoil",
		["WeaponOverhaulManager_menu.states.stats.spread_moving.title"] = "stats.spread_moving",
		["WeaponOverhaulManager_menu.states.stats.zoom.title"] = "stats.zoom",
		["WeaponOverhaulManager_menu.states.stats.concealment.title"] = "stats.concealment",
		["WeaponOverhaulManager_menu.states.stats.suppression.title"] = "stats.suppression",
		["WeaponOverhaulManager_menu.states.stats.alert_size.title"] = "stats.alert_size",
		["WeaponOverhaulManager_menu.states.stats.extra_ammo.title"] = "stats.extra_ammo",
		["WeaponOverhaulManager_menu.states.stats.total_ammo_mod.title"] = "stats.total_ammo_mod",
		["WeaponOverhaulManager_menu.states.stats.value.title"] = "stats.value",
		["WeaponOverhaulManager_menu.states.stats_modifiers.damage.title"] = "stats_modifiers.damage",
		["WeaponOverhaulManager_menu.states.stats_modifiers.spread.title"] = "stats_modifiers.spread",
		["WeaponOverhaulManager_menu.states.stats_modifiers.recoil.title"] = "stats_modifiers.recoil",
		["WeaponOverhaulManager_menu.states.stats_modifiers.spread_moving.title"] = "stats_modifiers.spread_moving",
		["WeaponOverhaulManager_menu.states.stats_modifiers.zoom.title"] = "stats_modifiers.zoom",
		["WeaponOverhaulManager_menu.states.stats_modifiers.concealment.title"] = "stats_modifiers.concealment",
		["WeaponOverhaulManager_menu.states.stats_modifiers.suppression.title"] = "stats_modifiers.suppression",
		["WeaponOverhaulManager_menu.states.stats_modifiers.alert_size.title"] = "stats_modifiers.alert_size",
		["WeaponOverhaulManager_menu.states.stats_modifiers.extra_ammo.title"] = "stats_modifiers.extra_ammo",
		["WeaponOverhaulManager_menu.states.stats_modifiers.total_ammo_mod.title"] = "stats_modifiers.total_ammo_mod",
		["WeaponOverhaulManager_menu.states.stats_modifiers.value.title"] = "stats_modifiers.value" 
	})
end )

WeaponOverhaulManager.Main_Options_Menu = "WeaponOverhaulManager_Main_Options_Menu"

local _commom_var = {
	huge = {min = 0, max = 999, step = 1},
	tiny = {min = 0.01, max = 999, step = 0.01},
	tinytiny = {min = 0.01, max = 99, step = 0.01}
}
WeaponOverhaulManager.States_Setting = {
	timers = {
		reload_not_empty = _commom_var.tinytiny,
		reload_empty = _commom_var.tinytiny,
		unequip = _commom_var.tinytiny,
		equip = _commom_var.tinytiny
	},
	DAMAGE = _commom_var.huge,
	CLIP_AMMO_MAX = _commom_var.huge,
	NR_CLIPS_MAX = _commom_var.huge,
	AMMO_MAX = _commom_var.huge,
	AMMO_PICKUP = {_commom_var.tiny, _commom_var.tiny},
	stats = {
		damage = _commom_var.huge,
		spread = _commom_var.huge,
		recoil = _commom_var.huge,
		spread_moving = _commom_var.huge,
		zoom = _commom_var.huge,
		concealment = _commom_var.huge,
		suppression = _commom_var.huge,
		alert_size = _commom_var.huge,
		extra_ammo = _commom_var.huge,
		total_ammo_mod = _commom_var.huge,
		value = _commom_var.huge
	},
	stats_modifiers = {
		damage = _commom_var.huge,
		spread = _commom_var.huge,
		recoil = _commom_var.huge,
		spread_moving = _commom_var.huge,
		zoom = _commom_var.huge,
		concealment = _commom_var.huge,
		suppression = _commom_var.huge,
		alert_size = _commom_var.huge,
		extra_ammo = _commom_var.huge,
		total_ammo_mod = _commom_var.huge,
		value = _commom_var.huge
	}
}
_commom_var = {}

WeaponOverhaulManager.Directory = WeaponOverhaulManager.ModPath .. "tweakdata/"
WeaponOverhaulManager.Settings = WeaponOverhaulManager.Settings or {}

local _, _, _, weapon_list, _, _, _, _, _ = tweak_data.statistics:statistics_table()
if weapon_list and type(weapon_list) == "table" and #weapon_list > 0 then
	WeaponOverhaulManager.All_Weapon = weapon_list
end
weapon_list = nil

function WeaponOverhaulManager:Save_Data()
	for weapon_name, weapon_data in pairs(self.Settings) do
		local file = io.open(self.Directory .. weapon_name .. ".txt", "w+")
		if file then
			local new_weapon_data = {}
			new_weapon_data[weapon_name] = weapon_data
			file:write(json.encode({weaponfactorytweakdata = {0}, weapontweakdata = new_weapon_data}))
			file:close()
		end
	end
	self:Load_Data()
end

function WeaponOverhaulManager:Load_Data()
	self:Load_Function(tweak_data.weapon, 1)
	self:Load_Function(tweak_data.weapon.factory, 2)
end

function WeaponOverhaulManager:datasplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

Hooks:Add("MenuManagerSetupCustomMenus", "WeaponOverhaulManagerOptionsSetup", function(...)
	MenuHelper:NewMenu(WeaponOverhaulManager.Main_Options_Menu)
	for _, weapon_name in pairs(WeaponOverhaulManager.All_Weapon) do
		if tweak_data.weapon[weapon_name] and tweak_data.weapon[weapon_name].name_id then
			MenuHelper:NewMenu("WeaponOverhaulManager_".. weapon_name .."_Options_Menu")
		end
	end
end )

Hooks:Add("MenuManagerBuildCustomMenus", "WeaponOverhaulManagerOptionsBuild", function(menu_manager, nodes)
	nodes[WeaponOverhaulManager.Main_Options_Menu] = MenuHelper:BuildMenu(WeaponOverhaulManager.Main_Options_Menu)
	MenuHelper:AddMenuItem(MenuHelper.menus.lua_mod_options_menu, WeaponOverhaulManager.Main_Options_Menu, "WeaponOverhaulManager_menu_title", "WeaponOverhaulManager_menu_desc")
	for _, weapon_name in pairs(WeaponOverhaulManager.All_Weapon) do
		if tweak_data.weapon[weapon_name] and tweak_data.weapon[weapon_name].name_id then
			local _new = "WeaponOverhaulManager_".. weapon_name .."_Options_Menu"
			nodes[_new] = MenuHelper:BuildMenu(_new)
			MenuHelper:AddMenuItem(nodes[WeaponOverhaulManager.Main_Options_Menu], _new, tweak_data.weapon[weapon_name].name_id, "WeaponOverhaulManager_menu_empty_desc")
		end
	end
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "WeaponOverhaulManagerOptionsPopulate", function(...)
	local _setting = WeaponOverhaulManager.States_Setting or {}
	for _, weapon_name in pairs(WeaponOverhaulManager.All_Weapon) do
		if tweak_data.weapon[weapon_name] and tweak_data.weapon[weapon_name].name_id then
			MenuCallbackHandler["WeaponOverhaulManager_Save_button_callback"] = function(self, item)
				WeaponOverhaulManager:Save_Data()
				QuickMenu:new(managers.localization:text("WeaponOverhaulManager_menu_title"), managers.localization:text("WeaponOverhaulManager_Save_button_SAVED_decs"), {}):Show()
			end
			MenuHelper:AddButton({
				id = "WeaponOverhaulManager_Save_button_callback",
				title = "WeaponOverhaulManager_Save_button_title",
				desc = "WeaponOverhaulManager_menu_empty_desc",
				callback = "WeaponOverhaulManager_Save_button_callback",
				menu_id = "WeaponOverhaulManager_".. weapon_name .."_Options_Menu"
			})
			local _stats_modifiers = tweak_data.weapon[weapon_name].stats_modifiers or {}
			for _tmp_v, _tmp_k in pairs(_setting.stats_modifiers) do
				_stats_modifiers[_tmp_v] = _stats_modifiers[_tmp_v] or 1		
			end
			tweak_data.weapon[weapon_name].stats_modifiers = _stats_modifiers
			for _state_name, _state_data in pairs(tweak_data.weapon[weapon_name]) do
				if _setting[_state_name] then
					local _insert_menu = {}
					local _value = -9999
					local _title_state_name = ""
					if type(_state_data) == "table" then
						_insert_menu = _state_data
						for _name, _data in pairs(_state_data) do
							if _setting[_state_name][_name] then
								_value = WeaponOverhaulManager.Settings[weapon_name] and WeaponOverhaulManager.Settings[weapon_name][_state_name][_name] or tweak_data.weapon[weapon_name][_state_name][_name]
								_title_state_name = _name
								local _priority = weapon_name .. "..." .. _state_name .. "..." .. _name
								local _callback_name = "WeaponOverhaulManager0callback___" .. _priority
								MenuCallbackHandler[_callback_name] = function(self, item)
									local _data = WeaponOverhaulManager:datasplit(tostring(item._priority), "...")
									local _weapon_name = _data[1] or ""
									local _state_name = _data[2] or ""
									local _name = _data[3] or ""
									if _weapon_name ~= "" and tweak_data.weapon[_weapon_name] then
										WeaponOverhaulManager.Settings[_weapon_name] = WeaponOverhaulManager.Settings[_weapon_name] or {}
										WeaponOverhaulManager.Settings[_weapon_name][_state_name] = WeaponOverhaulManager.Settings[_weapon_name][_state_name] or {}
										WeaponOverhaulManager.Settings[_weapon_name][_state_name][_name] = WeaponOverhaulManager.Settings[_weapon_name][_state_name][_name] or 0
										WeaponOverhaulManager.Settings[_weapon_name][_state_name][_name] = item:value()
									end
								end
								local _loc = tostring("WeaponOverhaulManager_menu.states.".. _state_name .. "." .. _name .. ".title")
								MenuHelper:AddSlider({
									id = _callback_name,
									title = _loc,
									desc = _loc,
									callback = _callback_name,
									value = _value,
									min = _setting[_state_name][_name].min,
									max = _setting[_state_name][_name].max,
									step = _setting[_state_name][_name].step,
									show_value = true,
									menu_id = "WeaponOverhaulManager_".. weapon_name .."_Options_Menu",
									priority = _priority
								})
							end
						end
					else
						local _priority = weapon_name .. "..." .. _state_name
						local _callback_name = "WeaponOverhaulManager0callback__" .. _priority
						_value = WeaponOverhaulManager.Settings[weapon_name] and WeaponOverhaulManager.Settings[weapon_name][_state_name] or tweak_data.weapon[weapon_name][_state_name]
						MenuCallbackHandler[_callback_name] = function(self, item)
							local _data = WeaponOverhaulManager:datasplit(tostring(item._priority), "...")
							local _weapon_name = _data[1] or ""
							local _state_name = _data[2] or ""
							if _weapon_name ~= "" and tweak_data.weapon[_weapon_name] then
								WeaponOverhaulManager.Settings[_weapon_name] = WeaponOverhaulManager.Settings[_weapon_name] or {}
								WeaponOverhaulManager.Settings[_weapon_name][_state_name] = WeaponOverhaulManager.Settings[_weapon_name][_state_name] or {}
								WeaponOverhaulManager.Settings[_weapon_name][_state_name] = item:value()
							end
						end
						local _loc = tostring("WeaponOverhaulManager_menu.states.".. _state_name .. ".title")
						MenuHelper:AddSlider({
							id = _callback_name,
							title = _loc,
							desc = _loc,
							callback = _callback_name,
							value = _value,
							min = _setting[_state_name].min,
							max = _setting[_state_name].max,
							step = _setting[_state_name].step,
							show_value = true,
							menu_id = "WeaponOverhaulManager_".. weapon_name .."_Options_Menu",
							priority = _priority
						})
					end
				end
			end
		end
	end
end )

function WeaponOverhaulManager:Load_Function(_ww, _type)
	local _files = file.GetFiles(self.Directory) or {}
	for _, file_name in pairs(_files) do
		local _file = io.open(self.Directory .. file_name, "r")
		local _data = {}
		if _file then
			_data = json.decode(_file:read("*all"))
			_file:close()
			_data = _type == 1 and _data.weapontweakdata or _data.weaponfactorytweakdata
			if _data then
				for name, settings in pairs(_data) do
					if _ww[name] then
						for var_name, var_data in pairs(settings) do
							if type(var_data) == "table" then
								for var_name2, var_data2 in pairs(var_data) do
									if type(var_data2) == "table" then
										for var_name3, var_data3 in pairs(var_data2) do
											_ww[name][var_name] = _ww[name][var_name] or {}
											_ww[name][var_name][var_name2] = _ww[name][var_name][var_name2] or {}
											_ww[name][var_name][var_name2][var_name3] = var_data2
										end
									else
										_ww[name][var_name] = _ww[name][var_name] or {}
										_ww[name][var_name][var_name2] = var_data2
									end
								end
							else
								_ww[name][var_name] = var_data
							end
						end
					end
				end
			end
		end
	end
end

WeaponOverhaulManager:Load_Data()