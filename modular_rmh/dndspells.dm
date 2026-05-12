#define DND_SPELL_SLOT_MIN 1
#define DND_SPELL_SLOT_MAX 5

/mob/living/carbon/human
	var/selected_dnd_spell_slot_level = DND_SPELL_SLOT_MIN
	var/list/dnd_spell_slots_max
	var/list/dnd_spell_slots_current

/mob/living/carbon/human/proc/setup_dnd_spell_slots(list/slot_table)
	if(!slot_table)
		return FALSE

	if(!dnd_spell_slots_max)
		dnd_spell_slots_max = list()

	if(!dnd_spell_slots_current)
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

	update_dnd_spell_slot_selector_buttons()
	return TRUE

/mob/living/carbon/human/proc/setup_default_dnd_spell_slots()
	var/list/default_slots = list()
	default_slots["1"] = 4
	default_slots["2"] = 3
	default_slots["3"] = 2
	default_slots["4"] = 1
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

	update_dnd_spell_slot_selector_buttons()
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

	return amount

/mob/living/carbon/human/proc/get_dnd_spell_slots_max(level)
	if(!dnd_spell_slots_max)
		return 0

	var/key = num2text(round(level))
	var/amount = dnd_spell_slots_max[key]

	if(!isnum(amount))
		return 0

	return amount

/mob/living/carbon/human/proc/can_spend_dnd_spell_slot(level, feedback = TRUE)
	level = clamp(round(level), DND_SPELL_SLOT_MIN, DND_SPELL_SLOT_MAX)

	if(!dnd_spell_slots_max || !dnd_spell_slots_current)
		if(feedback)
			to_chat(src, span_warning("I have no prepared spell slots."))
			balloon_alert(src, "No spell slots!")
		return FALSE

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
	dnd_spell_slots_current[key] = max(dnd_spell_slots_current[key] - 1, 0)

	update_dnd_spell_slot_selector_buttons()
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

	to_chat(src, span_notice("Selected spell slot level [level]. Charges: [current]/[maximum]."))
	balloon_alert(src, "Slot [level] selected")

	update_dnd_spell_slot_selector_buttons()
	return TRUE

/mob/living/carbon/human/proc/grant_dnd_spell_slot_selector()
	if(!dnd_spell_slots_max || !dnd_spell_slots_current)
		setup_default_dnd_spell_slots()

	for(var/datum/action/cooldown/spell/dnd_spell_slot_selector/existing_selector in actions)
		return existing_selector

	var/datum/action/cooldown/spell/dnd_spell_slot_selector/selector = new
	selector.Grant(src)

	update_dnd_spell_slot_selector_buttons()
	return selector

/mob/living/carbon/human/proc/remove_dnd_spell_slot_selector()
	var/list/selectors_to_remove = list()

	for(var/datum/action/cooldown/spell/dnd_spell_slot_selector/selector in actions)
		selectors_to_remove += selector

	for(var/datum/action/cooldown/spell/dnd_spell_slot_selector/selector as anything in selectors_to_remove)
		selector.Remove(src)

/mob/living/carbon/human/proc/update_dnd_spell_slot_selector_buttons()
	for(var/datum/action/cooldown/spell/dnd_spell_slot_selector/selector in actions)
		selector.button_icon_state = get_dnd_spell_slot_icon_state(get_selected_dnd_spell_slot_level())
		selector.build_all_button_icons()

/proc/get_dnd_spell_slot_icon_state(level)
	switch(level)
		if(1)
			return "spell0"
		if(2)
			return "shieldsparkles"
		if(3)
			return "fireball"
		if(4)
			return "fireball_greater"
		if(5)
			return "sacredflame"

	return "spell0"

/datum/action/cooldown/spell/dnd_spell_slot_selector
	name = "DND Spell Slot"
	desc = "Selects which spell slot level your next compatible spell will use."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "spell0"
	background_icon = 'icons/mob/actions/roguespells.dmi'
	background_icon_state = "spell0"
	base_background_icon_state = "spell0"
	active_background_icon_state = "spell1"
	panel = "Spells"
	click_to_activate = FALSE
	charge_required = FALSE
	cooldown_time = 0
	spell_type = NONE
	spell_cost = 0
	spell_requirements = NONE
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/cooldown/spell/dnd_spell_slot_selector/Grant(mob/grant_to)
	if(!ishuman(grant_to))
		qdel(src)
		return

	var/mob/living/carbon/human/H = grant_to
	if(!H.dnd_spell_slots_max || !H.dnd_spell_slots_current)
		H.setup_default_dnd_spell_slots()

	button_icon_state = get_dnd_spell_slot_icon_state(H.get_selected_dnd_spell_slot_level())

	return ..()

/datum/action/cooldown/spell/dnd_spell_slot_selector/Trigger(trigger_flags, atom/target)
	if(!owner)
		return FALSE

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!H.dnd_spell_slots_max || !H.dnd_spell_slots_current)
		H.setup_default_dnd_spell_slots()

	var/list/options = list()
	var/list/option_to_level = list()

	for(var/level in DND_SPELL_SLOT_MIN to DND_SPELL_SLOT_MAX)
		var/current = H.get_dnd_spell_slots_current(level)
		var/maximum = H.get_dnd_spell_slots_max(level)
		var/icon_state = get_dnd_spell_slot_icon_state(level)
		var/image/level_icon = image(icon = 'icons/mob/actions/roguespells.dmi', icon_state = icon_state)

		var/label = "Level [level] ([current]/[maximum])"
		options[label] = level_icon
		option_to_level[label] = level

	var/choice = show_radial_menu(
		H,
		H,
		options,
		require_near = FALSE
	)

	if(!choice)
		H.balloon_alert(H, "No spell slot selected!")
		return FALSE

	var/selected_level = option_to_level[choice]
	if(!isnum(selected_level))
		H.balloon_alert(H, "Invalid spell slot!")
		return FALSE

	H.select_dnd_spell_slot(selected_level)
	return TRUE

/datum/action/cooldown/spell/dnd_spell_slot_selector/get_spell_title()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return ""

	var/level = H.get_selected_dnd_spell_slot_level()
	return "Selected [level] "

#undef DND_SPELL_SLOT_MIN
#undef DND_SPELL_SLOT_MAX