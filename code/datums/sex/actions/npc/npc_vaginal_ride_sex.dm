/datum/sex_action/npc/npc_vaginal_ride_sex
	name = "NPC Ride them"
	stamina_cost = 0
	check_same_tile = FALSE
	hole_id = ORGAN_SLOT_VAGINA

/datum/sex_action/npc/npc_vaginal_ride_sex/shows_on_menu(mob/living/user, mob/living/target)
	return FALSE

/datum/sex_action/npc/npc_vaginal_ride_sex/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/npc/npc_vaginal_ride_sex/on_start(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] gets on top of [target] and begins riding [target.p_them()] with [user.p_their()] cunt!"))
	var/used_sex_volume = sex_volume
	if(user.rogue_sneaking || user.m_intent == MOVE_INTENT_SNEAK || user.alpha <= 100)
		used_sex_volume *= 0.5
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), used_sex_volume, TRUE, ignore_walls = FALSE)

/datum/sex_action/npc/npc_vaginal_ride_sex/on_perform(mob/living/user, mob/living/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	if(can_show_action_message(user, target))
		user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] rides [target]."))
	var/used_sex_volume = sex_volume
	if(user.rogue_sneaking || user.m_intent == MOVE_INTENT_SNEAK || user.alpha <= 100)
		used_sex_volume *= 0.5
	playsound(target, sex_session.get_force_sound(), used_sex_volume, TRUE, -2, ignore_walls = FALSE)
	do_thrust_animate(user, target)

	if(user.has_kink(KINK_ONOMATOPOEIA))
		do_onomatopoeia(user)

	if(sex_session.considered_limp(target))
		sex_session.perform_sex_action(target, user, 1.2, 3, 1.2, src)
	else
		sex_session.perform_sex_action(target, user, 2.4, 7, 2.4, src)
	sex_session.handle_passive_ejaculation(target)

	sex_session.perform_sex_action(user, target, 2, 4, 3, src)

/datum/sex_action/npc/npc_vaginal_ride_sex/handle_climax_message(mob/living/user, mob/living/target, must_flip)
	if(must_flip)
		user.visible_message(span_love("[user] cums into [target]'s pussy!"))
		user.lose_virginity()
		target.lose_virginity()
		return ORGASM_LOCATION_INTO
	else
		user.visible_message(span_love("[user] creams themselves around [target]'s dick!"))
		user.lose_virginity()
		target.lose_virginity()
		return ORGASM_LOCATION_ONTO

/datum/sex_action/npc/npc_vaginal_ride_sex/on_finish(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] gets off [target]."))
