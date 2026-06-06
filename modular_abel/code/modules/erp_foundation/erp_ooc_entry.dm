/client/verb/erp_settings()
	set name = "ERP Settings"
	set category = "OOC"
	set desc = "Toggle your per-character ERP opt-in and open the ERP panel."

	if(!prefs)
		to_chat(src, span_warning("No preferences loaded."))
		return

	var/list/choices = list()
	choices += (prefs.erp_enabled ? "Disable ERP (currently ON)" : "Enable ERP (currently OFF)")
	if(prefs.erp_enabled)
		choices += "Open ERP Panel"
	choices += "Cancel"

	var/pick = input(src, "ERP is a per-character setting saved to this character slot.", "ERP Settings") as null|anything in choices
	if(!pick || pick == "Cancel")
		return

	switch(pick)
		if("Enable ERP (currently OFF)")
			prefs.erp_enabled = TRUE
			prefs.save_character()
			to_chat(src, span_notice("ERP enabled for this character and saved to your character slot."))
			var/mob/living/carbon/human/H = mob
			if(istype(H))
				H.erp_on_spawn_setup()

		if("Disable ERP (currently ON)")
			prefs.erp_enabled = FALSE
			prefs.save_character()
			to_chat(src, span_notice("ERP disabled for this character and saved to your character slot."))

		if("Open ERP Panel")
			var/mob/living/carbon/human/H = mob
			if(!istype(H))
				to_chat(src, span_warning("You need a living body to configure ERP anatomy."))
				return
			if(!prefs.erp_enabled)
				to_chat(src, span_warning("Enable ERP first."))
				return
			H.start_erp_session(H)
