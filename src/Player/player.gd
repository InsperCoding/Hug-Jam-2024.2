extends CharacterBody2D


const SPEED : int = 100
signal shoot()

func get_input():

	# gets input vectors and applies it to the velocity
	var input_direction : Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED
	
	# when presses mouse left, emits signal to shoot
	if Input.is_action_just_pressed("mouseleft"):
		emit_signal("shoot")
	
func _physics_process(delta):

	get_input()
	move_and_slide()




