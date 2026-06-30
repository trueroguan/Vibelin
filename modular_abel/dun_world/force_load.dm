#if !defined(UNIT_TESTS) && !defined(FORCE_RANDOM_WORLD_GEN) && !defined(LOWMEMORYMODE) && !defined(NO_DUNGEON) && !defined(ABSOLUTE_MINIMUM_MODE)
/datum/controller/subsystem/mapping/PreInit()
	. = ..()
	config = load_map_config("dun_world", "_maps")
	// World pre-sizing for this map lives in world_presize.dm's loadWorld() override, not here -
	// this PreInit() is compiled out under UNIT_TESTS, but CI still loads dun_world via loadWorld().

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
