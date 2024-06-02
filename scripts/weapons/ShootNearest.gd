extends Node3D

@export var player: Player
@onready var weapon_range_component = $WeaponRangeComponent
var origin: Vector3

func _ready():
	origin = player.global_transform.origin
