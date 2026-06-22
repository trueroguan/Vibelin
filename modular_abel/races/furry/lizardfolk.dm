/mob/living/carbon/human/species/lizardfolk
	race = /datum/species/lizardfolk

/datum/attribute_holder/sheet/job/species/lizardfolk
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		STAT_PERCEPTION = -1,
	)

/datum/species/lizardfolk
	name = "Zardman"
	id = SPEC_ID_LIZARDFOLK
	changesource_flags = WABBAJACK

	desc = "Zardmen are semi-aquatic reptilian humanoids. Their flesh is covered in scales varying in color \
	from dark green to shades of brown and gray. Taller than humans and powerfully built, zardmen are often \
	between 6 and 7 feet tall, with muscular tails used for balance, sharp claws and teeth. \
	\n\n\
	THIS IS A DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. PLAY AT YOUR OWN RISK."

	use_skintones = TRUE
	default_color = "4a6b3c"
	possible_ages = NORMAL_AGES_LIST_CHILD

	species_traits = list(EYECOLOR, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)

	statsheet_male = /datum/attribute_holder/sheet/job/species/lizardfolk

	limbs_icon_m = 'modular_abel/races/icons/bodies/m/mta.dmi'
	limbs_icon_f = 'modular_abel/races/icons/bodies/f/fma.dmi'

	meat = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)

	offset_features_m = list(
		OFFSET_RING = list(0,1),OFFSET_GLOVES = list(0,1),OFFSET_WRISTS = list(0,1),OFFSET_HANDS = list(0,1),\
		OFFSET_CLOAK = list(0,1),OFFSET_FACEMASK = list(0,1),OFFSET_HEAD = list(0,1),OFFSET_FACE = list(0,1),\
		OFFSET_BELT = list(0,1),OFFSET_BACK = list(0,1),OFFSET_NECK = list(0,1),OFFSET_MOUTH = list(0,1),\
		OFFSET_PANTS = list(0,1),OFFSET_SHIRT = list(0,1),OFFSET_ARMOR = list(0,1),OFFSET_UNDIES = list(0,1),\
	)
	offset_features_f = list(
		OFFSET_RING = list(0,-1),OFFSET_GLOVES = list(0,0),OFFSET_WRISTS = list(0,0),OFFSET_HANDS = list(0,0),\
		OFFSET_CLOAK = list(0,0),OFFSET_FACEMASK = list(0,-1),OFFSET_HEAD = list(0,-1),OFFSET_FACE = list(0,-1),\
		OFFSET_BELT = list(0,0),OFFSET_BACK = list(0,-1),OFFSET_NECK = list(0,-1),OFFSET_MOUTH = list(0,-1),\
		OFFSET_PANTS = list(0,0),OFFSET_SHIRT = list(0,0),OFFSET_ARMOR = list(0,0),OFFSET_UNDIES = list(0,-1),\
	)

	enflamed_icon = "widefire"

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_SPLEEN = /obj/item/organ/spleen,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/lizard,
		ORGAN_SLOT_SNOUT = /obj/item/organ/snout/lizard,
	)

	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/organ/snout/lizard,
		/datum/customizer/organ/tail/lizard,
	)

	body_markings = list(
		/datum/body_marking/plain,
		/datum/body_marking/bellyscale,
		/datum/body_marking/bellyscaleslim,
		/datum/body_marking/bellyscalesmooth,
		/datum/body_marking/buttscale,
		/datum/body_marking/spotted,
		/datum/body_marking/backspots,
	)

/datum/species/lizardfolk/check_roundstart_eligible()
	return TRUE

/datum/species/lizardfolk/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/lizardfolk/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)

/datum/species/lizardfolk/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/lizardfolk/get_skin_list()
	return list(
		"Green" = "4a6b3c",
		"Olive" = "6b6b3c",
		"Forest" = "32502c",
		"Brown" = "5c4327",
		"Tan" = "9c8a5e",
		"Grey" = "6a6f68",
		"Slate" = "4a5258",
		"Black" = "2c2722",
	)

/mob/living/carbon/human/species/dracon
	race = /datum/species/dracon

/datum/attribute_holder/sheet/job/species/dracon
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		STAT_INTELLIGENCE = -1,
	)

/datum/species/dracon
	name = "Drakian"
	id = SPEC_ID_DRACON
	changesource_flags = WABBAJACK

	desc = "Mighty scaled individuals who claim to be descendants of the dragons of yore. \
	\n\n\
	THIS IS A DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. PLAY AT YOUR OWN RISK."

	use_skintones = TRUE
	default_color = "7a3a2c"
	possible_ages = NORMAL_AGES_LIST_CHILD

	species_traits = list(EYECOLOR, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)

	statsheet_male = /datum/attribute_holder/sheet/job/species/dracon

	limbs_icon_m = 'modular_abel/races/icons/bodies/m/mta.dmi'
	limbs_icon_f = 'modular_abel/races/icons/bodies/f/fma.dmi'

	meat = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)

	offset_features_m = list(
		OFFSET_RING = list(0,1),OFFSET_GLOVES = list(0,1),OFFSET_WRISTS = list(0,1),OFFSET_HANDS = list(0,1),\
		OFFSET_CLOAK = list(0,1),OFFSET_FACEMASK = list(0,1),OFFSET_HEAD = list(0,1),OFFSET_FACE = list(0,1),\
		OFFSET_BELT = list(0,1),OFFSET_BACK = list(0,1),OFFSET_NECK = list(0,1),OFFSET_MOUTH = list(0,1),\
		OFFSET_PANTS = list(0,1),OFFSET_SHIRT = list(0,1),OFFSET_ARMOR = list(0,1),OFFSET_UNDIES = list(0,1),\
	)
	offset_features_f = list(
		OFFSET_RING = list(0,-1),OFFSET_GLOVES = list(0,0),OFFSET_WRISTS = list(0,0),OFFSET_HANDS = list(0,0),\
		OFFSET_CLOAK = list(0,0),OFFSET_FACEMASK = list(0,-1),OFFSET_HEAD = list(0,-1),OFFSET_FACE = list(0,-1),\
		OFFSET_BELT = list(0,0),OFFSET_BACK = list(0,-1),OFFSET_NECK = list(0,-1),OFFSET_MOUTH = list(0,-1),\
		OFFSET_PANTS = list(0,0),OFFSET_SHIRT = list(0,0),OFFSET_ARMOR = list(0,0),OFFSET_UNDIES = list(0,-1),\
	)

	enflamed_icon = "widefire"

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_SPLEEN = /obj/item/organ/spleen,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/lizard,
		ORGAN_SLOT_SNOUT = /obj/item/organ/snout/lizard,
	)

	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/organ/snout/lizard,
		/datum/customizer/organ/tail/lizard,
	)

	body_markings = list(
		/datum/body_marking/plain,
		/datum/body_marking/bellyscale,
		/datum/body_marking/bellyscaleslim,
		/datum/body_marking/buttscale,
		/datum/body_marking/backspots,
	)

/datum/species/dracon/check_roundstart_eligible()
	return TRUE

/datum/species/dracon/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/dracon/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)

/datum/species/dracon/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/dracon/get_skin_list()
	return list(
		"Red" = "7a3a2c",
		"Crimson" = "6b2a24",
		"Bronze" = "8a5a30",
		"Green" = "3c5a34",
		"Black" = "2c2722",
		"White" = "cfc8bd",
		"Blue" = "39506b",
	)
