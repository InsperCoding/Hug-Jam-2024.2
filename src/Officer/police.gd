extends CharacterBody2D

@export var speed: float = 5
@onready var animation_officer = $Sprite2D/AnimationPlayer

var chase = true
var player_position
var target_position
var player1 = null
@onready var player = get_parent().get_node("Player")
var move_direction : Vector2 = Vector2.ZERO

func _physics_process(delta):
	#if chase:
		#position += (player.position - position) / speed
	player_position = player.position
	target_position = (player_position - position).normalized()
	if not chase:
		velocity = (move_direction * speed)/ delta
		move_and_slide()
	else:
		if position.distance_squared_to(player_position) > 10:
			move_and_collide(target_position * speed)
			animation_officer.play("walk")
			
func new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
#func _on_raio_de_verificação_is_polite_check():
	#if isPolite == false:
		#chase = true


func _on_hitbox_randomize_punishment():
	pass


func _on_raio_de_verificação_body_entered(body):
	player = body
	chase = true



func _on_raio_de_verificação_body_exited(body):
	player = null
	chase = false
