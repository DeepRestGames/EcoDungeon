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
@export var speed: float = 3.0

# Path calculation variables
const NAVIGATION_COOLDOWN_MODIFIER_BASE: float = 0.1
var navigation_step_cooldown: float = .4
var navigation_step_cooldown_counter: float = 0.0

@onready var xp_shard_template = preload("res://scenes/objects/XpPickup.tscn")

# Combat variables
@export var max_hp: float = 5.0
var current_hp: float = max_hp:
	set(value):
		current_hp = clamp(value, 0, max_hp)
@export var damage: float = 1.0

# NOTE Do these variables need to be declared for every enemy?
# Damage number variables
@export var dmg_label_height: float = 10
@export var dmg_label_spread: float = 10
@onready var damage_number_3d_template = preload("res://scenes/weapons/DamageNumber3D.tscn")


func _ready():
	var navigation_cooldown_modifier = randf_range(-NAVIGATION_COOLDOWN_MODIFIER_BASE, NAVIGATION_COOLDOWN_MODIFIER_BASE)
	navigation_step_cooldown += navigation_cooldown_modifier


func _physics_process(delta):
	if not player:
		return
	
	# Navigation calculation optimization
	navigation_step_cooldown_counter -= delta
	if navigation_step_cooldown_counter < 0.0:
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - position).normalized() * speed
		
		navigation_step_cooldown_counter = navigation_step_cooldown
	
	# Path calculation variables
	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision and collision.get_collider() is Player:
		player.take_damage(damage)

func take_damage(damage: float):
	current_hp -= damage
	show_damage(damage)
	
	if current_hp <= 0:
		_death()

func show_damage(damage: float):
	# TODO/NOTE: this is identical in player.
	var damage_floating_label = damage_number_3d_template.instantiate()
	var pos = global_position
	var level_root =  get_tree().get_root()
	level_root.add_child(damage_floating_label, true)
	damage_floating_label.set_values_and_animate(str(damage), pos, dmg_label_height, dmg_label_spread)

func _death():
	var dropped_shard = xp_shard_template.instantiate()
	var pos = global_position
	var level_root =  get_tree().get_root()
	level_root.add_child(dropped_shard, true)
	dropped_shard.set_values(pos)
	queue_free()
