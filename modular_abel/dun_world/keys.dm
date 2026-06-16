/obj/item/key/dun_world
	name = "iron key"
	desc = "A heavy iron key, its bow stamped with a worn local seal."

/datum/job/proc/dun_world_grant_keys(mob/living/carbon/human/spawned, list/lockid_list)
	if(!istype(spawned) || !length(lockid_list))
		return
	var/obj/item/key/dun_world/granted = new(spawned)
	granted.lockids = lockid_list.Copy()
	var/obj/item/storage/keyring/ring = locate(/obj/item/storage/keyring) in spawned.get_equipped_items()
	if(ring && SEND_SIGNAL(ring, COMSIG_TRY_STORAGE_INSERT, granted, null, TRUE, FALSE))
		return
	var/obj/item/pack = spawned.get_item_by_slot(ITEM_SLOT_BACK_R) || spawned.get_item_by_slot(ITEM_SLOT_BACK_L)
	if(pack && SEND_SIGNAL(pack, COMSIG_TRY_STORAGE_INSERT, granted, null, TRUE, FALSE))
		return
	spawned.put_in_hands(granted)

/datum/job/innkeep/dun_world_bathmaster/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("bath1", "bath2", "bath3", "bathhouse"))

/datum/job/merchant/dun_world_guildmaster/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("crafterguild", "craftermaster", "artificer", "tailor", "towner_blacksmith", "townie_smith_extra", "shop"))

/datum/job/artificer/dun_world_guildsman/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("artificer", "crafterguild", "craftermaster"))

/datum/job/servant/dun_world_keeper/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("keeper", "keeper2", "farm", "stablemaster", "stable_master_1", "stable_master_2", "stable_master_3", "stable_master_4", "stable_master_5"))

/datum/job/merchant/dun_world_trader/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("merchant", "shop", "stall1", "stall3", "stall4"))

/datum/job/monk/dun_world_druid/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("church", "priest", "zhurch", "graveyard"))

/datum/job/monk/dun_world_martyr/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("church", "priest", "zhurch"))

/datum/job/dungeoneer/dun_world_warden/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("warden", "dungeon", "vault", "armory", "garrison"))

/datum/job/mercenary/dun_world_veteran/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("merc", "merc_bunk_i", "merc_bunk_ii", "merc_bunk_iii", "merc_bunk_iv", "merc_bunk_v", "merc_bunk_vi", "merc_bunk_vii", "merc_bunk_viii"))
