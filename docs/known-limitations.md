# Known Limitations

Simple Waystone is currently an implementation prototype that requires in-game validation on Minecraft Java Edition 26.1.2.

## Runtime Validation

- Runtime testing found and fixed the previous lodestone core, echo-shard trigger, raw JSON name, and armor stand click-target issues. The clickable chat menu display fix still needs Minecraft Java Edition 26.1.2 runtime validation.
- JSON files have been validated with `jq`, but command parsing and advancement behavior still need Minecraft runtime validation.
- Function macro behavior must be tested on the target version.

## Function Macros

The creation function currently expects a plain string `name` argument:

```mcfunction
/function simple_waystone:admin/create_here {name:"Hub"}
/function simple_waystone:admin/create_here {name:"Mine"}
```

JSON text component arguments are avoided because runtime testing showed they could render as raw JSON text in-world.

## Interaction Hitbox

- Runtime testing showed that the previous invisible armor stand click target did not open the clickable chat menu reliably.
- New waystones use an invisible `minecraft:interaction` entity as the clickable hitbox and keep the armor stand only as a readable name label.
- Runtime validation confirmed the interaction hitbox can trigger the right-click reward and print the menu-opening message.
- The visible lodestone marker is a `block_display`; it is not a real placed block and does not itself handle clicks.
- The datapack does not use `Marker:1b` for clickable entities. The separate armor stand name label may use `Marker:1b` so it does not intercept clicks.
- The current advancement reward does not use an exact clicked-entity handle. It resolves the nearest tagged waystone within four blocks after the advancement fires.
- Existing waystones made before this change may need to be deleted and recreated so they receive the new interaction hitbox.

## Item-Based Creation

- The current Waystone Core is a custom `minecraft:echo_shard` item with `minecraft:custom_data`.
- Runtime validation confirmed the current echo-shard Waystone Core creation flow.
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

- Destination selection uses a fixed Java Edition clickable chat menu with buttons for waystone ids 1 through 8.
- Deleted ids can still appear as clickable chat buttons, but selection is validated against live `minecraft:interaction` hitboxes and stale ids are rejected safely.
- Dialog display and `trigger sws.select set <id>` button action behavior require Minecraft Java Edition 26.1.2 runtime validation.
- The clickable chat menu does not dynamically list waystone names and has no pagination yet.
- Teleporting from the clickable chat menu targets the selected loaded waystone entity in the current dimension and is free.
- Listing only includes loaded waystone entities.
- A lightweight tick function is used only to process players with pending `sws.select` trigger values.
- `simple_waystone:admin/cleanup` only repairs loaded chunks. It cannot clean unloaded waystone entities until those chunks are loaded.
