class_name ProjectileAttributesComponent extends Node3D

@export var lifetime: float = 2.0
@export var base_damage: float = 1.0
@export var round_float_damage: bool = true
@export var bullet_velocity: float = 20
@export var weapon_range: float = 20

var current_damage: float 

func _ready():
	current_damage = base_damage

func apply_scaling():
	pass # TODO: to scale damage of projectiles
