/mob/living/carbon/human/get_examine_list(mob/user, list/P)
	. = ..()
	var/datum/species/our_species = dna?.species
	if(!our_species)
		return
	if(!(our_species.id in GLOB.modular_race_followers))
		return
	LAZYADDASSOCLIST(., EXAMINE_SECT_WARNING, span_danger("This is an ALPHA-TEST race — expect bugs and unfinished features."))
