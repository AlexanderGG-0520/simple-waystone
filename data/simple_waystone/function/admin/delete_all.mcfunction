# Delete every loaded Simple Waystone entity. Creation costs are not refunded.

tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Deleting all waystones. No items will be refunded.","color":"yellow"}]
kill @e[tag=sws.waystone]
scoreboard players set @a[scores={sws.select=1..}] sws.select 0
tag @e[tag=sws.destination] remove sws.destination
execute if data storage simple_waystone:waystones waystones run data remove storage simple_waystone:waystones waystones
scoreboard players set #next sws.id 0
