GLOBAL_LIST_EMPTY(socks_m)
GLOBAL_LIST_EMPTY(socks_f)
GLOBAL_LIST_INIT(socks_list, init_socks_list())

/proc/init_socks_list()
	var/list/socks = init_sprite_accessory_subtypes(/datum/sprite_accessory/socks)
	GLOB.socks_m = socks[MALE_SPRITE_LIST]
	GLOB.socks_f = socks[FEMALE_SPRITE_LIST]
	return socks[DEFAULT_SPRITE_LIST]

/datum/preferences/var/undershirt_color
/datum/preferences/var/socks_color

/mob/living/carbon/human/var/undershirt_color
/mob/living/carbon/human/var/socks_color
/mob/living/carbon/human/var/uses_smallclothes_features = FALSE
/mob/living/carbon/human/var/smallclothes_render_suppressed = FALSE

/datum/preferences/_load_appearence(savefile/save)
	. = ..()
	save["undershirt_color"] >> undershirt_color
	save["socks_color"] >> socks_color

/datum/preferences/save_character()
	if(!character_setup_suppress_smallclothes_sync)
		character_setup_sync_smallclothes_from_entries()
	. = ..()
	if(!path)
		return
	var/savefile/save = new /savefile(path)
	if(!save)
		return
	save.cd = "/character[default_slot]"
	WRITE_FILE(save["undershirt_color"], undershirt_color)
	WRITE_FILE(save["socks_color"], socks_color)

/datum/preferences/apply_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE)
	if(!character_setup_suppress_smallclothes_sync)
		character_setup_sync_smallclothes_from_entries()
	if(!QDELETED(character))
		character.uses_smallclothes_features = TRUE
	. = ..()
	if(QDELETED(character))
		return
	character.undershirt_color = undershirt_color
	character.socks_color = socks_color
