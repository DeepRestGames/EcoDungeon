class_name WeaponPowerup


var powerup_dict: Dictionary = {}
@export var powerup_name: String
@export_multiline var powerup_description: String
@export var powerup_icon: Texture2D

@export_group("Fire Cooldown", "fire_cooldown_")
@export var fire_cooldown_modifier_value: float
@export var fire_cooldown_modifier_type: WeaponPowerupSystem.PowerupModifierType


@export_group("Projectile Lifetime", "projectile_lifetime_")
@export var projectile_lifetime_modifier_value: float
@export var projectile_lifetime_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("Projectile Velocity", "projectile_velocity_")
@export var projectile_velocity_modifier_value: float
@export var projectile_velocity_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("Range", "range_")
@export var range_modifier_value: float
@export var range_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("Damage", "damage_")
@export var damage_modifier_value: float
@export var damage_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("Projectiles number", "projectiles_number_")
@export var projectiles_number_modifier_value: int
@export var projectiles_number_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("Homing projectiles", "homing_projectiles_")
@export var homing_projectiles_modifier_value: bool

# --- NEW ---
@export_group("Explosion range", "explosion_radius_")
@export var explosion_radius_value: float
@export var explosion_radius_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("Explosion damage", "explosion_damage_")
@export var explosion_damage_value: float
@export var explosion_damage_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("Piercing", "projectile_pierce_")
@export var projectile_pierce_value: int
@export var projectile_pierce_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("DOT damage", "dot_dmg_")
@export var dot_dmg_value: float
@export var dot_dmg_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("DOT duration", "dot_time_")
@export var dot_time_value: float
@export var dot_time_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("DOT tick frequency", "dot_freq_")
@export var dot_freq_value: float
@export var dot_freq_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("CRIT Chance", "crit_chance_")
@export var crit_chance_value: float
@export var crit_chance_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("CRIT Damage", "crit_dmg_")
@export var crit_dmg_value: float
@export var crit_dmg_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("HP", "hp_")
@export var hp_value: float
@export var hp_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("HP regen", "hp_regen_")
@export var hp_regen_value: float
@export var hp_regen_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("Move speed", "move_speed_")
@export var move_speed_value: float
@export var move_speed_modifier_type: WeaponPowerupSystem.PowerupModifierType

@export_group("Pickup area", "pickup_area_")
@export var pickup_area_value: float
@export var pickup_area_modifier_type: WeaponPowerupSystem.PowerupModifierType

func get_powerups():
	powerup_dict = {
		"ATK SPD": fire_cooldown_modifier_value,
		"PROJ LIFETIME": projectile_lifetime_modifier_value,
		"PROJ SPD": projectile_velocity_modifier_value,
		"RANGE": range_modifier_value,
		"DMG": damage_modifier_value,
		"PROJ NUMBER": projectiles_number_modifier_value,
		"HOMING": homing_projectiles_modifier_value,
		"EXPL RAD": explosion_radius_value,
		"EXPL DMG": explosion_damage_value,
		"PIERCE": projectile_pierce_value ,
		"DOT DMG": dot_dmg_value,
		"DOT DUR": dot_time_value,
		"DOT FREQ": dot_freq_value,
		"CRIT CHANCE": crit_chance_value,
		"CRIT DMG": crit_dmg_value,
		"MAX HP": hp_value,
		"HP REGEN": hp_regen_value,
		"MOVE SPEED": move_speed_value,
		"PICKUP AREA": pickup_area_value,
	}

	return powerup_dict
