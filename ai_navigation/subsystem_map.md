# Subsystem Map

Generated on 2026-05-23 from subsystem macro declarations in `code/controllers/subsystem/**`.

- Total subsystem declarations detected: **129**
- Macro family breakdown: AI_CONTROLLER_SUBSYSTEM_DEF=1, MOVEMENT_SUBSYSTEM_DEF=2, PROCESSING_SUBSYSTEM_DEF=30, SUBSYSTEM_DEF=94, TIMER_SUBSYSTEM_DEF=1, VERB_MANAGER_SUBSYSTEM_DEF=1
- Naming rule: macros in `code/__DEFINES/MC.dm` synthesize globals in the form `SS<name>` and the corresponding type path under `/datum/controller/subsystem/...`.

## Category Summary

| Category | Subsystems | Examples |
| --- | ---: | --- |
| AI & movement | 4 | `SSconveyors`, `SSminecarts`, `SSmove_manager`, `SSmovement` |
| Boot, assets & infrastructure | 10 | `SSasset_loading`, `SSassets`, `SSatoms`, `SSban_cache`, `SSblackbox` |
| Gameplay simulation | 58 | `SSachievements`, `SSacid`, `SSadjacent_air`, `SSai_controllers`, `SSai_idle_controllers` |
| Processing loops | 25 | `SSaction_charge`, `SSaggro`, `SSai_behaviors`, `SSai_movement`, `SSanvil` |
| Round flow & player lifecycle | 7 | `SSgamemode`, `SSjob`, `SSlobbymenu`, `SSrole_class_handler`, `SSticker` |
| UI, comms & admin | 10 | `SSchat`, `SScommunications`, `SSdiscord`, `SSinput`, `SSradio` |
| World generation & map state | 15 | `SSdungeon_generator`, `SSfire_burning`, `SSfire_spread`, `SSlighting`, `SSliquids` |

## Quick Lookup

If you already know the `SS*` name, search this file for it directly (`Ctrl+F` or `rg`). The table below is sorted alphabetically within each category.

Category anchors — jump to the relevant block in the Complete Subsystem Index:

| Category | First entry in table |
|---|---|
| AI & movement | `SSconveyors` |
| Boot, assets & infrastructure | `SSasset_loading` |
| Gameplay simulation | `SSachievements` |
| Processing loops | `SSaction_charge` |
| Round flow & player lifecycle | `SSgamemode` |
| UI, comms & admin | `SSchat` |
| World generation & map state | `SSdungeon_generator` |

## Atom Lifecycle (SSatoms)

This is one of the most important patterns in SS13. When in doubt about `Initialize`, `LateInitialize`, or world-start timing — read `code/controllers/subsystem/atoms.dm` first.

### Initialize() return hints

| Hint constant | Effect |
|---|---|
| `INITIALIZE_HINT_NORMAL` | Default. `LateInitialize()` is **never called**. |
| `INITIALIZE_HINT_LATELOAD` | Atom is added to `late_loaders`. `LateInitialize()` is called after **all** map atoms finish `Initialize()`. Use this when you need other map objects (landmarks, spawners, datums) to already exist. |
| `INITIALIZE_HINT_QDEL` | Atom is deleted after `Initialize()`. |

### Rules
- `..()` in `Initialize()` returns `INITIALIZE_HINT_NORMAL` unless the parent explicitly returns something else.
- **Always check what the parent type returns.** Many parents (`fake_machine`, `obj/structure`, etc.) return `INITIALIZE_HINT_NORMAL` — subclasses that need `LateInitialize` must override `Initialize()` and explicitly `return INITIALIZE_HINT_LATELOAD`.
- `LateInitialize()` is only called during mapload. Atoms spawned mid-round via `new()` get `LateInitialize()` called immediately (not deferred) if `SSatoms.initialized != INITIALIZATION_INNEW_MAPLOAD`.
- If you need cross-object setup at world start, always use `LateInitialize()`, never `sleep()` hacks in `Initialize()`.

### How to check if a parent returns LATELOAD
```sh
rg -n "INITIALIZE_HINT_LATELOAD|return INITIALIZE_HINT" code/game/objects/structures/fake_machines/_fake_machine.dm
```
If nothing found → parent returns NORMAL → you must override.

