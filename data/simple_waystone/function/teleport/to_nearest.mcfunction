# Free teleport to the nearest waystone entity within four blocks.
# This is primarily useful for validating the prototype interaction path.

execute unless entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"No waystone found within 4 blocks.","color":"red"}]
execute if entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Using nearest waystone for free.","color":"green"}]
execute if entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run tp @s @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1]
