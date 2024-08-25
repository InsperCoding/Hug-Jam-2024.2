extends CanvasLayer

@export var timer : Timer
@onready var timelabel : Label = $Control/TimerContainer/Timer
@onready var player_inventory : Node2D = get_parent().get_node("Player/Inventory")
@onready var inventory_bar : GridContainer = get_node("Control/PanelContainer/InventoryBarMargin/InventoryBarGrid")

var slot_color_inactive : Color = Color("#77777773")
var slot_color_active : Color = Color("#c8c8c873")

@onready var globals = get_node("/root/Globals")

# translate timer to a string of minutes and seconds
func translate_time() -> String:
	var minutes : int = int(timer.time_left / 60)
	var seconds : int = fmod(timer.time_left, 60)

	var output : String 
	if seconds < 10:
		output = "%d:0%d" % [minutes, seconds]
	else:
		output = "%d:%d" % [minutes, seconds]
	return output
	
func set_active_slot() -> void:
	for i in range(inventory_bar.get_child_count()):
		var slot : ColorRect = inventory_bar.get_node("Slot%d" % i)
		if i == globals.inventory_idx:
			slot.color = slot_color_active
		else:
			slot.color = slot_color_inactive
			
	
func set_inventory_idx() -> void:
	if globals.inventory_idx < 0: globals.inventory_idx = globals.INVENTORY_SIZE_MAX
	elif globals.inventory_idx > globals.INVENTORY_SIZE_MAX:  globals.inventory_idx = 0
	
	
# capped at 60fps
func _physics_process(delta):
	timelabel.text = translate_time()
	set_active_slot()
	
	for i in range(player_inventory.get_child_count()):
		var slot : TextureRect = inventory_bar.get_node("Slot%d/Texture" % i)
		slot.texture = player_inventory.get_child(i).get_node("ItemSprite").texture

# not capped, so I used this one to draw fps
func _process(delta: float) -> void:
	$Control/FPSContainer/FPS.text = str(int(1/delta))
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory0"):
		globals.inventory_idx = 0
		set_inventory_idx()
	elif Input.is_action_just_pressed("inventory1"):
		globals.inventory_idx = 1
		set_inventory_idx()
	elif Input.is_action_just_pressed("inventory2"):
		globals.inventory_idx = 2
		set_inventory_idx()
	elif Input.is_action_just_pressed("inventory3"):
		globals.inventory_idx = 3
		set_inventory_idx()
	elif Input.is_action_just_pressed("inventory4"):
		globals.inventory_idx = 4
		set_inventory_idx()
	elif Input.is_action_just_released("scroll_up"):
		globals.inventory_idx -= 1
		set_inventory_idx()
	elif Input.is_action_just_released("scroll_down"):
		globals.inventory_idx += 1
		set_inventory_idx()
	
	
	
		
