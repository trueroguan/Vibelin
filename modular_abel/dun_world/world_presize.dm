// Azure Peak (dun_world) is 255x450, but whatever loads it (force_load.dm on a live server, or
// the map-validation unit test in CI) starts with the world still at its tiny default size. The
// per-column multi-z load then grows the world MID-load, and Vanderlin's stub increase_max_x/y
// don't re-init the newly exposed turfs across the z-levels InitializeDefaultZLevels() already
// allocated while the world was small. That corrupts the area assignment for the still-loading
// z-levels -> "bad loc" runtimes on the z4 mountains (code/modules/mapping/reader.dm).
//
// Growing the world to the map's size up front - before InitializeDefaultZLevels() allocates any
// z-levels - means the load needs no expansion at all. Final world dimensions are identical.
//
// This has to live in loadWorld() itself, NOT in force_load.dm's PreInit() override: that override
// is compiled out under UNIT_TESTS (and a few other build flags), but the CI map-validation test
// still loads dun_world through the normal loadWorld() path, so the fix needs to be unconditional
// and keyed off the config actually being loaded, not off how it got selected.
/datum/controller/subsystem/mapping/loadWorld()
	if(config?.map_path == "map_files/dun_world")
		world.increase_max_x(255)
		world.increase_max_y(450)
	return ..()
