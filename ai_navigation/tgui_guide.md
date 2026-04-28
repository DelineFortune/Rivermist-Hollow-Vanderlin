# TGUI Guide

Generated on 2026-03-14. Derived from `tgui/README.md`, `tgui/docs/`, and the React documentation.
TGUI is the project's primary UI framework — React + TypeScript on the frontend, DM on the backend, communicating via JSON over BYOND's browser component.

For all new player-facing interfaces, TGUI is mandatory (see `coding_standards.md` §User Interfaces).
The navigation layer may lag behind the live documents. If this file and source docs disagree, trust the source docs.

---

## Architecture Overview

```
DM backend (game object)          JS frontend (React component)
────────────────────────          ──────────────────────────────
ui_interact()  ←── open/update    routes.ts → loads component
ui_data()      ──→ JSON data  ──→ useBackend() → data, act()
ui_act()       ←── actions   ←── act("action", params)
ui_state()     ──→ access check
```

- **SStgui** — subsystem that owns all open UI instances. Always route through it.
- **`/datum/tgui`** — one instance per open window per user.
- **`/datum/tgui_window`** — lower-level wrapper around BYOND's browser element; used for custom HTML popups, not standard TGUI interfaces.

---

## Backend (DM Side)

### The four required procs

```dm
/obj/machinery/my_machine/ui_interact(mob/user, datum/tgui/ui)
    ui = SStgui.try_update_ui(user, src, ui)
    if (!ui)
        ui = new(user, src, "MyMachine")  // "MyMachine" = component filename
        ui.open()

/obj/machinery/my_machine/ui_data(mob/user)
    var/list/data = list()
    data["health"] = health
    data["color"] = color
    return data

/obj/machinery/my_machine/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
    . = ..()       // MUST be first — handles access checks, returns TRUE if already handled
    if (.)
        return
    switch(action)
        if("change_color")
            var/new_color = params["color"]
            if (!(new_color in allowed_colors))
                return FALSE
            color = new_color
            . = TRUE
    update_icon()

/obj/machinery/my_machine/ui_state(mob/user)
    return GLOB.default_state  // or a custom ui_state datum
```

### Rules

**`ui_interact`** is called both to open a new UI and to update an existing one. `try_update_ui` handles the update path; the `if(!ui)` block handles creation. `ui_interact` is triggered automatically by `attack_hand` (objects) and `attack_self` (items) — you usually don't call it directly.

**`ui_data`** must return only plain DM types: numbers, strings, lists. No atoms, no datums. Associative lists become JS objects; plain lists become JS arrays. **Always prefer plain arrays** — they support `.map()`, `.filter()`, etc. in JS; objects do not.

**`ui_act`** is the security boundary. The `..()` call at the top validates access via `ui_state`. Never skip it. **Always treat every param as potentially malicious** — clamp numbers, validate strings, check refs. Return `TRUE` when the action was handled and the UI should re-render; `FALSE` (or nothing) otherwise.

**`ui_state`** controls under what conditions the user may interact. Can be overridden from other procs to support embedded objects or remote access.

### Copypasta template

```dm
/obj/my_thing/ui_interact(mob/user, datum/tgui/ui)
    ui = SStgui.try_update_ui(user, src, ui)
    if (!ui)
        ui = new(user, src, "MyThing")
        ui.open()

/obj/my_thing/ui_data(mob/user)
    var/list/data = list()
    data["value"] = my_var
    return data

/obj/my_thing/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
    . = ..()
    if (.)
        return
    switch(action)
        if("set_value")
            my_var = CLAMP(params["value"], MIN_VAL, MAX_VAL)
            . = TRUE
```

---

## Frontend (React/TypeScript Side)

### File location

`tgui/packages/tgui/interfaces/MyThing.tsx` — filename must match the string passed to `new /datum/tgui(user, src, "MyThing")`.

Registration is automatic via `routes.ts` — no manual registration needed.

### Multilingual RMH interfaces

RMH bilingual player-facing TGUI should follow the modular wrapper pattern used by `ContractLedger` and `OvipositionStatus`:

- Before starting TGUI work, always offer the user to make or keep the interface multilingual (EN/RU), even when the original request does not explicitly ask for localization.
- Keep one shared implementation in `tgui/packages/tgui/interfaces/MyThingView.tsx`.
- Put user-facing strings in `MyThing.i18n.en.ts` and `MyThing.i18n.ru.ts`.
- Keep route wrappers thin: `MyThing.tsx` imports EN locale and `MyThingRu.tsx` imports RU locale, then both render `MyThingView`.
- On the DM side, choose the interface name before opening the UI: `get_preferred_ui_language(user) == "ru" ? "MyThingRu" : "MyThing"`. The language setting is stored on `client.preferred_ui_language` and changed by `modular_rmh/code/modules/client/preferred_language.dm`.
- Prefer stable keys, ids, counts, and raw state in `ui_data()`. Translate labels and status text in TS locale files; avoid hardcoding parallel English/Russian strings in DM unless the DM value is not TGUI-specific.

### Minimal component

```tsx
import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const MyThing = () => {
    const { act, data } = useBackend();
    const { health, color } = data;

    return (
        <Window resizable>
            <Window.Content scrollable>
                <Section title="Status">
                    <LabeledList>
                        <LabeledList.Item label="Health">{health}</LabeledList.Item>
                        <LabeledList.Item label="Color">{color}</LabeledList.Item>
                        <LabeledList.Item label="Action">
                            <Button onClick={() => act('reset')}>Reset</Button>
                        </LabeledList.Item>
                    </LabeledList>
                </Section>
            </Window.Content>
        </Window>
    );
};
```

### Key hooks

| Hook | Purpose |
|---|---|
| `useBackend()` | Returns `{ act, data, config }`. Primary hook for all TGUI interfaces. |
| `useState(initial)` | Local component state. Use for UI-only state (open/closed panels, input drafts). |
| `useEffect(fn, deps)` | Side effects and async data. Use sparingly — prefer derived state. |

`useLocalState` — **deprecated**, do not use in new code.
`useSharedState` — still valid for IC-shared UIs where all users at a terminal see the same state.

### State rules

- **Derived state over stored state.** If a value can be computed from existing data, compute it inline — don't store it in `useState`.
- **Don't overuse hooks.** State is for user interactivity and async data, not storing constants or values that don't change.
- Each `setState` used to trigger a re-render cascade in older React; React now batches renders, but the principle of minimising unnecessary state still applies.

```tsx
// Bad — isEven is derived from count, shouldn't be state
const [count, setCount] = useState(0);
const [isEven, setIsEven] = useState(false);
useEffect(() => { setIsEven(count % 2 === 0); }, [count]);

// Good
const [count, setCount] = useState(0);
const isEven = count % 2 === 0;
```

### JSX essentials

JSX compiles to `createElement()` calls. It is JavaScript, not a template language — any JS expression works inside `{}`.

```tsx
// Conditional rendering
{isOn && <Section title="Active">...</Section>}
{isOn ? <OnView /> : <OffView />}

// List rendering — key is mandatory
{items.map(item => (
    <LabeledList.Item key={item.id} label={item.name}>
        {item.value}
    </LabeledList.Item>
))}
```

**Always provide `key` when rendering lists.** React uses it to reconcile updates efficiently.

### Splitting large interfaces

When an interface grows unwieldy, extract sections into sub-components in the same file:

```tsx
export const MyThing = () => {
    return (
        <Window resizable>
            <Window.Content scrollable>
                <StatusPanel />
                <ControlPanel />
            </Window.Content>
        </Window>
    );
};

const StatusPanel = () => {
    const { data } = useBackend();
    return (
        <Section title="Status">
            ...
        </Section>
    );
};
```

---

## Project Structure

| Path | Contents |
|---|---|
| `tgui/packages/tgui/interfaces/` | All in-game UI components — one file per interface |
| `tgui/packages/tgui/components/` | Reusable UI building blocks (Button, Section, LabeledList, etc.) |
| `tgui/packages/tgui/layouts/` | Root window wrappers (Window, etc.) |
| `tgui/packages/tgui/routes.ts` | Auto-routes component name → file |
| `tgui/packages/tgui/styles/` | SCSS: `atomic/` (utility classes), `interfaces/` (per-UI), `themes/` |
| `tgui/packages/common/` | Shared helpers used across all packages |
| `tgui/packages/tgui/index.ts` | App entry point; theme registration |

