//
// These accept the OLD level values (0-6) and multiply by 10 internally.
// Use these when migrating call sites that still pass old-style values,
// e.g:  blade.adjust_skillrank(/datum/attribute/skill/combat/swords, 3, TRUE)
// becomes: blade.adjust_skillrank(/datum/attribute/skill/combat/swords, 3, TRUE)
// with no change at the call site - the helper does the conversion. it should NOT be used going forward

/**
 * LEGACY: Adjusts a skill by a delta in the old 0-6 scale.
 * Multiplies delta by 10 before applying.
 *
 * Example (unchanged call site):
 *   blade.adjust_skillrank(/datum/attribute/skill/combat/swords, 3, TRUE)
 *   -> internally calls adjust_skill_level(skill, 30, null, TRUE)
 */
/mob/proc/adjust_skillrank(skill_type, amt, silent = FALSE)
	attributes?.adjust_skill_level(legacy_attribute_skill_path(skill_type), amt * 10, null, silent)

/mob/proc/clamped_adjust_skillrank(skill_type, amt, max_or_silent = null, silent = FALSE)
	var/max_level = null
	if(isnum(max_or_silent))
		max_level = max_or_silent * 10
	else if(!isnull(max_or_silent))
		silent = max_or_silent
	attributes?.adjust_skill_level(legacy_attribute_skill_path(skill_type), amt * 10, max_level, silent)

/mob/proc/adjust_skillrank_up_to(skill_type, level, silent = FALSE)
	var/translated_skill = legacy_attribute_skill_path(skill_type)
	if(!translated_skill)
		return
	var/target_level = level * 10
	if(nulltozero(attributes?.raw_attribute_list[translated_skill]) >= target_level)
		return
	attributes?.set_skill_level(translated_skill, target_level, silent)

/mob/proc/set_skillrank(skill_type, level, silent = TRUE)
	attributes?.set_skill_level(legacy_attribute_skill_path(skill_type), level * 10, silent)

/mob/proc/get_skill_level(skill_type)
	var/translated_skill = legacy_attribute_skill_path(skill_type)
	if(!translated_skill)
		return 0
	return nulltozero(attributes?.raw_attribute_list[translated_skill]) / 10

/datum/mind/proc/get_skill_level(skill_type)
	if(current)
		return current.get_skill_level(skill_type)
	return 0
