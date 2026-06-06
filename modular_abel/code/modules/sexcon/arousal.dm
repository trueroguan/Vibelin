/datum/component/arousal
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/arousal = 0
	var/arousal_frozen = FALSE
	var/last_arousal_increase_time = 0
	var/last_moan = 0
	var/last_pain = 0
	var/arousal_multiplier = 1
	var/charge = SEX_MAX_CHARGE
	var/last_ejaculation_time = 0
	var/erp_last_climax_fx_time = 0

/datum/component/arousal/proc/spread_chain_orgasm(mob/living/carbon/human/source)
	return

/datum/component/arousal/proc/award_satisfaction_on_climax(mob/living/carbon/human/climaxer, mob/living/carbon/human/partner)
	return

/datum/component/arousal/proc/apply_climax_stress(mob/living/carbon/human/climaxer, mob/living/carbon/human/partner)
	return

/datum/component/arousal/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()

/datum/component/arousal/Destroy(force)
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/component/arousal/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_SEX_ADJUST_AROUSAL, PROC_REF(adjust_arousal))
	RegisterSignal(parent, COMSIG_SEX_SET_AROUSAL, PROC_REF(set_arousal))
	RegisterSignal(parent, COMSIG_SEX_FREEZE_AROUSAL, PROC_REF(freeze_arousal))
	RegisterSignal(parent, COMSIG_SEX_GET_AROUSAL, PROC_REF(get_arousal))
	RegisterSignal(parent, COMSIG_SEX_RECEIVE_ACTION, PROC_REF(receive_sex_action))
	RegisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(check_processing))
	RegisterSignal(parent, COMSIG_MOB_LOGOUT, PROC_REF(check_processing))
	check_processing()

/datum/component/arousal/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_SEX_ADJUST_AROUSAL,
		COMSIG_SEX_SET_AROUSAL,
		COMSIG_SEX_FREEZE_AROUSAL,
		COMSIG_SEX_GET_AROUSAL,
		COMSIG_SEX_RECEIVE_ACTION,
		COMSIG_MOB_CLIENT_LOGIN,
		COMSIG_MOB_LOGOUT,
	))

/datum/component/arousal/proc/check_processing()
	SIGNAL_HANDLER
	var/mob/parent_mob = parent
	if(parent_mob.client)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/datum/component/arousal/process(seconds_per_tick)
	handle_charge(seconds_per_tick)
	if(!can_lose_arousal())
		return
	adjust_arousal(parent, seconds_per_tick * -1)

/datum/component/arousal/proc/can_lose_arousal()
	if(last_arousal_increase_time + AROUSAL_TIME_TO_UNHORNY > world.time)
		return FALSE
	return TRUE

/datum/component/arousal/proc/set_arousal(datum/source, amount, forced = FALSE)
	SIGNAL_HANDLER
	if(amount > arousal)
		last_arousal_increase_time = world.time
	arousal = clamp(amount, 0, MAX_AROUSAL)
	try_ejaculate()
	SEND_SIGNAL(parent, COMSIG_SEX_AROUSAL_CHANGED)
	return arousal

/datum/component/arousal/proc/adjust_arousal(datum/source, amount, forced = FALSE)
	SIGNAL_HANDLER
	if(arousal_frozen)
		return arousal
	return set_arousal(source, arousal + amount, forced)

/datum/component/arousal/proc/freeze_arousal(datum/source, freeze_state = null)
	SIGNAL_HANDLER
	if(freeze_state == null)
		arousal_frozen = !arousal_frozen
	else
		arousal_frozen = freeze_state
	return arousal_frozen

/datum/component/arousal/proc/get_arousal(datum/source, list/arousal_data)
	SIGNAL_HANDLER
	var/cost = CHARGE_FOR_CLIMAX
	arousal_data += list(
		"arousal" = arousal,
		"frozen" = arousal_frozen,
		"last_increase" = last_arousal_increase_time,
		"arousal_multiplier" = arousal_multiplier,
		"is_spent" = is_spent(),
		"charge" = charge,
		"charge_max" = SEX_MAX_CHARGE,
		"charge_for_climax" = cost,
		"charge_pct" = (SEX_MAX_CHARGE > 0) ? round((charge / SEX_MAX_CHARGE) * 100) : 0,
		"charge_need_pct" = (SEX_MAX_CHARGE > 0) ? round((cost / SEX_MAX_CHARGE) * 100) : 0,
	)

