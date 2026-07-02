/datum/sprite_accessory
	var/smallclothes_covers_torso = FALSE
	var/smallclothes_covers_groin = FALSE
	var/smallclothes_covers_legs = FALSE
	var/smallclothes_taur_compatible = FALSE
	var/smallclothes_female_state
	var/smallclothes_dwarf_state
	var/smallclothes_female_dwarf_state
	var/smallclothes_female_extra_state
	var/smallclothes_female_dwarf_extra_state

/datum/sprite_accessory/underwear
	use_static = FALSE
	color_key_name = "Underwear"
	default_colors = list("#755f46")
	smallclothes_covers_groin = TRUE

/datum/sprite_accessory/proc/smallclothes_state(mob/living/carbon/human/human)
	var/datum/species/species = human.dna?.species
	var/species_id = species?.id_override || species?.id
	var/is_dwarf_body = species_id in list(SPEC_ID_DWARF, SPEC_ID_DWARF_SUBTERRAN, SPEC_ID_HALFLING)
	if(human.gender == FEMALE)
		if(is_dwarf_body && smallclothes_female_dwarf_state)
			return smallclothes_female_dwarf_state
		if(smallclothes_female_state)
			return smallclothes_female_state
	if(is_dwarf_body && smallclothes_dwarf_state)
		return smallclothes_dwarf_state
	return icon_state

/datum/sprite_accessory/proc/smallclothes_extra_state(mob/living/carbon/human/human)
	if(human.gender != FEMALE)
		return
	var/datum/species/species = human.dna?.species
	var/species_id = species?.id_override || species?.id
	if((species_id in list(SPEC_ID_DWARF, SPEC_ID_DWARF_SUBTERRAN, SPEC_ID_HALFLING)) && smallclothes_female_dwarf_extra_state)
		return smallclothes_female_dwarf_extra_state
	return smallclothes_female_extra_state

/datum/sprite_accessory/proc/smallclothes_torso_is_visible(mob/living/carbon/human/human)
	var/hide_top = FALSE
	for(var/obj/item/clothing/clothing in list(human.wear_armor, human.wear_shirt, human.cloak))
		if(!clothing)
			continue
		hide_top ||= clothing.flags_inv & (HIDEBOOB | HIDEUNDIESTOP)
	return !hide_top

/datum/sprite_accessory/proc/smallclothes_bottom_is_visible(mob/living/carbon/human/human)
	var/hide_bottom = FALSE
	for(var/obj/item/clothing/clothing in list(human.wear_armor, human.wear_shirt, human.cloak))
		if(clothing)
			hide_bottom ||= clothing.flags_inv & HIDEUNDIESBOT
	if(human.wear_pants)
		hide_bottom ||= human.wear_pants.flags_inv & HIDEUNDIESBOT
	return !hide_bottom

/datum/sprite_accessory/proc/smallclothes_is_visible(mob/living/carbon/human/human)
	if(smallclothes_covers_torso && smallclothes_torso_is_visible(human))
		return TRUE
	if((smallclothes_covers_groin || smallclothes_covers_legs) && smallclothes_bottom_is_visible(human))
		return TRUE
	return FALSE

/datum/sprite_accessory/proc/smallclothes_adjust_appearance(list/appearance_list, obj/item/bodypart/bodypart, mob/living/carbon/human/human)
	generic_gender_feature_adjust(appearance_list, null, bodypart, human, OFFSET_UNDIES)
	if(smallclothes_state(human) == icon_state)
		var/datum/species/species = human.dna?.species
		if(species)
			var/use_female = (human.gender == FEMALE) && species.sexes && !species.swap_female_clothes
			var/list/offsets = use_female ? species.offset_genitals_f : species.offset_genitals_m
			if(LAZYACCESS(offsets, OFFSET_SMALLCLOTHES))
				for(var/mutable_appearance/appearance as anything in appearance_list)
					appearance.pixel_x += offsets[OFFSET_SMALLCLOTHES][1]
					appearance.pixel_y += offsets[OFFSET_SMALLCLOTHES][2]
			if(species.smallclothes_scale_x != 1 || species.smallclothes_scale_y != 1)
				var/sx = species.smallclothes_scale_x
				var/sy = species.smallclothes_scale_y
				for(var/mutable_appearance/appearance as anything in appearance_list)
					var/icon/scaled = icon(appearance.icon, appearance.icon_state)
					var/old_w = scaled.Width()
					var/old_h = scaled.Height()
					var/new_w = max(1, round(old_w * sx))
					var/new_h = max(1, round(old_h * sy))
					scaled.Scale(new_w, new_h)
					appearance.icon = scaled
					appearance.pixel_x += round((old_w - new_w) / 2)
					appearance.pixel_y += round((old_h - new_h) / 2)

