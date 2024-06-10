extends Area3D


const XP_GRANTED: float = 10
#@onready var player_experience = $PlayerExperience

func _physics_process(delta):
	rotate_y(deg_to_rad(3))
	
func _on_body_entered(body):
	#print(body.name)
	if body.name == "Player":
		body.player_experience.current_xp += XP_GRANTED
		queue_free()
