/mob/living/carbon/human/proc/erp_get_fillable_hole()
	var/obj/item/organ/vagina/V = getorganslot(ORGAN_SLOT_VAGINA)
	if(V?.sex_organ)
		return V.sex_organ
	var/obj/item/bodypart/chest/C = get_bodypart(BODY_ZONE_CHEST)
	if(C?.sex_organ)
		return C.sex_organ
	return null

/mob/living/carbon/human/proc/erp_can_fill_hole(mob/living/user)
	if(!client?.prefs?.erp_enabled)
		return FALSE
	if(user == src)
		return TRUE
	if(!ishuman(user) || !Adjacent(user))
		return FALSE
	if(!user.client?.prefs?.erp_enabled)
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/erp_on_attackby(datum/source, obj/item/attacking_item, mob/living/user, list/modifiers)
	SIGNAL_HANDLER
	if(!istype(attacking_item, /obj/item/reagent_containers))
		return
	if(!istype(user) || user.zone_selected != BODY_ZONE_PRECISE_GROIN)
		return
	if(!user.used_intent || user.used_intent.type != INTENT_POUR)
		return
	var/obj/item/reagent_containers/container = attacking_item
	if(!container.reagents?.total_volume)
		return
	if(!erp_can_fill_hole(user))
		return
	if(!erp_get_fillable_hole())
		return
	INVOKE_ASYNC(src, PROC_REF(erp_fill_hole_interact), container, user)
	return COMPONENT_NO_AFTERATTACK

/mob/living/carbon/human/proc/erp_fill_hole_interact(obj/item/reagent_containers/container, mob/living/user)
	if(QDELETED(container) || QDELETED(user))
		return
	if(!erp_zone_uncovered(BODY_ZONE_PRECISE_GROIN))
		to_chat(user, span_warning("[src == user ? "My" : "[src]'s"] nethers are covered."))
		return
	var/datum/erp_sex_organ/hole = erp_get_fillable_hole()
	if(!hole?.storage)
		return
	user.visible_message(span_notice("[user] presses [container] to [src == user ? user.p_their() : "[src]'s"] nethers..."), span_notice("I press [container] to [src == user ? "my" : "[src]'s"] nethers..."))
	if(!do_after(user, 2 SECONDS, src))
		return
	if(QDELETED(container) || !container.reagents?.total_volume)
		return
	var/space = hole.storage.free_space()
	if(space <= 0)
		to_chat(user, span_warning("There is no more room inside."))
		return
	var/amount = min(container.amount_per_transfer_from_this, container.reagents.total_volume, space)
	if(amount <= 0)
		return
	hole.receive_reagents(container.reagents, amount)
	playsound(src, 'modular_abel/erp/sound/misc/mat/insert (1).ogg', 50, TRUE)
	user.visible_message(span_notice("[user] empties some of [container] inside [src == user ? user.p_them() : src]."), span_notice("I pour some of [container] inside."))
