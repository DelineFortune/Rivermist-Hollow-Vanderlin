/mob/living/carbon
	blood_volume = BLOOD_VOLUME_NORMAL
	gender = MALE
	base_intents = list(INTENT_HELP, INTENT_HARM)
	hud_possible = list(ANTAG_HUD)
	has_limbs = 1
	held_items = list(null, null)
	num_legs = 0 //Populated on init through list/bodyparts
	usable_legs = 0 //Populated on init through list/bodyparts
	num_hands = 0 //Populated on init through list/bodyparts
	usable_hands = 0 //Populated on init through list/bodyparts
	var/silent = FALSE 		//Can't talk. Value goes down every life proc. //NOTE TO FUTURE CODERS: DO NOT INITIALIZE NUMERICAL VARS AS NULL OR I WILL MURDER YOU.
	var/dreaming = 0 //How many dream images we have left to send

	var/disgust = 0

	/// Speech modifiers
	var/list/datum/speech_modifier/speech_modifiers

	/// List of carry_weight modifiers applying to this mob
	var/list/carry_weight_modification //Lazy list, see carry_weight_modifier.dm
	/// List of carry_weight modifiers ignored by this mob. List -> List (id) -> List (sources)
	var/list/carry_weight_mod_immunities //Lazy list, see carry_weight_modifier.dm

//inventory slots
	var/obj/item/backr = null
	var/obj/item/backl = null
	var/obj/item/clothing/face/wear_mask = null
	var/obj/item/mouth = null
	var/obj/item/clothing/neck/wear_neck = null
	var/obj/item/tank/internal = null
	var/obj/item/clothing/head = null


	var/obj/item/clothing/gloves = null //only used by humans
	var/obj/item/clothing/shoes = null //only used by humans.

	var/name_override //For temporary visible name changes
	var/honorary // A title prepended to the beginning of the name
	var/honorary_suffix // A title appended to the end of the name


	var/obj/item/clothing/undies/underwear = null	//Underwear item
	var/obj/item/clothing/legwears/legwear_socks = null	//legwear item
	var/obj/item/clothing/undershirt = null	//undershirt item
	var/obj/item/clothing/bra/bra = null	//bra item
	var/obj/item/clothing/garter/garter = null	//garter item
	var/obj/item/clothing/choker = null	//choker item
	var/obj/item/earring_l = null	//earring item
	var/obj/item/earring_r = null	//earring item
	var/obj/item/clothing/armsleeves = null	//armsleeve item

	var/datum/dna/dna = null//Carbon
	var/datum/mind/last_mind = null //last mind to control this mob, for blood-based cloning

	var/failed_last_breath = 0 //This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.

	var/co2overloadtime = null
	var/obj/item/reagent_containers/food/snacks/meat/steak/type_of_meat = /obj/item/reagent_containers/food/snacks/meat/steak

	var/gib_type = /obj/effect/decal/cleanable/blood/gibs

	var/rotate_on_lying = 1

	var/tinttotal = 0	// Total level of visualy impairing items

	var/list/bodyparts = list(/obj/item/bodypart/chest, /obj/item/bodypart/head, /obj/item/bodypart/l_arm,
					/obj/item/bodypart/r_arm, /obj/item/bodypart/r_leg, /obj/item/bodypart/l_leg, /obj/item/bodypart/mouth)
	//Gets filled up in create_bodyparts()

	var/list/hand_bodyparts = list() //a collection of arms (or actually whatever the fug /bodyparts you monsters use to wreck my systems)

	var/icon_render_key = ""
	var/static/list/limb_icon_cache = list()

	//halucination vars
	var/image/halimage
	var/image/halbody
	var/obj/halitem
	var/hal_screwyhud = SCREWYHUD_NONE
	var/next_hallucination = 0
	var/cpr_time = 1 //CPR cooldown.
	var/damageoverlaytemp = 0

	var/drunkenness = 0 //Overall drunkenness - check handle_alcohol() in life.dm for effects

	var/tiredness = 0
	var/next_smell = 0

	var/advsetup = 0
	/// Pulse is shared across all hearts and circulation effects.
	var/pulse = PULSE_NORM
	/// How long an external heart pump counts for circulation.
	var/heart_pump_duration = 5 SECONDS
	/// CPR/blood circulation pump record: time key mapped to effectiveness.
	var/list/recent_heart_pump
	/// Current immune system strength.
	var/immunity = 100
	var/default_immunity = 100

	var/datum/party/current_party
	var/list/party_hud_elements = list()

	/// To reduce processing, this list is used to associate body zone with all organs inside that zone
	var/list/organs_by_zone = list()

	/// A collection of organs (eyes) used to see
	var/list/eye_organs = list()

	/// Total sum of organ and bodypart blood requirement
	var/total_blood_req = DEFAULT_TOTAL_BLOOD_REQ
	/// Total sum of organ and bodypart oxygen requirement
	var/total_oxygen_req = DEFAULT_TOTAL_OXYGEN_REQ
	/// Total sum of organ and bodypart nutriment requirement
	var/total_nutriment_req = DEFAULT_TOTAL_NUTRIMENT_REQ
	/// Total sum of organ and bodypart hydration requirement
	var/total_hydration_req  = DEFAULT_TOTAL_HYDRATION_REQ

	// ~INJURY PENALTIES
	/// Timer for injury penalty, should reset if we take more damage
	var/shock_penalty_timer = null
	/// How much our injury penalty currently affects our DX and IQ
	var/shock_penalty = 0
	COOLDOWN_DECLARE(adrenaline_burst)

	/// All injuries we have accumulated on our body
	var/list/datum/injury/all_injuries
	/// Descriptive string used in combat messages
	var/wound_message = ""

	/// if they get a mana pool
	has_initial_mana_pool = TRUE
