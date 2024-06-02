@tool

extends Node3D

@export var WEAPON_TYPE: WeaponTemplate:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint():
			load_weapon()

@onready var weapon_mesh: MeshInstance3D = %WeaponMesh

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_weapon()


func load_weapon():
	weapon_mesh.mesh = WEAPON_TYPE.mesh
	position = WEAPON_TYPE.position
	rotation_degrees = WEAPON_TYPE.rotation
	
	
