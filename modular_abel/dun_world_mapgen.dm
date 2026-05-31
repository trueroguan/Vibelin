/obj/effect/landmark/mapGenerator/dun_world/forest
	mapGeneratorType = /datum/mapGenerator/dun_world/forest
	endTurfX = 255
	endTurfY = 255
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/dun_world/forest
	modules = list(
		/datum/mapGeneratorModule/dun_world/forestgrassturf,
		/datum/mapGeneratorModule/dun_world/forest,
		/datum/mapGeneratorModule/dun_world/forestroad,
		/datum/mapGeneratorModule/dun_world/forestgrass,
		/datum/mapGeneratorModule/dun_world/forestwater,
		/datum/mapGeneratorModule/dun_world/forestswampwater,
	)

/datum/mapGeneratorModule/dun_world/forest
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableAtoms = list(
		/obj/structure/flora/newtree = 30,
		/obj/structure/flora/grass/bush = 25,
		/obj/structure/flora/grass = 200,
		/obj/structure/flora/grass/herb/random = 7,
		/obj/structure/flora/grass/maneater = 13,
		/obj/structure/flora/grass/pyroclasticflowers = 3,
		/obj/item/natural/stone = 23,
		/obj/item/natural/rock = 6,
		/obj/item/grown/log/tree/stick = 16,
		/obj/structure/flora/tree/stump = 7,
		/obj/structure/leyline = 1,
		/obj/structure/closet/dirthole/closed = 3,
		/obj/structure/flora/grass/maneater/real = 3,
		/obj/structure/essence_node = 1,
	)
	spawnableTurfs = list(
		/turf/open/floor/dirt/road = 2,
		/turf/open/water/swamp = 1,
	)
	allowed_areas = list(/area/rogue/outdoors/woods, /area/rogue/outdoors/beach/forest)

/datum/mapGeneratorModule/dun_world/forestroad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/woods, /area/rogue/outdoors/beach/forest)
	spawnableAtoms = list(
		/obj/item/natural/stone = 9,
		/obj/item/grown/log/tree/stick = 6,
	)

/datum/mapGeneratorModule/dun_world/forestgrassturf
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	spawnableTurfs = list(/turf/open/floor/grass = 200)
	allowed_areas = list(/area/rogue/outdoors/woods, /area/rogue/outdoors/beach/forest)

/datum/mapGeneratorModule/dun_world/forestgrass
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/floor/grass, /turf/open/floor/grass/red, /turf/open/floor/grass/yel, /turf/open/floor/grass/cold)
	allowed_areas = list(/area/rogue/outdoors/woods, /area/rogue/outdoors/beach/forest)
	spawnableAtoms = list(
		/obj/structure/flora/tree = 30,
		/obj/structure/flora/tree/wise = 1,
		/obj/structure/flora/grass/bush = 25,
		/obj/structure/flora/grass = 200,
		/obj/structure/flora/grass/herb/random = 7,
		/obj/structure/flora/grass/maneater = 13,
		/obj/structure/flora/grass/maneater/real = 2,
		/obj/item/natural/stone = 6,
		/obj/item/natural/rock = 1,
		/obj/item/grown/log/tree/stick = 3,
		/obj/structure/leyline = 0.25,
		/obj/structure/flora/tree/stump = 3,
		/obj/structure/essence_node = 1,
	)

/datum/mapGeneratorModule/dun_world/forestwater
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/water/clean)
	allowed_areas = list(/area/rogue/outdoors/woods, /area/rogue/outdoors/beach/forest)
	spawnableAtoms = list(
		/obj/structure/flora/grass/water = 20,
		/obj/structure/flora/grass/water/reeds = 25,
		/obj/structure/kneestingers = 25,
	)

/datum/mapGeneratorModule/dun_world/forestswampwater
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/water/swamp)
	allowed_areas = list(/area/rogue/outdoors/woods, /area/rogue/outdoors/beach/forest)
	spawnableAtoms = list(
		/obj/structure/flora/grass/water = 20,
		/obj/structure/flora/grass/water/reeds = 30,
		/obj/structure/kneestingers = 30,
	)

/obj/effect/landmark/mapGenerator/dun_world/beach
	mapGeneratorType = /datum/mapGenerator/dun_world/beach
	endTurfX = 128
	endTurfY = 128
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/dun_world/beach
	modules = list(
		/datum/mapGeneratorModule/dun_world/beach,
		/datum/mapGeneratorModule/dun_world/beachgrass,
		/datum/mapGeneratorModule/dun_world/beachroad,
		/datum/mapGeneratorModule/dun_world/beachcoast,
		/datum/mapGeneratorModule/dun_world/beachsand,
	)

