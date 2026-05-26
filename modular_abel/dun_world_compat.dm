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

/obj/effect/dun_world_map_light_proxy
	icon = null
	alpha = 0
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/machinery/light/fueled
	var/tmp/obj/effect/dun_world_map_light_proxy/dun_world_light_proxy
	var/tmp/dun_world_uses_light_proxy = FALSE

/obj/machinery/light/fueled/proc/dun_world_map_light_outer_range()
	return max(brightness, light_outer_range)

/obj/machinery/light/fueled/proc/dun_world_map_light_inner_range(outer_range)
	var/inner_range = light_inner_range
	if(!inner_range)
		inner_range = outer_range / 4
	return inner_range

/obj/machinery/light/fueled/proc/dun_world_map_light_power()
	return max(max(bulb_power, light_power), 1)

/obj/machinery/light/fueled/proc/dun_world_force_map_light()
	status = LIGHT_OK
	on = TRUE
	seton(TRUE)
	var/map_light_color = bulb_colour
	if(color)
		map_light_color = color
	var/outer_range = dun_world_map_light_outer_range()
	set_light(outer_range, dun_world_map_light_inner_range(outer_range), dun_world_map_light_power(), l_falloff_curve = light_falloff_curve, l_color = map_light_color, l_on = TRUE)
	update_light()
	dun_world_sync_light_proxy(map_light_color)
	update()
	update_appearance(UPDATE_ICON_STATE)

/obj/machinery/light/fueled/proc/dun_world_init_map_light(mapload)
	if(!mapload)
		return
	dun_world_force_map_light()
	addtimer(CALLBACK(src, PROC_REF(dun_world_force_map_light)), 1)

/obj/machinery/light/fueled/proc/dun_world_update_light_proxy(map_light_color)
	var/turf/light_turf = dun_world_get_light_proxy_turf()
	if(!light_turf)
		return
	if(QDELETED(dun_world_light_proxy))
		dun_world_light_proxy = null
	if(!dun_world_light_proxy)
		dun_world_light_proxy = new(light_turf)
	else if(dun_world_light_proxy.loc != light_turf)
		dun_world_light_proxy.forceMove(light_turf)
	var/outer_range = dun_world_map_light_outer_range()
	dun_world_light_proxy.light_height = light_height
	dun_world_light_proxy.set_light(outer_range, dun_world_map_light_inner_range(outer_range), dun_world_map_light_power(), l_falloff_curve = light_falloff_curve, l_color = map_light_color, l_on = TRUE)
	dun_world_light_proxy.update_light()

/obj/machinery/light/fueled/proc/dun_world_clear_light_proxy()
	if(QDELETED(dun_world_light_proxy))
		dun_world_light_proxy = null
		return
	if(!dun_world_light_proxy)
		return
	dun_world_light_proxy.set_light(0, 0, 0, l_on = FALSE)
	QDEL_NULL(dun_world_light_proxy)

/obj/machinery/light/fueled/proc/dun_world_sync_light_proxy(map_light_color)
	if(!dun_world_uses_light_proxy)
		return
	if(!on)
		dun_world_clear_light_proxy()
		return
	if(isnull(map_light_color))
		map_light_color = bulb_colour
		if(color)
			map_light_color = color
	dun_world_update_light_proxy(map_light_color)

/obj/machinery/light/fueled/proc/dun_world_get_light_proxy_turf()
	var/turf/source_turf = get_turf(src)
	if(!source_turf)
		return null
	if(!source_turf.density && !source_turf.opacity)
		return source_turf

	var/list/candidates = list()
	var/preferred_direction = NONE
	if(abs(pixel_y) >= abs(pixel_x) && pixel_y)
		preferred_direction = pixel_y > 0 ? NORTH : SOUTH
	else if(pixel_x)
		preferred_direction = pixel_x > 0 ? EAST : WEST

	if(preferred_direction)
		candidates += get_step(source_turf, preferred_direction)
	candidates += source_turf
	for(var/direction in GLOB.cardinals)
		candidates += get_step(source_turf, direction)

	for(var/turf/candidate as anything in candidates)
		if(!candidate)
			continue
		if(candidate.density || candidate.opacity)
			continue
		return candidate
	return source_turf

