// TEMP diagnostic - remove once the dun_world z4 "bad loc" cause is confirmed.
// We've already ruled out: (1) mid-load world.maxx/maxy growth (world_presize.dm presizes
// before any z-level exists, so the reader.dm increase_max_x/y stub path never triggers for
// dun_world's own load) and (2) first-time area construction (the area type used at the
// failing coordinates is instanced ~47k times on z1-3 before z4 even starts, so it's long
// cached by the time z4 loads). This logs world size + full exception context at the exact
// moment of the runtime so we can see what's actually different about z4.
/world/Error(exception/E, datum/e_src)
	if(E?.name == "bad loc")
		log_world("BAD LOC DIAG - [E.file]:[E.line] world=[world.maxx]x[world.maxy]x[world.maxz] desc=[E.desc]")
	return ..()
