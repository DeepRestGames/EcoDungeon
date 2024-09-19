extends Control


var current_powerup: WeaponPowerup
@onready var focus_highlight_panel = $FocusHighlightPanel
@onready var powerup_name = $PowerupNameLabel
@onready var powerup_description = $PowerupDescriptionLabel
@onready var powerup_effect = $PowerupEffectLabel
@onready var powerup_effect_value = $PowerupEffectValueLabel
@onready var powerup_icon = $PowerupIconTexture
@onready var powerup_button = $PowerupButton

var powerup_menu

func initialize(powerup_data: WeaponPowerup, powerup_menu_instance):
	powerup_name.text = powerup_data.powerup_name
	powerup_description.text = powerup_data.powerup_description
	powerup_effect.text = "Powerup effect placeholder" + ':'
	powerup_effect_value.text = str(powerup_data.damage_modifier_value)
	powerup_icon.texture = powerup_data.powerup_icon
	
	current_powerup = powerup_data
	powerup_menu = powerup_menu_instance


func manual_focus():
	powerup_button.grab_focus()


func _on_powerup_button_pressed():
	powerup_menu.on_powerup_button_pressed(self, current_powerup)


func _on_powerup_button_focus_entered():
	focus_highlight_panel.show()


func _on_powerup_button_focus_exited():
	focus_highlight_panel.hide()
