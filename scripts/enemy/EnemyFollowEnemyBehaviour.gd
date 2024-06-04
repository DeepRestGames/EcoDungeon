extends Node3D


@onready var enemy: EnemyBase = $".."
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var target: Node3D = null


func _physics_process(_delta):
	enemy.velocity = Vector3.ZERO
	
	if target != null:
		nav_agent.set_target_position(target.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		enemy.velocity = (next_nav_point - global_transform.origin).normalized() * enemy.SPEED
		enemy.move_and_slide()


func update_target(new_target: Node3D):
	target = new_target


func _on_area_3d_body_entered(body):
	if target == null and body is EnemyBase and body.is_in_group("EnemySingle"):
		update_target(body)


func _on_area_3d_body_exited(body):
	if target != null and body is EnemyBase and body.is_in_group("EnemySingle"):
		update_target(null)
