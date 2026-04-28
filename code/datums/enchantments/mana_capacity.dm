/datum/enchantment/mana_capacity
	enchantment_name = "Mana Capacity"
	examine_text = "I can feel this objects mana and use it freely."

	essence_recipe = list(
		/datum/thaumaturgical_essence/energia = 30,
		/datum/thaumaturgical_essence/crystal = 30
	)
	var/hardcap_increase = 1000

	var/list/affecting_mobs = list()

/datum/enchantment/mana_capacity/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	registered_signals += COMSIG_ITEM_DROPPED
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/enchantment/mana_capacity/proc/on_equip(obj/item/source, mob/living/carbon/equipper, slot)
	if(!(source in affecting_mobs))
		affecting_mobs |= source
		affecting_mobs[source] = list()
	if(equipper in affecting_mobs[source])
		return
	affecting_mobs[source] |= equipper

	// Keep overload tolerance aligned with temporary hardcap boosts so
	// mana-capacity gear does not create a lethal "legal capacity" range.
	equipper.mana_pool?.set_max_mana(equipper.mana_pool.maximum_mana_capacity + hardcap_increase, change_softcap = FALSE)
	equipper.mana_overload_threshold += hardcap_increase


/datum/enchantment/mana_capacity/proc/on_drop(datum/source, mob/living/carbon/user)
	if(!(source in affecting_mobs))
		affecting_mobs |= source
		affecting_mobs[source] = list()
	if(!istype(user))
		return
	if(!(user in affecting_mobs[source]))
		return
	affecting_mobs[source] -= user

	user.mana_pool?.set_max_mana(user.mana_pool.maximum_mana_capacity - hardcap_increase)
	user.mana_overload_threshold -= hardcap_increase

/datum/enchantment/mana_capacity/Destroy(force, ...)
	for(var/source in affecting_mobs)
		var/list/source_mobs = affecting_mobs[source]
		if(!islist(source_mobs))
			continue
		for(var/mob/living/carbon/user as anything in source_mobs)
			if(QDELETED(user))
				continue
			user.mana_pool?.set_max_mana(user.mana_pool.maximum_mana_capacity - hardcap_increase)
			user.mana_overload_threshold -= hardcap_increase
	affecting_mobs = null
	return ..()
