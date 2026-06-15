# Advancement reward for using a Waystone Core.
# The core item is a custom_data-marked echo shard. A normal echo shard must not match.

advancement revoke @s only simple_waystone:use_waystone_core
function simple_waystone:internal/ensure_config

scoreboard players set #core.held sws.tmp 0
execute if items entity @s weapon.mainhand minecraft:echo_shard[minecraft:custom_data~{simple_waystone:{core:1b}}] run scoreboard players set #core.held sws.tmp 1
execute if items entity @s weapon.offhand minecraft:echo_shard[minecraft:custom_data~{simple_waystone:{core:1b}}] run scoreboard players set #core.held sws.tmp 1

scoreboard players set @s sws.has_cost 0
execute store result score #core.ender_eye sws.tmp run clear @s minecraft:ender_eye 0
execute store result score #core.diamond_block sws.tmp run clear @s minecraft:diamond_block 0
execute store result score #core.lodestone sws.tmp run clear @s minecraft:lodestone 0
execute if score #core.held sws.tmp matches 1 if score #core.lodestone sws.tmp matches 1.. if score #core.ender_eye sws.tmp matches 16.. if score #core.diamond_block sws.tmp matches 4.. run scoreboard players set @s sws.has_cost 1

scoreboard players set @s sws.tmp 1
execute unless score #core.held sws.tmp matches 1 run scoreboard players set @s sws.tmp 0
execute if entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..2,sort=nearest,limit=1] run scoreboard players set @s sws.tmp 0
execute unless score @s sws.has_cost matches 1 run scoreboard players set @s sws.tmp 0

execute unless score #core.held sws.tmp matches 1 run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Hold the Waystone Core while using it.","color":"red"}]
execute if score #core.held sws.tmp matches 1 unless score @s sws.has_cost matches 1 run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Waystone Core needs: 1 lodestone, 16 ender eyes, and 4 diamond blocks.","color":"red"}]
execute if score @s sws.has_cost matches 1 if score @s sws.tmp matches 0 run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"A waystone is already too close to this location.","color":"red"}]
scoreboard players set #core.consumed sws.tmp 0
scoreboard players set #core.consume_attempt sws.tmp 0
execute if score @s sws.tmp matches 1 run scoreboard players set #core.consume_attempt sws.tmp 1
execute if score @s sws.tmp matches 1 store result score #core.consumed sws.tmp run clear @s minecraft:echo_shard[minecraft:custom_data~{simple_waystone:{core:1b}}] 1
execute if score @s sws.tmp matches 1 unless score #core.consumed sws.tmp matches 1.. run scoreboard players set @s sws.tmp 0
execute if score #core.consume_attempt sws.tmp matches 1 unless score #core.consumed sws.tmp matches 1.. run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Waystone Core could not be consumed; no waystone was created.","color":"red"}]
execute if score @s sws.tmp matches 1 run clear @s minecraft:lodestone 1
execute if score @s sws.tmp matches 1 run clear @s minecraft:ender_eye 16
execute if score @s sws.tmp matches 1 run clear @s minecraft:diamond_block 4
execute if score @s sws.tmp matches 1 run function simple_waystone:internal/next_id
execute if score @s sws.tmp matches 1 run summon minecraft:block_display ~-0.5 ~ ~-0.5 {block_state:{Name:"minecraft:lodestone"},Tags:["sws.waystone","sws.visual","sws.pending"]}
execute if score @s sws.tmp matches 1 run summon minecraft:interaction ~ ~ ~ {width:1.1f,height:1.5f,response:1b,Tags:["sws.waystone","sws.clickable","sws.pending"]}
execute if score @s sws.tmp matches 1 run summon minecraft:armor_stand ~ ~ ~ {Invisible:1b,Invulnerable:1b,NoGravity:1b,Marker:1b,PersistenceRequired:1b,Silent:1b,CustomName:{text:"Waystone",color:"aqua",italic:0b},CustomNameVisible:1b,Tags:["sws.waystone","sws.label","sws.pending"]}
execute if score @s sws.tmp matches 1 as @e[tag=sws.pending,sort=nearest,distance=..3] run scoreboard players operation @s sws.id = #next sws.id
execute if score @s sws.tmp matches 1 as @e[tag=sws.pending,sort=nearest,distance=..3] run tag @s remove sws.pending
execute if score @s sws.tmp matches 1 run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Created visible Waystone #","color":"green"},{"score":{"name":"#next","objective":"sws.id"},"color":"green"},{"text":".","color":"green"}]
