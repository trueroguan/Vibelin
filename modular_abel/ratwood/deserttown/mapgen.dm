/obj/effect/landmark/mapGenerator/desert
	mapGeneratorType = /datum/mapGenerator/desert
	endTurfX = 380
	endTurfY = 310
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/desert
	modules = list(/datum/mapGeneratorModule/desertsand, /datum/mapGeneratorModule/desertgrass, /datum/mapGeneratorModule/desertroad, /datum/mapGeneratorModule/desertwater)

/datum/mapGeneratorModule/desertsand
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/floor/dunes)
	spawnableAtoms = list(/obj/structure/flora/tree/palm = 0.5,
							/obj/structure/flora/grass/bush/desertshrub = 0.5,
							/obj/structure/flora/tree/stump = 0.3,
							/obj/item/natural/stone = 1,
							/obj/item/natural/rock = 1,
							/obj/structure/flora/grass/herb/random = 0.5,
							/obj/structure/flora/grass/desertgrass = 1)
	allowed_areas = list(/area/outdoors/desert, /area/outdoors/desertdeep)

/datum/mapGeneratorModule/desertgrass
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/floor/dirt, /turf/open/floor/desert_grass)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/tree/palm = 5,
							/obj/structure/flora/grass/bush/desertshrub = 4,
														/obj/structure/flora/tree/stump = 0.5,
							/obj/structure/flora/grass/maneater = 0.5,
							/obj/item/natural/stone = 1,
							/obj/item/natural/rock = 1,
							/obj/structure/flora/grass/swampweed = 0.5,
							/obj/structure/flora/grass/herb/random = 2,
							/obj/effect/decal/remains/human = 0.3)
	allowed_areas = list(/area/outdoors/desert, /area/outdoors/desertdeep)

/datum/mapGeneratorModule/desertroad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 2, /obj/item/grown/log/tree/stick = 1)
	allowed_areas = list(/area/outdoors/desert, /area/outdoors/desertdeep)

/datum/mapGeneratorModule/desertwater
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/water/clean)
	allowed_areas = list(/area/outdoors/desert, /area/outdoors/desertdeep)
	spawnableAtoms = list(/obj/structure/flora/tree/stump = 1,
							/obj/structure/flora/grass/water/reeds = 1)

/obj/effect/landmark/mapGenerator/underdarkdesert
	mapGeneratorType = /datum/mapGenerator/underdarkdesert
	endTurfX = 380
	endTurfY = 310
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/underdarkdesert
	modules = list(/datum/mapGeneratorModule/underdarkdesertstone, /datum/mapGeneratorModule/underdarkdesertmud)

/datum/mapGeneratorModule/underdarkdesertstone
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/naturalstone)
	allowed_areas = list(/area/under/underdesert)
	spawnableAtoms = list(/obj/structure/flora/grass/mushroom = 20,
							/obj/item/natural/rock = 25,
							/obj/structure/vine = 5)

/datum/mapGeneratorModule/underdarkdesertmud
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_areas = list(/area/under/underdesert)
	allowed_turfs = list(/turf/open/floor/dirt, /turf/open/floor/desert_grass)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/grass/mushroom = 40,
							/obj/structure/flora/grass = 30,
							/obj/structure/flora/grass/herb/random = 5,
														/obj/structure/flora/grass/maneater = 1,
							/obj/item/grown/log/tree/stick = 4,
							/obj/structure/kneestingers = 1.5,
							/obj/item/natural/stone = 3,
							/obj/item/natural/rock = 3,
							/obj/structure/flora/grass/swampweed = 1)