/datum/mapGeneratorModule/dun_world/beach
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/beach/forest)
	spawnableAtoms = list(
		/obj/structure/flora/newtree = 15,
		/obj/structure/flora/grass/bush = 8,
		/obj/structure/flora/grass = 20,
		/obj/structure/flora/grass/maneater = 16,
		/obj/item/natural/stone = 18,
		/obj/item/natural/rock = 2,
		/obj/item/grown/log/tree/stick = 3,
		/obj/structure/leyline = 2,
		/obj/structure/closet/dirthole/closed = 3,
		/obj/structure/flora/tree/burnt = 3,
	)
	spawnableTurfs = list(/turf/open/floor/dirt/road = 5)

/datum/mapGeneratorModule/dun_world/beachgrass
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/grass)
	allowed_areas = list(/area/rogue/outdoors/beach/forest)
	spawnableAtoms = list(
		/obj/structure/flora/grass/bush = 5,
		/obj/structure/flora/grass = 35,
		/obj/structure/flora/grass/maneater = 4,
		/obj/item/natural/stone = 8,
		/obj/item/natural/rock = 2,
		/obj/item/grown/log/tree/stick = 10,
	)
	spawnableTurfs = list(/turf/open/floor/dirt/road = 5)

/datum/mapGeneratorModule/dun_world/beachroad
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS | CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/beach/forest)
	spawnableAtoms = list(
		/obj/item/natural/stone = 11,
		/obj/item/grown/log/tree/stick = 1,
	)

/datum/mapGeneratorModule/dun_world/beachcoast
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/water/ocean)
	allowed_areas = list(/area/rogue/outdoors/beach)
	spawnableAtoms = list(
		/obj/structure/roguerock = 3,
	)

/datum/mapGeneratorModule/dun_world/beachsand
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/sand)
	allowed_areas = list(/area/rogue/outdoors/beach)
	spawnableAtoms = list(
		/obj/item/natural/stone = 15,
		/obj/item/grown/log/tree/stick = 20,
	)

/obj/effect/landmark/mapGenerator/dun_world/roguetownfield
	mapGeneratorType = /datum/mapGenerator/dun_world/roguetownfield
	endTurfX = 155
	endTurfY = 155
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/dun_world/roguetownfield
	modules = list(
		/datum/mapGeneratorModule/dun_world/roguetownfield/grass,
		/datum/mapGeneratorModule/dun_world/roguetowngrass,
		/datum/mapGeneratorModule/dun_world/roguetownfield,
		/datum/mapGeneratorModule/dun_world/roguetownfield/road,
	)

/datum/mapGeneratorModule/dun_world/roguetownfield
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/rtfield)
	spawnableAtoms = list(
		/obj/structure/flora/newtree = 5,
		/obj/structure/flora/grass/bush = 13,
		/obj/structure/flora/grass = 40,
		/obj/structure/flora/grass/maneater = 16,
		/obj/item/natural/stone = 18,
		/obj/item/natural/rock = 2,
		/obj/item/grown/log/tree/stick = 3,
		/obj/structure/closet/dirthole/closed = 3,
		/obj/structure/flora/grass/pyroclasticflowers = 3,
	)
	spawnableTurfs = list(/turf/open/floor/dirt/road = 5)

/datum/mapGeneratorModule/dun_world/roguetownfield/road
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/rtfield)
	spawnableAtoms = list(
		/obj/item/natural/stone = 18,
		/obj/item/grown/log/tree/stick = 3,
	)

/datum/mapGeneratorModule/dun_world/roguetownfield/grass
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/rtfield)
	spawnableTurfs = list(/turf/open/floor/grass = 15)
	spawnableAtoms = list(/obj/structure/flora/grass = 1)

/datum/mapGeneratorModule/dun_world/roguetowngrass
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt, /turf/open/floor/grass, /turf/open/floor/grass/red, /turf/open/floor/grass/yel, /turf/open/floor/grass/cold)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/town, /area/rogue/outdoors/rtfield)
	spawnableAtoms = list(
		/obj/structure/flora/grass = 40,
		/obj/structure/flora/grass/maneater = 7,
		/obj/item/natural/stone = 18,
		/obj/item/grown/log/tree/stick = 3,
	)

