/mob/living/carbon/human/species/taur_kin
	race = /datum/species/taur_kin

/datum/attribute_holder/sheet/job/species/taur_kin
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = -1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = 1,
		STAT_FORTUNE = -1,
		STAT_ENDURANCE = -1,
	)

/datum/species/taur_kin
	name = "Taur-Kin"
	id = SPEC_ID_TAUR_KIN
	changesource_flags = WABBAJACK

	desc = "Taur-Kins are a highly diverse and varied group of people, the majority of which are descendants of the \
	first followers of the wilds who rejected civilization in favour of the deep forests. Some came from \
	magical anomalies or curses, Divine or otherwise. \
	\n\n\
	Where their kin walk on two legs, a Taur-Kin's body splits into a beastly lower half, leaving them powerful \
	but heavy, unable to wear footwear or fit through narrow places as easily as others. \
	\n\n\
	THIS IS A DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. PLAY AT YOUR OWN RISK."

	use_skintones = TRUE
	default_color = "444444"
	possible_ages = NORMAL_AGES_LIST_CHILD

	species_traits = list(EYECOLOR, HAIR, FACEHAIR, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)

	forced_taur = TRUE
	allowed_taur_types = list(
		/obj/item/bodypart/taur/otie,
		/obj/item/bodypart/taur/canine,
		/obj/item/bodypart/taur/venard,
		/obj/item/bodypart/taur/drake,
		/obj/item/bodypart/taur/dragon,
		/obj/item/bodypart/taur/noodle,
		/obj/item/bodypart/taur/horse,
		/obj/item/bodypart/taur/deer,
		/obj/item/bodypart/taur/redpanda,
		/obj/item/bodypart/taur/rat,
		/obj/item/bodypart/taur/skunk,
		/obj/item/bodypart/taur/kitsune,
		/obj/item/bodypart/taur/feline,
		/obj/item/bodypart/taur/snep,
		/obj/item/bodypart/taur/tiger,
		/obj/item/bodypart/taur/spider,
		/obj/item/bodypart/taur/arachne,
		/obj/item/bodypart/taur/centipede,
		/obj/item/bodypart/taur/sloog,
		/obj/item/bodypart/taur/ant,
		/obj/item/bodypart/taur/wasp,
		/obj/item/bodypart/taur/insect,
		/obj/item/bodypart/taur/jdeer,
	)

	statsheet_male = /datum/attribute_holder/sheet/job/species/taur_kin

	limbs_icon_m = 'modular_abel/races/icons/bodies/m/mta.dmi'
	limbs_icon_f = 'modular_abel/races/icons/bodies/f/fma.dmi'

	meat = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)

	offset_features_m = list(
		OFFSET_RING = list(0,1),OFFSET_GLOVES = list(0,1),OFFSET_WRISTS = list(0,1),OFFSET_HANDS = list(0,1),\
		OFFSET_CLOAK = list(0,1),OFFSET_FACEMASK = list(0,1),OFFSET_HEAD = list(0,1),OFFSET_FACE = list(0,1),\
		OFFSET_BELT = list(0,1),OFFSET_BACK = list(0,1),OFFSET_NECK = list(0,1),OFFSET_MOUTH = list(0,1),\
		OFFSET_PANTS = list(0,1),OFFSET_SHIRT = list(0,1),OFFSET_ARMOR = list(0,1),OFFSET_UNDIES = list(0,0),\
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

/datum/species/taur_kin/check_roundstart_eligible()
	return TRUE

/datum/species/taur_kin/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/taur_kin/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)

/datum/species/taur_kin/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(H.get_taur_tail())
			H.ensure_not_taur()

/datum/species/taur_kin/get_skin_list()
	return list(
		"Brown" = "5c4327",
		"Russet" = "7a4a2c",
		"Grey" = "7c7d77",
		"Silver" = "9ea0a0",
		"Cream" = "d8c39c",
		"Black" = "2c2722",
		"White" = "d9d6cc",
		"Tan" = "9c8a5e",
	)
