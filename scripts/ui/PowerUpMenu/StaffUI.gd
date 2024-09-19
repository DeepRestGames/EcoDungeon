extends Node


@onready var staff_texture = $StaffTexture
@onready var staff_powerup_slots = [
	$StaffPowerupsSlotContainer/StaffPowerupSlot, 
	$StaffPowerupsSlotContainer/StaffPowerupSlot2, 
	$StaffPowerupsSlotContainer/StaffPowerupSlot3
]


func manual_focus():
	staff_powerup_slots[0].manual_focus()
