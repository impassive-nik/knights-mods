--Reviving gems

local C = require("base")

heroes_gem = kts.Graphic("sprites/new_gem.bmp",0,0,0,-5,-4) --new sprite for gem (reviving gem)
heroes_drop_gem = kts.Graphic("sprites/new_drop_gem.bmp") -- new sprite for gem inside of backpack

barbaric_gem = kts.Graphic("sprites/bar_gem.bmp",0,0,0,-5,-4) --(barbaric gem)
barbaric_drop_gem = kts.Graphic("sprites/bar_drop_gem.bmp")

--Barbarian (based on knight player)

g_barb1n	= kts.Graphic("sprites/barb1n.bmp",0,0,0)
g_barb1e	= kts.Graphic("sprites/barb1e.bmp",0,0,0)
g_barb1s	= kts.Graphic("sprites/barb1s.bmp",0,0,0)
g_barb1w	= kts.Graphic("sprites/barb1w.bmp",0,0,0)
g_barb2n	= kts.Graphic("sprites/barb2n.bmp",0,0,0)
g_barb2e	= kts.Graphic("sprites/barb2e.bmp",0,0,0)
g_barb2s	= kts.Graphic("sprites/barb2s.bmp",0,0,0)
g_barb2w	= kts.Graphic("sprites/barb2w.bmp",0,0,0)
g_barb3n	= kts.Graphic("sprites/barb3n.bmp",0,0,0)
g_barb3e	= kts.Graphic("sprites/barb3e.bmp",0,0,0)
g_barb3s	= kts.Graphic("sprites/barb3s.bmp",0,0,0)
g_barb3w	= kts.Graphic("sprites/barb3w.bmp",0,0,0)
g_barb4n	= kts.Graphic("sprites/barb4n.bmp",0,0,0)
g_barb4e	= kts.Graphic("sprites/barb4e.bmp",0,0,0)
g_barb4s	= kts.Graphic("sprites/barb4s.bmp",0,0,0)
g_barb4w	= kts.Graphic("sprites/barb4w.bmp",0,0,0)


g_dead_barb_1 = kts.Graphic("sprites/dead_barb_1.bmp", 0,0,0) --Dead barbarian tile
g_dead_barb_2 = kts.Graphic("sprites/dead_barb_2.bmp", 0,0,0)
g_dead_barb_3 = kts.Graphic("sprites/dead_barb_3.bmp", 0,0,0)
g_dead_barb_4 = kts.Graphic("sprites/dead_barb_4.bmp", 0,0,0)

t_dead_barb_1 = kts.Tile(kts.table_merge(C.floor,  { graphic = g_dead_barb_1, depth = -2 } ))
t_dead_barb_2 = kts.Tile(kts.table_merge(C.floor,  { graphic = g_dead_barb_2, depth = -2 } ))
t_dead_barb_3 = kts.Tile(kts.table_merge(C.floor,  { graphic = g_dead_barb_3, depth = -2 } ))
t_dead_barb_4 = kts.Tile(kts.table_merge(C.floor,  { graphic = g_dead_barb_4, depth = -2 } ))

---[[
g_dead_barb_1g = kts.Graphic("sprites/dead_barb_1g.bmp", 0,0,0) --Same tile, but with barbaric gem
g_dead_barb_2g = kts.Graphic("sprites/dead_barb_2g.bmp", 0,0,0)
g_dead_barb_3g = kts.Graphic("sprites/dead_barb_3g.bmp", 0,0,0)
g_dead_barb_4g = kts.Graphic("sprites/dead_barb_4g.bmp", 0,0,0)


t_dead_barb_1g = kts.Tile(kts.table_merge(C.floor,  { graphic = g_dead_barb_1g, depth = -2 } ))
t_dead_barb_1g.on_walk_over = function() 
	if (kts.ActorIsKnight()) then
		f_barb_gem()
		kts.ChangeTile(t_dead_barb_1)
	end
end
t_dead_barb_2g = kts.Tile(kts.table_merge(C.floor,  { graphic = g_dead_barb_2g, depth = -2 } ))
t_dead_barb_2g.on_walk_over = function() 
	if (kts.ActorIsKnight()) then
		f_barb_gem()
		kts.ChangeTile(t_dead_barb_2)
	end
end
t_dead_barb_3g = kts.Tile(kts.table_merge(C.floor,  { graphic = g_dead_barb_3g, depth = -2 } ))
t_dead_barb_3g.on_walk_over = function() 
	if (kts.ActorIsKnight()) then
		f_barb_gem()
		kts.ChangeTile(t_dead_barb_3)
	end
end
t_dead_barb_4g = kts.Tile(kts.table_merge(C.floor,  { graphic = g_dead_barb_4g, depth = -2 } ))
t_dead_barb_4g.on_walk_over = function() 
	if (kts.ActorIsKnight()) then
		f_barb_gem()
		kts.ChangeTile(t_dead_barb_4)
	end
end

t_dead_barb_g = {t_dead_barb_1g, t_dead_barb_2g, t_dead_barb_3g, t_dead_barb_4g}
--]]

a_barbarian = kts.Anim {
	g_barb1n, g_barb1e, g_barb1s, g_barb1w,  -- Normal
	g_barb2n, g_barb2e, g_barb2s, g_barb2w,  -- Melee backswing
	g_barb3n, g_barb3e, g_barb3s, g_barb3w,  -- Melee downswing
	g_barb4n, g_barb4e, g_barb4s, g_barb4w,  -- Parrying
}

--Well, that is not a sprite, but who cares?..
s_barb_ugh = kts.Sound("sprites/barb_ugh.wav")