/client/verb/toggle_ui_language()
	set name = "Язык / Language"
	set category = "OOC"
	set desc = "Переключить язык интерфейса (RU/EN) / Switch interface language"
	if(!prefs)
		return
	var/new_lang = (prefs.read_preference(/datum/preference/choiced/language) == LANGUAGE_ENGLISH) ? LANGUAGE_RUSSIAN : LANGUAGE_ENGLISH
	prefs.write_preference(/datum/preference/choiced/language, new_lang)
	prefs.save_preferences()
	SStgui.update_uis(prefs)
	to_chat(src, span_notice("Язык интерфейса: [new_lang] / Interface language: [new_lang]"))
