/datum/sex_action/masturbate/other/breasts
	name = "Rub their breasts"
	target_menu_zone_mask = SEX_UI_ZONE_BODY

/datum/sex_action/masturbate/other/breasts/shows_on_menu(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/breasts/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_CHEST, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate/other/breasts/on_start(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] starts rubbing [target]'s breasts..."))

/datum/sex_action/masturbate/other/breasts/on_perform(mob/living/user, mob/living/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	if(can_show_action_message(user, target))
		user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] fondles [target]'s breasts..."))

	sex_session.perform_sex_action(user, target, 1, 4, 0.1, src)
	sex_session.handle_passive_ejaculation()

/datum/sex_action/masturbate/other/breasts/on_finish(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] stops fondling [target]'s breasts."))
