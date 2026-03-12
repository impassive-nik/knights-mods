local C = require("base")
local T = require("toolbox")
local M = T.Menu



--MAIN FUNCTION

T.Actions.Listen(T.ActionType.GAME_START, "Heroes_FGS", game_fakestart)


function start_heroes()	
	kts.AddHint("Collect "..BARB_GEMS.." barbaric gems to win", 1, 1)
	
	T.Actions.Listen(T.ActionType.RESPAWN, "Heroes_RF", respawn_func)
	
	C.i_gem = i_revive_gem --replace old gems with reviving ones
	
	heroes = {} --restart settings
	barb_gems = {}
	deaths = false
	local p_list = kts.GetAllPlayers()
	C.add_initial_monsters(m_barbarian, BARBS_PER_PLAYER * #p_list)
	if not ppenabled then
		ranks = {}
	end	
	for i=1,#p_list do
		table.insert(heroes, {p_list[i], 0, false, -1})-- 1:player link; 2:barbaric gems; 3:have a reviving gem?; 4:Respawns
		if ppenabled then
			local pname = "player " .. i -- fixme: kts.GetPlayerName(p_list[i])
			local p_rank = ranks[pname]
			if p_rank == nil then
				p_rank = {rank=1, promote=false, money=0}
				ranks[pname] = p_rank
			end
			if p_rank.promote and (p_rank.rank < #basic_ranks) then
				p_rank.rank = p_rank.rank + 1
			end	
			p_rank.promote = false
			if (RANKING_ENABLED) then
				print("- "..basic_ranks[p_rank.rank].text .. ' ' .. pname .. ' joined the game!')
			end
		end	
	end
end

function f_barb_gem()
	local i = get_hero(cxt.originator)
	local count = retrieve_barb_gem_from(cxt.pos)
	heroes[i][2] = heroes[i][2]+count
	if (count > 1) then
		kts.FlashMessage("Picked up "..count.." barbaric gem! Total: "..heroes[i][2])	
	else 
		kts.FlashMessage("Picked up a barbaric gem! Total: "..heroes[i][2])		
	end
	local p_name = "player " .. i -- fixme: kts.GetPlayerName(cxt.originator)
	local p_rank = ranks[p_name]
	local receive = count*MONEY_PER_GEM
	p_rank.money = p_rank.money + receive
	if (MONEY_ENABLED) then
		print("- "..p_name.." received $"..receive.." ($"..p_rank.money.." total)")
	end
	if ppenabled and (heroes[i][2]>=BARB_GEMS/2) then
		if (p_rank ~= nil) then
			p_rank.promote = true
		end	
	end
	
	if (heroes[i][2]>=BARB_GEMS) then
		mod_enabled = false
		print("- "..p_name.." completed the task!")
		kts.WinGame(heroes[i][1])
	end	
end	

barb_death = function()
	local pos = cxt.pos
	--print("Debug: barbarian was killed in "..pos.x.." "..pos.y)
	local b1 = isBarbBodyHere(pos)
	local b2 = isBarbBodyHere(n_pos)
	if b1 and (get_barb_gem_at(pos)<=0) then
		set_barb_gem_at(pos)
	elseif b2 and (get_barb_gem_at(n_pos)<=0) then
		set_barb_gem_at(n_pos)
	elseif b2 then
		set_barb_gem_at(n_pos)
	else
		set_barb_gem_at(pos)
	end
end

function creature_damage_f()
	if not kts.IsKnight(cxt.actor) then
		local c = kts.GetMonsterCount(m_barbarian)
		local pos = {x=cxt.pos.x, y=cxt.pos.y}
		local facing = kts.GetFacing(cxt.actor)
		local n_pos = {x=(pos.x+FdX(facing)), y=(pos.y+FdY(facing))}
		kts.Delay(10)
		if (get_barb_gem_at(pos)>0) and (not isBarbBodyHere(pos)) then
			kts.AddTile(pos,t_dead_barb_1g) 
		end	
		if (get_barb_gem_at(n_pos)>0) and (not isBarbBodyHere(n_pos)) then
			kts.AddTile(n_pos,t_dead_barb_1g) 
		end	
	end
end

function respawn_func(player)
	if mod_enabled then
	  local i = get_hero(player)
	    if (heroes[i][4]==-1) then
			--print("- Player "..get_hero(player).." appeared in the dungeon!")
		elseif (heroes[i][3]) then
			heroes[i][3] = false
			print(" - a player revived!")
			-- print(" - "..kts.GetPlayerName(player).." revived!")
		elseif (not DEBUG_ENABLED) then
			local p_rank = nil
			--fixme: local p_rank = ranks[kts.GetPlayerName(player)]
			if (p_rank ~= nil) then
				p_rank.rank = 1
				p_rank.promote = false
			end
			kts.EliminatePlayer(player)
		end
		heroes[i][4] = heroes[i][4]+1
	end	
end