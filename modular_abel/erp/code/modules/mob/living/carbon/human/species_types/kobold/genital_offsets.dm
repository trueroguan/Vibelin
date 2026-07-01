// Reopens /datum/species/kobold (core) to tune offset_genitals_m/f - same magnitude as that
// species' own offset_features_f body-drawn offsets (OFFSET_HEAD/BACK/NECK = (0,-5)).
// Kobold's smallclothes_state() never picks a dwarf-style sprite for it (not in the
// SPEC_ID_DWARF/SUBTERRAN/HALFLING list in modular_abel/erp), so OFFSET_SMALLCLOTHES applies to
// every underwear/undershirt/sock style on this species, not just ones missing dedicated art.
// /datum/species/kobold/formikrag inherits these (no override of its own).
/datum/species/kobold
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

	smallclothes_scale_x = 0.82
	smallclothes_scale_y = 0.82
