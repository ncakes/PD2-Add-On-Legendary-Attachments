_G[ModPath] = _G[ModPath] or {}
if _G[ModPath][RequiredScript] then return end
_G[ModPath][RequiredScript] = true

--Clone properties from real legendary part
--Clean unwanted properties from based_on part
Hooks:PostHook(WeaponFactoryTweakData, "init", "AOLA-PostHook-WeaponFactoryTweakData:init", function(self)
	--Copy data from legendary part to add-on part
	local ignore_keys = {
		"based_on",--BeardLib synced part
		"type",--Set in BeardLib
		"name_id",--Automatically set in BeardLib, we will overwrite it
		"texture_bundle_folder",--Set in BeardLib
		"is_a_unlockable",--Set in BeardLib
		"dlc",--Will remove
		"unatainable",--Will remove
		"is_legendary_part",--Set by OSA, not copied
		"has_description",--Set by OSA, will overwrite
		"desc_id",--Set by OSA, will overwrite
		AOLA.config.part_tag,
	}
	for skin_id, data in pairs(AOLA.legend_data) do
		for real_part_id, _ in pairs(data.parts) do
			local aola_part_id = real_part_id .. AOLA.config.part_suffix
			local aola_part_data = self.parts[aola_part_id]
			local real_part_data = self.parts[real_part_id]
			local based_on_data = self.parts[aola_part_data.based_on]

			--Remove stuff that was copied from "based_on" part but isn't in the legendary attachment
			--e.g. prevents Raven's front sight from being moved, might fix some other things
			for k, v in pairs(aola_part_data) do
				if not table.contains(ignore_keys, k) then
					--Key is absent in real part but present in based_on part
					if real_part_data[k] == nil and based_on_data[k] ~= nil then
						aola_part_data[k] = nil
					end
				end
			end

			--Copy properties from real legendary attachment
			--Also copies the Beak Suppressor fix and legend_part_name_type
			for k, v in pairs(real_part_data) do
				if not table.contains(ignore_keys, k) then
					if tostring(type(v)) == "table" then
						aola_part_data[k] = deep_clone(v)
					else
						aola_part_data[k] = v
					end
				end
			end

			--AOLA tracking
			aola_part_data[AOLA.config.part_tag] = true

			--Use original name_id with "_addon" appended.
			--Note: some legendary name_ids are incorrect and need to be fixed before this.
			aola_part_data.name_id = self.parts[real_part_id].name_id .. AOLA.config.part_suffix

			--Add description
			aola_part_data.has_description = true
			aola_part_data.desc_id = "bm_req_legend_owned_" .. skin_id

			--Just in case
			aola_part_data.dlc = nil
			aola_part_data.unatainable = nil
		end
	end

	--Copy AOLA data to extra part.
	for real_part_id, extra_parts in pairs(AOLA.extra_parts) do
		local aola_part_id = real_part_id .. AOLA.config.part_suffix
		for _, weapon_id in ipairs(extra_parts) do
			local extra_part_id = aola_part_id .. "_" .. weapon_id
			local extra_part_data = self.parts[extra_part_id]
			local aola_part_data = self.parts[aola_part_id]
			local based_on_data = self.parts[extra_part_data.based_on]
			for k, v in pairs(extra_part_data) do
				if not table.contains(ignore_keys, k) then
					if aola_part_data[k] == nil and based_on_data[k] ~= nil then
						extra_part_data[k] = nil
					end
				end
			end
			for k, v in pairs(aola_part_data) do
				if not table.contains(ignore_keys, k) then
					if tostring(type(v)) == "table" then
						extra_part_data[k] = deep_clone(v)
					else
						extra_part_data[k] = v
					end
				end
			end
			--Important: set part_tag to false to prevent autoswap by OSA.
			extra_part_data[AOLA.config.part_tag] = false
			extra_part_data.name_id = aola_part_data.name_id
			extra_part_data.has_description = true
			extra_part_data.desc_id = aola_part_data.desc_id
			extra_part_data.dlc = nil
			extra_part_data.unatainable = nil
		end
	end

	local function set_override_unit(part_id, old_unit_part_id, new_unit_part_id)
		self.parts[part_id].override = self.parts[part_id].override or {}
		self.parts[part_id].override[old_unit_part_id] = self.parts[part_id].override[old_unit_part_id] or {}
		self.parts[part_id].override[old_unit_part_id].unit = self.parts[new_unit_part_id].unit
	end

	--IZHMA body fix when using Vlad's Rodina Barrel.
	do
		local part_id = "wpn_fps_ass_74_b_legend_addon_saiga"
		set_override_unit(part_id, "wpn_fps_smg_akmsu_body_lowerreceiver", "wpn_fps_ass_ak_body_lowerreceiver")
	end
	--Krinkov body fix when using Vlad's Rodina Barrel.
	do
		local part_id = "wpn_fps_ass_74_b_legend_addon_akmsu"
		set_override_unit(part_id, "wpn_fps_smg_akmsu_body_lowerreceiver", "wpn_fps_ass_ak_body_lowerreceiver")
	end

	--Iron sights for the Midas Touch Add-On Barrel
	do
		local real_part_id = "wpn_fps_pis_deagle_b_legend"
		local aola_part_id = real_part_id .. AOLA.config.part_suffix
		self.wpn_fps_pis_deagle.adds = self.wpn_fps_pis_deagle.adds or {}
		self.wpn_fps_pis_deagle.adds[aola_part_id] = self.wpn_fps_pis_deagle.adds[real_part_id]
		self.wpn_fps_x_deagle.adds = self.wpn_fps_x_deagle.adds or {}
		self.wpn_fps_x_deagle.adds[aola_part_id] = self.wpn_fps_x_deagle.adds[real_part_id]
	end

	--Legacy ADS stance mod fix for Santa's Slayers Laser when equipped on single Crosskill
	--Modified from stance mod of Angled Sight (wpn_fps_upg_o_45iron) for the Thanatos (wpn_fps_snp_m95)
	do
		local real_part_id = "wpn_fps_pis_1911_fl_legendary"
		local stance_mod = self.parts[real_part_id].stance_mod and self.parts[real_part_id].stance_mod.wpn_fps_pis_1911 or {}
		AOLA._vanilla_stance_mod = deep_clone(stance_mod)
		AOLA._legacy_stance_mod = {
			translation = Vector3(-0.5, 5.8, -22.5),
			rotation = Rotation(0.5, 0, -45)
		}
		AOLA:set_crosskill_stance_mod(self)
	end
end)

