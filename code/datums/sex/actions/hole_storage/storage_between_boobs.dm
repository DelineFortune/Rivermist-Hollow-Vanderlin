
/datum/sex_action/hole_storage/boobs_store
	name = "Store items between boobs"
	target_menu_zone_mask = SEX_UI_ZONE_BODY
	hole_id = ORGAN_SLOT_BREASTS

/datum/sex_action/hole_storage/boobs_store/shows_on_menu(mob/living/user, mob/living/target)
	var/obj/item/dildo = user.get_active_held_item()
	if(!target.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_BREASTS, null, dildo))
		return FALSE
	if(!dildo)
		return FALSE
	return TRUE

/datum/sex_action/hole_storage/boobs_store/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/dildo = user.get_active_held_item()
	if(!dildo)
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_BREASTS, null, dildo))
		return FALSE
	if(!can_fit_item_in_hole(target, hole_id, dildo, get_hole_storage_force(user, target)))
		return FALSE
	return TRUE

/datum/sex_action/hole_storage/boobs_store/on_start(mob/living/user, mob/living/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/obj/item/dildo = user.get_active_held_item()

	if(user == target)
		target_organ = user.getorganslot(hole_id)
		to_chat(user, sex_session.spanify_force("I start inserting \the [dildo] between my boobs..."))
	else
		target_organ = target.getorganslot(hole_id)
		user.visible_message(span_warning("[user] starts inserting \the [dildo] between [target]'s boobs..."))

	var/used_sex_volume = sex_volume
	if(user.rogue_sneaking || user.m_intent == MOVE_INTENT_SNEAK || user.alpha <= 100)
		used_sex_volume *= 0.5
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), used_sex_volume, TRUE, ignore_walls = FALSE)


/datum/sex_action/hole_storage/boobs_store/on_perform(mob/living/user, mob/living/target)
	var/pain_amt = 0 //base pain amt to use
	var/self = (user == target)
	if(!target_organ)
		if(self)
			target_organ = user.getorganslot(hole_id)
		else
			target_organ = target.getorganslot(hole_id)

	var/datum/sex_session/sex_session = get_sex_session(user, target)

	var/obj/item/dildo = user.get_active_held_item()
	if(!dildo)
		sex_session.stop_current_action(src)
		return
	var/success = SEND_SIGNAL(target_organ, COMSIG_BODYSTORAGE_TRY_INSERT, dildo, STORAGE_LAYER_INNER, FALSE)
	switch(success)
		if(INSERT_FEEDBACK_OK)
			if(self)
				to_chat(user, sex_session.spanify_force("I stuff \the [dildo] between my boobs..."))
			else
				user.visible_message(sex_session.spanify_force("I stuff \the [dildo] between [target]'s boobs..."))
		if(INSERT_FEEDBACK_ALMOST_FULL)
			if(self)
				to_chat(user, sex_session.spanify_force("I stuff the \the [dildo] between my boobs, seems like they won't fit much more..."))
			else
				user.visible_message(sex_session.spanify_force("I stuff the \the [dildo] between [target]'s boobs, seems like they won't fit much more..."))
		if(INSERT_FEEDBACK_STUFFED, INSERT_FEEDBACK_TRY_FORCE)
			if(self)
				to_chat(user, sex_session.spanify_force("My boobs have too much between them to stuff \the [dildo] in."))
			else
				user.visible_message(sex_session.spanify_force("[target]'s boobs have too much between them to stuff \the [dildo] in."))
			sex_session.stop_current_action(src)
			return
		if(FALSE)
			if(self)
				to_chat(user, sex_session.spanify_force("I fail to stuff \the [dildo] between my boobs."))
			else
				user.visible_message(sex_session.spanify_force("I fail to stuff \the [dildo] between [target]'s boobs."))
			sex_session.stop_current_action(src)
			return

	user.update_inv_hands()
	user.update_a_intents()
	sex_session.perform_sex_action(user, target, 0.5, pain_amt, 0, src)
	sex_session.handle_passive_ejaculation()

/datum/sex_action/hole_storage/boobs_remove //do_time
	name = "Remove items from between boobs"
	target_menu_zone_mask = SEX_UI_ZONE_BODY
	hole_id = ORGAN_SLOT_BREASTS

/datum/sex_action/hole_storage/boobs_remove/shows_on_menu(mob/living/user, mob/living/target)
	if(!target.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_BREASTS))
		return FALSE
	if(user == target)
		target_organ = user.getorganslot(hole_id)
	else
		target_organ = target.getorganslot(hole_id)
	var/list/stored_items = SEND_SIGNAL(target_organ, COMSIG_BODYSTORAGE_GET_LISTS)
	var/list/stored_items_layer = stored_items[STORAGE_LAYER_INNER]
	if(!stored_items_layer.len)
		return FALSE
	return TRUE

/datum/sex_action/hole_storage/boobs_remove/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(user.get_active_held_item())
		return FALSE
	return TRUE

/datum/sex_action/hole_storage/boobs_remove/on_start(mob/living/user, mob/living/target)
	. = ..()
	self = (user == target)

	if(user == target)
		target_organ = user.getorganslot(hole_id)
		to_chat(user, span_warning("I start removing items from between my boobs..."))
	else
		target_organ = target.getorganslot(hole_id)
		user.visible_message(span_warning("[user] starts removing items from between [target]'s boobs..."))

	var/used_sex_volume = sex_volume
	if(user.rogue_sneaking || user.m_intent == MOVE_INTENT_SNEAK || user.alpha <= 100)
		used_sex_volume *= 0.5
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), used_sex_volume, TRUE, ignore_walls = FALSE)


/datum/sex_action/hole_storage/boobs_remove/on_perform(mob/living/user, mob/living/target)
	var/pain_amt = 0 //base pain amt to use

	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/self = (user == target)

	if(!target_organ)
		if(self)
			target_organ = user.getorganslot(hole_id)
		else
			target_organ = target.getorganslot(hole_id)

	var/obj/item/removed_item
	removed_item = SEND_SIGNAL(target_organ, COMSIG_BODYSTORAGE_REMOVE_RAND_ITEM, STORAGE_LAYER_INNER)
	if(!removed_item)
		to_chat(user, sex_session.spanify_force("I couldn't find anything inside..."))
		sex_session.stop_current_action(src)
		return
	if(user.get_active_held_item())
		user.visible_message(sex_session.spanify_force("The [removed_item] falls down on the floor..."))
		removed_item.doMove(get_turf(user))
	else
		if(self)
			to_chat(user, sex_session.spanify_force("I fish out the [removed_item] from between my boobs..."))
		else
			user.visible_message(sex_session.spanify_force("I fish out the [removed_item] from between [target]'s boobs..."))
		removed_item.doMove(get_turf(user))
		user.put_in_active_hand(removed_item)
	sex_session.perform_sex_action(user, target, 0.5, pain_amt, 0, src)
	sex_session.handle_passive_ejaculation()

