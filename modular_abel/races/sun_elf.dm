/mob/living/carbon/human/species/elf/sun
	race = /datum/species/elf/sun

/datum/attribute_holder/sheet/job/species/sun
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = -1,
		STAT_SPEED = 1,
	)

/datum/species/elf/sun
	name = "Sun Elf"
	id = SPEC_ID_ELF_SUN
	desc = "A sun-touched offshoot of elvenkind.\
	\n\n\
	Sun Elves hail from the warm and distant lands of the far East, where their ancestors raised \
	a proud, sun-worshipping dominion of gilded spires and rigid castes. \
	Centuries of golden light left its mark on them: warm, bronzed skin, and an unshakeable conviction \
	in their own superiority. \
	\n\n\
	The collapse of their homeland to faith-wars and the rebellions of those they once enslaved \
	scattered the Sun Elves westward. Many arrive in these colder lands as refugees, \
	though few shed the imperious bearing of a people who still believe themselves chosen. \
	They are vain, assertive, and quick to look down upon faiths and folk they deem lesser, \
	yet that same pride makes them formidable courtiers, scholars, and zealots."

	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)
	use_skintones = 1
	disliked_food = NONE
	liked_food = NONE
	possible_ages = NORMAL_AGES_LIST_CHILD
	changesource_flags = WABBAJACK
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/met.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/ft.dmi'
	hairyness = "t1"

	customizers = list(
		/datum/customizer/organ/ears/elf,
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
	)

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_SPLEEN = /obj/item/organ/spleen,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/elf,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/elfw,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)

	swap_male_clothes = TRUE

	soundpack_m = /datum/voicepack/male/elf
	soundpack_f = /datum/voicepack/female/elf

	offset_features_m = list(
		OFFSET_RING = list(0,2),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,1),\
		OFFSET_HANDS = list(0,2),\
		OFFSET_CLOAK = list(0,2),\
		OFFSET_FACEMASK = list(0,1),\
		OFFSET_HEAD = list(0,1),\
		OFFSET_FACE = list(0,1),\
		OFFSET_BELT = list(0,1),\
		OFFSET_BACK = list(0,2),\
		OFFSET_NECK = list(0,1),\
		OFFSET_MOUTH = list(0,2),\
		OFFSET_PANTS = list(0,2),\
		OFFSET_SHIRT = list(0,2),\
		OFFSET_ARMOR = list(0,2),\
		OFFSET_UNDIES = list(0,0),\
	)

	offset_features_f = list(
		OFFSET_RING = list(0,0),\
		OFFSET_GLOVES = list(0,1),\
		OFFSET_WRISTS = list(0,1),\
		OFFSET_HANDS = list(0,1),\
		OFFSET_CLOAK = list(0,1),\
		OFFSET_FACEMASK = list(0,0),\
		OFFSET_HEAD = list(0,0),\
		OFFSET_FACE = list(0,0),\
		OFFSET_BELT = list(0,1),\
		OFFSET_BACK = list(0,0),\
		OFFSET_NECK = list(0,0),\
		OFFSET_MOUTH = list(0,0),\
		OFFSET_PANTS = list(0,1),\
		OFFSET_SHIRT = list(0,1),\
		OFFSET_ARMOR = list(0,1),\
		OFFSET_UNDIES = list(0,1),\
	)

	statsheet_male = /datum/attribute_holder/sheet/job/species/sun
	enflamed_icon = "widefire"

	body_markings = list(
		/datum/body_marking/tonage,
	)

/datum/species/elf/sun/check_roundstart_eligible()
	return TRUE

/datum/species/elf/sun/get_skin_list()
	return list(
		"sun - dawn" = "e9c9a8",
		"sun - morning" = "e0b993",
		"sun - noon" = "d8a878",
		"sun - amber" = "c89460",
		"sun - bronze" = "b27b46",
		"sun - dusk" = "9c6638",
		"sun - gilded" = "8a5530",
	)

/datum/species/elf/sun/get_hairc_list()
	return sortList(list(
		"black - oil" = "181a1d",
		"black - rogue" = "2b201b",

		"blond - pale" = "9d8d6e",
		"blond - dirty" = "88754f",
		"blond - drywheat" = "d5ba7b",
		"blond - strawberry" = "c69b71",

		"brown - mud" = "362e25",
		"brown - oats" = "584a3b",
		"brown - grain" = "58433b",
		"brown - soil" = "48322a",

		"red - berry" = "b23434",
		"red - wine" = "82534c",
		"red - sunset" = "82462b",
		"red - blood" = "822b2b",
	))

/datum/species/elf/sun/get_possible_names(gender = MALE)
	var/static/list/male_names = file2list('strings/rt/names/elf/elfwm.txt')
	var/static/list/female_names = file2list('strings/rt/names/elf/elfwf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/elf/sun/get_possible_surnames(gender = MALE)
	var/static/list/last_names = file2list('strings/rt/names/elf/elfwlast.txt')
	return last_names

/datum/species/elf/sun/after_creation(mob/living/carbon/C)
	C.dna.species.accent_language = C.dna.species.get_accent(C.dna.species.native_language, 1)
