/mob/living/carbon/human/examine(mob/user)
	. = ..()
	var/list/erp_lines = erp_examine_features(user)
	if(length(erp_lines))
		. += erp_lines

/mob/living/carbon/human/proc/erp_examine_features(mob/user)
	. = list()
	if(!client?.prefs?.erp_enabled)
		return

	var/groin_exposed = isnull(wear_pants)
	var/chest_exposed = isnull(wear_shirt)
	if(!groin_exposed && !chest_exposed)
		return

	var/list/features = list()

	if(groin_exposed)
		var/obj/item/organ/penis/penis = getorganslot(ORGAN_SLOT_PENIS)
		if(penis?.visible_organ && penis.accessory_type)
			var/size_name = find_key_by_value(PENIS_SIZES_BY_NAME, penis.penis_size)
			features += "a[size_name ? " [lowertext(size_name)]" : ""] penis"
		var/obj/item/organ/testicles/balls = getorganslot(ORGAN_SLOT_TESTICLES)
		if(balls?.visible_organ && balls.accessory_type)
			var/size_name = find_key_by_value(TESTICLE_SIZES_BY_NAME, balls.ball_size)
			features += "[size_name ? "[lowertext(size_name)] " : ""]testicles"
		var/obj/item/organ/vagina/cunt = getorganslot(ORGAN_SLOT_VAGINA)
		if(cunt?.visible_organ && cunt.accessory_type)
			features += "a vagina"

	if(chest_exposed)
		var/obj/item/organ/breasts/breasts = getorganslot(ORGAN_SLOT_BREASTS)
		if(breasts?.visible_organ && breasts.accessory_type)
			var/size_name = find_key_by_value(BREAST_SIZES_BY_NAME, breasts.breast_size)
			features += "[size_name ? "[lowertext(size_name)] " : ""]breasts[breasts.lactating ? ", lactating" : ""]"

	var/naked_note
	if(groin_exposed && chest_exposed)
		naked_note = "[p_their(TRUE)] body is bared, leaving nothing to the imagination."
	else if(groin_exposed)
		naked_note = "[p_their(TRUE)] groin is left exposed."
	else
		naked_note = "[p_their(TRUE)] chest is left bare."
	. += span_warning(naked_note)

	if(length(features))
		. += span_notice("Features: [english_list(features)].")
