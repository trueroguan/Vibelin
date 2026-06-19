/obj/item/build_worn_icon(age = AGE_ADULT, default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, coom = FALSE, customi = null, sleeveindex, force_child = FALSE)
	. = ..()
	if(isinhands || !istype(., /mutable_appearance))
		return
	var/mob/living/carbon/human/H = loc
	if(!istype(H))
		return
	var/obj/item/bodypart/taur/taur = H.get_taur_tail()
	if(!taur?.clip_mask)
		return
	switch(default_layer)
		if(CLOAK_LAYER, SHIRT_LAYER, ARMOR_LAYER, PANTS_LAYER, TABARD_LAYER)
			var/mutable_appearance/MA = .
			MA.filters += filter(type = "alpha", icon = taur.clip_mask)
