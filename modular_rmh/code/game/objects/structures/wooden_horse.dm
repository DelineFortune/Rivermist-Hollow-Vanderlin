/obj/structure/wooden_horse
	name = "wooden horse"
	desc = "This tireless steed promises a less than pleasant journey, should you dare to ride it."
	icon = 'modular_rmh/icons/obj/structures/wooden_horse.dmi'
	icon_state = "wooden_horse"
	attacked_sound = "woodimpact"
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	blade_dulling = DULLING_BASHCHOP

	anchored = TRUE
	density = TRUE
	layer = OBJ_LAYER
	plane = GAME_PLANE

	can_buckle = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0
	buckle_prevents_pull = TRUE

	max_integrity = 250
	resistance_flags = NONE
	debris = list(/obj/item/natural/wood/plank = 1)

	var/pain_per_tick = 8
	var/next_flavor_time = 0
	var/next_reaction_time = 0

/obj/structure/wooden_horse/Initialize(mapload)
	. = ..()
	LAZYINITLIST(buckled_mobs)
	AddComponent(/datum/component/simple_rotation)
	handle_layer()

/obj/structure/wooden_horse/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/wooden_horse/setDir(newdir)
	. = ..()
	handle_rotation(newdir)

/obj/structure/wooden_horse/proc/handle_rotation(direction)
	handle_layer()
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.setDir(direction)

/obj/structure/wooden_horse/proc/handle_layer()
	// Mob goes behind the object
	if(dir == NORTH || dir == SOUTH)
		layer = ABOVE_MOB_LAYER
		plane = GAME_PLANE_UPPER
	// Mob sits on top of the object
	else
		layer = OBJ_LAYER
		plane = GAME_PLANE

/obj/structure/wooden_horse/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)

	if(!anchored && !istype(src, /obj/structure/wooden_horse/mobile))
		return FALSE

	if(force)
		return ..()

	if(!istype(M, /mob/living/carbon/human))
		to_chat(usr, span_warning("It doesn't look like [M.p_they()] can fit onto this properly!"))
		return FALSE

	// If we are NOT buckling ourselves, we need restraints (chains/grabs)
	if(M != usr)
		var/valid_restraint = FALSE
		var/mob/living/carbon/carbon = M

		if(carbon.handcuffed)
			valid_restraint = TRUE

		if(!valid_restraint)
			for(var/obj/item/grabbing/G in M.grabbedby)
				if(G.grab_state >= GRAB_AGGRESSIVE)
					valid_restraint = TRUE
					break

		if(!valid_restraint)
			to_chat(usr, span_warning("I must grab them more forcefully or handcuff them to put them on [src]."))
			return FALSE

		M.visible_message(span_danger("[usr] starts strapping [M] onto [src]!"), \
						span_userdanger("[usr] starts strapping you onto [src]!"))

		if(!do_after(usr, 5 SECONDS, src))
			return FALSE

	// If we ARE buckling ourselves, we skip restraint checks
	else
		M.visible_message(span_notice("[usr] starts climbing onto [src]..."), \
						span_notice("You start climbing onto [src]..."))
		if(!do_after(usr, 3 SECONDS, src))
			return FALSE

	return ..(M, force, FALSE)

/obj/structure/wooden_horse/post_buckle_mob(mob/living/M)
	. = ..()
	handle_layer()
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 14)
	START_PROCESSING(SSobj, src)

/obj/structure/wooden_horse/post_unbuckle_mob(mob/living/M)
	. = ..()
	if(!buckled_mobs.len)
		STOP_PROCESSING(SSobj, src)

	handle_layer()
	M.regenerate_icons()
	M.reset_offsets("bed_buckle")


/obj/structure/wooden_horse/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	if(user != buckled_mob)
		user.visible_message(
			span_notice("[user] starts unstrapping [buckled_mob] from [src]..."),
			span_notice("You start unstrapping [buckled_mob] from [src]..."))
		if(do_after(user, 3 SECONDS, src))
			return ..()
		return

	to_chat(user, span_warning("You struggle against the tight straps..."))

	var/arousal = rand(0,2)
	var/pain = rand(1,3)
	var/climax = rand(0,1)
	SEND_SIGNAL(buckled_mob, COMSIG_SEX_GENERIC_ACTION, user, arousal, pain, climax)

	// Strength roll
	var/roll = rand(1,20)
	var/bonus = floor((user.get_stat(STATKEY_STR)-10)/2)
	var/total = roll + bonus
	if(total < 10)
		user.visible_message(
			span_warning("[user] struggles but fails to loosen the straps."),
			span_warning("You fail to free yourself from the straps."))
		return

	if(do_after(user, 10 SECONDS, src))
		if(prob(50))
			user.visible_message(
				span_warning("[user] manages to unstrap [user.p_them()]self from [src]!"),
				span_notice("You manage to unstrap yourself from [src]!"))
			return ..()

		user.visible_message(
			span_warning("[user] struggles but fails to loosen the straps."),
			span_warning("You fail to free yourself from the straps."))

