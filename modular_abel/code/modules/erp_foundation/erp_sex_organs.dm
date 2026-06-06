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
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_PENIS
	unique_slot = TRUE
	visible_organ = FALSE
	organ_efficiency = list(ORGAN_SLOT_PENIS = 100)
	var/penis_type = PENIS_TYPE_PLAIN
	var/penis_size = DEFAULT_PENIS_SIZE
	var/erect_state = ERECT_STATE_NONE

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

/obj/item/organ/testicles
	name = "testicles"
	desc = "A pair of male reproductive glands."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_TESTICLES
	unique_slot = TRUE
	visible_organ = FALSE
	organ_efficiency = list(ORGAN_SLOT_TESTICLES = 100)
	var/ball_size = DEFAULT_TESTICLES_SIZE

/obj/item/organ/vagina
	name = "vagina"
	desc = "A female reproductive organ."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_VAGINA
	unique_slot = TRUE
	visible_organ = FALSE
	organ_efficiency = list(ORGAN_SLOT_VAGINA = 100)
	var/fertility = FALSE

/obj/item/organ/breasts
	name = "breasts"
	desc = "A pair of mammary glands."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_BREASTS
	unique_slot = TRUE
	visible_organ = FALSE
	organ_efficiency = list(ORGAN_SLOT_BREASTS = 100)
	var/breast_size = BREAST_SIZE_NORMAL
	var/lactating = FALSE

/mob/living/carbon/human/proc/erp_ensure_default_organs()
	if(QDELETED(src))
		return
	if(!client?.prefs?.erp_enabled)
		return

	if(gender == MALE)
		if(!getorganslot(ORGAN_SLOT_PENIS))
			var/obj/item/organ/penis/P = new
			P.Insert(src, special = TRUE, drop_if_replaced = FALSE)
		if(!getorganslot(ORGAN_SLOT_TESTICLES))
			var/obj/item/organ/testicles/T = new
			T.Insert(src, special = TRUE, drop_if_replaced = FALSE)
	else
		if(!getorganslot(ORGAN_SLOT_VAGINA))
			var/obj/item/organ/vagina/V = new
			V.Insert(src, special = TRUE, drop_if_replaced = FALSE)
		if(!getorganslot(ORGAN_SLOT_BREASTS))
			var/obj/item/organ/breasts/B = new
			B.Insert(src, special = TRUE, drop_if_replaced = FALSE)

	SEND_SIGNAL(src, COMSIG_ERP_ANATOMY_CHANGED)
