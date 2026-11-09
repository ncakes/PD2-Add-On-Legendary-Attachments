if _G.AOLA then return end

---@class AOLA
_G.AOLA = {}
AOLA.meta = {
	mod_path = ModPath,
	loc_path = ModPath .. "loc/",
	language = "en",
	menu_id = "aola_options_menu",
	menu_callback_prefix = "aola",
	save_file = SavePath .. "aola_settings.json",
}

AOLA.config = {
	part_tag = "is_aola_part",
	part_suffix = "_addon",
}

AOLA.settings = {
	hide_unowned = false,
	extended_attachments = true,
	legacy_crosskill_fix = false,
	aola_debug = false,
}
AOLA.save_migration = {
	{
		file = SavePath .. "aola_settings.txt",
		key_map = {
			aola_hide_unowned = "hide_unowned",
		}
	}
}
ncUtils.Settings:load(AOLA)

AOLA.legend_data = ncUtils.FileIO:load_json(AOLA.meta.mod_path .. "data/legend_data.json")
AOLA.extra_parts = ncUtils.FileIO:load_json(AOLA.meta.mod_path .. "data/extra_parts.json")

--Menu hooks
Hooks:Add("LocalizationManagerPostInit", "AOLA-Hooks-LocalizationManagerPostInit", function(loc)
	ncUtils.Localization:load(loc, AOLA)

	--Generate localizations for part names and "requires ownership" description
	local ptd = tweak_data and tweak_data.weapon and tweak_data.weapon.factory and tweak_data.weapon.factory.parts
	for skin_id, skin_data in pairs(AOLA.legend_data) do
		--Hardcode skin name, game doesn't localize it anyways
		local skin_name = skin_data.name

		--"Requires ownership" description
		do
			local k = "bm_req_legend_owned_" .. skin_id
			local v = loc:text("bm_req_legend_owned_template", {skin = skin_name})
			loc:add_localized_strings({[k] = v})
		end

		--Part names
		for real_part_id, fallback_part_type in pairs(skin_data.parts) do
			local aola_part_id = real_part_id .. AOLA.config.part_suffix
			local k = ptd and ptd[aola_part_id] and ptd[aola_part_id].name_id
			if k then
				local part_type = ptd[aola_part_id].legend_part_name_type or fallback_part_type
				local v = loc:text("bm_legend_part_name_template_" .. part_type, {skin = skin_name})
				loc:add_localized_strings({[k] = v .. " (AOLA)"})
			end
		end
	end
end)

Hooks:Add("MenuManagerInitialize", "AOLA-Hooks-MenuManagerInitialize", function(menu_manager)
	ncUtils.Menu:register_default_callbacks(AOLA)

	MenuCallbackHandler.aola_callback_back = function(self, item)
		ncUtils.Settings:save(AOLA)
		managers.blackmarket:aola_set_available_parts()
		AOLA:set_crosskill_stance_mod()
	end

	Hooks:Add("MenuManagerBuildCustomMenus", "AOLA-Hooks-MenuManagerBuildCustomMenus", function(menu_manager, nodes)
		if menu_manager._is_start_menu then
			AOLA:register_dl_button()
		end
	end)

	MenuHelper:LoadFromJsonFile(
		AOLA.meta.mod_path .. "menu/options.json",
		AOLA,
		AOLA.settings
	)
end)

function AOLA:register_dl_button()
	local mod_folder = "Legendary Stat Customizer"
	if _G.LegendStats ~= nil or ncUtils.FileIO:path_exists("mods/" .. mod_folder) then
		return
	end

	MenuHelper:AddDivider({
		id = "download_buttons_divider",
		size = 16,
		menu_id = "aola_options_menu",
		priority = -1,
	})

	MenuHelper:AddButton({
		id = "dl_lsc_button",
		title = "aola_dl_lsc_button_title",
		desc = "aola_dl_lsc_button_desc",
		callback = "aola_callback_button",
		menu_id = "aola_options_menu",
		priority = -2,
		disabled = false,
	})
end

function AOLA:dl_lsc_button_callback()
	local menu_title = managers.localization:text("aola_dialog_title")
	local menu_message = managers.localization:text("aola_dialog_install_lsc")
	local menu_options = {
		{
			text = managers.localization:text("aola_dialog_add_to_download_manager"),
			callback = function()
				local mod_folder = "Legendary Stat Customizer"
				local manifest_path = self.meta.mod_path .. "data/LSC.txt"
				local done_cb = function()
					managers.menu:open_node("blt_download_manager")
				end
				ncUtils.Bootstrap:blt_mod(mod_folder, manifest_path, done_cb)
				ncUtils.Menu:disable_item("dl_lsc_button", self)
			end,
		},
		{
			text = managers.localization:text("dialog_cancel"),
			is_focused_button = true,
			is_cancel_button = true,
		}
	}
	QuickMenu:new(menu_title, menu_message, menu_options):show()
end

function AOLA:set_crosskill_stance_mod(weapon_factory)
	weapon_factory = weapon_factory or tweak_data and tweak_data.weapon and tweak_data.weapon.factory

	local wfptd = weapon_factory and weapon_factory.parts
	if wfptd and self._vanilla_stance_mod and self._legacy_stance_mod then
		local stance_mod = self.settings.legacy_crosskill_fix and self._legacy_stance_mod or self._vanilla_stance_mod

		local real_part_id = "wpn_fps_pis_1911_fl_legendary"
		wfptd[real_part_id].stance_mod = wfptd[real_part_id].stance_mod or {}
		wfptd[real_part_id].stance_mod.wpn_fps_pis_1911 = stance_mod

		local aola_part_id = real_part_id .. AOLA.config.part_suffix
		wfptd[aola_part_id].stance_mod = wfptd[aola_part_id].stance_mod or {}
		wfptd[aola_part_id].stance_mod.wpn_fps_pis_1911 = stance_mod
	end
end
