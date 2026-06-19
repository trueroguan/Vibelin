/datum/sprite_accessory/wings/moth
	abstract_type = /datum/sprite_accessory/wings/moth
	icon = 'modular_abel/races/icons/wings/moth_wings.dmi'
	default_colors = list("#FFFFFF")

/datum/sprite_accessory/wings/moth/plain
	name = "Plain"
	icon_state = "plain"

/datum/sprite_accessory/wings/moth/monarch
	name = "Monarch"
	icon_state = "monarch"

/datum/sprite_accessory/wings/moth/luna
	name = "Luna"
	icon_state = "luna"

/datum/sprite_accessory/wings/moth/atlas
	name = "Atlas"
	icon_state = "atlas"

/datum/sprite_accessory/wings/moth/reddish
	name = "Reddish"
	icon_state = "redish"

/datum/sprite_accessory/wings/moth/royal
	name = "Royal"
	icon_state = "royal"

/datum/sprite_accessory/wings/moth/gothic
	name = "Gothic"
	icon_state = "gothic"

/datum/sprite_accessory/wings/moth/lovers
	name = "Lovers"
	icon_state = "lovers"

/datum/sprite_accessory/wings/moth/whitefly
	name = "White Fly"
	icon_state = "whitefly"

/datum/sprite_accessory/wings/moth/punished
	name = "Burnt Off"
	icon_state = "burnt_off"

/datum/sprite_accessory/wings/moth/firewatch
	name = "Firewatch"
	icon_state = "firewatch"

/datum/sprite_accessory/wings/moth/deathhead
	name = "Deathshead"
	icon_state = "deathhead"

/datum/sprite_accessory/wings/moth/poison
	name = "Poison"
	icon_state = "poison"

/datum/sprite_accessory/wings/moth/ragged
	name = "Ragged"
	icon_state = "ragged"

/datum/sprite_accessory/wings/moth/moonfly
	name = "Moon Fly"
	icon_state = "moonfly"

/datum/sprite_accessory/wings/moth/snow
	name = "Snow"
	icon_state = "snow"

/datum/sprite_accessory/wings/moth/oakworm
	name = "Oak Worm"
	icon_state = "oakworm"

/datum/sprite_accessory/wings/moth/jungle
	name = "Jungle"
	icon_state = "jungle"

/datum/sprite_accessory/wings/moth/witchwing
	name = "Witch Wing"
	icon_state = "witchwing"

/obj/item/organ/wings/moth
	name = "fluvian wings"
	desc = "A pair of fuzzy moth wings."
	accessory_type = /datum/sprite_accessory/wings/moth/plain

/datum/customizer/organ/wings/moth
	name = "Fluvian Wings"
	allows_disabling = TRUE
	default_disabled = FALSE
	customizer_choices = list(/datum/customizer_choice/organ/wings/moth)

/datum/customizer_choice/organ/wings/moth
	name = "Fluvian Wings"
	organ_type = /obj/item/organ/wings/moth
	default_accessory = /datum/sprite_accessory/wings/moth/plain
	sprite_accessories = list(
		/datum/sprite_accessory/wings/moth/plain,
		/datum/sprite_accessory/wings/moth/monarch,
		/datum/sprite_accessory/wings/moth/luna,
		/datum/sprite_accessory/wings/moth/atlas,
		/datum/sprite_accessory/wings/moth/reddish,
		/datum/sprite_accessory/wings/moth/royal,
		/datum/sprite_accessory/wings/moth/gothic,
		/datum/sprite_accessory/wings/moth/lovers,
		/datum/sprite_accessory/wings/moth/whitefly,
		/datum/sprite_accessory/wings/moth/punished,
		/datum/sprite_accessory/wings/moth/firewatch,
		/datum/sprite_accessory/wings/moth/deathhead,
		/datum/sprite_accessory/wings/moth/poison,
		/datum/sprite_accessory/wings/moth/ragged,
		/datum/sprite_accessory/wings/moth/moonfly,
		/datum/sprite_accessory/wings/moth/snow,
		/datum/sprite_accessory/wings/moth/oakworm,
		/datum/sprite_accessory/wings/moth/jungle,
		/datum/sprite_accessory/wings/moth/witchwing,
	)
