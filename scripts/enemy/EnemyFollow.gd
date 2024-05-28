extends EnemyBase


@export var player: Player


func _physics_process(_delta):
	velocity = Vector3.ZERO
	
	if target != null:
		nav_agent.set_target_position(target.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		move_and_slide()


func _on_area_3d_body_entered(body):
	if body is Player:
		update_target(body)


func _on_area_3d_body_exited(body):
	if body is Player:
		update_target(null)
