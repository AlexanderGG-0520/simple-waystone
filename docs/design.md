# Design Notes

Simple Waystone is intended to be a small server-side waystone datapack for Minecraft Java Edition 26.1.2.

## Philosophy

- Stay compatible with vanilla Minecraft datapacks.
- Require no client mod, server plugin, or external dependency.
- Keep commands and functions minimal.
- Make the behavior readable for server operators who want to inspect or adjust it.
- Avoid heavy ticking logic unless a feature absolutely needs it.
- Keep the repository clean and suitable for public distribution.

## Multi-Waystone Prototype

The currently implemented prototype separates a waystone into three concerns:

- a visible marker;
- a clickable interaction entity;
- stored metadata on the entities and scoreboards.

The visible marker is a `minecraft:block_display` rendering a lodestone block. It is visual-only and does not place or replace a real world block.

The clickable interaction entity is an invisible `minecraft:interaction` entity with:

- tags `sws.waystone` and `sws.clickable`;
- a stable numeric id in the `sws.id` scoreboard objective;
- a practical hitbox using `width:1.1f` and `height:1.5f`;
- `response:1b` so interaction feedback behaves like a normal clickable target;
- its actual entity position and dimension as the teleport target.

The readable name is carried by a separate invisible armor stand tagged `sws.label`. The `block_display`, `interaction` entity, and label armor stand all have the same `sws.id` value, so delete operations can remove all pieces together.

The design prefers teleporting to the clickable waystone entity itself instead of treating raw coordinates as the primary target. The entity naturally carries its dimension by existing in that dimension.

Live `minecraft:interaction` hitboxes are the source of truth for whether a waystone exists. The current prototype does not keep a separate durable `simple_waystone:waystones` metadata list. Admin listing and dialog teleport selection therefore rely on live loaded entities rather than stale storage records.

## Interaction Hitbox

Right-click detection is implemented with an advancement in `data/simple_waystone/advancement/` using the `minecraft:player_interacted_with_entity` trigger. The predicate is intended to match only `minecraft:interaction` entities tagged as Simple Waystone clickable hitboxes, but it still requires in-game validation on Minecraft Java Edition 26.1.2.

Runtime validation showed that right-clicking the visible waystone body did not open the menu when the clickable target was an invisible armor stand. New waystones therefore keep the visual lodestone marker and readable armor stand label, but use a dedicated `minecraft:interaction` hitbox for clicks.

The label armor stand is not tagged `sws.clickable` and is not used by the advancement. It uses `Marker:1b` only to remove its own hitbox so it cannot intercept clicks meant for the interaction entity. `Marker:1b` is not used on clickable entities.

The advancement reward calls `simple_waystone:interaction/right_click_waystone`, which immediately revokes the advancement from the player so future interactions should be able to trigger again.

## Item-Based Creation

Player-facing creation uses a custom echo-shard-based Waystone Core item. A lodestone-based core was removed after runtime testing confirmed that it placed a real lodestone block when used.

The previous polling-based prototype was removed. Runtime testing also showed that `minecraft:item_used_on_block` does not fire for echo shards. The current design gives the custom echo shard a long-duration `minecraft:consumable` component and uses a `minecraft:using_item` advancement that matches a `minecraft:echo_shard` carrying `minecraft:custom_data`:

- `simple_waystone:{core:1b}`

The advancement reward calls `simple_waystone:item/use_core` and immediately revokes `simple_waystone:use_waystone_core` so the item can trigger repeatedly. The reward function also verifies that the player is still holding the custom core before consuming anything.

This keeps normal usage item-free after creation: the expensive cost is paid only when a waystone is created, and teleporting remains free.

The Waystone Core is consumed during item-based creation. The item-created cost is the core, one normal lodestone, 16 ender eyes, and 4 diamond blocks. The admin/testing function `simple_waystone:admin/create_here` still exists because it supports conservative macro-provided plain names and is useful for validation, server operators, and debugging. Item-based creation currently uses a simple readable name, `Waystone`.

## Clicked Entity Resolution

Vanilla advancement rewards run as the player, but this prototype does not assume a direct reliable mcfunction handle to the clicked entity. After the tagged interaction advancement fires, the handler resolves the nearest tagged waystone within four blocks.

This is a constrained fallback used to decide whether the player is close enough to a waystone to open the destination dialog. If it proves unreliable in Minecraft Java Edition 26.1.2, the interaction hitbox dimensions or advancement predicate should be adjusted directly.

## Dialog Destination Menu

