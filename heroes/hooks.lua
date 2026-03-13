local C = require("base")
local T = require("toolbox")
local M = T.Menu

local mod_enabled = false

local heroes = {} --List of all knights with parameters
local deaths = false --Did the game already started?
local barb_gems = {}



--MAIN FUNCTION

local function game_start()
	C.i_gem = i_old_gem
end
T.Actions.Listen(T.ActionType.GAME_START, "Heroes_GS", game_start)

function start_heroes()
	mod_enabled = true
	
	C.add_segment(barbaric_room)	
	T.Hooks.Register(T.HookType.CREATURE_SQUELCH, "heroes_c_d" , creature_damage_f)
	
	kts.AddHint("Pick up 6 barbaric gems from dead barbarians", 1, 1)
	
	kts.SetRespawnFunction(respawn_func) --my respawn function
	
	C.i_gem = i_revive_gem --replace old gems with reviving ones
	i_revive_gem.on_pick_up = on_gem_pickup --call functions on events
	i_revive_gem.on_drop = on_gem_drop
	
	i_barbaric_gem.on_pick_up = f_barb_gem
	
	
	heroes = {} --restart settings
	barb_gems = {}
	deaths = false
	C.add_initial_monsters(m_barbarian, 12)
	local p_list = kts.GetAllPlayers()
	for i=1,#p_list do
		table.insert(heroes, {p_list[i], 0, false, -1})-- 1:player link; 2:barbaric gems; 3:have a reviving gem?; 4:Respawns
	end
end


-- Other functions
function get_hero(hero)
	for i=1,#heroes do
		if heroes[i][1] == hero then
			return i
		end
	end
	table.insert(heroes, {hero, 0, false, -1})
	return #heroes	
end

function set_barb_gem_at(pos)
	for i=1,#barb_gems do
		if (barb_gems[i][1].x == pos.x and barb_gems[i][1].y == pos.y) then
			barb_gems[i][2] = barb_gems[i][2]+1
			return
		end
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

function creature_damage_f()
	if not mod_enabled then
		Tools.DeleteHook("CREATURE_SQUELCH", "heroes_c_d")
	else
		if not kts.IsKnight(cxt.actor) then
			local c = kts.GetMonsterCount(m_barbarian)
			local pos = {x=cxt.pos.x, y=cxt.pos.y}
			kts.Delay(10)
			if (not kts.IsAlive(cxt.actor)) and (c-kts.GetMonsterCount(m_barbarian)>=1) then
				set_barb_gem_at(pos)
				--if not kts.PlaceItem(cxt.pos, i_barbaric_gem) then
					--kts.AddMonsters(m_barbarian, 1)
				--end
			end
		end
	end
	if old_creature_damage then
      old_creature_damage()
   end
end


function on_gem_pickup()
	if kts.GetNumHeld(cxt.actor, i_revive_gem)==1 then --Didn't he already have a gem?
		local i = get_hero(cxt.originator)
		heroes[i][3] = true
		local count = get_barb_gem_at(cxt.pos)
		local p_rank = ranks[pname].money
		ranks[cxt.actor].money = ranks[cxt.actor].money + MONEY_PER_GEM
		kts.FlashMessage("heroes.picked_up_reviving_gem")
	else
		kts.Drop(i_revive_gem) --Drop previous gem, pickup a new one
	end
end
function on_gem_drop()
	kts.Delay(10) --if gem drop was not caused by death - we will be able to detect this. Btw, "drop gem" action is now unused, but who knows...
	if kts.IsAlive(cxt.actor) then
		local i = get_hero(cxt.originator)
		if (heroes[i][3] and kts.GetNumHeld(cxt.actor, i_revive_gem)<1) then
			heroes[i][3] = false
		end
	else 
	end
end

function respawn_func(player)
	if mod_enabled then
	  local i = get_hero(player)
	    if (heroes[i][4]==-1) then
			--first appear of the player.
			--Should we do something?
		elseif (heroes[i][3]) then
			heroes[i][3] = false
			print("Player "..get_hero(player).." revived!") --Do nothing
		else
			kts.EliminatePlayer(player)
		end
		heroes[i][4] = heroes[i][4]+1
	end	
	return nil
end