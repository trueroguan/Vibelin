/proc/ui_lang_code(client/target)
	if(!target?.prefs)
		return UI_LANG_CODE_RU
	if(target.prefs.read_preference(/datum/preference/choiced/language) == LANGUAGE_ENGLISH)
		return UI_LANG_CODE_EN
	return UI_LANG_CODE_RU
