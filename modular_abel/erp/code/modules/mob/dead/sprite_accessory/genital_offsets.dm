/datum/species
	var/list/offset_genitals_m = list(
		OFFSET_PENIS = list(0,0),\
		OFFSET_BREASTS = list(0,0),\
		OFFSET_TESTICLES = list(0,0),\
		OFFSET_VAGINA = list(0,0),\
		OFFSET_SMALLCLOTHES = list(0,0),\
	)

	var/list/offset_genitals_f = list(
		OFFSET_PENIS = list(0,0),\
		OFFSET_BREASTS = list(0,0),\
		OFFSET_TESTICLES = list(0,0),\
		OFFSET_VAGINA = list(0,0),\
		OFFSET_SMALLCLOTHES = list(0,0),\
	)

	var/smallclothes_scale_x = 1
	var/smallclothes_scale_y = 1

/datum/sprite_accessory/proc/gender_genitals_adjust(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner, feature_key)
	if(QDELETED(owner) || !ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner
	var/datum/species/species = H.dna?.species

	if(!species)
		return

	var/use_female_sprites = FALSE
	if(species?.sexes)
		if(H.gender == FEMALE && !species.swap_female_clothes || H.gender == MALE && species.swap_male_clothes)
			use_female_sprites = FEMALE_SPRITES

	var/list/offsets = use_female_sprites ? species.offset_genitals_f : species.offset_genitals_m

	if(LAZYACCESS(offsets, feature_key))
		for(var/mutable_appearance/appearance as anything in appearance_list)
			appearance.pixel_x += offsets[feature_key][1]
			appearance.pixel_y += offsets[feature_key][2]

/datum/sprite_accessory/proc/genital_apply_stack_layer(list/appearance_list, stack_layer)
	for(var/mutable_appearance/appearance as anything in appearance_list)
		if(appearance.layer == -BODY_BEHIND_LAYER)
			continue
		appearance.layer = -stack_layer
