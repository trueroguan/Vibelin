/mob/living/carbon/human/proc/erp_set_underwear_state(removing)
	if(removing)
		if(underwear == "Nude")
			return FALSE
		cached_underwear = underwear
		underwear = "Nude"
		update_body()
		return TRUE
	if(underwear != "Nude")
		return FALSE
	if(!cached_underwear || cached_underwear == "Nude")
		return FALSE
	underwear = cached_underwear
	update_body()
	return TRUE

/mob/living/carbon/human/verb/erp_toggle_underwear()
	set name = "Smallclothes"
	set category = "IC"
	set desc = "Take off or put back on your smallclothes."

	if(stat != CONSCIOUS)
		to_chat(src, span_warning("I can't do that right now."))
		return

	if(underwear != "Nude")
		if(erp_set_underwear_state(TRUE))
			visible_message(span_notice("[name] slips off their smallclothes."), span_notice("I slip off my smallclothes."))
		return
	if(erp_set_underwear_state(FALSE))
		visible_message(span_notice("[name] slips their smallclothes back on."), span_notice("I slip my smallclothes back on."))
		return
	to_chat(src, span_warning("I'm not wearing any smallclothes."))

/mob/living/carbon/human/proc/erp_register_clothing_signals()
	RegisterSignal(src, COMSIG_ATOM_ATTACK_HAND, PROC_REF(erp_on_attack_hand), override = TRUE)

/mob/living/carbon/human/proc/erp_on_attack_hand(datum/source, mob/living/user, list/modifiers)
	SIGNAL_HANDLER
	if(!istype(user))
		return
	if(user.zone_selected != BODY_ZONE_PRECISE_GROIN)
		return
	if(user.get_active_held_item())
		return
	if(user.used_intent && user.used_intent.type != INTENT_HELP)
		return
	if(!erp_can_strip_underwear(user))
		return
	INVOKE_ASYNC(src, PROC_REF(erp_underwear_interact), user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/mob/living/carbon/human/proc/erp_can_strip_underwear(mob/living/user)
	if(user == src)
		return TRUE
	if(!ishuman(user) || !Adjacent(user))
		return FALSE
	if(!client?.prefs?.erp_enabled || !user.client?.prefs?.erp_enabled)
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/erp_underwear_interact(mob/living/user)
	var/removing = (underwear != "Nude")
	if(user != src)
		user.visible_message(span_notice("[user] reaches for [name]'s smallclothes..."), span_notice("I reach for [name]'s smallclothes..."))
		if(!do_after(user, 2 SECONDS, src))
			return
	if(removing)
		if(erp_set_underwear_state(TRUE))
			visible_message(span_notice("[name]'s smallclothes are slipped off."))
		return
	if(erp_set_underwear_state(FALSE))
		visible_message(span_notice("[name]'s smallclothes are slipped back on."))
