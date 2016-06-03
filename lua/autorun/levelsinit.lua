if SERVER then
	include('levels/init.lua')
	AddCSLuaFile()
	AddCSLuaFile('levels/shared.lua')
	AddCSLuaFile('levels/cl_init.lua')
end
include('levels/shared.lua')
if CLIENT then
include('levels/cl_init.lua')
end