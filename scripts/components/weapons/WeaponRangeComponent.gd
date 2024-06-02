extends Node3D

@export var radius: float = 5
@onready var collision_shape_3d = $Area3D/CollisionShape3D
@onready var mesh_instance_3d = $MeshInstance3D # DEBUG

func _ready():
	collision_shape_3d.shape.radius = radius
	mesh_instance_3d.mesh.inner_radius = radius - 0.2
	mesh_instance_3d.mesh.outer_radius = radius
