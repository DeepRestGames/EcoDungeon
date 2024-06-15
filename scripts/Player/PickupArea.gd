extends Area3D

var pull_speed: float = 5.0

func _physics_process(delta):
	# Check for loose XP
	var xp_in_range: Array = get_overlapping_areas()
	# If there are
	if xp_in_range.size() > 0:
		for shard in xp_in_range:
			shard.look_at(global_position, Vector3.UP)
			shard.translate(-delta * pull_speed * transform.basis.z)
		
	
