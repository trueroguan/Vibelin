/datum/sprite_accessory/horns/aura
	abstract_type = /datum/sprite_accessory/horns/aura
	icon = 'modular_abel/races/icons/horns/aura.dmi'

/datum/sprite_accessory/horns/aura/get_icon_state(obj/item/organ/horns/horns, ...)
	return icon_state

/datum/sprite_accessory/horns/aura/dragonhorn
	name = "Dragon Horns"
	icon_state = "dragonhorn"

/datum/sprite_accessory/horns/aura/dragonfaceguard
	name = "Dragon Faceguard"
	icon_state = "dragonfaceguard"

/obj/item/organ/horns/aura
	name = "aura horns"
	accessory_type = /datum/sprite_accessory/horns/aura/dragonhorn

/datum/customizer/organ/horns/humanoid/aura
	customizer_choices = list(/datum/customizer_choice/organ/horns/humanoid/aura)
	default_disabled = FALSE

/datum/customizer_choice/organ/horns/humanoid/aura
	name = "Horns"
	organ_type = /obj/item/organ/horns/aura
	default_accessory = /datum/sprite_accessory/horns/aura/dragonhorn
	sprite_accessories = list(
		/datum/sprite_accessory/horns/aura/dragonhorn,
		/datum/sprite_accessory/horns/aura/dragonfaceguard,
	)


/datum/sprite_accessory/tail/aura
	abstract_type = /datum/sprite_accessory/tail/aura

/datum/sprite_accessory/tail/aura/dragontail
	name = "Dragon Tail"
	icon = 'modular_abel/races/icons/tails/aura.dmi'
	icon_state = "dragontail"
	can_wag = TRUE

/obj/item/organ/tail/dragontail
	name = "dragon tail"
	accessory_type = /datum/sprite_accessory/tail/aura/dragontail

/datum/customizer/organ/tail/aura
	customizer_choices = list(/datum/customizer_choice/organ/tail/aura)

/datum/customizer_choice/organ/tail/aura
	name = "Dragon Tail"
	organ_type = /obj/item/organ/tail/dragontail
	generic_random_pick = TRUE
	default_accessory = /datum/sprite_accessory/tail/aura/dragontail
	sprite_accessories = list(
		/datum/sprite_accessory/tail/aura/dragontail,
	)


/datum/body_marking/aura
	abstract_type = /datum/body_marking/aura
	icon = 'modular_abel/races/icons/body_markings/aura_markings.dmi'
	default_color = "FFF"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT | LEG_RIGHT | LEG_LEFT
	gendered = TRUE

/datum/body_marking/aura/z
	name = "Покой"
	icon_state = "z"

/datum/body_marking/aura/x
	name = "Слово"
	icon_state = "x"

/datum/body_marking/aura/c
	name = "Сила"
	icon_state = "c"

/datum/body_marking/aura/v
	name = "Равновесие"
	icon_state = "v"

/datum/body_marking_set/aura
	abstract_type = /datum/body_marking_set/aura

/datum/body_marking_set/aura/z
	name = "Покой"
	body_marking_list = list(/datum/body_marking/aura/z)

/datum/body_marking_set/aura/x
	name = "Слово"
	body_marking_list = list(/datum/body_marking/aura/x)

/datum/body_marking_set/aura/c
	name = "Сила"
	body_marking_list = list(/datum/body_marking/aura/c)

/datum/body_marking_set/aura/v
	name = "Равновесие"
	body_marking_list = list(/datum/body_marking/aura/v)


/mob/living/carbon/human/species/aura
	race = /datum/species/aura

/datum/attribute_holder/sheet/job/species/aura
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
	)

/datum/species/aura
	name = "Au'Ra"
	id = SPEC_ID_AURA
	changesource_flags = WABBAJACK

	desc = "<b>Ау'Ра</b><br>\
	Изогнутые рога и красиво узорчатая чешуя Ау'Ра часто заставляют предполагать, что они произошли от драконов. \
	Это давно оспаривается, и ученые приводят в качестве доказательств против этого явные различия между двумя видами. \
	Улучшенный слух и способность распознавать пространство, которыми обладают их рога, не встречаются у драконов, \
	а крайний половой диморфизм, характерный для этой расы, также не встречается у драконов. \
	Представители этой расы крепки и выносливы из-за чешуи, которая защищает их. \
	\n\n\
	THIS IS A DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. PLAY AT YOUR OWN RISK."

	use_skintones = TRUE
	default_color = "FFFFFF"
	possible_ages = NORMAL_AGES_LIST_CHILD

	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)

	statsheet_male = /datum/attribute_holder/sheet/job/species/aura

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'

	meat = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)

	offset_features_m = list(
		OFFSET_RING = list(0,1),OFFSET_GLOVES = list(0,1),OFFSET_WRISTS = list(0,1),OFFSET_HANDS = list(0,1),\
		OFFSET_CLOAK = list(0,1),OFFSET_FACEMASK = list(0,1),OFFSET_HEAD = list(0,1),OFFSET_FACE = list(0,1),\
		OFFSET_BELT = list(0,1),OFFSET_BACK = list(0,1),OFFSET_NECK = list(0,1),OFFSET_MOUTH = list(0,1),\
		OFFSET_PANTS = list(0,0),OFFSET_SHIRT = list(0,1),OFFSET_ARMOR = list(0,1),OFFSET_UNDIES = list(0,1),\
	)
	offset_features_f = list(
		OFFSET_RING = list(0,-1),OFFSET_GLOVES = list(0,0),OFFSET_WRISTS = list(0,0),OFFSET_HANDS = list(0,0),\
		OFFSET_CLOAK = list(0,0),OFFSET_FACEMASK = list(0,-1),OFFSET_HEAD = list(0,-1),OFFSET_FACE = list(0,-1),\
		OFFSET_BELT = list(0,0),OFFSET_BACK = list(0,-1),OFFSET_NECK = list(0,-1),OFFSET_MOUTH = list(0,-1),\
		OFFSET_PANTS = list(0,0),OFFSET_SHIRT = list(0,0),OFFSET_ARMOR = list(0,0),OFFSET_UNDIES = list(0,0),\
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
		ORGAN_SLOT_HORNS = /obj/item/organ/horns/aura,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/dragontail,
	)

	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)

	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/organ/horns/humanoid/aura,
		/datum/customizer/organ/tail/aura,
	)

	body_marking_sets = list(
		/datum/body_marking_set/aura/z,
		/datum/body_marking_set/aura/x,
		/datum/body_marking_set/aura/c,
		/datum/body_marking_set/aura/v,
	)
	body_markings = list(
		/datum/body_marking/aura/z,
		/datum/body_marking/aura/x,
		/datum/body_marking/aura/c,
		/datum/body_marking/aura/v,
	)

/datum/species/aura/check_roundstart_eligible()
	return TRUE

/datum/species/aura/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/aura/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)

/datum/species/aura/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/aura/get_skin_list()
	return list(
		"Азри" = "e8d9c5",
		"Наиире" = "5a4a52",
		"Pale" = "d9cdbd",
		"Ashen" = "8a8079",
		"Slate" = "4a5258",
		"Crimson" = "6b2a24",
	)
