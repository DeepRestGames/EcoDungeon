extends CollisionShape3D


@onready var mesh_instance_3d = $"../DEBUG_range"
@onready var base_weapon = $"../.."



func _ready():
	var radius = base_weapon.weapon_range
	self.shape.radius = radius
	# -- DEBUG ONLY --
	mesh_instance_3d.mesh.inner_radius = radius - 0.2
	mesh_instance_3d.mesh.outer_radius = radius
