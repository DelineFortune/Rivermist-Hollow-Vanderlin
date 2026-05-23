# Type Index

Generated on 2026-05-23. Use this file when the task gives a BYOND type path and you need the cheapest route before opening the full `ai_navigation/type_tree.md`.

## Major Roots

| Root | Usually means | Open first |
|---|---|---|
| `/datum` | logic/state/controller datums | `code/datums/**`, sometimes `code/modules/**` for feature-local datums |
| `/mob` | player/NPC lifecycle and behavior | `code/modules/mob/**` |
| `/obj` | items, structures, effects, machinery, map objects | `code/game/objects/**`, `code/game/machinery/**`, feature modules in `code/modules/**` |
| `/atom` | shared atom behavior, appearance, interaction glue | `code/game/atom/**` |
| `/area` | area definitions and area-level behavior | `code/game/area/**` |
| `/turf` | world tiles, terrain, map logic | `code/game/turfs/**` |
| `/client` | client-side hooks and verbs | `code/modules/client/**`, `code/_onclick/**` |
| `/world` | bootstrap and global startup | `code/world.dm`, `code/controllers/master.dm` |

## High-Value Branches

| Type branch | Open first | Then check |
|---|---|---|
| `/datum/controller/subsystem/...` | `code/controllers/subsystem/**` | `ai_navigation/subsystem_map.md`, `code/controllers/master.dm` |
| `/datum/antagonist/...` | `code/modules/antagonists/**` | `code/modules/events/antagonist/**`, `code/datums/migrants/waves/antagonist/**` |
| `/datum/action/...` | `code/modules/spells/**` and feature-specific module files | `ai_navigation/runtime_flow.md`, `code/datums/status_effects/**` |
| `/datum/status_effect/...` | `code/datums/status_effects/**` | `code/modules/spells/**`, `code/datums/components/**`, `code/datums/elements/**` |
| `/datum/component/...` | `code/datums/components/**` | `code/__DEFINES/dcs/**`, `ai_navigation/runtime_flow.md` |
| `/datum/component/field_of_vision/...` | `code/datums/components/fov.dm` | `code/controllers/subsystem/processing/fov.dm`, `ai_navigation/subsystem_map.md` |
| `/datum/element/...` | `code/datums/elements/**` | `code/__DEFINES/dcs/**`, `ai_navigation/runtime_flow.md` |
| `/datum/ai_controller/...` or `/datum/ai_behavior/...` | `code/datums/ai/**` | `code/modules/mob/**`, `ai_navigation/subsystem_map.md` |
| `/datum/map_template/pocket/...` | `code/modules/mapping/pocket_dimensions.dm` | `code/controllers/subsystem/pocket_dimensions.dm`, `code/controllers/subsystem/mapping.dm` |
| `/datum/pocket_dimension/...` | `code/modules/mapping/pocket_dimensions.dm` | `code/controllers/subsystem/pocket_dimensions.dm`, `code/modules/admin/verbs/pocket_dimensions.dm` |
| `/datum/storyteller/...`, `/datum/round_event_control/...`, `/datum/round_event/...` | `code/datums/storytellers/**`, `code/modules/events/**` | `ai_navigation/runtime_flow.md`, `ai_navigation/system_dependencies.md` |
| `/datum/migrant_wave/...` or `/datum/migrant_role/...` | `code/datums/migrants/**` | `code/modules/jobs/**`, `modular_rmh/code/modules/jobs/**` |
| `/mob/living/...` | `code/modules/mob/living/**` | feature modules touching that mob family |
| `/mob/living/carbon/human/...` | `code/modules/mob/living/carbon/**` | jobs, species, antagonists, status systems |
| `/mob/dead/new_player` | `code/modules/mob/dead/**` | `SSjob`, ticker/round flow files |
| `/obj/item/...` | `code/game/objects/items/**` or matching feature module | `code/modules/**` for system-specific behavior |
| `/obj/structure/...` | `code/game/objects/structures/**` | mapping, events, or feature module that owns the structure |
| `/obj/effect/...` | `code/game/objects/effects/**` | mapping landmarks, event spawners, temporary gameplay effects |

## Cheap Rules

- Start with this file, not `ai_navigation/type_tree.md`, unless you truly need inheritance depth.
- If the branch matches one row above, open the mapped directory family before doing a repo-wide search.
- If the path is feature-local and not obvious from the branch, use `ai_navigation/entrypoints.md` or `ai_navigation/system_map.md`.
- After locating the core branch in `code/`, check whether `modular_rmh` extends the same path.
- Escalate to `ai_navigation/type_tree.md` only when parent/child inheritance is itself the problem.
