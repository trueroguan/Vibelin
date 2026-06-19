/datum/preferences/var/taur_type = null
/datum/preferences/var/taur_color = "ffffff"
/datum/preferences/var/taur_markings = "ffffff"
/datum/preferences/var/taur_tertiary = "ffffff"

/datum/preferences/proc/resolve_taur_type()
	if(!pref_species?.forced_taur || !LAZYLEN(pref_species.allowed_taur_types))
		return null
	if(taur_type && (taur_type in pref_species.allowed_taur_types))
		return taur_type
	taur_type = pick(pref_species.allowed_taur_types)
	return taur_type

/datum/preferences/apply_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE)
	. = ..()
	if(QDELETED(character) || !ishuman(character))
		return
	var/chosen = resolve_taur_type()
	if(!chosen)
		return
	character.Taurize(chosen, "#[taur_color]", "#[taur_markings]", "#[taur_tertiary]")

/datum/preferences/ui_data(mob/user)
	. = ..()
	if(!islist(.))
		return
	var/is_taur = !!(pref_species?.forced_taur && LAZYLEN(pref_species?.allowed_taur_types))
	.["is_taur"] = is_taur
	if(is_taur)
		var/obj/item/bodypart/taur/T = taur_type
		.["taur_body"] = T ? initial(T.name) : "Random"
		.["taur_color"] = "#[taur_color]"
		.["taur_markings"] = "#[taur_markings]"
		.["taur_tertiary"] = "#[taur_tertiary]"

/datum/preferences/process_link(mob/user, list/href_list)
	switch(href_list["preference"])
		if("abel_taur_body")
			if(!pref_species?.forced_taur || !LAZYLEN(pref_species.allowed_taur_types))
				return TRUE
			var/list/choices = list()
			for(var/atype in pref_species.allowed_taur_types)
				var/obj/item/bodypart/taur/T = atype
				choices[initial(T.name)] = atype
			var/picked = tgui_input_list(user, "Choose your taur body.", "TAUR BODY", choices)
			if(!picked || !choices[picked])
				return TRUE
			taur_type = choices[picked]
			save_character()
			update_menu_data(user)
			return TRUE
		if("abel_taur_color")
			var/which = href_list["which"]
			var/current
			switch(which)
				if("markings")
					current = taur_markings
				if("tertiary")
					current = taur_tertiary
				else
					current = taur_color
			var/new_color = input(user, "Choose a color.", "TAUR COLOR", "#[current]") as color|null
			if(!new_color)
				return TRUE
			new_color = replacetext(new_color, "#", "")
			switch(which)
				if("markings")
					taur_markings = new_color
				if("tertiary")
					taur_tertiary = new_color
				else
					taur_color = new_color
			save_character()
			update_menu_data(user)
			return TRUE
	return ..()
