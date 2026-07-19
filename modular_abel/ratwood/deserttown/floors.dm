/turf/open/floor/dunes
	name = "sand"
	desc = "Its course and rough, and it gets everywhere."
	icon = 'modular_abel/ratwood/icons/deserttown/desertfloor.dmi'
	icon_state = "dune1"
	footstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/dirtland.ogg'
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_SAND
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT + SMOOTH_GROUP_FLOOR_DIRT_ROAD + SMOOTH_GROUP_FLOOR_GRASS + SMOOTH_GROUP_FLOOR_SNOW + SMOOTH_GROUP_FLOOR_STONE

/turf/open/floor/dunes/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)
	icon_state = "dune[rand(1, 16)]"

/obj/effect/decal/duneedge
	name = ""
	desc = ""
	icon = 'modular_abel/ratwood/icons/deserttown/duneedge.dmi'
	icon_state = "duneedge"
	mouse_opacity = 0

/turf/open/floor/sandbrick
	name = "sandbrick floor"
	desc = "Bricks of sun-fired sand, laid flat and worn smooth."
	icon = 'modular_abel/ratwood/icons/deserttown/desertfloor.dmi'
	icon_state = "sand-brick1"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.ogg'
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_STONE
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT_ROAD + SMOOTH_GROUP_FLOOR_GRASS
	damage_deflection = 10
	max_integrity = 1000
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')

/turf/open/floor/sandbrick/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)
	icon_state = "sand-brick[rand(1, 4)]"

/datum/blueprint_recipe/floor/sandbrickfloor
	name = "Sandbrick Floor"
	desc = "A floor of sun-fired sandbricks."
	result_type = /turf/open/floor/sandbrick
	required_materials = list(
		/obj/item/natural/stone = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/attribute/skill/craft/masonry
	craftdiff = 1

/turf/open/floor/citybrick
	name = "city brick"
	desc = "Cut brickwork of a desert city."
	icon = 'modular_abel/ratwood/icons/deserttown/desertfloor.dmi'
	icon_state = "city-brick1"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.ogg'
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_STONE
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT_ROAD + SMOOTH_GROUP_FLOOR_GRASS
	damage_deflection = 10
	max_integrity = 1000
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	abstract_type = /turf/open/floor/citybrick

/turf/open/floor/citybrick/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/citybrick/citybrick1
	icon_state = "city-brick1-1"

/turf/open/floor/citybrick/citybrick1/Initialize()
	. = ..()
	icon_state = "city-brick1-[rand(1, 4)]"

/turf/open/floor/citybrick/citybrick2
	icon_state = "city-brick2-1"

/turf/open/floor/citybrick/citybrick2/Initialize()
	. = ..()
	icon_state = "city-brick2-[rand(1, 5)]"

/turf/open/floor/citybrick/citybrick3
	icon_state = "city-brick3-1"

/turf/open/floor/citybrick/citybrick4
	icon_state = "city-brick4-1"

/turf/open/floor/citybrick/citybrick4/Initialize()
	. = ..()
	icon_state = "city-brick4-[rand(1, 2)]"

/turf/open/floor/citybrick/citybrick5
	icon_state = "city-brick5-1"

/turf/open/floor/citybrick/citybrick5/Initialize()
	. = ..()
	icon_state = "city-brick5-[rand(1, 2)]"

/turf/open/floor/citybrick/citybrick6
	icon_state = "city-brick6-1"

/turf/open/floor/citybrick/citybrick6/Initialize()
	. = ..()
	icon_state = "city-brick6-[rand(1, 2)]"

/turf/open/floor/lightpath
	name = "light path"
	desc = "Packed pale sand, trodden into a path."
	icon = 'modular_abel/ratwood/icons/deserttown/desertfloor.dmi'
	icon_state = "light-path1"
	footstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_STONE
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT + SMOOTH_GROUP_FLOOR_SAND

/turf/open/floor/lightpath/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)
	icon_state = "light-path[rand(1, 8)]"

/turf/open/floor/darkpath
	name = "dark path"
	desc = "Packed dark sand, trodden into a path."
	icon = 'modular_abel/ratwood/icons/deserttown/desertfloor.dmi'
	icon_state = "dark-path1"
	slowdown = 0
	footstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_STONE
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT + SMOOTH_GROUP_FLOOR_SAND

/turf/open/floor/darkpath/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)
	icon_state = "dark-path[rand(1, 8)]"

/datum/blueprint_recipe/floor/darksandbrickfloor
	name = "Dark Sandbrick Floor"
	desc = "A floor of packed dark sandbrick."
	result_type = /turf/open/floor/darkpath
	required_materials = list(
		/obj/item/natural/stone = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/attribute/skill/craft/masonry
	craftdiff = 1

/obj/effect/decal/desertgrassedge
	name = ""
	desc = ""
	icon = 'modular_abel/ratwood/icons/deserttown/desertfloor.dmi'
	icon_state = "desertgrassedge"
	mouse_opacity = 0

/turf/open/floor/desert_grass
	name = "desert grass"
	desc = "Grass, barely."
	icon = 'modular_abel/ratwood/icons/deserttown/desertfloor.dmi'
	icon_state = "desertgrass"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.ogg'
	slowdown = 0
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_GRASS
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT + SMOOTH_GROUP_FLOOR_DIRT_ROAD + SMOOTH_GROUP_FLOOR_SNOW + SMOOTH_GROUP_FLOOR_STONE + SMOOTH_GROUP_FLOOR_SAND
	neighborlay = "desertgrassedge"
	spread_chance = 15
	burn_power = 6

/turf/open/floor/desert_grass/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/desert_grass/atom_destruction(damage_flag)
	. = ..()
	ChangeTurf(/turf/open/floor/dirt/desert, flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/desert_grass/nospawn

/turf/open/floor/dirt/desert
	icon = 'modular_abel/ratwood/icons/deserttown/desertfloor.dmi'

/turf/open/floor/dirt/desert/nospawn

/turf/open/floor/dirt/road/desert
	icon = 'modular_abel/ratwood/icons/deserttown/desertfloor.dmi'

/turf/open/floor/grass/desert
	icon = 'modular_abel/ratwood/icons/deserttown/desertfloor.dmi'

/turf/open/floor/deserttile
	name = "desert tile"
	desc = "Fired clay tiling in desert fashion."
	icon = 'modular_abel/ratwood/icons/deserttown/desertfloor.dmi'
	icon_state = "tiledrab"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.ogg'
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_STONE
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT_ROAD + SMOOTH_GROUP_FLOOR_GRASS
	damage_deflection = 10
	max_integrity = 1000
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	abstract_type = /turf/open/floor/deserttile

/turf/open/floor/naturalstone/sandstone
	name = "rough sandstone ground"
	desc = "Rough sandstone that's been exposed to the air either through erosion or the swing of a pickaxe. Dust wisps through the cracks."
	icon = 'modular_abel/ratwood/icons/deserttown/desertfloor.dmi'
	icon_state = "digstone"
