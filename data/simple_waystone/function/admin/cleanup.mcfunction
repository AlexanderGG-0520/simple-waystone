# Remove transient state and orphaned waystone pieces from loaded chunks.
# Live minecraft:interaction hitboxes are the source of truth.

scoreboard players set @a[scores={sws.select=1..}] sws.select 0
tag @e[tag=sws.destination] remove sws.destination
execute if data storage simple_waystone:waystones waystones run data remove storage simple_waystone:waystones waystones

tag @e[type=minecraft:block_display,tag=sws.waystone,tag=sws.visual] add sws.cleanup_orphan
tag @e[type=minecraft:armor_stand,tag=sws.waystone,tag=sws.label] add sws.cleanup_orphan
execute as @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable] run function simple_waystone:internal/mark_live_parts
kill @e[tag=sws.cleanup_orphan]

tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Cleanup complete for loaded waystone state.","color":"yellow"}]
