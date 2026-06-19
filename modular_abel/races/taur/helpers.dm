/datum/species/var/forced_taur = FALSE
/datum/species/var/list/allowed_taur_types = list()

/datum/species/proc/get_taur_list()
	return allowed_taur_types

/mob/living/proc/get_taur_tail()
	RETURN_TYPE(/obj/item/bodypart/taur)
	return null

/mob/living/carbon/get_taur_tail()
	for(var/X in bodyparts)
		var/obj/item/bodypart/affecting = X
		if(affecting.body_zone == BODY_ZONE_TAUR)
			return affecting
	return null

/mob/living/carbon/proc/ensure_not_taur()
	var/needs_new_legs = FALSE
	for(var/X in bodyparts)
		var/obj/item/bodypart/O = X
		if(O.body_zone == BODY_ZONE_TAUR)
			O.drop_limb(1)
			qdel(O)
			needs_new_legs = TRUE
	if(needs_new_legs)
		var/obj/item/bodypart/N
		N = new /obj/item/bodypart/l_leg
		N.attach_limb(src)
		N = new /obj/item/bodypart/r_leg
		N.attach_limb(src)
	regenerate_icons()
	set_resting(FALSE)

/mob/living/carbon/proc/Taurize(taur_type = /obj/item/bodypart/taur/horse, color = "#ffffff", markings = "#ffffff", tertiary = "#ffffff")
	var/obj/item/bodypart/taur/existing = get_taur_tail()
	if(existing && existing.type == taur_type && existing.taur_color == color && existing.taur_markings == markings && existing.taur_tertiary == tertiary)
		return
	for(var/X in bodyparts)
		var/obj/item/bodypart/O = X
		if(O.body_part == LEG_LEFT || O.body_part == LEG_RIGHT || O.body_zone == BODY_ZONE_TAUR)
			O.drop_limb(1)
			qdel(O)
	var/obj/item/bodypart/taur/T = new taur_type()
	T.taur_color = color
	if(markings)
		T.taur_markings = markings
	if(tertiary)
		T.taur_tertiary = tertiary
	T.attach_limb(src)
	if(shoes)
		dropItemToGround(shoes)
	regenerate_icons()
	set_resting(FALSE)
