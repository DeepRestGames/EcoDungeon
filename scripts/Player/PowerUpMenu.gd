extends PopupMenu


signal new_powerup(powerup)
var powerups_directory = "res://resources/powerups/"
var powerups_to_show: Array
var powerup_resources: Array


func _ready():
	hide()
	_get_powerups_resources_from_folder()


func _get_powerups_resources_from_folder():
	var powerups_file_names = DirAccess.get_files_at(powerups_directory)
	
	for current_powerup_file_name in powerups_file_names:
		var current_powerup = load(powerups_directory + current_powerup_file_name)
		powerup_resources.append(current_powerup)


func show_powerups_options():
	get_tree().paused = true
	_populate_powerups_menu()
	
	show()


func _populate_powerups_menu():
	clear()
	powerups_to_show.clear()
	
	# Pick which powerups to show in the choice menu
	# TODO Make number of powerups to show dynamic - maybe linked to a powerup
	for i in range(0, 3):
		powerups_to_show.append(_choose_next_powerup_to_show(powerups_to_show))
	
	# Populate choice menu with chosen pickups
	for current_powerup in powerups_to_show:
		#add_icon_item(current_powerup.powerup_icon, current_powerup.powerup_name)
		add_icon_item(current_powerup.powerup_icon, current_powerup.powerup_name)


func _choose_next_powerup_to_show(_powerups_to_show: Array):
	var current_powerup = powerup_resources.pick_random() as WeaponPowerup
	
	# Don't show same powerup in same menu, pick again
	if _powerups_to_show.has(current_powerup):
		return _choose_next_powerup_to_show(_powerups_to_show)
	# Picked unique powerup
	return current_powerup


func _on_powerup_menu_index_pressed(index):
	new_powerup.emit(powerups_to_show[index])
	get_tree().paused = false
