/mob/living/carbon/human/species/moth
	race = /datum/species/moth

/datum/attribute_holder/sheet/job/species/moth
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_PERCEPTION = 1,
		STAT_SPEED = 1,
		STAT_CONSTITUTION = -1,
	)

/datum/species/moth
	name = "Fluvian"
	id = SPEC_ID_MOTH
	changesource_flags = WABBAJACK

	desc = "Many comparisons have been made to the common moth in an attempt to describe this unique species. \
	From the appetite for clothing to the disconcertingly insectoid appearance, the name 'Moth' is forever \
	stamped onto the common vocabulary. \
	\n\n\
	THIS IS A DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. PLAY AT YOUR OWN RISK."

	use_skintones = TRUE
	default_color = "b7a98a"
	possible_ages = NORMAL_AGES_LIST_CHILD

	species_traits = list(EYECOLOR, HAIR, FACEHAIR, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)

	statsheet_male = /datum/attribute_holder/sheet/job/species/moth

	limbs_icon_m = 'modular_abel/races/icons/species/moth_male.dmi'
	limbs_icon_f = 'modular_abel/races/icons/species/moth_female.dmi'

	meat = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)

	offset_features_m = list(
		OFFSET_RING = list(0,1),OFFSET_GLOVES = list(0,1),OFFSET_WRISTS = list(0,1),OFFSET_HANDS = list(0,1),\
		OFFSET_CLOAK = list(0,1),OFFSET_FACEMASK = list(0,1),OFFSET_HEAD = list(0,1),OFFSET_FACE = list(0,0),\
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
		ORGAN_SLOT_EARS = /obj/item/organ/ears/anthro/antenna,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		ORGAN_SLOT_WINGS = /obj/item/organ/wings/moth,
	)

	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/organ/ears/anthro,
		/datum/customizer/organ/wings/moth,
	)

	body_markings = list(
		/datum/body_marking/plain,
		/datum/body_marking/tiger,
		/datum/body_marking/tiger/dark,
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
	)

/datum/species/moth/check_roundstart_eligible()
	return TRUE

/datum/species/moth/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/moth/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)

/datum/species/moth/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/moth/get_skin_list()
	return list(
		"Tan" = "b7a98a",
		"Brown" = "8a6f4e",
		"Grey" = "8f8c84",
		"Dark" = "4a4239",
		"Pale" = "ccc4b2",
		"Rust" = "9c6a44",
		"White" = "ded7c8",
	)
