class_name BaseWeapon
extends Node3D

const MAX_LIFETIME: float = 10.0
const MAX_VELOCITY: float = 100.0
const MAX_RANGE: float = 100.0

@export var player: Player

# --- Shooting variables ---
@onready var fire_cooldown_timer = $FireCooldown
@onready var bullet_instance = preload("res://scenes/weapons/Projectile.tscn")
# NOTE: get/set allow to modify ways in which we act on vars
# This set makes it so values are clamped when changed

@export var base_damage: float = 1.0
var current_damage: float 
@export var projectile_lifetime: float = 2.0:
	set(value):
		projectile_lifetime = clamp(value, 0.001, MAX_LIFETIME)
@export var projectile_velocity: float = 20.0:
	set(value):
		projectile_velocity = clamp(value, 1, MAX_VELOCITY)
@export var weapon_range: float = 20.0:
	set(value):
		weapon_range = clamp(value, 1, MAX_RANGE)
@export var fire_cooldown: float = 0.4:
	set(value):
		fire_cooldown_timer.wait_time = value


func _ready():
	current_damage = base_damage


func apply_scaling():
	pass # TODO: to scale damage of projectiles


func _on_weapon_range_area_found_enemies(enemy):
	if fire_cooldown_timer.is_stopped():
		var shoot_origin = player.bullet_origin.global_transform.origin
		# Spawn and shoot bullet
		var bullet = bullet_instance.instantiate()
		bullet.initialize(projectile_velocity, current_damage, projectile_lifetime, enemy)
		get_parent().add_child(bullet, true)
		bullet.global_transform.origin = shoot_origin
		bullet.look_at(enemy.global_position, Vector3.UP)
		fire_cooldown_timer.start()
