// Reopens /datum/species/halfling (core) to tune offset_genitals_m/f - same magnitude as that
// species' own offset_features_m/f body-drawn offsets (OFFSET_HEAD/BACK/NECK = (0,-5)).
/datum/species/halfling
	offset_genitals_m = list(
		OFFSET_PENIS = list(0,-5),\
		OFFSET_BREASTS = list(0,-5),\
		OFFSET_TESTICLES = list(0,-4),\
		OFFSET_VAGINA = list(0,-5),\
		OFFSET_SMALLCLOTHES = list(0,-5),\
	)

	offset_genitals_f = list(
		OFFSET_PENIS = list(0,-5),\
		OFFSET_BREASTS = list(0,-5),\
		OFFSET_TESTICLES = list(0,-4),\
		OFFSET_VAGINA = list(0,-5),\
		OFFSET_SMALLCLOTHES = list(0,-5),\
	)

	smallclothes_scale_x = 0.78
	smallclothes_scale_y = 0.78
