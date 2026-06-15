# Give the player-facing Waystone Core item.
# Component syntax is written for Minecraft Java Edition 26.1.2 and needs runtime validation.

give @s minecraft:echo_shard[minecraft:custom_name='{"text":"Waystone Core","color":"aqua","italic":false}',minecraft:custom_data={simple_waystone:{core:1b}}] 1
tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Received a Waystone Core. Right-click a block with it to create a waystone if you have the remaining cost.","color":"gray"}]
