class_name WeaponPowerupSystem
extends Node


enum PowerupModifierType {
	ADD,
	MULTIPLY
}


@onready var base_weapon: BaseWeapon = $".."
@onready var powerup_menu_ui = $"../../UI/PowerupMenu"
var weapon_powerups: Array [WeaponPowerup] = []


func _ready():
	weapon_powerups.clear()
	powerup_menu_ui.new_powerup.connect(add_powerup)


func add_powerup(powerup: WeaponPowerup):
	weapon_powerups.append(powerup)
	
	_apply_powerup_modifiers(powerup)
	
	print("Added new powerup! New stats:\n")
	print("Damage: " + str(base_weapon.current_damage))
	print("Projectile lifetime: " + str(base_weapon.projectile_lifetime))
	print("Projectile velocity: " + str(base_weapon.projectile_velocity))
	print("Range: " + str(base_weapon.weapon_range))
	print("Fire cooldown: " + str(base_weapon.fire_cooldown))
	print("Projectiles number: " + str(base_weapon.current_projectiles_number))
	print("Explosion range/damage: " + str(base_weapon.explosion_range) + '/'+ str(base_weapon.explosion_damage))
	print("Pierce: " + str(base_weapon.piercing_amount))
	print("-----------------------------------------------------------")


func _apply_powerup_modifiers(powerup: WeaponPowerup):
	# Fire cooldown
	match powerup.fire_cooldown_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.fire_cooldown += powerup.fire_cooldown_modifier_value
		PowerupModifierType.MULTIPLY:
			base_weapon.fire_cooldown *= powerup.fire_cooldown_modifier_value
	
	# Projectile lifetime
	match powerup.projectile_lifetime_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.projectile_lifetime += powerup.projectile_lifetime_modifier_value
		PowerupModifierType.MULTIPLY:
			base_weapon.projectile_lifetime *= powerup.projectile_lifetime_modifier_value
	
	# Projectile velocity
	match powerup.projectile_velocity_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.projectile_velocity += powerup.projectile_velocity_modifier_value
		PowerupModifierType.MULTIPLY:
			base_weapon.projectile_velocity *= powerup.projectile_velocity_modifier_value
	
	# Range
	match powerup.range_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.weapon_range += powerup.range_modifier_value
		PowerupModifierType.MULTIPLY:
			base_weapon.weapon_range *= powerup.range_modifier_value
	
	# Damage
	match powerup.damage_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.current_damage += powerup.damage_modifier_value
		PowerupModifierType.MULTIPLY:
			base_weapon.current_damage *= powerup.damage_modifier_value
	
	# Projectiles number
	match powerup.projectiles_number_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.current_projectiles_number += powerup.projectiles_number_modifier_value
	# If number of projectiles is updated recalculate projectiles origins
	if powerup.projectiles_number_modifier_value != 0:
		base_weapon.update_projectiles_origins()
	
	# Homing projectiles
	if powerup.homing_projectiles_modifier_value == true:
		base_weapon.homing_projectiles = true
	
	# Explosion range
	match powerup.explosion_radius_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.explosion_range += powerup.explosion_radius_value
		PowerupModifierType.MULTIPLY:
			base_weapon.explosion_range *= powerup.explosion_radius_value
	
	# Explosion damage
	match powerup.explosion_damage_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.explosion_damage += powerup.explosion_damage_value
		PowerupModifierType.MULTIPLY:
			base_weapon.explosion_damage *= powerup.explosion_damage_value
			
	# Pierce value
	match powerup.projectile_pierce_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.piercing_amount += powerup.projectile_pierce_value
		PowerupModifierType.MULTIPLY:
			base_weapon.piercing_amount *= powerup.projectile_pierce_value
