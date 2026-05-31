// DND Mind Spike variant.

/datum/action/cooldown/spell/mind_spike/dnd
	name = "DND Mind Spike"
	desc = "Drive a psychic spike into a target area. Brain damage scales with the selected DND spell slot."
	spell_cost = 0
	charge_drain = 0

	dnd_use_spell_slots = TRUE
	dnd_min_spell_slot_level = 1
	dnd_max_spell_slot_level = 5
	dnd_spell_slot_label = "Mind Spike"

	var/tmp/dnd_pending_mind_spike_level = 0

/datum/action/cooldown/spell/mind_spike/dnd/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE

	return dnd_spell_slot_can_cast(feedback)

/datum/action/cooldown/spell/mind_spike/dnd/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	var/dnd_result = dnd_spell_slot_before_cast(cast_on)
	if(dnd_result & SPELL_CANCEL_CAST)
		return . | SPELL_CANCEL_CAST

	return .

/datum/action/cooldown/spell/mind_spike/dnd/cast(atom/cast_on)
	dnd_pending_mind_spike_level = dnd_get_cast_level()
	return ..()

/datum/action/cooldown/spell/mind_spike/dnd/proc/get_dnd_mind_spike_divisor()
	var/level = dnd_pending_mind_spike_level
	if(!isnum(level) || level <= 0)
		level = dnd_get_cast_level()

	level = clamp(round(level), 1, 5)

	switch(level)
		if(1)
			return 8
		if(2)
			return 6
		if(3)
			return 5
		if(4)
			return 4
		if(5)
			return 3

	return 8

/datum/action/cooldown/spell/mind_spike/dnd/drive_spike(turf/victim)
	playsound(victim, "genslash", 80, TRUE)
	new /obj/effect/temp_visual/mind_spike(victim)

	var/divisor = get_dnd_mind_spike_divisor()

	for(var/mob/living/L in victim)
		var/obj/item/organ/brain/brain = L.getorganslot(ORGAN_SLOT_BRAIN)
		if(!brain)
			continue

		brain.applyOrganDamage((brain.maxHealth / divisor))
		to_chat(L, "<span class='userdanger'>Psychic energy is driven into my skull!!</span>")

	dnd_pending_mind_spike_level = 0

/datum/action/cooldown/spell/mind_spike/dnd/after_cast(atom/cast_on)
	. = ..()
	dnd_spell_slot_after_cast()
