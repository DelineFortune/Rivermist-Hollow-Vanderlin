/datum/sex_action/sex/throat
	name = "Fuck their throat"
	target_menu_zone_mask = SEX_UI_ZONE_MOUTH
	hole_id = BODY_ZONE_PRECISE_MOUTH
	stamina_cost = 1.0
	gags_target = TRUE
	requires_hole_storage = FALSE

/datum/sex_action/sex/throat/shows_on_menu(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/sex/throat/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(check_sex_lock(user, ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/sex/throat/on_start(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] slides [user.p_their()] cock into [target]'s throat!"))
	var/used_sex_volume = sex_volume
	if(user.rogue_sneaking || user.m_intent == MOVE_INTENT_SNEAK || user.alpha <= 100)
		used_sex_volume *= 0.5
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), used_sex_volume, TRUE, ignore_walls = FALSE)

/datum/sex_action/sex/throat/on_perform(mob/living/user, mob/living/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	if(can_show_action_message(user, target))
		user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fucks [target]'s throat."))
	playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)
	do_thrust_animate(user, target)

	sex_session.perform_sex_action(user, target, 2, 0, 2.5, src)

	if(sex_session.considered_limp(user))
		sex_session.perform_sex_action(target, user, 0.2, 2, 0.2, src)
	else
		var/oxyloss = 1.3
		sex_session.perform_sex_action(target, user, 0.5, 7, 0.5, src)
		sex_session.perform_deepthroat_oxyloss(target, oxyloss)
		if(sex_session.get_current_force() >= SEX_FORCE_HIGH)
			var/choker_snap_chance = 5
			if(sex_session.get_current_force() >= SEX_FORCE_EXTREME)
				choker_snap_chance = 15
			if(prob(choker_snap_chance))
				target.snap_worn_choker(user)
	sex_session.handle_passive_ejaculation()

/datum/sex_action/sex/throat/handle_climax_message(mob/living/user, mob/living/target, must_flip)
	if(must_flip)
		user.visible_message(span_love("[user] shudders in orgasm from being throatfucked!"))
		user.lose_virginity()
		return ORGASM_LOCATION_SELF
	else
		user.visible_message(span_love("[user] cums into [target]'s throat!"))
		user.lose_virginity()
		return ORGASM_LOCATION_ORAL


/datum/sex_action/sex/throat/on_finish(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] pulls [user.p_their()] cock out of [target]'s throat."))
