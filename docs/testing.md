# Manual In-Game Test Plan

Some runtime validation has been performed, and it found the previous lodestone core and raw JSON name issues. Use this checklist in a disposable Minecraft Java Edition 26.1.2 test world to revalidate the current fixes before public distribution.

## Install

1. Create or open a Minecraft Java Edition 26.1.2 test world with cheats enabled, or use an operator account on a test server.
2. Copy the repository folder into the world's `datapacks/` directory.
3. Start the world or server.
4. Run:

```mcfunction
/reload
```

5. Confirm the datapack is listed:

```mcfunction
/datapack list
```

Expected: the datapack appears in the enabled datapack list.

## Verify Load And Init

Run:

```mcfunction
/function simple_waystone:debug/state
```

Expected:

- a `[Simple Waystone Debug]` message;
- `next id` is shown, usually `0` before any waystone is created;
- configured creation cost storage shows lodestone, ender eye, and diamond block entries.

If this function is unknown, check that the datapack installed with `pack.mcmeta` at the datapack root.

## Give Required Items

Run:

```mcfunction
/give @s minecraft:lodestone 3
/give @s minecraft:ender_eye 48
/give @s minecraft:diamond_block 12
/function simple_waystone:item/give_core
```

This gives enough items for one Waystone Core-created waystone and two admin-created waystones.

## Verify Waystone Core Identity

After running `simple_waystone:item/give_core`, hold the received item and run:

```mcfunction
/data get entity @s SelectedItem
```

Expected:

- the item id is `minecraft:echo_shard`;
- the item displays a readable name, `Waystone Core`, not raw JSON text;
- the item has an item name component similar to `Waystone Core`;
- the item has `minecraft:custom_data` containing `simple_waystone:{core:1b}`.
- the item has a `minecraft:consumable` component so right-click can trigger `minecraft:using_item`.

The custom data is the important identity marker. A normal `minecraft:echo_shard` should not trigger waystone creation.

## Create A Visible Waystone With The Core Item

Hold right-click with the Waystone Core received from `simple_waystone:item/give_core`. Test both while looking at air and while looking at a block.

Expected:

- the Waystone Core, one normal lodestone, sixteen ender eyes, and four diamond blocks are consumed;
- a visible lodestone `block_display` marker appears;
- an invisible clickable armor stand with a readable visible name, `Waystone`, is created at the marker;
- a message similar to `[Simple Waystone] Created visible Waystone #1.` appears.

Run:

```mcfunction
/function simple_waystone:debug/nearest
```

Expected: the nearest clickable waystone id is printed.

Run:

```mcfunction
/data get entity @e[type=minecraft:block_display,tag=sws.visual,sort=nearest,limit=1]
```

Expected: the nearest visual marker has a lodestone `block_state` and the `sws.waystone` / `sws.visual` tags. The matching `sws.id` is stored as a scoreboard value, not NBT.

## Create A Waystone Named Hub

The current implementation expects a plain string `name` passed through a function macro:

```mcfunction
/function simple_waystone:admin/create_here {name:"Hub"}
```

Expected:

- one lodestone, sixteen ender eyes, and four diamond blocks are consumed;
- a visible lodestone `block_display` marker appears;
- an invisible armor stand with visible name `Hub` is created at the same location;
- a message similar to `[Simple Waystone] Created visible waystone #<id>.` appears.

## Create A Second Waystone Named Mine

Move to a different location and run:

```mcfunction
/function simple_waystone:admin/create_here {name:"Mine"}
```

Expected:

- the second set of cost items is consumed;
- a second visible marker and named waystone armor stand are created;
- the created id advances.

## List Waystones

Run:

```mcfunction
/function simple_waystone:admin/list
```

Expected:

- a `[Simple Waystone] Known loaded waystones:` message;
- entries for loaded waystone armor stands with their scoreboard ids.

Only waystones in loaded chunks are expected to appear.

## Inspect Nearest Waystone

Stand within four blocks of a waystone and run:

```mcfunction
/function simple_waystone:debug/nearest
```

Expected: the nearest waystone id and selector display are printed.

Move more than four blocks away and run it again.

Expected: `- none`.

## Test Free Teleport To Nearest

Stand within four blocks of a waystone and run:

```mcfunction
/function simple_waystone:teleport/to_nearest
```

Expected:

- no items are consumed;
- a `[Simple Waystone] Using nearest waystone for free.` message appears;
- the player teleports to the nearest tagged waystone entity.

## Test Right-Click Interaction

Stand near the visible lodestone marker and right-click where the invisible armor stand should be.

Expected:

- the advancement reward runs;
- the advancement is revoked after handling, allowing repeated tests;
- the Simple Waystone dialog opens with destination buttons.
- button labels are readable, such as `Waystone #1`.

If nothing happens:

- verify the armor stand was created without `Marker:1b`;
- run `/function simple_waystone:debug/nearest` while standing near the name;
- try clicking around the visible marker and armor stand body, not only the floating name;
- inspect logs for advancement or command parsing errors.

## Test Dialog Destination Selection

Create at least two waystones, then right-click one of them to open the dialog.

Expected:

- the UI is the Java Edition dialog-style menu, not a chest GUI and not chat text;
- the title is `Simple Waystone`;
- the body says `Select a destination.`;
- destination buttons are shown for `Waystone #1` through `Waystone #8`.

Select an existing destination.

Expected:

- the dialog action runs `/trigger sws.select set <id>`;
- the lightweight tick processor teleports the player to the selected loaded waystone entity in the current dimension;
- no items are consumed;
- `sws.select` resets to `0`, so the player is not repeatedly teleported.

