# Add-On Legendary Attachments

## Overview

Adds a standalone copy of legendary attachments that can be used if you own the corresponding legendary skin. Add-on legendary attachments are synced to peers as a non-legendary vanilla game attachment and will not trigger cheater tags. You can safely use them even if you do not have the legendary skin equipped.

It is recommended to also use [Super Duper Skin Swapper](https://github.com/ncakes/PD2-Super-Duper-Skin-Swapper) **OR** [Optional Skin Attachments](https://github.com/ncakes/PD2-Optional-Skin-Attachments), as either of these mods will prevent clipping on some legendary attachments while also providing better support for skins. Do not install both because they are not compatible with each other.

Peers will see a vanilla game attachment. Typically, this is either a default part or a base game (non-DLC) attachment. There are a few exceptions where a DLC attachment is used, but only if it belongs to the same DLC as the weapon. A full list can be found [here](https://github.com/ncakes/PD2-Add-On-Legendary-Attachments/blob/master/Based-On%20Parts.md).

## Known Issues

The Vlad's Rodina Laser and Santa's Slayers Laser can be seen by other players. However, the integrated laser found on non-gadget legendary attachments cannot be seen by other players. Full list of attachments with lasers that do not sync:
- Admiral Barrel
- Anarcho Barrel
- Apex Barrel
- Astatoz Foregrip
- Demon Barrel
- Mars Ultor Barrel
- Plush Phoenix Barrel

May add the option to hide unowned add-on attachments in the future.

Add-on legendary attachments use a white version of the legendary skin icon. I have no plans to change the icons at this time, mainly because OSA/SDSS use a colored version of the legendary skin icon and this is a nice way to differentiate the add-on attachments while preserving the style. Also because I really can't be bothered to make 40 icons.

## Installation

This mod requires [SuperBLT](https://superblt.znix.xyz) and [BeardLib](https://modworkshop.net/mod/14924).

This mod consists of a BLT part and an asset override part. The asset overrides can be downloaded automatically so you only need to install the BLT part of the mod. Download `Add-On-Legendary-Attachments_<ver>.zip` from the [latest release page](https://github.com/ncakes/PD2-Add-On-Legendary-Attachments/releases/latest) and extract the entire contents to your `mods` folder.

```
C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2\mods
```

You will automatically be prompted to install the assets overrides through SuperBLT's Download Manager when you start the game.

If you run into issues, you can also install the asset overrides manually. Download `Add-On-Legendary-Attachments-Assets_<ver>.zip` from the [latest release page](https://github.com/ncakes/PD2-Add-On-Legendary-Attachments/releases/latest) and extract the entire contents to your `mod_overrides` folder.

```
C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2\assets\mod_overrides
```

## Uninstallation

Before uninstalling, you should remove all add-on legendary parts from your weapons. If you delete the assets folder, the BLT mod will automatically remove the attachments the next time you launch the game. Step by step instructions:

1. Delete the `Add-On Legendary Attachments Assets` folder found here:

```
C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2\assets\mod_overrides\Add-On Legendary Attachments Assets
```

2. Launch the game and the attachments will be removed. Ignore the pop-up asking to download assets.

3. Open your inventory, then go back to the main menu so the game saves.

4. Exit the game. You can now delete the `Add-On Legendary Attachments` BLT mod folder:

```
C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2\mods\Add-On Legendary Attachments
```
