SUBSYSTEM_DEF(room_key_funds)
	name = "Room Key Funds"
	flags = SS_NO_FIRE
	var/static/list/funded_jobs = typecacheof(list(
		/datum/job/royalknight,
		/datum/job/men_at_arms,
	))
	var/coin_grant = 3

/datum/controller/subsystem/room_key_funds/Initialize(start_timeofday)
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_job_after_spawn))
	return ..()

/datum/controller/subsystem/room_key_funds/proc/on_job_after_spawn(source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER
	if(!ishuman(spawned) || !is_type_in_list(job, funded_jobs))
		return
	var/mob/living/carbon/human/H = spawned
	var/obj/item/coin/gold/pile/coins = new(null, coin_grant)
	if(!H.equip_to_slot_if_possible(coins, ITEM_SLOT_BACKPACK, qdel_on_fail = FALSE, disable_warning = TRUE))
		H.put_in_hands(coins, del_on_fail = TRUE)
