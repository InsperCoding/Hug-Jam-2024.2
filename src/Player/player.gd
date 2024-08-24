extends CharacterBody2D


@onready var globals = get_node("/root/Globals")
const SPEED : int = 300
signal shoot()
signal pickup(body : StaticBody2D)

func handle_inventory() -> void:
	for i in range($Inventory.get_child_count()):
		if i == globals.inventory_idx:
			$Inventory.get_child(i).visible = true
		else:
			$Inventory.get_child(i).visible = false
func get_input():

	# gets input vectors and applies it to the velocity
	var input_direction : Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED
	
	# when presses mouse left, emits signal to shoot
	if Input.is_action_just_pressed("mouseleft"):
		emit_signal("shoot")
	
func _physics_process(delta):
	
	
	handle_inventory()
	get_input()
	move_and_slide()


func _input(event: InputEvent) -> void:
	
	# Pickup items
	if event.is_action_pressed("interact"):
		# checks all bodies in the interaction area
		for body in $InteractionArea.get_overlapping_bodies():
			# if the body is already a child of player, skip
			if body in get_children():
				continue
			if "Item" in body.name:
				emit_signal("pickup", body)
				
				break
			
