class_name EnemyBase
extends CharacterBody3D
## Base class for all enemies
##
## This script offers all the base functionalities that an Enemy must have.
## It is meant to be overridden, to extend the different AI behaviours.
##

# Movement variables
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player: Player = $"../../Player"
@export var SPEED: float = 3.0

@onready var damage_number_3d_template = preload("res://scenes/weapons/DamageNumber3D.tscn")
# Combat variables
@export var max_hp: int = 5
var current_hp: int = max_hp:
	set(value):
		current_hp = clamp(value, 0, max_hp)
const DAMAGE: int = 1


func _physics_process(_delta):
	if not player:
		return
	
	velocity = Vector3.ZERO
	
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - position).normalized() * SPEED
	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision and collision.get_collider() is Player:
		player.take_damage(DAMAGE)

func take_damage(damage: int):
	current_hp -= damage	
	show_damage(damage)
	
	if current_hp <= 0:
		_death()

func show_damage(damage: float):
	var damage_floating_label = damage_number_3d_template.instantiate()
	var pos = global_position
	var height = 10
	var spread = 10
	var level_root =  get_tree().get_root()
	level_root.add_child(damage_floating_label, true)
	damage_floating_label.set_values_and_animate(str(damage), pos, height, spread)

func _death():
	queue_free()
