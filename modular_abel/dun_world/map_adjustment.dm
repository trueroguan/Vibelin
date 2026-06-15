/datum/map_adjustment/dun_world
	map_file_name = "dun_world_new.dmm"
	slot_adjust = list(
		/datum/job/merchant/dun_world_guildmaster = 1,
		/datum/job/artificer/dun_world_guildsman = 4,
		/datum/job/innkeep/dun_world_bathmaster = 1,
		/datum/job/servant/dun_world_keeper = 1,
		/datum/job/merchant/dun_world_trader = 5,
		/datum/job/monk/dun_world_druid = 2,
		/datum/job/monk/dun_world_martyr = 1,
		/datum/job/vagrant/dun_world_lunatic = 1,
		/datum/job/vagrant/dun_world_vagabond = 12,
		/datum/job/mercenary/dun_world_veteran = 1,
		/datum/job/dungeoneer/dun_world_warden = 4,
	)

/datum/map_adjustment/dun_world/job_change()
	. = ..()
	change_job_position(/datum/job/lord, 1, 1)
	change_job_position(/datum/job/villager, 0, 40)
	GLOB.peasant_positions.Add(/datum/job/villager::title)
	GLOB.serf_positions.Add("Guildmaster", "Guildsman", "Bathmaster")
	GLOB.church_positions.Add("Druid", "Martyr")
	GLOB.garrison_positions.Add("Warden")
	GLOB.allmig_positions.Add("Keeper", "Trader", "Lunatic", "Vagabond", "Veteran")
