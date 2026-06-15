# List registered waystone interaction hitboxes visible to commands in loaded chunks.

tag @s add sws.listing
tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Known loaded waystones:","color":"gray"}]
execute unless entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable] run tellraw @s [{"text":"- none","color":"gray"}]
execute as @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable] run tellraw @a[tag=sws.listing] [{"text":"- #","color":"gray"},{"score":{"name":"@s","objective":"sws.id"},"color":"yellow"},{"text":" ","color":"gray"},{"selector":"@s","color":"aqua"}]
tag @s remove sws.listing
