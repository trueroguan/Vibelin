/datum/preference/choiced/language
	savefile_key = "language"
	savefile_identifier = PREF_PLAYER
	category = "ui"
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/choiced/language/init_possible_values(datum/preferences/prefs)
	return list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH)

/datum/preference/choiced/language/create_default_value(datum/preferences/prefs)
	return LANGUAGE_RUSSIAN

/datum/preference/choiced/language/handle_link(datum/preferences/prefs, mob/user)
	switch(prefs.read_preference(/datum/preference/choiced/language))
		if(LANGUAGE_ENGLISH)
			prefs.write_preference(/datum/preference/choiced/language, LANGUAGE_RUSSIAN)
		else
			prefs.write_preference(/datum/preference/choiced/language, LANGUAGE_ENGLISH)
