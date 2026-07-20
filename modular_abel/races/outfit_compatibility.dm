/datum/species/var/clothing_race_proxy

/datum/species/proc/is_allowed_clothing_race(list/allowed_race)
	var/own_id = id_override ? id_override : id
	if(own_id in allowed_race)
		return TRUE
	if(clothing_race_proxy && (clothing_race_proxy in allowed_race))
		return TRUE
	return FALSE

/obj/item/clothing/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning, bypass_equip_delay_self)
	if(!M)
		return FALSE

	if(!M.can_equip(src, slot, disable_warning, bypass_equip_delay_self))
		return FALSE

	if(!(slot_flags & slot))
		return FALSE

	if(!(M.gender in allowed_sex))
		return FALSE

	if(!ishuman(M))
		return FALSE

	var/mob/living/carbon/human/H = M

	if(!(H.age in allowed_ages))
		return FALSE

	var/datum/species/species = H.dna?.species
	if(!species)
		return FALSE

	if(!species.is_allowed_clothing_race(allowed_race))
		return FALSE

	return TRUE

/datum/species/harpy
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/medicator
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/elf/sun
	clothing_race_proxy = SPEC_ID_ELF

/datum/species/tabaxi
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/vulpkanin
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/lupian
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/akula
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/anthromorph
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/lizardfolk
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/dracon
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/moth
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/aura
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/taur_kin
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/ooze
	clothing_race_proxy = SPEC_ID_HUMEN

/datum/species/harpy/New()
	. = ..()
	organs = organs.Copy()
	organs -= ORGAN_SLOT_TAIL
	customizers = customizers.Copy()
	customizers -= /datum/customizer/organ/tail/harpy
