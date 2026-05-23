# System Map

Generated on 2026-05-23. Last validated 2026-05-23. Use this file as the fast index of gameplay and infrastructure systems before opening source files.

## Repository Hotspots

- `code/modules` largest slices by DM file count: `mob (342)`, `spells (196)`, `crafting (169)`, `antagonists (107)`, `clothing (95)`, `mapping (82)`, `admin (79)`, `client (66)`.
- `code/datums` largest slices by DM file count: `ai (217)`, `components (186)`, `sex (96)`, `rts (87)`, `runeword (43)`, `chimeric_organs (42)`, `elements (32)`, `status_effects (23)`.
- `modular_rmh/code/modules` largest slices: `jobs (157 DM files)`, `mob (22)`, `spells (33)`, `clothing (49)`.
- `modular_rmh/code/datums` focuses on `religion (6)`, `status_effects (3)`, `stress (2)`, `ai (4)`, plus `character_flaw`, `reflection`, and standalone `sexcon` and `components`.

**Type path counts as of 2026-05-23 (compiled-include extraction from `vanderlin.dme`; explicit type declarations only):**

| Type root | Count |
|---|---|
| `/datum` | 13009 |
| `/obj` | 6918 |
| `/mob` | 642 |
| `/atom` | 640 |
| `/area` | 469 |
| `/turf` | 410 |
| `/particles` | 31 |
| `/image` | 3 |
| `/mutable_appearance` | 3 |
| `/world` | 1 |

Note: the regenerated `ai_navigation/type_tree.md` also synthesized `414` missing ancestor nodes to keep inheritance readable. Section-level counts below still use targeted grep/file-slice estimates when that gives a more useful branch-specific picture than a root-only total.
- `modular_rmh/modular` standalone packs include `piercing`, `selectable_moanpacks`, `resurrection_rune`, `fluids`, `comfy`, `ceramics`, `loot`, and helpers.

## Major Systems

### Master Controller and Round Flow

- Main type root(s): `/datum/controller/subsystem`
- Approximate path count under the root(s): `129` subsystem macro declarations
- Primary directories: `code/world.dm`, `code/controllers/**`
- Main controllers/subsystems: `Master`, `SSticker`, `SSatoms`, `SStimer`
- Notes: `/world` boots the game; `Master` discovers subsystem subtypes, sorts by `init_order`, and drives runlevels/tick budgets.

### DCS Components and Elements

- Main type root(s): `/datum/component`, `/datum/element`
- Approximate path count under the root(s): ~`658` component paths, ~`100` element paths
- Primary directories: `code/datums/components/**`, `code/datums/elements/**`, `code/__DEFINES/dcs/**`, `code/__DEFINES/components.dm`
- Main controllers/subsystems: `SSdcs`
- Notes: Main composition/event system. `RegisterSignal(` appears at ~`1209` call sites, `SEND_SIGNAL(` at `991`, `UnregisterSignal(` at `668`. Many combat and item signals live in `code/__DEFINES/components.dm`, not the DCS subfolder.

### Antagonists and Hostile Role Systems

- Main type root(s): `/datum/antagonist`
- Approximate path count under the root(s): ~`119`
- Primary directories: `code/modules/antagonists/**`, `code/modules/events/antagonist/**`, `code/datums/migrants/waves/antagonist/**`
- Main controllers/subsystems: `SSgamemode`, `SSevents`
- Notes: Direct antagonist datums coexist with storyteller-driven antagonist events and antag migrant waves.

### Storytellers, Round Events, and Omen Tracks

- Main type root(s): `/datum/storyteller`, `/datum/round_event_control`, `/datum/round_event`, `/datum/event_group`
- Approximate path count under the root(s): `15` storyteller paths plus the event/event-group trees
- Primary directories: `code/datums/storytellers/**`, `code/datums/event_groups/**`, `code/modules/events/**`
- Main controllers/subsystems: `SSgamemode`, `SSevents`, `SSticker`
- Notes: Storytellers buy/select `round_event_control` instances; event groups provide cooldown/track grouping; antagonist events bridge directly into role systems.

### Status Effects, Actions, and Spell Trees

- Main type root(s): `/datum/status_effect`, `/datum/action`
- Approximate path count under the root(s): ~`830` status-effect paths, ~`1115` action paths
- Primary directories: `code/datums/status_effects/**`, `code/modules/spells/**`, `modular_rmh/code/modules/spells/**`, `modular_rmh/code/datums/status_effects/**`
- Main controllers/subsystems: `SSstatusprocess`, `SSmagic`, `SSskills`
- Notes: `apply_status_effect(...)` appears at `345` call sites across combat, spells, liquids, quirks, wounds, and modular packs.

### AI Controllers and Behavior Trees

