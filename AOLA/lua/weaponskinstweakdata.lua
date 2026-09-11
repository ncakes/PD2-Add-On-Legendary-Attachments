--Add-on parts use same skin pattern as the real part.
--Just reference, don't bother cloning
Hooks:PostHook(BlackMarketTweakData, "_init_weapon_skins", "AOLA-PostHook-BlackMarketTweakData:_init_weapon_skins", function(self)
	for skin_id, data in pairs(AOLA.legend_data) do
		local skin_part_data = self.weapon_skins[skin_id] and self.weapon_skins[skin_id].parts
		if skin_part_data then
			for real_part_id, _ in pairs(data.parts) do
				local aola_part_id = real_part_id .. AOLA.config.part_suffix
				skin_part_data[aola_part_id] = skin_part_data[real_part_id]
			end
		end
	end
end)
