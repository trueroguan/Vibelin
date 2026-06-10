/obj/item/organ
	var/datum/erp_sex_organ/sex_organ

/obj/item/organ/Destroy()
	if(sex_organ)
		qdel(sex_organ)
		sex_organ = null
	return ..()

/obj/item/bodypart
	var/datum/erp_sex_organ/sex_organ

/obj/item/bodypart/Destroy()
	if(sex_organ)
		qdel(sex_organ)
		sex_organ = null
	return ..()

/obj/item/organ/penis
	name = "penis"
	desc = "A male reproductive organ."
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_PENIS
	unique_slot = TRUE
	visible_organ = TRUE
	bodypart_layer = BODY_FRONT_LAYER
	organ_dna_type = /datum/organ_dna/penis
	organ_efficiency = list(ORGAN_SLOT_PENIS = 100)
	var/penis_type = PENIS_TYPE_PLAIN
	var/penis_size = DEFAULT_PENIS_SIZE
	var/erect_state = ERECT_STATE_NONE
	var/sheath_type = SHEATH_TYPE_NONE

/obj/item/organ/penis/proc/update_erect_state(state)
	if(erect_state == state)
		return
	erect_state = state
	if(owner)
		owner.update_body_parts(TRUE)

/obj/item/organ/penis/knotted
	penis_type = PENIS_TYPE_KNOTTED

/obj/item/organ/penis/knotted/big
	penis_size = MAX_PENIS_SIZE

/obj/item/organ/penis/equine
	penis_type = PENIS_TYPE_EQUINE

/obj/item/organ/penis/equine_knotted
	penis_type = PENIS_TYPE_EQUINE_KNOTTED

/obj/item/organ/penis/tapered
	penis_type = PENIS_TYPE_TAPERED

/obj/item/organ/penis/tapered_mammal
	penis_type = PENIS_TYPE_TAPERED

/obj/item/organ/penis/tapered_knot
	penis_type = PENIS_TYPE_TAPERED_KNOTTED

/obj/item/organ/penis/tapered_double
	penis_type = PENIS_TYPE_TAPERED_DOUBLE

/obj/item/organ/penis/tapered_double_knotted
	penis_type = PENIS_TYPE_TAPERED_DOUBLE_KNOTTED

/obj/item/organ/penis/barbed
	penis_type = PENIS_TYPE_BARBED

/obj/item/organ/penis/barbed_knotted
	penis_type = PENIS_TYPE_BARBED_KNOTTED

/obj/item/organ/penis/tentacle
	penis_type = PENIS_TYPE_TENTACLE

/obj/item/organ/testicles
	name = "testicles"
	desc = "A pair of male reproductive glands."
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_TESTICLES
	unique_slot = TRUE
	visible_organ = TRUE
	bodypart_layer = BODY_FRONT_LAYER
	organ_dna_type = /datum/organ_dna/testicles
	organ_efficiency = list(ORGAN_SLOT_TESTICLES = 100)
	var/ball_size = DEFAULT_TESTICLES_SIZE

/obj/item/organ/testicles/internal
	desc = "A pair of internal reproductive glands."
	visible_organ = FALSE

/obj/item/organ/vagina
	name = "vagina"
	desc = "A female reproductive organ."
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_VAGINA
	unique_slot = TRUE
	visible_organ = TRUE
	bodypart_layer = BODY_FRONT_LAYER
	organ_dna_type = /datum/organ_dna/vagina
	organ_efficiency = list(ORGAN_SLOT_VAGINA = 100)
	var/fertility = FALSE

/obj/item/organ/breasts
	name = "breasts"
	desc = "A pair of mammary glands."
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_BREASTS
	unique_slot = TRUE
	visible_organ = TRUE
	bodypart_layer = BODY_ADJ_LAYER
	organ_dna_type = /datum/organ_dna/breasts
	organ_efficiency = list(ORGAN_SLOT_BREASTS = 100)
	var/breast_size = BREAST_SIZE_NORMAL
	var/lactating = FALSE

/obj/item/organ/penis/get_availability(datum/species/owner_species, mob/living/carbon/owner_mob)
	return TRUE

/obj/item/organ/testicles/get_availability(datum/species/owner_species, mob/living/carbon/owner_mob)
	return TRUE

/obj/item/organ/vagina/get_availability(datum/species/owner_species, mob/living/carbon/owner_mob)
	return TRUE

/obj/item/organ/breasts/get_availability(datum/species/owner_species, mob/living/carbon/owner_mob)
	return TRUE
