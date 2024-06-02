class_name EnemyBase
extends CharacterBody3D
## Base class for all enemies
##
## This script offers all the base functionalities that an Enemy must have.
## It is meant to be overridden, to extend the different AI behaviours.
##

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player: Player = $"../../Player"

@export var SPEED: float = 5.0
@export var max_hp: int = 5
var current_hp: int = max_hp


func _physics_process(_delta):
	velocity = Vector3.ZERO
	
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	#velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	velocity = (next_nav_point - position).normalized() * SPEED
	move_and_slide()


func take_damage(damage: int):
	current_hp -= damage
