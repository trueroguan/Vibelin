/// Every garment defaults to `allowed_race = ALL_RACES_LIST`, a core compile-time define that
/// cannot see the modular races. Left alone, that rejects every piece of clothing a modular race
/// tries to wear - at roundstart the job outfit silently equips nothing but the weapons, which is
/// how a Venardine ends up spawning naked holding a sword and shield.
///
/// The garment a modular race can wear is the one cut for the race it descends from, so each of
/// them names that race here. The check is additive (see is_allowed_clothing_race): a species keeps
/// everything its own id already allowed and merely gains its proxy's wardrobe, so no race loses
/// access to anything it could wear before.
///
/// Deliberately separate from `id_override`, which decides who may play what: registration.dm owns
/// job gating and grants modular races their own class access, and routing that through a proxy
/// would silently narrow it (e.g. Warrior allows RACES_PLAYER_NONEXOTIC, which has no rakshari).
/datum/species/var/clothing_race_proxy

/datum/species/proc/is_allowed_clothing_race(list/allowed_race)
	var/own_id = id_override ? id_override : id
	if(own_id in allowed_race)
		return TRUE
	if(clothing_race_proxy && (clothing_race_proxy in allowed_race))
		return TRUE
	return FALSE

/datum/species/harpy
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/medicator
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/elf/sun
	clothing_race_proxy = SPEC_ID_ELF

/datum/species/tabaxi
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/vulpkanin
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/lupian
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/akula
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/anthromorph
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/lizardfolk
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/dracon
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/moth
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/aura
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/taur_kin
	clothing_race_proxy = SPEC_ID_RAKSHARI

/datum/species/ooze
	clothing_race_proxy = SPEC_ID_HUMEN

/datum/species/harpy/New()
	. = ..()
	organs = organs.Copy()
	organs -= ORGAN_SLOT_TAIL
	customizers = customizers.Copy()
	customizers -= /datum/customizer/organ/tail/harpy
