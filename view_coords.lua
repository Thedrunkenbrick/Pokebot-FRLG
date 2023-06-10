dofile ("data\\lua\\Memory.lua")
dofile ("data\\lua\\GameSettings.lua")




GameSettings.initialize()

console.log("Lua Version: ".._VERSION)
package.path = ";.\\data\\lua\\?.lua;"

function getTrainer()
	local trainer = Memory.readdword(GameSettings.trainerpointer)

	trainer = {
		state = Memory.readbyte(GameSettings.trainerpointer + 139),
		mapId = Memory.readbyte(GameSettings.trainerpointer + 2),
		mapBank = Memory.readbyte(GameSettings.mapbank),
		posX = Memory.readbyte(GameSettings.coords + 0) - 7,
		posY = Memory.readbyte(GameSettings.coords + 2) - 7
	}

	return trainer
end

last_posY = 0
last_posX = 0
last_state = 0
last_mapBank = 0
last_mapId = 0
last_PID = 0
last_LVL = 0 

OffSet = 0

mapId = Memory.readbyte(GameSettings.trainerpointer + OffSet)

-- while mapId ~= 2 do
-- 	OffSet = OffSet + 1
-- 	mapId = Memory.readbyte(GameSettings.trainerpointer + OffSet)
	
-- 	if mapId == 2 then
-- 		local f = assert(io.open("quicksave.txt", "w"))
-- 		f:write(OffSet, "\n")
-- 		f:close()
-- 		gui.addmessage("DONE")
-- 	end
-- end



while true do
	trainer = getTrainer()

	opponent = readMonData(GameSettings.estats)



	if (last_state ~= trainer.state) then
		last_state = trainer.state
		gui.addmessage("State: " .. trainer.state)
	end

	if (last_posX ~= trainer.posX) or (last_posY ~= trainer.posY) then
		last_posY = trainer.posY
		last_posX = trainer.posX
		gui.addmessage("X: " .. trainer.posX .. ", Y: " .. trainer.posY)
	end

	if (last_mapBank ~= trainer.mapBank) or (last_mapId ~= trainer.mapId) then
		last_mapBank = trainer.mapBank
		last_mapId = trainer.mapId
		gui.addmessage("Map: " .. trainer.mapBank .. ":" .. trainer.mapId)
	end

	if (last_PID ~= opponent.personality) then
		last_PID = opponent.personality
		gui.addmessage("PID: " .. opponent.personality)
	end

	if (last_LVL ~= opponent.level) then
		last_LVL = opponent.level
		gui.addmessage("LVL: " .. opponent.level)
	end

	emu.frameadvance()
end