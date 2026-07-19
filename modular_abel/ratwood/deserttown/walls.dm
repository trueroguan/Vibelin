/turf/closed/wall/mineral/sandstone
	name = "sandstone wall"
	desc = "A wall of smooth, unyielding sandstone."
	icon = 'modular_abel/ratwood/icons/deserttown/sandstone_wall.dmi'
	icon_state = MAP_SWITCH("sandstone", "sandstone-0")
	blade_dulling = DULLING_BASH
	max_integrity = 1800
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_SANDSTONE
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_SANDSTONE
	above_floor = /turf/open/floor/citybrick/citybrick1
	baseturfs = /turf/open/floor/citybrick/citybrick1
	neighborlay = "dirtedge"
	climbdiff = 3
	damage_deflection = 10
	hardness = 3

/datum/blueprint_recipe/wall/sandstone
	name = "Sandstone Wall"
	desc = "A wall of smooth sandstone."
	result_type = /turf/closed/wall/mineral/sandstone
	required_materials = list(
		/obj/item/natural/stone = 2
	)
	construct_tool = /obj/item/weapon/hammer
	skillcraft = /datum/attribute/skill/craft/masonry
	craftdiff = 2

/turf/closed/wall/mineral/sandbrick
	name = "sandbrick wall"
	desc = "A wall of smooth, unyielding bricks."
	icon = 'modular_abel/ratwood/icons/deserttown/sandbrick_wall.dmi'
	icon_state = MAP_SWITCH("sandbrick", "sandbrick-0")
	blade_dulling = DULLING_BASH
	max_integrity = 1800
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_SANDBRICK
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_SANDBRICK
	above_floor = /turf/open/floor/darkpath
	baseturfs = /turf/open/floor/darkpath
	neighborlay = "dirtedge"
	climbdiff = 3
	damage_deflection = 10
	hardness = 3

/datum/blueprint_recipe/wall/sandbrick
	name = "Sandbrick Wall"
	desc = "A wall of smooth sandbricks."
	result_type = /turf/closed/wall/mineral/sandbrick
	required_materials = list(
		/obj/item/natural/stone = 2
	)
	construct_tool = /obj/item/weapon/hammer
	skillcraft = /datum/attribute/skill/craft/masonry
	craftdiff = 2

/turf/closed/mineral/sandstone
	name = "sandstone"
	desc = "Dusty, sand-blasted rock."
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock.dmi'
	icon_state = MAP_SWITCH("sandrock", "sandrock-0")
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_SANDROCK
	smoothing_list = SMOOTH_GROUP_SANDROCK
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone

/turf/closed/mineral/bedrock/sandstone
	name = "sandstone"
	desc = "Seems barren and nigh-indestructable."
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock.dmi'
	icon_state = "bedrock"

/turf/closed/mineral/random/sandstone
	name = "sandstone"
	desc = "Dusty, sand-blasted rock."
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock.dmi'
	icon_state = MAP_SWITCH("sandrock", "sandrock-0")
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_SANDROCK
	smoothing_list = SMOOTH_GROUP_SANDROCK
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone
	mineralSpawnChanceList = list(
		/turf/closed/mineral/salt/sandstone = 5,
		/turf/closed/mineral/iron/sandstone = 15,
		/turf/closed/mineral/copper/sandstone = 10,
		/turf/closed/mineral/coal/sandstone = 25)

/turf/closed/mineral/random/sandstone/med
	mineralChance = 10
	mineralSpawnChanceList = list(
		/turf/closed/mineral/salt/sandstone = 5,
		/turf/closed/mineral/gold/sandstone = 3,
		/turf/closed/mineral/silver/sandstone = 2,
		/turf/closed/mineral/iron/sandstone = 33,
		/turf/closed/mineral/mana_crystal/sandstone = 15,
		/turf/closed/mineral/cinnabar/sandstone = 15,
		/turf/closed/mineral/copper/sandstone = 15,
		/turf/closed/mineral/tin/sandstone = 10,
		/turf/closed/mineral/coal/sandstone = 14,
		/turf/closed/mineral/gemeralds/sandstone = 1)

/turf/closed/mineral/random/sandstone/high
	mineralChance = 33
	mineralSpawnChanceList = list(
		/turf/closed/mineral/mana_crystal/sandstone = 15,
		/turf/closed/mineral/cinnabar/sandstone = 15,
		/turf/closed/mineral/salt/sandstone = 5,
		/turf/closed/mineral/gold/sandstone = 9,
		/turf/closed/mineral/silver/sandstone = 5,
		/turf/closed/mineral/iron/sandstone = 33,
		/turf/closed/mineral/copper/sandstone = 20,
		/turf/closed/mineral/tin/sandstone = 12,
		/turf/closed/mineral/coal/sandstone = 19,
		/turf/closed/mineral/gemeralds/sandstone = 3)

/turf/closed/mineral/gold/sandstone
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock.dmi'
	icon_state = MAP_SWITCH("sandrock", "sandrock-0")
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_SANDROCK
	smoothing_list = SMOOTH_GROUP_SANDROCK
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone

/turf/closed/mineral/silver/sandstone
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock.dmi'
	icon_state = MAP_SWITCH("sandrock", "sandrock-0")
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_SANDROCK
	smoothing_list = SMOOTH_GROUP_SANDROCK
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone

/turf/closed/mineral/salt/sandstone
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock.dmi'
	icon_state = MAP_SWITCH("sandrock", "sandrock-0")
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_SANDROCK
	smoothing_list = SMOOTH_GROUP_SANDROCK
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone

/turf/closed/mineral/iron/sandstone
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock.dmi'
	icon_state = MAP_SWITCH("sandrock", "sandrock-0")
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_SANDROCK
	smoothing_list = SMOOTH_GROUP_SANDROCK
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone

/turf/closed/mineral/copper/sandstone
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock.dmi'
	icon_state = MAP_SWITCH("sandrock", "sandrock-0")
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_SANDROCK
	smoothing_list = SMOOTH_GROUP_SANDROCK
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone

/turf/closed/mineral/tin/sandstone
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock.dmi'
	icon_state = MAP_SWITCH("sandrock", "sandrock-0")
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_SANDROCK
	smoothing_list = SMOOTH_GROUP_SANDROCK
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone

/turf/closed/mineral/coal/sandstone
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock.dmi'
	icon_state = MAP_SWITCH("sandrock", "sandrock-0")
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_SANDROCK
	smoothing_list = SMOOTH_GROUP_SANDROCK
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone

/turf/closed/mineral/mana_crystal/sandstone
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock.dmi'
	icon_state = MAP_SWITCH("sandrock", "sandrock-0")
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_SANDROCK
	smoothing_list = SMOOTH_GROUP_SANDROCK
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone

/turf/closed/mineral/cinnabar/sandstone
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock.dmi'
	icon_state = MAP_SWITCH("sandrock", "sandrock-0")
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_SANDROCK
	smoothing_list = SMOOTH_GROUP_SANDROCK
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone

/turf/closed/mineral/gemeralds/sandstone
	icon = 'modular_abel/ratwood/icons/deserttown/sandrock.dmi'
	icon_state = MAP_SWITCH("sandrock", "sandrock-0")
	smoothing_groups = SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_SANDROCK
	smoothing_list = SMOOTH_GROUP_SANDROCK
	turf_type = /turf/open/floor/naturalstone/sandstone
	baseturfs = /turf/open/floor/naturalstone/sandstone
	above_floor = /turf/open/floor/naturalstone/sandstone
