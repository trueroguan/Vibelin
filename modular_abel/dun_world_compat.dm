/turf/open/floor/cobblerock/dun_world
	smoothing_flags = NONE
	smoothing_list = null
	neighborlay = null

/turf/open/floor/cobble/dun_world
	smoothing_flags = NONE
	smoothing_list = null
	neighborlay = null

/turf/open/floor/cobble/mossy/dun_world
	smoothing_flags = NONE
	smoothing_list = null
	neighborlay = null

/obj/effect/decal/cobbleedge/dun_world
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/cobbleedge/alt/dun_world
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/cobbleedge/mossy/dun_world
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/curtain/dun_world
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_type = "curtain"
	icon_state = "curtain-open"
	color = "#ffffff"
	alpha = 255
	layer = LARGE_MOB_LAYER

/obj/structure/curtain/dun_world/red
	color = "#a32121"

/obj/structure/curtain/dun_world/blue
	color = CLOTHING_BLUE

/obj/structure/curtain/dun_world/green
	color = CLOTHING_DARK_GREEN

/obj/structure/curtain/dun_world/brown
	color = CLOTHING_BROWN

/obj/structure/curtain/dun_world/purple
	color = "#8747b1"

/obj/structure/curtain/dun_world/magenta
	color = "#962e5c"

/obj/structure/curtain/dun_world/black
	color = "#414143"

/obj/structure/table/wood/counter/dun_world
	dir = SOUTH

/obj/structure/table/wood/counter/dun_world/north
	dir = NORTH

/obj/structure/table/wood/counter/end/dun_world
	dir = SOUTH

/obj/structure/table/wood/counter/end/dun_world/north
	dir = NORTH

/obj/structure/table/wood/counter/end/dun_world/east
	dir = EAST

/obj/structure/table/wood/counter/end/dun_world/west
	dir = WEST

/obj/structure/table/wood/large/dun_world
	dir = SOUTH

/obj/structure/table/wood/large/dun_world/north
	dir = NORTH

/obj/structure/table/wood/large/dun_world/east
	dir = EAST

/obj/structure/table/wood/large/dun_world/west
	dir = WEST

/obj/structure/table/wood/large/corner/dun_world
	dir = SOUTH

/obj/structure/table/wood/large/corner/dun_world/north_east
	dir = NORTHEAST

/obj/structure/table/wood/large/corner/dun_world/north_west
	dir = NORTHWEST

/obj/structure/table/wood/large/corner/dun_world/south_east
	dir = SOUTHEAST

/obj/structure/table/wood/large/corner/dun_world/south_west
	dir = SOUTHWEST

/obj/structure/closet/crate/drawer/dun_world
	dir = SOUTH

/obj/structure/closet/crate/drawer/random/dun_world
	dir = SOUTH

/obj/structure/closet/crate/drawer/inn/dun_world
	dir = SOUTH

/turf/closed/wall/mineral/roofwall/middle/dir1
	dir = NORTH

/turf/closed/wall/mineral/roofwall/middle/dir4
	dir = EAST

/turf/closed/wall/mineral/roofwall/middle/dir8
	dir = WEST

/turf/closed/wall/mineral/roofwall/outercorner/dir1
	dir = NORTH

/turf/closed/wall/mineral/roofwall/outercorner/dir4
	dir = EAST

/turf/closed/wall/mineral/roofwall/outercorner/dir8
	dir = WEST

/turf/closed/wall/mineral/roofwall/innercorner/dir1
	dir = NORTH

/turf/closed/wall/mineral/roofwall/innercorner/dir4
	dir = EAST

/turf/closed/wall/mineral/roofwall/innercorner/dir8
	dir = WEST

/obj/machinery/light/fueled/wallfire/candle/proc/dun_world_force_map_light()
	status = LIGHT_OK
	seton(TRUE)
	update_appearance(UPDATE_ICON_STATE)

/obj/machinery/light/fueled/wallfire/candle/dun_world/Initialize(mapload, ...)
	. = ..()
	if(mapload)
		dun_world_force_map_light()

/obj/machinery/light/fueled/wallfire/candle/r/dun_world/Initialize(mapload, ...)
	. = ..()
	if(mapload)
		dun_world_force_map_light()

/obj/machinery/light/fueled/wallfire/candle/l/dun_world/Initialize(mapload, ...)
	. = ..()
	if(mapload)
		dun_world_force_map_light()

/obj/machinery/light/fueled/wallfire/candle/blue/dun_world/Initialize(mapload, ...)
	. = ..()
	if(mapload)
		dun_world_force_map_light()

/obj/machinery/light/fueled/wallfire/candle/blue/r/dun_world/Initialize(mapload, ...)
	. = ..()
	if(mapload)
		dun_world_force_map_light()

/obj/machinery/light/fueled/wallfire/candle/blue/l/dun_world/Initialize(mapload, ...)
	. = ..()
	if(mapload)
		dun_world_force_map_light()

/obj/machinery/light/fueled/wallfire/candle/weak/dun_world/Initialize(mapload, ...)
	. = ..()
	if(mapload)
		dun_world_force_map_light()

/obj/machinery/light/fueled/wallfire/candle/weak/r/dun_world/Initialize(mapload, ...)
	. = ..()
	if(mapload)
		dun_world_force_map_light()

/obj/machinery/light/fueled/wallfire/candle/weak/l/dun_world/Initialize(mapload, ...)
	. = ..()
	if(mapload)
		dun_world_force_map_light()

/obj/machinery/light/fueled/wallfire/candle/lamp/dun_world/Initialize(mapload, ...)
	. = ..()
	if(mapload)
		dun_world_force_map_light()

/mob/dead/observer
	hud_type = /datum/hud/ghost/dun_world

/datum/hud/ghost/dun_world/New(mob/owner)
	. = ..()
	var/atom/movable/screen/ghost/teleport/old_teleport
	for(var/atom/movable/screen/ghost/teleport/teleport_button as anything in static_inventory)
		old_teleport = teleport_button
		break
	if(old_teleport)
		static_inventory -= old_teleport
		qdel(old_teleport)
	static_inventory += new /atom/movable/screen/ghost/teleport/dun_world(null, src)

/atom/movable/screen/ghost/teleport/dun_world/Click()
	var/mob/dead/observer/G = usr
	G.dun_world_dead_tele()

/mob/dead/observer/proc/dun_world_dead_tele()
	if(!isobserver(src))
		to_chat(src, span_warning("Not when you're not dead!"))
		return

	var/area/thearea = browser_input_list(src, "Area to jump to", "Where?", GLOB.areas)
	if(!thearea || QDELETED(src))
		return

	var/list/possible_turfs = list()
	for(var/list/zlevel_turfs as anything in thearea.get_zlevel_turf_lists())
		possible_turfs += zlevel_turfs

	if(!length(possible_turfs))
		for(var/turf/T as anything in get_area_turfs(thearea.type))
			possible_turfs += T

	if(!length(possible_turfs))
		to_chat(src, span_warning("No location available!"))
		return

	forceMove(pick(possible_turfs))
