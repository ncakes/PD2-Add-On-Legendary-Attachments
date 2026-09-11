--Refresh parts after Steam inventory update.
Hooks:PostHook(BlackMarketManager, "tradable_update", "AOLA-PostHook-BlackMarketManager:tradable_update", function(self, ...)
	self:aola_set_available_parts()
end)

--Set parts on first load, only happens once.
--Needed because init_finalize gets called before this.
Hooks:PostHook(BlackMarketManager, "load", "AOLA-PostHook-BlackMarketManager:load", function(self, ...)
	self:aola_set_available_parts()
end)

--Set parts on reload. Needed because load is only called once.
Hooks:PostHook(BlackMarketManager, "init_finalize", "AOLA-PostHook-BlackMarketManager:init_finalize", function(self, ...)
	self:aola_set_available_parts()
end)

--Checks which skins are owned and set available legendary parts
function BlackMarketManager:aola_set_available_parts()
	for skin_id, data in pairs(AOLA.legend_data) do
		local has_skin = self:have_inventory_tradable_item("weapon_skins", skin_id) or AOLA.settings.aola_debug
		local show = has_skin or not AOLA.settings.aola_hide_unowned
		for real_part_id, _ in pairs(data.parts) do
			local aola_part_id = real_part_id .. AOLA.config.part_suffix
			local global_value = "normal"
			local category = "weapon_mods"
			self._global.inventory[global_value] = self._global.inventory[global_value] or {}
			self._global.inventory[global_value][category] = self._global.inventory[global_value][category] or {}
			self._global.inventory[global_value][category][aola_part_id] = has_skin and 1 or 0

			tweak_data.weapon.factory.parts[aola_part_id].pcs = show and {} or nil
			tweak_data.weapon.factory.parts[aola_part_id].inaccessible = not show
			tweak_data.blackmarket.weapon_mods[aola_part_id].pcs = show and {} or nil
			tweak_data.blackmarket.weapon_mods[aola_part_id].inaccessible = not show
		end
	end
end