/obj/effect/landmark/mapGenerator/dun_world/bog
	mapGeneratorType = /datum/mapGenerator/dun_world/bog
	endTurfX = 255
	endTurfY = 400
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/dun_world/bog
	modules = list(
		/datum/mapGeneratorModule/dun_world/boggrassturf,
		/datum/mapGeneratorModule/dun_world/bog,
		/datum/mapGeneratorModule/dun_world/bogroad,
		/datum/mapGeneratorModule/dun_world/boggrass,
		/datum/mapGeneratorModule/dun_world/bogwater,
	)

/datum/mapGeneratorModule/dun_world/bog
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/bog)
	spawnableAtoms = list(
		/obj/structure/flora/newtree = 30,
		/obj/structure/flora/grass/bush = 10,
		/obj/structure/flora/grass = 26,
		/obj/structure/flora/grass/maneater = 13,
		/obj/item/natural/stone = 23,
		/obj/item/natural/rock = 6,
		/obj/item/natural/artifact = 4,
		/obj/structure/leyline = 1,
		/obj/structure/voidstoneobelisk = 1,
		/obj/structure/flora/grass/herb/random = 4,
		/obj/item/grown/log/tree/stick = 16,
		/obj/structure/flora/tree/stump = 7,
		/obj/structure/closet/dirthole/closed = 3,
		/obj/structure/flora/grass/swampweed = 10,
		/obj/structure/flora/grass/maneater/real = 3,
		/obj/structure/essence_node = 1,
	)
	spawnableTurfs = list(
		/turf/open/floor/dirt/road = 2,
		/turf/open/water/swamp = 1,
	)

/datum/mapGeneratorModule/dun_world/bogroad
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/bog)
	spawnableAtoms = list(
		/obj/item/natural/stone = 9,
		/obj/item/grown/log/tree/stick = 6,
	)

/datum/mapGeneratorModule/dun_world/boggrassturf
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/bog)
	spawnableTurfs = list(/turf/open/floor/grass = 23)

/datum/mapGeneratorModule/dun_world/boggrass
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/grass)
	allowed_areas = list(/area/rogue/outdoors/bog)
	spawnableAtoms = list(
		/obj/structure/kneestingers = 20,
		/obj/structure/flora/tree = 30,
		/obj/structure/flora/tree/wise = 5,
		/obj/structure/flora/grass/bush = 10,
		/obj/structure/flora/grass = 44,
		/obj/structure/flora/grass/maneater = 15,
		/obj/structure/flora/grass/maneater/real = 10,
		/obj/item/natural/stone = 6,
		/obj/item/natural/rock = 1,
		/obj/item/grown/log/tree/stick = 3,
		/obj/structure/flora/tree/stump = 3,
		/obj/structure/flora/tree/evil = 5,
		/obj/structure/essence_node = 1,
	)

/datum/mapGeneratorModule/dun_world/bogwater
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/water/swamp, /turf/open/water/swamp/deep)
	allowed_areas = list(/area/rogue/outdoors/bog)
	spawnableAtoms = list(
		/obj/structure/kneestingers = 60,
		/obj/item/restraints/legcuffs/beartrap/armed = 10,
		/obj/structure/flora/tree/stump = 3,
	)

/obj/effect/landmark/mapGenerator/dun_world/cave
	mapGeneratorType = /datum/mapGenerator/dun_world/cave
	endTurfX = 128
	endTurfY = 128
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/dun_world/cave
	modules = list(
		/datum/mapGeneratorModule/dun_world/cave,
		/datum/mapGeneratorModule/dun_world/cavedirt,
		/datum/mapGeneratorModule/dun_world/cavebeach,
	)

/datum/mapGeneratorModule/dun_world/cave
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road, /turf/open/water, /turf/open/floor/volcanic)
	allowed_areas = list(/area/rogue/under/cave/spider, /area/rogue/indoors/cave, /area/rogue/under/cavewet, /area/rogue/under/cave)
	spawnableAtoms = list(
		/obj/item/natural/stone = 19,
		/obj/structure/roguerock = 5,
		/obj/item/natural/rock = 3,
		/obj/structure/kneestingers = 4,
	)

