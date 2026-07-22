/datum/erp_sex_ui
	var/mob/living/actor
	var/datum/erp_controller/controller
	var/active_tab = "actions"
	var/datum/erp_sex_ui_tab/actions_tab
	var/datum/erp_sex_ui_tab/status_tab
	var/datum/erp_sex_ui_tab/editor_tab
	var/datum/erp_sex_ui_tab/kinks_tab

/datum/erp_sex_ui/New(mob/living/A, datum/erp_controller/C)
	. = ..()
	actor = A
	controller = C
	actions_tab = new /datum/erp_sex_ui_tab/actions(src, "actions")
	status_tab  = new /datum/erp_sex_ui_tab/status(src, "status")
	editor_tab  = new /datum/erp_sex_ui_tab/editor(src, "editor")
	kinks_tab   = new /datum/erp_sex_ui_tab/kinks(src, "erp")

/datum/erp_sex_ui/proc/build_payload(mob/living/current_actor)
	actor = current_actor
	var/datum/erp_actor/P = controller?.active_partner

	var/list/tabs = list(
		"active" = active_tab,
		"status"  = null,
		"actions" = null,
		"editor"  = null,
		"erp"     = null
	)

	switch(active_tab)
		if("status")  tabs["status"]  = status_tab.build()
		if("actions") tabs["actions"] = actions_tab.build()
		if("editor")  tabs["editor"]  = editor_tab.build()
		if("erp")     tabs["erp"]     = kinks_tab.build()

	return list(
		"lang" = ui_lang_code(current_actor?.client),
		"actor_name" = "[actor]",
		"active_tab" = active_tab,
		"hidden_mode" = controller.hidden_mode,
		"do_until_finished" = controller.do_until_finished,
		"yield_to_partner" = controller.yield_to_partner,
		"allow_user_moan" = controller.allow_user_moan,
		"frozen" = controller.arousal_frozen,
		"current_partner_ref" = P ? P.get_ref() : null,
		"current_partner_name" = P ? P.get_display_name() : null,
		"tabs" = tabs,
		"partners" = controller ? controller.get_partners_ui() : list(),
		"actor_arousal" = controller ? controller.get_actor_arousal_ui(actor) : 0,
		"partner_arousal" = controller ? controller.get_partner_arousal_ui(actor) : null,
		"partner_arousal_hidden" = controller ? controller.is_partner_arousal_hidden(actor) : TRUE
	)

/datum/erp_sex_ui/proc/handle_ui_intent(action, list/params)
	switch(action)
		if("set_tab")
			var/static/list/valid_tabs = list("actions", "status", "editor", "erp")
			var/tab = params["tab"]
			if(!(tab in valid_tabs))
				return FALSE
			active_tab = tab
			return TRUE

		if("toggle_hidden")
			controller?.change_hidden_mode()
			return TRUE

		if("yield")
			controller?.change_yield_state()
			return TRUE

		if("freeze_arousal")
			controller?.change_freeze_arousal()
			return TRUE

		if("set_moaning")
			controller?.change_moaning()
			return TRUE

		if("change_direction")
			controller?.change_direction()
			return TRUE

		if("full_stop")
			controller?.full_stop()
			return TRUE

		if("set_partner")
			return controller?.set_active_partner_by_ref(params["ref"])

		if("set_arousal")
			controller?.set_actor_arousal(actor, text2num(params["amount"]))
			return TRUE

	var/datum/erp_sex_ui_tab/T = get_active_tab()
	if(T)
		return T.handle_ui_intent(action, params)

	return FALSE

/datum/erp_sex_ui/proc/get_active_tab()
	switch(active_tab)
		if("actions") return actions_tab
		if("status")  return status_tab
		if("editor")  return editor_tab
		if("erp")     return kinks_tab
	return null

/datum/erp_sex_ui/ui_state(mob/user)
	return GLOB.conscious_state

/datum/erp_sex_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EroticRolePlayPanel", "Утолить желания")
		ui.open()

/datum/erp_sex_ui/ui_data(mob/user)
	if(istype(user, /mob/living) && user.client == actor?.client)
		actor = user
	return build_payload(user)

/datum/erp_sex_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	return handle_ui_intent(action, params)

/datum/erp_sex_ui/proc/request_update()
	if(!controller)
		return
	controller.request_ui_update()
