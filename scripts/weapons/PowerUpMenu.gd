extends HBoxContainer

signal new_powerup(powerup)
var powerups_directory = "res://resources/powerups/"
var powerups_to_show: Array
var powerup_resources: Array

signal button_pressed(buttonName)
@export var buttonArray:Array[String]  

@onready var ui = $".."
var power
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
	_populate_powerups_menu()
	
	show()


func _populate_powerups_menu():
	powerups_to_show.clear()
	
	# Pick which powerups to show in the choice menu
	# TODO Make number of powerups to show dynamic - maybe linked to a powerup
	for i in range(0, 3):
		powerups_to_show.append(_choose_next_powerup_to_show(powerups_to_show))
	
	# Populate choice menu with chosen pickups

	for index in powerups_to_show.size():
		_define_button(powerups_to_show[index], index)


func _define_button(current_powerup, index):
	var button: MenuButton = MenuButton.new()  
	
	# Name
	button.text = current_powerup.powerup_name   
	# Background
	button.flat = false
	button.process_mode = Node.PROCESS_MODE_ALWAYS
	# Icon and positioning
	button.icon = current_powerup.powerup_icon
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
	button.expand_icon = true
	button.custom_minimum_size.x = 300 * ui.ui_scale
	button.custom_minimum_size.y = 400 * ui.ui_scale
	
	# Description
	var desc = RichTextLabel.new()
	desc.theme = POWER_UP_THEME
	desc.bbcode_enabled = true
	desc["theme_override_font_sizes/normal_font_size"] = 40 * ui.ui_scale
	desc.text_direction = TEXT_DIRECTION_LTR
	desc.fit_content = true
	desc.text = '"' + current_powerup.powerup_description + '"\n'
	
	# Values
	var vals = RichTextLabel.new()
	vals.theme = POWER_UP_THEME
	vals.bbcode_enabled = true
	vals["theme_override_font_sizes/normal_font_size"] = 36 * ui.ui_scale
	vals.text_direction = TEXT_DIRECTION_LTR
	vals.fit_content = true
	var powerups: Dictionary = current_powerup.get_powerups()
	for key in powerups:
		var value = powerups[key]
		# Brutto ma VA BENE LO STESSOOOO
		if key == "HOMING PROJECTILES":
			if value:
				vals.text +=  "[color=green]" + key + "[/color]"
		else:
			var actual_value = value[0]
			var modifier = value[1]
			if actual_value != 0:
				var str_modifier = "+" if modifier == 0 else "X"
				vals.text +=  ("[color=green]" + key + "[/color]" + ": " + str_modifier + " " + str(actual_value) + "\n")

	desc.clip_contents = false
	desc.custom_minimum_size.y = 10
	desc.layout_mode = 1 # anchors (it-s not exported idk)
	desc.anchors_preset = PRESET_BOTTOM_WIDE 
	desc.position.y = button.size.y + 20 * ui.ui_scale
	desc.grow_vertical = Control.GROW_DIRECTION_END
	
	vals.clip_contents = false
	vals.custom_minimum_size.y = 10
	vals.layout_mode = 1 # anchors (it-s not exported idk)
	vals.anchors_preset = PRESET_BOTTOM_WIDE 
	vals.position.y = desc.position.y + 200 * ui.ui_scale
	vals.grow_vertical = Control.GROW_DIRECTION_END
	
	#var block = ColorRect.new()
	#block.layout_mode = 1
	#block.anchors_preset = PRESET_FULL_RECT
	#block.size.y += 230
	#block.size.x += 20
	#block.position.x -= 10
	#block.z_index = -1
	#block.color = Color(0.204,0.576,0.663,0.5)
	
	add_child(button)
	button.add_child(desc)
	button.add_child(vals)
	
	button.connect("pressed", self._on_powerup_menu_index_pressed.bind(index))
	#button.add_child(block)

func _choose_next_powerup_to_show(_powerups_to_show: Array):
	var current_powerup = powerup_resources.pick_random() as WeaponPowerup
	
	# Don't show same powerup in same menu, pick again
	if _powerups_to_show.has(current_powerup):
		return _choose_next_powerup_to_show(_powerups_to_show)
	# Picked unique powerup
	return current_powerup


func _on_powerup_menu_index_pressed(index):
	new_powerup.emit(powerups_to_show[index])
	hide()
	get_tree().paused = false
	for n in get_children():
		remove_child(n)
		n.queue_free()


# signal button_pressed(buttonName)
# @export var buttonArray:Array[String]  

# func _ready():    
# 	for name in buttonArray:  
# 		var button = Button.new()  
# 		button.text = name    
# 		button.pressed.connect("button_pressed", name)#When pressed, this menu will anounce it along with the button's name
# 		add_child(button)


func _on_menu_button_pressed():
	print("bro...")
	new_powerup.emit(powerups_to_show[0])
	get_tree().paused = false