/obj/structure/wooden_horse/process(delta_time)
	..()

	if(!has_buckled_mobs())
		return

	for(var/mob/living/M in buckled_mobs)

		if(!iscarbon(M))
			continue

		var/mob/living/carbon/victim = M
		var/pain = pain_per_tick * delta_time
		var/arousal = rand(1,3) * delta_time
		SEND_SIGNAL(victim, COMSIG_SEX_GENERIC_ACTION, victim, arousal, pain, 0)

		if(world.time >= next_reaction_time)
			next_reaction_time = world.time + 2 MINUTES

			if(pain >= 8 && prob(70))
				victim.visible_message(
					span_danger("[victim] grimaces as the [name] painfully presses into them."),
					span_danger("A sharp pain shoots through your body from the [name]."))

			else if(pain >= 4 && prob(50))
				victim.visible_message(
					span_danger("[victim] shifts uncomfortably on the [name]."),
					span_danger("You feel an uncomfortable pressure from the [name]."))

			if(pain >= 2 && prob(30))
				victim.visible_message(
					span_danger("[victim] squirms slightly on the [name]."),
					span_danger("Your body reacts involuntarily to the stimulation."))

		if(world.time >= next_flavor_time)
			next_flavor_time = world.time + 2 MINUTES
			if(prob(60)) // only 60% chance to spam flavor
				to_chat(victim, span_danger("The ridge of the [name] digs into your nethers."))

/obj/structure/wooden_horse/attack_hand_secondary(mob/living/user, list/modifiers)
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!has_buckled_mobs())
		to_chat(user, span_warning("Swinging the horse achieves nothing with no one riding it."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	for(var/mob/living/M in buckled_mobs)
		var/mob/living/carbon/human/H = M

		if(user == M)
			to_chat(user, span_notice("You rock the [src] back and forth with your body!"))
			H.visible_message(
				span_danger("[M] swings themselves on the [src]!"),
				span_notice("You feel the [src] shift beneath you as you move!")
			)
		else
			to_chat(user, span_notice("You push and sway the [src] with [M] on it!"))
			H.visible_message(
				span_danger("[M] is pushed and jolted on the [src]!"),
				span_notice("You are jolted as the [src] moves under [user]'s hands!"))

		var/arousal = rand(1,3)
		var/pain = rand(1,5)
		var/climax = rand(0,1)
		SEND_SIGNAL(H, COMSIG_SEX_GENERIC_ACTION, user, arousal, pain, climax)
		playsound(src, pick('modular_rmh/sound/effects/swing_horse (1).ogg', 'modular_rmh/sound/effects/swing_horse (2).ogg', 'modular_rmh/sound/effects/swing_horse (3).ogg'), 100)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/wooden_horse/mobile
	name = "wooden horse"
	desc = "An affordable means of transportation for all walks of life, though few wish to ride. Watching the galloping of unlucky riders is one of the favorite pastimes of local nobility."
	icon = 'modular_rmh/icons/obj/structures/wooden_horse.dmi'
	icon_state = "wooden_horse_mobile"
	anchored = FALSE
	drag_slowdown = 0.4
	facepull = FALSE
	throw_range = 1

/obj/structure/wooden_horse/mobile/handle_layer()
	// Mob goes behind the object
	if(dir == SOUTH)
		layer = ABOVE_MOB_LAYER
		plane = GAME_PLANE_UPPER
	// Mob sits on top of the object
	else
		layer = OBJ_LAYER
		plane = GAME_PLANE

/obj/structure/wooden_horse/small
	icon_state = "wooden_horse_small"

/obj/structure/wooden_horse/small/post_buckle_mob(mob/living/M)
	. = ..()
	handle_layer()
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 4)
	START_PROCESSING(SSobj, src)


/obj/structure/wooden_horse/metal
	icon_state = "wooden_horse_metal"

/obj/structure/wooden_horse/metal/post_buckle_mob(mob/living/M)
	. = ..()
	handle_layer()
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 6)
	START_PROCESSING(SSobj, src)
