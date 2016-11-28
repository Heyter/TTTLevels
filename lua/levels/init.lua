local sql = sql
util.AddNetworkString("TTTXP_GetXP")
util.AddNetworkString("TTTXP_AddXP")
local function sqlQuery(q)
	local res = sql.Query(q)
	if res==false then
		error("Failure during SQL Query: "..sql.LastError())
		return false
	end
	return res
end
if not sql.TableExists("TTTXP") then
	sqlQuery("CREATE TABLE TTTXP ( SteamID TEXT, XP INT, LEVEL INT, Unique(SteamID))")
end
local function createPlayer(steamid)
	sqlQuery("INSERT INTO TTTXP (SteamID, XP, LEVEL) VALUES ('"..steamid.."', 0, 1)")
end
local function sendXP(ply)
	net.Start("TTTXP_GetXP")
		net.WriteInt(getPlayerXP(ply:SteamID()), 32)
		net.WriteInt(getPlayerLevel(ply:SteamID()), 32)
	net.Send(ply)
end
hook.Add("PlayerAuthed", "TTTXP_Auth", function (ply, st, a)
	if sqlQuery("SELECT * FROM TTTXP WHERE SteamID = '"..st.."'") then
		sendXP(ply)
		return
	end
	createPlayer(st)
	sendXP(ply)
end)
local xpUpdateBuffer = {}
local function sendXPUpdate(ply, amt)
	if not amt then return end
	xpUpdateBuffer[ply] = (xpUpdateBuffer[ply] or 0) + amt
end
local function sendXPUpdates()
	for ply,amt in pairs(xpUpdateBuffer) do
		net.Start("TTTXP_AddXP")
			net.WriteInt(amt, 32)
		net.Send(ply)
	end
	xpUpdateBuffer = {}
end
local function tttEndRound(result)
	local winteam = (result==WIN_TRAITOR and ROLE_TRAITOR) or (result == WIN_INNOCENT and ROLE_INNOCENT)
	for _,v in pairs(player.GetHumans()) do
		if not v:Alive() and v:GetRole() != winteam then continue end
		givePlayerXP(v:SteamID(), winteam==ROLE_TRAITOR and xpForTWin or xpForInnoWin)
	end
	sendXPUpdates()
end
hook.Add("TTTEndRound","TTTXP_SendXPUpdates", tttEndRound)
local function checkLevel(steamid)
	local xp = getPlayerXP(steamid) or 0
	if xp >= xpForLevel then
		takePlayerXP(steamid, xpForLevel)
		addPlayerLevel(steamid)
		hook.Run("Levels_LevelUp", player.GetBySteamID(steamid), getPlayerLevel(steamid))
	elseif xp<0 then
		takePlayerLevel(steamid)
	end
end
local function setPlayerXP(steamid, amt)
	local res = sqlQuery("UPDATE TTTXP SET XP="..amt.." WHERE SteamID='"..steamid.."'")
	checkLevel(steamid, amt)
end
local function getPlayerLevel(steamid)
	local res = sqlQuery("SELECT LEVEL FROM TTTXP WHERE SteamID='"..steamid.."'")
	if res == false then
		debugprint("Player didn't exist during getlevel: "..steamid)
		createPlayer(steamid)
		return 1
	end
	return tonumber(res) or 1
end
local function addPlayerLevel(steamid)
	sql.Query("UPDATE TTTXP SET LEVEL="..(getPlayerLevel(steamid)+1).." WHERE SteamID='"..steamid.."'")
end
local function takePlayerLevel(steamid)
	sql.Query("UPDATE TTTXP SET LEVEL="..(getPlayerLevel(steamid)-1).." WHERE SteamID='"..steamid.."'")
end
local function getPlayerXP(steamid)
	local res = sqlQuery("SELECT XP FROM TTTXP WHERE SteamID='"..steamid.."'")
	if res == false then
		local err = sql.LastError()
		if string.find(err, "exist") then
			createPlayer(steamid)
			return sqlQuery("SELECT XP FROM TTTXP WHERE SteamID='"..steamid.."'") or 0
		end
	end
	return tonumber(res) or 0
end
local function givePlayerXP(steamid, amt)
	local xp = getPlayerXP(steamid) or 0
	sendXPUpdate(player.GetBySteamID(steamid), amt)
	setPlayerXP(steamid, xp+amt)
end

local function takePlayerXP(steamid, amt)
	local xp = getPlayerXP( steamid ) or 0
	setPlayerXP( steamid, xp-amt)
end
hook.Add("PlayerDeath", "TTTXP_PlayerDeath", function(vic, inf, att)
	if vic == att then return end
	if att:GetRole() == vic:GetRole() then 
		if xpLossForTK > 0 then
			takePlayerXP(att:SteamID(),xpLossForTK)
		end
	end
	givePlayerXP(att:SteamID(), att:GetRole() == ROLE_TRAITOR and xpForTKill or xpForInnoKill)
end)
