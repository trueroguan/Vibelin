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

/obj/structure/fluff/railing/tall/palisade/dun_world
	desc = "A rudimentary barrier that might keep the monsters at bay."
	max_integrity = 400
	climbable = FALSE
	pass_crawl = FALSE
	pass_throwing = FALSE
	pass_projectile = FALSE
	opacity = TRUE

/obj/structure/fluff/railing/tall/palisade/dun_world/Initialize(mapload, ...)
	. = ..()
	smooth_dun_world_palisades()

/obj/structure/fluff/railing/tall/palisade/dun_world/Destroy()
	var/turf/old_loc = loc
	. = ..()
	if(!old_loc)
		return
	for(var/check_dir in GLOB.cardinals)
		var/turf/neighbor_turf = get_step(old_loc, check_dir)
		if(!neighbor_turf)
			continue
		for(var/obj/structure/fluff/railing/tall/palisade/dun_world/neighbor in neighbor_turf)
			neighbor.smooth_dun_world_palisades(TRUE)

/obj/structure/fluff/railing/tall/palisade/dun_world/OnCrafted(dirin, mob/user)
	. = ..()
	smooth_dun_world_palisades()

/obj/structure/fluff/railing/tall/palisade/dun_world/proc/smooth_dun_world_palisades(neighbors = FALSE)
	cut_overlays()
	if(!(dir in list(EAST, WEST)))
		return
	var/turf/north_turf = get_step(src, NORTH)
	if(north_turf)
		for(var/obj/structure/fluff/railing/tall/palisade/dun_world/fence in north_turf)
			if(fence.dir != dir)
				continue
			if(!neighbors)
				fence.smooth_dun_world_palisades(TRUE)
			var/mutable_appearance/smooth_above = mutable_appearance(icon, "fence_smooth_above")
			smooth_above.dir = dir
			add_overlay(smooth_above)
	var/turf/south_turf = get_step(src, SOUTH)
	if(south_turf)
		for(var/obj/structure/fluff/railing/tall/palisade/dun_world/fence in south_turf)
			if(fence.dir != dir)
				continue
			if(!neighbors)
				fence.smooth_dun_world_palisades(TRUE)
			var/mutable_appearance/smooth_below = mutable_appearance(icon, "fence_smooth_below")
			smooth_below.dir = dir
			add_overlay(smooth_below)

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

// Dun World wallfire candle compat.
//
// Why this is more involved than just "empty subtype":
// /obj/machinery/light/fueled/wallfire/candle uses STATIC_LIGHT (corner-based) but in
// the Dun World z-level its corner-based lighting never visibly applies — the light
// datum is created, light_on/light_outer_range/light_color are all set, yet adjacent
// turfs stay dark. Other STATIC_LIGHT sources (firebowl, brazier, chand) light up
// fine on the same map, and MOVABLE_LIGHT sources (torches) also work — so the
// failure is specific to wallfire/candle's static-light path on this z, not the
// lighting system as a whole.
//
// We sidestep the issue by:
//   1) Forcing the candle's own brightness to 0 so /obj/machinery/light/proc/update
//      can't (re)create the broken static light_source.
//   2) Spawning a stationary MOVABLE_LIGHT proxy at the candle's turf that carries
//      the actual outer_range / power / colour. MOVABLE_LIGHT uses the overlay
//      lighting component (same code path as torches), which works here.
//   3) Re-syncing the proxy on update()/Destroy so burn_out, fire_act, and dir
//      changes stay in step.

/obj/effect/dun_world_movable_light_proxy
	name = ""
	desc = ""
	icon = null
	icon_state = null
	alpha = 0
	anchored = TRUE
	invisibility = INVISIBILITY_LIGHTING
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_system = MOVABLE_LIGHT
	light_on = FALSE

/obj/machinery/light/fueled/wallfire/candle
	var/dun_world_compat = FALSE
	var/tmp/obj/effect/dun_world_movable_light_proxy/dun_world_proxy

