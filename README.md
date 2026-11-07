# Add-On Legendary Attachments

## Overview

Adds a standalone copy of legendary attachments that can be used if you own the corresponding legendary skin. Add-on legendary attachments are synced to peers as a non-legendary vanilla game attachment and will not trigger cheater tags. You can safely use them even if you do not have the legendary skin equipped.

Peers will see a vanilla game attachment. This is either a default part or a base game (non-DLC) attachment. A full list can be found [here](https://github.com/ncakes/PD2-Add-On-Legendary-Attachments/blob/master/Based-On%20Parts.md).

## Legendary Attachment Fixes

AOLA includes all of the legendary attachment fixes found in OSA. Thanks to the following people for their contributions:

- Hoppip and Mercu for helping with the Beak Suppressor model fix.
- AkiraDragunDaishiyu for the barrel fixes for the Astatoz, Big Kahuna, and Anarcho.

## Client Detection Risk

In stealth, the host calculates client concealment independently using the parts that the host sees (the synced based-on part). If the synced part has lower concealment, the host calculates you with lower concealment (i.e. higher detection risk, harmful). Conversely, if the synced part has higher concealment, it benefits you. For loud, it doesn't matter because crit chance is handled locally.

Net concealment change seen by the host. Negative is bad, positive is good.

| AOLA Part | Change |
|---|---|
| Astatoz Stock | +6 |
| Don Pastrami Stock | -1 |
| Mars Ultor Barrel | -4 |
| Midas Touch Barrel | +3 |
| Santa's Slayers Laser | -1 |
| Vlad's Rodina Laser | -1 |

## Known Issues

The Vlad's Rodina Laser and Santa's Slayers Laser can be seen by other players. However, the integrated laser found on non-gadget legendary attachments cannot be seen by other players. Full list of attachments with lasers that do not sync:

- Admiral Barrel
- Anarcho Barrel
- Apex Barrel
- Astatoz Foregrip
- Demon Barrel
- Mars Ultor Barrel
- Plush Phoenix Barrel

Add-on legendary attachments use a white version of the legendary skin icon. I have no plans to change the icons at this time, mainly because Optional Skin Attachments use a colored version of the legendary skin icon and this is a nice way to differentiate the add-on attachments while preserving the style. Also because I really can't be bothered to make 40 icons.

## Updating to v2.0+

The AOLA install directory has been moved in v2.0. If you are using AOLA v1.x, you need to uninstall the old version manually before downloading v2.0+.

1. Delete the `Add-On Legendary Attachments` BLT mod folder:

```
C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2\mods\Add-On Legendary Attachments
```

2. Delete the `AOLA Assets` folder:

```
C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2\assets\mod_overrides\AOLA Assets
```

3. Follow the instructions in the next section to install the new version. Future updates can be downloaded in-game via the BeardLib Mods Manager.

## Installation (v2.0+)

This mod requires [SuperBLT](https://superblt.znix.xyz) and [BeardLib](https://modworkshop.net/mod/14924).

Download `Add-On-Legendary-Attachments_<ver>.zip` from the [latest release page](https://github.com/ncakes/PD2-Add-On-Legendary-Attachments/releases/latest) and extract the entire contents to your `mod_overrides` folder.

```
C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2\assets\mod_overrides
```
