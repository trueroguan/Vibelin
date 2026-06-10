GLOBAL_LIST_INIT(abel_genital_customizers, list(
	/datum/customizer/organ/penis/human,
	/datum/customizer/organ/testicles/human,
	/datum/customizer/organ/breasts/human,
	/datum/customizer/organ/vagina/human,
))

/datum/preferences/validate_customizer_entries()
	if(pref_species && islist(pref_species.customizers) && length(pref_species.customizers))
		for(var/ctype in GLOB.abel_genital_customizers)
			pref_species.customizers |= ctype
	return ..()
