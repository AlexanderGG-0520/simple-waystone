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

The prototype represents each waystone as an in-world armor stand entity with:

- tags `sws.waystone` and `sws.clickable`;
- a stable numeric id in the `sws.id` scoreboard objective;
- a visible `CustomName`;
- its actual entity position and dimension as the teleport target.

The design prefers teleporting to the waystone entity itself instead of treating raw coordinates as the primary target. The entity naturally carries its dimension by existing in that dimension.

## Armor Stand Interaction

Right-click detection uses an advancement in `data/simple_waystone/advancement/` with the `minecraft:player_interacted_with_entity` trigger. The predicate only matches armor stands tagged as Simple Waystone entities.

The armor stand is:

- invisible;
- invulnerable;
- gravity-free;
- persistent;
- silent;
- not marked with `Marker:1b`.

`Marker:1b` is intentionally avoided because marker armor stands have an extremely small hitbox and are unreliable as right-click targets.

The advancement reward calls `simple_waystone:interaction/right_click_waystone`, which immediately revokes the advancement from the player so future interactions can trigger again.

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

The initial command API is function-based:

- `simple_waystone:admin/create_here {name:"Hub"}`
- `simple_waystone:admin/list`
- `simple_waystone:admin/delete_nearest`
- `simple_waystone:admin/delete_all`
- `simple_waystone:teleport/to_nearest`

The create function uses Minecraft function macros for the name. Names should stay simple and should not contain embedded quotes.

## Known Limitations

- Destination list UI is not implemented.
- The current right-click behavior teleports the player to the same nearest waystone entity, primarily validating interaction and entity resolution.
- Listing waystones only covers loaded waystone entities.
- Runtime behavior has not been tested in Minecraft Java Edition 26.1.2 from this repository.
- Command syntax is written for current vanilla datapack conventions, but Minecraft 26.1.2 runtime validation is still required.

## Target

- Minecraft Java Edition: 26.1.2
- Data pack format: 101.1
- Datapack namespace: `simple_waystone`
