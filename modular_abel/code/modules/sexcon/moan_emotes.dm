/datum/emote/living/moan
	key = "moan"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE

/datum/emote/living/moan/get_sound(mob/living/user)
	return get_erp_moan_sound(user)

/datum/emote/living/sexmoanlight
	key = "sexmoanlight"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE

/datum/emote/living/sexmoanlight/get_sound(mob/living/user)
	return get_erp_moan_sound(user)

/datum/emote/living/sexmoanhvy
	key = "sexmoanhvy"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE

/datum/emote/living/sexmoanhvy/get_sound(mob/living/user)
	return get_erp_moan_sound(user)

/proc/get_erp_moan_sound(mob/living/user)
	var/static/list/feminine_moans = list(
		'modular_abel/sound/misc/mat/sex_moans/mature_woman/SWFMoan159.ogg',
		'modular_abel/sound/misc/mat/sex_moans/mature_woman/SWFMoan164.ogg',
		'modular_abel/sound/misc/mat/sex_moans/mature_woman/SWFMoan171.ogg',
		'modular_abel/sound/misc/mat/sex_moans/mature_woman/SWFMoan178.ogg',
		'modular_abel/sound/misc/mat/sex_moans/mature_woman/SWFMoan182.ogg',
	)
	var/static/list/masculine_moans = list(
		'modular_abel/sound/misc/mat/sex_moans/fem_man/SWFMoan210.ogg',
		'modular_abel/sound/misc/mat/sex_moans/fem_man/SWFMoan213.ogg',
		'modular_abel/sound/misc/mat/sex_moans/fem_man/SWFMoan216.ogg',
		'modular_abel/sound/misc/mat/sex_moans/fem_man/SWFMoan217.ogg',
		'modular_abel/sound/misc/mat/sex_moans/fem_man/SWFMoan219.ogg',
	)
	if(user?.gender == FEMALE)
		return pick(feminine_moans)
	return pick(masculine_moans)