To inspect the selection score after teleporting, run:

```mcfunction
/scoreboard players get @s sws.select
```

Expected: the score is `0`.

Delete a waystone, then open the dialog and select its old id.

Expected:

- a clear error says the selected waystone is not available in this loaded dimension;
- no items are consumed;
- `sws.select` resets to `0`.

Test with a non-OP player if possible.

Expected:

- the player can use the dialog because the button action uses `/trigger`, not direct `/function` execution.

## Delete The Nearest Waystone

Stand within four blocks of one waystone and run:

```mcfunction
/function simple_waystone:admin/delete_nearest
```

Expected:

- the nearest waystone armor stand is killed;
- the matching visible `block_display` marker is killed;
- no items are refunded;
- a deletion message appears.

Run the list command again to confirm it is gone from loaded entities.

## Delete All Waystones

Run:

```mcfunction
/function simple_waystone:admin/delete_all
```

Expected:

- all loaded Simple Waystone clickable armor stands and visual markers are killed;
- no items are refunded.

## Inspect Storage And Scoreboards

Run:

```mcfunction
/data get storage simple_waystone:config
/scoreboard players get #next sws.id
/scoreboard objectives list
```

Expected:

- config storage contains the default creation cost;
- there is currently no separate `simple_waystone:waystones` storage; waystone state is held on loaded armor stand entities and scoreboards;
- `#next sws.id` equals the highest assigned id;
- `sws.id`, `sws.tmp`, `sws.has_cost`, and `sws.select` exist.

To inspect nearby waystone entity data, stand near one and run:

```mcfunction
/data get entity @e[type=minecraft:armor_stand,tag=sws.waystone,sort=nearest,limit=1]
```

Expected: entity data includes `Invisible`, `Invulnerable`, `NoGravity`, `PersistenceRequired`, `Silent`, `CustomName`, and the `sws.waystone` / `sws.clickable` tags.

The rendered in-world name should be readable, such as `Waystone`, `Hub`, or `Mine`. It should not display raw JSON text such as `[{"text":"Waystone"...}]`.

To inspect the visual marker, run:

```mcfunction
/data get entity @e[type=minecraft:block_display,tag=sws.visual,sort=nearest,limit=1]
```

Expected: entity data includes a lodestone `block_state` and the `sws.waystone` / `sws.visual` tags.

## Retest Right-Click Advancement

The right-click reward function is expected to revoke the advancement automatically. If manual reset is needed while testing, run:

```mcfunction
/advancement revoke @s only simple_waystone:right_click_waystone
```

## Expected Failure Cases

### Missing Cost

Without the required items, run:

```mcfunction
/function simple_waystone:admin/create_here {name:"NoCost"}
```

Expected:

- a missing-cost message appears;
- no items are consumed;
- no waystone is created;
- the next id does not advance.

Also test the item flow without cost by holding right-click with a Waystone Core.

Expected:

- a Waystone Core missing-cost message appears;
- the Waystone Core is not consumed;
- no visible marker or clickable armor stand is created.

If the message says the Waystone Core could not be consumed, inspect whether the custom echo shard was already removed or transformed before the reward function ran.

### Normal Echo Shard Does Not Trigger

Hold a normal echo shard and right-click:

```mcfunction
/give @s minecraft:echo_shard 1
```

Expected:

- no Simple Waystone creation message appears;
- no cost items are consumed;
- no waystone marker or clickable armor stand is created.

### Advancement Repeats

Create or receive another Waystone Core and hold right-click again after the first successful or failed test.

Expected:

- the `simple_waystone:use_waystone_core` advancement has been revoked by `simple_waystone:item/use_core`;
- the trigger can fire again.

### Missing Macro Argument

Run:

```mcfunction
/function simple_waystone:admin/create_here
```

Expected: Minecraft should reject or fail the macro invocation because `name` is required by macro lines. No commands in the function should run.

### Complex Admin Names Are Not Supported Yet

Run a simple plain name first:

```mcfunction
/function simple_waystone:admin/create_here {name:"Hub"}
```

Expected: the in-world name is readable. Avoid embedded quotes or JSON text components in `name`; the prototype intentionally keeps admin names conservative after runtime testing showed raw JSON could render in-world.

### No Nearby Waystone

Run:

```mcfunction
/function simple_waystone:teleport/to_nearest
/function simple_waystone:admin/delete_nearest
```

while more than four blocks from any waystone.

Expected: failure messages appear and no waystone is deleted.

## Command Examples

These commands are duplicated here as a compact copy-paste checklist. Each command is a single executable line.

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
/trigger sws.select set 1
/function simple_waystone:admin/delete_nearest
/function simple_waystone:admin/delete_all
/data get storage simple_waystone:config
/data get entity @e[type=minecraft:armor_stand,tag=sws.waystone,sort=nearest,limit=1]
/data get entity @e[type=minecraft:block_display,tag=sws.visual,sort=nearest,limit=1]
/advancement revoke @s only simple_waystone:right_click_waystone
/advancement revoke @s only simple_waystone:use_waystone_core
```

## Tick Processing Check

Verify that item creation no longer uses tick polling, and that the only tick hook is for dialog selection processing:

```mcfunction
/scoreboard objectives list
```

Expected:

- there is no item-use polling objective for the Waystone Core flow;
- `sws.select` exists as a trigger objective;
- `data/minecraft/tags/function/tick.json` points to `simple_waystone:internal/process_selection`.
