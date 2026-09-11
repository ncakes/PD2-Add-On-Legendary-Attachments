if _G.AOLA then return end
dofile(ModPath.."lua/ncUtils/init.lua")

_G.AOLA = {}
AOLA.meta = {
	mod_path = ModPath,
	loc_path = ModPath.."loc/",
	language = "en",
	menu_id = "aola_options_menu",
	menu_callback_prefix = "aola",
	menu_file = ModPath.."menu/options.json",
	save_file = SavePath.."aola_settings.json",
}

AOLA.config = {
	part_tag = "is_aola_part",
	part_suffix = "_addon",
}

AOLA.settings = {
	hide_unowned = false,
	legacy_crosskill_fix = false,
	aola_debug = false,
}
AOLA.save_migration = {
	{
		file = SavePath.."aola_settings.txt",
		key_map = {
			aola_hide_unowned = "hide_unowned",
		}
	}
}
ncUtils.Settings:load(AOLA)

AOLA.legend_data = ncUtils.FileIO:load_json(AOLA.meta.mod_path.."data/legend_data.json")

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
				local v = loc:text("bm_legend_part_name_template_"..part_type, {skin = skin_name})
				loc:add_localized_strings({[k] = v.." (AOLA)"})
			end
		end
	end
end)

Hooks:Add("MenuManagerInitialize", "AOLA-Hooks-MenuManagerInitialize", function(menu_manager)
	ncUtils.Menu:register_default_callbacks(AOLA)

	MenuCallbackHandler.aola_callback_back = function(self, item)
		ncUtils.Settings:save(AOLA)
		managers.blackmarket:aola_set_available_parts()
	end

	MenuHelper:LoadFromJsonFile(AOLA.meta.menu_file, AOLA, AOLA.settings)
end)
