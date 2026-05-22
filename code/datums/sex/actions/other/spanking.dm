/datum/sex_action/spanking
	name = "Spank their butt"
	user_menu_zone_mask = SEX_UI_ZONE_ARMS
	target_menu_zone_mask = SEX_UI_ZONE_BODY
	// Allow through all clothes, so no body zone accessibility check for clothing
	check_same_tile = FALSE
	do_time = 2.5 SECONDS // Slightly faster than average for repeated action
	stamina_cost = 0
	requires_free_hands = TRUE

/datum/sex_action/spanking/shows_on_menu(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/spanking/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(!find_available_hand(user))
		return FALSE
	if(user == target)
		return FALSE
	if(!user.Adjacent(target))
		return FALSE
	// No clothing or body zone checks, can always spank
	return TRUE

/datum/sex_action/spanking/on_start(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] positions [user.p_their()] hand to spank [target]'s butt!"))

/datum/sex_action/spanking/on_perform(mob/living/user, mob/living/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/force = sex_session.force
	var/sound = pick('sound/foley/slap.ogg', 'sound/foley/smackspecial.ogg')
	playsound(target, sound, 50, TRUE, -2, ignore_walls = FALSE)

	var/msg = "[user] [sex_session.get_generic_force_adjective()] spanks [target]'s butt."
	if(can_show_action_message(user, target))
		user.visible_message(sex_session.spanify_force(msg))

	// Arousal and pain logic
	var/arousal_amt = 1.2 + (force * 0.5)
	var/pain_amt = 2 * force
	sex_session.perform_sex_action(target, user, arousal_amt, pain_amt, arousal_amt, src)
	sex_session.handle_passive_ejaculation(target)

	// Soreness messaging depending on force
	if(force >= SEX_FORCE_HIGH)
		to_chat(target, span_warning("Your butt is starting to feel sore from the spanking!"))
	else if(force == SEX_FORCE_MID)
		if(prob(30))
			to_chat(target, span_notice("You feel a pleasant sting on your rear."))
	else if(force == SEX_FORCE_LOW)
		if(prob(10))
			to_chat(target, span_notice("A gentle warmth spreads across your buttocks."))

/datum/sex_action/spanking/on_finish(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] stops spanking [target]."))

/datum/sex_action/spanking/lock_sex_object(mob/living/user, mob/living/target)
	var/locked = get_hand_lock_slot(user)
	if(locked)
		add_sex_lock(user, locked)
