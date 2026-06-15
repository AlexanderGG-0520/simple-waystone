# Known Limitations

Simple Waystone is currently an implementation prototype that requires in-game validation on Minecraft Java Edition 26.1.2.

## Runtime Validation

- The datapack has not yet been runtime-tested in Minecraft Java Edition 26.1.2.
- JSON files have been validated with `jq`, but command parsing and advancement behavior still need Minecraft runtime validation.
- Function macro behavior must be tested on the target version.

## Function Macros

The creation function currently expects the `name` argument as a JSON text component string:

```mcfunction
/function simple_waystone:admin/create_here {name:'{"text":"Hub","color":"aqua","italic":false}'}
/function simple_waystone:admin/create_here {name:'{"text":"Mine","color":"gold","italic":false}'}
```

The simpler form below is a future UX improvement, not the format expected by the current implementation:

```mcfunction
/function simple_waystone:admin/create_here {name:"Hub"}
```

This may become possible later with a separate wrapper or stricter name sanitization, but directly injecting arbitrary text into JSON/NBT command syntax is fragile.

## Armor Stand Interaction

- Right-click detection may need adjustment after in-game testing.
- Invisible armor stands may be hard for players to interact with, even without `Marker:1b`.
- The visible lodestone marker is a `block_display`; it is not a real placed block and does not itself handle clicks.
- The datapack intentionally does not use `Marker:1b` because marker armor stands have a very small hitbox.
- The current advancement reward does not use an exact clicked-entity handle. It resolves the nearest tagged waystone within four blocks after the advancement fires.

## Item-Based Creation

- The current Waystone Core is a custom `minecraft:lodestone` item with `minecraft:custom_data`.
- The item component syntax and advancement item predicate syntax need runtime validation on Minecraft Java Edition 26.1.2.
- Detection uses `minecraft:item_used_on_block`, not tick polling.
- A normal `minecraft:lodestone` should not match the advancement because it lacks the Simple Waystone custom data marker.
- Because the current Waystone Core is lodestone-based, in-game testing must confirm whether right-clicking a block places the item as a real lodestone before the advancement reward runs. If it does, this trigger design needs adjustment before public distribution.
- The exact clicked block position may not be directly available to the reward function, so the current prototype creates the waystone at the player position.
- Item-created waystones use generated names like `Waystone #<id>`. Custom naming currently uses the admin/testing function.

## Cost Configuration

- The readable default cost is centralized in `storage simple_waystone:config`.
- The active item checks and consumption commands are centralized in `internal/check_cost` and `internal/consume_cost`.
- Fully dynamic item ids and counts are still limited by vanilla mcfunction command constraints, so changing the cost currently requires updating those centralized functions.

## Prototype Scope

- Destination selection is not implemented.
- Teleporting currently targets the nearest tagged waystone entity within four blocks.
- Listing only includes loaded waystone entities.
- No tick logic is used.