- Main type root(s): `/datum/ai_controller`, `/datum/ai_behavior`
- Approximate path count under the root(s): ~`91` AI controller paths, ~`555` AI behavior paths
- Primary directories: `code/datums/ai/**`, `modular_rmh/code/datums/ai/**` (4 files), `modular_rmh/code/modules/mob/**`
- Main controllers/subsystems: `SSai_controllers`, `SSai_idle_controllers`, `SSai_behaviors`, `SSai_movement`, `SSidle_ai_behaviors`, `SSbasic_avoidance`, `SSaggro`
- Notes: AI is split into controllers, behaviors, planning subtrees, movement datums, and dedicated processing loops.

### Mobs, Jobs, Migrants, and Character Lifecycle

- Main type root(s): `/mob`, `/datum/migrant_wave`, `/datum/migrant_role`
- Approximate path count under the root(s): `/mob` has ~`2278` grep-visible paths (includes all subtype levels); migrant wave types are centered in `code/datums/migrants/**`
- Primary directories: `code/modules/mob/**`, `code/modules/jobs/**`, `code/datums/migrants/**`, `modular_rmh/code/modules/jobs/**`, `modular_rmh/code/modules/mob/**`
- Main controllers/subsystems: `SSjob`, `SSmobs`, `SSmigrants`, `SSrole_class_handler`
- Notes: Core player/NPC logic lives in `mob/`; jobs and migrant waves define spawn-time role structure; RMH adds a large parallel job layer.

### RTS / Strategy Layer

- Main type root(s): `/datum/work_order`, `/datum/building_datum`
- Approximate path count under the root(s): the `code/datums/rts/**` slice contains `87` DM files
- Primary directories: `code/datums/rts/**`
- Main controllers/subsystems: `SSstrategy_master`
- Notes: Standalone strategy subsystem with work orders, building datums, worker minds, templates, and controller UI.

### Economy, Property, Merchants, and World Factions

- Main type root(s): `/datum/nation`, `/datum/world_faction`
- Approximate path count under the root(s): `nation` and `world_factions` are smaller trees; runtime ownership is subsystem-heavy
- Primary directories: `code/modules/economy/**`, `code/controllers/subsystem/economy.dm`, `code/controllers/subsystem/treasury.dm`, `code/controllers/subsystem/property_management.dm`, `code/datums/world_factions/**`
- Main controllers/subsystems: `SSeconomy`, `SStreasury`, `SShousing`, `SSmerchant`
- Notes: Money/accounting, estate income, housing, trader flows, and factional world state are split across controllers and datums.

### Questing, Contracts, and Objective Tracking

- Main type root(s): `/datum/quest`, `/obj/item/paper/scroll/quest`, `/obj/item/quest_compass`, `/obj/structure/fake_machine/contractledger`
- Approximate path count under the root(s): the core questing slice currently spans `15` DM files under `code/modules/questing/**`
- Primary directories: `code/modules/questing/**`, `tgui/packages/tgui/interfaces/ContractLedger.tsx`, `tgui/packages/tgui/interfaces/ContractLedgerRu.tsx`, `tgui/packages/tgui/interfaces/ContractLedgerView.tsx`, `tgui/packages/tgui/interfaces/ContractLedger.i18n.en.ts`, `tgui/packages/tgui/interfaces/ContractLedger.i18n.ru.ts`, `modular_rmh/code/modules/client/preferred_language.dm`, `code/__DEFINES/quests.dm`, `code/modules/antagonists/villain/harlequinn/bounty.dm`
- Main controllers/subsystems: `SSprocessing`, `SStreasury`, `SSmapping`
- Notes: Contracts are issued and turned in through the ledger, objectives live on `/datum/quest` subtypes, the scroll is the player-facing contract record, and the compass is the live tracking surface. The ledger now opens separate EN/RU TGUI interfaces selected from `client.preferred_ui_language`, which is changed through the modular OOC verb in `modular_rmh/code/modules/client/preferred_language.dm`. Merchant/guild job gating lives in the modular RMH jobs branch.

### Crafting, Materials, Runewords, Farming, Fishing

- Main type root(s): `/datum/material`, `/datum/runeword`
- Approximate path count under the root(s): `runeword` alone spans `43` files in `code/datums/runeword/**`; crafting is concentrated in `code/modules/crafting/**`
- Primary directories: `code/modules/crafting/**`, `code/datums/materials/**`, `code/datums/quality/**`, `code/datums/runeword/**`, `code/modules/farming/**`, `code/modules/fishing/**`
- Main controllers/subsystems: `SSskills`, `SSfishing`, `SSanvil`, `SSenchantment`
- Notes: Progression logic concentrates in crafting/material datums plus module-sliced recipes and minigames.

### Skills, Dreams, and Experience

