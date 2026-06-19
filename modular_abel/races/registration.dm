GLOBAL_LIST_INIT(modular_race_followers, list(
	SPEC_ID_ELF_SUN = SPEC_ID_ELF,
	SPEC_ID_TABAXI = SPEC_ID_RAKSHARI,
	SPEC_ID_VULPKANIN = SPEC_ID_RAKSHARI,
	SPEC_ID_LUPIAN = SPEC_ID_RAKSHARI,
	SPEC_ID_AKULA = SPEC_ID_RAKSHARI,
	SPEC_ID_ANTHROMORPH = SPEC_ID_RAKSHARI,
	SPEC_ID_LIZARDFOLK = SPEC_ID_RAKSHARI,
	SPEC_ID_DRACON = SPEC_ID_RAKSHARI,
	SPEC_ID_MOTH = SPEC_ID_RAKSHARI,
	SPEC_ID_TAUR_KIN = SPEC_ID_RAKSHARI,
))

/datum/job/New()
	. = ..()
	if(!length(allowed_races))
		return
	for(var/new_id in GLOB.modular_race_followers)
		var/proxy_id = GLOB.modular_race_followers[new_id]
		if(proxy_id in allowed_races)
			allowed_races |= new_id
