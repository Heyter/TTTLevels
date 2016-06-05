if SERVER then
	local version = "1.0"
	include('levels/autoupdate.lua')
	include('levels/init.lua')
	AddCSLuaFile()
	AddCSLuaFile('levels/shared.lua')
	AddCSLuaFile('levels/cl_init.lua')
end
include('levels/shared.lua')
if CLIENT then
include('levels/cl_init.lua')
end
