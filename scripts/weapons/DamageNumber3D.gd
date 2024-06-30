class_name DamageNumber3D
extends Node3D

@onready var label_3d = $AnimationPlayer/LabelContainer/Label3D
@onready var label_container = $AnimationPlayer/LabelContainer
@onready var animation_player = $AnimationPlayer


func set_values_and_animate(value: String, start_pos: Vector3, height: float, spread: float, color: Color) -> void:
	label_3d.text = value
	
	label_3d.modulate = color
	
	animation_player.play("Rise and Fade")
	global_position = start_pos
	
	var tween = get_tree().create_tween()
	var end_pos = Vector3(randf_range(-spread, spread), height, randf_range(-spread, spread)) + start_pos
	var tween_length = animation_player.get_animation("Rise and Fade").length
	
	tween.tween_property(label_container, "global_position", end_pos, tween_length).from(start_pos)
	
func remove() -> void:
	animation_player.stop()
	if is_inside_tree():
		get_parent().remove_child(self)
