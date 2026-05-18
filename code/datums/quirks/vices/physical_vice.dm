/datum/status_effect/debuff/badvision
	id = "badvision"
	alert_type = null
	effectedstats = list(STAT_PERCEPTION = -10, STAT_SPEED = -2, STAT_FORTUNE = -5)
	duration = 5 SECONDS

/datum/quirk/vice/bad_sight
	name = "Poor Vision"
	desc = "I need spectacles to see normally from my years spent reading books."
	point_value = 2

/datum/quirk/vice/bad_sight/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	owner.adjust_skill_level(/datum/attribute/skill/misc/reading, 10)

	if(H.wear_mask)
		var/type = H.wear_mask.type
		qdel(H.wear_mask)
		H.put_in_hands(new type())
	H.equip_to_slot_or_del(new /obj/item/clothing/face/spectacles(H), ITEM_SLOT_MASK)
	H.become_nearsighted(type)

/datum/quirk/vice/bad_sight/on_remove()
	if(owner)
		owner.cure_nearsighted(type)
		owner.remove_status_effect(/datum/status_effect/debuff/badvision)
	. = ..()

/datum/quirk/vice/bad_sight/on_life(mob/living/user)
	if(!ishuman(user))
		return
	if(user.is_nearsighted_currently())
		user.apply_status_effect(/datum/status_effect/debuff/badvision)

/datum/quirk/vice/cyclops_right
	name = "Cyclops (R)"
	desc = "I lost my right eye long ago. But it made me great at noticing things."
	point_value = 2

/datum/quirk/vice/cyclops_right/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.wear_mask)
		var/type = H.wear_mask.type
		QDEL_NULL(H.wear_mask)
		H.put_in_hands(new type(get_turf(H)))
	H.equip_to_slot_or_del(new /obj/item/clothing/face/eyepatch(H), ITEM_SLOT_MASK)
	ADD_TRAIT(H, TRAIT_CYCLOPS_RIGHT, QUIRK_TRAIT)
	H.update_fov_angles()

/datum/quirk/vice/cyclops_left
	name = "Cyclops (L)"
	desc = "I lost my left eye long ago. But it made me great at noticing things."
	point_value = 2

/datum/quirk/vice/cyclops_left/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.wear_mask)
		var/type = H.wear_mask.type
		QDEL_NULL(H.wear_mask)
		H.put_in_hands(new type(get_turf(H)))
	H.equip_to_slot_or_del(new /obj/item/clothing/face/eyepatch/left(H), ITEM_SLOT_MASK)
	ADD_TRAIT(H, TRAIT_CYCLOPS_LEFT, QUIRK_TRAIT)
	H.update_fov_angles()

/datum/quirk/vice/tongueless
	name = "Tongueless"
	desc = "I said one word too many to a noble, they cut out my tongue. (Being mute is not an excuse to forego roleplay. Use of custom emotes is recommended.)"
	point_value = 4

/datum/quirk/vice/tongueless/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/tongue/permanent)

/datum/quirk/vice/wooden_arm_right
	name = "Wooden Arm (R)"
	desc = "I lost my right arm long ago, but the wooden arm doesn't bleed as much."
	incompatible_quirks = list(
		/datum/quirk/boon/iron_arm_right,
		/datum/quirk/boon/steel_arm_right,
		/datum/quirk/boon/gold_arm_right,
		/datum/quirk/boon/bronze_arm_right,
	)
	point_value = 3

/datum/quirk/vice/wooden_arm_right/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_R_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	var/obj/item/bodypart/r_arm/prosthetic/wood/L = new()
	L.attach_limb(H)

/datum/quirk/vice/wooden_arm_left
	name = "Wooden Arm (L)"
	desc = "I lost my left arm long ago, but the wooden arm doesn't bleed as much."
	incompatible_quirks = list(
		/datum/quirk/boon/iron_arm_left,
		/datum/quirk/boon/steel_arm_left,
		/datum/quirk/boon/gold_arm_left,
		/datum/quirk/boon/bronze_arm_left,
	)
	point_value = 3

