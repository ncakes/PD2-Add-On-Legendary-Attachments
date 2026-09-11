# Changelog

## v2.0.1

*2026-09-12 - Update 247.3*

- Fixed a mistake that caused settings not to be applied.
- Toggling the Santa's Slayers legacy viewmodel setting will take effect immediately.

## v2.0

*2026-09-11 - Update 247.3*

- Converted mod to BeardLib. A manual update to v2.0 is required, see README.md for instructions. Future updates will be available through the BeardLib Mods Manager.
- Fixed iron sights on the Midas Touch barrel (thanks MilesFox92).
- Updated Santa's Slayers attachments to use the single-hand weapon icon.
- Santa's Slayers Laser blocks all sights except for the Marksman Sight.
- Santa's Slayers Laser equipped on the single Crosskill uses the new base-game ADS viewmodel.
	- Option available to use the legacy AOLA viewmodel.
- Restored the ability to use any barrel extension on the Demon Barrel (removed from the base game in U242.1).
- Don Pastrami suppressor fix is now always enabled.
- Legendary attachment fixes from Optional Skin Attachments are now natively available in AOLA.
	- AOLA is still compatible with OSA, but these fixes will now be available even if OSA is not installed.
- M308 now shows mini-icons for the upper body and lower body (renamed to upper receiver and lower receiver).
- Localization changes:
	- Alamo Dallas Barrel renamed to Body Kit.
	- Plush Phoenix Upper Body renamed to Upper Receiver.
	- Plush Phoenix Lower Body renamed to Lower Receiver.
	- Reworked localization for suppressed legendary attachment mods.
- Cleanup:
	- Refactor to use shared utilities.

## v1.5

*2021-04-21 - Update 205*

- Edited the ADS viewmodel when using the add-on Santa's Slayers Laser on the single Crosskill to prevent vision from being obscured.
- Add-on Santa's Slayers Laser now blocks all sight attachments except for the Marksman Sight to prevent clipping.
- Added an option for hiding unowned legendary attachments.
- Added an option for disabling the Beak Suppressor fix.
- Added an option for disabling the Crosskill viewmodel change.

## v1.4

*2021-04-15 - Update 205*

- Added an edited Beak Suppressor model that is automatically enabled when using the Don Pastrami Barrel to fix the invisible suppressor glitch.

## v1.3

*2021-04-08 - Update 205*

- Changed some based-on parts to reduce detection risk sync issues:
	- Admiral Barrel now synced as default barrel.
	- Astatoz Barrel now synced as default barrel.
	- Astatoz Foregrip now synced as default foregrip.
	- Mars Ultor Stock now synced as Folding Stock.
	- The Gimp Body Kit now synced as I'll Take Half That Kit.
- Updated localizations for suppressed legendary attachment mods.

## v1.2

*2021-04-08 - Update 205*

- Assets folder has been migrated to `mod_overrides/AOLA Assets`. After updating to v1.2 and restarting your game, the assets folder will be automatically migrated and you will be prompted to restart your game once more. Your currently equipped attachments should not be affected. Please update to v1.2 as soon as possible, because asset downloads through SuperBLT is currently broken because the old file path is too long.

## v1.1

*2020-04-09 - Update 199 Mark II Hotfix 2*

- Fixed a sync issue that could cause peers to crash if add-on barrels were equipped with barrel extensions.

## v1.0

*2020-04-07 - Update 199 Mark II Hotfix 2*

- Initial release.
