i_old_gem = base.i_gem -- save the old gem definition

i_revive_gem = kts.ItemType {
    type = "backpack",
    graphic = Assets.g_revive_gem,
    backpack_graphic = Assets.g_revive_gem_bp,
    backpack_slot = 30,
    critical = "A reviving gem",
	on_pick_up = Funcs.on_gem_pickup,
	on_drop = Funcs.on_gem_drop
}

i_barbaric_gem = kts.ItemType {
    type = "backpack",
    graphic = Assets.g_barb_gem,
    backpack_graphic = Assets.g_barb_gem_bp,
    backpack_slot = 30,
    critical = "A barbaric gem",
	on_pick_up = Funcs.on_barb_gem_pickup
}
