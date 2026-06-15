# Manual In-Game Test Plan

This datapack has not yet been runtime-tested in Minecraft Java Edition 26.1.2. Use this checklist in a disposable test world before public distribution.

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
/give @s minecraft:lodestone 2
/give @s minecraft:ender_eye 32
/give @s minecraft:diamond_block 8
```

This gives enough items for two default-cost waystones.

## Create A Waystone Named Hub

The current implementation expects `name` to be a JSON text component string passed through a function macro:

```mcfunction
/function simple_waystone:admin/create_here {name:'{"text":"Hub","color":"aqua","italic":false}'}
```

Expected:

- one lodestone, sixteen ender eyes, and four diamond blocks are consumed;
- an invisible armor stand with visible name `Hub` is created at your position;
- a message similar to `[Simple Waystone] Created waystone #1.` appears.

## Create A Second Waystone Named Mine

Move to a different location and run:

```mcfunction
/function simple_waystone:admin/create_here {name:'{"text":"Mine","color":"gold","italic":false}'}
```

Expected:

- the second set of cost items is consumed;
- a second named waystone armor stand is created;
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

Stand near the visible name of a waystone and right-click where the invisible armor stand should be.

Expected:

- the advancement reward runs;
- the advancement is revoked after handling, allowing repeated tests;
- the same free nearest-waystone behavior runs.

If nothing happens:

- verify the armor stand was created without `Marker:1b`;
- run `/function simple_waystone:debug/nearest` while standing near the name;
- try clicking around the armor stand body, not only the floating name;
- inspect logs for advancement or command parsing errors.

## Delete The Nearest Waystone

Stand within four blocks of one waystone and run:

```mcfunction
/function simple_waystone:admin/delete_nearest
```

Expected:

- the nearest waystone armor stand is killed;
- no items are refunded;
- a deletion message appears.

Run the list command again to confirm it is gone from loaded entities.

## Delete All Waystones

Run:

```mcfunction
/function simple_waystone:admin/delete_all
```

Expected:

- all loaded Simple Waystone armor stands are killed;
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
- `sws.id`, `sws.tmp`, and `sws.has_cost` exist.

To inspect nearby waystone entity data, stand near one and run:

```mcfunction
/data get entity @e[type=minecraft:armor_stand,tag=sws.waystone,sort=nearest,limit=1]
```

Expected: entity data includes `Invisible`, `Invulnerable`, `NoGravity`, `PersistenceRequired`, `Silent`, `CustomName`, and the `sws.waystone` / `sws.clickable` tags.

## Retest Right-Click Advancement

The right-click reward function is expected to revoke the advancement automatically. If manual reset is needed while testing, run:

```mcfunction
/advancement revoke @s only simple_waystone:right_click_waystone
```

## Expected Failure Cases

### Missing Cost

Without the required items, run:

```mcfunction
/function simple_waystone:admin/create_here {name:'{"text":"No Cost","color":"aqua","italic":false}'}
```

Expected:

- a missing-cost message appears;
- no items are consumed;
- no waystone is created;
- the next id does not advance.

### Missing Macro Argument

Run:

```mcfunction
/function simple_waystone:admin/create_here
```

Expected: Minecraft should reject or fail the macro invocation because `name` is required by macro lines. No commands in the function should run.

### Invalid Name Component

Run a command with malformed JSON in `name`.

Expected: Minecraft should fail to parse the expanded macro command. No cost should be consumed if the macro function fails before execution.

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
