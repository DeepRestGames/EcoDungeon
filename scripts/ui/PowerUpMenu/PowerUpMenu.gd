extends Control

signal is_in_powerup_state(flag)
signal new_powerup(powerup)

# Powerups retrieval
var powerups_directory = "res://resources/powerups/"
var powerup_resources: Array

# Random powerups to show in current screen
var powerups_to_show: Array

# Actual powerup buttons, nodes of the scene
@onready var powerup_choices_container = $PowerupChoicesContainer
var powerup_choice_scene = preload("res://scenes/ui/PowerupChoice.tscn")
var powerups_choices_instances: Array

# Powerup equipment elements
@onready var powerup_equipment_panel_control = $PowerupEquipmentPanelControl

# Powerup reroll elements
@onready var reroll_panel_control = $RerollPanelControl


# Staffs UIs
@onready var staff_ui = $LeftStaffsContainer/StaffUI


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
	_clean_powerup_menu()
	
	# Pick which powerups to show in the choice menu
	# TODO Make number of powerups to show dynamic - maybe linked to a powerup
	for i in range(0, 3):
		var current_powerup = _choose_next_powerup_to_show(powerups_to_show)
		powerups_to_show.append(current_powerup)
		
		# Populate choice menu with chosen pickups
		_instantiate_powerup_choice_button(current_powerup)
	
	powerups_choices_instances[0].manual_focus()


func _instantiate_powerup_choice_button(current_powerup: WeaponPowerup):
	var powerup_choice_button = powerup_choice_scene.instantiate()
	powerup_choices_container.add_child(powerup_choice_button)
	powerup_choice_button.initialize(current_powerup, self)
	powerups_choices_instances.append(powerup_choice_button)


func _choose_next_powerup_to_show(_powerups_to_show: Array):
	var current_powerup = powerup_resources.pick_random() as WeaponPowerup
	
	# Don't show same powerup in same menu, pick again
	if _powerups_to_show.has(current_powerup):
		return _choose_next_powerup_to_show(_powerups_to_show)
	# Picked unique powerup
	return current_powerup


func on_powerup_button_pressed(powerup_button, chosen_powerup: WeaponPowerup):
	powerup_equipment_panel_control.show()
	
	for powerup_choice in powerups_choices_instances:
		powerup_choice.z_index = 0
	powerup_button.z_index = 1
	
	# Highlight staff slots
	staff_ui.manual_focus()
	
	#new_powerup.emit(chosen_powerup)
	#hide()
	#get_tree().paused = false
	#is_in_powerup_state.emit(false)
	#
	#_clean_powerup_menu()


func _clean_powerup_menu():
	for powerup_choice in powerups_choices_instances:
		powerup_choice.queue_free()

	powerups_choices_instances.clear()
	powerups_to_show.clear()


func _on_reroll_powerups_button_pressed():
	reroll_panel_control.show()
	#_clean_powerup_menu()
	#_populate_powerups_menu()