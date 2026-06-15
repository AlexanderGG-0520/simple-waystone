# Delete every loaded Simple Waystone entity. Creation costs are not refunded.

tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Deleting all waystones. No items will be refunded.","color":"yellow"}]
kill @e[tag=sws.waystone]
