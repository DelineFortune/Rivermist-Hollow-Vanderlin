#define DND_SPELL_SLOT_MIN 1
#define DND_SPELL_SLOT_MAX 5
#define DND_SPELL_SLOT_ICON_MAX 4
#define DND_SHORT_REST_MAX_CHARGES 2

/mob/living/carbon/human
	var/selected_dnd_spell_slot_level = DND_SPELL_SLOT_MIN
	var/list/dnd_spell_slots_max
	var/list/dnd_spell_slots_current
	var/list/dnd_spell_slot_hud_buttons
	var/dnd_short_rest_max = DND_SHORT_REST_MAX_CHARGES
	var/dnd_short_rest_current = DND_SHORT_REST_MAX_CHARGES
	var/dnd_spell_slots_collapsed = FALSE
	var/atom/movable/screen/dnd_short_rest_hud/dnd_short_rest_hud_button
	var/atom/movable/screen/dnd_spell_slots_toggle_hud/dnd_spell_slots_toggle_hud_button

/mob/living/carbon/human/proc/setup_dnd_spell_slots(list/slot_table)
	if(!slot_table)
		return FALSE

	dnd_spell_slots_max = list()
	dnd_spell_slots_current = list()

	for(var/level_key in slot_table)
		var/slot_level = text2num("[level_key]")
		if(!slot_level)
			continue

		slot_level = clamp(round(slot_level), DND_SPELL_SLOT_MIN, DND_SPELL_SLOT_MAX)

		var/amount = slot_table[level_key]
		if(!isnum(amount))
			continue

		amount = clamp(round(amount), 0, DND_SPELL_SLOT_ICON_MAX)

		var/key = num2text(slot_level)
		dnd_spell_slots_max[key] = amount
		dnd_spell_slots_current[key] = amount

	update_dnd_spell_slot_hud()
	return TRUE

/mob/living/carbon/human/proc/setup_default_dnd_spell_slots()
	var/list/default_slots = list()
	default_slots["1"] = 4
	default_slots["2"] = 3
	default_slots["3"] = 3
	default_slots["4"] = 2
	default_slots["5"] = 1

	setup_dnd_spell_slots(default_slots)
	dnd_short_rest_max = DND_SHORT_REST_MAX_CHARGES
	dnd_short_rest_current = DND_SHORT_REST_MAX_CHARGES
	update_dnd_short_rest_hud()
	update_dnd_spell_slots_toggle_hud()
	return TRUE

/mob/living/carbon/human/proc/restore_all_dnd_spell_slots()
	if(!dnd_spell_slots_max)
		setup_default_dnd_spell_slots()
		return TRUE

	if(!dnd_spell_slots_current)
		dnd_spell_slots_current = list()

	for(var/key in dnd_spell_slots_max)
		dnd_spell_slots_current[key] = dnd_spell_slots_max[key]

	dnd_short_rest_current = dnd_short_rest_max

	update_dnd_spell_slot_hud()
	update_dnd_short_rest_hud()
	update_dnd_spell_slots_toggle_hud()
	return TRUE

/mob/living/carbon/human/proc/get_selected_dnd_spell_slot_level()
	if(!isnum(selected_dnd_spell_slot_level))
		selected_dnd_spell_slot_level = DND_SPELL_SLOT_MIN

	return clamp(round(selected_dnd_spell_slot_level), DND_SPELL_SLOT_MIN, DND_SPELL_SLOT_MAX)

/mob/living/carbon/human/proc/get_dnd_spell_slots_current(level)
	if(!dnd_spell_slots_current)
		return 0

	var/key = num2text(round(level))
	var/amount = dnd_spell_slots_current[key]

	if(!isnum(amount))
		return 0

	return clamp(round(amount), 0, DND_SPELL_SLOT_ICON_MAX)

/mob/living/carbon/human/proc/get_dnd_spell_slots_max(level)
	if(!dnd_spell_slots_max)
		return 0

	var/key = num2text(round(level))
	var/amount = dnd_spell_slots_max[key]

	if(!isnum(amount))
		return 0

	return clamp(round(amount), 0, DND_SPELL_SLOT_ICON_MAX)

