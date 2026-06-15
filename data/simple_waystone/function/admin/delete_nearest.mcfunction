# Delete the nearest waystone within four blocks. Creation costs are not refunded.

execute unless entity @e[type=minecraft:armor_stand,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"No waystone found within 4 blocks.","color":"red"}]
execute if entity @e[type=minecraft:armor_stand,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Deleted nearest waystone. No items were refunded.","color":"yellow"}]
kill @e[type=minecraft:armor_stand,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1]