if _G.OSA then
	return
end

--Fallback for OSA's legendary attachment fixes.
--Copy directly, do not modify.
--Current version from OSA v5.1.
local OSA = {}
OSA.legend_data = AOLA.legend_data

--Set up legendary parts
Hooks:PostHook(WeaponFactoryTweakData, "_init_legendary", "OSA-PostHook-WeaponFactoryTweakData:_init_legendary", function(self)
	--Fix Astatoz legendary foregrip type
	self.parts.wpn_fps_ass_m16_fg_legend.type = "foregrip"

	--Fix incorrect name_id, needed for localization
	self.parts.wpn_fps_pis_deagle_b_legend.name_id = "bm_wp_deagle_b_legend"
	self.parts.wpn_fps_fla_mk2_body_fierybeast.name_id = "bm_wp_fla_mk2_body_fierybeast"
	self.parts.wpn_fps_rpg7_m_grinclown.name_id = "bm_wp_rpg7_m_grinclown"
	self.parts.wpn_fps_shot_r870_s_legendary.name_id = "bm_wp_r870_s_legend"
	self.parts.wpn_fps_shot_r870_fg_legendary.name_id = "bm_wp_r870_fg_legend"
	self.parts.wpn_fps_snp_model70_b_legend.name_id = "bm_wp_model70_b_legend"
	self.parts.wpn_fps_snp_model70_s_legend.name_id = "bm_wp_model70_s_legend"

	for skin_id, data in pairs(OSA.legend_data) do
		for part_id, _ in pairs(data.parts) do
			--OSA tracking
			self.parts[part_id].is_legendary_part = true

			--Set unlockable so it can't be dropped/bought
			self.parts[part_id].is_a_unlockable = true

			--Add description
			self.parts[part_id].has_description = true
			self.parts[part_id].desc_id = "bm_req_legend_equipped_" .. skin_id

			--Set sub_type to "laser" so the color can be changed
			--Raven's barrel sub_type is "silencer" which is wrong, but it has a gadget so that gets overwritten here
			if self.parts[part_id].perks then
				if table.contains(self.parts[part_id].perks, "gadget") then
					self.parts[part_id].sub_type = "laser"
				end
			end
		end
	end
end)

