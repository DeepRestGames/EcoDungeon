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

@onready var xp_shard_template = preload("res://scenes/objects/XpPickup.tscn")

# Combat variables
@export var max_hp: float = 5.0
var current_hp: float = max_hp:
	set(value):
		current_hp = clamp(value, 0, max_hp)
const DAMAGE: float = 1.0

# Damage number variables
@export var dmg_label_height: float = 10
@export var dmg_label_spread: float = 10
@onready var damage_number_3d_template = preload("res://scenes/weapons/DamageNumber3D.tscn")

const NORMAL_DMG_COLOR: Color = Color(1.0,1.0,1.0,1.0)
const POISON_DMG_COLOR: Color = Color(0.0235, 0.553, 0.218, 1.0)
const EXPLOSION_DMG_COLOR: Color = Color(1, 0.537, 0.208, 1.0)

# DoT handling
var dot_damage: float = 0.0
var dot_duration: float = 5.0
var dot_tick: float = 0.5

var dot_duration_timer: Timer = Timer.new()
var dot_tick_timer: Timer = Timer.new()

func _init():
	dot_duration_timer.one_shot = true
	dot_tick_timer.one_shot = true
	add_child(dot_duration_timer)
	add_child(dot_tick_timer)

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
		
func _process(_delta):
	if not dot_duration_timer.is_stopped():
		#print(dot_duration_timer.time_left)
		# Apply damage and restart
		#print(dot_tick_timer.is)
		if dot_tick_timer.is_stopped():
			#print(dot_tick_timer.time_left)	
			take_damage(dot_damage, POISON_DMG_COLOR)
			dot_tick_timer.start()
	else:
		dot_damage = 0.0

func take_damage(damage: float, label_color: Color):
	current_hp -= damage
	show_damage(damage, label_color)
	
	if current_hp <= 0:
		_death()
		
func gain_dot(dot_dmg, dot_dur, dot_tick_freq):
	dot_damage = dot_dmg
	dot_duration = dot_dur
	dot_tick = dot_tick_freq
	
	dot_duration_timer.wait_time = dot_duration

		
	# Refresh if hit again
	dot_duration_timer.start()
	# Refresh ticks only if stopped
	if dot_tick_timer.is_stopped():
		dot_tick_timer.wait_time = dot_tick
		dot_tick_timer.start()	

func show_damage(damage: float, label_color: Color):
	# TODO/NOTE: this is identical in player.
	var damage_floating_label = damage_number_3d_template.instantiate()
	var pos = global_position
	var level_root =  get_tree().get_root()
	level_root.add_child(damage_floating_label, true)
	damage_floating_label.set_values_and_animate(str(damage), pos, dmg_label_height, dmg_label_spread, label_color)

func _death():
	var dropped_shard = xp_shard_template.instantiate()
	var pos = global_position
	var level_root =  get_tree().get_root()
	level_root.add_child(dropped_shard, true)
	dropped_shard.set_values(pos)
	queue_free()
