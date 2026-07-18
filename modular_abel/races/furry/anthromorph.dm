/mob/living/carbon/human/species/anthromorph
	race = /datum/species/anthromorph

/datum/attribute_holder/sheet/job/species/anthromorph
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_CONSTITUTION = 1,
	)

/datum/species/anthromorph
	name = "Wild-Kin"
	id = SPEC_ID_ANTHROMORPH
	changesource_flags = WABBAJACK

	desc = "A product of Dendor's enigmatic meddling in mortal races. The average wild-kin suffers from \
	animalistic urges that vary in severity, usually tied to the animal that the wild-kin is melded with. \
	Despite this, the way each wild-kin approaches their bizarre physiology varies, creating a diverse \
	race of people who may not even empathise with one another. \
	\n\n\
	THIS IS A DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. PLAY AT YOUR OWN RISK."

	use_skintones = TRUE
	default_color = "444444"
	possible_ages = NORMAL_AGES_LIST_CHILD

	species_traits = list(EYECOLOR, HAIR, FACEHAIR, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)

	statsheet_male = /datum/attribute_holder/sheet/job/species/anthromorph

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
		ORGAN_SLOT_EARS = /obj/item/organ/ears/anthro/wolf,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/anthro,
		ORGAN_SLOT_SNOUT = /obj/item/organ/snout/anthro,
	)

	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/organ/snout/anthro,
		/datum/customizer/organ/tail/anthro,
		/datum/customizer/organ/ears/anthro,
	)

	body_markings = list(
		/datum/body_marking/plain,
		/datum/body_marking/spotted,
		/datum/body_marking/tiger,
		/datum/body_marking/tiger/dark,
		/datum/body_marking/sock,
		/datum/body_marking/socklonger,
		/datum/body_marking/tips,
		/datum/body_marking/belly,
		/datum/body_marking/bellyslim,
		/datum/body_marking/butt,
		/datum/body_marking/tie,
		/datum/body_marking/tiesmall,
		/datum/body_marking/backspots,
		/datum/body_marking/front,
		/datum/body_marking/tonage,
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
	)

/datum/species/anthromorph/check_roundstart_eligible()
	return TRUE

/datum/species/anthromorph/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/anthromorph/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)

/datum/species/anthromorph/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