/datum/mapGeneratorModule/dun_world/cavedirt
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt)
	allowed_areas = list(/area/rogue/under/cave/spider, /area/rogue/indoors/cave, /area/rogue/under/cavewet, /area/rogue/under/cave)
	spawnableAtoms = list(
		/obj/structure/flora/shroom_tree = 20,
		/obj/structure/flora/grass/mushroom = 6,
		/obj/structure/roguerock = 20,
		/obj/structure/flora/grass = 14,
		/obj/structure/closet/dirthole/closed = 6,
		/obj/item/natural/stone = 24,
		/obj/item/natural/rock = 8,
		/obj/structure/kneestingers = 3,
	)

/datum/mapGeneratorModule/dun_world/cavebeach
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/water/ocean)
	allowed_areas = list(/area/rogue/outdoors/beach)
	spawnableAtoms = list(
		/obj/structure/roguerock = 3,
	)

/obj/effect/landmark/mapGenerator/dun_world/underdark
	mapGeneratorType = /datum/mapGenerator/dun_world/underdark
	endTurfX = 255
	endTurfY = 450
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/dun_world/underdark
	modules = list(
		/datum/mapGeneratorModule/dun_world/underdarkstone,
		/datum/mapGeneratorModule/dun_world/underdarkmud,
	)

/datum/mapGeneratorModule/dun_world/underdarkstone
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/naturalstone)
	allowed_areas = list(/area/rogue/under/underdark)
	spawnableAtoms = list(
		/obj/structure/flora/shroom_tree = 30,
		/obj/structure/flora/grass/mushroom = 40,
		/obj/structure/roguerock = 25,
		/obj/item/natural/rock = 25,
		/obj/structure/vine = 5,
		/obj/structure/kneestingers = 10,
		/obj/structure/wild_plant/nospread/mushroom/caveweep = 4,
		/obj/structure/wild_plant/nospread/mushroom/drowsbane = 4,
	)

/datum/mapGeneratorModule/dun_world/underdarkmud
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/under/underdark)
	spawnableAtoms = list(
		/obj/structure/flora/grass/mushroom = 40,
		/obj/structure/flora/grass/thorn_bush = 10,
		/obj/structure/flora/shroom_tree = 40,
		/obj/structure/flora/grass = 30,
		/obj/structure/flora/grass/herb/random = 5,
		/obj/structure/kneestingers = 10,
	)

/obj/effect/landmark/mapGenerator/dun_world/mountain
	mapGeneratorType = /datum/mapGenerator/dun_world/mtn
	endTurfX = 255
	endTurfY = 255
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/dun_world/mtn
	modules = list(/datum/mapGeneratorModule/dun_world/mtn)

/datum/mapGeneratorModule/dun_world/mtn
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/mountains)
	spawnableAtoms = list(
		/obj/structure/roguerock = 5,
		/obj/item/natural/stone = 18,
		/obj/item/natural/rock = 10,
	)

/obj/effect/landmark/mapGenerator/dun_world/decap
	mapGeneratorType = /datum/mapGenerator/dun_world/decap
	endTurfX = 255
	endTurfY = 255
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/dun_world/decap
	modules = list(
		/datum/mapGeneratorModule/dun_world/decapsnow,
		/datum/mapGeneratorModule/dun_world/decaproad,
		/datum/mapGeneratorModule/dun_world/decapgrass,
	)

/datum/mapGeneratorModule/dun_world/decapsnow
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/snow)
	excluded_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/mountains/decap)
	spawnableAtoms = list(
		/obj/structure/flora/grass/tundra = 35,
		/obj/item/grown/log/tree/stick = 16,
		/obj/structure/flora/grass/pyroclasticflowers = 3,
		/obj/structure/flora/grass/maneater/real = 3,
		/obj/structure/flora/grass/herb/random = 5,
		/obj/structure/leyline = 2,
	)
	spawnableTurfs = list(/turf/open/floor/snow/patchy = 15)

/datum/mapGeneratorModule/dun_world/decaproad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/mountains/decap)
	spawnableAtoms = list(
		/obj/item/natural/stone = 15,
		/obj/item/natural/rock = 3,
		/obj/item/grown/log/tree/stick = 6,
	)

/datum/mapGeneratorModule/dun_world/decapgrass
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/floor/grass, /turf/open/floor/grass/red, /turf/open/floor/grass/yel, /turf/open/floor/grass/cold)
	allowed_areas = list(/area/rogue/outdoors/mountains/decap)
	spawnableAtoms = list(
		/obj/structure/flora/grass = 25,
		/obj/structure/flora/grass/herb/random = 2,
		/obj/item/natural/stone = 6,
		/obj/item/natural/rock = 1,
		/obj/item/grown/log/tree/stick = 3,
	)
