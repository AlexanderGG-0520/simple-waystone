# Create a named waystone at the executing player's position.
# Requires a function macro argument:
# /function simple_waystone:admin/create_here {name:"Hub"}

function simple_waystone:internal/ensure_config
function simple_waystone:internal/check_cost

execute unless score @s sws.has_cost matches 1 run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Missing creation cost: 1 lodestone, 16 ender eyes, and 4 diamond blocks.","color":"red"}]
execute if score @s sws.has_cost matches 1 run function simple_waystone:internal/consume_cost
execute if score @s sws.has_cost matches 1 run function simple_waystone:internal/next_id
$execute if score @s sws.has_cost matches 1 run summon minecraft:armor_stand ~ ~ ~ {Invisible:1b,Invulnerable:1b,NoGravity:1b,PersistenceRequired:1b,Silent:1b,CustomName:'{"text":"$(name)","color":"aqua","italic":false}',CustomNameVisible:1b,Tags:["sws.waystone","sws.clickable","sws.pending"]}
execute if score @s sws.has_cost matches 1 as @e[type=minecraft:armor_stand,tag=sws.pending,sort=nearest,limit=1,distance=..2] run scoreboard players operation @s sws.id = #next sws.id
execute if score @s sws.has_cost matches 1 as @e[type=minecraft:armor_stand,tag=sws.pending,sort=nearest,limit=1,distance=..2] run tag @s remove sws.pending
$execute if score @s sws.has_cost matches 1 run tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Created waystone #","color":"green"},{"score":{"name":"#next","objective":"sws.id"},"color":"green"},{"text":" named ","color":"green"},{"text":"$(name)","color":"aqua"},{"text":".","color":"green"}]