## Complete Subsystem Index

| SS global | Kind | Category | Type path | Role | File |
| --- | --- | --- | --- | --- | --- |
| `SSconveyors` | movement | AI & movement | `/datum/controller/subsystem/movement/conveyors` | Handles conveyors. | `code\\controllers\\subsystem\movement\conveyors.dm` |
| `SSminecarts` | movement | AI & movement | `/datum/controller/subsystem/movement/minecarts` | Handles minecarts. | `code\\controllers\\subsystem\movement\minecarts.dm` |
| `SSmove_manager` | standard | AI & movement | `/datum/controller/subsystem/move_manager` | Handles move manager. | `code\\controllers\\subsystem\movement\move_manager.dm` |
| `SSmovement` | standard | AI & movement | `/datum/controller/subsystem/movement` | Handles movement. | `code\\controllers\\subsystem\movement\movement_loop.dm` |
| `SSasset_loading` | standard | Boot, assets & infrastructure | `/datum/controller/subsystem/asset_loading` | Handles asset loading. | `code\\controllers\\subsystem\assets\asset_loading.dm` |
| `SSassets` | standard | Boot, assets & infrastructure | `/datum/controller/subsystem/assets` | Handles assets. | `code\\controllers\\subsystem\assets\assets.dm` |
| `SSatoms` | standard | Boot, assets & infrastructure | `/datum/controller/subsystem/atoms` | **Core atom lifecycle — read this file before any Initialize/LateInitialize question.** Calls `Initialize()` on every atom at world start. Atoms returning `INITIALIZE_HINT_LATELOAD` are queued into `late_loaders` and get `LateInitialize()` called after ALL atoms on the map finish initializing — the only safe moment to reference other map objects (landmarks, spawners, etc.). Atoms returning `INITIALIZE_HINT_NORMAL` (the default `..()`) never receive `LateInitialize()`. **Critical gotcha:** parent types like `fake_machine` return `INITIALIZE_HINT_NORMAL` by default — subclasses that need `LateInitialize` must explicitly override `Initialize()` and `return INITIALIZE_HINT_LATELOAD`. | `code\\controllers\\subsystem\atoms.dm` |
| `SSban_cache` | standard | Boot, assets & infrastructure | `/datum/controller/subsystem/ban_cache` | Handles ban cache. | `code\\controllers\\subsystem\ban_cache.dm` |
| `SSblackbox` | standard | Boot, assets & infrastructure | `/datum/controller/subsystem/blackbox` | Handles blackbox. | `code\\controllers\\subsystem\blackbox.dm` |
| `SSdbcore` | standard | Boot, assets & infrastructure | `/datum/controller/subsystem/dbcore` | Handles dbcore. | `code\\controllers\\subsystem\dbcore.dm` |
| `SSearly_assets` | standard | Boot, assets & infrastructure | `/datum/controller/subsystem/early_assets` | Handles early assets. | `code\\controllers\\subsystem\assets\early_assets.dm` |
| `SSelastic` | standard | Boot, assets & infrastructure | `/datum/controller/subsystem/elastic` | Handles elastic. | `code\\controllers\\subsystem\elastic.dm` |
| `SSgarbage` | standard | Boot, assets & infrastructure | `/datum/controller/subsystem/garbage` | Handles garbage. | `code\\controllers\\subsystem\garbage.dm` |
| `SSserver_maint` | standard | Boot, assets & infrastructure | `/datum/controller/subsystem/server_maint` | Handles server maint. | `code\\controllers\\subsystem\server_maint.dm` |
| `SSachievements` | standard | Gameplay simulation | `/datum/controller/subsystem/achievements` | Handles achievements. | `code\\controllers\\subsystem\achievements.dm` |
| `SSacid` | standard | Gameplay simulation | `/datum/controller/subsystem/acid` | Handles acid. | `code\\controllers\\subsystem\acid.dm` |
| `SSadjacent_air` | standard | Gameplay simulation | `/datum/controller/subsystem/adjacent_air` | Handles adjacent air. | `code\\controllers\\subsystem\adjacent_air.dm` |
| `SSai_controllers` | standard | Gameplay simulation | `/datum/controller/subsystem/ai_controllers` | Handles ai controllers. | `code\\controllers\\subsystem\ai_controller.dm` |
| `SSai_idle_controllers` | ai-controller | Gameplay simulation | `/datum/controller/subsystem/ai_controllers/ai_idle_controllers` | Handles ai idle controllers. | `code\\controllers\\subsystem\ai_idle_controllers.dm` |
| `SSambience` | standard | Gameplay simulation | `/datum/controller/subsystem/ambience` | Handles ambience. | `code\\controllers\\subsystem\ambience.dm` |
| `SSarea_contents` | standard | Gameplay simulation | `/datum/controller/subsystem/area_contents` | Handles area contents. | `code\\controllers\\subsystem\area_contents.dm` |
| `SSblueprints` | standard | Gameplay simulation | `/datum/controller/subsystem/blueprints` | Handles blueprints. | `code\\controllers\\subsystem\blueprints.dm` |
| `SSbounties` | standard | Gameplay simulation | `/datum/controller/subsystem/bounties` | Handles bounties. | `code\\controllers\\subsystem\bounties.dm` |
| `SScellauto` | standard | Gameplay simulation | `/datum/controller/subsystem/cellauto` | Handles cellauto. | `code\\controllers\\subsystem\cellular_tracker.dm` |
| `SScrediticons` | standard | Gameplay simulation | `/datum/controller/subsystem/crediticons` | Handles crediticons. | `code\\controllers\\subsystem\crediticons.dm` |
| `SSdamoverlays` | standard | Gameplay simulation | `/datum/controller/subsystem/damoverlays` | Handles damoverlays. | `code\\controllers\\subsystem\damoverlays.dm` |
| `SSdcs` | processing | Gameplay simulation | `/datum/controller/subsystem/processing/dcs` | Handles dcs. | `code\\controllers\\subsystem\dcs.dm` |
| `SSdeath_arena` | standard | Gameplay simulation | `/datum/controller/subsystem/death_arena` | Handles death arena. | `code\\controllers\\subsystem\death_arena.dm` |
| `SSeconomy` | standard | Gameplay simulation | `/datum/controller/subsystem/economy` | Handles economy. | `code\\controllers\\subsystem\economy.dm` |
| `SSevents` | standard | Gameplay simulation | `/datum/controller/subsystem/events` | Handles events. | `code\\controllers\\subsystem\events.dm` |
| `SSfield_of_vision` | standard | Gameplay simulation | `/datum/controller/subsystem/field_of_vision` | Runs object-permanence updates for registered FoV components. | `code\\controllers\\subsystem\processing\fov.dm` |
| `SSfamilytree` | standard | Gameplay simulation | `/datum/controller/subsystem/familytree` | Handles familytree. | `code\\controllers\\subsystem\familytree.dm` |
| `SSfrenzy_handler` | standard | Gameplay simulation | `/datum/controller/subsystem/frenzy_handler` | Handles frenzy handler. | `code\\controllers\\subsystem\frenzy_handler.dm` |
| `SSgreyscale` | standard | Gameplay simulation | `/datum/controller/subsystem/greyscale` | Handles greyscale. | `code\\controllers\\subsystem\greyscale.dm` |
| `SShotspots` | standard | Gameplay simulation | `/datum/controller/subsystem/hotspots` | Handles hotspots. | `code\\controllers\\subsystem\hotspots.dm` |
| `SShousing` | standard | Gameplay simulation | `/datum/controller/subsystem/housing` | Handles housing. | `code\\controllers\\subsystem\property_management.dm` |
| `SSicon_smooth` | standard | Gameplay simulation | `/datum/controller/subsystem/icon_smooth` | Handles icon smooth. | `code\\controllers\\subsystem\icon_smooth.dm` |
| `SSidle_ai_behaviors` | processing | Gameplay simulation | `/datum/controller/subsystem/processing/idle_ai_behaviors` | Handles idle ai behaviors. | `code\\controllers\\subsystem\idle_ai_behaviors.dm` |
| `SSipintel` | standard | Gameplay simulation | `/datum/controller/subsystem/ipintel` | Handles ipintel. | `code\\controllers\\subsystem\ipintel.dm` |
| `SSisland_mobs` | standard | Gameplay simulation | `/datum/controller/subsystem/island_mobs` | Handles island mobs. | `code\\controllers\\subsystem\mobs\islander.dm` |
| `SSlanguage` | standard | Gameplay simulation | `/datum/controller/subsystem/language` | Handles language. | `code\\controllers\\subsystem\language.dm` |
| `SSlibrarian` | standard | Gameplay simulation | `/datum/controller/subsystem/librarian` | Handles librarian. | `code\\controllers\\subsystem\librarian.dm` |
| `SSmachines` | standard | Gameplay simulation | `/datum/controller/subsystem/machines` | Handles machines. | `code\\controllers\\subsystem\machines.dm` |
| `SSmatthios_mobs` | standard | Gameplay simulation | `/datum/controller/subsystem/matthios_mobs` | Handles matthios mobs. | `code\\controllers\\subsystem\mobs\matthios.dm` |
| `SSmerchant` | standard | Gameplay simulation | `/datum/controller/subsystem/merchant` | Handles merchant. | `code\\controllers\\subsystem\merchant.dm` |
| `SSmigrants` | standard | Gameplay simulation | `/datum/controller/subsystem/migrants` | Handles migrants. | `code\\controllers\\subsystem\migration.dm` |
| `SSmob_functions` | processing | Gameplay simulation | `/datum/controller/subsystem/processing/mob_functions` | Handles mob functions. | `code\\controllers\\subsystem\mob_functions.dm` |
| `SSmobs` | standard | Gameplay simulation | `/datum/controller/subsystem/mobs` | Handles mobs. | `code\\controllers\\subsystem\mobs\mobs.dm` |
| `SSmood` | processing | Gameplay simulation | `/datum/controller/subsystem/processing/mood` | Handles mood. | `code\\controllers\\subsystem\moods.dm` |
| `SSmouse_entered` | standard | Gameplay simulation | `/datum/controller/subsystem/mouse_entered` | Handles mouse entered. | `code\\controllers\\subsystem\mouse_entered.dm` |
| `SSnightshift` | standard | Gameplay simulation | `/datum/controller/subsystem/nightshift` | Handles nightshift. | `code\\controllers\\subsystem\nightshift.dm` |
| `SSoverlays` | standard | Gameplay simulation | `/datum/controller/subsystem/overlays` | Handles overlays. | `code\\controllers\\subsystem\overlays.dm` |
| `SSoverwatch` | standard | Gameplay simulation | `/datum/controller/subsystem/overwatch` | Handles overwatch. | `code\\controllers\\subsystem\overwatch.dm` |
| `SSpaintings` | standard | Gameplay simulation | `/datum/controller/subsystem/paintings` | Handles paintings. | `code\\controllers\\subsystem\painting.dm` |
| `SSpersistence` | standard | Gameplay simulation | `/datum/controller/subsystem/persistence` | Handles persistence. | `code\\controllers\\subsystem\persistence.dm` |
| `SSping` | standard | Gameplay simulation | `/datum/controller/subsystem/ping` | Handles ping. | `code\\controllers\\subsystem\ping.dm` |
| `SSplexora` | standard | Gameplay simulation | `/datum/controller/subsystem/plexora` | Handles plexora. | `code\\controllers\\subsystem\plexora.dm` |
| `SSrandom_travel_tiles` | standard | Gameplay simulation | `/datum/controller/subsystem/random_travel_tiles` | Handles random travel tiles. | `code\\controllers\\subsystem\randomized_travel_tiles.dm` |
| `SSregionthreat` | standard | Gameplay simulation | `/datum/controller/subsystem/regionthreat` | Handles regionthreat. | `code\\controllers\\subsystem\regional_threat.dm` |
| `SSroguemachine` | processing | Gameplay simulation | `/datum/controller/subsystem/processing/roguemachine` | Handles roguemachine. | `code\\controllers\\subsystem\roguemachine.dm` |
| `SSroguerot` | processing | Gameplay simulation | `/datum/controller/subsystem/processing/roguerot` | Handles roguerot. | `code\\controllers\\subsystem\roguerot.dm` |
| `SSskills` | standard | Gameplay simulation | `/datum/controller/subsystem/skills` | Handles skills. | `code\\controllers\\subsystem\skills.dm` |
| `SSsoundloopers` | standard | Gameplay simulation | `/datum/controller/subsystem/soundloopers` | Handles soundloopers. | `code\\controllers\\subsystem\soundloopers.dm` |
| `SSsounds` | standard | Gameplay simulation | `/datum/controller/subsystem/sounds` | Handles sounds. | `code\\controllers\\subsystem\sounds.dm` |
| `SSstrategy_master` | processing | Gameplay simulation | `/datum/controller/subsystem/processing/strategy_master` | Handles strategy master. | `code\\controllers\\subsystem\strategy_master.dm` |
| `SSthrowing` | standard | Gameplay simulation | `/datum/controller/subsystem/throwing` | Handles throwing. | `code\\controllers\\subsystem\throwing.dm` |
| `SStime_track` | standard | Gameplay simulation | `/datum/controller/subsystem/time_track` | Handles time track. | `code\\controllers\\subsystem\time_track.dm` |
| `SStimer` | standard | Gameplay simulation | `/datum/controller/subsystem/timer` | Handles timer. | `code\\controllers\\subsystem\timer.dm` |
| `SStreasury` | standard | Gameplay simulation | `/datum/controller/subsystem/treasury` | Handles treasury. | `code\\controllers\\subsystem\treasury.dm` |
| `SStreesetup` | standard | Gameplay simulation | `/datum/controller/subsystem/treesetup` | Handles treesetup. | `code\\controllers\\subsystem\treestuff.dm` |
| `SSverb_manager` | standard | Gameplay simulation | `/datum/controller/subsystem/verb_manager` | Handles verb manager. | `code\\controllers\\subsystem\verb_manager.dm` |
| `SSvis_overlays` | standard | Gameplay simulation | `/datum/controller/subsystem/vis_overlays` | Handles vis overlays. | `code\\controllers\\subsystem\vis_overlays.dm` |
| `SSaction_charge` | processing | Processing loops | `/datum/controller/subsystem/processing/action_charge` | Handles action charge. | `code\\controllers\\subsystem\processing\action_charge.dm` |
| `SSaggro` | processing | Processing loops | `/datum/controller/subsystem/processing/aggro` | Handles aggro. | `code\\controllers\\subsystem\processing\aggro.dm` |
| `SSai_behaviors` | processing | Processing loops | `/datum/controller/subsystem/processing/ai_behaviors` | Handles ai behaviors. | `code\\controllers\\subsystem\processing\ai_behaviors.dm` |
| `SSai_movement` | processing | Processing loops | `/datum/controller/subsystem/processing/ai_movement` | Handles ai movement. | `code\\controllers\\subsystem\processing\ai_movement.dm` |
| `SSanvil` | processing | Processing loops | `/datum/controller/subsystem/processing/anvil` | Handles anvil. | `code\\controllers\\subsystem\processing\anvil_minigame.dm` |
| `SSbasic_avoidance` | processing | Processing loops | `/datum/controller/subsystem/processing/basic_avoidance` | Handles basic avoidance. | `code\\controllers\\subsystem\processing\ai_avoidance.dm` |
| `SSenchantment` | processing | Processing loops | `/datum/controller/subsystem/processing/enchantment` | Handles enchantment. | `code\\controllers\\subsystem\processing\enchantment.dm` |
| `SSfaster_obj` | processing | Processing loops | `/datum/controller/subsystem/processing/faster_obj` | Handles faster obj. | `code\\controllers\\subsystem\processing\faster_object.dm` |
| `SSfastprocess` | processing | Processing loops | `/datum/controller/subsystem/processing/fastprocess` | Handles fastprocess. | `code\\controllers\\subsystem\processing\fastprocess.dm` |
| `SSfishing` | processing | Processing loops | `/datum/controller/subsystem/processing/fishing` | Handles fishing. | `code\\controllers\\subsystem\processing\fishing.dm` |
| `SSfluids` | processing | Processing loops | `/datum/controller/subsystem/processing/fluids` | Handles fluids. | `code\\controllers\\subsystem\processing\fluids.dm` |
| `SShaunting` | processing | Processing loops | `/datum/controller/subsystem/processing/haunting` | Handles haunting. | `code\\controllers\\subsystem\processing\haunting.dm` |
| `SShuds` | processing | Processing loops | `/datum/controller/subsystem/processing/huds` | Handles huds. | `code\\controllers\\subsystem\processing\huds.dm` |
| `SSincone` | standard | Processing loops | `/datum/controller/subsystem/incone` | Handles incone. | `code\\controllers\\subsystem\processing\incone.dm` |
| `SSmagic` | processing | Processing loops | `/datum/controller/subsystem/processing/magic` | Handles magic. | `code\\controllers\\subsystem\processing\magic.dm` |
| `SSmousecharge` | processing | Processing loops | `/datum/controller/subsystem/processing/mousecharge` | Handles mousecharge. | `code\\controllers\\subsystem\processing\mousecharge.dm` |
| `SSobj` | processing | Processing loops | `/datum/controller/subsystem/processing/obj` | Handles obj. | `code\\controllers\\subsystem\processing\obj.dm` |
| `SSpollutants` | processing | Processing loops | `/datum/controller/subsystem/processing/pollutants` | Handles pollutants. | `code\\controllers\\subsystem\processing\pollutants.dm` |
| `SSprocessing` | standard | Processing loops | `/datum/controller/subsystem/processing` | Handles processing. | `code\\controllers\\subsystem\processing\_processing.dm` |
| `SSprojectiles` | processing | Processing loops | `/datum/controller/subsystem/processing/projectiles` | Handles projectiles. | `code\\controllers\\subsystem\processing\projectiles.dm` |
| `SSslowobj` | processing | Processing loops | `/datum/controller/subsystem/processing/slowobj` | Handles slowobj. | `code\\controllers\\subsystem\processing\slow_objects.dm` |
| `SSstatusprocess` | processing | Processing loops | `/datum/controller/subsystem/processing/statusprocess` | Handles statusprocess. | `code\\controllers\\subsystem\processing\statusprocess.dm` |
| `SStramprocess` | processing | Processing loops | `/datum/controller/subsystem/processing/tramprocess` | Handles tramprocess. | `code\\controllers\\subsystem\processing\tram.dm` |
| `SSvisual_ui` | processing | Processing loops | `/datum/controller/subsystem/processing/visual_ui` | Handles visual ui. | `code\\controllers\\subsystem\processing\visual_ui.dm` |
| `SSwet_floors` | processing | Processing loops | `/datum/controller/subsystem/processing/wet_floors` | Handles wet floors. | `code\\controllers\\subsystem\processing\wet_floors.dm` |
| `SSgamemode` | standard | Round flow & player lifecycle | `/datum/controller/subsystem/gamemode` | Handles gamemode. | `code\\controllers\\subsystem\storyteller.dm` |
| `SSjob` | standard | Round flow & player lifecycle | `/datum/controller/subsystem/job` | Handles job. | `code\\controllers\\subsystem\job.dm` |
| `SSlobbymenu` | standard | Round flow & player lifecycle | `/datum/controller/subsystem/lobbymenu` | Handles lobbymenu. | `code\\controllers\\subsystem\lobby.dm` |
| `SSrole_class_handler` | standard | Round flow & player lifecycle | `/datum/controller/subsystem/role_class_handler` | Handles role class handler. | `code\\controllers\\subsystem\role_class_handler\role_class_handler.dm` |
| `SSticker` | standard | Round flow & player lifecycle | `/datum/controller/subsystem/ticker` | Handles ticker. | `code\\controllers\\subsystem\ticker.dm` |
| `SStitle` | standard | Round flow & player lifecycle | `/datum/controller/subsystem/title` | Handles title. | `code\\controllers\\subsystem\title.dm` |
| `SStriumphs` | standard | Round flow & player lifecycle | `/datum/controller/subsystem/triumphs` | Handles triumphs. | `code\\controllers\\subsystem\triumph\triumphs.dm` |
| `SSchat` | standard | UI, comms & admin | `/datum/controller/subsystem/chat` | Handles chat. | `code\\controllers\\subsystem\chat.dm` |
| `SScommunications` | standard | UI, comms & admin | `/datum/controller/subsystem/communications` | Handles communications. | `code\\controllers\\subsystem\communications.dm` |
| `SSdiscord` | standard | UI, comms & admin | `/datum/controller/subsystem/discord` | Handles discord. | `code\\controllers\\subsystem\discord.dm` |
| `SSinput` | verb-manager | UI, comms & admin | `/datum/controller/subsystem/verb_manager/input` | Handles input. | `code\\controllers\\subsystem\input.dm` |
| `SSradio` | standard | UI, comms & admin | `/datum/controller/subsystem/radio` | Handles radio. | `code\\controllers\\subsystem\radio.dm` |
| `SSrunechat` | timer | UI, comms & admin | `/datum/controller/subsystem/timer/runechat` | Handles runechat. | `code\\controllers\\subsystem\runechat.dm` |
| `SSstatpanels` | standard | UI, comms & admin | `/datum/controller/subsystem/statpanels` | Handles statpanels. | `code\\controllers\\subsystem\statpanel.dm` |
| `SStgui` | standard | UI, comms & admin | `/datum/controller/subsystem/tgui` | Handles tgui. | `code\\controllers\\subsystem\tgui.dm` |
| `SSverifications` | standard | UI, comms & admin | `/datum/controller/subsystem/verifications` | Handles verifications. | `code\\controllers\\subsystem\veyra.dm` |
| `SSvote` | standard | UI, comms & admin | `/datum/controller/subsystem/vote` | Handles vote. | `code\\controllers\\subsystem\vote.dm` |
| `SSdungeon_generator` | standard | World generation & map state | `/datum/controller/subsystem/dungeon_generator` | Handles dungeon generator. | `code\\controllers\\subsystem\dungeon_generator.dm` |
| `SSfire_burning` | standard | World generation & map state | `/datum/controller/subsystem/fire_burning` | Handles fire burning. | `code\\controllers\\subsystem\fire_burning.dm` |
| `SSfire_spread` | standard | World generation & map state | `/datum/controller/subsystem/fire_spread` | Handles fire spread. | `code\\controllers\\subsystem\fire_spread.dm` |
| `SSlighting` | standard | World generation & map state | `/datum/controller/subsystem/lighting` | Handles lighting. | `code\\controllers\\subsystem\lighting.dm` |
| `SSliquids` | standard | World generation & map state | `/datum/controller/subsystem/liquids` | Handles liquids. | `code\\controllers\\subsystem\liquids.dm` |
| `SSmapping` | standard | World generation & map state | `/datum/controller/subsystem/mapping` | Handles mapping. | `code\\controllers\\subsystem\mapping.dm` |
| `SSminor_mapping` | standard | World generation & map state | `/datum/controller/subsystem/minor_mapping` | Handles minor mapping. | `code\\controllers\\subsystem\minor_mapping.dm` |
| `SSoutdoor_effects` | standard | World generation & map state | `/datum/controller/subsystem/outdoor_effects` | Handles outdoor effects. | `code\\controllers\\subsystem\particle_weather_outdoors.dm` |
| `SSParticleWeather` | standard | World generation & map state | `/datum/controller/subsystem/ParticleWeather` | Handles ParticleWeather. | `code\\controllers\\subsystem\particle_weather.dm` |
| `SSpathfinder` | standard | World generation & map state | `/datum/controller/subsystem/pathfinder` | Handles pathfinder. | `code\\controllers\\subsystem\pathfinder.dm` |
| `SSpollution` | standard | World generation & map state | `/datum/controller/subsystem/pollution` | Handles pollution. | `code\\controllers\\subsystem\pollution.dm` |
| `SSpocket_dimensions` | standard | World generation & map state | `/datum/controller/subsystem/pocket_dimensions` | Caches pocket templates, manages live pocket instances, and advances their lifecycle. | `code\\controllers\\subsystem\pocket_dimensions.dm` |
| `SSspatial_grid` | standard | World generation & map state | `/datum/controller/subsystem/spatial_grid` | Handles spatial grid. | `code\\controllers\\subsystem\spatial_grid.dm` |
| `SSterrain_generation` | standard | World generation & map state | `/datum/controller/subsystem/terrain_generation` | Handles terrain generation. | `code\\controllers\\subsystem\voyage.dm` |
| `SSwaterlevel` | standard | World generation & map state | `/datum/controller/subsystem/waterlevel` | Handles waterlevel. | `code\\controllers\\subsystem\water_level.dm` |
