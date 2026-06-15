# Give the current player-facing Waystone Core trigger item.
# Current prototype detection uses minecraft.used:minecraft.carrot_on_a_stick.

give @s minecraft:carrot_on_a_stick 1
tellraw @s [{"text":"[Simple Waystone] ","color":"gold"},{"text":"Received a Waystone Core prototype item. Use the carrot on a stick to create a waystone if you have the full cost.","color":"gray"}]
