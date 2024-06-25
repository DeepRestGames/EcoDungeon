extends Area3D


const XP_GRANTED: float = 50

func _physics_process(_delta):
	rotate_y(deg_to_rad(3))
	
func _on_body_entered(body):
	#print(body.name)
	if body.name == "Player":
		body.player_experience.current_xp += XP_GRANTED
		queue_free()

func set_values(start_pos: Vector3) -> void:
	global_position = start_pos
	
