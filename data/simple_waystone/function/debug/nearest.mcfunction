# Print the nearest waystone near the executing player for manual validation.

tag @s add sws.debug_target
tellraw @s [{"text":"[Simple Waystone Debug] ","color":"gold"},{"text":"Nearest waystone within 4 blocks","color":"gray"}]
execute unless entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"- clickable hitbox: none","color":"red"}]
execute as @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..4,sort=nearest,limit=1] run tellraw @a[tag=sws.debug_target] [{"text":"- clickable id: ","color":"gray"},{"score":{"name":"@s","objective":"sws.id"},"color":"yellow"},{"text":" selector: ","color":"gray"},{"selector":"@s","color":"aqua"}]
execute unless entity @e[type=minecraft:block_display,tag=sws.waystone,tag=sws.visual,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"- visual marker: none","color":"red"}]
execute if entity @e[type=minecraft:block_display,tag=sws.waystone,tag=sws.visual,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"- visual marker: nearby","color":"gray"}]
execute unless entity @e[type=minecraft:armor_stand,tag=sws.waystone,tag=sws.label,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"- name label: none","color":"red"}]
execute if entity @e[type=minecraft:armor_stand,tag=sws.waystone,tag=sws.label,distance=..4,sort=nearest,limit=1] run tellraw @s [{"text":"- name label: nearby","color":"gray"}]
tag @s remove sws.debug_target
