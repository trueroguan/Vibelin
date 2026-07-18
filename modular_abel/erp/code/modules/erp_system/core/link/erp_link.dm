/datum/erp_sex_link
	var/datum/erp_actor/actor_active
	var/datum/erp_actor/actor_passive
	var/datum/erp_sex_organ/init_organ
	var/datum/erp_sex_organ/target_organ
	var/datum/erp_action/action

	var/force = SEX_FORCE_MID
	var/speed = SEX_SPEED_MID

	var/state = LINK_STATE_ACTIVE
	var/last_tick = 0
	var/tick_interval = 2 SECONDS
	var/datum/erp_controller/session

	var/finish_mode = "until_climax"
	var/finish_time = 0
	var/climax_target = "none"

/datum/erp_sex_link/New(datum/erp_actor/A, datum/erp_actor/B, datum/erp_action/Act, list/organs, datum/erp_controller/S)
	actor_active  = A
	actor_passive = B
	action = Act
	session = S

	init_organ   = organs?["init"]
	target_organ = organs?["target"]

	if(!init_organ || !target_organ || QDELETED(init_organ) || QDELETED(target_organ))
		qdel(src)
		return

	if(!islist(init_organ.links))
		init_organ.links = list()
	if(!islist(target_organ.links))
		target_organ.links = list()

	init_organ.links += src
	target_organ.links += src

	if(session)
		force = session.default_link_force
		speed = session.default_link_speed

	last_tick = world.time
	var/mob/actor_mob = actor_active.get_mob()
	var/mob/partner_mob = actor_passive.get_mob()
	actor_mob.log_message("([key_name(actor_passive.client)]) started erp action with [partner_mob] ([key_name(actor_passive.client)])", LOG_ATTACK, color="red")
	. = ..()

/datum/erp_sex_link/Destroy()
	finish()
	var/mob/actor_mob = actor_active.get_mob()
	var/mob/partner_mob = actor_passive.get_mob()
	actor_mob.log_message("([key_name(actor_passive.client)]) started erp action with [partner_mob] ([key_name(actor_passive.client)])", LOG_ATTACK, color="red")
	actor_active = null
	actor_passive = null
	action = null
	session = null
	init_organ = null
	target_organ = null
	. = ..()

/datum/erp_sex_link/proc/finish()
	if(state == LINK_STATE_FINISHED)
		return

	state = LINK_STATE_FINISHED

	if(init_organ && !QDELETED(init_organ) && islist(init_organ.links))
		init_organ.links -= src
	if(target_organ && !QDELETED(target_organ) && islist(target_organ.links))
		target_organ.links -= src

/datum/erp_sex_link/proc/request_inject(datum/erp_sex_organ/source, target_mode, datum/erp_actor/who = null)
	if(!source || state != LINK_STATE_ACTIVE)
		return
	if(!session)
		return

	session.handle_inject(link = src, source = source, target_mode = target_mode, who = who)

/datum/erp_sex_link/proc/get_climax_score()
	if(!src)
		return 0

	var/s = 0
	s += (speed || 0) * 10
	s += (force || 0) * 25
	return s

/datum/erp_sex_link/proc/handle_climax(datum/erp_actor/who)
	if(!who || QDELETED(who))
		return null
	return who.build_climax_result(src)

/datum/erp_sex_link/proc/is_giving(datum/erp_actor/A)
	return actor_active == A

/datum/erp_sex_link/proc/is_valid()
	return SSerp?.link_rules?.is_valid(src)

/datum/erp_sex_link/proc/is_aggressive()
	return SSerp?.link_rules?.is_aggressive(src)

/datum/erp_sex_link/proc/has_big_breasts()
	return SSerp?.link_rules?.has_big_breasts(src)

/datum/erp_sex_link/proc/is_dullahan_scene()
	return SSerp?.link_rules?.is_dullahan_scene(src)

/datum/erp_sex_link/proc/is_knot_scene()
	return SSerp?.link_rules?.is_knot_scene(src)

/datum/erp_sex_link/proc/get_target_zone_text()
	return SSerp?.link_presenter?.get_target_zone_text(src) || "тело"

/datum/erp_sex_link/proc/get_target_zone(mob/living/user, mob/living/target)
	return get_target_zone_text()

/datum/erp_sex_link/proc/get_force_text()
	return SSerp?.link_presenter?.get_force_text(force) || "уверенно"

/datum/erp_sex_link/proc/get_speed_text()
	return SSerp?.link_presenter?.get_speed_text(speed) || "ритмично"

/datum/erp_sex_link/proc/get_ui_state()
	return SSerp?.link_presenter?.get_ui_state(src) || list()

/datum/erp_sex_link/proc/get_speed_mult()
	return SSerp?.link_math?.get_speed_mult(speed) || 1.0

/datum/erp_sex_link/proc/get_force_mult()
	return SSerp?.link_math?.get_force_mult(force) || 1.0

/datum/erp_sex_link/proc/get_effective_interval()
	return SSerp?.link_math?.get_effective_interval(src) || tick_interval

/datum/erp_sex_link/proc/get_message_weight()
	return SSerp?.link_math?.get_message_weight(src) || (get_speed_mult() + get_force_mult())

/datum/erp_sex_link/proc/get_message_color()
	return SSerp?.link_presenter?.get_message_color(src)

/datum/erp_sex_link/proc/spanify_sex(text)
	return SSerp?.link_presenter?.spanify_sex(src, text)

/datum/erp_sex_link/proc/get_furniture_for_scene()
	var/mob/living/active_mob = actor_active?.physical
	var/mob/living/passive_mob = actor_passive?.physical

	var/turf/active_turf = get_turf(active_mob)
	var/turf/passive_turf = get_turf(passive_mob)

	if(active_turf && passive_turf && active_turf == passive_turf)
		var/atom/movable/shared_furniture = find_furniture_on_turf(active_turf)
		if(shared_furniture)
			return shared_furniture

	if(active_turf)
		var/atom/movable/active_furniture = find_furniture_on_turf(active_turf)
		if(active_furniture)
			return active_furniture

	if(passive_turf)
		var/atom/movable/passive_furniture = find_furniture_on_turf(passive_turf)
		if(passive_furniture)
			return passive_furniture

	return null

/datum/erp_sex_link/proc/find_furniture_on_turf(turf/T)
	if(!T)
		return null

	var/atom/movable/furniture

	furniture = find_closet_on_turf(T)
	if(furniture)
		return furniture

	furniture = find_bed_on_turf(T)
	if(furniture)
		return furniture

	furniture = find_chair_on_turf(T)
	if(furniture)
		return furniture

	furniture = find_table_on_turf(T)
	if(furniture)
		return furniture

	return null

/datum/erp_sex_link/proc/find_closet_on_turf(turf/T)
	if(!T)
		return null

	for(var/obj/structure/closet/C in T)
		if(QDELETED(C))
			continue
		return C

	return null

/datum/erp_sex_link/proc/find_bed_on_turf(turf/T)
	if(!T)
		return null

	for(var/obj/structure/bed/B in T)
		if(QDELETED(B))
			continue
		return B

	return null

/datum/erp_sex_link/proc/find_chair_on_turf(turf/T)
	if(!T)
		return null

	for(var/obj/structure/chair/C in T)
		if(QDELETED(C))
			continue
		return C

	return null

/datum/erp_sex_link/proc/find_table_on_turf(turf/T)
	if(!T)
		return null

	for(var/obj/structure/table/TB in T)
		if(QDELETED(TB))
			continue
		return TB

	return null
