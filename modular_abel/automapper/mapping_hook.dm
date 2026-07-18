/datum/controller/subsystem/mapping/LoadGroup(list/errorList, name, path, files, list/traits, list/default_traits, silent = FALSE, delve = 0)
	. = ..()
	if(!islist(.) || !length(.))
		return
	if(islist(errorList) && length(errorList))
		return
	if(!islist(files))
		files = list(files)
	var/list/parsed_maps = .
	var/total_z = 0
	for(var/P in parsed_maps)
		var/datum/parsed_map/pm = P
		if(!pm?.bounds)
			continue
		total_z += pm.bounds[MAP_MAXZ] - pm.bounds[MAP_MINZ] + 1
	if(!total_z)
		return
	var/start_z = world.maxz - total_z + 1
	var/list/group_start_z = list()
	var/list/group_depth = list()
	for(var/P in parsed_maps)
		var/datum/parsed_map/pm = P
		if(!pm?.bounds)
			continue
		var/filename = pm.original_path
		var/slash = findlasttext(filename, "/")
		if(slash)
			filename = copytext(filename, slash + 1)
		group_start_z[filename] = start_z + parsed_maps[P]
		group_depth[filename] = pm.bounds[MAP_MAXZ] - pm.bounds[MAP_MINZ] + 1
	SSautomapper.set_map_context(group_start_z, group_depth)
	SSautomapper.preload_templates_from_toml(files)
	SSautomapper.load_templates_from_cache(files)
