/area/pocket_dimension/werewolf_lair_trap
	name = "Werewolf Lair Trap"

/datum/map_template/pocket/werewolf_lair_trap
	name = "Werewolf Lair Trap"
	id = "pocket_werewolf_lair_trap"
	mappath = "_maps/templates/pockets/pocket_werewolf_lair_trap.dmm"
	instance_type = /datum/pocket_dimension/trap/werewolf
	exit_structure_type = /obj/structure/pocket_dimension_exit/hole
	lifecycle_policy = POCKET_LIFECYCLE_KEEP_LOADED

/datum/pocket_dimension/trap/werewolf
	orgasm_trigger_count = WW_TRAP_ORGASM_TRIGGER
	time_trigger_delay = WW_TRAP_TIME_TRIGGER
	trigger_on_soft_crit = TRUE
	trigger_on_hard_crit = TRUE
	reset_cooldown = WW_TRAP_RESET_COOLDOWN
	captive_release_mode = TRAP_RELEASE_OWNER_ONLY

/datum/pocket_dimension/trap/werewolf/get_captive_exit_denial_message(mob/user)
	return "The moon pit holds me fast. Only the lair's owner can draw me back out."

/obj/structure/werewolf_lair_trap_maw
	name = "moon pit"
	desc = "A deeper sinkhole gnawed out beneath the lair. The air inside smells of wet stone, old fear, and patient hunger."
	icon = 'icons/turf/floors.dmi'
	icon_state = "hole2"
	anchored = TRUE
	density = TRUE
	pixel_y = 5
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/werewolf_lair_trap_maw/Destroy()
	if(SSpocket_dimensions)
		SSpocket_dimensions.delete_instance(get_trap_instance_key(), "The moon pit spits everything back into the lair!")
	return ..()

/obj/structure/werewolf_lair_trap_maw/attack_hand(mob/user, list/modifiers)
	. = ..()
	try_enter_owner(user)