- Main type root(s): `/datum/attribute/skill` (legacy `/datum/skill` aliases still resolve)
- Approximate path count under the root(s): split across `combat`, `craft`, `labor`, `magic`, `misc` skill families
- Primary directories: `code/datums/attributes/attributes/skills/**`, `code/datums/attributes/__holder.dm`, `code/datums/attributes/__legacy.dm`
- Main controllers/subsystems: `SSskills`
- Notes: Skills are attribute-backed progression datums with XP thresholds, dream unlock costs, and level-gated effects. Mobs store them through `mob.attributes` (`/datum/attribute_holder`), while legacy `/datum/skill` paths and rank helpers remain as compatibility shims. Job skill grants are in `modular_rmh/code/modules/jobs/**`. No per-tick processing — XP changes are event-driven via signal hooks.

### Questing and Contracts

- Main type root(s): `/datum/quest`, `/datum/component/quest_object`
- Approximate path count under the root(s): small tree — courier, retrieval, kill quest subtypes plus contract ledger structure
- Primary directories: `code/modules/questing/**`
- Main controllers/subsystems: `SSdcs` (quest_object is a component; signal-driven)
- Notes: Quests are `/datum/quest` instances issued via the contract ledger (`/obj/structure/fake_machine/contractledger`). Quest targets get a `quest_object` component attached which hooks `COMSIG_MOB_DEATH` and examine signals. No dedicated subsystem — lifecycle is player-driven.

### Combat Intents and Clash System

- Main type root(s): `/datum/special_intent`
- Approximate path count under the root(s): multiple AOE intent patterns plus clash status effects in `code/modules/combat/clash/**`
- Primary directories: `code/modules/combat/**`
- Main controllers/subsystems: `SSdcs`, combat chain (`code/_onclick/item_attack.dm`)
- Notes: `special_intent` provides AOE weapon abilities with tile coordinate patterns, pre/post sounds, and stamina costs. The clash system (`process_clash`) lives on `/mob/living` and resolves guard/riposte/disarm outcomes. Integrates into the standard hit chain — see `ai_navigation/combat_signal_map.md` for signal hooks.

### Culture and Character Background

- Main type root(s): `/datum/culture`
- Approximate path count under the root(s): small tree — `universal` and `species`-gated subtypes
- Primary directories: `code/datums/culture/**`
- Main controllers/subsystems: none — loaded at spawn via `job/after_spawn()`
- Notes: Cultural background is a character-pref datum that contributes examine strings and spawn-time effects. Species-gated cultures check `pref_species` at selection. No runtime processing after spawn.

### Cooking and Food

- Main type root(s): `/obj/item/reagent_containers/food`
- Approximate path count under the root(s): concentrated in `code/modules/cooking/**` and `code/modules/food_and_drinks/**`
- Primary directories: `code/modules/cooking/**`, `code/modules/food_and_drinks/**`, `code/datums/brewing_recipes/**`
- Main controllers/subsystems: `SSskills`, `SSanvil` (slapcrafting chain)
- Notes: Cooking uses slapcrafting rather than menu-based recipes. Raw food base (`foodbase`) applies a debuff status effect when eaten uncooked. Teas and brews are in `Teas_and_Brews.dm`. Reagent interactions route through `code/modules/reagents/**`.

### Rage System

- Main type root(s): `/datum/rage`
- Approximate path count under the root(s): base datum plus `werewolf_rage` antag subtype
- Primary directories: `code/datums/rage/**`
- Main controllers/subsystems: `SSdcs` (signal-driven via `COMSIG_HUMAN_LIFE`; no dedicated SS*)
- Notes: Rage is a holder datum attached to a mob via `grant_to_holder()`. Ticks on `COMSIG_HUMAN_LIFE`, sends `COMSIG_RAGE_CHANGED`, `COMSIG_RAGE_BOTTOMED`, `COMSIG_RAGE_OVERRAGE`. Supports threshold-based ability tiers. HUD uses a bloodpool element. Werewolf antag is the primary real user — see `code/datums/rage/werewolf_rage.dm`.

### Faith, Gods, Mana, Quirks, Wounds

- Main type root(s): `/datum/faith`, `/datum/mana`, `/datum/quirk`, `/datum/wound`
- Approximate path count under the root(s): `quirk` has ~`282` paths and `wound` has ~`142`; faith/gods/mana are smaller but central
- Primary directories: `code/datums/faith/**`, `code/datums/gods/**`, `code/datums/mana/**`, `code/datums/quirks/**`, `code/datums/wounds/**`
- Main controllers/subsystems: `SSskills`, `SSstatusprocess`, `SSmood`
- Notes: Character state is distributed across faith/devotion, mana, quirks, wounds, stress, rage, and organ systems.

### Mapping, Dungeons, Voyage, and Procedural Generation

