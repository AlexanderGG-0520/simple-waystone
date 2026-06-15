# Advancement reward for right-clicking a tagged waystone interaction hitbox.
# The advancement is revoked so future right-clicks can trigger again.

advancement revoke @s only simple_waystone:right_click_waystone
execute unless entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Waystone interaction detected, but no nearby waystone could be resolved.","color":"red"}]
execute if entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Opening menu...","color":"gray"}]
execute if entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run function simple_waystone:menu/open
