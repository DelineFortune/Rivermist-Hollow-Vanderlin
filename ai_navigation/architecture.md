# Architecture Overview

Generated on 2026-05-23. This file explains how the repository is put together and where runtime ownership lives.

## Composition Model

- The project is a BYOND/Dream Maker codebase with a classic tgstation-style linear `.dme` include graph.
- The high-level include order is: maps/templates -> world/defines -> helpers -> globalvars -> controllers -> datums -> modules -> game atoms/objects -> interface -> a small late `modular_alizeria`/`modular_ratwood` cluster -> `modular_rmh`.
- Because `modular_rmh` is included at the end of that late modular cluster in `vanderlin.dme`, it acts as the dominant overlay layer: it can extend existing type trees and piggyback on core singletons without replacing the architecture.

## Runtime Backbone

- `code/world.dm` defines `/world`; `code/controllers/master.dm` owns the master controller loop and discovers all `/datum/controller/subsystem` subtypes via `subtypesof(...)`.
- `code/controllers/subsystem.dm` is the base scheduler contract: metadata (`init_order`, `wait`, `priority`, `flags`), runlevels, queueing, `Initialize()`, and `fire()`.
- `code/__DEFINES/MC.dm` turns subsystem macros into `SS*` globals plus type declarations, so subsystem files effectively declare singletons and their types together.
- `SSatoms` is the bridge between BYOND construction and the project initialization model: it drives `Initialize`, `LateInitialize`, and init diagnostics for atoms.

> **Engine constraint bridge:** The master controller loop operates within the BYOND tick budget (`world.tick_lag` default = 0.1 s; `world.cpu` is the health gauge). Any work added to a subsystem `fire()` directly increases tick CPU cost. Subsystems that call `sleep()` from inside `fire()` hand control back to the engine immediately — the intended delay does **not** block the scheduler (engine behavior, not a bug). See `ai_navigation/engine_limits.md` §Tick System and `ai_navigation/performance_gotchas.md` §3.

## Domain Layers

- `code/__DEFINES`: compile-time constants, macros, signal definitions, subsystem flags, and root constants.
- `code/__HELPERS`: shared procs/helpers used across every gameplay layer.
- `code/_globalvars`: global singletons, caches, lookup tables, and configuration state.
- `code/controllers`: world bootstrap, master controller, configuration, and subsystem framework.
- `code/datums`: pure/stateful datums for AI, components, status effects, faith, RTS, migrants, runewords, and other reusable logic.
- `code/modules`: feature-sliced gameplay code such as jobs, spells, antagonists, mobs, crafting, mapping, reagents, and UI bridges.
- `code/game`: concrete atoms, mobs, objects, turfs, areas, and gamemode implementations.
- `_maps`: static maps, templates, and map adjustment files.
- `interface`: BYOND client verbs, menus, DMF, and font datums.
- `tgui`: TypeScript/React frontend packages and build tooling.
- `modular_rmh`: late-included modular extension layer for jobs, spells, mobs, mapgen, status effects, religion, fluids, and content packs.
- `config`, `SQL`, `tools`: runtime config, schema data, and developer tooling.

## Core Patterns

- Type-tree inheritance is the primary structural unit. Most gameplay features are found by following paths under `/datum`, `/obj`, `/mob`, `/turf`, and `/area`.
- Signal-driven composition is a first-class pattern: `RegisterSignal` and `SEND_SIGNAL` appear at `2195` call sites, which means behavior is frequently attached indirectly through DCS contracts instead of hardcoded call chains.
- Component-based extension is pervasive: `AddComponent(...)` appears at `416` call sites, especially around atoms, items, mobs, and environmental systems.
- Status effects are a common cross-system state container: `apply_status_effect(...)` appears at `345` call sites spanning combat, spells, liquids, wounds, quirks, and modular features.
- Feature slices are split between `code/datums` for reusable logic/state and `code/modules` for feature bundles, UI, content, and mechanics.
- Mapping is hybrid: static DMM/templates in `_maps` coexist with procedural generation in `code/modules/mapping`, `code/modules/procedural_mapping`, and voyage/dungeon subsystems.

> **Engine constraint bridge — components and status effects:** Components and status effects frequently use `sleep()` for timed expiry. After any `sleep()`, all object references held by the proc must be null-checked — the owning atom may have been deleted. Status-effect procs running inside `process()` must not call `sleep()` directly; use timers or the subsystem's own tick cadence instead. See `ai_navigation/performance_gotchas.md` §3, §4.
>
> **Engine constraint bridge — overlays:** `overlays +=` / `overlays -=` on atoms registers new Appearance objects in the engine. Calling this inside a per-tick loop for many entities simultaneously causes Appearance accumulation and network floods to all observing clients. Batch overlay changes; prefer `icon_state` swaps over overlay cycling. See `ai_navigation/performance_gotchas.md` §7 and `ai_navigation/engine_limits.md` §Overlays and Appearance.

