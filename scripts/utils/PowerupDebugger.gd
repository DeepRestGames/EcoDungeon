extends Control

@onready var debugger_panel = $DebuggerPanel
@onready var powerup_icon = $DebuggerPanel/PowerupIcon
@onready var powerup_name = $DebuggerPanel/PowerupName
@onready var powerup_description = $DebuggerPanel/PowerupDescription

var powerups_directory = "res://resources/powerups/"
var powerup_resources: Array

var current_powerup: WeaponPowerup:
	get:
		return current_powerup
	set(value):
		current_powerup = value
		powerup_icon.texture = current_powerup.powerup_icon
		powerup_name.text = current_powerup.powerup_name
		powerup_description.text = current_powerup.powerup_description
var current_powerup_index = 0


func _ready():
	_get_powerups_resources_from_folder()
	current_powerup = powerup_resources[current_powerup_index]


func _get_powerups_resources_from_folder():
	var powerups_file_names = DirAccess.get_files_at(powerups_directory)
	
	for current_powerup_file_name in powerups_file_names:
		var current_powerup = load(powerups_directory + current_powerup_file_name)
		powerup_resources.append(current_powerup)


func _on_open_powerup_button_pressed():
	if debugger_panel.is_visible_in_tree():
		debugger_panel.hide()
		get_tree().paused = false
	else:
		debugger_panel.show()
		get_tree().paused = true


func _on_left_button_pressed():
	current_powerup_index -= 1
	current_powerup = powerup_resources[current_powerup_index]


func _on_right_button_pressed():
	current_powerup_index += 1
	current_powerup = powerup_resources[current_powerup_index]


func _on_add_powerup_button_pressed():
	WeaponPowerupSystem.add_powerup($"../../BaseWeapon", current_powerup)
