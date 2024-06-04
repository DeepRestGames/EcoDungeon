extends Node3D

const MAX_LIFETIME: float = 10.0
const MAX_VELOCITY: float = 100.0
const MAX_RANGE: float = 100.0

@export var player: Player

# --- Shooting variables ---
@onready var fire_cooldown = $FireCooldown 
@onready var bullet_instance = preload("res://scenes/Projectile.tscn")

# NOTE: get/set allow to modify ways in which we act on vars
# This set makes it so values are clamped when changed

@export var projectile_lifetime: float = 2.0:
	set(value):
		projectile_lifetime = clamp(projectile_lifetime, 1, MAX_LIFETIME)
@export var bullet_velocity: float = 20.0:
	set(value):
		bullet_velocity = clamp(bullet_velocity, 1, MAX_VELOCITY)
@export var weapon_range: float = 20.0:
	set(value):
		weapon_range = clamp(weapon_range, 1, MAX_RANGE)
@export var base_damage: float = 1.0
var current_damage: float 

func _ready():
	current_damage = base_damage

func apply_scaling():
	pass # TODO: to scale damage of projectiles


func _on_weapon_range_area_found_enemies(enemy_pos):
	var shoot_origin = player.shoot_from.global_transform.origin
	
	# Spawn and shoot bullet
	var bullet = bullet_instance.instantiate()
	get_parent().add_child(bullet, true)
	bullet.global_transform.origin = shoot_origin
	bullet.look_at(enemy_pos, Vector3.UP)
	#bullet.add_collision_exception_with(self)
