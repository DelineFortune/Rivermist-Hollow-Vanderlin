/turf/closed/wall/mineral/sandstone
	name = "sandstone wall"
	desc = "A wall of smooth, unyielding sandstone."
	icon = 'modular_ratwood/modular_deserttown/icons/sandstone.dmi'
	icon_state = "sand-stone"
	//NEED TO REPAIR FOR RMH smooth = SMOOTH_MORE
	blade_dulling = DULLING_BASH
	max_integrity = 1800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	//NEED TO REPAIR FOR RMH canSmoothWith = list(/turf/closed/wall/mineral/desert/sandstone)
	above_floor = /turf/open/floor/desert/citybrick
	baseturfs = /turf/open/floor/desert/citybrick
	neighborlay = "dirtedge"
	climbdiff = 3
	damage_deflection = 10
	hardness = 4

/turf/closed/wall/mineral/sandbrick
	name = "sandbrick wall"
	desc = "A wall of smooth, unyielding bricks."
	icon = 'modular_ratwood/modular_deserttown/icons/sandbrick_wall.dmi'
	icon_state = "sandbrick"
	//NEED TO REPAIR FOR RMH smooth = SMOOTH_MORE
	blade_dulling = DULLING_BASH
	max_integrity = 1800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	//NEED TO REPAIR FOR RMH canSmoothWith = list(/turf/closed/wall/mineral/sandbrick)
	above_floor = /turf/open/floor/desert/darkpath
	baseturfs = /turf/open/floor/desert/darkpath
	neighborlay = "dirtedge"
	climbdiff = 3
	damage_deflection = 10
	hardness = 3

/turf/closed/mineral/sandstone
	name = "sandstone"
	desc = "Dusty, sand-blasted rock."
	icon = 'icons/turf/smooth/walls/mineral_moss.dmi'
	icon_state = MAP_SWITCH("mineral", "mineral-0")
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_MINERAL_WALLS
	smoothing_list = SMOOTH_GROUP_MINERAL_WALLS
	// icon = 'modular_ratwood/modular_deserttown/icons/rock.dmi'
	// icon_state = "wallformed"
	//NEED TO REPAIR FOR RMH smooth = SMOOTH_TRUE | SMOOTH_MORE
	//NEED TO REPAIR FOR RMH smooth_icon = 'modular_deserttown/icons/rock.dmi'
	//NEED TO REPAIR FOR RMH canSmoothWith = list(/turf/closed/mineral/random/rogue/sandstone, /turf/closed/mineral/rogue/sandstone)
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone

/turf/closed/mineral/bedrock/sandstone
	name = "sandstone"
	desc = "Seems barren and nigh-indestructable"
	icon = 'icons/turf/smooth/walls/mineral_moss.dmi'
	icon_state = MAP_SWITCH("mineral", "mineral-0")
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_MINERAL_WALLS
	smoothing_list = SMOOTH_GROUP_MINERAL_WALLS
	// icon = 'modular_ratwood/modular_deserttown/icons/rock.dmi'
	// icon_state = "bedrock"
	// smooth_icon = 'icons/turf/walls/hardrock.dmi'
	above_floor = /turf/closed/mineral/bedrock/sandstone

/turf/closed/mineral/random/sandstone
	name = "sandstone"
	desc = "Dusty, sand-blasted rock."
	icon = 'icons/turf/smooth/walls/mineral_moss.dmi'
	icon_state = MAP_SWITCH("mineral", "mineral-0")
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_MINERAL_WALLS
	smoothing_list = SMOOTH_GROUP_MINERAL_WALLS
	// icon = 'modular_ratwood/modular_deserttown/icons/rock.dmi'
	// icon_state = MAP_SWITCH("wallformed", "minlow")
	//NEED TO REPAIR FOR RMH smooth = SMOOTH_TRUE | SMOOTH_MORE
	//NEED TO REPAIR FOR RMH smooth_icon = 'modular_deserttown/icons/rock.dmi'
	//NEED TO REPAIR FOR RMH canSmoothWith = list(/turf/closed/mineral/random/rogue/sandstone, /turf/closed/mineral/rogue/sandstone)
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone
	mineralSpawnChanceList = list(
		/turf/closed/mineral/random/sandstone/salt = 5,
		/turf/closed/mineral/random/sandstone/iron = 15,
		/turf/closed/mineral/random/sandstone/copper = 10,
		/turf/closed/mineral/random/sandstone/coal = 25)