Right-clicking a waystone opens a Java Edition datapack dialog from `data/simple_waystone/dialog/destinations.json`. The dialog is intended to use the vanilla dialog UI, not a chest/container GUI and not a tellraw chat menu.

The first implementation is intentionally static: it has buttons for waystone ids 1 through 8. Datapack dialog JSON cannot currently enumerate arbitrary waystone entities and names at runtime in this prototype, so labels are `Waystone #1` through `Waystone #8`.

Each button runs a non-OP-safe trigger command. In the dialog JSON command payload, this is written without the leading slash:

```mcfunction
trigger sws.select set 1
```

`simple_waystone:menu/open` enables `sws.select` for the player before showing the dialog. A lightweight tick function then processes only players with pending `sws.select` values, teleports them to the matching loaded waystone entity in the current dimension, and resets the score. This keeps command execution out of direct `/function` access for normal players.

Selecting a deleted, missing, unloaded, cross-dimension, or out-of-range waystone id shows an error and consumes no items. Teleporting remains free.

The static dialog can still display buttons for ids that were deleted because the dialog JSON is fixed. The selection processor validates the chosen id against live `minecraft:interaction` hitboxes before teleporting; if no matching live hitbox exists, it resets `sws.select` and reports `[Simple Waystone] That destination no longer exists.`

`simple_waystone:admin/cleanup` is a safe maintenance function for loaded chunks. It clears pending selection/destination tags, removes any optional stale `simple_waystone:waystones` storage list if present, and removes orphaned visual markers or name labels that no longer have a live interaction hitbox with the same `sws.id`.

`simple_waystone:admin/delete_all` additionally resets `#next sws.id` to `0`, so a full wipe returns the prototype id state to empty.

## Cost Model

Creating a waystone is intentionally expensive so waystones feel like server infrastructure rather than a disposable travel item. Using an existing waystone is free, and deletion does not refund items.

The readable default cost lives in `storage simple_waystone:config` and is initialized by `simple_waystone:config/default`:

- `minecraft:lodestone` x1
- `minecraft:ender_eye` x16
- `minecraft:diamond_block` x4

Because plain mcfunction commands do not make fully dynamic item id and count consumption clean, the active implementation centralizes hardcoded cost commands in:

- `simple_waystone:internal/check_cost`
- `simple_waystone:internal/consume_cost`

The cost is checked without consuming items first. Items are only consumed after validation passes.

## Public API Direction

The initial admin command API is function-based. The current implementation expects a plain string macro argument:

- `/function simple_waystone:admin/create_here {name:"Hub"}`
- `/function simple_waystone:admin/create_here {name:"Mine"}`

Other public validation commands:

- `/function simple_waystone:item/give_core`
- `/function simple_waystone:admin/list`
- `/function simple_waystone:admin/delete_nearest`
- `/function simple_waystone:admin/delete_all`
- `/function simple_waystone:admin/cleanup`
- `/function simple_waystone:teleport/to_nearest`
- `/function simple_waystone:debug/state`
- `/function simple_waystone:debug/nearest`
- `trigger sws.select set <id>` through dialog button actions

The create function uses Minecraft function macros for the name. Macro behavior must be validated on Minecraft Java Edition 26.1.2 before public distribution.

## Known Limitations

- The dialog menu is limited to waystone ids 1 through 8.
- Static dialog buttons may remain visible for deleted ids, but selection validates live entities and rejects stale ids.
- The dialog display and action behavior require Minecraft Java Edition 26.1.2 runtime validation.
- Listing waystones only covers loaded waystone entities.
- Runtime validation confirmed echo-shard core creation, item consumption, visible marker creation, and readable display names.
- The visible marker is a visual-only `block_display`, not a real lodestone block.
- A lodestone-based Waystone Core was runtime-tested and rejected because it placed a real block.
- The `minecraft:interaction` right-click hitbox and dialog-opening path need runtime validation on Minecraft Java Edition 26.1.2.
- Right-click detection now uses `minecraft:interaction` and needs another in-game validation pass.
- Existing waystones created by older prototype versions may still have armor stand click targets; recreate them after updating the datapack.
- The nearest-waystone fallback may not always be the same as exact clicked-entity detection.
- Function macro behavior must be validated on Minecraft Java Edition 26.1.2.
- Creation cost is centralized but still limited by vanilla mcfunction command constraints.
- Command syntax is written for current vanilla datapack conventions, but Minecraft 26.1.2 runtime validation is still required.

See `docs/testing.md` for the manual validation plan and `docs/known-limitations.md` for a focused limitation summary.

## Target

- Minecraft Java Edition: 26.1.2
- Data pack format: 101.1
- Datapack namespace: `simple_waystone`
