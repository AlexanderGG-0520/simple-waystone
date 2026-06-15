# Known Limitations

Simple Waystone is currently an implementation prototype that requires in-game validation on Minecraft Java Edition 26.1.2.

## Runtime Validation

- Runtime testing found the previous lodestone core and raw JSON name issues; the current echo-shard core and readable-name fixes still need revalidation on Minecraft Java Edition 26.1.2.
- JSON files have been validated with `jq`, but command parsing and advancement behavior still need Minecraft runtime validation.
- Function macro behavior must be tested on the target version.

## Function Macros

The creation function currently expects a plain string `name` argument:

```mcfunction
/function simple_waystone:admin/create_here {name:"Hub"}
/function simple_waystone:admin/create_here {name:"Mine"}
```

JSON text component arguments are avoided because runtime testing showed they could render as raw JSON text in-world.

## Armor Stand Interaction

- Right-click detection may need adjustment after in-game testing.
- Invisible armor stands may be hard for players to interact with, even without `Marker:1b`.
- The visible lodestone marker is a `block_display`; it is not a real placed block and does not itself handle clicks.
- The datapack intentionally does not use `Marker:1b` because marker armor stands have a very small hitbox.
- The current advancement reward does not use an exact clicked-entity handle. It resolves the nearest tagged waystone within four blocks after the advancement fires.

## Item-Based Creation

- The current Waystone Core is a custom `minecraft:echo_shard` item with `minecraft:custom_data`.
- The item component syntax and advancement item predicate syntax need runtime validation on Minecraft Java Edition 26.1.2.
- Detection uses `minecraft:using_item` with a long-duration `minecraft:consumable` component, not tick polling.
- A normal `minecraft:echo_shard` should not match the advancement because it lacks the Simple Waystone custom data marker.
- A lodestone-based Waystone Core was runtime-tested and rejected because it placed a real lodestone block.
- `minecraft:item_used_on_block` was runtime-tested and did not fire for echo shard use.
- The exact clicked block position may not be directly available to the reward function, so the current prototype creates the waystone at the player position.
- Item-created waystones use a simple readable name, `Waystone`. Custom naming currently uses the admin/testing function.

## Cost Configuration

- The readable default cost is centralized in `storage simple_waystone:config`.
- The active item checks and consumption commands are centralized in `internal/check_cost` and `internal/consume_cost`.
- Fully dynamic item ids and counts are still limited by vanilla mcfunction command constraints, so changing the cost currently requires updating those centralized functions.

## Prototype Scope

- Destination selection is not implemented.
- Teleporting currently targets the nearest tagged waystone entity within four blocks.
- Listing only includes loaded waystone entities.
- No tick logic is used.
