extends Area3D

@onready var timer = $Timer


func _on_body_entered(body):
	Engine.time_scale = 0.5
	body.get_node("CollisionShape3D").queue_free()
	timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

