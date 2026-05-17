#define DND_SPELL_SLOT_MIN 1
#define DND_SPELL_SLOT_MAX 5

/mob/living/carbon/human
	var/selected_dnd_spell_slot_level = DND_SPELL_SLOT_MIN
	var/list/dnd_spell_slots_max
	var/list/dnd_spell_slots_current
	var/list/dnd_spell_slot_hud_buttons

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

		amount = max(round(amount), 0)

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
	return TRUE

/mob/living/carbon/human/proc/restore_all_dnd_spell_slots()
	if(!dnd_spell_slots_max)
		setup_default_dnd_spell_slots()
		return TRUE

	if(!dnd_spell_slots_current)
		dnd_spell_slots_current = list()

	for(var/key in dnd_spell_slots_max)
		dnd_spell_slots_current[key] = dnd_spell_slots_max[key]

	update_dnd_spell_slot_hud()
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

	return max(round(amount), 0)

/mob/living/carbon/human/proc/get_dnd_spell_slots_max(level)
	if(!dnd_spell_slots_max)
		return 0

	var/key = num2text(round(level))
	var/amount = dnd_spell_slots_max[key]

	if(!isnum(amount))
		return 0

	return max(round(amount), 0)

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

/mob/living/carbon/human/proc/remove_dnd_spell_slot_hud()
	if(!dnd_spell_slot_hud_buttons)
		return

	for(var/atom/movable/screen/dnd_spell_slot_hud/button as anything in dnd_spell_slot_hud_buttons)
		if(client)
			client.screen -= button
		qdel(button)

	dnd_spell_slot_hud_buttons = null

/mob/living/carbon/human/proc/update_dnd_spell_slot_hud()
	if(!dnd_spell_slot_hud_buttons)
		return

	for(var/atom/movable/screen/dnd_spell_slot_hud/button as anything in dnd_spell_slot_hud_buttons)
		if(button)
			button.refresh_dnd_slot_hud()

/proc/get_dnd_spell_slot_icon_state(level, charges)
	level = clamp(round(level), DND_SPELL_SLOT_MIN, DND_SPELL_SLOT_MAX)

	if(charges <= 0)
		return "dnd_slot_1_0"

	return "dnd_slot_1_[level]"

/proc/get_dnd_spell_slot_screen_loc(level)
	switch(level)
		if(1)
			return "CENTER-2,NORTH-4"
		if(2)
			return "CENTER-1,NORTH-4"
		if(3)
			return "CENTER,NORTH-4"
		if(4)
			return "CENTER+1,NORTH-4"
		if(5)
			return "CENTER+2,NORTH-4"

	return "CENTER,NORTH-4"

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
		icon_state = "dnd_slot_1_0"
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

#undef DND_SPELL_SLOT_MIN
#undef DND_SPELL_SLOT_MAX

/mob/living/carbon/human/verb/debug_grant_dnd_fireball()
	set name = "Grant DND Fireball"
	set category = "Debug"

	setup_default_dnd_spell_slots()
	grant_dnd_spell_slot_hud()

	var/datum/action/cooldown/spell/projectile/fireball/F = new
	F.Grant(src)

	to_chat(src, span_notice("DND Fireball granted."))