## Modular RMH Layer

- `modular_rmh/code/modules` is dominated by jobs, clothing, spells, and mobs. RMH mostly extends character-facing content rather than core scheduling infrastructure.
- `modular_rmh/code/datums` primarily extends religion, AI, status effects, stress, and a few support datums.
- `modular_rmh/modular` contains smaller self-contained packs such as `piercing`, `selectable_moanpacks`, `resurrection_rune`, `fluids`, `comfy`, `ceramics`, and `loot`.
- The important navigation rule is: find the core type first in `code/`, then check whether `modular_rmh` adds descendants, overrides behavior on that path, or introduces parallel content that hooks into the same subsystem.

> **Engine constraint bridge — RMH clothing and overlays:** RMH clothing and appearance systems are the most likely source of high-frequency `overlays` mutations (per-equip, per-tick, per-state changes across many player mobs simultaneously). Before adding new per-mob overlay logic in `modular_rmh`, consult `ai_navigation/performance_gotchas.md` §7. Each unique icon+state+color+transform combination becomes a tracked Appearance object sent to every nearby client.

## Frontend and External Integration

- DM-side UI backends live in `code/modules/tgui/**`, `code/modules/visual_ui/**`, and `interface/**`.
- The TypeScript frontend is under `tgui/packages/**` (`common`, `tgui`, `tgui-panel`, `tgui-say`, etc.) with Rspack/TS build tooling in the `tgui/` root.
- Runtime configuration and policies live under `config/**`; SQL/schema files live under `SQL/**`; CI/build helpers are under `bin/**`, `tools/**`, and shell/cmd scripts at repo root.

> **Engine constraint bridge — network output:** UI updates sent via `world <<` or large resource files pushed to many clients create bandwidth spikes that register as network lag (distinct from CPU/server lag). Use `world.cpu` to tell the two apart: low CPU + sluggish client = network lag. Prefer targeted `mob <<` sends over `world <<` broadcasts. See `ai_navigation/engine_limits.md` §Network.

## Runtime Ownership Quick Reference

Use this table to identify the runtime owner before opening `ai_navigation/subsystem_map.md`.

| Domain | Primary owner | Key files |
|---|---|---|
| Combat, hit chain, signals | `SSdcs` | `code/_onclick/item_attack.dm`, `code/_onclick/other_mobs.dm` |
| Movement, moveloops, collisions | `SSmovement`, `SSdcs` | `code/modules/mob/mob_movement.dm`, `code/controllers/subsystem/movement/**` |
| Spells, actions, cooldowns | `SSmagic`, `SSstatusprocess` | `code/modules/spells/**` |
| Status effects, wounds, mood | `SSstatusprocess`, `SSmood` | `code/datums/status_effects/**`, `code/datums/wounds/**` |
| AI controllers, NPC behavior | `SSai_controllers`, `SSai_behaviors` | `code/datums/ai/**` |
| Jobs, roles, latejoins | `SSjob`, `SSmigrants`, `SSrole_class_handler` | `code/modules/jobs/**`, `code/datums/migrants/**` |
| Antagonists, events | `SSgamemode`, `SSevents` | `code/modules/antagonists/**`, `code/modules/events/**` |
| Economy, housing, factions | `SSeconomy`, `SShousing`, `SStreasury` | `code/modules/economy/**`, `code/datums/world_factions/**` |
| Mapping, worldgen, dungeons | `SSmapping`, `SSpocket_dimensions`, `SSdungeon_generator` | `_maps/**`, `code/modules/mapping/**`, `code/modules/mapping/pocket_dimensions.dm`, `code/controllers/subsystem/pocket_dimensions.dm`, `code/modules/procedural_mapping/**` |
| Overlays, visual state | `SSoverlays` | `code/controllers/subsystem/overlays.dm` |
| Lighting | `SSlighting` | `code/controllers/subsystem/lighting/**` |
| UI, browser, TGUI | `SStgui`, `SSvisual_ui` | `code/modules/tgui/**`, `tgui/packages/**` |
| GC, harddel, ref cleanup | `SSgarbage` | `code/controllers/subsystem/garbage.dm` |
| Round bootstrap, tick loop | `Master` | `code/controllers/master.dm`, `code/world.dm` |
