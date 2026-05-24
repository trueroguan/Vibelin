SUBSYSTEM_DEF(modular_abel)
	name = "Modular Abel"
	init_order = INIT_ORDER_DEFAULT
	flags = SS_NO_FIRE

/datum/controller/subsystem/modular_abel/Initialize(timeofday)
	modular_abel_register_map_rotation()
	return ..()

/proc/modular_abel_register_map_rotation()
	if(!global.config)
		return

	LAZYINITLIST(global.config.maplist)
	if(global.config.maplist["Dun World"])
		return

	var/datum/map_config/dun_world = load_map_config("dun_world", MAP_DIRECTORY_MAPS, FALSE)
	if(!dun_world || dun_world.defaulted)
		qdel(dun_world)
		log_world("modular_abel: failed to register Dun World in map rotation.")
		return

	dun_world.votable = TRUE
	global.config.maplist[dun_world.map_name] = dun_world
	log_world("modular_abel: registered Dun World in map rotation.")