/mob/living/carbon/human/proc/get_dnd_short_rest_current()
	if(!isnum(dnd_short_rest_current))
		dnd_short_rest_current = DND_SHORT_REST_MAX_CHARGES

	return clamp(round(dnd_short_rest_current), 0, DND_SHORT_REST_MAX_CHARGES)

/mob/living/carbon/human/proc/get_dnd_short_rest_max()
	if(!isnum(dnd_short_rest_max))
		dnd_short_rest_max = DND_SHORT_REST_MAX_CHARGES

	return clamp(round(dnd_short_rest_max), 0, DND_SHORT_REST_MAX_CHARGES)

/mob/living/carbon/human/proc/can_spend_dnd_spell_slot(level, feedback = TRUE)
	level = clamp(round(level), DND_SPELL_SLOT_MIN, DND_SPELL_SLOT_MAX)

	if(!dnd_spell_slots_max || !dnd_spell_slots_current)
		setup_default_dnd_spell_slots()

	if(get_dnd_spell_slots_max(level) <= 0)
		if(feedback)
			to_chat(src, span_warning("I have no level [level] spell slots."))
			balloon_alert(src, "No level [level] slots!")
		return FALSE

	if(get_dnd_spell_slots_current(level) <= 0)
		if(feedback)
			to_chat(src, span_warning("My level [level] spell slots are spent."))
			balloon_alert(src, "Level [level] slots spent!")
		return FALSE

	return TRUE

/mob/living/carbon/human/proc/spend_dnd_spell_slot(level)
	level = clamp(round(level), DND_SPELL_SLOT_MIN, DND_SPELL_SLOT_MAX)

	if(!can_spend_dnd_spell_slot(level, FALSE))
		return FALSE

	var/key = num2text(level)
	dnd_spell_slots_current[key] = max(get_dnd_spell_slots_current(level) - 1, 0)

	update_dnd_spell_slot_hud()
	return TRUE

/mob/living/carbon/human/proc/select_dnd_spell_slot(level)
	level = clamp(round(level), DND_SPELL_SLOT_MIN, DND_SPELL_SLOT_MAX)

	if(!dnd_spell_slots_max || !dnd_spell_slots_current)
		setup_default_dnd_spell_slots()

	if(!can_spend_dnd_spell_slot(level, TRUE))
		return FALSE

	selected_dnd_spell_slot_level = level

	var/current = get_dnd_spell_slots_current(level)
	var/maximum = get_dnd_spell_slots_max(level)

	to_chat(src, span_notice("Selected level [level] spell slot. Charges: [current]/[maximum]."))
	balloon_alert(src, "Level [level] selected")

	update_dnd_spell_slot_hud()
	return TRUE

/mob/living/carbon/human/proc/use_dnd_short_rest()
	if(!dnd_spell_slots_max || !dnd_spell_slots_current)
		setup_default_dnd_spell_slots()

	if(get_dnd_short_rest_current() <= 0)
		to_chat(src, span_warning("I have no short rests left."))
		balloon_alert(src, "No short rests!")
		return FALSE

	var/restored_any = FALSE

	for(var/level in DND_SPELL_SLOT_MIN to DND_SPELL_SLOT_MAX)
		var/key = num2text(level)
		var/current = get_dnd_spell_slots_current(level)
		var/maximum = get_dnd_spell_slots_max(level)

		if(maximum <= 0)
			continue

		var/half = round(maximum / 2)
		if(half < 1)
			half = 1

		if(current >= half)
			continue

		dnd_spell_slots_current[key] = half
		restored_any = TRUE

	dnd_short_rest_current = max(get_dnd_short_rest_current() - 1, 0)

	update_dnd_spell_slot_hud()
	update_dnd_short_rest_hud()

	if(restored_any)
		to_chat(src, span_notice("I take a short rest and recover some spell slots."))
		balloon_alert(src, "Short rest")
	else
		to_chat(src, span_notice("I take a short rest, but my spell slots are already steady."))
		balloon_alert(src, "No slots restored")

	return TRUE

