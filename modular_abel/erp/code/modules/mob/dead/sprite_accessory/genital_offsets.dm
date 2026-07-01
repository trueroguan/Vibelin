// Reopens /datum/species (core, code/modules/mob/living/carbon/human/species.dm) to add a
// per-species genital/smallclothes-fallback offset table, separate from offset_features_m/f.
// Defaults to (0,0) for every key, so this is a no-op for any species that doesn't override it
// below - see code/modules/mob/living/carbon/human/species_types/*/genital_offsets.dm overrides.
/datum/species
	/// Per-species pixel offsets for genital sprites and smallclothes styles with no dedicated
	/// short-race sprite, separate from offset_features_m since those are drawn straight onto the
	/// body and need to track its actual proportions (short races compress the torso but
	/// offset_features' clothing offsets stay at 0,0).
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

	/// Shrinks smallclothes styles that have no dedicated short-race art (see
	/// smallclothes_adjust_appearance() in modular_abel/erp/code/modules/smallclothes/accessories.dm) -
	/// a human-proportioned sprite can be nudged into roughly the right spot with offset_genitals
	/// alone, but it still overhangs a shorter/narrower body unless it's also scaled down. 1 = no-op.
	var/smallclothes_scale_x = 1
	var/smallclothes_scale_y = 1

// Reopens /datum/sprite_accessory (core, code/modules/mob/dead/sprite_accessory/_sprite_accessory.dm)
// to add a genital-specific counterpart to generic_gender_feature_adjust() that reads the table above.
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

// Moves a genital's front-facing overlays onto its slot in the anatomical stack (see the
// GENITAL_LAYER_* defines). Only the render layer changes - relevant_layers still drives the
// icon-state suffix lookup (_FRONT/_ADJ), so no icon rename is needed. BEHIND stays where it is
// (it must render behind the body, not just behind the other genitals).
/datum/sprite_accessory/proc/genital_apply_stack_layer(list/appearance_list, stack_layer)
	for(var/mutable_appearance/appearance as anything in appearance_list)
		if(appearance.layer == -BODY_BEHIND_LAYER)
			continue
		appearance.layer = -stack_layer