/datum/component/arousal/proc/receive_sex_action(datum/source, arousal_amt, pain_amt, giving, applied_force = SEX_FORCE_MID, applied_speed = SEX_SPEED_MID, organ_id = null)
	SIGNAL_HANDLER
	var/mob/user = parent

	arousal_amt *= get_force_pleasure_multiplier(applied_force, giving)
	pain_amt *= get_force_pain_multiplier(applied_force)
	pain_amt *= get_speed_pain_multiplier(applied_speed)

	if(user.stat == DEAD)
		arousal_amt = 0
		pain_amt = 0

	if(!arousal_frozen)
		adjust_arousal(source, arousal_amt)

	damage_from_pain(pain_amt)
	try_do_moan(arousal_amt, pain_amt, applied_force, giving)
	try_do_pain_effect(pain_amt, giving)

/datum/component/arousal/proc/damage_from_pain(pain_amt)
	var/mob/living/carbon/user = parent
	if(!istype(user))
		return
	if(pain_amt < PAIN_MINIMUM_FOR_DAMAGE)
		return
	var/damage = (pain_amt / PAIN_DAMAGE_DIVISOR)
	var/obj/item/bodypart/part = user.get_bodypart(BODY_ZONE_CHEST)
	if(!part)
		return
	user.apply_damage(damage, BRUTE, part)

/datum/component/arousal/proc/set_charge(amount)
	var/empty = (charge < CHARGE_FOR_CLIMAX)
	charge = clamp(amount, 0, SEX_MAX_CHARGE)
	var/after_empty = (charge < CHARGE_FOR_CLIMAX)
	if(empty && !after_empty)
		to_chat(parent, span_notice("I feel like I'm not so spent anymore."))
	if(!empty && after_empty)
		to_chat(parent, span_notice("I'm spent!"))

/datum/component/arousal/proc/adjust_charge(amount)
	set_charge(charge + amount)

/datum/component/arousal/proc/handle_charge(seconds_per_tick)
	adjust_charge(seconds_per_tick * CHARGE_RECHARGE_RATE)
	if(is_spent())
		if(arousal > 60)
			to_chat(parent, span_warning("I'm too spent!"))
			adjust_arousal(parent, -20)
			return
		adjust_arousal(parent, -seconds_per_tick * SPENT_AROUSAL_RATE)

/datum/component/arousal/proc/is_spent()
	return (charge < CHARGE_FOR_CLIMAX)

/datum/component/arousal/proc/try_ejaculate()
	if(arousal < PASSIVE_EJAC_THRESHOLD)
		return
	if(is_spent())
		return
	ejaculate()
	record_round_statistic(STATS_PLEASURES)

/datum/component/arousal/proc/get_erp_links()
	var/list/L = list()
	SEND_SIGNAL(parent, COMSIG_ERP_GET_LINKS, L)
	return L

/datum/component/arousal/proc/pick_best_erp_link(list/L)
	var/mob/living/carbon/human/H = parent
	if(!istype(H) || !length(L))
		return null

	var/datum/erp_controller/C = SSerp.get_controller_for(H)
	var/datum/erp_actor/me = C ? C.get_actor_by_mob(H) : null
	if(!me)
		return null

	var/datum/erp_sex_link/best = null
	var/best_score = -1
	for(var/datum/erp_sex_link/link in L)
		if(!link || QDELETED(link) || !link.is_valid() || link.state != LINK_STATE_ACTIVE)
			continue
		var/sc = link.get_climax_score(me)
		if(sc > best_score)
			best_score = sc
			best = link
	return best

/datum/component/arousal/proc/ejaculate()
	if(world.time <= (last_ejaculation_time + 2 SECONDS))
		return
	last_ejaculation_time = world.time

	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return

	var/list/L = get_erp_links()
	var/datum/erp_sex_link/best = pick_best_erp_link(L)
	var/datum/erp_controller/C = best ? SSerp.get_controller_for(H) : null

	var/mob/living/carbon/human/partner = null
	var/climax_type = "self"

	if(best)
		if(best.action && best.action.inject_timing == INJECT_ON_FINISH)
			best.action.handle_inject(best, H)

		var/datum/erp_actor/me = C ? C.get_actor_by_mob(H) : null
		var/list/info = me ? best.handle_climax(me) : null
		climax_type = info?["type"] || "self"
		partner = info?["partner"]

	handle_climax(climax_type, H, partner)
	after_ejaculation(H, partner)

