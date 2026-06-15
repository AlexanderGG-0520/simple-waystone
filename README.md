# Simple Waystone

Simple Waystone is a lightweight vanilla Minecraft datapack for a simple waystone / teleport marker system.

The project targets **Minecraft Java Edition 26.1.2** and data pack format **101.1**. It is designed primarily for server-side use on vanilla-compatible servers, with no client mod, plugin, or external dependency required.

## Status

Early development. The currently implemented prototype is designed to support multiple named waystone marker entities, expensive waystone creation, free waystone use, and armor stand right-click detection through an advancement. It still requires in-game validation on Minecraft Java Edition 26.1.2.

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

## Public Functions

Run these commands as an operator or from an appropriate command context.

### Create a Named Waystone

The current implementation requires the `name` argument to be a JSON text component string:

```mcfunction
/function simple_waystone:admin/create_here {name:'{"text":"Hub","color":"aqua","italic":false}'}
/function simple_waystone:admin/create_here {name:'{"text":"Mine","color":"gold","italic":false}'}
```

The simpler command format below is a future UX improvement, not current behavior:

```mcfunction
/function simple_waystone:admin/create_here {name:"Hub"}
```

This function uses Minecraft function macros. The `name` value is expected to be a JSON text component string used as the armor stand `CustomName`.

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

These functions print useful validation state without adding tick logic.

## Command Examples

All command examples are written as single executable lines for Minecraft chat or a server console with the leading slash where appropriate.

```mcfunction
/reload
/datapack list
/give @s minecraft:lodestone 2
/give @s minecraft:ender_eye 32
/give @s minecraft:diamond_block 8
/function simple_waystone:admin/create_here {name:'{"text":"Hub","color":"aqua","italic":false}'}
/function simple_waystone:admin/create_here {name:'{"text":"Mine","color":"gold","italic":false}'}
/function simple_waystone:admin/list
/function simple_waystone:debug/state
/function simple_waystone:debug/nearest
/function simple_waystone:teleport/to_nearest
/function simple_waystone:admin/delete_nearest
/function simple_waystone:admin/delete_all
/data get storage simple_waystone:config
/data get entity @e[type=minecraft:armor_stand,tag=sws.waystone,sort=nearest,limit=1]
/advancement revoke @s only simple_waystone:right_click_waystone
```

## Current Limitations

- The prototype uses invisible, invulnerable armor stands instead of interaction entities because armor stands are the requested target for this project.
- The clickable armor stand intentionally does not use `Marker:1b`, because marker armor stands have a very small hitbox.
- Advancement rewards run as the player but do not provide a simple direct mcfunction handle for the clicked entity. The right-click handler therefore uses a nearest tagged waystone fallback within four blocks.
- The function macro creation command must be validated on Minecraft Java Edition 26.1.2. The current expected format passes `name` as a JSON text component string.
- Destination selection is not implemented yet.
- Runtime behavior has not been validated in Minecraft Java Edition 26.1.2 from this repository.

See [docs/testing.md](docs/testing.md) and [docs/known-limitations.md](docs/known-limitations.md).

## Target Version

- Minecraft Java Edition: 26.1.2
- Data pack format: 101.1

## License

MIT License. See [LICENSE](LICENSE).
