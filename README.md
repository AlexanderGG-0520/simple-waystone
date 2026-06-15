# Simple Waystone

Simple Waystone is a lightweight vanilla Minecraft datapack for a simple waystone / teleport marker system.

The project targets **Minecraft Java Edition 26.1.2** and data pack format **101.1**. It is designed primarily for server-side use on vanilla-compatible servers, with no client mod, plugin, or external dependency required.

## Status

Early development. The currently implemented prototype is designed to support visible waystone markers, multiple named waystone entities, expensive waystone creation, free waystone use, and armor stand right-click detection through an advancement. It still requires in-game validation on Minecraft Java Edition 26.1.2.

This is not a finished destination-selection system yet. The expected prototype behavior is that right-clicking a waystone resolves the nearest tagged waystone within four blocks and teleports the player to that same entity, which is mainly useful for validating the interaction path.

## Installation

1. Download or clone this repository.
2. Copy the datapack folder into your world's `datapacks/` directory.
3. Start or reload the world.
4. Run `/reload` if the world is already running.
5. Confirm the datapack is enabled with `/datapack list`.

## Planned Direction

- Keep the system small and readable.
- Prefer vanilla commands and datapack features.
- Add simple server-side waystone registration and teleport behavior.
- Avoid heavy per-tick logic unless a feature clearly requires it.
- Keep files clean enough for public distribution.

## Waystone Representation

Waystones currently use two aligned entities:

- a visible `minecraft:block_display` showing a lodestone block as a visual-only marker;
- an invisible, invulnerable armor stand used for right-click interaction and teleport targeting.

The lodestone marker is not a real placed block, so creating a waystone should not modify or replace world blocks. Deleting a waystone removes both the visual marker and the clickable armor stand when their internal id matches.

## Player-Facing Creation

The current player-facing creation item is a custom echo-shard-based Waystone Core. Runtime testing showed that a lodestone-based core placed a real lodestone block, so the core uses the non-placeable `minecraft:echo_shard` item instead. Use the helper function to receive one:

```mcfunction
/function simple_waystone:item/give_core
```

The helper gives a `minecraft:echo_shard` with a custom name and `minecraft:custom_data` marker. The custom data, not the display name, is the intended item identity. Right-clicking a block with the Waystone Core is expected to create a visible waystone at the player's position if the player has the full creation cost.

The item-created waystone cost is:

- Waystone Core x1
- `minecraft:lodestone` x1
- `minecraft:ender_eye` x16
- `minecraft:diamond_block` x4

Item-created waystones currently receive a simple readable visible name, `Waystone`. Custom names are still available through the admin/testing function.

The item flow uses `minecraft:item_used_on_block` advancement detection and rewards `simple_waystone:item/use_core`. This behavior still requires Minecraft Java Edition 26.1.2 runtime validation.

## Public Functions

Run these commands as an operator or from an appropriate command context.

### Create a Named Waystone

This admin/testing function remains available for precise named creation:

The current implementation expects a plain string name:

```mcfunction
/function simple_waystone:admin/create_here {name:"Hub"}
/function simple_waystone:admin/create_here {name:"Mine"}
```

JSON text component arguments are intentionally avoided for now because runtime testing showed raw JSON could render in-world instead of a readable name.

This function uses Minecraft function macros. The `name` value is inserted into a simple text component used as the armor stand `CustomName`.

Creating a waystone consumes the configured creation cost only after the cost check passes.

Current default creation cost:

- `minecraft:lodestone` x1
- `minecraft:ender_eye` x16
- `minecraft:diamond_block` x4

The readable cost configuration is stored in `storage simple_waystone:config` by `simple_waystone:config/default`. Because fully dynamic item ids and counts are not practical in plain mcfunction command lines, the active cost check and consumption commands are centralized in:

- `simple_waystone:internal/check_cost`
- `simple_waystone:internal/consume_cost`

### List Loaded Waystones

```mcfunction
/function simple_waystone:admin/list
```

Lists currently loaded waystone armor stand entities.

### Delete Waystones

```mcfunction
/function simple_waystone:admin/delete_nearest
/function simple_waystone:admin/delete_all
```

Deleting a waystone does not refund the creation cost.

### Use the Nearest Waystone

```mcfunction
/function simple_waystone:teleport/to_nearest
```

Using a waystone is free. The current prototype is expected to teleport the executing player to the nearest tagged waystone entity within four blocks.

### Debug Functions

```mcfunction
/function simple_waystone:debug/state
/function simple_waystone:debug/nearest
```

These functions print useful validation state without adding spammy behavior.

## Command Examples

All command examples are written as single executable lines for Minecraft chat or a server console with the leading slash where appropriate.

```mcfunction
/reload
/datapack list
/give @s minecraft:lodestone 3
/give @s minecraft:ender_eye 48
/give @s minecraft:diamond_block 12
/function simple_waystone:item/give_core
/function simple_waystone:admin/create_here {name:"Hub"}
/function simple_waystone:admin/create_here {name:"Mine"}
/function simple_waystone:admin/list
/function simple_waystone:debug/state
/function simple_waystone:debug/nearest
/function simple_waystone:teleport/to_nearest
/function simple_waystone:admin/delete_nearest
/function simple_waystone:admin/delete_all
/data get storage simple_waystone:config
/data get entity @e[type=minecraft:armor_stand,tag=sws.waystone,sort=nearest,limit=1]
/data get entity @e[type=minecraft:block_display,tag=sws.visual,sort=nearest,limit=1]
/advancement revoke @s only simple_waystone:right_click_waystone
/advancement revoke @s only simple_waystone:use_waystone_core
```

## Current Limitations

- The prototype uses invisible, invulnerable armor stands instead of interaction entities because armor stands are the requested target for this project.
- The visible lodestone marker is a `block_display`, not a real block.
- The Waystone Core uses `minecraft:echo_shard`; a lodestone-based core was rejected because it placed a real block during runtime testing.
- The current Waystone Core item flow depends on `minecraft:item_used_on_block` matching `minecraft:custom_data`; this still needs runtime validation.
- The clickable armor stand intentionally does not use `Marker:1b`, because marker armor stands have a very small hitbox.
- Advancement rewards run as the player but do not provide a simple direct mcfunction handle for the clicked entity. The right-click handler therefore uses a nearest tagged waystone fallback within four blocks.
- The function macro creation command must be revalidated on Minecraft Java Edition 26.1.2 after simplifying name handling.
- Destination selection is not implemented yet.
- The latest fixes require another Minecraft Java Edition 26.1.2 runtime validation pass before public distribution.

See [docs/testing.md](docs/testing.md) and [docs/known-limitations.md](docs/known-limitations.md).

## Target Version

- Minecraft Java Edition: 26.1.2
- Data pack format: 101.1

## License

MIT License. See [LICENSE](LICENSE).