/datum/quirk/vice/wooden_arm_left/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_L_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	var/obj/item/bodypart/l_arm/prosthetic/wood/L = new()
	L.attach_limb(H)

/datum/quirk/vice/wooden_leg_right
	name = "Wooden Leg (R)"
	desc = "I lost my right leg long ago, but the wooden leg doesn't bleed as much."
	point_value = 3
	incompatible_quirks = list(
		/datum/quirk/boon/iron_leg_right,
		/datum/quirk/boon/steel_leg_right,
		/datum/quirk/boon/gold_leg_right,
		/*
		/datum/quirk/boon/bronze_leg_right,
		*/
	)

/datum/quirk/vice/wooden_leg_right/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_R_LEG)
	if(O)
		O.drop_limb()
		qdel(O)
	var/obj/item/bodypart/r_leg/prosthetic/wood/L = new()
	L.attach_limb(H)

/datum/quirk/vice/wooden_leg_left
	name = "Wooden Leg (L)"
	desc = "I lost my left leg long ago, but the wooden leg doesn't bleed as much."
	incompatible_quirks = list(
		/datum/quirk/boon/iron_leg_left,
		/datum/quirk/boon/steel_leg_left,
		/datum/quirk/boon/gold_leg_left,
		/*
		/datum/quirk/boon/bronze_leg_left,
		*/
	)
	point_value = 3

/datum/quirk/vice/wooden_leg_left/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_L_LEG)
	if(O)
		O.drop_limb()
		qdel(O)
	var/obj/item/bodypart/l_leg/prosthetic/wood/L = new()
	L.attach_limb(H)


/datum/quirk/vice/leprosy
	name = "Leprosy"
	desc = "Become a leper. You will be hated, you will be shunned, you will bleed and you will be weak."
	point_value = 8

/datum/quirk/vice/leprosy/on_spawn()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner

	ADD_TRAIT(H, TRAIT_LEPROSY, QUIRK_TRAIT)
	ADD_TRAIT(H, TRAIT_NOPAIN, QUIRK_TRAIT)

	// Equip iron mask - remove existing mask if present
	if(H.wear_mask)
		var/type = H.wear_mask.type
		QDEL_NULL(H.wear_mask)
		H.put_in_hands(new type(get_turf(H)))

	H.equip_to_slot_or_del(new /obj/item/clothing/face/facemask(H), ITEM_SLOT_MASK)

/datum/quirk/vice/leprosy/on_remove()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner

	// Remove traits when quirk is removed
	REMOVE_TRAIT(H, TRAIT_LEPROSY, QUIRK_TRAIT)
	REMOVE_TRAIT(H, TRAIT_NOPAIN, QUIRK_TRAIT)

/datum/quirk/vice/crippled_arm
	name = "Missing Arm"
	desc = "You're missing an arm. It was lost in an accident or battle, and the stump is too damaged for anything but prosthetics."
	point_value = 5
	customization_label = "Choose Missing Arm"
	incompatible_quirks = list(
		/datum/quirk/vice/wooden_arm_right,
		/datum/quirk/vice/wooden_arm_left,
		/datum/quirk/boon/iron_arm_right,
		/datum/quirk/boon/iron_arm_left,
		/datum/quirk/boon/steel_arm_right,
		/datum/quirk/boon/steel_arm_left,
		/datum/quirk/boon/gold_arm_right,
		/datum/quirk/boon/gold_arm_left,
		/datum/quirk/boon/bronze_arm_right,
		/datum/quirk/boon/bronze_arm_left,
	)
	customization_options = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
	)

/datum/quirk/vice/crippled_arm/on_spawn()
	if(!ishuman(owner))
		return
	if(!customization_value)
		customization_value = BODY_ZONE_L_ARM

	addtimer(CALLBACK(src, PROC_REF(remove_limb)), 0.5 SECONDS)

/datum/quirk/vice/crippled_arm/proc/remove_limb()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/limb_to_remove = H.get_bodypart(customization_value)

	if(limb_to_remove)
		limb_to_remove.drop_limb()
		qdel(limb_to_remove)

