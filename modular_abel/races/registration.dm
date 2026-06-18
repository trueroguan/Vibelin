GLOBAL_LIST_INIT(modular_race_followers, list(
	SPEC_ID_ELF_SUN = SPEC_ID_ELF,
))

/datum/job/New()
	. = ..()
	if(!length(allowed_races))
		return
	for(var/new_id in GLOB.modular_race_followers)
		var/proxy_id = GLOB.modular_race_followers[new_id]
		if(proxy_id in allowed_races)
			allowed_races |= new_id
