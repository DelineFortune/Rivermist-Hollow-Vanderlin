# Entrypoints

Generated on 2026-05-23. Use this file before the larger maps when the goal can be matched to a known system quickly.

## Minimal Route

1. Match the task to one row below.
2. Open only the listed directories/files first.
3. Escalate only if needed:
   - symptom-first debugging -> `ai_navigation/debug_routes.md`
   - handoff between systems unclear -> `ai_navigation/system_dependencies.md`
   - execution order/lifecycle unclear -> `ai_navigation/runtime_flow.md`
   - ownership unclear -> `ai_navigation/subsystem_map.md`
   - system unclear -> `ai_navigation/system_map.md`
   - branch/root unclear for a type path -> `ai_navigation/type_index.md`
   - deep inheritance unclear -> `ai_navigation/type_tree.md`
   - architecture/layer question -> `ai_navigation/architecture.md`

## Fast Index

| Task or keyword | Open first | Then check | Runtime owner |
|---|---|---|---|
| `vampire`, `werewolf`, `antag`, `thrall`, `villain` | `code/modules/antagonists/**` | `code/modules/events/antagonist/**`, `code/datums/migrants/waves/antagonist/**`, `modular_rmh/**` | `SSgamemode`, `SSevents` |
| `job`, `role`, `latejoin`, `spawn role`, `migrant`, `class` | `code/modules/jobs/**`, `code/datums/migrants/**` | `modular_rmh/code/modules/jobs/**`, `code/modules/mob/**` | `SSjob`, `SSmigrants`, `SSrole_class_handler` |
| `spell`, `ability`, `action`, `miracle`, `rituos`, `projectile`, `aoe`, `cone`, `touch` | `code/modules/spells/**`, `ai_navigation/spell_signal_map.md` | `code/datums/status_effects/**`, `code/datums/components/**`, `code/datums/elements/**`, `modular_rmh/code/modules/spells/**` | `SSmagic`, `SSstatusprocess`, `SSskills` |
| `combat`, `melee`, `attack`, `hit`, `weapon`, `disarm`, `parry`, `block`, `shield`, `projectile` | `ai_navigation/combat_signal_map.md`, `code/_onclick/item_attack.dm` | `code/_onclick/other_mobs.dm`, `code/modules/projectiles/projectile.dm`, defense/species files, `modular_rmh/**` | `SSdcs`, mob/projectile paths, AI combat listeners |
| `sex`, `lewd`, `arousal`, `erp`, `kink` | `code/datums/sex/**`, `code/datums/components/arousal.dm` | `code/modules/mob/**`, `modular_rmh/code/datums/ai/horny_ai/**`, `modular_rmh/code/game/objects/items/lewd/**`, `ai_navigation/signal_map.md` | `SSobj`, `SSdcs`, mob/chat paths |
| `ai`, `npc`, `behavior`, `controller`, `hostile mob` | `code/datums/ai/**`, `code/modules/mob/**` | `modular_rmh/code/datums/ai/**`, `modular_rmh/code/modules/mob/**` | `SSai_controllers`, `SSai_behaviors`, `SSai_movement` |
| `movement`, `move`, `collision`, `pull`, `buckle`, `throw`, `glide`, `moveloop`, `pathing` | `ai_navigation/movement_signal_map.md`, `code/modules/mob/mob_movement.dm` | `code/modules/mob/living/living_movement.dm`, `code/controllers/subsystem/movement/**`, `modular_rmh/**` | `SSmovement`, `SSdcs`, mob movement paths |
| `quest`, `questing`, `contract`, `bounty`, `courier`, `retrieval`, `scroll`, `compass` | `code/modules/questing/**` | `tgui/packages/tgui/interfaces/ContractLedger.tsx`, `tgui/packages/tgui/interfaces/ContractLedgerRu.tsx`, `tgui/packages/tgui/interfaces/ContractLedgerView.tsx`, `tgui/packages/tgui/interfaces/ContractLedger.i18n.en.ts`, `tgui/packages/tgui/interfaces/ContractLedger.i18n.ru.ts`, `modular_rmh/code/modules/client/preferred_language.dm`, `code/__DEFINES/quests.dm`, `code/modules/antagonists/villain/harlequinn/bounty.dm`, `modular_rmh/code/modules/jobs/**` | `SSprocessing`, `SStreasury`, `SSmapping` |
| `map`, `dungeon`, `voyage`, `worldgen`, `template`, `spawn landmark` | `_maps/**`, `code/modules/mapping/**`, `code/modules/procedural_mapping/**` | `modular_rmh/code/game/modules/mapgen/**`, landmarks/spawners on the affected branch | `SSmapping`, `SSminor_mapping`, `SSdungeon_generator`, `SSterrain_generation` |
| `pocket`, `pocket dimension`, `pocket template`, `spatial reservation`, `hibernate pocket`, `collapse pocket` | `code/modules/mapping/pocket_dimensions.dm`, `code/controllers/subsystem/pocket_dimensions.dm` | `code/controllers/subsystem/mapping.dm`, `code/modules/admin/verbs/pocket_dimensions.dm`, `code/controllers/subsystem/lighting.dm` | `SSpocket_dimensions`, `SSmapping`, `SSlighting` |
| `economy`, `merchant`, `treasury`, `property`, `housing`, `faction` | `code/modules/economy/**` | `code/controllers/subsystem/economy.dm`, `treasury.dm`, `property_management.dm`, `code/datums/world_factions/**` | `SSeconomy`, `SStreasury`, `SShousing`, `SSmerchant` |
| `craft`, `recipe`, `material`, `runeword`, `anvil`, `fishing`, `farming` | `code/modules/crafting/**`, `code/datums/materials/**`, `code/datums/runeword/**` | `code/modules/farming/**`, `code/modules/fishing/**`, `code/datums/quality/**` | `SSskills`, `SSanvil`, `SSfishing`, `SSenchantment` |
| `faith`, `god`, `mana`, `quirk`, `wound`, `stress`, `mood` | `code/datums/faith/**`, `code/datums/gods/**`, `code/datums/mana/**` | `code/datums/quirks/**`, `code/datums/wounds/**`, RMH datums | `SSskills`, `SSstatusprocess`, `SSmood` |
| `skill`, `skill level`, `dream`, `xp`, `experience`, `skill_holder` | `code/datums/attributes/attributes/skills/**`, `code/datums/attributes/__holder.dm`, `code/modules/mob/mob.dm` (`mob.attributes` holder) | `code/datums/attributes/attributes/skills/combat.dm`, `craft.dm`, `labor.dm`, `magic.dm`, `misc.dm`; `code/datums/attributes/__legacy.dm`; RMH job files for skill grants | `SSskills` |
| `quest`, `contract`, `bounty`, `quest_object`, `contractledger` | `code/modules/questing/**` | `code/modules/questing/quests/**`, `code/modules/questing/quest_object.dm`, `code/modules/questing/quest_map_config.dm`, `ai_navigation/signal_map.md` (quest_object uses RegisterSignal) | `SSdcs` (component-driven, no dedicated SS*) |
| `quest map config`, `quest difficulty`, `quest reward modifier`, `quest distance bonus` | `code/modules/questing/quest_map_config.dm` | `code/__DEFINES/quests.dm` (QUEST_MAP_FLAG_*, QUEST_DISTANCE_BONUS_*, QUEST_MAP_DIFFICULTY_*, QUEST_MAP_REWARD_*), `code/modules/ambush/**` | no dedicated SS* — applied at quest generation |
| `quest ambush`, `ambush payload`, `quest_ambush_payload` | `code/modules/questing/quest_ambush_payload.dm` | `code/modules/questing/quest_map_config.dm` (ambush_pools), `code/modules/ambush/**` (ambush_config subtypes), `code/__DEFINES/quests.dm` (QUEST_AMBUSH_*) | no dedicated SS* — component on quest mob, fires on COMSIG_MOB_DEATH |
| `special_intent`, `aoe intent`, `clash`, `riposte`, `guard`, `stamina cost` | `code/modules/combat/**` | `code/modules/combat/special_intents.dm`, `code/modules/combat/clash/**`, `ai_navigation/combat_signal_map.md` | `SSdcs`, combat chain |
| `culture`, `character background`, `species culture`, `on_after_spawn` | `code/datums/culture/**` | `code/datums/culture/species.dm`, `code/datums/culture/universal.dm`; linked from job `after_spawn()` | no dedicated SS* — applied at spawn |
| `cooking`, `food`, `recipe`, `raw food`, `NeuFood`, `brew`, `tea` | `code/modules/cooking/**`, `code/modules/food_and_drinks/**` | `code/modules/cooking/NeuFood.dm`, `code/modules/cooking/cooked/**`, `code/modules/cooking/raw/**`, `code/modules/crafting/**` | `SSanvil`, `SSskills` |
| `rage`, `rage meter`, `rage tier`, `bloodpool`, `werewolf rage` | `code/datums/rage/**` | `code/datums/rage/_base.dm`, `code/datums/rage/werewolf_rage.dm`; ticks via `COMSIG_HUMAN_LIFE`; signals: `COMSIG_RAGE_CHANGED`, `COMSIG_RAGE_BOTTOMED`, `COMSIG_RAGE_OVERRAGE` | no dedicated SS* — signal-driven on mob life tick |
| `greyscale`, `GAGS`, `recolor`, `greyscale_config`, `greyscale_colors`, `sprite layers` | `code/datums/greyscale/**`, `ai_navigation/visuals_guide.md` §GAGS | existing configs in `code/datums/greyscale/greyscale_configs.dm` as reference; JSON configs in `code/datums/greyscale/json_configs/` | `SSgreyscale` |
| `icon smoothing`, `smooth_icon`, `smoothing_flags`, `smoothing_groups`, `SMOOTH_BITMASK`, `bitmask wall`, `tile junction` | `ai_navigation/icon_rendering.md` §Part1, `code/__DEFINES/icon_smoothing.dm` | `code/__HELPERS/icon_smoothing.dm` for proc implementations; `code/controllers/subsystem/icon_smooth.dm` for queue owner | `SSicon_smooth` |
| `iconstate2appearance`, `icon2appearance`, `appearance cache`, `build_appearance_list`, `vis_contents cache`, `SSvis_overlays` | `ai_navigation/icon_rendering.md` §Part2, `code/controllers/subsystem/overlays.dm` | `code/controllers/subsystem/vis_overlays.dm`, `code/__DEFINES/layers.dm` for plane/layer constants | `SSoverlays`, `SSvis_overlays`, `SSdamoverlays` |
| `liquid`, `weather`, `fire`, `overlay`, `lighting` | `code/datums/liquids/**`, `code/datums/particle_weathers/**`, `ai_navigation/visuals_guide.md` | `code/controllers/subsystem/liquids.dm`, `particle_weather*.dm`, fire/overlay subsystems, `ai_navigation/coding_standards.md` §GC if overlay holders are created/destroyed | `SSliquids`, `SSParticleWeather`, `SSfire_burning`, `SSfire_spread`, `SSlighting` |
| `tgui`, `ui`, `browser`, `hud`, `interface` | `code/modules/tgui/**`, `code/modules/visual_ui/**`, `interface/**` | `tgui/packages/**`, `html/**` | `SStgui`, `SSvisual_ui`, `SSchat` |
| `lag`, `runtime`, `processing`, `tick`, `scheduler`, `master`, `startup` | `ai_navigation/subsystem_map.md`, `code/world.dm`, `code/controllers/master.dm`, `code/controllers/subsystem.dm` | `code/controllers/subsystem/**`, `rg` for the relevant `SS*` | `Master`, target `SS*` |
| exact BYOND type path like `/datum/...`, `/mob/...`, `/obj/...` | `ai_navigation/type_index.md` | matching DM branch in `code/**` and `modular_rmh/**`, then `ai_navigation/type_tree.md` if needed | depends on branch |

## Escalation Rules

- If a keyword row matches, do not open `ai_navigation/system_map.md` immediately.
- If the user gives a symptom instead of a feature name, switch to `ai_navigation/debug_routes.md`.
- If the first branch is wrong, switch rows once before doing a broad repository search.
- After locating a core path in `code/`, always check whether `modular_rmh` extends the same branch.
