// TEMP diagnostic - remove once the dun_world z4 "bad loc" cause is confirmed.
// Ruled out so far (see modular_abel/README.md investigation notes / conversation log):
// (1) mid-load world.maxx/maxy growth - world_presize.dm presizes before any z-level exists, so
//     the reader.dm increase_max_x/y stub path never triggers for dun_world's own load.
// (2) first-time area construction - every area type seen at the failing coordinates (plain
//     mountains, town roofs, the inquisition chapel) is already instanced tens of thousands of
//     times on z1-3 before z4 even starts, so it's long cached by the time z4 loads.
// (3) content-specific - the exact same model keys (bare mountains, chapel walls, etc.) succeed
//     everywhere else in the map; only this one ~586-tile blob at x:5-39 y:96-126 z4 fails, 100%
//     deterministically (same tiles every run, local and CI).
// Current lead: modular_abel/README.md documents a known "DEFAULT_MAP_TRAITS vs world.maxz"
// double-load failure mode when a map's z-levels exist both compiled-in and runtime-loaded. CI's
// own log shows CentCom.dmm IS baked into the .dmb at compile time (world.maxz starts > 0 before
// loadWorld() ever runs), so this logs SSmapping's z-level bookkeeping at the exact crash moment
// to check for an inconsistency there (z_list vs world.maxz vs the space_level's own traits).
/world/Error(exception/E, datum/e_src)
	if(E?.name == "bad loc")
		var/z4_traits = "no z_list entry"
		if(SSmapping?.z_list && SSmapping.z_list.len >= 4)
			var/datum/space_level/z4_level = SSmapping.z_list[4]
			z4_traits = z4_level ? "[z4_level.name]|[json_encode(z4_level.traits)]" : "null entry"
		log_world("BAD LOC DIAG - [E.file]:[E.line] world=[world.maxx]x[world.maxy]x[world.maxz] z_list.len=[SSmapping?.z_list?.len] station_start=[SSmapping?.station_start] z4=[z4_traits] desc=[E.desc]")
	return ..()
