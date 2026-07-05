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
	character_setup_validate_smallclothes()
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
		if("character_setup_taur_body")
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
		if("character_setup_taur_color")
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

/datum/preferences/save_character()
	. = ..()
	if(!path)
		return
	var/savefile/S = new /savefile(path)
	if(!S)
		return
	S.cd = "/character[default_slot]"
	var/taur_type_text = taur_type ? "[taur_type]" : ""
	WRITE_FILE(S["character_setup_taur_type"], taur_type_text)
	WRITE_FILE(S["character_setup_taur_color"], taur_color)
	WRITE_FILE(S["character_setup_taur_markings"], taur_markings)
	WRITE_FILE(S["character_setup_taur_tertiary"], taur_tertiary)

/datum/preferences/load_character(slot)
	. = ..()
	if(!path || !fexists(path))
		return
	var/savefile/S = new /savefile(path)
	if(!S)
		return
	if(!slot)
		slot = default_slot
	slot = sanitize_integer(slot, 1, max_save_slots, initial(default_slot))
	S.cd = "/character[slot]"
	var/loaded_taur
	S["character_setup_taur_type"] >> loaded_taur
	var/resolved = loaded_taur ? text2path(loaded_taur) : null
	taur_type = ispath(resolved, /obj/item/bodypart/taur) ? resolved : null
	var/loaded_color
	S["character_setup_taur_color"] >> loaded_color
	if(loaded_color)
		taur_color = loaded_color
	var/loaded_markings
	S["character_setup_taur_markings"] >> loaded_markings
	if(loaded_markings)
		taur_markings = loaded_markings
	var/loaded_tertiary
	S["character_setup_taur_tertiary"] >> loaded_tertiary
	if(loaded_tertiary)
		taur_tertiary = loaded_tertiary
