local function get_faced_pos(pos, facing)
  if facing == "west" then
		return {x=pos.x-1, y=pos.y}
	elseif facing == "east" then
		return {x=pos.x+1, y=pos.y}
  elseif facing == "south" then
		return {x=pos.x, y=pos.y+1}
	elseif facing == "north" then
		return {x=pos.x, y=pos.y-1}
	end
  return pos
end

local function isBarbBodyHere(pos)
	local tiles = kts.GetTiles(pos)
	if tiles == nil then
		return false
	end	
	for _i = 1,#tiles do
		for _j = 1,#Assets.t_barb_corpses do
			if (tiles[_i].table == Assets.t_barb_corpses[_j].table) then
				return true
			end
		end
	end
	return false
end

Funcs = {
}

function Funcs.on_barb_gem_pickup()
  local player = cxt.originator
	local hero = Data.get_hero(player)
	local count = Data.retrieve_barb_gem_from(cxt.pos)
	hero.num_barb_gems = hero.num_barb_gems + count

	kts.FlashMessage({key="heroes.picked_up_barbaric_gem", params={count, hero.num_barb_gems}, plural=count})

	if (hero.num_barb_gems >= Config.barb_gems) then
		kts.WinGame(player)
	end
end

function Funcs.on_gem_pickup()
	if kts.GetNumHeld(cxt.actor, i_revive_gem) == 1 then
		local player = kts.GetPlayer(cxt.actor)
		local hero = Data.get_hero(player)
		hero.has_revive_gem = true
		kts.FlashMessage("heroes.picked_up_reviving_gem")
	else
		kts.Drop(i_revive_gem) --Drop previous gem, pickup a new one
	end
end

function Funcs.on_gem_drop()
	local actor = cxt.actor
	local player = cxt.originator
	kts.Delay(10) -- if gem drop was not caused by death - we will be able to detect this. Btw, "drop gem" action is now unused, but who knows...
	if kts.IsAlive(actor) then
		local hero = Data.get_hero(player)
		if kts.GetNumHeld(actor, i_revive_gem) < 1 then
			hero.has_revive_gem = false
		end
	else 
	end
end

function Funcs.barb_death()
	local pos = cxt.pos
	local f_pos = get_faced_pos(pos, kts.GetFacing(cxt.actor))
	local b1 = isBarbBodyHere(pos)
	local b2 = isBarbBodyHere(f_pos)
	if b1 and Data.get_barb_gems_at(pos) < 1 then
		Data.add_barb_gem_at(pos)
	elseif b2 and Data.get_barb_gems_at(f_pos) < 1 then
		Data.add_barb_gem_at(f_pos)
	elseif b2 then
		Data.add_barb_gem_at(f_pos)
	else
		Data.add_barb_gem_at(pos)
	end
end

function Funcs.on_respawn(player)
  local hero = Data.get_hero(player)
  hero.respawns = hero.respawns + 1
  if hero.respawns == 0 then
    return
  end
  assert(hero ~= nil, "An unknown hero have respawned!")
  if hero.has_revive_gem then
    hero.has_revive_gem = false
		print(" - A player was revived!")
  else
    kts.EliminatePlayer(player)
  end
end

function Funcs.on_game_start()
  if not Data.mission_selected then
    toolbox.Actions.Disable(toolbox.ActionType.RESPAWN, "heroes")
    if base.i_gem == i_revive_gem then
      base.i_gem = i_old_gem
    end
    return
  end
  Data.mission_selected = false
end

function Funcs.start_heroes()
	kts.AddHint({key="heroes.collect_n_gems", params={Config.barb_gems}, plural=Config.barb_gems}, 1, 1)
	toolbox.Actions.Listen(toolbox.ActionType.RESPAWN, "heroes", Funcs.on_respawn)
	base.i_gem = i_revive_gem --replace old gems with reviving ones
	local players = kts.GetAllPlayers()
	base.add_initial_monsters(m_barbarian, Config.barbs_per_player * #players)
  Data.heroes = {}
  Data.barb_gems = {}
end

toolbox.Actions.Listen(toolbox.ActionType.GAME_START, "heroes", Funcs.on_game_start)
