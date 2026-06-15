data modify entity @e[type=minecraft:interaction,tag=sws.clickable,scores={sws.id=4},limit=1] CustomName set from storage simple_waystone:rename name
data modify entity @e[type=minecraft:armor_stand,tag=sws.label,scores={sws.id=4},limit=1] CustomName set from storage simple_waystone:rename name
clear @s minecraft:name_tag 1
tellraw @s {"text":"[Simple Waystone] Waystone renamed.","color":"green"}
