/// Per-map removal of advanced classes.
///
/// The stock per-map job config (/datum/map_adjustment) only reaches /datum/job entries: job_change()
/// resolves every `blacklist` entry through SSjob.GetJobType(), and advanced classes are never
/// registered as occupations there, so listing one would fall through to change_job_position() and
/// CRASH the job setup. Advanced classes therefore need their own list.
///
/// The gate lives in check_requirements() because that is the single funnel every path to an advanced
/// class goes through - the normal category roll, forced class additions, and the triumph "pick any
/// class" buy - so a blacklisted class cannot be reached by any of them.
///
/// Keep map-specific content here rather than on the class itself: a class edited to know about one
/// map leaks that map's rules into every other map that uses it.
/datum/map_adjustment/var/list/advclass_blacklist

/datum/job/advclass/check_requirements(mob/living/carbon/human/to_check, triumph_restriction_lift = FALSE)
	var/datum/map_adjustment/adjustment = SSmapping.map_adjustment
	if(adjustment && (type in adjustment.advclass_blacklist))
		return FALSE
	return ..()
