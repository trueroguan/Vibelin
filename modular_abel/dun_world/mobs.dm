/mob/living/simple_animal/hostile/boss/dun_world_lich
	name = "Archlich"
	desc = "An incomprehensibly powerful necromancer, dressed in the papal garbs of a priest of old - a glimpse into what once was. The air around you crackles with unholy energy."
	mob_biotypes = MOB_HUMANOID|MOB_UNDEAD
	boss_abilities = list(/datum/action/boss/dun_world_lich_summon)
	faction = list(FACTION_UNDEAD)
	del_on_death = TRUE
	icon = 'icons/mob/evilpope.dmi'
	icon_state = "EvilPope"
	wander = 0
	vision_range = 8
	aggro_vision_range = 24
	ranged = 1
	rapid = 3
	rapid_fire_delay = 8
	ranged_message = "casts a spell"
	ranged_cooldown_time = 40
	ranged_ignores_vision = TRUE
	environment_smash = 0
	minimum_distance = 8
	retreat_distance = 0
	move_to_delay = 10
	obj_damage = 100
	melee_damage_lower = 60
	melee_damage_upper = 80
	health = 6666
	maxHealth = 6666
	loot = list(/obj/effect/temp_visual/dun_world_lich_dying)
	projectiletype = /obj/projectile/magic/arcane_barrage
	stat_attack = UNCONSCIOUS

/datum/action/boss/dun_world_lich_summon
	name = "Summon Minions"
	usage_probability = 100
	boss_cost = 70
	boss_type = /mob/living/simple_animal/hostile/boss/dun_world_lich
	needs_target = TRUE
	say_when_triggered = "Minions, to me!"
	var/summoned_minions = 0

/datum/action/boss/dun_world_lich_summon/Trigger(trigger_flags)
	. = ..()
	if(!. || summoned_minions > 6)
		return
	var/list/directions = GLOB.cardinals.Copy()
	for(var/i in 1 to 2)
		new /mob/living/carbon/human/species/skeleton/npc/medium(get_step(boss, pick_n_take(directions)))
	summoned_minions++

/obj/effect/temp_visual/dun_world_lich_dying
	name = "Lich"
	desc = ""
	layer = ABOVE_OPEN_TURF_LAYER
	icon = 'icons/mob/evilpope.dmi'
	icon_state = "popedeath"
	anchored = TRUE
	duration = 30
	randomdir = FALSE

/obj/effect/temp_visual/dun_world_lich_dying/Initialize()
	. = ..()
	visible_message(span_boldannounce("The Archlich collapses into a pile of dust and bone, unholy energy dispersing into the air!"))

/obj/effect/temp_visual/dun_world_lich_dying/Destroy()
	for(var/mob/M in range(7, src))
		shake_camera(M, 7, 1)
	var/turf/T = get_turf(src)
	playsound(T, 'sound/vo/mobs/skel/skeleton_death (5).ogg', 80, TRUE, TRUE)
	new /obj/item/key/dun_world_lich(T)
	return ..()

/obj/item/key/dun_world_lich
	name = "lich's key"
	desc = "An offputting key the Archlich dropped."
	lockid = "lich"

/obj/effect/dun_world_oneway/barrier/lich
	desc = "An unholy barrier. Perhaps the key of its master can disperse it."

/obj/effect/dun_world_oneway/barrier/lich/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/key/dun_world_lich))
		visible_message(span_boldannounce("The magical barrier disperses!"))
		qdel(src)
