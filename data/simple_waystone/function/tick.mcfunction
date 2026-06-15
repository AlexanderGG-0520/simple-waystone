# Lightweight item-use poll for the player-facing Waystone Core flow.

execute as @a[scores={sws.use_core=1..}] at @s run function simple_waystone:player/use_core