/datum/sprite_accessory/underwear/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/mob/living/carbon/human/human = owner
	return istype(human) ? smallclothes_state(human) : icon_state

/datum/sprite_accessory/underwear/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/mob/living/carbon/human/human = owner
	return istype(human) && human.underwear == name && smallclothes_is_visible(human)

/datum/sprite_accessory/underwear/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/mob/living/carbon/human/human = owner
	if(istype(human))
		smallclothes_adjust_appearance(appearance_list, bodypart, human)

/proc/smallclothes_groin_covered(mob/living/carbon/human/human)
	if(!istype(human))
		return FALSE
	var/datum/sprite_accessory/accessory
	if(human.underwear && human.underwear != "Nude")
		accessory = GLOB.underwear_list[human.underwear]
		if(istype(accessory) && accessory.smallclothes_covers_groin)
			return TRUE
	if(human.undershirt && human.undershirt != "Nude")
		accessory = GLOB.undershirt_list[human.undershirt]
		if(istype(accessory) && accessory.smallclothes_covers_groin)
			return TRUE
	if(human.socks && human.socks != "Nude")
		accessory = GLOB.socks_list[human.socks]
		if(istype(accessory) && accessory.smallclothes_covers_groin)
			return TRUE
	return FALSE

/proc/smallclothes_breast_size(mob/living/carbon/human/human, maximum = 5)
	var/obj/item/organ/breasts = human.getorganslot("breasts")
	var/breast_size = breasts?.vars["breast_size"]
	if(!isnum(breast_size))
		return 0
	return clamp(breast_size, 0, maximum)

/datum/sprite_accessory/underwear/female_bikini
	smallclothes_covers_torso = TRUE
	smallclothes_female_extra_state = "female_boob"

/datum/sprite_accessory/underwear/female_dwarf
	smallclothes_covers_torso = TRUE
	smallclothes_female_extra_state = "female_dwarf_boob"

/datum/sprite_accessory/underwear/female_leotard
	smallclothes_covers_torso = TRUE
	smallclothes_female_extra_state = "female_leotard_boob"

/datum/sprite_accessory/underwear/bikini
	name = "Bikini"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_bottoms.dmi'
	icon_state = "bikini_f_0"
	specuse = ALL_RACES_LIST
	smallclothes_covers_torso = TRUE

/datum/sprite_accessory/underwear/bikini/smallclothes_state(mob/living/carbon/human/human)
	return "bikini_f_[smallclothes_breast_size(human)]"

/datum/sprite_accessory/underwear/leotard
	name = "Leotard"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_bottoms.dmi'
	icon_state = "male_leotard"
	specuse = ALL_RACES_LIST
	smallclothes_covers_torso = TRUE

/datum/sprite_accessory/underwear/leotard/smallclothes_state(mob/living/carbon/human/human)
	if(human.gender == FEMALE)
		return "female_leotard_[smallclothes_breast_size(human)]"
	return icon_state

/datum/sprite_accessory/underwear/athletic_leotard
	name = "Athletic Leotard"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_bottoms.dmi'
	icon_state = "male_athletic_leotard"
	smallclothes_female_state = "female_athletic_leotard"
	specuse = ALL_RACES_LIST
	smallclothes_covers_torso = TRUE

/datum/sprite_accessory/underwear/eoran_briefs
	name = "Eoran Briefs"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_bottoms.dmi'
	icon_state = "eoran_reg"
	smallclothes_female_state = "eoran_elf"
	smallclothes_dwarf_state = "eoran_dwarf"
	smallclothes_female_dwarf_state = "eoran_dwarf"
	specuse = ALL_RACES_LIST

/datum/sprite_accessory/underwear/small_loincloth
	name = "Small Loincloth"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_bottoms.dmi'
	icon_state = "loinclothunder"
	specuse = ALL_RACES_LIST

