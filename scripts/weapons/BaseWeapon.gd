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
const MAX_PROJECTILE_NUMBER: int = 10

@export var player: Player

# --- Shooting variables ---
@onready var fire_cooldown_timer = $FireCooldown
@onready var weapon_range_collider = $WeaponRangeArea/WeaponRangeCollider
@onready var projectile_instance = preload("res://scenes/weapons/Projectile.tscn")

# --- Projectiles origins ---
const PROJECTILE_ORIGIN_DISTANCE_FROM_CENTER = 0.5
@onready var projectiles_origins_node = $ProjectilesOrigins
@onready var default_projectiles_origin = $ProjectilesOrigins/ProjectileOrigin01
var projectiles_origins: Array

# --- Statistics ---
@export var base_damage: float = 1.0
var current_damage: float:
	set(value):
		current_damage = clamp(value, MIN_DAMAGE, MAX_DAMAGE)
@export var projectile_lifetime: float = 2.0:
	set(value):
		projectile_lifetime = clamp(value, MIN_LIFETIME, MAX_LIFETIME)
@export var projectile_velocity: float = 10.0:
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

# --- Powerups ---
var homing_projectiles = false


func _ready():
	current_damage = base_damage
	current_projectiles_number = base_projectiles_number
	projectiles_origins.append(default_projectiles_origin)


func _on_weapon_range_area_enemies_found(enemies: Array):
	if fire_cooldown_timer.is_stopped():
		var level_root =  get_tree().get_root()
		
		for projectile_origin_index in current_projectiles_number:
			# Set enemy target, closest one first
			var enemy = enemies[projectile_origin_index % enemies.size()]
			
			# Create new projectile targeting enemy target
			var projectile = projectile_instance.instantiate()
			# Set enemy as target to follow if weapon has homing powerup
			if homing_projectiles:
				projectile.initialize(projectile_velocity, current_damage, projectile_lifetime, enemy)
			else:
				projectile.initialize(projectile_velocity, current_damage, projectile_lifetime)
			
			# Spawn projectile at its origin and shoot it
			var shoot_origin = projectiles_origins[projectile_origin_index].global_transform.origin
			level_root.add_child(projectile, true)
			projectile.global_transform.origin = shoot_origin
			projectile.look_at(enemy.global_position, Vector3.UP)
		
		fire_cooldown_timer.start()


func update_projectiles_origins():
	# Reset origins array, leave only default one
	projectiles_origins = projectiles_origins.slice(0, 1)
	
	# Calculate angle between points
	var radians_step = deg_to_rad(360 / current_projectiles_number)
	
	# Position new projectiles origins
	for i in range(1, current_projectiles_number):
		var new_origin_x_position = PROJECTILE_ORIGIN_DISTANCE_FROM_CENTER * sin(i * radians_step)
		var new_origin_z_position = PROJECTILE_ORIGIN_DISTANCE_FROM_CENTER * cos(i * radians_step)
		
		var current_origin = default_projectiles_origin.duplicate()
		projectiles_origins_node.add_child(current_origin)
		current_origin.position = Vector3(new_origin_x_position, 0, new_origin_z_position)
		
		projectiles_origins.append(current_origin)

