# Give the player-facing Waystone Core item.
# Component syntax is written for Minecraft Java Edition 26.1.2 and needs runtime validation.

give @s minecraft:echo_shard[minecraft:item_name={text:"Waystone Core",color:"aqua",italic:0b},minecraft:custom_data={simple_waystone:{core:1b}},minecraft:consumable={consume_seconds:1000000.0f,animation:"none",has_consume_particles:0b}] 1
tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Received a Waystone Core. Hold right-click with it to create a waystone if you have the full cost.","color":"gray"}]