/datum/sprite_accessory/underwear/briefs
	name = "Briefs"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_bottoms.dmi'
	icon_state = "briefs"
	smallclothes_female_state = "briefs_f"
	smallclothes_dwarf_state = "briefs_dwarf"
	smallclothes_female_dwarf_state = "briefs_dwarf_f"
	specuse = ALL_RACES_LIST

/datum/sprite_accessory/underwear/panties
	name = "Panties"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_bottoms.dmi'
	icon_state = "panties"
	smallclothes_female_state = "panties_f"
	specuse = ALL_RACES_LIST

/datum/sprite_accessory/underwear/thong
	name = "Thong"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_bottoms.dmi'
	icon_state = "thong"
	smallclothes_female_state = "thong_f"
	smallclothes_dwarf_state = "thong_dwarf"
	smallclothes_female_dwarf_state = "thong_dwarf_f"
	specuse = ALL_RACES_LIST

/datum/sprite_accessory/underwear/bikini_bottom
	name = "Bikini Bottom"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_bottoms.dmi'
	icon_state = "bikini_bottom"
	smallclothes_female_state = "bikini_bottom_f"
	specuse = ALL_RACES_LIST

/datum/sprite_accessory/underwear/braies
	name = "Braies"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_bottoms.dmi'
	icon_state = "braies"
	smallclothes_female_state = "braies_f"
	specuse = ALL_RACES_LIST

/datum/sprite_accessory/undershirt
	use_static = FALSE
	color_key_name = "Torso Underwear"
	default_colors = list("#ffffff")
	smallclothes_covers_torso = TRUE
	smallclothes_taur_compatible = TRUE

/datum/sprite_accessory/undershirt/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/mob/living/carbon/human/human = owner
	return istype(human) ? smallclothes_state(human) : icon_state

/datum/sprite_accessory/undershirt/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/mob/living/carbon/human/human = owner
	return istype(human) && human.undershirt == name && smallclothes_is_visible(human)

/datum/sprite_accessory/undershirt/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/mob/living/carbon/human/human = owner
	if(istype(human))
		smallclothes_adjust_appearance(appearance_list, bodypart, human)

/datum/sprite_accessory/undershirt/bra
	name = "Bra"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_tops.dmi'
	icon_state = "bra"
	smallclothes_female_state = "bra_f"
	smallclothes_dwarf_state = "bra_dwarf"
	smallclothes_female_dwarf_state = "bra_f_dwarf"

/datum/sprite_accessory/undershirt/bikini_top
	name = "Bikini Top"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_tops.dmi'
	icon_state = "bikini_top"

/datum/sprite_accessory/undershirt/bikini_top/smallclothes_state(mob/living/carbon/human/human)
	if(human.gender == FEMALE)
		var/size = smallclothes_breast_size(human, 6)
		if(size == 2)
			size = 1
		return "bikini_top_f_B[size]"
	return icon_state

/datum/sprite_accessory/undershirt/leotard
	name = "Leotard Top"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_tops.dmi'
	icon_state = "leotard"
	smallclothes_taur_compatible = FALSE
	smallclothes_covers_groin = TRUE

/datum/sprite_accessory/undershirt/leotard/smallclothes_state(mob/living/carbon/human/human)
	if(human.gender == FEMALE)
		return "leotard_f_B[smallclothes_breast_size(human, 6)]"
	return icon_state

/datum/sprite_accessory/undershirt/athletic_leotard
	name = "Athletic Leotard Top"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_tops.dmi'
	icon_state = "athletic_leotard"
	smallclothes_female_state = "athletic_leotard_f"
	smallclothes_taur_compatible = FALSE
	smallclothes_covers_groin = TRUE

/datum/sprite_accessory/undershirt/fullbody
	name = "Full-Body Suit"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_tops.dmi'
	icon_state = "full"
	smallclothes_female_state = "full_f"
	smallclothes_dwarf_state = "full_dwarf"
	smallclothes_female_dwarf_state = "full_f_dwarf"
	smallclothes_female_extra_state = "full_f_boob"
	smallclothes_female_dwarf_extra_state = "full_f_dwarf_boob"
	smallclothes_taur_compatible = FALSE
	smallclothes_covers_groin = TRUE
	smallclothes_covers_legs = TRUE

