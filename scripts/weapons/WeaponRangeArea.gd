extends Area3D

signal found_enemies(enemy_pos: Node3D)

func _physics_process(_delta):
	# Check for enemies
	var enemies_in_range: Array[Node3D] = get_overlapping_bodies()
	# If there are
	if enemies_in_range.size() > 0:
		# TODO: specify which one; closest?
		var target_enemy = enemies_in_range.front()
		#var closest_enemy = 
		#look_at(target_enemy.global_position)
		found_enemies.emit(target_enemy)
