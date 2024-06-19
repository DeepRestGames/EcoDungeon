extends Area3D

signal enemies_found(enemies: Array)


func sort_by_closest_enemy(enemy_l, enemy_r):
	var enemy_l_distance = global_position.distance_squared_to(enemy_l.global_position)
	var enemy_r_distance = global_position.distance_squared_to(enemy_r.global_position)
	
	# Sort putting closest enemy first
	if enemy_l_distance <= enemy_r_distance:
		return true
	return false

func _physics_process(_delta):
	# Check for enemies
	var enemies_in_range: Array[Node3D] = get_overlapping_bodies()

	if enemies_in_range.size() > 0:
		enemies_in_range.sort_custom(sort_by_closest_enemy)
		enemies_found.emit(enemies_in_range)