/datum/sprite_accessory/undershirt/sheer
	name = "Sheer Body"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_tops.dmi'
	icon_state = "solid"
	smallclothes_female_state = "solid_f"
	smallclothes_dwarf_state = "solid_dwarf"
	smallclothes_female_dwarf_state = "solid_f_dwarf"
	smallclothes_female_extra_state = "solid_f_boob"
	smallclothes_female_dwarf_extra_state = "solid_f_dwarf_boob"

/datum/sprite_accessory/undershirt/sheer_half
	name = "Sheer Half-Body"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_tops.dmi'
	icon_state = "solid-half"
	smallclothes_female_state = "solid-half_f"
	smallclothes_dwarf_state = "solid-half_dwarf"
	smallclothes_female_dwarf_state = "solid-half_f_dwarf"
	smallclothes_female_extra_state = "solid-half_f_boob"
	smallclothes_female_dwarf_extra_state = "solid-half_f_dwarf_boob"

/datum/sprite_accessory/undershirt/silk
	name = "Silk Body"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_tops.dmi'
	icon_state = "silk"
	smallclothes_female_state = "silk_f"
	smallclothes_dwarf_state = "silk_dwarf"
	smallclothes_female_dwarf_state = "silk_f_dwarf"
	smallclothes_female_extra_state = "silk_f_boob"
	smallclothes_female_dwarf_extra_state = "silk_f_dwarf_boob"

/datum/sprite_accessory/undershirt/silk_half
	name = "Silk Half-Body"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_tops.dmi'
	icon_state = "silk-half"
	smallclothes_female_state = "silk-half_f"
	smallclothes_dwarf_state = "silk-half_dwarf"
	smallclothes_female_dwarf_state = "silk-half_f_dwarf"
	smallclothes_female_extra_state = "silk-half_f_boob"
	smallclothes_female_dwarf_extra_state = "silk-half_f_dwarf_boob"

/datum/sprite_accessory/undershirt/mesh
	name = "Mesh Body"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_tops.dmi'
	icon_state = "mesh"
	smallclothes_female_state = "mesh_f"
	smallclothes_dwarf_state = "mesh_dwarf"
	smallclothes_female_dwarf_state = "mesh_f_dwarf"
	smallclothes_female_extra_state = "mesh_f_boob"
	smallclothes_female_dwarf_extra_state = "mesh_f_dwarf_boob"

/datum/sprite_accessory/undershirt/mesh_half
	name = "Mesh Half-Body"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_tops.dmi'
	icon_state = "mesh-half"
	smallclothes_female_state = "mesh-half_f"
	smallclothes_dwarf_state = "mesh-half_dwarf"
	smallclothes_female_dwarf_state = "mesh-half_f_dwarf"
	smallclothes_female_extra_state = "mesh-half_f_boob"
	smallclothes_female_dwarf_extra_state = "mesh-half_f_dwarf_boob"

/datum/sprite_accessory/undershirt/net
	name = "Net Body"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_tops.dmi'
	icon_state = "net"
	smallclothes_female_state = "net_f"
	smallclothes_dwarf_state = "net_dwarf"
	smallclothes_female_dwarf_state = "net_f_dwarf"
	smallclothes_female_extra_state = "net_f_boob"
	smallclothes_female_dwarf_extra_state = "net_f_dwarf_boob"

/datum/sprite_accessory/undershirt/net_half
	name = "Net Half-Body"
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_tops.dmi'
	icon_state = "net-half"
	smallclothes_female_state = "net-half_f"
	smallclothes_dwarf_state = "net-half_dwarf"
	smallclothes_female_dwarf_state = "net-half_f_dwarf"
	smallclothes_female_extra_state = "net-half_f_boob"
	smallclothes_female_dwarf_extra_state = "net-half_f_dwarf_boob"

/datum/sprite_accessory/socks
	icon = 'modular_abel/erp/icons/character_setup/smallclothes_legwear.dmi'
	use_static = FALSE
	color_key_name = "Legwear"
	default_colors = list("#ffffff")
	smallclothes_covers_legs = TRUE

/datum/sprite_accessory/socks/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/mob/living/carbon/human/human = owner
	return istype(human) ? smallclothes_state(human) : icon_state

/datum/sprite_accessory/socks/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/mob/living/carbon/human/human = owner
	return istype(human) && human.socks == name && smallclothes_is_visible(human)

/datum/sprite_accessory/socks/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/mob/living/carbon/human/human = owner
	if(istype(human))
		smallclothes_adjust_appearance(appearance_list, bodypart, human)

