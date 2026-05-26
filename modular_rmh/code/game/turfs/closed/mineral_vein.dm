
// for mining flag
/mob/living
	var/is_mining_vein = FALSE
// ORE VEINS
/obj/structure/vein
	name = "vein ore"
	desc = "A rich vein of ore embedded in solid rock."
	icon = 'modular_rmh/icons/obj/oreveins.dmi'
	icon_state = "stonelayer"
	anchored = TRUE

	max_integrity = 999999
	damage_deflection = 9999
	opacity = FALSE
	density = FALSE

	var/ore_type = "iron"
	var/resource_type = /obj/item/ore/iron
	var/display_name = "iron"

	var/max_charges = 8
	var/current_charges = 8
	var/resource_time = 15 MINUTES
	var/next_resource = 0
	var/mining_time = 8 SECONDS
	var/skill_category = /datum/attribute/skill/labor/mining
	var/max_ore_drop = 3

/obj/structure/vein/Initialize(mapload)
	. = ..()
	current_charges = max_charges
	update_vein_overlay()

/obj/structure/vein/update_overlays()
	. = ..()
	var/state = (current_charges > 0) ? "[ore_type]_full" : "[ore_type]_empty"
	var/mutable_appearance/ore_overlay = mutable_appearance(icon, state)
	ore_overlay.layer = ABOVE_ALL_MOB_LAYER + 0.1
	. += ore_overlay

/obj/structure/vein/proc/update_vein_overlay()
	update_icon()

