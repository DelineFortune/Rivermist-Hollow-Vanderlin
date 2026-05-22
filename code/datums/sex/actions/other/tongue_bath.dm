/datum/sex_action/tonguebath
	name = "Bathe with tongue"
	user_menu_zone_mask = SEX_UI_ZONE_MOUTH
	target_menu_zone_mask = SEX_UI_ZONE_BODY

/datum/sex_action/tonguebath/shows_on_menu(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/tonguebath/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	if(!check_location_accessible(target, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(check_sex_lock(user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/tonguebath/on_start(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] sticks [user.p_their()] tongue out, getting close to [target]..."))

/datum/sex_action/tonguebath/on_perform(mob/living/user, mob/living/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	if(can_show_action_message(user, target))
		user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] bathes [target]'s body with [user.p_their()] tongue..."))
	user.make_sucking_noise()

	sex_session.perform_sex_action(target, user, 0.5, 0, 0,5, src)
	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/tonguebath/on_finish(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] stops bathing [target]'s body ..."))

/datum/sex_action/tonguebath/lock_sex_object(mob/living/user, mob/living/target)
	sex_locks |= new /datum/sex_session_lock(user, BODY_ZONE_PRECISE_MOUTH)