/obj/structure/werewolf_lair_trap_maw/attack_hand_secondary(mob/user, list/modifiers)
	if(!can_owner_use_trap(user, TRUE))
		return ..()

	show_release_menu(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/werewolf_lair_trap_maw/attackby(obj/item/attacking_item, mob/living/user, list/modifiers)
	if(istype(attacking_item, /obj/item/grabbing))
		var/obj/item/grabbing/grab_item = attacking_item
		if(handle_grabbed_entry(user, grab_item))
			return TRUE

	return ..()

/obj/structure/werewolf_lair_trap_maw/examine(mob/user)
	. = ..()
	var/datum/antagonist/werewolf/owner_werewolf = get_owner_werewolf()
	if(!owner_werewolf)
		. += span_warning("The moon pit has gone dead and still.")
		return .

	var/obj/structure/werewolf_lair_entrance/lair_entrance = get_main_lair_entrance()
	if(lair_entrance?.is_owner_werewolf(user, owner_werewolf))
		var/datum/pocket_dimension/trap/werewolf/trap_pocket = get_trap_pocket_instance()
		var/list/forced_captives = trap_pocket?.get_forced_captives() || list()
		. += span_notice("Grab and shove victims into the pit. Right-click it to release captives back into the lair.")
		. += span_notice("Current captives: [length(forced_captives)].")

/obj/structure/werewolf_lair_trap_maw/proc/get_main_lair_entrance()
	var/area/pocket_dimension/pocket_area = get_area(src)
	if(!istype(pocket_area))
		return null

	var/datum/pocket_dimension/main_lair_pocket = pocket_area.linked_pocket
	if(!main_lair_pocket)
		return null

	var/obj/structure/werewolf_lair_entrance/lair_entrance = main_lair_pocket.get_pocket_holder()
	if(!istype(lair_entrance))
		return null

	return lair_entrance

/obj/structure/werewolf_lair_trap_maw/proc/get_owner_werewolf()
	var/obj/structure/werewolf_lair_entrance/lair_entrance = get_main_lair_entrance()
	return lair_entrance?.get_owner_werewolf()

/obj/structure/werewolf_lair_trap_maw/proc/get_trap_instance_key()
	return "werewolf_lair_trap::[REF(src)]"

/obj/structure/werewolf_lair_trap_maw/proc/get_trap_pocket_instance()
	var/datum/pocket_dimension/trap/werewolf/trap_pocket = SSpocket_dimensions?.get_instance(get_trap_instance_key())
	return trap_pocket

/obj/structure/werewolf_lair_trap_maw/proc/get_or_create_trap_pocket_instance()
	var/datum/pocket_dimension/trap/werewolf/trap_pocket = SSpocket_dimensions?.get_or_create_instance(get_trap_instance_key(), /datum/map_template/pocket/werewolf_lair_trap, POCKET_LIFECYCLE_KEEP_LOADED, 0, src)
	return trap_pocket

/obj/structure/werewolf_lair_trap_maw/proc/can_owner_use_trap(mob/living/user, show_feedback = FALSE)
	var/datum/antagonist/werewolf/owner_werewolf = get_owner_werewolf()
	if(!owner_werewolf)
		if(show_feedback)
			to_chat(user, span_warning("The moon pit has gone dead and still."))
		return FALSE
	if(!istype(user))
		return FALSE
	if(!user.Adjacent(src))
		if(show_feedback)
			to_chat(user, span_warning("I need to stand by the moon pit first."))
		return FALSE
	var/obj/structure/werewolf_lair_entrance/lair_entrance = get_main_lair_entrance()
	if(lair_entrance?.is_owner_werewolf(user, owner_werewolf))
		return TRUE
	if(show_feedback)
		to_chat(user, span_warning("Only the lair's owner can command the moon pit."))
	return FALSE

/obj/structure/werewolf_lair_trap_maw/proc/try_enter_owner(mob/living/user)
	if(!can_owner_use_trap(user, TRUE))
		return FALSE

	var/datum/pocket_dimension/trap/werewolf/trap_pocket = get_or_create_trap_pocket_instance()
	if(!trap_pocket)
		to_chat(user, span_warning("The moon pit refuses to open right now."))
		return FALSE

	to_chat(user, span_notice("I descend into the moon pit."))
	return trap_pocket.enter_mob(user, get_turf(src), src)

/obj/structure/werewolf_lair_trap_maw/proc/handle_grabbed_entry(mob/living/user, obj/item/grabbing/grab_item)
	if(!istype(user) || !istype(grab_item))
		return FALSE
	if(user.used_intent.type != /datum/intent/grab/move && user.used_intent.type != /datum/intent/grab/shove)
		return FALSE
	if(!can_owner_use_trap(user, TRUE))
		return FALSE

	var/mob/living/victim = grab_item.grabbed
	if(!istype(victim))
		to_chat(user, span_warning("Only living prey can be forced into the moon pit."))
		return TRUE

	var/follow_inside = user.used_intent.type == /datum/intent/grab/move
	if(!force_movable_inside(user, victim, follow_inside))
		return TRUE

	user.stop_pulling()
	qdel(grab_item)
	return TRUE

/obj/structure/werewolf_lair_trap_maw/proc/force_movable_inside(mob/living/user, atom/movable/movable, follow_inside = FALSE)
	if(!movable || QDELETED(movable))
		return FALSE

	var/datum/pocket_dimension/trap/werewolf/trap_pocket = get_or_create_trap_pocket_instance()
	if(!trap_pocket)
		to_chat(user, span_warning("The moon pit refuses to open right now."))
		return FALSE

	var/turf/entrance_turf = get_turf(src)
	if(!trap_pocket.send_movable_inside(movable, entrance_turf, null, src))
		to_chat(user, span_warning("[movable] won't fit through the moon pit."))
		return FALSE

	var/mob/living/victim = movable
	if(istype(victim))
		trap_pocket.arm_forced_captive(victim, src, src)
		var/datum/antagonist/werewolf/owner_werewolf = get_owner_werewolf()
		owner_werewolf?.record_trapped_target(victim)
		log_combat(user, victim, follow_inside ? "dragged into a werewolf moon pit" : "shoved into a werewolf moon pit")

	if(follow_inside && !trap_pocket.enter_mob(user, entrance_turf, src))
		to_chat(user, span_warning("The moon pit takes [movable], but bars my way."))
		return FALSE

	user.visible_message(
		span_warning("[user] [follow_inside ? "drags" : "shoves"] [movable] into [src]!"),
		span_notice("I [follow_inside ? "drag" : "shove"] [movable] into [src]."),
	)
	return TRUE

/obj/structure/werewolf_lair_trap_maw/proc/show_release_menu(mob/living/user)
	var/datum/pocket_dimension/trap/werewolf/trap_pocket = get_trap_pocket_instance()
	if(!trap_pocket)
		to_chat(user, span_notice("The moon pit is empty."))
		return FALSE

	var/list/forced_captives = trap_pocket.get_forced_captives()
	if(!length(forced_captives))
		to_chat(user, span_notice("Nothing is trapped in the moon pit right now."))
		return FALSE

	var/list/display_names = list()
	var/list/captive_lookup = list()
	for(var/mob/living/captive as anything in forced_captives)
		var/display_name = "[captive.real_name || captive.name]"
		while(display_name in captive_lookup)
			display_name += " *"
		display_names += display_name
		captive_lookup[display_name] = captive

	var/choice = browser_input_list(user, "Choose who to release back into the lair.", "Moon Pit", display_names)
	if(!choice)
		return FALSE
	if(!can_owner_use_trap(user))
		return FALSE

	var/mob/living/captive = captive_lookup[choice]
	if(!istype(captive))
		return FALSE
	if(!trap_pocket.release_captive(captive, get_turf(src), "The moon pit spits me back into the lair."))
		to_chat(user, span_warning("The moon pit refuses to release [captive] right now."))
		return FALSE

	user.visible_message(
		span_notice("[src] spits [captive] back into the lair."),
		span_notice("I release [captive] from the moon pit."),
	)
	return TRUE
