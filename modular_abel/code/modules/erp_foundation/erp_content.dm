/obj/effect/decal/cleanable/coom
	name = "mess"
	desc = ""
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "mess1"
	random_icon_states = list("mess1", "mess2", "mess3")
	beauty = -100
	alpha = 150
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = NO_CLIENT_COLOR
	var/reagents_capacity = 50

/obj/effect/decal/cleanable/coom/Initialize(mapload)
	. = ..()
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)
	if(!reagents)
		create_reagents(reagents_capacity)

/obj/effect/decal/cleanable/coom/proc/is_empty()
	return !reagents || reagents.total_volume <= 0

/datum/reagent/erpjuice
	name = "Bodily Fluid"
	taste_description = "salty"
	reagent_state = LIQUID
	color = "#ebebeb"

/datum/reagent/erpjuice/cum
	name = "Erotic Fluid"
	description = "A thick, sticky, cream-like fluid produced during orgasm."
	color = "#ebebeb"
	taste_description = "salty and tangy"

/datum/reagent/erpjuice/lube
	name = "Lubricant"
	description = "A slick, translucent fluid that helps things go smoothly."
	color = "#e6f0ff"
	taste_description = "slippery"

/datum/reagent/consumable/milk/erp
	name = "Breast Milk"
	description = "A thick, sweet milk that clearly doesn't come from a cow."
	color = "#eee4e4"
	taste_description = "sweet and tart"
	nutriment_factor = 0

#define ERP_COATING_DRY_AFTER (4 MINUTES)

/datum/status_effect/erp_coating
	id = "erp_coating"
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = ERP_COATING_DRY_AFTER
	duration = -1
	var/coating_zone = "body"
	var/has_dried_up = FALSE
	var/datum/reagents/reagents
	var/reagents_capacity = 30

/datum/status_effect/erp_coating/on_creation(mob/living/new_owner, capacity = 30)
	. = ..()
	reagents_capacity = max(5, capacity)
	if(!reagents)
		reagents = new /datum/reagents(reagents_capacity)
		reagents.my_atom = src

/datum/status_effect/erp_coating/Destroy()
	if(reagents)
		qdel(reagents)
		reagents = null
	return ..()

/datum/status_effect/erp_coating/on_apply()
	. = ..()
	if(owner)
		RegisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(_on_clean_act), override = TRUE)
	has_dried_up = FALSE
	return TRUE

/datum/status_effect/erp_coating/on_remove()
	if(owner)
		UnregisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT)
	return ..()

/datum/status_effect/erp_coating/tick()
	has_dried_up = TRUE

/datum/status_effect/erp_coating/proc/_on_clean_act(datum/source, clean)
	SIGNAL_HANDLER
	if(QDELETED(owner))
		return FALSE
	if(reagents)
		reagents.clear_reagents()
	qdel(src)
	return TRUE

/datum/status_effect/erp_coating/proc/is_empty()
	return !reagents || reagents.total_volume <= 0

/datum/status_effect/erp_coating/proc/add_from(datum/reagents/R, amount = null)
	if(!reagents || !R || R.total_volume <= 0)
		return 0
	var/take = amount
	if(!isnum(take) || take <= 0)
		take = R.total_volume
	take = min(take, R.total_volume)
	R.trans_to(reagents, take, 1, TRUE, TRUE)
	has_dried_up = FALSE
	return take

/datum/status_effect/erp_coating/groin
	id = "erp_coating_groin"
	coating_zone = "groin"

/datum/status_effect/erp_coating/chest
	id = "erp_coating_chest"
	coating_zone = "chest"

/datum/status_effect/erp_coating/face
	id = "erp_coating_face"
	coating_zone = "face"

#undef ERP_COATING_DRY_AFTER

/datum/status_effect/mouth_full
	id = "mouth_full"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/mouth_full
	duration = -1

/atom/movable/screen/alert/status_effect/mouth_full
	name = "Full Mouth"
	desc = "Click to swallow a bit."

/atom/movable/screen/alert/status_effect/mouth_full/Click(location, control, params)
	..()
	var/mob/living/user = usr
	if(!istype(user))
		return FALSE
	var/datum/erp_sex_organ/mouth/M = user.get_erp_organ(SEX_ORGAN_MOUTH)
	if(M)
		M.swallow(5)
	return FALSE

/datum/status_effect/knot_tied
	id = "knot_tied"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knot_tied

/atom/movable/screen/alert/status_effect/knot_tied
	name = "Knotted"
	desc = "I am tied to my partner..."

/datum/status_effect/knot_fucked_stupid
	id = "knot_fucked_stupid"
	duration = 2 MINUTES
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knot_fucked_stupid

/atom/movable/screen/alert/status_effect/knot_fucked_stupid
	name = "Fucked Stupid"
	desc = "Mmmph I can't think straight..."

/datum/status_effect/knot_gaped
	id = "knot_gaped"
	duration = 60 SECONDS
	tick_interval = 10 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knot_gaped
	var/turf/last_loc

/datum/status_effect/knot_gaped/on_apply()
	last_loc = get_turf(owner)
	return ..()

/datum/status_effect/knot_gaped/tick()
	var/turf/cur_loc = get_turf(owner)
	if(get_dist(cur_loc, last_loc) <= 5)
		return
	new /obj/effect/decal/cleanable/coom(cur_loc)
	last_loc = cur_loc

/atom/movable/screen/alert/status_effect/knot_gaped
	name = "Gaped"
	desc = "You were forcefully withdrawn from..."

/datum/status_effect/knotted
	id = "knotted"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knotted

/atom/movable/screen/alert/status_effect/knotted
	name = "Knotted"
	desc = "I have to be careful where I step..."

/atom/movable/screen/alert/status_effect/knotted/Click()
	..()
	var/mob/living/user = usr
	if(!istype(user))
		return FALSE
	var/datum/component/erp_knotting/knot_comp = user.GetComponent(/datum/component/erp_knotting)
	if(!knot_comp)
		return FALSE
	if(!knot_comp.active_links || !knot_comp.active_links.len)
		return FALSE
	var/list/arousal_data = list()
	SEND_SIGNAL(user, COMSIG_SEX_GET_AROUSAL, arousal_data)
	var/do_forceful_removal = (arousal_data["arousal"] > MAX_AROUSAL / 2)
	for(var/datum/erp_knot_link/L as anything in knot_comp.active_links)
		if(!istype(L) || !L.is_valid())
			continue
		if(L.top != user)
			continue
		knot_comp.remove_all_for_penis(L.penis_org, who_pulled = user, forceful = do_forceful_removal)
	return FALSE

/obj/item/dildo
	name = "dildo"
	desc = "A phallic implement."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "nullrod"
	w_class = WEIGHT_CLASS_SMALL