/mob/living/carbon/human/proc/grant_dnd_spell_hud()
	if(!client)
		return FALSE

	if(!dnd_spell_slots_max || !dnd_spell_slots_current)
		setup_default_dnd_spell_slots()

	grant_dnd_spell_slots_toggle_hud()
	grant_dnd_short_rest_hud()
	grant_dnd_spell_slot_hud()
	apply_dnd_spell_hud_visibility()
	return TRUE

/mob/living/carbon/human/proc/grant_dnd_spell_slot_hud()
	if(!client)
		return FALSE

	if(!dnd_spell_slots_max || !dnd_spell_slots_current)
		setup_default_dnd_spell_slots()

	if(!dnd_spell_slot_hud_buttons)
		dnd_spell_slot_hud_buttons = list()

	for(var/level in DND_SPELL_SLOT_MIN to DND_SPELL_SLOT_MAX)
		var/already_has_button = FALSE

		for(var/atom/movable/screen/dnd_spell_slot_hud/existing_button in dnd_spell_slot_hud_buttons)
			if(existing_button && existing_button.slot_level == level)
				already_has_button = TRUE
				break

		if(already_has_button)
			continue

		var/atom/movable/screen/dnd_spell_slot_hud/button = new
		button.owner_mob = src
		button.slot_level = level
		button.screen_loc = get_dnd_spell_slot_screen_loc(level)
		dnd_spell_slot_hud_buttons += button
		client.screen += button

	update_dnd_spell_slot_hud()
	return TRUE

/mob/living/carbon/human/proc/grant_dnd_short_rest_hud()
	if(!client)
		return FALSE

	if(!isnum(dnd_short_rest_current))
		dnd_short_rest_current = DND_SHORT_REST_MAX_CHARGES

	if(dnd_short_rest_hud_button)
		dnd_short_rest_hud_button.refresh_dnd_short_rest_hud()
		return dnd_short_rest_hud_button

	var/atom/movable/screen/dnd_short_rest_hud/button = new
	button.owner_mob = src
	button.screen_loc = get_dnd_short_rest_screen_loc()
	dnd_short_rest_hud_button = button
	client.screen += button

	update_dnd_short_rest_hud()
	return button

/mob/living/carbon/human/proc/grant_dnd_spell_slots_toggle_hud()
	if(!client)
		return FALSE

	if(dnd_spell_slots_toggle_hud_button)
		dnd_spell_slots_toggle_hud_button.refresh_dnd_spell_slots_toggle_hud()
		return dnd_spell_slots_toggle_hud_button

	var/atom/movable/screen/dnd_spell_slots_toggle_hud/button = new
	button.owner_mob = src
	button.screen_loc = get_dnd_spell_slots_toggle_screen_loc()
	dnd_spell_slots_toggle_hud_button = button
	client.screen += button

	update_dnd_spell_slots_toggle_hud()
	return button

/mob/living/carbon/human/proc/toggle_dnd_spell_hud()
	dnd_spell_slots_collapsed = !dnd_spell_slots_collapsed
	apply_dnd_spell_hud_visibility()
	update_dnd_spell_slots_toggle_hud()
	return TRUE

/mob/living/carbon/human/proc/apply_dnd_spell_hud_visibility()
	if(!client)
		return FALSE

	if(dnd_spell_slot_hud_buttons)
		for(var/atom/movable/screen/dnd_spell_slot_hud/button as anything in dnd_spell_slot_hud_buttons)
			if(!button)
				continue

			if(dnd_spell_slots_collapsed)
				client.screen -= button
			else
				if(!(button in client.screen))
					client.screen += button

	if(dnd_short_rest_hud_button)
		if(dnd_spell_slots_collapsed)
			client.screen -= dnd_short_rest_hud_button
		else
			if(!(dnd_short_rest_hud_button in client.screen))
				client.screen += dnd_short_rest_hud_button

	if(dnd_spell_slots_toggle_hud_button && !(dnd_spell_slots_toggle_hud_button in client.screen))
		client.screen += dnd_spell_slots_toggle_hud_button

	return TRUE

