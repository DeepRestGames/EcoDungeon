extends Control


@onready var debugger_panel = $DebuggerPanel


func _on_open_powerup_button_pressed():
	if debugger_panel.is_visible_in_tree():
		debugger_panel.hide()
		get_tree().paused = false
	else:
		debugger_panel.show()
		get_tree().paused = true
