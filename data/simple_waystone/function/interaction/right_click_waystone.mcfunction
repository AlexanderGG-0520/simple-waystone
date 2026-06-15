advancement revoke @s only simple_waystone:right_click_waystone

execute if data entity @s SelectedItem{id:"minecraft:name_tag"} if data entity @s SelectedItem.components."minecraft:custom_name" run function simple_waystone:rename/from_mainhand
execute if data entity @s SelectedItem{id:"minecraft:name_tag"} unless data entity @s SelectedItem.components."minecraft:custom_name" if data entity @s SelectedItem.components."minecraft:item_name" run function simple_waystone:rename/from_mainhand

execute unless data entity @s SelectedItem{id:"minecraft:name_tag"} run tellraw @s {"text":"[Simple Waystone] Opening menu...","color":"gray"}
execute unless data entity @s SelectedItem{id:"minecraft:name_tag"} run function simple_waystone:menu/open

execute if data entity @s SelectedItem{id:"minecraft:name_tag"} unless data entity @s SelectedItem.components."minecraft:custom_name" unless data entity @s SelectedItem.components."minecraft:item_name" run tellraw @s {"text":"[Simple Waystone] Rename requires a renamed Name Tag.","color":"red"}
