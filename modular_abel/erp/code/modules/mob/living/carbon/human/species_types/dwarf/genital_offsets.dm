// Reopens /datum/species/dwarf/mountain (core) to tune offset_genitals_m/f - same magnitude as
// that species' own offset_features_m/f body-drawn offsets (OFFSET_HEAD/BACK/NECK = (0,-4)),
// since genitals and underwear-without-dwarf-art sit at roughly the same compressed body height.
// /datum/species/dwarf/mountain/subterra inherits these (no override of its own).
/datum/species/dwarf/mountain
	offset_genitals_m = list(
		OFFSET_PENIS = list(0,-4),\
		OFFSET_BREASTS = list(0,-4),\
		OFFSET_TESTICLES = list(0,-3),\
		OFFSET_VAGINA = list(0,-4),\
		OFFSET_SMALLCLOTHES = list(0,-4),\
	)

	offset_genitals_f = list(
		OFFSET_PENIS = list(0,-4),\
		OFFSET_BREASTS = list(0,-4),\
		OFFSET_TESTICLES = list(0,-3),\
		OFFSET_VAGINA = list(0,-4),\
		OFFSET_SMALLCLOTHES = list(0,-4),\
	)
