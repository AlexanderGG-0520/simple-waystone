# Open the prototype destination dialog.

scoreboard players enable @s sws.select
tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Showing destination dialog...","color":"gray"}]
dialog show @s simple_waystone:destinations
