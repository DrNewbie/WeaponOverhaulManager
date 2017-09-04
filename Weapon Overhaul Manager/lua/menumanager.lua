if Announcer then
	Announcer:AddHostMod("Weapon Overhaul Manager, (Change my weapon attributes)")
	Announcer:AddClientMod("Weapon Overhaul Manager, (Change my weapon attributes)")
end

if ModCore then
	ModCore:new(ModPath .. "Config.xml", false, true):init_modules()
end