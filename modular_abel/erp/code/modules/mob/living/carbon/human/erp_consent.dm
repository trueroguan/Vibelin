/proc/erp_try_start(atom/initiator, atom/target_atom, mob/living/actor, silent = FALSE)
	if(!actor || !istype(actor))
		return null
	if(!target_atom || QDELETED(target_atom))
		return null

	if(istype(target_atom, /obj/structure/closet))
		return erp_try_start_container(initiator, target_atom, actor, silent)

	var/force = FALSE
	#ifdef LOCALTEST
	force = TRUE
	#endif

	if(!erp_can_use_menu_as_actor(actor, silent, force))
		return null

	var/mob/living/carbon/human/consent = SSerp.get_consent_mob_for_target(target_atom)
	if(!consent)
		return null

	if(!erp_can_target_atom_for_menu(actor, target_atom, silent, force))
		return null

	var/client/C = actor.client
	var/datum/erp_controller/EC = SSerp.get_or_create_controller(initiator, C, actor)
	if(!EC)
		return null

	EC.add_partner_atom(target_atom)
	EC.open_ui(actor)
	return EC

/proc/erp_can_use_menu_as_actor(mob/living/actor, silent = FALSE, force = FALSE)
	if(!actor || !istype(actor))
		return FALSE
	if(force)
		return TRUE

	var/mob/living/carbon/human/human_actor = actor
	if(istype(human_actor) && !human_actor.can_do_sex)
		if(!silent)
			to_chat(actor, span_warning("I can't do this."))
		return FALSE

	if(istype(human_actor) && human_actor.is_erp_blocked_as_target())
		return FALSE

	if(!actor.client?.prefs?.erp_enabled)
		if(!silent)
			to_chat(actor, span_warning("You don't want to do this. (ERP preference)"))
		return FALSE

	return TRUE

/proc/erp_can_target_atom_for_menu(mob/living/actor, atom/target_atom, silent = FALSE, force = FALSE)
	if(!actor || !target_atom || QDELETED(target_atom))
		return FALSE

	var/mob/living/carbon/human/consent = SSerp.get_consent_mob_for_target(target_atom)
	if(!consent)
		return FALSE
	if(force)
		return TRUE

	if(consent.is_erp_blocked_as_target())
		return FALSE
	if(!consent.client)
		return FALSE

	if(!consent.client?.prefs?.erp_enabled)
		if(!silent)
			to_chat(actor, span_warning("[consent] doesn't wish to be touched. (Their ERP preference)"))
			to_chat(consent, span_warning("[actor] failed to touch you. (Your ERP preference)"))
		log_combat(actor, consent, "tried unwanted ERP menu against")
		return FALSE

	return TRUE

/proc/erp_collect_valid_targets_from_container(atom/container, atom/initiator, mob/living/actor, silent = FALSE, force = FALSE)
	var/list/out = list()
	if(!container || QDELETED(container) || !actor)
		return out
	for(var/atom/movable/AM in container.contents)
		if(!AM || QDELETED(AM))
			continue
		if(!erp_can_target_atom_for_menu(actor, AM, TRUE, force))
			continue
		out += AM
	return out

/proc/erp_try_start_container(atom/initiator, atom/container, mob/living/actor, silent = FALSE)
	if(!actor || !container || QDELETED(container))
		return null

	var/force = FALSE
	#ifdef LOCALTEST
	force = TRUE
	#endif

	if(!erp_can_use_menu_as_actor(actor, silent, force))
		return null

	var/list/targets = erp_collect_valid_targets_from_container(container, initiator, actor, silent, force)
	if(!targets.len)
		if(!silent)
			to_chat(actor, span_warning("There is no valid partner inside."))
		return null

	var/client/C = actor.client
	var/datum/erp_controller/EC = SSerp.get_or_create_controller(initiator, C, actor)
	if(!EC)
		return null

	var/first = TRUE
	for(var/atom/target_atom as anything in targets)
		EC.add_partner_atom(target_atom, first)
		first = FALSE

	EC.open_ui(actor)
	return EC

/mob/living/carbon/human/MiddleMouseDrop_T(atom/movable/dragged, mob/living/user)
	if(user?.mmb_intent)
		return ..()
	if(!dragged)
		return
	if(dragged != user)
		return
	return erp_try_start(user, src, user)

/mob/living/simple_animal/MiddleMouseDrop_T(atom/movable/dragged, mob/living/user)
	if(user?.mmb_intent)
		return ..()
	if(!dragged)
		return
	if(dragged != user)
		return
	return erp_try_start(user, src, user)

/obj/structure/closet/MiddleMouseDrop_T(atom/movable/dragged, mob/living/user)
	if(user?.mmb_intent)
		return ..()
	if(!dragged || !user)
		return

	var/valid = FALSE
	if(dragged == user)
		valid = TRUE
	else if(dragged == src && user.loc == src)
		valid = TRUE
	if(!valid)
		return

	return erp_try_start(user, src, user)
