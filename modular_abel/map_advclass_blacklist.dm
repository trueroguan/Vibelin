/datum/map_adjustment/var/list/advclass_blacklist

/datum/job/advclass/check_requirements(mob/living/carbon/human/to_check, triumph_restriction_lift = FALSE)
	var/datum/map_adjustment/adjustment = SSmapping.map_adjustment
	if(adjustment && (type in adjustment.advclass_blacklist))
		return FALSE
	return ..()