/datum/quirk/vice/crippled_arm/get_option_name(option)
	switch(option)
		if(BODY_ZONE_L_ARM)
			return "Left Arm"
		if(BODY_ZONE_R_ARM)
			return "Right Arm"
	return "[option]"

/datum/quirk/vice/crippled_leg
	name = "Missing Leg"
	desc = "You're missing a leg. It was lost in an accident or battle, and the stump is too damaged for anything but prosthetics."
	point_value = 5
	customization_label = "Choose Missing Leg"
	incompatible_quirks = list(
		/datum/quirk/vice/wooden_leg_right,
		/datum/quirk/vice/wooden_leg_left,
		/datum/quirk/boon/iron_leg_right,
		/datum/quirk/boon/iron_leg_left,
		/datum/quirk/boon/steel_leg_right,
		/datum/quirk/boon/steel_leg_left,
		/datum/quirk/boon/gold_leg_right,
		/datum/quirk/boon/gold_leg_left,
		/*
		/datum/quirk/boon/bronze_leg_right,
		/datum/quirk/boon/bronze_leg_left,
		*/
	)
	customization_options = list(
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG
	)

/datum/quirk/vice/crippled_leg/on_spawn()
	if(!ishuman(owner))
		return
	if(!customization_value)
		customization_value = BODY_ZONE_L_ARM

	addtimer(CALLBACK(src, PROC_REF(remove_limb)), 0.5 SECONDS)

/datum/quirk/vice/crippled_leg/proc/remove_limb()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/limb_to_remove = H.get_bodypart(customization_value)

	if(limb_to_remove)
		limb_to_remove.drop_limb()
		qdel(limb_to_remove)

/datum/quirk/vice/crippled_leg/get_option_name(option)
	switch(option)
		if(BODY_ZONE_L_LEG)
			return "Left Leg"
		if(BODY_ZONE_R_LEG)
			return "Right Leg"
	return "[option]"

/datum/quirk/vice/tainted_soul
	name = "Tainted Soul"
	desc = "You had an unfortunate run-in with a monster. A goblin saved you, but you've never felt the same since."
	point_value = 2
	blocked_species = list(
		/datum/species/kobold,
		/datum/species/demihuman,
		/datum/species/rakshari,
		/datum/species/rousman,
		/datum/species/goblin,
		/datum/species/orc,
	)

/datum/quirk/vice/tainted_soul/on_spawn()
	if(!ishuman(owner))
		return
	ADD_TRAIT(owner, TRAIT_TAINTED_LUX, "[type]")

/datum/quirk/vice/tainted_soul/on_remove()
	if(!ishuman(owner))
		return
	REMOVE_TRAIT(owner, TRAIT_TAINTED_LUX, "[type]")

/datum/quirk/vice/rough_start
	name = "Rough Start"
	desc = "You begin your journey drunk, drugged, beaten, with broken legs, and spawn somewhere random in the forest."
	point_value = 4
	apply_order = 10000 ///this should always be first tbh
	incompatible_quirks = list(
		/datum/quirk/vice/lost_keys,
		/datum/quirk/boon/always_prepared,
	)
	preview_render = FALSE

