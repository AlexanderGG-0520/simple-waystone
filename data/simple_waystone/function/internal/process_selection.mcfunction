# Process pending /trigger selections from the waystone dialog.

execute as @a[scores={sws.select=1..}] at @s run function simple_waystone:internal/teleport_selected
