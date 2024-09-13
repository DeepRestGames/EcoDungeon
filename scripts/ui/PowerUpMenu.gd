extends Control

signal is_in_powerup_state(flag)

var powerups_directory = "res://resources/powerups/"
var powerup_resources: Array

var powerups_to_show: Array

@onready var powerup_choices_container = $PowerupChoicesContainer
var powerup_choice_scene = preload("res://scenes/ui/PowerupChoice.tscn")
var powerups_choices_list: Array

signal new_powerup(powerup)

const POWER_UP_THEME = preload("res://scenes/player/PowerUpTheme.tres")
const POWER_UP_THEME_BOLD = preload("res://scenes/player/PowerUpThemeBold.tres")


func _get_powerups_resources_from_folder():
	var powerups_file_names = DirAccess.get_files_at(powerups_directory)
	
	for current_powerup_file_name in powerups_file_names:
		var current_powerup = load(powerups_directory + current_powerup_file_name)
		powerup_resources.append(current_powerup)


func _ready():
	hide()
	_get_powerups_resources_from_folder()


func show_powerups_options():
	get_tree().paused = true
	is_in_powerup_state.emit(true)
	_populate_powerups_menu()
	
	show()


func _populate_powerups_menu():
	powerups_to_show.clear()
	
	# Pick which powerups to show in the choice menu
	# TODO Make number of powerups to show dynamic - maybe linked to a powerup
	for i in range(0, 3):
		var current_powerup = _choose_next_powerup_to_show(powerups_to_show)
		powerups_to_show.append(current_powerup)
		
		# Populate choice menu with chosen pickups
		_instantiate_powerup_choice_button(current_powerup)


func _instantiate_powerup_choice_button(current_powerup: WeaponPowerup):
	var powerup_choice_button = powerup_choice_scene.instantiate()
	powerup_choices_container.add_child(powerup_choice_button)
	powerup_choice_button.initialize(current_powerup, self)
	powerups_choices_list.append(powerup_choice_button)


func _choose_next_powerup_to_show(_powerups_to_show: Array):
	var current_powerup = powerup_resources.pick_random() as WeaponPowerup
	
	# Don't show same powerup in same menu, pick again
	if _powerups_to_show.has(current_powerup):
		return _choose_next_powerup_to_show(_powerups_to_show)
	# Picked unique powerup
	return current_powerup


func on_powerup_button_pressed(chosen_powerup: WeaponPowerup):
	new_powerup.emit(chosen_powerup)
	hide()
	get_tree().paused = false
	is_in_powerup_state.emit(false)
	
	# Clean powerup menu
	for powerup_choice in powerups_choices_list:
		powerup_choice.queue_free()

