class_name WeaponPowerup
extends Node3D


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