Component reference (building blocks): `https://tgstation.github.io/tgui-core/`
Tgui Core (component library): `https://github.com/tgstation/tgui-core`

---

## Build and Dev Workflow

**Always run a full build before submitting a PR.** It runs the same checks as CI but faster locally.

```
bun tgui:build        # production build + full CI checks
bun tgui:dev          # dev server with hot reload
bun tgui:dev --reload # reload BYOND cache once
bun tgui:lint         # lint + auto-fix
bun tgui:tsc          # TypeScript type check
bun tgui:test         # unit tests (Jest)
```

**Dev server won't attach?** Open a TGUI window in-game first, then start the server. Press F5 to refresh if needed.

**Browser DevTools:** In-game → Debug tab → "Allow Browser Inspection" → F12.

**Dev-only tools:**
- `F12` / green bug icon → KitchenSink (component playground)
- `F11` → Layout Debugger (outlines all tgui elements)
- `--debug` flag → print render timing; keep re-renders under 16ms

**Webpack cache issues** (cryptic errors after update): run `bun tgui:clean` then rebuild.

---

## Testing

Unit tests use Jest. Create a `.test.ts` or `.spec.ts` file alongside the file being tested:

```ts
test('something', () => {
    expect(computeValue(2)).toBe(4);
});
```

No UI integration tests yet — Jest + jsdom support exists but no solution for testing full interfaces. Test pure logic functions.

---

## Chat Embedded Components

TGUI components can be embedded in chat via HTML data attributes:

```html
<span data-component="Tooltip" data-content="Hover text">Visible text</span>
```

- `data-component` — component name (must be in `TGUI_CHAT_COMPONENTS` whitelist in `tgui-panel/chat/renderer.js`)
- `data-*` props — passed as component props; prop name mapping in `TGUI_CHAT_ATTRIBUTES_TO_PROPS`
- Types: booleans as `"$true"`/`"$false"`, numbers as numeric strings, everything else as string

---

## Custom HTML Popups (`/datum/tgui_window`)

For non-standard popups (stat panel, chat, background music, etc.) that need BYOND skin API access but not a full TGUI interface:

```dm
var/datum/tgui_window/window = new(usr.client, "custom_popup")
window.initialize(
    inline_html = "<h1>Hello</h1>",
    inline_js   = "window.alert('hi')",
    inline_css  = "h1 { color: red }",
    strict_mode = TRUE,  // bluescreen on unhandled errors — keep ON during dev
)
```

More expensive than `browse()` — use only for complex, long-lived popups.

**DM → JS messaging:**
```dm
window.send_message("alert", list(text = "Hello!"))
```
```js
Byond.subscribeTo('alert', (payload) => window.alert(payload.text));
```

**JS → DM messaging:**
```js
Byond.sendMessage('click', { button: 'explode' });
```
```dm
/datum/my_obj/proc/on_message(type, payload)
    if (type == "click")
        process_click(payload["button"])
```

**BYOND Skin API** (via `Byond.winset` / `Byond.winget`):
- Controls BYOND skin element properties at runtime
- Useful for resizing windows, showing/hiding elements, defining macros
- Reference: `tgui/global.d.ts` for type definitions; `https://secure.byond.com/docs/ref/skinparams.html` for full param list
- `Byond.windowId` — current window's skin element ID
- `'mainwindow'` — main SS13 game window ID

---

## Security Checklist

Every `ui_act` implementation must:
- [ ] Call `..()` first and return if it returns truthy
- [ ] Validate every param — never trust client input
- [ ] Clamp numeric inputs: `CLAMP(params["value"], min, max)`
- [ ] Scope `locate()` calls — never bare `locate(ref)`, always `locate(ref) in contents`
- [ ] Return `TRUE` only after handling the action, `FALSE` otherwise

---

*Cross-references:*
- *All new UIs must use TGUI: `coding_standards.md` §User Interfaces*
- *UI subsystem ownership: `subsystem_map.md` (SStgui)*
- *Topic href exploit patterns: `coding_standards.md` §Security*
