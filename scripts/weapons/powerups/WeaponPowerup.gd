class_name WeaponPowerup


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
