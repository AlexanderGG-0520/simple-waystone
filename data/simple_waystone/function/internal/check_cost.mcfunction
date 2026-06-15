# Centralized default creation cost check:
# - minecraft:lodestone x1
# - minecraft:ender_eye x16
# - minecraft:diamond_block x4
#
# clear ... 0 counts matching items without consuming them.

scoreboard players set @s sws.has_cost 0
execute store result score #cost.lodestone sws.tmp run clear @s minecraft:lodestone 0
execute store result score #cost.ender_eye sws.tmp run clear @s minecraft:ender_eye 0
execute store result score #cost.diamond_block sws.tmp run clear @s minecraft:diamond_block 0

execute if score #cost.lodestone sws.tmp matches 1.. if score #cost.ender_eye sws.tmp matches 16.. if score #cost.diamond_block sws.tmp matches 4.. run scoreboard players set @s sws.has_cost 1