- Main type root(s): `/datum/map_template`
- Approximate path count under the root(s): map templates are spread across `_maps/**` and several mapgen slices
- Primary directories: `_maps/**`, `code/modules/mapping/**`, `code/modules/procedural_mapping/**`, `modular_rmh/code/game/modules/mapgen/**`
- Main controllers/subsystems: `SSmapping`, `SSpocket_dimensions`, `SSminor_mapping`, `SSdungeon_generator`, `SSterrain_generation`, `SSpathfinder`
- Notes: Static DMM templates, procedural mapgen, dungeon placement, pocket-dimension reservations, and voyage terrain generation coexist.

### Pocket Dimensions and Spatial Reservations

- Main type root(s): `/datum/map_template/pocket`, `/datum/pocket_dimension`
- Approximate path count under the root(s): compact template-and-instance tree centered in `code/modules/mapping/pocket_dimensions.dm`
- Primary directories: `code/modules/mapping/pocket_dimensions.dm`, `code/controllers/subsystem/pocket_dimensions.dm`, `code/controllers/subsystem/mapping.dm`, `code/modules/admin/verbs/pocket_dimensions.dm`
- Main controllers/subsystems: `SSpocket_dimensions`, `SSmapping`, `SSlighting`
- Notes: `SSpocket_dimensions` rebuilds pocket template caches from `SSmapping.map_templates`, manages instance creation/wake/hibernate/collapse lifecycle, and relies on `SSmapping.RequestPocketBlockReservation(...)` plus lighting refreshes during activation. Admin debugging tools live under `code/modules/admin/verbs/pocket_dimensions.dm`.

### World Simulation: Liquids, Weather, Fire, Overlays

- Main type root(s): `/datum/liquid`, `/datum/weather_effect`
- Approximate path count under the root(s): environment logic is spread across datums plus subsystem-owned runtime state
- Primary directories: `code/datums/liquids/**`, `code/datums/particle_weathers/**`, `code/controllers/subsystem/liquids.dm`, `code/controllers/subsystem/particle_weather*.dm`
- Main controllers/subsystems: `SSliquids`, `SSParticleWeather`, `SSoutdoor_effects`, `SSfire_burning`, `SSfire_spread`, `SSlighting`, `SSvis_overlays`
- Notes: High-frequency simulation cluster for environmental state and visual side effects.

### UI and Frontend Stack

- Main type root(s): `/datum/ui`, `/datum/tgui`
- Approximate path count under the root(s): UI types are spread between DM and the separate `tgui` TS workspace
- Primary directories: `code/modules/tgui/**`, `code/modules/visual_ui/**`, `interface/**`, `tgui/packages/**`, `html/**`
- Main controllers/subsystems: `SStgui`, `SSvisual_ui`, `SSchat`
- Notes: DM-side browser UIs coexist with TypeScript `tgui` packages and custom BYOND interface verbs/menus.

### RMH Modular Extension Layer

- Main type root(s): multiple existing roots extended late in the include graph
- Approximate path count under the root(s): RMH contributes heavily to jobs, clothing, spells, mobs, religion, status effects, and standalone modular packs
- Primary directories: `modular_rmh/code/**`, `modular_rmh/modular/**`
- Main controllers/subsystems: uses the same core `SS*` singletons
- Notes: Loaded late in the modular include cluster in `vanderlin.dme`, with small `modular_alizeria` and `modular_ratwood` slices landing immediately before RMH. Treat RMH as the dominant overlay layer rather than a separate architecture.

## High-Level Dependency Awareness

- Components/elements are the main cross-cutting composition mechanism: `AddComponent(...)` appears at ~`424` call sites, and most signal-driven wiring routes through `SSdcs`, `code/__DEFINES/dcs/**`, and `code/__DEFINES/components.dm`.
- Status effects are a core gameplay contract: `apply_status_effect(...)` appears at ~`346` call sites across combat, spells, liquids, quirks, wounds, and modular packs.
- Event-driven communication is pervasive: `RegisterSignal` appears at ~`1209` call sites, `SEND_SIGNAL` at ~`991`, so many systems are decoupled by signals instead of direct proc calls.
- Important: combat and item signals (`COMSIG_ITEM_*`, `COMSIG_HUMAN_*`, `COMSIG_PROJECTILE_*`, `COMSIG_COMBAT_*`) live in `code/__DEFINES/components.dm`, not the DCS subfolder.
- Mob creation is relatively centralized: only `52` direct `new /mob` call sites were detected, while round setup, migrants, event controllers, and spawners handle most mob lifecycle orchestration.
- Map and worldgen systems are layered: static `_maps` templates feed mapping helpers, while `SSmapping`, `SSpocket_dimensions`, `SSminor_mapping`, `SSdungeon_generator`, and `SSterrain_generation` own runtime placement/generation passes.
- The modular RMH layer does not introduce a second runtime architecture; it extends existing roots and reuses the same `SS*` infrastructure, so always check `modular_rmh` after locating the core path in `code/`.