/mob/living/carbon/human/proc/remove_dnd_spell_hud()
	remove_dnd_spell_slot_hud()
	remove_dnd_short_rest_hud()
	remove_dnd_spell_slots_toggle_hud()

/mob/living/carbon/human/proc/remove_dnd_spell_slot_hud()
	if(!dnd_spell_slot_hud_buttons)
		return

	for(var/atom/movable/screen/dnd_spell_slot_hud/button as anything in dnd_spell_slot_hud_buttons)
		if(client)
			client.screen -= button
		qdel(button)

	dnd_spell_slot_hud_buttons = null

/mob/living/carbon/human/proc/remove_dnd_short_rest_hud()
	if(!dnd_short_rest_hud_button)
		return

	if(client)
		client.screen -= dnd_short_rest_hud_button

	qdel(dnd_short_rest_hud_button)
	dnd_short_rest_hud_button = null

/mob/living/carbon/human/proc/remove_dnd_spell_slots_toggle_hud()
	if(!dnd_spell_slots_toggle_hud_button)
		return

	if(client)
		client.screen -= dnd_spell_slots_toggle_hud_button

	qdel(dnd_spell_slots_toggle_hud_button)
	dnd_spell_slots_toggle_hud_button = null

/mob/living/carbon/human/proc/update_dnd_spell_slot_hud()
	if(!dnd_spell_slot_hud_buttons)
		return

	for(var/atom/movable/screen/dnd_spell_slot_hud/button as anything in dnd_spell_slot_hud_buttons)
		if(button)
			button.refresh_dnd_slot_hud()

/mob/living/carbon/human/proc/update_dnd_short_rest_hud()
	if(dnd_short_rest_hud_button)
		dnd_short_rest_hud_button.refresh_dnd_short_rest_hud()

/mob/living/carbon/human/proc/update_dnd_spell_slots_toggle_hud()
	if(dnd_spell_slots_toggle_hud_button)
		dnd_spell_slots_toggle_hud_button.refresh_dnd_spell_slots_toggle_hud()

/proc/get_dnd_spell_slot_icon_state(level, charges)
	level = clamp(round(level), DND_SPELL_SLOT_MIN, DND_SPELL_SLOT_MAX)
	charges = clamp(round(charges), 0, DND_SPELL_SLOT_ICON_MAX)

	return "dnd_slot_[level]_[charges]"

/proc/get_dnd_short_rest_icon_state(charges)
	charges = clamp(round(charges), 0, DND_SHORT_REST_MAX_CHARGES)

	return "dnd_short_rest_[charges]"

/proc/get_dnd_spell_slot_screen_loc(level)
	switch(level)
		if(1)
			return "CENTER-1,SOUTH+2"
		if(2)
			return "CENTER,SOUTH+2"
		if(3)
			return "CENTER+1,SOUTH+2"
		if(4)
			return "CENTER+2,SOUTH+2"
		if(5)
			return "CENTER+3,SOUTH+2"

	return "CENTER+1,SOUTH+2"

/proc/get_dnd_short_rest_screen_loc()
	return "CENTER-2,SOUTH+2"

/proc/get_dnd_spell_slots_toggle_screen_loc()
	return "CENTER-3,SOUTH+2"

/atom/movable/screen/dnd_spell_slot_hud
	name = "Spell Slot"
	desc = "Selects a spell slot."
	icon = 'icons/mob/actions/dnd_spell_slots.dmi'
	icon_state = "dnd_slot_1_0"
	mouse_opacity = MOUSE_OPACITY_ICON

	var/slot_level = 1
	var/mob/living/carbon/human/owner_mob

