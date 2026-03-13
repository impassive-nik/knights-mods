local C = require("base")
local T = require("toolbox")
local M = T.Menu

function toolbox_enable (S)
	if not (S.quest == "Heroes" or (S.quest == "custom" and (S.mission == "heroes" or S.mission == "heroespp"))) then
		--S.IsNot("mission", "heroes")
		S.IsNot("mission", "heroespp")
	else
		S.Is("mission", "heroespp")
		S.quest = "Heroes"	
	end
end

function toolbox_disable (S)
	S.IsNot("quest", "Heroes")
	--S.IsNot("mission", "heroes")
	S.IsNot("mission", "heroespp")
end

function game_fakestart()
	mod_enabled = false
	ppenabled = false
	T.Hooks.TryDisable(T.HookType.CREATURE_SQUELCH, "heroes_c_d")
	T.Actions.Disable(T.ActionType.RESPAWN, "Heroes_RF")
	ranks = {}
	--money = {}
end

function game_start()
	mod_enabled = true
	
	C.i_gem = i_old_gem
	
	print("-= Heroic battle begins =-")
	print("")
	
	T.Hooks.Register(T.HookType.CREATURE_SQUELCH, "heroes_c_d" , creature_damage_f)
	
	T.Actions.Disable(T.ActionType.GAME_START, "Heroes_GS")
	T.Actions.Listen(T.ActionType.GAME_START, "Heroes_FGS", game_fakestart)
end

function get_hero(hero)
	for i=1,#heroes do
		if heroes[i][1] == hero then
			return i
		end
	end
	table.insert(heroes, {hero, 0, false, -1, -1})
	return #heroes	
end

function on_gem_pickup()
	if kts.GetNumHeld(cxt.actor, i_revive_gem)==1 then --Didn't he already have a gem?
		local i = get_hero(cxt.originator)
		heroes[i][3] = true
		kts.FlashMessage("heroes.picked_up_reviving_gem")
	else
		kts.Drop(i_revive_gem) --Drop previous gem, pickup a new one
	end
end

function on_gem_drop()
	local actor = cxt.actor
	local origin = cxt.originator
	kts.Delay(10) --if gem drop was not caused by death - we will be able to detect this. Btw, "drop gem" action is now unused, but who knows...
	if kts.IsAlive(actor) then
		local i = get_hero(originator)
		if (heroes[i][3] and kts.GetNumHeld(actor, i_revive_gem)<1) then
			heroes[i][3] = false
		end
	else 
	end
end

function set_barb_gem_at(pos)
	for i=1,#barb_gems do
		if (barb_gems[i][1].x == pos.x and barb_gems[i][1].y == pos.y) then
			if (DEBUG_ENABLED) then
				print("Debug: +1 gem")
			end	
			barb_gems[i][2] = barb_gems[i][2]+1
			return
		end
	end	
	if (DEBUG_ENABLED) then
		print("Debug: placed 1 gem "..pos.x.." "..pos.y)
	end
	table.insert(barb_gems, {pos, 1})
end

function get_barb_gem_at(pos)
	for i=1,#barb_gems do
		if (barb_gems[i][1].x == pos.x and barb_gems[i][1].y == pos.y) then
			if (DEBUG_ENABLED) then
				print("Debug: there are "..barb_gems[i][2].." gems on this tile")
			end
			return barb_gems[i][2]
		end
	end	
	if (DEBUG_ENABLED) then
		print("Debug: there are no gems on this tile")
	end
	return 0
end

function retrieve_barb_gem_from(pos)
	for i=1,#barb_gems do
		if (barb_gems[i][1].x == pos.x and barb_gems[i][1].y == pos.y) then
			local t = barb_gems[i][2]
			barb_gems[i][2] = 0
			if (DEBUG_ENABLED) then
				print("Debug: retrieved "..t.." gems")
			end
			return t
		end
	end	
	if (DEBUG_ENABLED) then
		print("Debug: retrieved a gem")
	end
	return 1
end

function FdX(facing)
	if (facing == "west") then
		return -1
	elseif (facing == "east") then
		return 1
	end
	return 0
end
function FdY(facing)
	if (facing == "south") then
		return 1
	elseif (facing == "north") then
		return -1
	end
	return 0
end

function isBarbBodyHere(pos)
	local tts = kts.GetTiles(pos)
	if tts == nil then
		if (DEBUG_ENABLED) then
			print("Debug: a nil tile tried")
		end
		return false
	end	
	for _i = 1,#tts do
		for _j = 1,#t_dead_barb_g do
			if (tts[_i].table == t_dead_barb_g[_j].table) then
				return true
			end	
		end
	end
	return false
end

function snd_barb()
	kts.PlaySound(cxt.pos, s_barb_ugh, 9000)   
end
