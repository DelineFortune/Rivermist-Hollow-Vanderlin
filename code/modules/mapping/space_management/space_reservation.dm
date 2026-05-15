
//Yes, they can only be rectangular.
//Yes, I'm sorry.
/datum/turf_reservation
	var/list/reserved_turfs = list()
	var/width = 0
	var/height = 0
	var/bottom_left_coords[3]
	var/top_right_coords[3]
	var/wipe_reservation_on_release = TRUE
	var/turf_type = /turf/open/floor/blocks

/datum/turf_reservation/transit
	turf_type = /turf/open/floor/blocks

/datum/turf_reservation/proc/Release()
	if(!length(reserved_turfs))
		return FALSE

	var/list/turfs_to_release = reserved_turfs.Copy()
	reserved_turfs.Cut()

	for(var/turf/released_turf as anything in turfs_to_release)
		SSmapping.used_turfs -= released_turf

	SSmapping.reserve_turfs(turfs_to_release)
	return TRUE

/datum/turf_reservation/proc/claim_turfs(list/turfs_to_claim, reservation_width, reservation_height)
	if(!length(turfs_to_claim))
		return FALSE

	reserved_turfs.Cut()
	var/failed_to_claim = FALSE
	for(var/turf/T as anything in turfs_to_claim)
		if(!istype(T))
			failed_to_claim = TRUE
			continue

		var/turf_x = T.x
		var/turf_y = T.y
		var/turf_z = T.z

		T.turf_flags &= ~UNUSED_RESERVATION_TURF
		SSmapping.unused_turfs["[turf_z]"] -= T
		SSmapping.used_turfs -= T
		T.ChangeTurf(turf_type, turf_type)

		var/turf/reserved_turf = locate(turf_x, turf_y, turf_z)
		if(!reserved_turf)
			failed_to_claim = TRUE
			stack_trace("Failed to relocate reserved turf at ([turf_x], [turf_y], [turf_z]) after ChangeTurf.")
			continue

		reserved_turf.turf_flags &= ~UNUSED_RESERVATION_TURF
		SSmapping.unused_turfs["[turf_z]"] -= reserved_turf
		SSmapping.used_turfs[reserved_turf] = src
		reserved_turfs |= reserved_turf

	if(failed_to_claim || length(reserved_turfs) != length(turfs_to_claim))
		Release()
		return FALSE

	src.width = reservation_width
	src.height = reservation_height
	return TRUE

/datum/turf_reservation/proc/RefreshTurfs()
	if(!length(bottom_left_coords) || !length(top_right_coords))
		return FALSE

	var/turf/BL = locate(bottom_left_coords[1], bottom_left_coords[2], bottom_left_coords[3])
	var/turf/TR = locate(top_right_coords[1], top_right_coords[2], top_right_coords[3])
	if(!istype(BL) || !istype(TR))
		return FALSE

	var/list/current_turfs = block(BL, TR)
	if(!length(current_turfs))
		return FALSE

	for(var/turf/old_turf as anything in reserved_turfs)
		SSmapping.used_turfs -= old_turf

	reserved_turfs.Cut()
	for(var/turf/current_turf as anything in current_turfs)
		current_turf.turf_flags &= ~UNUSED_RESERVATION_TURF
		SSmapping.unused_turfs["[current_turf.z]"] -= current_turf
		SSmapping.used_turfs[current_turf] = src
		reserved_turfs |= current_turf

	return TRUE

/datum/turf_reservation/proc/Reserve(width, height, zlevel)
	if(width > world.maxx || height > world.maxy || width < 1 || height < 1)
		return FALSE
	var/list/avail = SSmapping.unused_turfs["[zlevel]"]
	var/turf/BL
	var/turf/TR
	var/list/turf/final = list()
	var/passing = FALSE
	for(var/i in avail)
		CHECK_TICK
		BL = i
		if(!(BL.turf_flags & UNUSED_RESERVATION_TURF))
			continue
		if(BL.x + width > world.maxx || BL.y + height > world.maxy)
			continue
		TR = locate(BL.x + width - 1, BL.y + height - 1, BL.z)
		if(!(TR.turf_flags & UNUSED_RESERVATION_TURF))
			continue
		final = block(BL, TR)
		if(!final)
			continue
		passing = TRUE
		for(var/turf/checking as anything in final)
			if(!(checking.turf_flags & UNUSED_RESERVATION_TURF))
				passing = FALSE
				break
		if(!passing)
			continue
		break
	if(!passing || !istype(BL) || !istype(TR))
		return FALSE
	bottom_left_coords = list(BL.x, BL.y, BL.z)
	top_right_coords = list(TR.x, TR.y, TR.z)
	return claim_turfs(final, width, height)

/datum/turf_reservation/proc/ReserveAt(width, height, x, y, zlevel)
	if(width > world.maxx || height > world.maxy || width < 1 || height < 1)
		return FALSE
	if(x < 1 || y < 1 || zlevel < 1)
		return FALSE
	if(x + width - 1 > world.maxx || y + height - 1 > world.maxy || zlevel > world.maxz)
		return FALSE

	var/turf/BL = locate(x, y, zlevel)
	var/turf/TR = locate(x + width - 1, y + height - 1, zlevel)
	if(!istype(BL) || !istype(TR))
		return FALSE

	var/list/turf/final = block(BL, TR)
	if(!length(final))
		return FALSE

	for(var/turf/checking as anything in final)
		if(!(checking.turf_flags & UNUSED_RESERVATION_TURF))
			return FALSE

	bottom_left_coords = list(BL.x, BL.y, BL.z)
	top_right_coords = list(TR.x, TR.y, TR.z)
	return claim_turfs(final, width, height)

/datum/turf_reservation/New()
	LAZYADD(SSmapping.turf_reservations, src)

/datum/turf_reservation/Destroy()
	Release()
	LAZYREMOVE(SSmapping.turf_reservations, src)
	return ..()
