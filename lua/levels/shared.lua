xpForLevel = 100
xpForTKill = 10
xpForInnoKill = 10
xpLossForTK = 0 // Set to anything above 0 to lose XP

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
