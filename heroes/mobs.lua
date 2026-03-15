barbaric_weapon = kts.ItemType { -- similar to sword but with graphic of an axe
    type = "held",
    graphic = base.g_axe,
    overlay = kts.Overlay { base.g_axe_north, base.g_axe_east, base.g_axe_south, base.g_axe_west },

    melee_backswing_time = base.ts*2,
    melee_downswing_time = base.ts*2,
    melee_damage = base.rng_range(1, 1),
    melee_stun_time = base.rng_time_range(1, 2),
    melee_tile_damage = 1,
    parry_chance = 0.66
}

local function snd_barb()
	kts.PlaySound(cxt.pos, Assets.s_barb_ugh, 9000)
end

m_barbarian = kts.MonsterType {
   type = "walking",
   health = base.rng_range(5, 6),  
   speed = 80,
   anim = Assets.a_barbarian,
   corpse_tiles = Assets.t_barb_corpses,
   on_attack = snd_barb,
   on_damage = snd_barb,
   on_death = Funcs.barb_death,
   on_move = function()
      if kts.RandomChance(0.05) then
         snd_barb()
      end
   end,

   weapon = barbaric_weapon,
   ai_avoid = base.all_open_pit_tiles,
   ai_fear = {base.i_wand_of_undeath, base.i_wand_of_destruction, base.i_necronomicon}
}
