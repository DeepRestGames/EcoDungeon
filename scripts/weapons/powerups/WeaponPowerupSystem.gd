extends Node


enum PowerupModifierType {
	ADD,
	MULTIPLY
}


var staffs: Array[BaseWeapon]
var current_weapon: BaseWeapon

var weapon_powerups: Array [WeaponPowerup] = []

signal add_hp(value, type)
signal add_regen(value, type)
signal add_movespeed(value, type)
signal add_pickup_range(value, type)


func _ready():
	weapon_powerups.clear()
	current_weapon = null


func add_staff(staff: BaseWeapon):
	staffs.append(staff)


func add_powerup(weapon: BaseWeapon, powerup: WeaponPowerup):
	current_weapon = weapon

	weapon_powerups.append(powerup)
	
	_apply_powerup_modifiers(powerup)
	
	print("Added new powerup! New stats:\n")
	print("Damage: " + str(current_weapon.current_damage))
	print("Projectile lifetime: " + str(current_weapon.projectile_lifetime))
	print("Projectile velocity: " + str(current_weapon.projectile_velocity))
	print("Range: " + str(current_weapon.weapon_range))
	print("Fire cooldown: " + str(current_weapon.fire_cooldown))
	print("Projectiles number: " + str(current_weapon.current_projectiles_number))
	print("Explosion (range/damage): " + str(current_weapon.explosion_range) + '/'+ str(current_weapon.explosion_damage))
	print("Pierce: " + str(current_weapon.piercing_amount))
	print("DoT (damage/duration/freq): " + str(current_weapon.dot_dmg)  + '/' 
	+ str(current_weapon.dot_duration)  + '/'
	+ str(current_weapon.dot_frequency))
	print("Crit (chance/damage): " + str(current_weapon.crit_chance)  + '/' 
	+ str(current_weapon.crit_damage))
	print("-----------------------------------------------------------")

	current_weapon = null


func _apply_powerup_modifiers(powerup: WeaponPowerup):
	# Fire cooldown
	match powerup.fire_cooldown_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.fire_cooldown += powerup.fire_cooldown_modifier_value
		PowerupModifierType.MULTIPLY:
			current_weapon.fire_cooldown *= powerup.fire_cooldown_modifier_value
	
	# Projectile lifetime
	match powerup.projectile_lifetime_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.projectile_lifetime += powerup.projectile_lifetime_modifier_value
		PowerupModifierType.MULTIPLY:
			current_weapon.projectile_lifetime *= powerup.projectile_lifetime_modifier_value
	
	# Projectile velocity
	match powerup.projectile_velocity_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.projectile_velocity += powerup.projectile_velocity_modifier_value
		PowerupModifierType.MULTIPLY:
			current_weapon.projectile_velocity *= powerup.projectile_velocity_modifier_value
	
	# Range
	match powerup.range_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.weapon_range += powerup.range_modifier_value
		PowerupModifierType.MULTIPLY:
			current_weapon.weapon_range *= powerup.range_modifier_value
	
	# Damage
	match powerup.damage_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.current_damage += powerup.damage_modifier_value
		PowerupModifierType.MULTIPLY:
			current_weapon.current_damage *= powerup.damage_modifier_value
	
	# Projectiles number
	match powerup.projectiles_number_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.current_projectiles_number += powerup.projectiles_number_modifier_value
	# If number of projectiles is updated recalculate projectiles origins
	if powerup.projectiles_number_modifier_value != 0:
		current_weapon.update_projectiles_origins()
	
	# Homing projectiles
	if powerup.homing_projectiles_modifier_value == true:
		current_weapon.homing_projectiles = true
	
	# Explosion range
	match powerup.explosion_radius_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.explosion_range += powerup.explosion_radius_value
		PowerupModifierType.MULTIPLY:
			current_weapon.explosion_range *= powerup.explosion_radius_value
	
	# Explosion damage
	match powerup.explosion_damage_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.explosion_damage += powerup.explosion_damage_value
		PowerupModifierType.MULTIPLY:
			current_weapon.explosion_damage *= powerup.explosion_damage_value
			
	# Pierce value
	match powerup.projectile_pierce_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.piercing_amount += powerup.projectile_pierce_value
		PowerupModifierType.MULTIPLY:
			current_weapon.piercing_amount *= powerup.projectile_pierce_value
			
	# DOT damage
	match powerup.dot_dmg_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.dot_dmg += powerup.dot_dmg_value
		PowerupModifierType.MULTIPLY:
			current_weapon.dot_dmg *= powerup.dot_dmg_value
	
	# DOT duration
	match powerup.dot_time_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.dot_duration += powerup.dot_time_value
		PowerupModifierType.MULTIPLY:
			current_weapon.dot_duration *= powerup.dot_time_value
			
	# DOT frequency
	match powerup.dot_freq_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.dot_frequency += powerup.dot_freq_value
		PowerupModifierType.MULTIPLY:
			current_weapon.dot_frequency *= powerup.dot_freq_value
			
	# CRIT CH
	match powerup.crit_chance_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.crit_chance += powerup.crit_chance_value
		PowerupModifierType.MULTIPLY:
			current_weapon.crit_chance *= powerup.crit_chance_value

	# CRIT DMG
	match powerup.crit_dmg_modifier_type:
		PowerupModifierType.ADD:
			current_weapon.crit_damage += powerup.crit_dmg_value
		PowerupModifierType.MULTIPLY:
			current_weapon.crit_damage *= powerup.crit_dmg_value
			
	# HP
	match powerup.hp_modifier_type:
		PowerupModifierType.ADD:
			add_hp.emit(powerup.hp_value, "+")
		PowerupModifierType.MULTIPLY:
			add_hp.emit(powerup.hp_value, "*")

	# REGEN
	match powerup.hp_regen_modifier_type:
		PowerupModifierType.ADD:
			add_regen.emit(powerup.hp_regen_value, "+")
		PowerupModifierType.MULTIPLY:
			add_regen.emit(powerup.hp_regen_value, "*")
			
	match powerup.move_speed_modifier_type:
		PowerupModifierType.ADD:
			add_movespeed.emit(powerup.move_speed_value, "+")
		PowerupModifierType.MULTIPLY:
			add_movespeed.emit(powerup.move_speed_value, "*")
		
	match powerup.pickup_area_modifier_type:
		PowerupModifierType.ADD:
			add_pickup_range.emit(powerup.pickup_area_value, "+")
		PowerupModifierType.MULTIPLY:
			add_pickup_range.emit(powerup.pickup_area_value, "*")

