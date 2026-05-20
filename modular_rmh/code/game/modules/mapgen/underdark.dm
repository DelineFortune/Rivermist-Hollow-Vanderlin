/obj/effect/landmark/mapGenerator/underdark
	mapGeneratorType = /datum/mapGenerator/underdark
	endTurfX = 255
	endTurfY = 450
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/underdark
	modules = list(/datum/mapGeneratorModule/ambushing, /datum/mapGeneratorModule/underdarkstone, /datum/mapGeneratorModule/underdarkmud, /datum/mapGeneratorModule/underglimmer)


/datum/mapGeneratorModule/underdarkstone
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/naturalstone)
	allowed_areas = list(/area/under/underdark)
	spawnableAtoms = list(/obj/structure/flora/shroom_tree/happy/random = 30,
							/obj/structure/flora/mushroomcluster = 20,
							/obj/structure/flora/tinymushrooms = 20,
							/obj/structure/roguerock = 25,
							/obj/item/natural/rock = 25,
							/obj/structure/flora/crystal = 12,
							/obj/structure/vine = 5,
							/obj/structure/flora/gemcrystals/aquamarine = 2,
							/obj/structure/flora/gemcrystals/aquamarine/small = 3,
							/obj/structure/flora/gemcrystals/emerald = 2,
							/obj/structure/flora/gemcrystals/emerald/small = 3,
							/obj/structure/flora/gemcrystals/rube = 2,
							/obj/structure/flora/gemcrystals/rube/small = 3,
							/obj/structure/flora/gemcrystals/topaz = 2,
							/obj/structure/flora/gemcrystals/topaz/small = 3,
							/obj/structure/flora/gemcrystals/lapiz = 1,
							/obj/structure/flora/gemcrystals/sapphiresmall = 2)

/datum/mapGeneratorModule/underdarkmud
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_areas = list(/area/under/underdark)
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/mushroomcluster = 20,
							/obj/structure/flora/grass/thorn_bush = 10,
							/obj/structure/flora/shroom_tree = 20,
							/obj/structure/flora/shroom_tree/happy/random = 40,
							/obj/structure/flora/tinymushrooms = 20,
							/obj/structure/flora/grass = 30,
							/obj/structure/flora/grass/herb/random = 5)

/datum/mapGeneratorModule/underglimmer
	allowed_areas = list(/area/under/underdark/rmh/glimmerlakes)
	allowed_turfs = list(/turf/open/floor/grass/cold)
	excluded_turfs = list(/turf/open/floor/dirt, /turf/open/floor/dirt/road)
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	spawnableAtoms = list(
		/obj/structure/flora/new_shroom/red = 5,
		/obj/structure/flora/new_shroom/purplesmall = 5,
		/obj/structure/flora/new_shroom/purplef = 5,
		/obj/structure/flora/new_shroom/purple = 5,
		/obj/structure/flora/new_shroom/cyan = 5,
		/obj/structure/flora/new_shroom/cyanf = 5,
		/obj/structure/flora/new_shroom/cyansmall = 5,
		/obj/structure/flora/crystal = 10,
		/obj/structure/flora/grass/mushroom = 10
	)
