extends Control

signal unpause


func _on_resume_pressed():
	unpause.emit()


func _on_quit_pressed():
	get_tree().quit()
