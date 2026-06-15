# Print global Simple Waystone prototype state for manual validation.

tellraw @s [{"text":"[Simple Waystone Debug] ","color":"gold"},{"text":"Global state","color":"gray"}]
tellraw @s [{"text":"- next id: ","color":"gray"},{"score":{"name":"#next","objective":"sws.id"},"color":"yellow"}]
tellraw @s [{"text":"- configured creation cost storage: ","color":"gray"},{"nbt":"creation_cost","storage":"simple_waystone:config","color":"yellow"}]
execute store result score #debug.count sws.tmp if entity @e[type=minecraft:armor_stand,tag=sws.waystone,tag=sws.clickable]
tellraw @s [{"text":"- loaded clickable waystones present: ","color":"gray"},{"score":{"name":"#debug.count","objective":"sws.tmp"},"color":"yellow"}]
execute store result score #debug.visual sws.tmp if entity @e[type=minecraft:block_display,tag=sws.waystone,tag=sws.visual]
tellraw @s [{"text":"- loaded visual markers present: ","color":"gray"},{"score":{"name":"#debug.visual","objective":"sws.tmp"},"color":"yellow"}]