/atom/movable/screen/dnd_spell_slot_hud/Destroy()
	owner_mob = null
	return ..()

/atom/movable/screen/dnd_spell_slot_hud/proc/refresh_dnd_slot_hud()
	if(!owner_mob)
		icon_state = get_dnd_spell_slot_icon_state(slot_level, 0)
		return FALSE

	var/current = owner_mob.get_dnd_spell_slots_current(slot_level)
	var/maximum = owner_mob.get_dnd_spell_slots_max(slot_level)

	icon_state = get_dnd_spell_slot_icon_state(slot_level, current)
	name = "Level [slot_level] Spell Slot ([current]/[maximum])"
	desc = "Select level [slot_level] spell slot. Charges: [current]/[maximum]."
	return TRUE

/atom/movable/screen/dnd_spell_slot_hud/Click(location, control, params)
	. = ..()

	if(!owner_mob)
		return

	owner_mob.select_dnd_spell_slot(slot_level)

/atom/movable/screen/dnd_short_rest_hud
	name = "Short Rest"
	desc = "Restores spell slots up to half of each level."
	icon = 'icons/mob/actions/dnd_spell_slots.dmi'
	icon_state = "dnd_short_rest_2"
	mouse_opacity = MOUSE_OPACITY_ICON

	var/mob/living/carbon/human/owner_mob

/atom/movable/screen/dnd_short_rest_hud/Destroy()
	owner_mob = null
	return ..()

/atom/movable/screen/dnd_short_rest_hud/proc/refresh_dnd_short_rest_hud()
	if(!owner_mob)
		icon_state = "dnd_short_rest_0"
		return FALSE

	var/current = owner_mob.get_dnd_short_rest_current()
	var/maximum = owner_mob.get_dnd_short_rest_max()

	icon_state = get_dnd_short_rest_icon_state(current)
	name = "Short Rest ([current]/[maximum])"
	desc = "Restores spell slots up to half of each level. Charges: [current]/[maximum]."
	return TRUE

/atom/movable/screen/dnd_short_rest_hud/Click(location, control, params)
	. = ..()

	if(!owner_mob)
		return

	owner_mob.use_dnd_short_rest()

/atom/movable/screen/dnd_spell_slots_toggle_hud
	name = "Toggle Spell Slots"
	desc = "Hide or show spell slot HUD."
	icon = 'icons/mob/actions/dnd_spell_slots.dmi'
	icon_state = "dnd_slots_open"
	mouse_opacity = MOUSE_OPACITY_ICON

	var/mob/living/carbon/human/owner_mob

/atom/movable/screen/dnd_spell_slots_toggle_hud/Destroy()
	owner_mob = null
	return ..()

/atom/movable/screen/dnd_spell_slots_toggle_hud/proc/refresh_dnd_spell_slots_toggle_hud()
	if(!owner_mob)
		icon_state = "dnd_slots_closed"
		return FALSE

	if(owner_mob.dnd_spell_slots_collapsed)
		icon_state = "dnd_slots_closed"
		name = "Show Spell Slots"
		desc = "Show spell slot HUD."
	else
		icon_state = "dnd_slots_open"
		name = "Hide Spell Slots"
		desc = "Hide spell slot HUD."

	return TRUE

/atom/movable/screen/dnd_spell_slots_toggle_hud/Click(location, control, params)
	. = ..()

	if(!owner_mob)
		return

	owner_mob.toggle_dnd_spell_hud()

#undef DND_SPELL_SLOT_MIN
#undef DND_SPELL_SLOT_MAX
#undef DND_SPELL_SLOT_ICON_MAX
#undef DND_SHORT_REST_MAX_CHARGES


/mob/living/carbon/human/verb/debug_grant_dnd_fireball()
	set name = "Grant DND Fireball"
	set category = "Debug"

	setup_default_dnd_spell_slots()
	grant_dnd_spell_hud()

	var/datum/action/cooldown/spell/projectile/fireball/F = new
	F.Grant(src)

	to_chat(src, span_notice("DND Fireball granted."))
