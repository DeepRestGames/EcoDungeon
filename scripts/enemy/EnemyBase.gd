class_name EnemyBase
extends CharacterBody3D
## Base class for all enemies
##
## This script offers all the base functionalities that an Enemy must have.
## It is meant to be overridden, to extend the different AI behaviours.
##


@onready var nav_agent = $NavigationAgent3D
@export var SPEED: float = 5.0
@export var max_hp: int = 5
var current_hp: int = max_hp
var target: Node3D = null


func update_target(new_target: Node3D):
	target = new_target


func take_damage(damage: int):
	current_hp -= damage
