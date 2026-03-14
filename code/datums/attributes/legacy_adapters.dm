/proc/legacy_attribute_skill_path(skill_type)
	if(isnull(skill_type))
		return null
	if(ispath(skill_type, /datum/attribute/skill))
		return skill_type

	switch(skill_type)
		if(/datum/skill/combat/axes, /datum/skill/combat/maces)
			return /datum/attribute/skill/combat/axesmaces

	var/text_path = "[skill_type]"
	if(!findtext(text_path, "/datum/skill/"))
		return null

	var/path/translated_path = text2path(replacetext(text_path, "/datum/skill/", "/datum/attribute/skill/"))
	if(ispath(translated_path, /datum/attribute/skill))
		return translated_path
	return null

/proc/legacy_attribute_stat_path(stat_key)
	switch(stat_key)
		if(STATKEY_STR)
			return STAT_STRENGTH
		if(STATKEY_PER)
			return STAT_PERCEPTION
		if(STATKEY_INT)
			return STAT_INTELLIGENCE
		if(STATKEY_CON)
			return STAT_CONSTITUTION
		if(STATKEY_END)
			return STAT_ENDURANCE
		if(STATKEY_SPD)
			return STAT_SPEED
		if(STATKEY_LCK)
			return STAT_FORTUNE
	if(ispath(stat_key, STAT))
		return stat_key
	return null

/proc/build_legacy_attribute_sheet(list/legacy_stats = null, list/legacy_skills = null)
	if(!LAZYLEN(legacy_stats) && !LAZYLEN(legacy_skills))
		return null

	var/datum/attribute_holder/sheet/job/generated_sheet = new
	generated_sheet.raw_attribute_list = list()

	if(LAZYLEN(legacy_stats))
		for(var/stat_key in legacy_stats)
			var/stat_path = legacy_attribute_stat_path(stat_key)
			if(!stat_path)
				continue
			generated_sheet.raw_attribute_list[stat_path] = legacy_stats[stat_key]

	if(LAZYLEN(legacy_skills))
		for(var/skill_key in legacy_skills)
			var/skill_path = legacy_attribute_skill_path(skill_key)
			if(!skill_path)
				continue

			var/amount = legacy_skills[skill_key]
			if(islist(amount))
				amount = amount[1]
			if(!isnum(amount))
				continue

			var/translated_amount = amount * 10
			if(skill_path in generated_sheet.raw_attribute_list)
				generated_sheet.raw_attribute_list[skill_path] = max(generated_sheet.raw_attribute_list[skill_path], translated_amount)
			else
				generated_sheet.raw_attribute_list[skill_path] = translated_amount

	generated_sheet.update_attributes()
	return generated_sheet
