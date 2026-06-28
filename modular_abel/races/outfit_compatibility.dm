/datum/species/var/outfit_clothing_proxy
/datum/species/var/outfit_clothing_proxy_depth = 0
/datum/species/var/outfit_clothing_original_id

/datum/species/pre_equip_species_outfit(datum/job/job, mob/living/carbon/human/equipping, visuals_only = FALSE)
	if(!outfit_clothing_proxy)
		return
	if(!outfit_clothing_proxy_depth)
		outfit_clothing_original_id = id_override
	outfit_clothing_proxy_depth++
	id_override = outfit_clothing_proxy
	addtimer(CALLBACK(src, PROC_REF(restore_outfit_clothing_id)), 0)

/datum/species/proc/restore_outfit_clothing_id()
	outfit_clothing_proxy_depth = max(0, outfit_clothing_proxy_depth - 1)
	if(outfit_clothing_proxy_depth)
		return
	id_override = outfit_clothing_original_id
	outfit_clothing_original_id = null

/datum/species/harpy
	outfit_clothing_proxy = SPEC_ID_RAKSHARI

/datum/species/medicator
	outfit_clothing_proxy = SPEC_ID_RAKSHARI

/datum/species/moth
	outfit_clothing_proxy = SPEC_ID_RAKSHARI

/datum/species/taur_kin
	outfit_clothing_proxy = SPEC_ID_RAKSHARI

/datum/species/harpy/New()
	. = ..()
	organs = organs.Copy()
	organs -= ORGAN_SLOT_TAIL
	customizers = customizers.Copy()
	customizers -= /datum/customizer/organ/tail/harpy
