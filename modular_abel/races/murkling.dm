/mob/living/carbon/human/species/ooze
	race = /datum/species/ooze

/datum/attribute_holder/sheet/job/species/ooze
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_INTELLIGENCE = 1,
		STAT_STRENGTH = -1,
	)

/// Murkling blood is the ooze itself, so it is neither red nor lux-bearing.
/datum/blood_type/human/ooze
	name = "Murk"
	color = "#79F299"
	contains_lux = FALSE

/datum/species/ooze
	name = "Murkling"
	id = SPEC_ID_OOZE
	changesource_flags = WABBAJACK

	desc = "Few know the true origins of the Murklings. Ancient records place their beginnings deep \
	within the cold caverns of the Underdark, where primordial ooze infested the tunnels and defended \
	its spawning pits with relentless hostility. Only within the last century did the ooze begin to \
	change, and what emerged were crude humanoid figures that were somehow sentient. \
	\n\n\
	True to their nature, Murklings adapt rapidly to their surroundings, but that adaptability carries \
	a curse: their bodies absorb more than shape, and dusts and spirits can alter them past recovery. \
	\n\n\
	THIS IS A DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. PLAY AT YOUR OWN RISK."

	use_skintones = TRUE
	default_color = "79F299"
	possible_ages = NORMAL_AGES_LIST_CHILD

	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS)
	inherent_traits = list(
		TRAIT_NOMOBSWAP,
		TRAIT_NASTY_EATER,
		TRAIT_EASYDISMEMBER,
		TRAIT_LIMBATTACHMENT,
		TRAIT_ZOMBIE_IMMUNE,
	)

	statsheet_male = /datum/attribute_holder/sheet/job/species/ooze

	// Murklings hold a humen shape, so they use the humen body and wear what humen wear.
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'

	exotic_bloodtype = /datum/blood_type/human/ooze

	enflamed_icon = "widefire"

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

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/ooze,
		ORGAN_SLOT_SPLEEN = /obj/item/organ/spleen,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/ooze,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/ooze,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/ooze,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/ooze,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/ooze,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/ooze,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)

	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
	)

/datum/species/ooze/check_roundstart_eligible()
	return TRUE

/datum/species/ooze/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/ooze/get_skin_list()
	return list(
		"Bogwater" = "79F299",
		"Mire" = "5a8f63",
		"Silt" = "8a9b6e",
		"Amber Murk" = "c9a24b",
		"Bruised Violet" = "9b6fb5",
		"Deep Tide" = "5f9bb5",
		"Rust Sludge" = "a4593c",
		"Cavern Grey" = "7d8288",
		"Pitch" = "3a3a42",
	)

////// ORGAN SPRITES, provided by VelSlime
/obj/item/organ/brain/ooze
	name = "ooze neural core"
	icon = 'modular_abel/races/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC
	decoy_override = TRUE

/obj/item/organ/lungs/ooze
	name = "ooze breathing sac"
	icon = 'modular_abel/races/icons/obj/velslime.dmi'
	icon_state = "liver" // velslime.dmi has no lungs sprite; the liver one reads as a sac well enough.
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/heart/ooze
	name = "ooze fluid pump"
	icon = 'modular_abel/races/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/eyes/ooze
	name = "ooze ocular sensors"
	icon = 'modular_abel/races/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/tongue/ooze
	name = "ooze taste buds"
	icon = 'modular_abel/races/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/stomach/ooze
	name = "ooze digestive chamber"
	icon = 'modular_abel/races/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/liver/ooze
	name = "ooze detoxification organelle"
	icon = 'modular_abel/races/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC
