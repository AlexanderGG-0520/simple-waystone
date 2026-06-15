# Simple Waystone

Simple Waystone is a lightweight vanilla Minecraft datapack for a simple waystone / teleport marker system.

The project targets **Minecraft Java Edition 26.1.2** and data pack format **101.1**. It is designed primarily for server-side use on vanilla-compatible servers, with no client mod, plugin, or external dependency required.

## Status

Early development. The current prototype supports multiple named waystone marker entities, expensive waystone creation, free waystone use, and armor stand right-click detection through an advancement.

This is not a finished destination-selection system yet. Right-clicking a waystone currently resolves the nearest tagged waystone within four blocks and teleports the player to that same entity, which is mainly useful for validating the interaction path.

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

```mcfunction
/function simple_waystone:admin/create_here {name:"Hub"}
/function simple_waystone:admin/create_here {name:"Mining Base"}
```

This function uses Minecraft function macros. The `name` value is inserted into the armor stand `CustomName`, so keep names simple and avoid embedded quotes.

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

Using a waystone is free. The current prototype teleports the executing player to the nearest tagged waystone entity within four blocks.

## Current Limitations

- The prototype uses invisible, invulnerable armor stands instead of interaction entities because armor stands are the requested target for this project.
- The clickable armor stand intentionally does not use `Marker:1b`, because marker armor stands have a very small hitbox.
- Advancement rewards run as the player but do not provide a simple direct mcfunction handle for the clicked entity. The right-click handler therefore uses a nearest tagged waystone fallback within four blocks.
- Destination selection is not implemented yet.
- Runtime behavior has not been validated in Minecraft Java Edition 26.1.2 from this repository.

## Target Version

- Minecraft Java Edition: 26.1.2
- Data pack format: 101.1

## License

MIT License. See [LICENSE](LICENSE).
