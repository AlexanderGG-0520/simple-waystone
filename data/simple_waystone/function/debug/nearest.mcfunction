# Print the nearest waystone near the executing player for manual validation.

tag @s add sws.debug_target
tellraw @s [{"text":"[Simple Waystone Debug] ","color":"gold"},{"text":"Nearest waystone within 4 blocks","color":"gray"}]
execute unless entity @e[type=minecraft:armor_stand,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"- none","color":"red"}]
execute as @e[type=minecraft:armor_stand,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run tellraw @a[tag=sws.debug_target] [{"text":"- id: ","color":"gray"},{"score":{"name":"@s","objective":"sws.id"},"color":"yellow"},{"text":" name: ","color":"gray"},{"selector":"@s","color":"aqua"}]
tag @s remove sws.debug_target