/turf/closed/mineral/random/sandstone/gold
	icon_state = "mingold"
	mineralType = /obj/item/ore/gold
	rockType = /obj/item/natural/rock/gold
	spreadChance = 5
	spread = 1

/turf/closed/mineral/random/sandstone/silver
	icon_state = "mingold"
	mineralType = /obj/item/ore/silver
	rockType = /obj/item/natural/rock/silver
	spreadChance = 5
	spread = 1

/turf/closed/mineral/random/sandstone/salt
	icon_state = "mingold"
	mineralType = /obj/item/reagent_containers/powder/salt
	rockType = /obj/item/natural/rock/salt
	spreadChance = 33
	spread = 15

/turf/closed/mineral/random/sandstone/iron
	icon_state = "mingold"
	mineralType = /obj/item/ore/iron
	rockType = /obj/item/natural/rock/iron
	spreadChance = 23
	spread = 5

/turf/closed/mineral/random/sandstone/copper
	icon_state = "mingold"
	mineralType = /obj/item/ore/copper
	rockType = /obj/item/natural/rock/copper
	spreadChance = 27
	spread = 8

/turf/closed/mineral/random/sandstone/tin
	icon_state = "mingold"
	mineralType = /obj/item/ore/tin
	rockType = /obj/item/natural/rock/tin
	spreadChance = 15
	spread = 5

/turf/closed/mineral/random/sandstone/coal
	icon_state = "mingold"
	mineralType = /obj/item/ore/coal
	rockType = /obj/item/natural/rock/coal
	spreadChance = 33
	spread = 11

/turf/closed/mineral/random/sandstone/cinnabar
	icon_state = "mingold"
	mineralType = /obj/item/ore/cinnabar
	rockType = /obj/item/natural/rock/cinnabar
	spreadChance = 23
	spread = 5

/turf/closed/mineral/random/sandstone/gem
	icon_state = "mingold"
	mineralType = /obj/item/gem/random
	rockType = /obj/item/natural/rock/gemerald
	spreadChance = 3
	spread = 2

/turf/closed/mineral/random/random/sandstone/med
	icon_state = "minmed"
	mineralChance = 10
	mineralSpawnChanceList = list(
		/turf/closed/mineral/random/sandstone/salt = 5,
		/turf/closed/mineral/random/sandstone/gold = 3,
		/turf/closed/mineral/random/sandstone/silver = 2,
		/turf/closed/mineral/random/sandstone/iron = 33,
		/turf/closed/mineral/random/sandstone/cinnabar = 15,
		/turf/closed/mineral/random/sandstone/copper = 15,
		/turf/closed/mineral/random/sandstone/tin = 10,
		/turf/closed/mineral/random/sandstone/coal = 14,
		/turf/closed/mineral/random/sandstone/gem = 1)

/turf/closed/mineral/random/random/sandstone/high
	icon_state = "minhigh"
	mineralChance = 33
	mineralSpawnChanceList = list(
		/turf/closed/mineral/random/sandstone/cinnabar = 15,
		/turf/closed/mineral/random/sandstone/salt = 5,
		/turf/closed/mineral/random/sandstone/gold = 9,
		/turf/closed/mineral/random/sandstone/silver = 5,
		/turf/closed/mineral/random/sandstone/iron = 33,
		/turf/closed/mineral/random/sandstone/copper = 20,
		/turf/closed/mineral/random/sandstone/tin = 12,
		/turf/closed/mineral/random/sandstone/coal = 19,
		/turf/closed/mineral/random/sandstone/gem = 3)
