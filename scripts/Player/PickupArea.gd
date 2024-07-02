extends Area3D

var pull_speed: float = 5.0
@onready var pickup_attract_point = $"../PickupAttractPoint"

func _physics_process(delta):
	# Check for loose XP
	var xp_in_range: Array = get_overlapping_areas()
	# If there are
	if xp_in_range.size() > 0:
		for shard in xp_in_range:
			# Get direction unit vector
			var dir_vec = (pickup_attract_point.global_position - shard.global_position).normalized()
			# Move then accelerate shard
			shard.global_translate(delta * shard.pull_speed * dir_vec)
			shard.pull_speed += shard.pull_accell
		
	
