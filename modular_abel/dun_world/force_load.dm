#if !defined(UNIT_TESTS) && !defined(LOWMEMORYMODE) && !defined(FORCE_RANDOM_WORLD_GEN)
/datum/controller/subsystem/mapping/PreInit()
	. = ..()
	if(config?.map_name == "Dun World")
		return
	config = load_map_config("dun_world", "_maps")
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
	log_world("modular_abel: TEMP forced Dun World map (remove before release).")
#endif
