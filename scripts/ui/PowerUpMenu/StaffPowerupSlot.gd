extends Control


@onready var focus_highlight_panel = $FocusHighlightPanel
@onready var powerup_icon_texture = $BackgroundPanel/EquippedPowerupTexture
@onready var equipped_powerup_button = $BackgroundPanel/EquippedPowerupButton


func manual_focus():
	equipped_powerup_button.grab_focus()


func _on_equipped_powerup_button_focus_entered():
	focus_highlight_panel.show()


func _on_equipped_powerup_button_focus_exited():
	focus_highlight_panel.hide()
