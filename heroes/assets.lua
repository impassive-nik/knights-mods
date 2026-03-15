local function load_anim(base_path)
  local anim_table = {}
  local nesw = "nesw"
  for i=1,4 do
    for c in nesw:gmatch"." do
      table.insert(anim_table, kts.Graphic(base_path .. i .. c .. ".bmp", 0, 0, 0))
    end
  end
  return kts.Anim(anim_table)
end

local function get_barb_corpse(i)
  local tile_no_gem   = kts.Tile(kts.table_merge(base.floor, { graphic = kts.Graphic("assets/dead_barb_" .. i .. ".bmp", 0, 0, 0), depth = -2 } ))
  local tile_with_gem = kts.Tile(kts.table_merge(base.floor, { graphic = kts.Graphic("assets/dead_barb_" .. i .. "g.bmp", 0, 0, 0), depth = -2 } ))
  tile_with_gem.on_walk_over = function()
    if (kts.ActorIsKnight()) then
      Funcs.on_barb_gem_pickup()
      kts.ChangeTile(tile_no_gem)
    end
  end
  return tile_with_gem
end

Assets = {
  g_revive_gem    = kts.Graphic("assets/new_gem.bmp", 0, 0, 0, -5, -4), -- a new sprite for gem (reviving gem)
  g_revive_gem_bp = kts.Graphic("assets/new_drop_gem.bmp"),             -- a new sprite for gem inside of backpack

  g_barb_gem      = kts.Graphic("assets/bar_gem.bmp", 0, 0, 0, -5, -4), -- barbaric gem
  g_barb_gem_bp   = kts.Graphic("assets/bar_drop_gem.bmp"),             -- barbaric gem inside a backpack

  a_barbarian = load_anim("assets/barb"), -- Barbarian animation

  -- a set of barbarian corpses with gems
  t_barb_corpses = {
    get_barb_corpse(1),
    get_barb_corpse(2),
    get_barb_corpse(3),
    get_barb_corpse(4)
  },

  s_barb_ugh = kts.Sound("assets/barb_ugh.wav")
}
