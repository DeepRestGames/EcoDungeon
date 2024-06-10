extends Node

# Note: To balance
const base_value: float = 100.0
const base_multiplier: float = 1.1
var current_level: int = 1
var xp_to_level: float = 100

var current_xp: float = 0:
	set(value):
		current_xp = value
		if current_xp >= xp_to_level:
			current_xp = 0
			level_up()


func level_up():
	current_level +=1
	xp_to_level =  ( xp_to_level + base_value ) * base_multiplier
	