/datum/quirk/vice/rough_start/on_spawn()
	if(!owner || !ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner
	if(H.reagents)
		H.reagents.add_reagent(/datum/reagent/consumable/ethanol, 15)

	if(H.reagents)
		H.reagents.add_reagent(/datum/reagent/drug/space_drugs, 15)

	for(var/i = 1 to 4)
		H.adjustBruteLoss(rand(9, 14), damage_type = BCLASS_BLUNT)
	var/obj/item/bodypart/l_leg/left = H.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/r_leg/right = H.get_bodypart(BODY_ZONE_R_LEG)

	if(left)
		var/datum/wound/fracture/F = left.add_wound(/datum/wound/fracture)
		if(F)
			F.whp = 10
	if(right)
		var/datum/wound/fracture/F = right.add_wound(/datum/wound/fracture)
		if(F)
			F.whp = 10

	var/list/spawn_points = list()
	for(var/obj/effect/landmark/start/adventurerlate/L in GLOB.start_landmarks_list)
		spawn_points += get_turf(L)

	if(length(spawn_points))
		var/turf/spawn_turf = pick(spawn_points)
		H.forceMove(spawn_turf)
	else
		for(var/obj/effect/landmark/start/L in GLOB.start_landmarks_list)
			spawn_points += get_turf(L)
		if(length(spawn_points))
			H.forceMove(pick(spawn_points))

	to_chat(H, span_danger("You awaken battered and broken in an unfamiliar place..."))

/datum/quirk/vice/lost_keys
	name = "Lost Keys"
	desc = "You've lost your keys! They're somewhere nearby, and you spawn at a vagrant location."
	point_value = 1
	incompatible_quirks = list(
		/datum/quirk/vice/rough_start,
	)
	preview_render = FALSE

/datum/quirk/vice/lost_keys/on_spawn()
	if(!owner || !ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner

	// Move owner to vagrant spawn first
	var/list/vagrant_spawns = list()
	for(var/obj/effect/landmark/start/adventurerlate/V in GLOB.start_landmarks_list)
		vagrant_spawns += get_turf(V)

	if(length(vagrant_spawns))
		H.forceMove(pick(vagrant_spawns))

	to_chat(H, span_warning("Where did I leave my keys?"))

/datum/quirk/vice/lost_keys/after_job_spawn(datum/job/job)
	if(!owner || !ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner

	// Find all keys on the player
	var/list/found_keys = list()
	for(var/obj/item/key/K in H.get_all_contents())
		found_keys += K

	if(!length(found_keys))
		return

	// Move keys to random nearby location
	var/list/nearby_turfs = list()
	for(var/turf/T in range(20, H))
		if(T.density)
			continue
		nearby_turfs += T

	if(length(nearby_turfs))
		for(var/obj/item/key/K in found_keys)
			var/turf/key_location = pick(nearby_turfs)
			K.forceMove(key_location)

/datum/quirk/vice/nightmares
	name = "Nitemares"
	desc = "You suffer from terrible nitemares. You scream in your sleep and take longer to rest."
	point_value = 1
	var/next_scream = 0

/datum/quirk/vice/nightmares/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, span_info("Nitemares..."))

/datum/quirk/vice/nightmares/on_spawn()
	if(!owner)
		return
	START_PROCESSING(SSobj, src)

/datum/quirk/vice/nightmares/process()
	if(!owner)
		return

	if(owner.stat == UNCONSCIOUS && owner.IsSleeping())
		if(world.time >= next_scream)
			next_scream = world.time + rand(30 SECONDS, 60 SECONDS)
			owner.emote("scream")

/datum/quirk/vice/nightmares/on_remove()
	STOP_PROCESSING(SSobj, src)

/datum/stress_event/darkness
	stress_change = 2
	desc = span_red("I can't see! The darkness is terrifying!")
	timer = 1 MINUTES

/datum/quirk/vice/fear_darkness
	name = "Fear of Darkness"
	desc = "The dark terrifies you. Without light, you panic and lose control."
	point_value = 3
	var/in_darkness = FALSE
	var/next_panic = 0

/datum/quirk/vice/fear_darkness/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, span_info("Scared of the Dark..."))

/datum/quirk/vice/fear_darkness/on_life(mob/living/user)
	if(!owner)
		return

	var/turf/T = get_turf(owner)
	var/light_amount = T?.get_lumcount() || 0

	var/outside = T.can_see_sky()

	var/dark = FALSE
	if(outside)
		if(light_amount < 0.15 && GLOB.tod == "night")
			dark = TRUE
	else if(light_amount < 0.15)
		dark = TRUE

	if(dark)
		if(!in_darkness)
			in_darkness = TRUE
			to_chat(owner, span_userdanger("THE DARKNESS! I CAN'T SEE!"))
			owner.add_stress(/datum/stress_event/darkness)

		if(world.time >= next_panic)
			next_panic = world.time + 8 SECONDS
			owner.emote("scream")
			var/move_dir = pick(GLOB.cardinals)
			step(owner, move_dir)

			owner.add_stress(/datum/stress_event/darkness)
	else
		if(in_darkness)
			in_darkness = FALSE
			to_chat(owner, span_notice("Finally, light! I can breathe again..."))


/datum/quirk/vice/endowed
	name = "Naturally Endowed"
	desc = "I have massive bits... This makes life hard."
	point_value = 2
	revive_reapply = TRUE

/datum/quirk/vice/endowed/on_spawn()
	var/mob/living/carbon/human/H = owner
	H.remove_status_effect(/datum/status_effect/debuff/boobs_quirk)
	H.apply_status_effect(/datum/status_effect/debuff/boobs_quirk)

/datum/quirk/vice/nopouch
	name = "No Pouch"
	desc = "I lost my pouch recently, I'm without a zenny.."
	point_value = 1

/datum/quirk/vice/nopouch/on_spawn()
	var/mob/living/carbon/human/H = owner
	var/obj/item/pouch = locate(/obj/item/storage/belt/pouch) in H
	if(H.wear_neck == pouch)
		H.wear_neck = null
	if(H.beltl == pouch)
		H.beltl = null
	if(H.beltr == pouch)
		H.beltr = null
	qdel(pouch)

/datum/quirk/vice/wild_night
	name = "Wild Night"
	desc = "I don't remember what I did last night, and now I'm lost!"
	point_value = 1

/datum/quirk/vice/wild_night/on_spawn()
	var/mob/living/carbon/human/character = owner
	var/turf/location = get_spawn_turf_for_job("Pilgrim") || get_turf(character)
	if(location)
		character.forceMove(location)
	character.reagents.add_reagent(pick(/datum/reagent/ozium, /datum/reagent/moondust, /datum/reagent/druqks), 15)
	character.reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, 72)
	character.grant_lit_torch()

