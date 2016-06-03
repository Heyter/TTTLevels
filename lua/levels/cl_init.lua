myXP = myXP or 0
myLevel = myLevel or 1
local levelColors = {
	Color(235, 0, 0),
	Color(0, 235, 0),
	Color(0, 0, 235),
	Color(235, 235, 0),
	Color(235, 0, 235),
	Color(0, 235, 235),
	Color(0, 141, 255)
}

net.Receive("PHXP_GetXP", function(len)
		myXP = net.ReadInt(32)
		myLevel = net.ReadInt(32)
end)
net.Receive("PHXP_AddXP", function(len)
		local toadd = net.ReadInt(16)
		addXP(toadd)
end)
local w = ScrW()*.2604167
local h = ScrH()*.037
local y = 50
local a = 255
local addxps = {}
local times = CurTime()
function addXP(amt)
	myXP = myXP + amt
	
	while myXP >= xpForLevel do
		myXP = myXP - xpForLevel
		myLevel = myLevel + 1
		table.insert(addxps, {"Level Up", h+60+(#addxps*18), 255})
	end
	times = CurTime()
	table.insert(addxps, {amt, h+60+(#addxps*18), 255})
end
local function drawAddXP()
	if #addxps > 0 and times+5 > CurTime() then
		local i = 0
		for k,xp in pairs(addxps) do
			if i > 10 then break end 
			draw.SimpleText("+ "..xp[1], "Trebuchet24", 45, xp[2], Color(255,255,255,xp[3]), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			xp[2] = math.Clamp(xp[2] - .10, h+20, 999999)
			xp[3] = math.Clamp(xp[3] - 1.125, 0, 255)
			i = i + 1
		end
	elseif #addxps > 0 and times+5 < CurTime() then
		addxps = {}
	end
end
hook.Add("HUDPaint", "PHXP_PaintXPUpdate", drawAddXP)
local twenty = ScrH()*.019
local twentyfive = ScrH()*.023
local ten = ScrH()*.0093
local function HUDPaint()
	draw.RoundedBox(0, twenty, twenty, w, h, Color(96, 96, 96, 225) )
	draw.RoundedBox(0, twentyfive, twentyfive, w*math.Clamp(myXP/xpForLevel,0,.98), h-ten, levelColors[(myLevel)%(#levelColors-1)] or Color(0,191,255))
	draw.SimpleText("Level: "..myLevel,"Trebuchet24",(w+twentyfive)/2,h,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end
hook.Add("HUDPaint", "PHXP_PaintBar", HUDPaint)
