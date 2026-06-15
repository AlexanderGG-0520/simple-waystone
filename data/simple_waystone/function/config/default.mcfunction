# Human-readable default configuration.
# The active cost checks are centralized in internal/check_cost and internal/consume_cost.

execute unless data storage simple_waystone:config creation_cost run data modify storage simple_waystone:config creation_cost set value [{id:"minecraft:lodestone",count:1},{id:"minecraft:ender_eye",count:16},{id:"minecraft:diamond_block",count:4}]
