extends Area3D

@onready var pickup_area_collider = $PickupAreaCollider
@onready var player = $"../.."
var pull_speed: float = 5.0

func _physics_process(delta):
	# Check for enemies
	var xp_in_range: Array = get_overlapping_areas()
	# If there are
	if xp_in_range.size() > 0:
		for shard in xp_in_range:
			# TODO: I'm sure there's a fancier/better way to do this
			shard.look_at(player.bullet_origin.global_position, Vector3.UP)
			shard.translate(-delta * pull_speed * transform.basis.z)
			#shard.global_position = shard.global_position - ((shard.global_position - player.global_position) * delta)

