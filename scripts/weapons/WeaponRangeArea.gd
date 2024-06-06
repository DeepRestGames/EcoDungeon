extends Area3D

signal found_enemies(enemy_pos: Node3D)


func closest_enemy(enemies: Array[Node3D]):
	var closest = null
	var closest_distance : float = INF

	for current_enemy in enemies:
		var distance : float = global_position.distance_squared_to(current_enemy.global_position)
		if distance < closest_distance:
			closest = current_enemy
			closest_distance = distance
	return closest

func _physics_process(_delta):
	# Check for enemies
	var enemies_in_range: Array[Node3D] = get_overlapping_bodies()
	# If there are
	if enemies_in_range.size() > 0:
		# TODO: specify which one; closest?
		var target_enemy = closest_enemy(enemies_in_range)
		#var closest_enemy = 
		#look_at(target_enemy.global_position)
		found_enemies.emit(target_enemy)
