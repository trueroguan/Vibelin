/area/outdoors/desert
	name = "Inner Dunes"
	icon = 'icons/turf/areas/forest.dmi'
	icon_state = "woods"
	soundenv = 19
	droning_index = DRONING_MOUNT_DAY
	droning_index_night = DRONING_MOUNT_NIGHT
	background_track = 'modular_abel/ratwood/sound/music/desert/Iberia1.ogg'
	background_track_dusk = 'modular_abel/ratwood/sound/music/desert/NightPrayer.ogg'
	background_track_night = 'modular_abel/ratwood/sound/music/desert/Moonrise.ogg'
	first_time_text = "THE DUNES"
	ambush_times = list(NIGHT)
	ambush_mobs = list(
		new /datum/ambush_config/hyena_pack = 25,
		new /datum/ambush_config/desert_skeletons = 20,
		new /datum/ambush_config/desert_wildlife = 30,
	)

/area/outdoors/desert/river
	name = "river"
	droning_index = DRONING_RIVER_DAY
	droning_index_night = DRONING_RIVER_NIGHT

/area/outdoors/desertdeep
	name = "Deep Dunes"
	icon = 'icons/turf/areas/forest.dmi'
	icon_state = "woods"
	droning_index = DRONING_MOUNT_DAY
	droning_index_night = DRONING_MOUNT_NIGHT
	background_track = 'modular_abel/ratwood/sound/music/desert/Iberia1.ogg'
	background_track_dusk = 'modular_abel/ratwood/sound/music/desert/NightPrayer.ogg'
	background_track_night = 'modular_abel/ratwood/sound/music/desert/Moonrise.ogg'
	first_time_text = "THE DEEP DUNES"
	ambush_times = list(NIGHT, DAWN, DUSK, DAY)
	ambush_mobs = list(
		new /datum/ambush_config/hyena_pack = 30,
		new /datum/ambush_config/desert_skeletons = 30,
		new /datum/ambush_config/desert_wildlife = 25,
	)
	converted_type = /area/indoors/shelter/desertdeep

/area/indoors/shelter/desertdeep
	name = "Deep Desert (shelter)"
	droning_index = DRONING_INDOORS
	droning_index_night = DRONING_INDOORS

/area/outdoors/desertdeep/safe
	name = "Desert Pass"
	ambush_times = null
	ambush_mobs = null

/area/outdoors/desertdeep/above
	name = "deep desert above"
	droning_index = DRONING_MOUNTAIN
	droning_index_night = DRONING_MOUNTAIN
	soundenv = 17
	first_time_text = null
	ambush_times = null
	ambush_mobs = null

/area/outdoors/desert/above
	name = "desert above"
	droning_index = DRONING_MOUNTAIN
	droning_index_night = DRONING_MOUNTAIN
	soundenv = 17
	first_time_text = null
	ambush_times = null
	ambush_mobs = null

/area/outdoors/town/desert
	name = "desert town outdoors"
	soundenv = 16
	background_track = 'modular_abel/ratwood/sound/music/desert/TheRoad.ogg'
	background_track_dusk = 'modular_abel/ratwood/sound/music/desert/NightPrayer.ogg'
	background_track_night = 'modular_abel/ratwood/sound/music/desert/Moonrise.ogg'
	first_time_text = "THE DESERT CITY"

/area/outdoors/town/desert/roofs
	name = "desert roofs"
	droning_index = DRONING_MOUNTAIN
	droning_index_night = DRONING_MOUNTAIN
	soundenv = 17
	first_time_text = null

/area/indoors/shelter/town/desert
	name = "desert town (shelter)"
	droning_index = DRONING_INDOORS
	droning_index_night = DRONING_INDOORS

/area/indoors/town/desert
	name = "desert town indoors"
	droning_index = DRONING_INDOORS
	droning_index_night = DRONING_INDOORS
	background_track = 'modular_abel/ratwood/sound/music/desert/TheRoad.ogg'
	background_track_dusk = 'modular_abel/ratwood/sound/music/desert/NightPrayer.ogg'
	background_track_night = 'modular_abel/ratwood/sound/music/desert/Moonrise.ogg'

/area/under/underdesert
	name = "the underdesert"
	droning_index = DRONING_BASEMENT
	droning_index_night = DRONING_BASEMENT
	background_track = 'modular_abel/ratwood/sound/music/desert/Dune.ogg'
