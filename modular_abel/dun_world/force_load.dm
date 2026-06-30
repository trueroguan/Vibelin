#if !defined(UNIT_TESTS) && !defined(FORCE_RANDOM_WORLD_GEN) && !defined(LOWMEMORYMODE) && !defined(NO_DUNGEON) && !defined(ABSOLUTE_MINIMUM_MODE)
/datum/controller/subsystem/mapping/PreInit()
	. = ..()
	config = load_map_config("dun_world", "_maps")

	// Azure Peak is 255x450, but it gets force-loaded into a world still at its tiny default size.
	// The per-column multi-z load then grows the world MID-load, and Vanderlin's stub
	// increase_max_x/y don't re-init the newly exposed turfs across the z-levels that were already
	// allocated (by add_new_zlevel) while the world was small. That corrupts the area assignment
	// for the still-loading z-levels -> "bad loc" runtimes on the z4 mountains. Growing the world
	// to the map's size up front - before any z-levels are allocated - means the load needs no
	// expansion at all. Final world dimensions are identical either way.
	world.increase_max_x(255)
	world.increase_max_y(450)

	var/map = config.map_file
	if(islist(map))
		var/list/maps = map
		map = maps[1]

	if(map_adjustment)
		qdel(map_adjustment)
		map_adjustment = null

	for(var/datum/map_adjustment/adjust as anything in subtypesof(/datum/map_adjustment))
		if(adjust.map_file_name != map)
			continue
		map_adjustment = new adjust()
		log_world("Loaded '[map]' map adjustment.")
		break

	log_world("modular_abel: forced Azure Peak map.")
#endif
