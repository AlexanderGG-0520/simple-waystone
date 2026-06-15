# Delete every Simple Waystone armor stand. Creation costs are not refunded.

tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Deleting all waystones. No items will be refunded.","color":"yellow"}]
kill @e[type=minecraft:armor_stand,tag=sws.waystone,tag=sws.clickable]
