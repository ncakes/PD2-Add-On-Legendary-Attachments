--Adapted from OSA 5.0
if not _G.OSA then
	--Set up legendary parts
	Hooks:PostHook(WeaponFactoryTweakData, "_init_legendary", "AOLA-PostHook-WeaponFactoryTweakData:_init_legendary", function(self)
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

		for skin_id, data in pairs(AOLA.legend_data) do
			for part_id, legend_part_name_type in pairs(data.parts) do
				--Used to generate legendary attachment name
				self.parts[part_id].legend_part_name_type = legend_part_name_type

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
	Hooks:PreHook(WeaponFactoryTweakData, "_set_inaccessibles", "AOLA-PreHook-WeaponFactoryTweakData:_set_inaccessibles", function(self)
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

		--Big Kahuna / Demon
		--Default body adds default grip, legendary stock forbids default grip
		wftd_safe_add_value("wpn_fps_shot_r870_body_standard", "adds", "wpn_fps_upg_m4_g_standard")
		wftd_safe_add_value("wpn_fps_shot_r870_s_legendary", "forbids", "wpn_fps_upg_m4_g_standard")
		wftd_safe_add_value("wpn_fps_shot_shorty_s_legendary", "forbids", "wpn_fps_upg_m4_g_standard")
		--Reinfeld and Locomotive grips forbid default grip
		for _, part_id in pairs(self.wpn_fps_shot_r870.uses_parts) do
			if self.parts[part_id] and self.parts[part_id].type == "grip" then
				wftd_safe_add_value(part_id, "forbids", "wpn_fps_upg_m4_g_standard")
			end
		end
		for _, part_id in pairs(self.wpn_fps_shot_serbu.uses_parts) do
			if self.parts[part_id] and self.parts[part_id].type == "grip" then
				wftd_safe_add_value(part_id, "forbids", "wpn_fps_upg_m4_g_standard")
			end
		end

		--Mars Ultor
		--Default lower receiver adds default barrel extension, legendary barrel forbids default barrel extension
		wftd_safe_add_value("wpn_fps_ass_tecci_lower_reciever", "adds", "wpn_fps_ass_tecci_ns_standard")
		wftd_safe_add_value("wpn_fps_ass_tecci_b_legend", "forbids", "wpn_fps_ass_tecci_ns_standard")
		--Bootleg barrel extensions forbid default barrel extension
		for _, part_id in pairs(self.wpn_fps_ass_tecci.uses_parts) do
			if self.parts[part_id] and self.parts[part_id].type == "barrel_ext" then
				wftd_safe_add_value(part_id, "forbids", "wpn_fps_ass_tecci_ns_standard")
			end
		end

		--Vlad's Rodina
		--Legendary stock adds default grip, legendary grip forbids default grip
		wftd_safe_add_value("wpn_upg_ak_s_legend", "adds", "wpn_upg_ak_g_standard")
		wftd_safe_add_value("wpn_upg_ak_g_legend", "forbids", "wpn_upg_ak_g_standard")

		--Raven Admiral
		--Without this, the foregrip will disappear if you apply the Short Barrel then switch to the Admiral Barrel
		wftd_safe_add_value("wpn_fps_sho_ksg_b_legendary", "adds", "wpn_fps_sho_ksg_fg_standard")
		wftd_safe_add_value("wpn_fps_sho_ksg_b_legendary", "forbids", "wpn_fps_sho_ksg_fg_short")

		--Santa's Slayers Laser on single-hand Crosskill
		--Previously only available in AOLA but legendary attachments were added to the single-hand Crosskill in U242
		--Laser blocks all sights except for Marksman Sight to prevent clipping
		local whitelist = {"wpn_upg_o_marksmansight_rear"}
		for _, part_id in pairs(self.wpn_fps_pis_1911.uses_parts) do
			if not table.contains(whitelist, part_id) then
				if self.parts[part_id] and self.parts[part_id].type == "sight" then
					wftd_safe_add_value("wpn_fps_pis_1911_fl_legendary", "forbids", part_id)
				end
			end
		end

		--Allow the Demon Barrel to use suppressors
		--Previously possible but was removed from the game in U242.1
		self.parts.wpn_fps_shot_shorty_b_legendary.forbids = nil

		--Don Pastrami suppressor fix
		self.parts.wpn_fps_snp_model70_b_legend.override = self.parts.wpn_fps_snp_model70_b_legend.override or {}
		self.parts.wpn_fps_snp_model70_b_legend.override.wpn_fps_snp_model70_ns_suppressor = {
			third_unit = self.parts.wpn_fps_snp_model70_ns_suppressor.third_unit,
			unit = "units/aola/weapons/wpn_fps_snp_model70_pts/wpn_fps_snp_model70_ns_suppressor_addon",
		}
	end)
end

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

	--Iron sights for the Midas Touch Add-On Barrel
	do
		local real_part_id = "wpn_fps_pis_deagle_b_legend"
		local aola_part_id = real_part_id .. AOLA.config.part_suffix
		self.wpn_fps_pis_deagle.adds = self.wpn_fps_pis_deagle.adds or {}
		self.wpn_fps_pis_deagle.adds[aola_part_id] = self.wpn_fps_pis_deagle.adds[real_part_id]
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
