Data = {
  mission_selected = false,
  heroes = {},
  barb_gems = {},
}

function Data.get_hero(player)
  for i=1,#Data.heroes do
    local hero = Data.heroes[i]
    if hero.player == player then
      return hero
    end
  end
  local hero = {player=player, num_barb_gems=0, has_revive_gem=false, respawns=-1}
  table.insert(Data.heroes, hero)
  return hero
end

function Data.add_barb_gem_at(pos)
	for i=1,#Data.barb_gems do
    local gems = Data.barb_gems[i]
		if gems.pos.x == pos.x and gems.pos.y == pos.y then
			gems.num = gems.num + 1
			return
		end
	end
	table.insert(Data.barb_gems, {pos=pos, num=1})
end

function Data.get_barb_gems_at(pos)
	for i=1,#Data.barb_gems do
    local gems = Data.barb_gems[i]
		if gems.pos.x == pos.x and gems.pos.y == pos.y then
			return gems.num
		end
	end
	return 0
end

function Data.retrieve_barb_gem_from(pos)
	for i=1,#Data.barb_gems do
    local gems = Data.barb_gems[i]
		if gems.pos.x == pos.x and gems.pos.y == pos.y then
      local num = gems.num
      gems.num = 0
			return num
		end
	end
	return 1
end
