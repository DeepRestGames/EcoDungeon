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
const MIN_PROJECTILES_NUMBER: int = 1
const MAX_PROJECTILE_NUMBER: int = 4

@export var player: Player

# --- Shooting variables ---
@onready var fire_cooldown_timer = $FireCooldown
@onready var weapon_range_collider = $WeaponRangeArea/WeaponRangeCollider
@onready var projectile_instance = preload("res://scenes/weapons/Projectile.tscn")

# --- Projectiles origins ---
@onready var projectiles_origins = [$ProjectileOrigin01, $ProjectileOrigin02, $ProjectileOrigin03, $ProjectileOrigin04]

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
@export var base_projectiles_number: int = 1
var current_projectiles_number: int:
	set(value):
		current_projectiles_number = clamp(value, MIN_PROJECTILES_NUMBER, MAX_PROJECTILE_NUMBER)


func _ready():
	current_damage = base_damage
	current_projectiles_number = base_projectiles_number


func _on_weapon_range_area_enemies_found(enemies: Array):
	if fire_cooldown_timer.is_stopped():
		var level_root =  get_tree().get_root()
		
		for projectile_origin_index in current_projectiles_number:
			# Set enemy target, closest one first
			var enemy = enemies[projectile_origin_index % enemies.size()]
			
			var projectile = projectile_instance.instantiate()
			projectile.initialize(projectile_velocity, current_damage, projectile_lifetime, enemy)
			var shoot_origin = projectiles_origins[projectile_origin_index].global_transform.origin
			
			# Spawn and shoot projectile
			level_root.add_child(projectile, true)
			projectile.global_transform.origin = shoot_origin
			projectile.look_at(enemy.global_position, Vector3.UP)
		
		fire_cooldown_timer.start()
