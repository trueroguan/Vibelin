GLOBAL_LIST_INIT(character_setup_smallclothes_customizers, list(
	/datum/customizer/bodypart_feature/smallclothes/bottom,
	/datum/customizer/bodypart_feature/smallclothes/top,
	/datum/customizer/bodypart_feature/smallclothes/legs,
))

/datum/preferences/var/character_setup_suppress_smallclothes_sync = FALSE

/datum/bodypart_feature/smallclothes
	body_zone = BODY_ZONE_CHEST

/datum/bodypart_feature/smallclothes/bottom
	name = "Underwear"
	feature_slot = "smallclothes_bottom"

/datum/bodypart_feature/smallclothes/top
	name = "Torso Underwear"
	feature_slot = "smallclothes_top"

/datum/bodypart_feature/smallclothes/legs
	name = "Legwear"
	feature_slot = "smallclothes_legs"

/datum/customizer/bodypart_feature/smallclothes
	abstract_type = /datum/customizer/bodypart_feature/smallclothes
	allows_disabling = TRUE
	default_disabled = FALSE
	var/smallclothes_slot

/datum/customizer/bodypart_feature/smallclothes/make_default_customizer_entry(datum/preferences/prefs, changed_entry = TRUE)
	. = ..()
	var/datum/customizer_entry/entry = .
	var/datum/customizer_choice/bodypart_feature/smallclothes/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
	var/legacy_name
	var/legacy_color
	switch(smallclothes_slot)
		if("top")
			legacy_name = prefs.cspref_undershirt()
			legacy_color = prefs.undershirt_color
		if("legs")
			legacy_name = prefs.cspref_socks()
			legacy_color = prefs.socks_color
		else
			legacy_name = prefs.cspref_underwear()
			legacy_color = prefs.cspref_underwear_color()

	var/list/allowed = choice.character_setup_accessory_types(prefs)
	var/selected_type = choice.character_setup_accessory_type_by_name(legacy_name, prefs)
	if(!selected_type && length(allowed))
		selected_type = allowed[1]
	if(selected_type)
		entry.accessory_type = selected_type
	if(legacy_color)
		entry.accessory_colors = color_list_to_string(list(legacy_color))
	entry.disabled = !is_allowed(prefs) || !selected_type

/datum/customizer/bodypart_feature/smallclothes/bottom
	name = "Underwear"
	smallclothes_slot = "bottom"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/smallclothes/bottom)

/datum/customizer/bodypart_feature/smallclothes/top
	name = "Torso Underwear"
	smallclothes_slot = "top"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/smallclothes/top)

/datum/customizer/bodypart_feature/smallclothes/legs
	name = "Legwear"
	smallclothes_slot = "legs"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/smallclothes/legs)

/datum/customizer/bodypart_feature/smallclothes/legs/is_allowed(datum/preferences/prefs)
	var/datum/species/species = return_species(prefs)
	return !species?.forced_taur

/datum/customizer_choice/proc/character_setup_accessory_types(datum/preferences/prefs)
	return sprite_accessories

/datum/customizer_choice/proc/character_setup_section()
	return null

/datum/customizer_choice/bodypart_feature/smallclothes
	abstract_type = /datum/customizer_choice/bodypart_feature/smallclothes
	var/accessory_root

/datum/customizer_choice/bodypart_feature/smallclothes/New()
	sprite_accessories = list()
	for(var/datum/sprite_accessory/accessory_type as anything in subtypesof(accessory_root))
		if(!initial(accessory_type.roundstart) || !initial(accessory_type.name) || !initial(accessory_type.icon) || !initial(accessory_type.icon_state))
			continue
		sprite_accessories += accessory_type
	return ..()

/datum/customizer_choice/bodypart_feature/smallclothes/character_setup_section()
	return "underwear"

/datum/customizer_choice/bodypart_feature/smallclothes/proc/character_setup_accessory_type_by_name(accessory_name, datum/preferences/prefs)
	if(!accessory_name || accessory_name == "Nude")
		return
	for(var/accessory_type in character_setup_accessory_types(prefs))
		var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
		if(accessory.name == accessory_name)
			return accessory_type

/datum/customizer_choice/bodypart_feature/smallclothes/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	. = ..()
	var/list/allowed = character_setup_accessory_types(prefs)
	if(!(entry.accessory_type in allowed) && length(allowed))
		set_accessory_type(prefs, allowed[1], entry)
	if(length(allowed))
		entry.disabled = FALSE
	else
		entry.disabled = TRUE

/datum/customizer_choice/bodypart_feature/smallclothes/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	if(href_list["customizer_task"] == "select_acc")
		var/accessory_type = text2path(href_list["acc_type"])
		if(!(accessory_type in character_setup_accessory_types(prefs)))
			return
	return ..()

/datum/customizer_choice/bodypart_feature/smallclothes/bottom
	name = "Underwear"
	feature_type = /datum/bodypart_feature/smallclothes/bottom
	accessory_root = /datum/sprite_accessory/underwear

/datum/customizer_choice/bodypart_feature/smallclothes/top
	name = "Torso Underwear"
	feature_type = /datum/bodypart_feature/smallclothes/top
	accessory_root = /datum/sprite_accessory/undershirt

/datum/customizer_choice/bodypart_feature/smallclothes/top/character_setup_accessory_types(datum/preferences/prefs)
	var/datum/species/species = return_species(prefs)
	if(!species?.forced_taur)
		return ..()
	var/list/allowed = list()
	for(var/accessory_type in sprite_accessories)
		var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
		if(accessory.smallclothes_taur_compatible)
			allowed += accessory_type
	return allowed

/datum/customizer_choice/bodypart_feature/smallclothes/legs
	name = "Legwear"
	feature_type = /datum/bodypart_feature/smallclothes/legs
	accessory_root = /datum/sprite_accessory/socks

/datum/preferences/proc/character_setup_sync_smallclothes_from_entries()
	for(var/customizer_type in GLOB.character_setup_smallclothes_customizers)
		var/datum/customizer/bodypart_feature/smallclothes/customizer = CUSTOMIZER(customizer_type)
		var/datum/customizer_entry/entry = get_customizer_entry_for_customizer_type(customizer_type)
		if(!customizer || !entry)
			continue
		var/datum/sprite_accessory/accessory = entry.accessory_type ? SPRITE_ACCESSORY(entry.accessory_type) : null
		var/selected_name = (!customizer.is_allowed(src) || entry.disabled || !accessory) ? "Nude" : accessory.name
		var/list/colors = color_string_to_list(entry.accessory_colors)
		var/selected_color = length(colors) ? colors[1] : null
		switch(customizer.smallclothes_slot)
			if("top")
				cspref_set_undershirt(selected_name)
				if(selected_color)
					undershirt_color = selected_color
			if("legs")
				cspref_set_socks(selected_name)
				if(selected_color)
					socks_color = selected_color
			else
				cspref_set_underwear(selected_name)
				if(selected_color)
					cspref_set_underwear_color(selected_color)

/datum/preferences/validate_customizer_entries()
	if(pref_species && islist(pref_species.customizers))
		for(var/customizer_type in GLOB.character_setup_smallclothes_customizers)
			pref_species.customizers |= customizer_type
	. = ..()
	if(!character_setup_suppress_smallclothes_sync)
		character_setup_sync_smallclothes_from_entries()