/obj/machinery/light/fueled/wallfire/candle/proc/dun_world_sync_light_proxy()
	if(!dun_world_compat)
		return
	var/proxy_outer = dun_world_compat_outer_range()
	var/proxy_power = dun_world_compat_power()
	var/proxy_color = dun_world_compat_color()
	var/should_be_on = on && status == LIGHT_OK && proxy_outer > 0 && proxy_power > 0
	if(!should_be_on)
		if(dun_world_proxy)
			dun_world_proxy.set_light_on(FALSE)
		return
	if(QDELETED(dun_world_proxy))
		dun_world_proxy = null
	if(!dun_world_proxy)
		dun_world_proxy = new(get_turf(src))
	else if(dun_world_proxy.loc != get_turf(src))
		dun_world_proxy.forceMove(get_turf(src))
	dun_world_proxy.set_light_range(0, proxy_outer)
	dun_world_proxy.set_light_power(proxy_power)
	dun_world_proxy.set_light_color(proxy_color)
	dun_world_proxy.set_light_on(TRUE)

/obj/machinery/light/fueled/wallfire/candle/proc/dun_world_compat_outer_range()
	return 8

/obj/machinery/light/fueled/wallfire/candle/proc/dun_world_compat_power()
	return 1

/obj/machinery/light/fueled/wallfire/candle/proc/dun_world_compat_color()
	if(color)
		return color
	return bulb_colour

/obj/machinery/light/fueled/wallfire/candle/dun_world
	dun_world_compat = TRUE
	brightness = 0

/obj/machinery/light/fueled/wallfire/candle/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/dun_world/Destroy()
	QDEL_NULL(dun_world_proxy)
	return ..()

/obj/machinery/light/fueled/wallfire/candle/r/dun_world
	dun_world_compat = TRUE
	brightness = 0

/obj/machinery/light/fueled/wallfire/candle/r/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/r/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/r/dun_world/Destroy()
	QDEL_NULL(dun_world_proxy)
	return ..()

/obj/machinery/light/fueled/wallfire/candle/l/dun_world
	dun_world_compat = TRUE
	brightness = 0

/obj/machinery/light/fueled/wallfire/candle/l/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/l/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/l/dun_world/Destroy()
	QDEL_NULL(dun_world_proxy)
	return ..()

/obj/machinery/light/fueled/wallfire/candle/blue/dun_world
	dun_world_compat = TRUE
	brightness = 0

/obj/machinery/light/fueled/wallfire/candle/blue/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/blue/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/blue/dun_world/Destroy()
	QDEL_NULL(dun_world_proxy)
	return ..()

/obj/machinery/light/fueled/wallfire/candle/blue/r/dun_world
	dun_world_compat = TRUE
	brightness = 0

/obj/machinery/light/fueled/wallfire/candle/blue/r/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/blue/r/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/blue/r/dun_world/Destroy()
	QDEL_NULL(dun_world_proxy)
	return ..()

/obj/machinery/light/fueled/wallfire/candle/blue/l/dun_world
	dun_world_compat = TRUE
	brightness = 0

/obj/machinery/light/fueled/wallfire/candle/blue/l/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/blue/l/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/blue/l/dun_world/Destroy()
	QDEL_NULL(dun_world_proxy)
	return ..()

/obj/machinery/light/fueled/wallfire/candle/weak/dun_world
	dun_world_compat = TRUE
	brightness = 0

/obj/machinery/light/fueled/wallfire/candle/weak/dun_world/dun_world_compat_outer_range()
	return 6

/obj/machinery/light/fueled/wallfire/candle/weak/dun_world/dun_world_compat_power()
	return 0.9

/obj/machinery/light/fueled/wallfire/candle/weak/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/weak/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/weak/dun_world/Destroy()
	QDEL_NULL(dun_world_proxy)
	return ..()

/obj/machinery/light/fueled/wallfire/candle/weak/r/dun_world
	dun_world_compat = TRUE
	brightness = 0

/obj/machinery/light/fueled/wallfire/candle/weak/r/dun_world/dun_world_compat_outer_range()
	return 6

/obj/machinery/light/fueled/wallfire/candle/weak/r/dun_world/dun_world_compat_power()
	return 0.9