/datum/component/arousal/proc/handle_climax(climax_type, mob/living/carbon/human/climaxer, mob/living/carbon/human/partner)
	switch(climax_type)
		if("outside", "onto")
			log_combat(climaxer, partner, "Came onto [partner]")
			playsound(climaxer, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
			if(partner)
				playsound(partner, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
				new /obj/effect/decal/cleanable/coom(get_turf(partner))
		if("inside", "into")
			log_combat(climaxer, partner, "Came inside [partner]")
			playsound(climaxer, 'sound/misc/mat/endin.ogg', 50, TRUE, ignore_walls = FALSE)
			if(partner)
				playsound(partner, 'sound/misc/mat/endin.ogg', 50, TRUE, ignore_walls = FALSE)
		else
			log_combat(climaxer, climaxer, "Ejaculated")
			climaxer.visible_message(span_love("[climaxer] makes a mess!"))
			playsound(climaxer, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
			new /obj/effect/decal/cleanable/coom(get_turf(climaxer))

/datum/component/arousal/proc/after_ejaculation(mob/living/carbon/human/climaxer, mob/living/carbon/human/partner)
	SEND_SIGNAL(climaxer, COMSIG_SEX_SET_AROUSAL, 20)
	SEND_SIGNAL(climaxer, COMSIG_SEX_CLIMAX)
	charge = max(0, charge - CHARGE_FOR_CLIMAX)
	climaxer.emote("moan", forced = TRUE)
	if(climaxer.client)
		climaxer.playsound_local(climaxer, 'sound/misc/mat/end.ogg', 100)

/datum/component/arousal/proc/try_do_moan(arousal_amt, pain_amt, applied_force, giving)
	var/mob/user = parent
	if(arousal_amt < 1.5)
		return
	if(user.stat != CONSCIOUS)
		return
	if(last_moan + MOAN_COOLDOWN >= world.time)
		return
	if(prob(50))
		return
	var/chosen_emote
	switch(arousal_amt)
		if(0 to 5)
			chosen_emote = "sexmoanlight"
		if(5 to INFINITY)
			chosen_emote = "sexmoanhvy"

	if(pain_amt >= PAIN_MILD_EFFECT)
		if(giving)
			if(prob(30))
				chosen_emote = "groan"
		else
			if(prob(40))
				chosen_emote = "painmoan"
	if(pain_amt >= PAIN_MED_EFFECT)
		if(giving)
			if(prob(50))
				chosen_emote = "groan"
		else
			if(prob(60))
				chosen_emote = "painmoan"

	last_moan = world.time
	user.emote(chosen_emote)

/datum/component/arousal/proc/try_do_pain_effect(pain_amt, giving)
	var/mob/user = parent
	if(pain_amt < PAIN_MILD_EFFECT)
		return
	if(last_pain + PAIN_COOLDOWN >= world.time)
		return
	if(prob(50))
		return
	last_pain = world.time
	if(pain_amt >= PAIN_HIGH_EFFECT)
		to_chat(user, span_boldwarning(pick("IT HURTS!!!", "IT NEEDS TO STOP!!!", "I CAN'T TAKE IT ANYMORE!!!")))
	else if(pain_amt >= PAIN_MED_EFFECT)
		to_chat(user, span_boldwarning(pick("It hurts!", "It pains me!")))
	else
		to_chat(user, span_warning(pick("It hurts a little...", "It stings...", "I'm aching...")))

/datum/component/arousal/proc/get_force_pleasure_multiplier(passed_force, giving)
	switch(passed_force)
		if(SEX_FORCE_LOW)
			return 0.8
		if(SEX_FORCE_MID)
			return 1.2
		if(SEX_FORCE_HIGH)
			return giving ? 1.6 : 1.2
		if(SEX_FORCE_EXTREME)
			return giving ? 2.0 : 0.8
	return 1.0

/datum/component/arousal/proc/get_force_pain_multiplier(passed_force)
	switch(passed_force)
		if(SEX_FORCE_LOW)
			return 0.5
		if(SEX_FORCE_MID)
			return 1.0
		if(SEX_FORCE_HIGH)
			return 2.0
		if(SEX_FORCE_EXTREME)
			return 3.0
	return 1.0

/datum/component/arousal/proc/get_speed_pain_multiplier(passed_speed)
	switch(passed_speed)
		if(SEX_SPEED_LOW)
			return 0.8
		if(SEX_SPEED_MID)
			return 1.0
		if(SEX_SPEED_HIGH)
			return 1.2
		if(SEX_SPEED_EXTREME)
			return 1.4
	return 1.0
