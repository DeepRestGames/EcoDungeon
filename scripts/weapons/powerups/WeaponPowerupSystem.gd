class_name WeaponPowerupSystem
extends Node


enum PowerupModifierType {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}


@onready var base_weapon: BaseWeapon = $".."
var weapon_powerups: Array [WeaponPowerup] = []


func _ready():
	weapon_powerups.clear()
	
	$"../../UI".new_powerup.connect(add_powerup)


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
	print("-----------------------------------------------------------")


func _apply_powerup_modifiers(powerup: WeaponPowerup):
	# Fire cooldown
	match powerup.fire_cooldown_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.fire_cooldown += powerup.fire_cooldown_modifier_value
		PowerupModifierType.SUBTRACT:
			base_weapon.fire_cooldown -= powerup.fire_cooldown_modifier_value
		PowerupModifierType.MULTIPLY:
			base_weapon.fire_cooldown *= powerup.fire_cooldown_modifier_value
		PowerupModifierType.DIVIDE:
			base_weapon.fire_cooldown /= powerup.fire_cooldown_modifier_value
	
	# Projectile lifetime
	match powerup.projectile_lifetime_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.projectile_lifetime += powerup.projectile_lifetime_modifier_value
		PowerupModifierType.SUBTRACT:
			base_weapon.projectile_lifetime -= powerup.projectile_lifetime_modifier_value
		PowerupModifierType.MULTIPLY:
			base_weapon.projectile_lifetime *= powerup.projectile_lifetime_modifier_value
		PowerupModifierType.DIVIDE:
			base_weapon.projectile_lifetime /= powerup.projectile_lifetime_modifier_value
	
	# Projectile velocity
	match powerup.projectile_velocity_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.projectile_velocity += powerup.projectile_velocity_modifier_value
		PowerupModifierType.SUBTRACT:
			base_weapon.projectile_velocity -= powerup.projectile_velocity_modifier_value
		PowerupModifierType.MULTIPLY:
			base_weapon.projectile_velocity *= powerup.projectile_velocity_modifier_value
		PowerupModifierType.DIVIDE:
			base_weapon.projectile_velocity /= powerup.projectile_velocity_modifier_value
	
	# Range
	match powerup.range_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.weapon_range += powerup.range_modifier_value
		PowerupModifierType.SUBTRACT:
			base_weapon.weapon_range -= powerup.range_modifier_value
		PowerupModifierType.MULTIPLY:
			base_weapon.weapon_range *= powerup.range_modifier_value
		PowerupModifierType.DIVIDE:
			base_weapon.weapon_range /= powerup.range_modifier_value
	
	# Damage
	match powerup.damage_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.current_damage += powerup.damage_modifier_value
		PowerupModifierType.SUBTRACT:
			base_weapon.current_damage -= powerup.damage_modifier_value
		PowerupModifierType.MULTIPLY:
			base_weapon.current_damage *= powerup.damage_modifier_value
		PowerupModifierType.DIVIDE:
			base_weapon.current_damage /= powerup.damage_modifier_value
	
	# Projectiles number
	match powerup.projectiles_number_modifier_type:
		PowerupModifierType.ADD:
			base_weapon.current_projectiles_number += powerup.projectiles_number_modifier_value
		PowerupModifierType.SUBTRACT:
			base_weapon.current_projectiles_number -= powerup.projectiles_number_modifier_value
		#PowerupModifierType.MULTIPLY:
			#base_weapon.current_projectiles_number *= powerup.projectiles_number_modifier_value
		#PowerupModifierType.DIVIDE:
			#base_weapon.current_projectiles_number /= powerup.projectiles_number_modifier_value


