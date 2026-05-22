/datum/sex_action/wax_play
	abstract_type = /datum/sex_action/wax_play
	name = "Wax Play"
	continous = FALSE
	do_time = 2.5 SECONDS
	stamina_cost = 0.2
	requires_free_hands = TRUE

/datum/sex_action/wax_play/proc/get_held_lit_candle(mob/living/user)
	var/obj/item/held_item = user.get_active_held_item()
	if(istype(held_item, /obj/item/candle))
		var/obj/item/candle/candle = held_item
		if(candle.lit)
			return candle
	held_item = user.get_inactive_held_item()
	if(istype(held_item, /obj/item/candle))
		var/obj/item/candle/candle = held_item
		if(candle.lit)
			return candle
	return null

/datum/sex_action/wax_play/proc/get_candle_hand_lock(mob/living/user)
	var/obj/item/held_item = user.get_active_held_item()
	if(istype(held_item, /obj/item/candle))
		var/obj/item/candle/candle = held_item
		if(candle.lit)
			return user.get_active_precise_hand()
	held_item = user.get_inactive_held_item()
	if(istype(held_item, /obj/item/candle))
		var/obj/item/candle/candle = held_item
		if(candle.lit)
			if(user.get_active_precise_hand() == BODY_ZONE_PRECISE_L_HAND)
				return BODY_ZONE_PRECISE_R_HAND
			return BODY_ZONE_PRECISE_L_HAND
	return null

/datum/sex_action/wax_play/shows_on_menu(mob/living/user, mob/living/target)
	if(!get_held_lit_candle(user))
		return FALSE
	return TRUE

/datum/sex_action/wax_play/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/candle/candle = get_held_lit_candle(user)
	if(!candle)
		return FALSE
	var/candle_hand = get_candle_hand_lock(user)
	if(candle_hand && check_sex_lock(user, candle_hand))
		return FALSE
	if(check_sex_lock(user, null, candle))
		return FALSE
	return TRUE

/datum/sex_action/wax_play/proc/apply_wax_effects(mob/living/user, mob/living/target, text_target, arousal_base, pain_base)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	if(can_show_action_message(user, target))
		user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] drips hot wax over [target]'s [text_target]."))

	var/arousal_amt = arousal_base + (sex_session.force * 0.4)
	var/pain_amt = pain_base + (sex_session.force * 1.5)
	sex_session.perform_sex_action(target, user, arousal_amt, pain_amt, arousal_amt, src)
	sex_session.handle_passive_ejaculation(target)

	var/obj/item/candle/candle = get_held_lit_candle(user)
	if(candle && !candle.infinite && candle.wax > 0)
		candle.wax = max(candle.wax - 5, 0)
		candle.update_appearance(UPDATE_ICON_STATE)

/datum/sex_action/wax_play/breasts
	name = "Pour wax on breasts"
	user_menu_zone_mask = SEX_UI_ZONE_ARMS
	target_menu_zone_mask = SEX_UI_ZONE_BODY

/datum/sex_action/wax_play/breasts/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_CHEST, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/wax_play/breasts/on_start(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] tilts the candle over [target]'s chest..."))

/datum/sex_action/wax_play/breasts/on_perform(mob/living/user, mob/living/target)
	. = ..()
	apply_wax_effects(user, target, "breasts", 1.2, 2.5)

/datum/sex_action/wax_play/breasts/on_finish(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] stops dripping wax onto [target]."))

/datum/sex_action/wax_play/breasts/lock_sex_object(mob/living/user, mob/living/target)
	var/obj/item/candle/candle = get_held_lit_candle(user)
	var/candle_hand = get_candle_hand_lock(user)
	if(candle_hand)
		add_sex_lock(user, candle_hand)
	if(candle)
		add_sex_lock(user, null, candle)

/datum/sex_action/wax_play/butt
	name = "Pour wax on butt"
	user_menu_zone_mask = SEX_UI_ZONE_ARMS
	target_menu_zone_mask = SEX_UI_ZONE_BODY

/datum/sex_action/wax_play/butt/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/wax_play/butt/on_start(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] tilts the candle over [target]'s rear..."))

/datum/sex_action/wax_play/butt/on_perform(mob/living/user, mob/living/target)
	. = ..()
	apply_wax_effects(user, target, "butt", 1.0, 2.0)

/datum/sex_action/wax_play/butt/on_finish(mob/living/user, mob/living/target)
	. = ..()
	user.visible_message(span_warning("[user] stops dripping wax onto [target]."))

/datum/sex_action/wax_play/butt/lock_sex_object(mob/living/user, mob/living/target)
	var/obj/item/candle/candle = get_held_lit_candle(user)
	var/candle_hand = get_candle_hand_lock(user)
	if(candle_hand)
		add_sex_lock(user, candle_hand)
	if(candle)
		add_sex_lock(user, null, candle)
