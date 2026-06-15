# Delete the nearest waystone within four blocks. Creation costs are not refunded.

scoreboard players set #delete sws.tmp -1
execute as @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run scoreboard players operation #delete sws.tmp = @s sws.id
execute unless entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"No waystone found within 4 blocks.","color":"red"}]
execute if entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Deleted nearest waystone. No items were refunded.","color":"yellow"}]
execute as @a if score @s sws.select = #delete sws.tmp run scoreboard players set @s sws.select 0
execute as @e[tag=sws.waystone] if score @s sws.id = #delete sws.tmp run kill @s
execute if score #delete sws.tmp matches 0.. run function simple_waystone:admin/cleanup
