/datum/sex_action/facesitting
	name = "Sit on their face"
	user_menu_zone_mask = SEX_UI_ZONE_GENITALS | SEX_UI_ZONE_MISC
	target_menu_zone_mask = SEX_UI_ZONE_MOUTH
	gags_target = TRUE

/datum/sex_action/facesitting/shows_on_menu(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/facesitting/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	// Need to stand up
	if(user.resting)
		return FALSE
	// Target can't stand up
	if(!target.resting)
		return FALSE
	if(check_sex_lock(target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(check_sex_lock(user, ORGAN_SLOT_ANUS))
		return FALSE
	return TRUE

/datum/sex_action/facesitting/on_start(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] sits [user.p_their()] butt on [target]'s face!"))

/datum/sex_action/facesitting/on_perform(mob/living/user, mob/living/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/verbstring = pick(list("rubs", "smushes", "forces"))
	if(can_show_action_message(user, target))
		user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] [verbstring] [user.p_their()] butt against [target] face."))
	target.make_sucking_noise()
	do_thrust_animate(user, target)

	sex_session.perform_sex_action(user, target, 1, 3, 1, src)
	sex_session.handle_passive_ejaculation()

	sex_session.perform_sex_action(target, user, 0.5, 2, 0, src)
	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/facesitting/on_finish(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] gets off [target]'s face."))

/datum/sex_action/facesitting/lock_sex_object(mob/living/user, mob/living/target)
	add_sex_lock(target, BODY_ZONE_PRECISE_MOUTH, null, FALSE)
	add_sex_lock(user, ORGAN_SLOT_ANUS, null, FALSE)
