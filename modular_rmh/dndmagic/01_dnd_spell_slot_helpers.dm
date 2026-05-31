// DND spell slot helpers.
// Keep this file loaded before the DND spell files below.
// It does not change normal spells unless a spell sets dnd_use_spell_slots = TRUE.

/datum/action/cooldown/spell
	var/dnd_use_spell_slots = FALSE
	var/dnd_min_spell_slot_level = 1
	var/dnd_max_spell_slot_level = 5
	var/tmp/dnd_cast_slot_level = 0
	var/dnd_spell_slot_label

/datum/action/cooldown/spell/proc/dnd_get_min_slot_level()
	if(!isnum(dnd_min_spell_slot_level))
		dnd_min_spell_slot_level = 1

	return clamp(round(dnd_min_spell_slot_level), 1, 5)

/datum/action/cooldown/spell/proc/dnd_get_max_slot_level()
	if(!isnum(dnd_max_spell_slot_level))
		dnd_max_spell_slot_level = 5

	return clamp(round(dnd_max_spell_slot_level), dnd_get_min_slot_level(), 5)

/datum/action/cooldown/spell/proc/dnd_get_cast_level()
	var/min_level = dnd_get_min_slot_level()
	var/max_level = dnd_get_max_slot_level()

	var/level = dnd_cast_slot_level
	if(!isnum(level) || level <= 0)
		level = min_level

	return clamp(round(level), min_level, max_level)

/datum/action/cooldown/spell/proc/dnd_get_spell_label()
	if(dnd_spell_slot_label)
		return dnd_spell_slot_label

	return name

/datum/action/cooldown/spell/proc/dnd_spell_slot_can_cast(feedback = TRUE)
	if(!dnd_use_spell_slots)
		return TRUE

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		if(feedback && owner)
			owner.balloon_alert(owner, "Only humans can use slots!")
		return FALSE

	var/level = H.get_selected_dnd_spell_slot_level()
	var/min_level = dnd_get_min_slot_level()
	var/max_level = dnd_get_max_slot_level()

	if(level < min_level)
		if(feedback)
			to_chat(H, span_warning("[dnd_get_spell_label()] requires a level [min_level]+ spell slot."))
			H.balloon_alert(H, "Needs level [min_level]+ slot")
		return FALSE

	level = clamp(round(level), min_level, max_level)

	if(!H.can_spend_dnd_spell_slot(level, feedback))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/proc/dnd_spell_slot_before_cast(atom/cast_on)
	dnd_cast_slot_level = 0

	if(!dnd_use_spell_slots)
		return NONE

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return SPELL_CANCEL_CAST

	var/level = H.get_selected_dnd_spell_slot_level()
	var/min_level = dnd_get_min_slot_level()
	var/max_level = dnd_get_max_slot_level()

	if(level < min_level)
		to_chat(H, span_warning("[dnd_get_spell_label()] requires a level [min_level]+ spell slot."))
		H.balloon_alert(H, "Needs level [min_level]+ slot")
		return SPELL_CANCEL_CAST

	level = clamp(round(level), min_level, max_level)

	if(!H.can_spend_dnd_spell_slot(level, TRUE))
		return SPELL_CANCEL_CAST

	if(!H.spend_dnd_spell_slot(level))
		to_chat(H, span_warning("My level [level] spell slot fizzles before [dnd_get_spell_label()] takes shape."))
		return SPELL_CANCEL_CAST

	dnd_cast_slot_level = level

	var/current = H.get_dnd_spell_slots_current(level)
	var/maximum = H.get_dnd_spell_slots_max(level)

	to_chat(H, span_notice("I cast [dnd_get_spell_label()] using a level [level] spell slot. Charges left: [current]/[maximum]."))
	H.balloon_alert(H, "[dnd_get_spell_label()] level [level]")

	return NONE

/datum/action/cooldown/spell/proc/dnd_spell_slot_after_cast()
	dnd_cast_slot_level = 0

/datum/action/cooldown/spell/proc/dnd_scale_number(list/table, fallback = 0)
	var/level = dnd_get_cast_level()
	var/value = fallback

	if(table)
		value = table[num2text(level)]

	if(!isnum(value))
		value = fallback

	return value