/obj/machinery/light/fueled/wallfire/candle/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/wallfire/candle/r/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/wallfire/candle/l/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/wallfire/candle/blue/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/wallfire/candle/blue/r/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/wallfire/candle/blue/l/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/wallfire/candle/weak/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/wallfire/candle/weak/r/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/wallfire/candle/weak/l/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/wallfire/candle/lamp/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/wallfire/candle/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/r/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/l/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/blue/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/blue/r/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/blue/l/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/weak/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/weak/r/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/weak/l/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/lamp/dun_world/update(trigger = TRUE)
	. = ..()
	dun_world_sync_light_proxy()

/obj/machinery/light/fueled/wallfire/candle/dun_world
	dun_world_uses_light_proxy = TRUE

/obj/machinery/light/fueled/wallfire/candle/r/dun_world
	dun_world_uses_light_proxy = TRUE

/obj/machinery/light/fueled/wallfire/candle/l/dun_world
	dun_world_uses_light_proxy = TRUE

/obj/machinery/light/fueled/wallfire/candle/blue/dun_world
	dun_world_uses_light_proxy = TRUE

/obj/machinery/light/fueled/wallfire/candle/blue/r/dun_world
	dun_world_uses_light_proxy = TRUE

/obj/machinery/light/fueled/wallfire/candle/blue/l/dun_world
	dun_world_uses_light_proxy = TRUE

/obj/machinery/light/fueled/wallfire/candle/weak/dun_world
	dun_world_uses_light_proxy = TRUE

/obj/machinery/light/fueled/wallfire/candle/weak/r/dun_world
	dun_world_uses_light_proxy = TRUE

/obj/machinery/light/fueled/wallfire/candle/weak/l/dun_world
	dun_world_uses_light_proxy = TRUE

/obj/machinery/light/fueled/wallfire/candle/lamp/dun_world
	dun_world_uses_light_proxy = TRUE

/obj/item/candle/proc/dun_world_sync_item_candle_light()
	if(lit)
		var/outer_range = max(light_outer_range, 3)
		var/inner_range = light_inner_range
		if(!inner_range)
			inner_range = outer_range / 4
		var/power = max(light_power, 1)
		set_light(outer_range, inner_range, power, l_color = light_color, l_on = TRUE)
	else
		set_light(0, 0, 0, l_on = FALSE)

/obj/item/candle/yellow/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/yellow/fire_act(added, maxstacks)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/yellow/attack_self(mob/user, list/modifiers)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/yellow/extinguish()
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/skull/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/skull/fire_act(added, maxstacks)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/skull/attack_self(mob/user, list/modifiers)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/skull/extinguish()
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/eora/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/eora/fire_act(added, maxstacks)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/eora/attack_self(mob/user, list/modifiers)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/eora/extinguish()
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/scandle/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/scandle/fire_act(added, maxstacks)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/scandle/attack_self(mob/user, list/modifiers)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/scandle/extinguish()
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/gcandle/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/gcandle/fire_act(added, maxstacks)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/gcandle/attack_self(mob/user, list/modifiers)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/gcandle/extinguish()
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/scandelabra/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/scandelabra/fire_act(added, maxstacks)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/scandelabra/attack_self(mob/user, list/modifiers)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/scandelabra/extinguish()
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/scandelabrasingle/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/scandelabrasingle/fire_act(added, maxstacks)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/scandelabrasingle/attack_self(mob/user, list/modifiers)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/scandelabrasingle/extinguish()
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/gcandelabra/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/gcandelabra/fire_act(added, maxstacks)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/gcandelabra/attack_self(mob/user, list/modifiers)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/gcandelabra/extinguish()
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/gcandelabrasingle/Initialize(mapload, ...)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/gcandelabrasingle/fire_act(added, maxstacks)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/gcandelabrasingle/attack_self(mob/user, list/modifiers)
	. = ..()
	dun_world_sync_item_candle_light()

/obj/item/candle/gcandelabrasingle/extinguish()
	. = ..()
	dun_world_sync_item_candle_light()

/obj/machinery/light/fueled/firebowl/dun_world
	brightness = 12

/obj/machinery/light/fueled/firebowl/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/firebowl/church/dun_world
	brightness = 12

/obj/machinery/light/fueled/firebowl/church/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/firebowl/stump/dun_world
	brightness = 12

/obj/machinery/light/fueled/firebowl/stump/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/firebowl/standing/dun_world
	brightness = 12

/obj/machinery/light/fueled/firebowl/standing/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

/obj/machinery/light/fueled/firebowl/standing/blue/dun_world
	brightness = 12

/obj/machinery/light/fueled/firebowl/standing/blue/dun_world/Initialize(mapload, ...)
	. = ..()
	dun_world_init_map_light(mapload)

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
