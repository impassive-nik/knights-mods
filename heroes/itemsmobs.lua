--ITEMS

local C = require("base")

i_old_gem = C.i_gem --save old gem definition

i_revive_gem = kts.ItemType { --create new gem definition (will be replaced in 'hooks.lua') 
    type = "backpack",
    graphic = heroes_gem,
    backpack_graphic = heroes_drop_gem,
    backpack_slot = 30,
    tutorial = TUT_GEM,
    critical = "A reviving gem",
	on_pick_up = on_gem_pickup,
	on_drop = on_gem_drop
}

i_barbaric_gem = kts.ItemType { --create new gem definition (will be replaced in 'hooks.lua') 
    type = "backpack",
    graphic = barbaric_gem,
    backpack_graphic = barbaric_drop_gem,
    backpack_slot = 30,
    tutorial = TUT_GEM,
    critical = "A barbaric gem",
	on_pick_up = f_barb_gem
}

--MOBS

barbaric_weapon = kts.ItemType { --similar to sword but with graphic of an axe
    type = "held",
    graphic = C.g_axe,
    overlay = kts.Overlay { C.g_axe_north, C.g_axe_east, C.g_axe_south, C.g_axe_west },

    melee_backswing_time = C.ts*2,
    melee_downswing_time = C.ts*2,
    melee_damage = C.rng_range(1, 1),
    melee_stun_time = C.rng_time_range(1, 2),
    melee_tile_damage = 1,
    parry_chance = 0.66
}

m_barbarian = kts.MonsterType {
   type = "walking",
   health = C.rng_range(5, 6),  
   speed = 80,
   anim = a_barbarian,
   corpse_tiles = { t_dead_barb_1g, t_dead_barb_2g, t_dead_barb_3g, t_dead_barb_4g },
   on_attack = pre_snd_barb,
   on_damage = pre_snd_barb,
   on_death = pre_barb_death,
   on_move = function()
      if kts.RandomChance(0.05) then
         pre_snd_barb()
      end
   end,

   weapon = barbaric_weapon,
   ai_avoid = C.all_open_pit_tiles,
   ai_fear = {C.i_wand_of_undeath, i_wand_of_destruction, i_necronomicon}
}