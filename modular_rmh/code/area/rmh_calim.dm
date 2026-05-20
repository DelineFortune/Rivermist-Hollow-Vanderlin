// - - - - - - - - - - - - - - - - - - - - - -  //
//	CALIM DESERT - PORT TOWN AREAS + OUTSKIRTS	//
// - - - - - - - - - - - - - - - - - - - - - -  //
/*
/area/outdoors
	name = "outdoors roguetown"
	icon_state = "outdoors"
	outdoors = TRUE
	droning_index = DRONING_TOWN_DAY
	droning_index_night = DRONING_TOWN_NIGHT
	ambient_index = AMBIENCE_BIRDS
	ambient_index_night = AMBIENCE_GENERIC
	background_track = 'sound/music/area/townstreets.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/indoors/shelter

/area/indoors
	name = "indoors rt"
	icon_state = "indoors"
	droning_index = DRONING_INDOORS
	ambient_index = AMBIENCE_GENERIC
	background_track = 'sound/music/area/indoor.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'
	plane = INDOOR_PLANE
	converted_type = /area/outdoors

/area/under
	name = "basement"
	icon_state = "under"
	background_track = 'sound/music/area/towngen.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'
	soundenv = 8
	plane = INDOOR_PLANE
	converted_type = /area/outdoors/exposed

/area/outdoors/rmh_desert
	name = "Desert"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "desert"
	soundenv = 19
	ambush_mobs = null
	first_time_text = "CURSED DESERT"
	droning_index = DRONING_MOUNTAIN
	ambient_index = AMBIENCE_GENERIC
	background_track_dawn = 'modular_rmh/sound/music/area/desert_dawn.ogg'
	background_track = 'modular_rmh/sound/music/area/desert_day.ogg'
	background_track_dusk = 'modular_rmh/sound/music/area/desert_dusk.ogg'
	background_track_night = 'modular_rmh/sound/music/area/desert_night.ogg'
	converted_type = /area/indoors/shelter/rmh_desert
	threat_region = THREAT_REGION_RMH_DESERT
	//deathsight_message = "somewhere far in sands"

*/
