class_name WeaponTemplate extends Resource

@export var name: StringName
@export_category("Weapon Orientation")
@export var position: Vector3
@export var rotation: Vector3
@export var directions: PackedVector3Array
@export_category("Visual Settings")
@export var mesh: Mesh
@export_category("Weapon Statistics")
@export var num_projectiles: int # TODO: useless
@export_range (1,6) var current_level: int
