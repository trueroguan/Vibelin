/datum/erp_controller_ui
	var/datum/erp_controller/controller

/datum/erp_controller_ui/New(datum/erp_controller/C)
	. = ..()
	controller = C

/datum/erp_controller_ui/proc/open_ui(mob/user = null)
	if(!controller.ui)
		return

	var/mob/M = controller._get_ui_user(user)
	if(!M || !M.client)
		return

	var/datum/erp_actor/A = controller.get_actor_by_mob(M)
	if(A)
		for(var/datum/erp_sex_organ/O in A.get_organs_ref())
			if(!O || QDELETED(O))
				continue

			O.sanitize_owner_links(controller)

	controller.owner_client?.prefs?.apply_erp_kinks_to_mob(M)
	controller.ui.ui_interact(M)

/datum/erp_controller_ui/proc/on_arousal_changed(datum/source)
	controller.ui?.request_update()

/datum/erp_controller_ui/proc/get_arousal_data(mob/living/carbon/human/H)
	if(!istype(H))
		return null

	var/list/data = list()
	SEND_SIGNAL(H, COMSIG_SEX_GET_AROUSAL, data)

	if(!length(data))
		return null

	return data

/datum/erp_controller_ui/proc/get_actor_arousal_ui(mob/user)
	var/mob/living/A = controller._get_owner_effect_mob()
	if(!istype(A))
		return 0

	var/list/data = get_arousal_data(A)
	return data ? (data["arousal"] || 0) : 0

/datum/erp_controller_ui/proc/get_partner_arousal_ui(mob/user)
	var/mob/living/B = controller._get_partner_effect_mob()
	if(!istype(B))
		return 0

	if(controller.is_partner_arousal_hidden(B))
		return null

	var/list/data = get_arousal_data(B)
	return data ? (data["arousal"] || 0) : 0

/datum/erp_controller_ui/proc/set_actor_arousal(actor, value = 0)
	var/mob/living/carbon/human/owner_mob = controller.owner?.physical
	if(!istype(owner_mob) || !owner_mob.client)
		return FALSE

	var/mob/living/carbon/human/H = null
	if(istype(actor,/datum/erp_actor))
		var/datum/erp_actor/A = actor
		H = A.physical
	else if(istype(actor, /mob/living/carbon/human))
		H = actor
	else if(istext(actor))
		if("\ref[owner_mob]" == "[actor]" || "[owner_mob]" == "[actor]")
			H = owner_mob

	if(H != owner_mob)
		return FALSE

	var/n = isnum(value) ? value : text2num("[value]")
	if(!isnum(n))
		return FALSE

	n = clamp(round(n), 0, MAX_AROUSAL)
	SEND_SIGNAL(owner_mob, COMSIG_SEX_SET_AROUSAL, n, TRUE)
	return TRUE

/datum/erp_controller_ui/proc/request_ui_update()
	if(!controller.ui)
		return
	SStgui.update_uis(controller.ui)
