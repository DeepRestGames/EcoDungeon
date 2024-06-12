class_name BaseWeapon
extends Node3D

const MIN_DAMAGE: float = 0.1
const MAX_DAMAGE: float = 100.0
const MIN_LIFETIME: float = 0.001
const MAX_LIFETIME: float = 10.0
const MIN_VELOCITY: float = 1.0
const MAX_VELOCITY: float = 100.0
const MIN_RANGE: float = 1.0
const MAX_RANGE: float = 100.0
const MIN_COOLDOWN: float = 0.1
const MAX_COOLDOWN: float = 5.0

@export var player: Player

# --- Shooting variables ---
@onready var fire_cooldown_timer = $FireCooldown
@onready var weapon_range_collider = $WeaponRangeArea/WeaponRangeCollider
@onready var bullet_instance = preload("res://scenes/weapons/Projectile.tscn")
# NOTE: get/set allow to modify ways in which we act on vars
# This set makes it so values are clamped when changed

@export var base_damage: float = 1.0
var current_damage: float:
	set(value):
		current_damage = clamp(value, MIN_DAMAGE, MAX_DAMAGE)
@export var projectile_lifetime: float = 2.0:
	set(value):
		projectile_lifetime = clamp(value, MIN_LIFETIME, MAX_LIFETIME)
@export var projectile_velocity: float = 20.0:
	set(value):
		projectile_velocity = clamp(value, MIN_VELOCITY, MAX_VELOCITY)
@export var weapon_range: float = 15.0:
	set(value):
		weapon_range = clamp(value, MIN_RANGE, MAX_RANGE)
		weapon_range_collider.update_range()
@export var fire_cooldown: float = 0.4:
	set(value):
		fire_cooldown = clamp(value, MIN_COOLDOWN, MAX_COOLDOWN)
		fire_cooldown_timer.wait_time = fire_cooldown


func _ready():
	current_damage = base_damage


func apply_scaling():
	pass # TODO: to scale damage of projectiles


func _on_weapon_range_area_found_enemies(enemy):
	if fire_cooldown_timer.is_stopped():
		var shoot_origin = player.bullet_origin.global_transform.origin
		# Spawn and shoot bullet
		var bullet = bullet_instance.instantiate()
		var level_root =  get_tree().get_root()
		bullet.initialize(projectile_velocity, current_damage, projectile_lifetime, enemy)
		level_root.add_child(bullet, true)
		bullet.global_transform.origin = shoot_origin
		bullet.look_at(enemy.global_position, Vector3.UP)
		fire_cooldown_timer.start()
