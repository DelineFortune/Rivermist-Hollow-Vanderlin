/datum/round_event_control/wild_crops
	name = "Wild Crop Sprout"
	track = EVENT_TRACK_MODERATE
	typepath = /datum/round_event/wild_crops
	weight = 7
	max_occurrences = 10
	min_players = 0
	earliest_start = 10 MINUTES

	tags = list(
		TAG_NATURE,
		TAG_BOON,
	)

/datum/round_event/wild_crops/start()
	. = ..()
	var/list/turfs = get_area_turfs(/area/outdoors/wilderness, subtypes = TRUE)
	var/list/valid_turfs = list()
	for(var/turf/turf as anything in turfs)
		if(!istype(turf, /turf/open/floor/dirt) && !istype(turf, /turf/open/floor/grass) && !istype(turf, /turf/open/floor/snow))
			continue
		valid_turfs += turf
	if(!length(valid_turfs))
		return
	for(var/i = 1 to rand(2, 12))
		new /obj/structure/wild_plant/random(pick(valid_turfs))
