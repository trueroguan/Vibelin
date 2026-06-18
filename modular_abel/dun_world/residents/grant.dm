/datum/action/cooldown/spell/undirected/list_target/grant_resident
	name = "Grant Residency"
	desc = "Welcome a soul as a resident with the right to a home, or cast an unworthy one out as an outsider."
	button_icon_state = "recruit_titlegrant"
	spell_type = NONE
	cooldown_time = 1 MINUTES
	target_radius = 3

/datum/action/cooldown/spell/undirected/list_target/grant_resident/get_list_targets(atom/center, target_radius)
	var/list/things = list()
	if(target_radius)
		for(var/mob/living/carbon/human/target_mob in view(target_radius, center))
			if(QDELETED(target_mob))
				continue
			if(!target_mob.mind || target_mob.stat != CONSCIOUS)
				continue
			if(!target_mob.get_face_name(null))
				continue
			things += target_mob
	return things

/datum/action/cooldown/spell/undirected/list_target/grant_resident/before_cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	if(cast_on.has_quirk(/datum/quirk/boon/resident))
		var/answer = tgui_alert(owner, "[cast_on] is already a resident, cast them out?", "[name]", DEFAULT_INPUT_CONFIRMATIONS)
		if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
			return . | SPELL_CANCEL_CAST
		if(answer == CHOICE_CONFIRM)
			owner.say("I HEREBY CAST YOU OUT, [uppertext(cast_on.name)], FROM THESE LANDS!")
			cast_on.remove_quirk(/datum/quirk/boon/resident)
			cast_on.received_resident_key = FALSE
		else
			reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/undirected/list_target/grant_resident/cast(mob/living/carbon/human/cast_on)
	. = ..()
	owner.say("I HEREBY WELCOME YOU, [uppertext(cast_on.name)], AS A RESIDENT OF THESE LANDS!")
	cast_on.add_quirk(/datum/quirk/boon/resident)
