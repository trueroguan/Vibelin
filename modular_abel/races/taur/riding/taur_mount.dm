/mob/living/carbon/human/var/taur_allow_riding = FALSE

/datum/component/riding/creature/taur
	can_be_driven = FALSE

/datum/component/riding/creature/taur/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 6, OBJ_LAYER),
		TEXT_SOUTH = list(0, 6, ABOVE_MOB_LAYER),
		TEXT_EAST = list(-3, 6, OBJ_LAYER),
		TEXT_WEST = list(3, 6, OBJ_LAYER),
	)

// ---------------- ANTI-GRIEF CONSENT ----------------

/mob/living/carbon/human/proc/taur_consent_prebuckle(datum/source, mob/living/rider, force, ride_check_flags)
	SIGNAL_HANDLER
	if(force)
		return
	if(!taur_allow_riding)
		if(rider && rider != src)
			to_chat(rider, span_warning("[src] will not let you mount them."))
		return COMPONENT_BLOCK_BUCKLE

/mob/living/carbon/human/verb/toggle_taur_riding()
	set name = "Toggle Allow Riding"
	set category = "IC"
	if(!get_taur_tail())
		to_chat(src, span_warning("My body cannot be ridden."))
		return
	taur_allow_riding = !taur_allow_riding
	to_chat(src, span_notice("I will [taur_allow_riding ? "now" : "no longer"] allow others to ride me."))
	if(!taur_allow_riding && has_buckled_mobs())
		unbuckle_all_mobs()

// ---------------- HIT REDIRECT (rider -> taur, by riding skill) ----------------

/mob/living/carbon/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE, damage_type, skip_dtype, can_crit = TRUE)
	if(damage > 0 && (damagetype == BRUTE || damagetype == BURN) && istype(buckled, /mob/living/carbon/human))
		var/mob/living/carbon/human/mount = buckled
		if(mount != src && mount.get_taur_tail())
			var/skill = GET_MOB_SKILL_VALUE(src, /datum/attribute/skill/misc/riding) || 0
			var/redirect_chance = min(floor(skill / 10) * 10, 60)
			if(redirect_chance > 0 && prob(redirect_chance))
				mount.visible_message(span_warning("[mount] takes a blow meant for [src]!"))
				return mount.apply_damage(damage, damagetype, blocked = blocked, forced = forced, can_crit = can_crit)
	return ..()