--Set some adds/forbids to prevent legendary attachment clipping.
--Do not add or delete legendary mods from uses_parts, can cause sync issues/cheater tags.
Hooks:PreHook(WeaponFactoryTweakData, "_set_inaccessibles", "OSA-PreHook-WeaponFactoryTweakData:_set_inaccessibles", function(self)
	local function override_unit(part_id, change_part_id, unit)
		if not DB:has(Idstring("unit"), unit) then
			log("[OSA/AOLA] DB missing unit: " .. unit)
			return
		end

		if self.parts[part_id] then
			self.parts[part_id].override = self.parts[part_id].override or {}
			self.parts[part_id].override[change_part_id] = self.parts[part_id].override[change_part_id] or {}
			self.parts[part_id].override[change_part_id].unit = unit
		end
	end

	local function hide_part(part_id, hide_part_id)
		local unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy"
		override_unit(part_id, hide_part_id, unit)
	end

	--Safely add a value to the table of a part_id. Creates the table if it does not exist.
	--Does nothing if value==part_id or if the value is already in the table.
	local function wftd_safe_add_value(part_id, table_name, value)
		if value ~= part_id and self.parts[part_id] then
			self.parts[part_id][table_name] = self.parts[part_id][table_name] or {}
			if not table.contains(self.parts[part_id][table_name], value) then
				table.insert(self.parts[part_id][table_name], value)
			end
		end
	end

	--Big Kahuna. Legendary stock hides default grip.
	hide_part("wpn_fps_shot_r870_s_legendary", "wpn_fps_upg_m4_g_standard")

	--Demon. Legendary stock hides default grip.
	hide_part("wpn_fps_shot_shorty_s_legendary", "wpn_fps_upg_m4_g_standard")

	--Mars Ultor. Legendary barrel hides default barrel extension.
	hide_part("wpn_fps_ass_tecci_b_legend", "wpn_fps_ass_tecci_ns_standard")

	--Vlad's Rodina. Legendary stock adds default grip. Legendary grip forbids default grip
	wftd_safe_add_value("wpn_upg_ak_s_legend", "adds", "wpn_upg_ak_g_standard")
	wftd_safe_add_value("wpn_upg_ak_g_legend", "forbids", "wpn_upg_ak_g_standard")
	--Legendary grip forbids Wooden Sniper Stock
	wftd_safe_add_value("wpn_upg_ak_g_legend", "forbids", "wpn_upg_ak_s_psl")

	--Raven Admiral. Legendary barrel adds standard foregrip and forbids short foregrip.
	--Otherwise the foregrip disappears if you use the Short Barrel then switch to the Admiral Barrel.
	wftd_safe_add_value("wpn_fps_sho_ksg_b_legendary", "adds", "wpn_fps_sho_ksg_fg_standard")
	wftd_safe_add_value("wpn_fps_sho_ksg_b_legendary", "forbids", "wpn_fps_sho_ksg_fg_short")

	--Iron sights for the Midas Touch Barrel on the Akimbo Deagle.
	do
		self.wpn_fps_x_deagle.adds = self.wpn_fps_x_deagle.adds or {}
		self.wpn_fps_x_deagle.adds.wpn_fps_pis_deagle_b_legend = {
			"wpn_fps_pis_deagle_o_standard_rear",
			"wpn_fps_pis_deagle_o_standard_front",
		}
	end

	--Fix the misaligned barrel extension on the Anarcho Barrel (thanks AkiraDragunDaishiyu)
	self.parts.wpn_fps_pis_judge_b_legend.override = self.parts.wpn_fps_pis_judge_b_legend.override or {}
	for _, part_id in ipairs(self.wpn_fps_pis_judge.uses_parts) do
		if self.parts[part_id] and self.parts[part_id].type == "barrel_ext" then
			self.parts.wpn_fps_pis_judge_b_legend.override[part_id] = {
				parent = "barrel",
			}
		end
	end

	--Allow equipping suppressors with the Demon Barrel
	--Previously possible but was removed in U242.1
	self.parts.wpn_fps_shot_shorty_b_legendary.forbids = nil

	--Allow equipping Iron Sight with the Don Pastrami Barrel
	--Previously possible but was removed in U242
	self.parts.wpn_fps_snp_model70_b_legend.forbids = nil

	if _G.BeardLib then
		do
			--Alamo Dallas "hide" default barrel.
			--Can't use standard dummy because it messes up the barrel extensions.
			local unit = "units/aola/weapons/wpn_fps_smg_p90_pts/wpn_fps_smg_p90_b_short_dallas"
			override_unit("wpn_fps_smg_p90_b_legend", "wpn_fps_smg_p90_b_short", unit
			)
		end
		do
			--Don Pastrami suppressor fix
			local unit = "units/aola/weapons/wpn_fps_snp_model70_pts/wpn_fps_snp_model70_ns_suppressor_baaah"
			override_unit("wpn_fps_snp_model70_b_legend", "wpn_fps_snp_model70_ns_suppressor", unit)
		end
	end
end)