/datum/quirk/vice/atrophy
	name = "Atrophy"
	desc = "When growing up I could barely feed myself. This has left my body weak and fragile."
	point_value = 6

/datum/quirk/vice/atrophy/on_spawn()
	var/mob/living/carbon/human/H = owner
	H.change_stat("strength", -2)
	H.change_stat("constitution", -2)
	H.change_stat("endurance", -2)

/datum/quirk/vice/monochromatic
	name = "Monochromacy"
	desc = "I see things all gray."
	point_value = 2

/datum/quirk/vice/monochromatic/on_spawn()
	. = ..()
	owner.add_client_colour(/datum/client_colour/monochrome)

/datum/quirk/vice/monochromatic/on_remove()
	. = ..()
	if(owner)
		owner.remove_client_colour(/datum/client_colour/monochrome)

/datum/quirk/vice/no_taste
	name = "Ageusia"
	desc = "I can't taste a thing."
	point_value = 1
	gain_text = span_notice("I can't taste anything!")
	lose_text = span_notice("I can taste again!")

/datum/quirk/vice/no_taste/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	ADD_TRAIT(H, TRAIT_AGEUSIA, "[type]")

/datum/quirk/vice/no_taste/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	ADD_TRAIT(H, TRAIT_AGEUSIA, "[type]")

/datum/quirk/vice/vegetarian
	name = "Vegetarian"
	desc = "I can't eat meat."
	point_value = 1
	gain_text = span_notice("I feel repulsion at the idea of eating meat.")
	lose_text = span_notice("I feel like eating meat isn't that bad.")

/datum/quirk/vice/vegetarian/on_spawn()
	. = ..()
	var/mob/living/carbon/human/H = owner
	var/datum/species/species = H.dna.species
	species.liked_food &= ~MEAT
	species.disliked_food |= MEAT

/datum/quirk/vice/vegetarian/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(H)
		var/datum/species/species = H.dna.species
		if(initial(species.liked_food) & MEAT)
			species.liked_food |= MEAT
		if(!(initial(species.disliked_food) & MEAT))
			species.disliked_food &= ~MEAT

