# Create objectives used by the prototype.

scoreboard objectives add sws.id dummy
scoreboard objectives add sws.tmp dummy
scoreboard objectives add sws.has_cost dummy
scoreboard objectives add sws.use_core minecraft.used:minecraft.carrot_on_a_stick

execute unless score #next sws.id matches 0.. run scoreboard players set #next sws.id 0
