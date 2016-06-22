# TTTLevels
Adds a level system to Trouble in Terrorist Town for Garry's Mod.

##Customization
In the [`shared.lua`](https://github.com/end360/TTTLevels/blob/master/lua/levels/shared.lua) file:

  - `xpForLevel` This is the amount of experience it takes to level up

  - `xpForTKill` This is the amount of experience a traitor gets for a kill
  
  - `xpForInnoKill` This is the amount of experience an innocent gets for a kill

  - `xpLossForTK` This makes players lose experience if they teamkill, set to 0 to disable

```
// Pointshop On Levelup, Remove /* and */ to enable
/*
  pointsForLevelup = 1000
  local function givePointshopReward(ply, lvl)
    if SERVER then
      ply:PS_GivePoints(pointsForLevelup)
    else
      // Do something
    end
end
hook.Add("Levels_LevelUp", "TTTXP_PSReward", givePointshopReward)
*/
```
This allows you to give players points for pointshop when they level. Compatability with Pointshop2 is unknown.
