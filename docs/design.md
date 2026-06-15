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

The clickable interaction entity is still an invisible armor stand with:

- tags `sws.waystone` and `sws.clickable`;
- a stable numeric id in the `sws.id` scoreboard objective;
- a visible `CustomName`;
- its actual entity position and dimension as the teleport target.

The `block_display` also has the same `sws.id` value and the tags `sws.waystone` and `sws.visual`, so delete operations can remove both pieces together.

The design prefers teleporting to the clickable waystone entity itself instead of treating raw coordinates as the primary target. The entity naturally carries its dimension by existing in that dimension.

## Armor Stand Interaction

Right-click detection is implemented with an advancement in `data/simple_waystone/advancement/` using the `minecraft:player_interacted_with_entity` trigger. The predicate is intended to match only armor stands tagged as Simple Waystone entities, but it still requires in-game validation on Minecraft Java Edition 26.1.2.

The armor stand is:

- invisible;
- invulnerable;
- gravity-free;
- persistent;
- silent;
- not marked with `Marker:1b`.

`Marker:1b` is intentionally avoided because marker armor stands have an extremely small hitbox and are unreliable as right-click targets.

The advancement reward calls `simple_waystone:interaction/right_click_waystone`, which immediately revokes the advancement from the player so future interactions should be able to trigger again.

## Item-Based Creation

Player-facing creation uses a custom lodestone-based Waystone Core item.

The previous polling-based prototype was removed. The current design uses a `minecraft:item_used_on_block` advancement that matches a `minecraft:lodestone` carrying `minecraft:custom_data`:

- `simple_waystone:{core:1b}`

The advancement reward calls `simple_waystone:item/use_core` and immediately revokes `simple_waystone:use_waystone_core` so the item can trigger repeatedly.

This keeps normal usage item-free after creation: the expensive cost is paid only when a waystone is created, and teleporting remains free.

The Waystone Core is consumed during item-based creation and counts as the lodestone part of the cost. The remaining item-created cost is 16 ender eyes and 4 diamond blocks. The admin/testing function `simple_waystone:admin/create_here` still exists because it supports precise macro-provided names and is useful for validation, server operators, and debugging. Item-based creation currently uses a generated name like `Waystone #<id>`.

## Clicked Entity Resolution

Vanilla advancement rewards run as the player, but this prototype does not assume a direct reliable mcfunction handle to the clicked entity. After the tagged armor stand advancement fires, the handler resolves the nearest tagged waystone within four blocks.

This is a constrained fallback, not a destination-selection system. If this proves unreliable in Minecraft Java Edition 26.1.2, the armor stand approach should be documented as blocked before switching to another entity type.

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

The initial command API is function-based. The current implementation expects the macro argument as a JSON text component string:

- `/function simple_waystone:admin/create_here {name:'{"text":"Hub","color":"aqua","italic":false}'}`
- `/function simple_waystone:admin/create_here {name:'{"text":"Mine","color":"gold","italic":false}'}`

The desired simple UX below is a future improvement, not current behavior:

- `/function simple_waystone:admin/create_here {name:"Hub"}`

Other public validation commands:

- `/function simple_waystone:item/give_core`
- `/function simple_waystone:admin/list`
- `/function simple_waystone:admin/delete_nearest`
- `/function simple_waystone:admin/delete_all`
- `/function simple_waystone:teleport/to_nearest`
- `/function simple_waystone:debug/state`
- `/function simple_waystone:debug/nearest`

The create function uses Minecraft function macros for the name. Macro behavior must be validated on Minecraft Java Edition 26.1.2 before public distribution.

## Known Limitations

- Destination list UI is not implemented.
- The current right-click behavior teleports the player to the same nearest waystone entity, primarily validating interaction and entity resolution.
- Listing waystones only covers loaded waystone entities.
- Runtime behavior has not been tested in Minecraft Java Edition 26.1.2 from this repository.
- The visible marker is a visual-only `block_display`, not a real lodestone block.
- `minecraft:item_used_on_block` behavior and `minecraft:custom_data` item predicate syntax need runtime validation on Minecraft Java Edition 26.1.2.
- Right-click detection may need adjustment after in-game testing.
- Invisible armor stands may be hard for players to interact with.
- The nearest-waystone fallback may not always be the same as exact clicked-entity detection.
- Function macro behavior must be validated on Minecraft Java Edition 26.1.2.
- Creation cost is centralized but still limited by vanilla mcfunction command constraints.
- Command syntax is written for current vanilla datapack conventions, but Minecraft 26.1.2 runtime validation is still required.

See `docs/testing.md` for the manual validation plan and `docs/known-limitations.md` for a focused limitation summary.

## Target

- Minecraft Java Edition: 26.1.2
- Data pack format: 101.1
- Datapack namespace: `simple_waystone`