/datum/sprite_accessory/socks/nude
	name = "Nude"
	icon_state = null

/datum/sprite_accessory/socks/stockings
	name = "Stockings"
	icon_state = "stockings"
	smallclothes_female_state = "stockings_f"
	smallclothes_dwarf_state = "stockings_dwarf"
	smallclothes_female_dwarf_state = "stockings_f_dwarf"

/datum/sprite_accessory/socks/silk
	name = "Silk Stockings"
	icon_state = "silk"
	smallclothes_female_state = "silk_f"
	smallclothes_dwarf_state = "silk_dwarf"
	smallclothes_female_dwarf_state = "silk_f_dwarf"

/datum/sprite_accessory/socks/fishnet
	name = "Fishnet Stockings"
	icon_state = "fishnet"
	smallclothes_female_state = "fishnet_f"
	smallclothes_dwarf_state = "fishnet_dwarf"
	smallclothes_female_dwarf_state = "fishnet_f_dwarf"

/datum/sprite_accessory/socks/gartered
	name = "Gartered Stockings"
	icon_state = "stockings_wg"
	smallclothes_female_state = "stockings_wg_f"
	smallclothes_dwarf_state = "stockings_wg_dwarf"
	smallclothes_female_dwarf_state = "stockings_wg_f_dwarf"

/datum/sprite_accessory/socks/gartered_silk
	name = "Gartered Silk Stockings"
	icon_state = "silk_wg"
	smallclothes_female_state = "silk_wg_f"
	smallclothes_dwarf_state = "silk_wg_dwarf"
	smallclothes_female_dwarf_state = "silk_wg_f_dwarf"

/datum/sprite_accessory/socks/sir
	name = "Sir Stockings"
	icon_state = "stockings_sir"
	smallclothes_female_state = "stockings_sir_f"
	smallclothes_dwarf_state = "stockings_sir_dwarf"
	smallclothes_female_dwarf_state = "stockings_sir_f_dwarf"

/datum/sprite_accessory/socks/thigh_high
	name = "Thigh-High Stockings"
	icon_state = "thighs"
	smallclothes_female_state = "thighs_f"
	smallclothes_dwarf_state = "thighs_dwarf"
	smallclothes_female_dwarf_state = "thighs_f_dwarf"

/datum/sprite_accessory/socks/thigh_high_silk
	name = "Silk Thigh-High Stockings"
	icon_state = "silk_thighs"
	smallclothes_female_state = "silk_thighs_f"
	smallclothes_dwarf_state = "silk_thighs_dwarf"
	smallclothes_female_dwarf_state = "silk_thighs_f_dwarf"

/datum/sprite_accessory/socks/thigh_high_fishnet
	name = "Fishnet Thigh-High Stockings"
	icon_state = "fishnet_thighs"
	smallclothes_female_state = "fishnet_thighs_f"
	smallclothes_dwarf_state = "fishnet_thighs_dwarf"
	smallclothes_female_dwarf_state = "fishnet_thighs_f_dwarf"

/datum/sprite_accessory/socks/thigh_high_closed
	name = "Closed Thigh-High Stockings"
	icon_state = "thighs_cl"
	smallclothes_female_state = "thighs_cl_f"
	smallclothes_dwarf_state = "thighs_cl_dwarf"
	smallclothes_female_dwarf_state = "thighs_cl_f_dwarf"

/datum/sprite_accessory/socks/priestess
	name = "Priestess Stockings"
	icon_state = "priestess"
	smallclothes_female_state = "priestess_f"
	smallclothes_dwarf_state = "priestess_dwarf"
	smallclothes_female_dwarf_state = "priestess_f_dwarf"

/datum/sprite_accessory/socks/mesh_low
	name = "Low Mesh Stockings"
	icon_state = "stockings_mesh_low"
	smallclothes_female_state = "stockings_mesh_low_f"
	smallclothes_dwarf_state = "stockings_mesh_low_dwarf"
	smallclothes_female_dwarf_state = "stockings_mesh_low_f_dwarf"

/datum/sprite_accessory/socks/mesh_closed
	name = "Closed Mesh Stockings"
	icon_state = "stockings_mesh_cl"
	smallclothes_female_state = "stockings_mesh_cl_f"
	smallclothes_dwarf_state = "stockings_mesh_cl_dwarf"
	smallclothes_female_dwarf_state = "stockings_mesh_cl_f_dwarf"
