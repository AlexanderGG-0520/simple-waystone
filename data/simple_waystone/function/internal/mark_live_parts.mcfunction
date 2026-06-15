# Called as a live clickable waystone hitbox.

scoreboard players operation #live sws.tmp = @s sws.id
execute as @e[tag=sws.cleanup_orphan] if score @s sws.id = #live sws.tmp run tag @s remove sws.cleanup_orphan