/datum/quirk/vice/blooddeficiency
	name = "Blood Deficiency"
	desc = "My blood is not enough for me, I need to keep it in me."
	point_value = 2
	gain_text = span_danger("I feel my vigor slowly fading away.")
	lose_text = span_notice("I feel vigorous again.")

/datum/quirk/vice/blooddeficiency/on_life()
	var/mob/living/carbon/human/H = owner
	if(NOBLOOD in H.dna.species.species_traits) //can't lose blood if my species doesn't have any
		return
	else
		if (H.blood_volume > (BLOOD_VOLUME_NORMAL - 25)) // just barely survivable without treatment
			H.blood_volume -= 0.275

/datum/quirk/vice/frail
	name = "Frail"
	desc = "My bones are like sticks."
	point_value = 4
	gain_text = span_danger("I feel frail.")
	lose_text = span_notice("I feel sturdy again.")

/datum/quirk/vice/frail/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	ADD_TRAIT(H, TRAIT_EASYLIMBDISABLE, "[type]")

/datum/quirk/vice/frail/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	ADD_TRAIT(H, TRAIT_EASYLIMBDISABLE, "[type]")

/datum/quirk/vice/heavy_sleeper
	name = "Heavy Sleeper"
	desc = "I sleep like a rock."
	point_value = 1
	gain_text = span_danger("I feel sleepy.")
	lose_text = span_notice("I feel awake again.")

/datum/quirk/vice/heavy_sleeper/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	ADD_TRAIT(H, TRAIT_HEAVY_SLEEPER, "[type]")

/datum/quirk/vice/heavy_sleeper/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	ADD_TRAIT(H, TRAIT_HEAVY_SLEEPER, "[type]")

/datum/quirk/vice/light_drinker
	name = "Light Drinker"
	desc = "Even a drop of alcohol knocks me out."
	point_value = 1
	gain_text = span_notice("Just the thought of drinking alcohol makes my head spin.")
	lose_text = span_danger("You're no longer severely affected by alcohol.")

/datum/quirk/vice/light_drinker/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	ADD_TRAIT(H, TRAIT_LIGHT_DRINKER, "[type]")

/datum/quirk/vice/light_drinker/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	ADD_TRAIT(H, TRAIT_LIGHT_DRINKER, "[type]")

/datum/quirk/vice/poor_aim
	name = "Poor Aim"
	desc = "My aim is poor."
	point_value = 1

/datum/quirk/vice/poor_aim/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	ADD_TRAIT(H, TRAIT_POOR_AIM, "[type]")

/datum/quirk/vice/poor_aim/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	ADD_TRAIT(H, TRAIT_POOR_AIM, "[type]")

/datum/quirk/vice/missing_teeth
	name = "Missing Teeth"
	desc = "Years of brawling, bad luck, or bad hygiene have cost you several teeth. You lisp noticeably."
	point_value = 2
	incompatible_quirks = list(
		/datum/quirk/vice/toothless,
	)

/datum/quirk/vice/missing_teeth/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/mouth/jaw = H.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(!jaw)
		return
	var/to_remove = rand(6, 8)
	jaw.remove_teeth(to_remove)
	to_chat(H, span_warning("You run your tongue across the gaps where your teeth used to be."))

/datum/quirk/vice/no_dental
	name = "No Dental"
	desc = "My teeth are loose, brittle, or terribly neglected. A hard blow can send them flying."
	point_value = 2
	incompatible_quirks = list(
		/datum/quirk/vice/toothless,
	)

/datum/quirk/vice/no_dental/on_spawn()
	if(!ishuman(owner))
		return
	to_chat(owner, span_warning("My teeth feel worryingly loose."))

/datum/quirk/vice/toothless
	name = "Toothless"
	desc = "I have no teeth left at all. My speech and bite suffer for it."
	point_value = 3
	incompatible_quirks = list(
		/datum/quirk/vice/missing_teeth,
		/datum/quirk/vice/no_dental,
	)

/datum/quirk/vice/toothless/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/mouth/jaw = H.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(!jaw)
		return
	jaw.remove_teeth(jaw.get_teeth_amount())
	to_chat(H, span_warning("My mouth is completely bare of teeth."))
