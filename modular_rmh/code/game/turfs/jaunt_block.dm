// ==================== ETHEREAL JAUNT BLOCK PASSAGE THROUHT BEDROCK ====================

/obj/effect/dummy/phased_mob/spell_jaunt
	var/last_jaunt_warning = 0

/obj/effect/dummy/phased_mob/spell_jaunt/relaymove(mob/living/user, direction)
	var/turf/new_turf = get_step(src, direction)
	if(!new_turf)
		return FALSE

	if(istype(new_turf, /turf/closed/mineral/bedrock) || \
		istype(new_turf, /turf/closed/mineral/bedrock/cold) || \
		istype(new_turf, /turf/closed/indestructible/pocket_border) || \
		istype(new_turf, /turf/closed/basic))

		if(world.time - last_jaunt_warning > 1 SECONDS)
			to_chat(user, span_warning("This wall is too dense even for your ethereal form..."))
			last_jaunt_warning = world.time

		return FALSE

	return ..()

/turf/closed/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(!.)
		return FALSE

	if(istype(mover, /obj/effect/dummy/phased_mob/spell_jaunt))
		if(istype(src, /turf/closed/mineral/bedrock) || \
			istype(src, /turf/closed/mineral/bedrock/cold) || \
			istype(src, /turf/closed/basic))
			return FALSE

	return TRUE
