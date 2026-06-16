/datum/erp_actor_effects_bridge

/obj/item
	var/list/erp_item_tags

#define STATS_KNOTTED "knotted"
#define STATS_KNOTTED_NOT_LUPIANS "knotted_not_lupians"

/proc/islupian(atom/A)
	return FALSE

/proc/is_abstract(thetype)
	if(!ispath(thetype))
		return FALSE
	var/datum/kink/K = thetype
	return initial(K.abstract_type) == thetype

/proc/do_thrust_animate(atom/movable/user, atom/target, dir, pixels, time)
	return

/obj/effect/temp_visual/heart/sex_effects
	icon = 'icons/effects/effects.dmi'
	icon_state = "heart"
	duration = 10

/obj/effect/temp_visual/heart/sex_effects/red_heart
	color = "#ff5b78"

/datum/erp_scene_effects/proc/apply_training(list/active_links)
	return
