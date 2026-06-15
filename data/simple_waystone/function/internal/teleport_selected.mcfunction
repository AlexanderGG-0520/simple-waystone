# Teleport the selecting player to the selected loaded waystone entity.

scoreboard players operation #selected sws.tmp = @s sws.select
scoreboard players set @s sws.select 0
tag @e[tag=sws.destination] remove sws.destination
execute as @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable] if score @s sws.id = #selected sws.tmp run tag @s add sws.destination
execute unless entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,tag=sws.destination,limit=1] run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Selected waystone is not available in this loaded dimension.","color":"red"}]
execute if entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,tag=sws.destination,limit=1] run tp @s @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,tag=sws.destination,limit=1]
execute if entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,tag=sws.destination,limit=1] run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Teleported for free.","color":"green"}]
tag @e[tag=sws.destination] remove sws.destination
