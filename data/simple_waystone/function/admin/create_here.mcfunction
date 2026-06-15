# Create a named waystone at the executing player's position.
# Requires a function macro argument:
# /function simple_waystone:admin/create_here {name:"Hub"}

function simple_waystone:internal/ensure_config
function simple_waystone:internal/check_cost

scoreboard players set @s sws.tmp 1
execute if entity @e[type=minecraft:interaction,tag=sws.waystone,tag=sws.clickable,distance=..2,sort=nearest,limit=1] run scoreboard players set @s sws.tmp 0
execute unless score @s sws.has_cost matches 1 run scoreboard players set @s sws.tmp 0

execute unless score @s sws.has_cost matches 1 run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Missing creation cost: 1 lodestone, 16 ender eyes, and 4 diamond blocks.","color":"red"}]
execute if score @s sws.has_cost matches 1 if score @s sws.tmp matches 0 run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"A waystone is already too close to this location.","color":"red"}]
execute if score @s sws.tmp matches 1 run function simple_waystone:internal/consume_cost
execute if score @s sws.tmp matches 1 run function simple_waystone:internal/next_id
execute if score @s sws.tmp matches 1 run summon minecraft:block_display ~-0.5 ~ ~-0.5 {block_state:{Name:"minecraft:lodestone"},Tags:["sws.waystone","sws.visual","sws.pending"]}
execute if score @s sws.tmp matches 1 run summon minecraft:interaction ~ ~ ~ {width:1.1f,height:1.5f,response:1b,Tags:["sws.waystone","sws.clickable","sws.pending"]}
$execute if score @s sws.tmp matches 1 run summon minecraft:armor_stand ~ ~ ~ {Invisible:1b,Invulnerable:1b,NoGravity:1b,Marker:1b,PersistenceRequired:1b,Silent:1b,CustomName:{text:"$(name)",color:"aqua",italic:0b},CustomNameVisible:1b,Tags:["sws.waystone","sws.label","sws.pending"]}
execute if score @s sws.tmp matches 1 as @e[tag=sws.pending,sort=nearest,distance=..3] run scoreboard players operation @s sws.id = #next sws.id
execute if score @s sws.tmp matches 1 as @e[tag=sws.pending,sort=nearest,distance=..3] run tag @s remove sws.pending
execute if score @s sws.tmp matches 1 run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Created visible waystone #","color":"green"},{"score":{"name":"#next","objective":"sws.id"},"color":"green"},{"text":".","color":"green"}]