/obj/machinery/light/fueled/wallfire/candle/weak/r/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/weak/r/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/weak/r/dun_world/Destroy()
	QDEL_NULL(dun_world_proxy)
	return ..()

/obj/machinery/light/fueled/wallfire/candle/weak/l/dun_world
	dun_world_compat = TRUE
	brightness = 0

/obj/machinery/light/fueled/wallfire/candle/weak/l/dun_world/dun_world_compat_outer_range()
	return 6

/obj/machinery/light/fueled/wallfire/candle/weak/l/dun_world/dun_world_compat_power()
	return 0.9

/obj/machinery/light/fueled/wallfire/candle/weak/l/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/weak/l/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/weak/l/dun_world/Destroy()
	QDEL_NULL(dun_world_proxy)
	return ..()

/obj/machinery/light/fueled/wallfire/candle/lamp/dun_world
	dun_world_compat = TRUE
	brightness = 0

/obj/machinery/light/fueled/wallfire/candle/lamp/dun_world/dun_world_compat_outer_range()
	return 6

/obj/machinery/light/fueled/wallfire/candle/lamp/dun_world/dun_world_compat_power()
	return 0.9

/obj/machinery/light/fueled/wallfire/candle/lamp/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/lamp/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/lamp/dun_world/Destroy()
	QDEL_NULL(dun_world_proxy)
	return ..()

/obj/machinery/light/fueled/wallfire/candle/dun_world/floorcandle
	name = "candles"
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "floorcandle1"
	base_state = "floorcandle"
	layer = TABLE_LAYER
	SET_BASE_PIXEL(0, 0)

/obj/machinery/light/fueled/wallfire/candle/dun_world/floorcandle/alt
	icon_state = "floorcandlee1"
	base_state = "floorcandlee"

/obj/machinery/light/fueled/wallfire/candle/dun_world/floorcandle/pink
	color = "#f858b5ff"
	bulb_colour = "#ff13d8ff"

/obj/machinery/light/fueled/wallfire/candle/dun_world/floorcandle/alt/pink
	icon_state = "floorcandlee1"
	base_state = "floorcandlee"
	color = "#f858b5ff"
	bulb_colour = "#ff13d8ff"

// Dun World firebowl compat: match Azure's brightness = 12 (Vanderlin base defaults to 8).

/obj/machinery/light/fueled/firebowl/dun_world
	brightness = 12

/obj/machinery/light/fueled/firebowl/church/dun_world
	brightness = 12

/obj/machinery/light/fueled/firebowl/stump/dun_world
	brightness = 12

/obj/machinery/light/fueled/firebowl/standing/dun_world
	brightness = 12

/obj/machinery/light/fueled/firebowl/standing/blue/dun_world
	brightness = 12

#define DUN_WORLD_STAIR_TERMINATOR_AUTOMATIC 0

/obj/structure/stairs/dun_world
	density = FALSE
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	terminator_mode = DUN_WORLD_STAIR_TERMINATOR_AUTOMATIC

/obj/structure/stairs/stone/dun_world
	density = FALSE
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	terminator_mode = DUN_WORLD_STAIR_TERMINATOR_AUTOMATIC

/obj/structure/stairs/fancy/dun_world
	density = FALSE
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	terminator_mode = DUN_WORLD_STAIR_TERMINATOR_AUTOMATIC

/obj/structure/stairs/fancy/c/dun_world
	density = FALSE
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	terminator_mode = DUN_WORLD_STAIR_TERMINATOR_AUTOMATIC

/obj/structure/stairs/fancy/r/dun_world
	density = FALSE
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	terminator_mode = DUN_WORLD_STAIR_TERMINATOR_AUTOMATIC

/obj/structure/stairs/fancy/l/dun_world
	density = FALSE
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	terminator_mode = DUN_WORLD_STAIR_TERMINATOR_AUTOMATIC

#undef DUN_WORLD_STAIR_TERMINATOR_AUTOMATIC

/turf/open/water/river/dun_world
	dir = SOUTH

/turf/open/water/river/dun_world/north
	dir = NORTH

/turf/open/water/river/dun_world/east
	dir = EAST

/turf/open/water/river/dun_world/west
	dir = WEST

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