/obj/structure/vein/attackby(obj/item/I, mob/living/user, params)
	if(!istype(I, /obj/item/weapon/pick))
		to_chat(user, span_warning("You need a pickaxe to mine this."))
		return

	if(current_charges <= 0)
		if(world.time >= next_resource)
			replenish_vein()
		else
			to_chat(user, span_warning("This vein is still regenerating."))
			return

	// Stamina threshold
	if(!user.check_stamina(40))
		to_chat(user, span_warning("You are too tired to swing a pickaxe right now."))
		return

	//checking for mining one vein
	if(user.is_mining_vein)
		to_chat(user, span_warning("You are already mining."))
		return

	user.is_mining_vein = TRUE
	user.adjust_stamina(40)
	playsound(src, list('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 50, TRUE)

	var/skill_level = user.get_skill_level(skill_category)
	var/time = mining_time - (skill_level * 0.6 SECONDS)
	time = max(2 SECONDS, time)

	// debuff for mining
	if(user.energy <= 0)
		time *= 2
		to_chat(user, span_warning("You are exhausted. Mining feels much harder..."))

	if(do_after(user, time, src))
		playsound(src, 'sound/combat/hits/onstone/stonedeath.ogg', 50, TRUE)
		mine_vein(user, skill_level)

	user.is_mining_vein = FALSE
	return TRUE

/obj/structure/vein/proc/mine_vein(mob/living/user, skill_level = 0)
	if(current_charges <= 0)
		return

	current_charges--

	var/amount = 0
	if(skill_level >= 5)
		amount = max_ore_drop
	else if(skill_level >= 3)
		amount = max(1, round(max_ore_drop * 0.5))
	else
		if(prob(40))
			amount = 0
		else
			amount = max(1, round(max_ore_drop * 0.25))

	if(amount <= 0)
		user.visible_message(span_warning("[user] swings at [src] but breaks nothing off."), \
							span_warning("You chip at the rock but get nothing this time."))
	else
		for(var/i in 1 to amount)
			new resource_type(get_turf(src))
		user.visible_message(span_notice("[user] breaks off some ore from [src]."), \
							span_notice("You successfully mine [amount] piece\s of ore."))

	update_vein_overlay()

	if(current_charges <= 0)
		islooted()

/obj/structure/vein/proc/islooted()
	next_resource = world.time + resource_time

/obj/structure/vein/proc/replenish_vein()
	current_charges = max_charges
	next_resource = 0
	update_vein_overlay()
	visible_message(span_notice("[src] looks rich with ore once again."))

/obj/structure/vein/examine(mob/user)
	. = ..()

	// admins see all info about vein
	if(isobserver(user))
		. += span_info("This is a <b>[display_name]</b> vein.")
		if(current_charges > 0)
			. += span_notice("It has <b>[current_charges]/[max_charges]</b> harvests remaining.")
		else
			var/mins_left = round((next_resource - world.time) / 600)
			. += span_warning("It is depleted. Regenerates in approximately <b>[mins_left]</b> min.")
		return

	// simple like mobs see min info
	if(!isliving(user) || !user.mind)
		if(current_charges > 0)
			. += span_notice("It looks like there might be something in the rock.")
		else
			. += span_warning("It looks barren.")
		return
	// energy
	var/mob/living/L = user

	if(L.energy <= 0)
		. += span_warning("You are too exhausted to make out anything about this rock.")
		return

	var/skill_level = user.get_skill_level(skill_category)

	// Skill 0-2: see only avaible ore
	if(skill_level <= 2)
		if(current_charges > 0)
			. += span_notice("There seems to be ore in this rock.")
		else
			. += span_warning("The rock looks barren.")

	// Skill 3-4: + type of ore
	else if(skill_level <= 4)
		. += span_info("This appears to be a <b>[display_name]</b> vein.")
		if(current_charges > 0)
			. += span_notice("It still has ore to give.")
		else
			. += span_warning("It looks depleted.")

	// Skill 5: + left ore
	else if(skill_level == 5)
		. += span_info("This is a <b>[display_name]</b> vein.")
		if(current_charges > 0)
			. += span_notice("It has <b>[current_charges]</b> harvests remaining.")
		else
			. += span_warning("It is currently depleted.")

	// Skill 6+: + time to new charges
	else
		. += span_info("This is a <b>[display_name]</b> vein.")
		if(current_charges > 0)
			. += span_notice("It has <b>[current_charges]/[max_charges]</b> harvests remaining.")
		else
			var/mins_left = round((next_resource - world.time) / 600)
			. += span_warning("It is depleted. You will find a new ore in approximately <b>[mins_left]</b> min.")

// ORES
/obj/structure/vein/iron
	name = "ore vein"
	ore_type = "iron"
	resource_type = /obj/item/ore/iron
	display_name = "iron"
	max_charges = 5
	current_charges = 5
	max_ore_drop = 3
	resource_time = 75 MINUTES

/obj/structure/vein/copper
	name = "ore vein"
	ore_type = "copper"
	resource_type = /obj/item/ore/copper
	display_name = "copper"
	max_charges = 4
	current_charges = 4
	max_ore_drop = 4
	resource_time = 80 MINUTES

/obj/structure/vein/tin
	name = "ore vein"
	ore_type = "tin"
	resource_type = /obj/item/ore/tin
	display_name = "tin"
	max_charges = 4
	current_charges = 4
	max_ore_drop = 2
	resource_time = 80 MINUTES

/obj/structure/vein/silver
	name = "ore vein"
	ore_type = "silver"
	resource_type = /obj/item/ore/silver
	display_name = "silver"
	max_charges = 1
	current_charges = 1
	max_ore_drop = 3
	resource_time = 180 MINUTES

/obj/structure/vein/gold
	name = "ore vein"
	ore_type = "gold"
	resource_type = /obj/item/ore/gold
	display_name = "gold"
	max_charges = 2
	current_charges = 2
	max_ore_drop = 3
	resource_time = 120 MINUTES

/obj/structure/vein/salt
	name = "ore vein"
	ore_type = "salt"
	resource_type = /obj/item/reagent_containers/powder/salt
	display_name = "salt"
	max_charges = 5
	current_charges = 5
	max_ore_drop = 2
	resource_time = 30 MINUTES

/obj/structure/vein/coal
	name = "ore vein"
	ore_type = "coal"
	resource_type = /obj/item/ore/coal
	display_name = "coal"
	max_charges = 5
	current_charges = 5
	max_ore_drop = 3
	resource_time = 20 MINUTES
